Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14A234AE91
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCZS2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:28:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:12659 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhCZS1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:35 -0400
IronPort-SDR: tcPSerMZRIyfr3+GmhrLgpzelTmQUeZEmdVJimwRpX2Q3PLtGWDzTeVr7IUUOd/eogyQwOuhN7
 ccbpDhVzLmvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276342989"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="276342989"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:34 -0700
IronPort-SDR: q2Z2A5R/VTNeGI4xm5ZZ6CxEMMVWRLvri6GXFikZnHKvQrPkwQRu65Xu4oBr3T7q7LZToQM3Nl
 leV64hCGTc+Q==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456545"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/13] mptcp: skip connecting the connected address
Date:   Fri, 26 Mar 2021 11:26:32 -0700
Message-Id: <20210326182642.136419-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
References: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
 <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new helper named lookup_subflow_by_daddr to find
whether the destination address is in the msk's conn_list.

In mptcp_pm_nl_add_addr_received, use lookup_subflow_by_daddr to check
whether the announced address is already connected. If it is, skip
connecting this address and send out the echo.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 53c09db08058..4b4b87803f33 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -140,6 +140,24 @@ static bool lookup_subflow_by_saddr(const struct list_head *list,
 	return false;
 }
 
+static bool lookup_subflow_by_daddr(const struct list_head *list,
+				    struct mptcp_addr_info *daddr)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_addr_info cur;
+	struct sock_common *skc;
+
+	list_for_each_entry(subflow, list, node) {
+		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
+
+		remote_address(skc, &cur);
+		if (addresses_equal(&cur, daddr, daddr->port))
+			return true;
+	}
+
+	return false;
+}
+
 static struct mptcp_pm_addr_entry *
 select_local_address(const struct pm_nl_pernet *pernet,
 		     struct mptcp_sock *msk)
@@ -475,6 +493,10 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	pr_debug("accepted %d:%d remote family %d",
 		 msk->pm.add_addr_accepted, add_addr_accept_max,
 		 msk->pm.remote.family);
+
+	if (lookup_subflow_by_daddr(&msk->conn_list, &msk->pm.remote))
+		goto add_addr_echo;
+
 	msk->pm.add_addr_accepted++;
 	msk->pm.subflows++;
 	if (msk->pm.add_addr_accepted >= add_addr_accept_max ||
@@ -494,6 +516,7 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	__mptcp_subflow_connect(sk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
 
+add_addr_echo:
 	mptcp_pm_announce_addr(msk, &msk->pm.remote, true);
 	mptcp_pm_nl_add_addr_send_ack(msk);
 }
-- 
2.31.0

