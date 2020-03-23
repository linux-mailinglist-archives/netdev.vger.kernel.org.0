Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE0190044
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgCWV3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:60319 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgCWV3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:33 -0400
IronPort-SDR: rlBByOd1r5JIBkXQe8+R0CNWfjyqgWXx6mVDiKxsWvhBrqo2/HvGZzjpV+nSDq4lVhaeXS+/Cx
 X1DQJVULqq1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:32 -0700
IronPort-SDR: xpKJ6r8p8kIY0gPQfclWoYZTaiQya8rtYAYNUW6u/C5Vv+/V9sxRdYaTF3HJLOjr8FB3QV+KpH
 HXuzz6tCYEaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960391"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        eric.dumazet@gmail.com
Subject: [PATCH net-next 00/17] Multipath TCP part 3: Multiple subflows and path management
Date:   Mon, 23 Mar 2020 14:26:25 -0700
Message-Id: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set allows more than one TCP subflow to be established and
used for a multipath TCP connection. Subflows are added to an existing
connection using the MP_JOIN option during the 3-way handshake. With
multiple TCP subflows available, sent data is now stored in the MPTCP
socket so it may be retransmitted on any TCP subflow if there is no
DATA_ACK before a timeout. If an MPTCP-level timeout occurs, data is
retransmitted using an available subflow. Storing this sent data
requires the addition of memory accounting at the MPTCP level, which was
previously delegated to the single subflow. Incoming DATA_ACKs now free
data from the MPTCP-level retransmit buffer.

IP addresses available for new subflow connections can now be advertised
and received with the ADD_ADDR option, and the corresponding REMOVE_ADDR
option likewise advertises that an address is no longer available.

The MPTCP path manager netlink interface has commands to set in-kernel
limits for the number of concurrent subflows and control the
advertisement of IP addresses between peers.

To track and debug MPTCP connections there are new MPTCP MIB counters,
and subflow context can be requested using inet_diag. The MPTCP
self-tests now validate multiple-subflow operation and the netlink path
manager interface.

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-for-5.7-part3-v1)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-for-5.7-part3-v1

Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Davide Caratti (1):
  mptcp: allow dumping subflow context to userspace

Florian Westphal (2):
  mptcp: allow partial cleaning of rtx head dfrag
  mptcp: add and use MIB counter infrastructure

Paolo Abeni (9):
  mptcp: update per unacked sequence on pkt reception
  mptcp: queue data for mptcp level retransmission
  mptcp: introduce MPTCP retransmission timer
  mptcp: implement memory accounting for mptcp rtx queue
  mptcp: rework mptcp_sendmsg_frag to accept optional dfrag
  mptcp: implement and use MPTCP-level retransmission
  mptcp: add netlink-based PM
  selftests: add PM netlink functional tests
  selftests: add test-cases for MPTCP MP_JOIN

Peter Krystad (5):
  mptcp: Add ADD_ADDR handling
  mptcp: Add path manager interface
  mptcp: Add handling of incoming MP_JOIN requests
  mptcp: Add handling of outgoing MP_JOIN requests
  mptcp: Implement path manager interface commands

 MAINTAINERS                                   |   1 +
 include/linux/tcp.h                           |  26 +-
 include/net/mptcp.h                           |  26 +
 include/net/netns/mib.h                       |   3 +
 include/uapi/linux/inet_diag.h                |   1 +
 include/uapi/linux/mptcp.h                    |  88 ++
 net/ipv4/af_inet.c                            |   4 +
 net/ipv4/proc.c                               |   2 +
 net/ipv4/tcp_minisocks.c                      |   6 +
 net/mptcp/Makefile                            |   3 +-
 net/mptcp/crypto.c                            |  17 +-
 net/mptcp/diag.c                              | 104 +++
 net/mptcp/mib.c                               |  69 ++
 net/mptcp/mib.h                               |  40 +
 net/mptcp/options.c                           | 515 ++++++++++-
 net/mptcp/pm.c                                | 242 +++++
 net/mptcp/pm_netlink.c                        | 856 ++++++++++++++++++
 net/mptcp/protocol.c                          | 584 +++++++++++-
 net/mptcp/protocol.h                          | 187 +++-
 net/mptcp/subflow.c                           | 337 ++++++-
 net/mptcp/token.c                             |  27 +
 tools/testing/selftests/net/mptcp/Makefile    |   7 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  28 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 357 ++++++++
 .../testing/selftests/net/mptcp/pm_netlink.sh | 130 +++
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 616 +++++++++++++
 26 files changed, 4153 insertions(+), 123 deletions(-)
 create mode 100644 include/uapi/linux/mptcp.h
 create mode 100644 net/mptcp/diag.c
 create mode 100644 net/mptcp/mib.c
 create mode 100644 net/mptcp/mib.h
 create mode 100644 net/mptcp/pm.c
 create mode 100644 net/mptcp/pm_netlink.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_join.sh
 create mode 100755 tools/testing/selftests/net/mptcp/pm_netlink.sh
 create mode 100644 tools/testing/selftests/net/mptcp/pm_nl_ctl.c


base-commit: 6919a8264a3248dc0d7f945bb42f2c380f76b01e
-- 
2.26.0

