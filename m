Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9273B0D9D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhFVT1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:27:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:32268 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhFVT1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:27:45 -0400
IronPort-SDR: wPcuwl2LdZZj3TY137F0n50Ef4WUWQTxBVfOJAQW3HxZlYYDxLY2UQd7nL3wicfZyR6bLWSCV/
 oyHnfmyTMsUQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="186818192"
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="186818192"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:28 -0700
IronPort-SDR: GJ1zFwKTen67slpEWfukTeg+UiSH4HWJtQ4LNxltWHpybX1HuQljsfjsrny0ytBq3PL0RCN5Li
 v9JoEvxdv3bg==
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="480909712"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.237.182])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:28 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/6] mptcp: Connection-time 'C' flag and two fixes
Date:   Tue, 22 Jun 2021 12:25:17 -0700
Message-Id: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are six more patches from the MPTCP tree.

Most of them add support for the 'C' flag in the MPTCP connection-time
option headers. This flag affects how the initial address and port are
treated by each peer. Normally one peer may send MP_JOIN requests to the
remote address and port that were used when initiating the MPTCP
connection. The 'C' bit indicates that MP_JOINs should only be sent to
remote addresses that have been advertised with ADD_ADDR.

The other two patches are unrelated improvements.

Patches 1-4: Add the 'C' flag feature, a sysctl to optionally enable it,
and a selftest.

Patch 5: Adjust rp_filter settings in a selftest.

Patch 6: Improve rbuf cleanup for MPTCP sockets.


Geliang Tang (4):
  mptcp: add sysctl allow_join_initial_addr_port
  mptcp: add allow_join_id0 in mptcp_out_options
  mptcp: add deny_join_id0 in mptcp_options_received
  selftests: mptcp: add deny_join_id0 testcases

Paolo Abeni (1):
  mptcp: refine mptcp_cleanup_rbuf

Yonglong Li (1):
  selftests: mptcp: turn rp_filter off on each NIC

 Documentation/networking/mptcp-sysctl.rst     | 13 ++++
 include/net/mptcp.h                           |  3 +-
 net/mptcp/ctrl.c                              | 16 ++++
 net/mptcp/options.c                           | 13 ++++
 net/mptcp/pm.c                                |  1 +
 net/mptcp/pm_netlink.c                        |  3 +-
 net/mptcp/protocol.c                          | 56 ++++++--------
 net/mptcp/protocol.h                          | 12 ++-
 net/mptcp/subflow.c                           |  3 +
 .../testing/selftests/net/mptcp/mptcp_join.sh | 75 ++++++++++++++++++-
 .../selftests/net/mptcp/simult_flows.sh       |  3 +-
 11 files changed, 157 insertions(+), 41 deletions(-)


base-commit: a432c771e2d9bc059ffe3028faf040c08b6a9f98
-- 
2.32.0

