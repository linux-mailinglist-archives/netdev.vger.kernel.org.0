Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1942EFC77
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbhAIAwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:52:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:32272 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbhAIAwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:52:23 -0500
IronPort-SDR: yOpmcmIMLMkhziYaAkLXwdGPEfZUinP+xfP8GDneShXnCXoeTzAykP/j3Hl/dbBaUaKE5/1dGa
 Vmsq7Yir6t5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771951"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771951"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: EdJ37iz2eAGr6GSn2qGIo+kJf8TK4o8Mcgm7d4WnalJDH1xcz/4jKrDKdr8pJ3fmrnLpSUZML2
 jK3dZglFKkDw==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124498"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/8] mptcp: add the address ID assignment bitmap
Date:   Fri,  8 Jan 2021 16:47:55 -0800
Message-Id: <20210109004802.341602-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Currently the address ID set by the netlink PM from user-space is
overridden by the kernel. This patch added the address ID assignment
bitmap to allow user-space to set the address ID.

Use a per netns bitmask id_bitmap (256 bits) to keep track of in-use IDs.
And use next_id to keep track of the highest ID currently in use. If the
user-space provides an ID at endpoint creation time, try to use it. If
already in use, endpoint creation fails. Otherwise pick the first ID
available after the highest currently in use, with wrap-around.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 72 +++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a6d983d80576..7fe7be4eef7e 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -36,6 +36,9 @@ struct mptcp_pm_add_entry {
 	u8			retrans_times;
 };
 
+#define MAX_ADDR_ID		255
+#define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
+
 struct pm_nl_pernet {
 	/* protects pernet updates */
 	spinlock_t		lock;
@@ -46,6 +49,7 @@ struct pm_nl_pernet {
 	unsigned int		local_addr_max;
 	unsigned int		subflows_max;
 	unsigned int		next_id;
+	unsigned long		id_bitmap[BITMAP_SZ];
 };
 
 #define MPTCP_PM_ADDR_MAX	8
@@ -524,10 +528,12 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	/* to keep the code simple, don't do IDR-like allocation for address ID,
 	 * just bail when we exceed limits
 	 */
-	if (pernet->next_id > 255)
-		goto out;
+	if (pernet->next_id == MAX_ADDR_ID)
+		pernet->next_id = 1;
 	if (pernet->addrs >= MPTCP_PM_ADDR_MAX)
 		goto out;
+	if (test_bit(entry->addr.id, pernet->id_bitmap))
+		goto out;
 
 	/* do not insert duplicate address, differentiate on port only
 	 * singled addresses
@@ -539,12 +545,30 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 			goto out;
 	}
 
+	if (!entry->addr.id) {
+find_next:
+		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
+						    MAX_ADDR_ID + 1,
+						    pernet->next_id);
+		if ((!entry->addr.id || entry->addr.id > MAX_ADDR_ID) &&
+		    pernet->next_id != 1) {
+			pernet->next_id = 1;
+			goto find_next;
+		}
+	}
+
+	if (!entry->addr.id || entry->addr.id > MAX_ADDR_ID)
+		goto out;
+
+	__set_bit(entry->addr.id, pernet->id_bitmap);
+	if (entry->addr.id > pernet->next_id)
+		pernet->next_id = entry->addr.id;
+
 	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
 		pernet->add_addr_signal_max++;
 	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
 		pernet->local_addr_max++;
 
-	entry->addr.id = pernet->next_id++;
 	pernet->addrs++;
 	list_add_tail_rcu(&entry->list, &pernet->local_addr_list);
 	ret = entry->addr.id;
@@ -597,6 +621,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	entry->addr = skc_local;
 	entry->addr.ifindex = 0;
 	entry->addr.flags = 0;
+	entry->addr.id = 0;
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0)
 		kfree(entry);
@@ -857,6 +882,7 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 
 	pernet->addrs--;
 	list_del_rcu(&entry->list);
+	__clear_bit(entry->addr.id, pernet->id_bitmap);
 	spin_unlock_bh(&pernet->lock);
 
 	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), &entry->addr);
@@ -894,6 +920,8 @@ static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 	spin_lock_bh(&pernet->lock);
 	list_splice_init(&pernet->local_addr_list, &free_list);
 	__reset_counters(pernet);
+	pernet->next_id = 1;
+	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
 	__flush_addrs(sock_net(skb->sk), &free_list);
 	return 0;
@@ -994,27 +1022,34 @@ static int mptcp_nl_cmd_dump_addrs(struct sk_buff *msg,
 	struct pm_nl_pernet *pernet;
 	int id = cb->args[0];
 	void *hdr;
+	int i;
 
 	pernet = net_generic(net, pm_nl_pernet_id);
 
 	spin_lock_bh(&pernet->lock);
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (entry->addr.id <= id)
-			continue;
-
-		hdr = genlmsg_put(msg, NETLINK_CB(cb->skb).portid,
-				  cb->nlh->nlmsg_seq, &mptcp_genl_family,
-				  NLM_F_MULTI, MPTCP_PM_CMD_GET_ADDR);
-		if (!hdr)
-			break;
+	for (i = id; i < MAX_ADDR_ID + 1; i++) {
+		if (test_bit(i, pernet->id_bitmap)) {
+			entry = __lookup_addr_by_id(pernet, i);
+			if (!entry)
+				break;
+
+			if (entry->addr.id <= id)
+				continue;
+
+			hdr = genlmsg_put(msg, NETLINK_CB(cb->skb).portid,
+					  cb->nlh->nlmsg_seq, &mptcp_genl_family,
+					  NLM_F_MULTI, MPTCP_PM_CMD_GET_ADDR);
+			if (!hdr)
+				break;
+
+			if (mptcp_nl_fill_addr(msg, entry) < 0) {
+				genlmsg_cancel(msg, hdr);
+				break;
+			}
 
-		if (mptcp_nl_fill_addr(msg, entry) < 0) {
-			genlmsg_cancel(msg, hdr);
-			break;
+			id = entry->addr.id;
+			genlmsg_end(msg, hdr);
 		}
-
-		id = entry->addr.id;
-		genlmsg_end(msg, hdr);
 	}
 	spin_unlock_bh(&pernet->lock);
 
@@ -1148,6 +1183,7 @@ static int __net_init pm_nl_init_net(struct net *net)
 	INIT_LIST_HEAD_RCU(&pernet->local_addr_list);
 	__reset_counters(pernet);
 	pernet->next_id = 1;
+	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
 	spin_lock_init(&pernet->lock);
 	return 0;
 }
-- 
2.30.0

