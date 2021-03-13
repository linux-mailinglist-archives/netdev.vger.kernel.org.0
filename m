Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F34339AC9
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhCMBQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:35 -0500
Received: from mga17.intel.com ([192.55.52.151]:1169 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: 98Kp+T7KuRVpGrlPOtfZ3zrDJ7z8aqy0ib/Vt56B6bkmgjwgwqKx1zKZO8Jn/D9RV1ZecKpWnf
 p+3oyI66UogA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828248"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828248"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: dhsFyq6fPPp3rviam7UlPdpxESv6+TS82OYTQFIfLcZCfPCJJt4713bfnw5+9yMfOtxsDBYWPy
 vSlejLOCY3Tg==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197377"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/11] mptcp: remove a list of addrs when flushing
Date:   Fri, 12 Mar 2021 17:16:18 -0800
Message-Id: <20210313011621.211661-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch invoked mptcp_nl_remove_addrs_list to remove a list of addresses
when the netlink flushes addresses, instead of using
mptcp_nl_remove_subflow_and_signal_addr to remove them one by one.

And dropped the unused parameter net in __flush_addrs too.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a5f6ab96a1b4..5857b82c88bf 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1248,14 +1248,13 @@ static void mptcp_nl_remove_addrs_list(struct net *net,
 	}
 }
 
-static void __flush_addrs(struct net *net, struct list_head *list)
+static void __flush_addrs(struct list_head *list)
 {
 	while (!list_empty(list)) {
 		struct mptcp_pm_addr_entry *cur;
 
 		cur = list_entry(list->next,
 				 struct mptcp_pm_addr_entry, list);
-		mptcp_nl_remove_subflow_and_signal_addr(net, &cur->addr);
 		list_del_rcu(&cur->list);
 		mptcp_pm_free_addr_entry(cur);
 	}
@@ -1280,7 +1279,8 @@ static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 	pernet->next_id = 1;
 	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
-	__flush_addrs(sock_net(skb->sk), &free_list);
+	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
+	__flush_addrs(&free_list);
 	return 0;
 }
 
@@ -1877,7 +1877,7 @@ static void __net_exit pm_nl_exit_net(struct list_head *net_list)
 		/* net is removed from namespace list, can't race with
 		 * other modifiers
 		 */
-		__flush_addrs(net, &pernet->local_addr_list);
+		__flush_addrs(&pernet->local_addr_list);
 	}
 }
 
-- 
2.30.2

