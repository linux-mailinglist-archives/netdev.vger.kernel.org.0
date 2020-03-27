Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67241960A1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgC0VtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:49:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:25803 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgC0VtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:49:07 -0400
IronPort-SDR: 9Mi7p5xcX577NPtnQreZLSZGdtDPex5uxVRgBJnBBRpM54Bz5Vt6pzvrjlvdxHRaNZvzg9TUtM
 n5mj9gpQON2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:49:07 -0700
IronPort-SDR: /G17EzBS9fX4BLrYrm50vTw2wysmfqXlSMGjFi6joAO1KNb8i+JiBiGUIG0lZxdHG5IU7S4ynD
 bD4FO0Zk9Mww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="271713458"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.7.195])
  by fmsmga004.fm.intel.com with ESMTP; 27 Mar 2020 14:49:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        eric.dumazet@gmail.com
Subject: [PATCH net-next v3 00/17] Multipath TCP part 3: Multiple subflows and path management
Date:   Fri, 27 Mar 2020 14:48:36 -0700
Message-Id: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 -> v3: Remove 'inline' in .c files, fix uapi bit macros, and rebase.

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
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-for-5.7-part3-v3)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-for-5.7-part3-v3

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
 include/uapi/linux/mptcp.h                    |  89 ++
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
 net/mptcp/protocol.c                          | 588 ++++++++++--
 net/mptcp/protocol.h                          | 187 +++-
 net/mptcp/subflow.c                           | 337 ++++++-
 net/mptcp/token.c                             |  27 +
 tools/testing/selftests/net/mptcp/.gitignore  |   1 +
 tools/testing/selftests/net/mptcp/Makefile    |   7 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  28 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 357 ++++++++
 .../testing/selftests/net/mptcp/pm_netlink.sh | 130 +++
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 616 +++++++++++++
 27 files changed, 4158 insertions(+), 125 deletions(-)
 create mode 100644 include/uapi/linux/mptcp.h
 create mode 100644 net/mptcp/diag.c
 create mode 100644 net/mptcp/mib.c
 create mode 100644 net/mptcp/mib.h
 create mode 100644 net/mptcp/pm.c
 create mode 100644 net/mptcp/pm_netlink.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_join.sh
 create mode 100755 tools/testing/selftests/net/mptcp/pm_netlink.sh
 create mode 100644 tools/testing/selftests/net/mptcp/pm_nl_ctl.c


base-commit: 5bb7357f45315138f623d08a615d23dd6ac26cf3
-- 
2.26.0

