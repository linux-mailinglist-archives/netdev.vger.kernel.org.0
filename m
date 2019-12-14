Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065C811F07D
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfLNGEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:24722 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfLNGEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855210"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:32 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 00/15] Multipath TCP part 2: Single subflow
Date:   Fri, 13 Dec 2019 22:04:02 -0800
Message-Id: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches depend on the "Multipath TCP part 1: Prerequisites" patch
set sent earlier.

This set adds MPTCP connection establishment, writing & reading MPTCP
options on data packets, a sysctl to allow MPTCP per-namespace, and self
tests. This is sufficient to establish and maintain a connection with a
MPTCP peer, but will not yet allow or initiate establishment of
additional MPTCP subflows.

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-v1-part2)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-v1-part2

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
 net/mptcp/protocol.c                          | 1160 +++++++++++++++++
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
 25 files changed, 4796 insertions(+), 1 deletion(-)
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

