Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF0DC94E2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfJBXhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbfJBXhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862577"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 00/45] Multipath TCP
Date:   Wed,  2 Oct 2019 16:36:10 -0700
Message-Id: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP upstreaming community has prepared a net-next RFCv2 patch set
for review.

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-rfcv2)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-rfcv2


With CONFIG_MPTCP=y, a socket created with IPPROTO_MPTCP will attempt to
create an MPTCP connection but remains compatible with regular
TCP. IPPROTO_TCP socket behavior is unchanged.

This implementation makes use of ULP between the userspace-facing MPTCP
socket and the set of in-kernel TCP sockets it controls. ULP has been
extended for use with listening sockets. skb_ext is used to carry MPTCP
metadata.

The patch set includes self-tests to exercise MPTCP in various
connection and routing scenarios.


We have more work planned to reach the initial feature set for merging,
notably:

* IPv6

* Comply with MPTCPv1 (RFC6824bis). This patch set supports only
  MPTCPv0 (RFC 6824 / experimental)

* Proper MPTCP-level connection closing with DATA_FIN

* Couple receive windows across sibling subflow TCP sockets as required
  by RFC 6824

* Limit subflow ULP visibility to kernel space

* Simple transmit scheduler that respects subflow 'backup' flags


In order to simplify both code review and the development process, we
propose splitting the patch set in to smaller chunks. The first patch
set for merging would include patches 1 to 31 and basic IPv6 support.

Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Florian Westphal (7):
  mptcp: add mptcp_poll
  mptcp: add basic kselftest for mptcp
  selftests: mptcp: make tc delays random
  selftests: mptcp: extend mptcp_connect tool for ipv6 family
  selftests: mptcp: add accept/getpeer checks
  selftests: mptcp: add ipv6 connectivity
  selftests: mptcp: random ethtool tweaking

Mat Martineau (13):
  tcp: Add MPTCP option number
  net: Make sock protocol value checks more specific
  sock: Make sk_protocol a 16-bit value
  tcp: Define IPPROTO_MPTCP
  mptcp: Add MPTCP socket stubs
  tcp, ulp: Add clone operation to tcp_ulp_ops
  mptcp: Add MPTCP to skb extensions
  tcp: Prevent coalesce/collapse when skb has MPTCP extensions
  tcp: Export low-level TCP functions
  mptcp: Write MPTCP DSS headers to outgoing data packets
  mptcp: Implement MPTCP receive path
  tcp: Check for filled TCP option space before SACK
  mptcp: Make MPTCP socket block/wakeup ignore sk_receive_queue

Matthieu Baerts (1):
  mptcp: new sysctl to control the activation per NS

Paolo Abeni (11):
  tcp: clean ext on tx recycle
  mptcp: use sk_page_frag() in sendmsg
  mptcp: sendmsg() do spool all the provided data
  mptcp: allow collapsing consecutive sendpages on the same substream
  mptcp: harmonize locking on all socket operations.
  mptcp: update per unacked sequence on pkt reception
  mptcp: queue data for mptcp level retransmission
  mptcp: introduce MPTCP retransmission timer
  mptcp: implement memory accounting for mptcp rtx queue
  mptcp: rework mptcp_sendmsg_frag to accept optional dfrag
  mptcp: implement and use MPTCP-level retransmission

Peter Krystad (13):
  mptcp: Handle MPTCP TCP options
  mptcp: Associate MPTCP context with TCP socket
  tcp: Expose tcp struct and routine for MPTCP
  mptcp: Handle MP_CAPABLE options for outgoing connections
  mptcp: Create SUBFLOW socket for incoming connections
  mptcp: Add key generation and token tree
  mptcp: Add shutdown() socket operation
  mptcp: Add setsockopt()/getsockopt() socket operations
  mptcp: Add path manager interface
  mptcp: Add ADD_ADDR handling
  mptcp: Add handling of incoming MP_JOIN requests
  mptcp: Add handling of outgoing MP_JOIN requests
  mptcp: Implement path manager interface commands

 include/linux/skbuff.h                        |   11 +
 include/linux/tcp.h                           |   51 +
 include/net/mptcp.h                           |  149 ++
 include/net/sock.h                            |    6 +-
 include/net/tcp.h                             |   20 +
 include/trace/events/sock.h                   |    5 +-
 include/uapi/linux/in.h                       |    2 +
 net/Kconfig                                   |    1 +
 net/Makefile                                  |    1 +
 net/ax25/af_ax25.c                            |    2 +-
 net/core/skbuff.c                             |    7 +
 net/decnet/af_decnet.c                        |    2 +-
 net/ipv4/inet_connection_sock.c               |    2 +
 net/ipv4/tcp.c                                |    8 +-
 net/ipv4/tcp_input.c                          |   29 +-
 net/ipv4/tcp_ipv4.c                           |    4 +-
 net/ipv4/tcp_minisocks.c                      |    6 +
 net/ipv4/tcp_output.c                         |   62 +-
 net/ipv4/tcp_ulp.c                            |   12 +
 net/mptcp/Kconfig                             |   11 +
 net/mptcp/Makefile                            |    4 +
 net/mptcp/crypto.c                            |  128 ++
 net/mptcp/ctrl.c                              |  112 ++
 net/mptcp/options.c                           |  753 +++++++++
 net/mptcp/pm.c                                |  181 ++
 net/mptcp/protocol.c                          | 1455 +++++++++++++++++
 net/mptcp/protocol.h                          |  319 ++++
 net/mptcp/subflow.c                           |  537 ++++++
 net/mptcp/token.c                             |  217 +++
 tools/include/uapi/linux/in.h                 |    2 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/net/mptcp/.gitignore  |    2 +
 tools/testing/selftests/net/mptcp/Makefile    |   11 +
 tools/testing/selftests/net/mptcp/config      |    1 +
 .../selftests/net/mptcp/mptcp_connect.c       |  522 ++++++
 .../selftests/net/mptcp/mptcp_connect.sh      |  401 +++++
 36 files changed, 5021 insertions(+), 16 deletions(-)
 create mode 100644 include/net/mptcp.h
 create mode 100644 net/mptcp/Kconfig
 create mode 100644 net/mptcp/Makefile
 create mode 100644 net/mptcp/crypto.c
 create mode 100644 net/mptcp/ctrl.c
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
2.23.0

