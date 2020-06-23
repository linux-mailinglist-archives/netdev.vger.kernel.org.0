Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DB82062DC
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393096AbgFWVIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:08:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36095 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391555AbgFWUef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:35 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYRrn019522;
        Tue, 23 Jun 2020 13:34:33 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 01/12] cxgb4: move handling L2T ARP failures to caller
Date:   Wed, 24 Jun 2020 01:51:31 +0530
Message-Id: <4d48b93157af9ea59ab2612e3f315ac220694cd9.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move code handling L2T ARP failures to the only caller.

Fixes following sparse warning:
skbuff.h:2091:29: warning: context imbalance in
'handle_failed_resolution' - unexpected unlock

Fixes: 749cb5fe48bb ("cxgb4: Replace arpq_head/arpq_tail with SKB double link-list code")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/l2t.c | 52 +++++++++++-------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 72b37a66c7d8..0ed20a9cca14 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -502,41 +502,20 @@ u64 cxgb4_select_ntuple(struct net_device *dev,
 }
 EXPORT_SYMBOL(cxgb4_select_ntuple);
 
-/*
- * Called when address resolution fails for an L2T entry to handle packets
- * on the arpq head.  If a packet specifies a failure handler it is invoked,
- * otherwise the packet is sent to the device.
- */
-static void handle_failed_resolution(struct adapter *adap, struct l2t_entry *e)
-{
-	struct sk_buff *skb;
-
-	while ((skb = __skb_dequeue(&e->arpq)) != NULL) {
-		const struct l2t_skb_cb *cb = L2T_SKB_CB(skb);
-
-		spin_unlock(&e->lock);
-		if (cb->arp_err_handler)
-			cb->arp_err_handler(cb->handle, skb);
-		else
-			t4_ofld_send(adap, skb);
-		spin_lock(&e->lock);
-	}
-}
-
 /*
  * Called when the host's neighbor layer makes a change to some entry that is
  * loaded into the HW L2 table.
  */
 void t4_l2t_update(struct adapter *adap, struct neighbour *neigh)
 {
-	struct l2t_entry *e;
-	struct sk_buff_head *arpq = NULL;
-	struct l2t_data *d = adap->l2t;
 	unsigned int addr_len = neigh->tbl->key_len;
 	u32 *addr = (u32 *) neigh->primary_key;
-	int ifidx = neigh->dev->ifindex;
-	int hash = addr_hash(d, addr, addr_len, ifidx);
+	int hash, ifidx = neigh->dev->ifindex;
+	struct sk_buff_head *arpq = NULL;
+	struct l2t_data *d = adap->l2t;
+	struct l2t_entry *e;
 
+	hash = addr_hash(d, addr, addr_len, ifidx);
 	read_lock_bh(&d->lock);
 	for (e = d->l2tab[hash].first; e; e = e->next)
 		if (!addreq(e, addr) && e->ifindex == ifidx) {
@@ -569,8 +548,25 @@ void t4_l2t_update(struct adapter *adap, struct neighbour *neigh)
 			write_l2e(adap, e, 0);
 	}
 
-	if (arpq)
-		handle_failed_resolution(adap, e);
+	if (arpq) {
+		struct sk_buff *skb;
+
+		/* Called when address resolution fails for an L2T
+		 * entry to handle packets on the arpq head. If a
+		 * packet specifies a failure handler it is invoked,
+		 * otherwise the packet is sent to the device.
+		 */
+		while ((skb = __skb_dequeue(&e->arpq)) != NULL) {
+			const struct l2t_skb_cb *cb = L2T_SKB_CB(skb);
+
+			spin_unlock(&e->lock);
+			if (cb->arp_err_handler)
+				cb->arp_err_handler(cb->handle, skb);
+			else
+				t4_ofld_send(adap, skb);
+			spin_lock(&e->lock);
+		}
+	}
 	spin_unlock_bh(&e->lock);
 }
 
-- 
2.24.0

