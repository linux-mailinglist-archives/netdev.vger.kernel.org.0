Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5CD49595
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfFQW6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbfFQW6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:49 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 00/33] Multipath TCP
Date:   Mon, 17 Jun 2019 15:57:35 -0700
Message-Id: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP upstreaming community has prepared a net-next RFC patch set
for review.

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-rfc)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-rfc

With CONFIG_MPTCP=y, a socket created with IPPROTO_MPTCP will attempt to
create an MPTCP connection but remains compatible with regular
TCP. IPPROTO_TCP socket behavior is unchanged.

This implementation makes use of ULP between the userspace-facing MPTCP
socket and the set of in-kernel TCP sockets it controls. ULP has been
extended for use with listening sockets. skb_ext is used to carry MPTCP
metadata.

The patch set includes a self-test to exercise MPTCP in various
connection and routing scenarios.

We have more work to do to reach the initial feature set for merging,
notably:

* Finish MP_JOIN work

* Couple receive windows across sibling subflow TCP sockets as required
  by RFC 6824

* IPv6

* Limit subflow ULP visibility to kernel space

Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Florian Westphal (6):
  mptcp: add mptcp_poll
  mptcp: add and use mptcp_subflow_hold
  mptcp: add basic kselftest program
  mptcp: selftests: switch to netns+veth based tests
  mptcp: accept: don't leak mptcp socket structure
  mptcp: switch sublist to mptcp socket lock protection

Mat Martineau (11):
  tcp: Add MPTCP option number
  tcp: Define IPPROTO_MPTCP
  mptcp: Add MPTCP socket stubs
  tcp, ulp: Add clone operation to tcp_ulp_ops
  mptcp: Add MPTCP to skb extensions
  tcp: Prevent coalesce/collapse when skb has MPTCP extensions
  tcp: Export low-level TCP functions
  mptcp: Write MPTCP DSS headers to outgoing data packets
  mptcp: Implement MPTCP receive path
  mptcp: selftests: Add capture option
  tcp: Check for filled TCP option space before SACK

Paolo Abeni (4):
  tcp: clean ext on tx recycle
  mptcp: use sk_page_frag() in sendmsg
  mptcp: sendmsg() do spool all the provided data
  mptcp: allow collapsing consecutive sendpages on the same substream

Peter Krystad (12):
  mptcp: Handle MPTCP TCP options
  mptcp: Associate MPTCP context with TCP socket
  tcp: Expose tcp struct and routine for MPTCP
  mptcp: Handle MP_CAPABLE options for outgoing connections
  mptcp: Create SUBFLOW socket for incoming connections
  mptcp: Add key generation and token tree
  mptcp: Add shutdown() socket operation
  mptcp: Add setsockopt()/getsockopt() socket operations
  mptcp: Make connection_list a real list of subflows
  mptcp: Add path manager interface
  mptcp: Add ADD_ADDR handling
  mptcp: Add handling of incoming MP_JOIN requests

 include/linux/skbuff.h                        |   11 +
 include/linux/tcp.h                           |   51 +
 include/net/mptcp.h                           |  158 +++
 include/net/sock.h                            |    1 +
 include/net/tcp.h                             |   20 +
 include/uapi/linux/in.h                       |    2 +
 net/Kconfig                                   |    1 +
 net/Makefile                                  |    1 +
 net/core/skbuff.c                             |    7 +
 net/ipv4/inet_connection_sock.c               |    2 +
 net/ipv4/tcp.c                                |    8 +-
 net/ipv4/tcp_input.c                          |   25 +-
 net/ipv4/tcp_ipv4.c                           |    4 +-
 net/ipv4/tcp_minisocks.c                      |    6 +
 net/ipv4/tcp_output.c                         |   62 +-
 net/ipv4/tcp_ulp.c                            |   12 +
 net/mptcp/Kconfig                             |   11 +
 net/mptcp/Makefile                            |    4 +
 net/mptcp/crypto.c                            |  206 ++++
 net/mptcp/options.c                           |  621 ++++++++++
 net/mptcp/pm.c                                |   66 ++
 net/mptcp/protocol.c                          | 1043 +++++++++++++++++
 net/mptcp/protocol.h                          |  229 ++++
 net/mptcp/subflow.c                           |  344 ++++++
 net/mptcp/token.c                             |  373 ++++++
 tools/include/uapi/linux/in.h                 |    2 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/net/mptcp/.gitignore  |    1 +
 tools/testing/selftests/net/mptcp/Makefile    |   11 +
 tools/testing/selftests/net/mptcp/config      |    1 +
 .../selftests/net/mptcp/mptcp_connect.c       |  408 +++++++
 .../selftests/net/mptcp/mptcp_connect.sh      |  271 +++++
 32 files changed, 3955 insertions(+), 8 deletions(-)
 create mode 100644 include/net/mptcp.h
 create mode 100644 net/mptcp/Kconfig
 create mode 100644 net/mptcp/Makefile
 create mode 100644 net/mptcp/crypto.c
 create mode 100644 net/mptcp/options.c
 create mode 100644 net/mptcp/pm.c
 create mode 100644 net/mptcp/protocol.c
 create mode 100644 net/mptcp/protocol.h
 create mode 100644 net/mptcp/subflow.c
 create mode 100644 net/mptcp/token.c
 create mode 100644 tools/testing/selftests/net/mptcp/.gitignore
 create mode 100644 tools/testing/selftests/net/mptcp/Makefile
 create mode 100644 tools/testing/selftests/net/mptcp/config
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_connect.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect.sh

-- 
2.22.0

