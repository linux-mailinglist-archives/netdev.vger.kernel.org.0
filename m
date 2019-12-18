Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2C125258
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfLRTzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:2222 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfLRTzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019936"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:12 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 00/15] Multipath TCP part 2: Single subflow
Date:   Wed, 18 Dec 2019 11:54:55 -0800
Message-Id: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series


This set adds MPTCP connection establishment, writing & reading MPTCP
options on data packets, a sysctl to allow MPTCP per-namespace, and self
tests. This is sufficient to establish and maintain a connection with a
MPTCP peer, but will not yet allow or initiate establishment of
additional MPTCP subflows.

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-v2-part2)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-v2-part2

Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Florian Westphal (2):
  mptcp: add subflow write space signalling and mptcp_poll
  mptcp: add basic kselftest for mptcp

Mat Martineau (3):
  mptcp: Add MPTCP socket stubs
  mptcp: Write MPTCP DSS headers to outgoing data packets
  mptcp: Implement MPTCP receive path

Matthieu Baerts (1):
  mptcp: new sysctl to control the activation per NS

Paolo Abeni (2):
  mptcp: recvmsg() can drain data from multiple subflows
  mptcp: allow collapsing consecutive sendpages on the same substream

Peter Krystad (7):
  mptcp: Handle MPTCP TCP options
  mptcp: Associate MPTCP context with TCP socket
  mptcp: Handle MP_CAPABLE options for outgoing connections
  mptcp: Create SUBFLOW socket for incoming connections
  mptcp: Add key generation and token tree
  mptcp: Add shutdown() socket operation
  mptcp: Add setsockopt()/getsockopt() socket operations

 MAINTAINERS                                   |    2 +
 include/linux/tcp.h                           |   34 +
 include/net/mptcp.h                           |   98 ++
 net/Kconfig                                   |    1 +
 net/Makefile                                  |    1 +
 net/ipv4/tcp.c                                |    2 +
 net/ipv4/tcp_input.c                          |   19 +-
 net/ipv4/tcp_output.c                         |   57 +
 net/ipv6/tcp_ipv6.c                           |    7 +
 net/mptcp/Kconfig                             |   16 +
 net/mptcp/Makefile                            |    4 +
 net/mptcp/crypto.c                            |  122 ++
 net/mptcp/ctrl.c                              |  130 ++
 net/mptcp/options.c                           |  520 ++++++++
 net/mptcp/protocol.c                          | 1159 +++++++++++++++++
 net/mptcp/protocol.h                          |  220 ++++
 net/mptcp/subflow.c                           |  763 +++++++++++
 net/mptcp/token.c                             |  195 +++
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/net/mptcp/.gitignore  |    2 +
 tools/testing/selftests/net/mptcp/Makefile    |   13 +
 tools/testing/selftests/net/mptcp/config      |    2 +
 .../selftests/net/mptcp/mptcp_connect.c       |  832 ++++++++++++
 .../selftests/net/mptcp/mptcp_connect.sh      |  595 +++++++++
 tools/testing/selftests/net/mptcp/settings    |    1 +
 25 files changed, 4795 insertions(+), 1 deletion(-)
 create mode 100644 net/mptcp/Kconfig
 create mode 100644 net/mptcp/Makefile
 create mode 100644 net/mptcp/crypto.c
 create mode 100644 net/mptcp/ctrl.c
 create mode 100644 net/mptcp/options.c
 create mode 100644 net/mptcp/protocol.c
 create mode 100644 net/mptcp/protocol.h
 create mode 100644 net/mptcp/subflow.c
 create mode 100644 net/mptcp/token.c
 create mode 100644 tools/testing/selftests/net/mptcp/.gitignore
 create mode 100644 tools/testing/selftests/net/mptcp/Makefile
 create mode 100644 tools/testing/selftests/net/mptcp/config
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_connect.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect.sh
 create mode 100644 tools/testing/selftests/net/mptcp/settings

-- 
2.24.1

