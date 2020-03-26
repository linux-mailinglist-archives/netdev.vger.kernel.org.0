Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1F19496E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgCZUq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:46:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:47899 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbgCZUq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:46:59 -0400
IronPort-SDR: Frikn/zJUR4BiVKT03hAxjdEGi1i4Xaf3151cC/A9vFRMQZ76b9yzjSEYdg5H0XenT5usSDakT
 62BSFaNDYXKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 13:46:58 -0700
IronPort-SDR: MJ9ew+Rd7pj6zskM9j7r1jKGeOl6I8SYP3b5wAzInh0w2icw9wnvM1qvyIKyM5PD7bPOSAhVQA
 54UsUkkx7jKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="238911658"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.252.133.119])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2020 13:46:58 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        eric.dumazet@gmail.com
Subject: [PATCH net-next v2 00/17] Multipath TCP part 3: Multiple subflows and path management
Date:   Thu, 26 Mar 2020 13:46:23 -0700
Message-Id: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2: Rebase on current net-next, fix for netlink limit setting,
and update .gitignore for selftest.

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
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-for-5.7-part3-v2)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-for-5.7-part3-v2

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
 net/mptcp/pm_netlink.c                        | 857 ++++++++++++++++++
 net/mptcp/protocol.c                          | 584 +++++++++++-
 net/mptcp/protocol.h                          | 187 +++-
 net/mptcp/subflow.c                           | 337 ++++++-
 net/mptcp/token.c                             |  27 +
 tools/testing/selftests/net/mptcp/.gitignore  |   1 +
 tools/testing/selftests/net/mptcp/Makefile    |   7 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  28 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 357 ++++++++
 .../testing/selftests/net/mptcp/pm_netlink.sh | 130 +++
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 616 +++++++++++++
 27 files changed, 4155 insertions(+), 123 deletions(-)
 create mode 100644 include/uapi/linux/mptcp.h
 create mode 100644 net/mptcp/diag.c
 create mode 100644 net/mptcp/mib.c
 create mode 100644 net/mptcp/mib.h
 create mode 100644 net/mptcp/pm.c
 create mode 100644 net/mptcp/pm_netlink.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_join.sh
 create mode 100755 tools/testing/selftests/net/mptcp/pm_netlink.sh
 create mode 100644 tools/testing/selftests/net/mptcp/pm_nl_ctl.c


base-commit: 14340219b89c98d96170721d38378252db206e69
-- 
2.26.0

