Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3688A339AC8
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhCMBQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232255AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: +pfp6ItEzVFkNLGg7FrkQsZ460McuIhSFX0D5hrIz2Zj7EhTjOnf2KvlvHsh3CuLbYFcTCe1Ak
 60+ijAuGEM0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828247"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828247"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: u9B20i3aBRU4OU0+WgvYImorFQD3lOtBEJ4KHXhQ1I1UMm7xgCu/x/0j2Uu0KWoDbNvzh5bO98
 VZWByTgXIIMw==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197376"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/11] mptcp: remove multi addresses and subflows in PM
Date:   Fri, 12 Mar 2021 17:16:17 -0800
Message-Id: <20210313011621.211661-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch implemented the function to remove a list of addresses and
subflows, named mptcp_nl_remove_addrs_list, which had a input parameter
rm_list as the removing addresses list.

In mptcp_nl_remove_addrs_list, traverse all the existing msk sockets to
invoke mptcp_pm_remove_addrs_and_subflows to remove a list of addresses
for each msk socket.

In mptcp_pm_remove_addrs_and_subflows, traverse all the addresses in the
removing addresses list, to find whether this address is in the conn_list
or anno_list. If it is, put the address ID into the removing address list
or the removing subflow list, and pass the two lists to
mptcp_pm_remove_addr and mptcp_pm_remove_subflow.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 769a05d836da..a5f6ab96a1b4 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1200,6 +1200,54 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+static void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
+					       struct list_head *rm_list)
+{
+	struct mptcp_rm_list alist = { .nr = 0 }, slist = { .nr = 0 };
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, rm_list, list) {
+		if (lookup_subflow_by_saddr(&msk->conn_list, &entry->addr) &&
+		    alist.nr < MPTCP_RM_IDS_MAX &&
+		    slist.nr < MPTCP_RM_IDS_MAX) {
+			alist.ids[alist.nr++] = entry->addr.id;
+			slist.ids[slist.nr++] = entry->addr.id;
+		} else if (remove_anno_list_by_saddr(msk, &entry->addr) &&
+			 alist.nr < MPTCP_RM_IDS_MAX) {
+			alist.ids[alist.nr++] = entry->addr.id;
+		}
+	}
+
+	if (alist.nr) {
+		spin_lock_bh(&msk->pm.lock);
+		mptcp_pm_remove_addr(msk, &alist);
+		spin_unlock_bh(&msk->pm.lock);
+	}
+	if (slist.nr)
+		mptcp_pm_remove_subflow(msk, &slist);
+}
+
+static void mptcp_nl_remove_addrs_list(struct net *net,
+				       struct list_head *rm_list)
+{
+	long s_slot = 0, s_num = 0;
+	struct mptcp_sock *msk;
+
+	if (list_empty(rm_list))
+		return;
+
+	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
+		struct sock *sk = (struct sock *)msk;
+
+		lock_sock(sk);
+		mptcp_pm_remove_addrs_and_subflows(msk, rm_list);
+		release_sock(sk);
+
+		sock_put(sk);
+		cond_resched();
+	}
+}
+
 static void __flush_addrs(struct net *net, struct list_head *list)
 {
 	while (!list_empty(list)) {
-- 
2.30.2

