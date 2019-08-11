Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814F289041
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 09:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHKHv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 03:51:29 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53549 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbfHKHv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 03:51:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 00E0020BA1;
        Sun, 11 Aug 2019 03:51:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Aug 2019 03:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ctqK/Sary1SgUxE2r
        WfVRidxMLhXESYfaGpSAhLiV6A=; b=HyfQk2P/lSDuzjVeO7XHdjNhUr29UIV2O
        PBbvRoeJsE/8pUmV3Hf/y6E6HZS9qMaj9ddsWxk8totfCYc/2NVLv9YRRQ1K+l9a
        lOii32OTrS0oZXDJCprkUby+LuXfv/SUovIKMTIg2aF6DL+GfoLXJIJ6Uz7tjUZ+
        T2jneXosipJzbSRCTYduLE1NZI4J2jAN5/ReQ2X1EDg7oF3kYkyMOdewq8Ojskh0
        /oLwPXCW/YdmhsHodlaqhi22cnWf13hbzG+/jODATuU7llXxg4ZIcHfIi2QINlVb
        7nhut9qRBzbJuyoVn0RXshuimCECTvx4OdKFSgpNRUcbniCdbgKOQ==
X-ME-Sender: <xms:_shPXQGuqZmkL4PPntDylw_afIE_kEDxEP673M4qFUOP--s_IdH-nA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:_shPXbLnKCx7QhDweT5oPMN9bAvFB__1eOjcigapkDmZJFEIBxhZTw>
    <xmx:_shPXb68ESA2akXQVh-HputdUXCSgKLBCNa7ENOPBj6jjvWTkAzUjA>
    <xmx:_shPXTTbaSLq6de0aT64UnEC2Qpj_jkaI6Mgv446ax3NlP-NNQvyaA>
    <xmx:_shPXbzRwtTlik3duUdYDbV31B3d-5SXANdPddAh3kJEMpYg_gTTBA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C46F80059;
        Sun, 11 Aug 2019 03:51:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        richardcochran@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_ptp: Keep unmatched entries in a linked list
Date:   Sun, 11 Aug 2019 10:48:37 +0300
Message-Id: <20190811074837.28216-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

To identify timestamps for matching with their packets, Spectrum-1 uses a
five-tuple of (port, direction, domain number, message type, sequence ID).
If there are several clients from the same domain behind a single port
sending Delay_Req's, the only thing differentiating these packets, as far
as Spectrum-1 is concerned, is the sequence ID. Should sequence IDs between
individual clients be similar, conflicts may arise. That is not a problem
to hardware, which will simply deliver timestamps on a first comes, first
served basis.

However the driver uses a simple hash table to store the unmatched pieces.
When a new conflicting piece arrives, it pushes out the previously stored
one, which if it is a packet, is delivered without timestamp. Later on as
the corresponding timestamps arrive, the first one is mismatched to the
second packet, and the second one is never matched and eventually is GCd.

To correct this issue, instead of using a simple rhashtable, use rhltable
to keep the unmatched entries.

Previously, a found unmatched entry would always be removed from the hash
table. That is not the case anymore--an incompatible entry is left in the
hash table. Therefore removal from the hash table cannot be used to confirm
the validity of the looked-up pointer, instead the lookup would simply need
to be redone. Therefore move it inside the critical section. This
simplifies a lot of the code.

Fixes: 8748642751ed ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
Reported-by: Alex Veber <alexve@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 138 +++++++-----------
 1 file changed, 55 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 63b07edd9d81..38bb1cfe4e8c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -29,7 +29,7 @@
 
 struct mlxsw_sp_ptp_state {
 	struct mlxsw_sp *mlxsw_sp;
-	struct rhashtable unmatched_ht;
+	struct rhltable unmatched_ht;
 	spinlock_t unmatched_lock; /* protects the HT */
 	struct delayed_work ht_gc_dw;
 	u32 gc_cycle;
@@ -45,7 +45,7 @@ struct mlxsw_sp1_ptp_key {
 
 struct mlxsw_sp1_ptp_unmatched {
 	struct mlxsw_sp1_ptp_key key;
-	struct rhash_head ht_node;
+	struct rhlist_head ht_node;
 	struct rcu_head rcu;
 	struct sk_buff *skb;
 	u64 timestamp;
@@ -359,7 +359,7 @@ static int mlxsw_sp_ptp_parse(struct sk_buff *skb,
 /* Returns NULL on successful insertion, a pointer on conflict, or an ERR_PTR on
  * error.
  */
-static struct mlxsw_sp1_ptp_unmatched *
+static int
 mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
 			     struct mlxsw_sp1_ptp_key key,
 			     struct sk_buff *skb,
@@ -368,41 +368,51 @@ mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
 	int cycles = MLXSW_SP1_PTP_HT_GC_TIMEOUT / MLXSW_SP1_PTP_HT_GC_INTERVAL;
 	struct mlxsw_sp_ptp_state *ptp_state = mlxsw_sp->ptp_state;
 	struct mlxsw_sp1_ptp_unmatched *unmatched;
-	struct mlxsw_sp1_ptp_unmatched *conflict;
+	int err;
 
 	unmatched = kzalloc(sizeof(*unmatched), GFP_ATOMIC);
 	if (!unmatched)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	unmatched->key = key;
 	unmatched->skb = skb;
 	unmatched->timestamp = timestamp;
 	unmatched->gc_cycle = mlxsw_sp->ptp_state->gc_cycle + cycles;
 
-	conflict = rhashtable_lookup_get_insert_fast(&ptp_state->unmatched_ht,
-					    &unmatched->ht_node,
-					    mlxsw_sp1_ptp_unmatched_ht_params);
-	if (conflict)
+	err = rhltable_insert(&ptp_state->unmatched_ht, &unmatched->ht_node,
+			      mlxsw_sp1_ptp_unmatched_ht_params);
+	if (err)
 		kfree(unmatched);
 
-	return conflict;
+	return err;
 }
 
 static struct mlxsw_sp1_ptp_unmatched *
 mlxsw_sp1_ptp_unmatched_lookup(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp1_ptp_key key)
+			       struct mlxsw_sp1_ptp_key key, int *p_length)
 {
-	return rhashtable_lookup(&mlxsw_sp->ptp_state->unmatched_ht, &key,
-				 mlxsw_sp1_ptp_unmatched_ht_params);
+	struct mlxsw_sp1_ptp_unmatched *unmatched, *last = NULL;
+	struct rhlist_head *tmp, *list;
+	int length = 0;
+
+	list = rhltable_lookup(&mlxsw_sp->ptp_state->unmatched_ht, &key,
+			       mlxsw_sp1_ptp_unmatched_ht_params);
+	rhl_for_each_entry_rcu(unmatched, tmp, list, ht_node) {
+		last = unmatched;
+		length++;
+	}
+
+	*p_length = length;
+	return last;
 }
 
 static int
 mlxsw_sp1_ptp_unmatched_remove(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp1_ptp_unmatched *unmatched)
 {
-	return rhashtable_remove_fast(&mlxsw_sp->ptp_state->unmatched_ht,
-				      &unmatched->ht_node,
-				      mlxsw_sp1_ptp_unmatched_ht_params);
+	return rhltable_remove(&mlxsw_sp->ptp_state->unmatched_ht,
+			       &unmatched->ht_node,
+			       mlxsw_sp1_ptp_unmatched_ht_params);
 }
 
 /* This function is called in the following scenarios:
@@ -489,75 +499,38 @@ static void mlxsw_sp1_ptp_got_piece(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp1_ptp_key key,
 				    struct sk_buff *skb, u64 timestamp)
 {
-	struct mlxsw_sp1_ptp_unmatched *unmatched, *conflict;
+	struct mlxsw_sp1_ptp_unmatched *unmatched;
+	int length;
 	int err;
 
 	rcu_read_lock();
 
-	unmatched = mlxsw_sp1_ptp_unmatched_lookup(mlxsw_sp, key);
-
 	spin_lock(&mlxsw_sp->ptp_state->unmatched_lock);
 
-	if (unmatched) {
-		/* There was an unmatched entry when we looked, but it may have
-		 * been removed before we took the lock.
-		 */
-		err = mlxsw_sp1_ptp_unmatched_remove(mlxsw_sp, unmatched);
-		if (err)
-			unmatched = NULL;
-	}
-
-	if (!unmatched) {
-		/* We have no unmatched entry, but one may have been added after
-		 * we looked, but before we took the lock.
-		 */
-		unmatched = mlxsw_sp1_ptp_unmatched_save(mlxsw_sp, key,
-							 skb, timestamp);
-		if (IS_ERR(unmatched)) {
-			if (skb)
-				mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
-							    key.local_port,
-							    key.ingress, NULL);
-			unmatched = NULL;
-		} else if (unmatched) {
-			/* Save just told us, under lock, that the entry is
-			 * there, so this has to work.
-			 */
-			err = mlxsw_sp1_ptp_unmatched_remove(mlxsw_sp,
-							     unmatched);
-			WARN_ON_ONCE(err);
-		}
-	}
-
-	/* If unmatched is non-NULL here, it comes either from the lookup, or
-	 * from the save attempt above. In either case the entry was removed
-	 * from the hash table. If unmatched is NULL, a new unmatched entry was
-	 * added to the hash table, and there was no conflict.
-	 */
-
+	unmatched = mlxsw_sp1_ptp_unmatched_lookup(mlxsw_sp, key, &length);
 	if (skb && unmatched && unmatched->timestamp) {
 		unmatched->skb = skb;
 	} else if (timestamp && unmatched && unmatched->skb) {
 		unmatched->timestamp = timestamp;
-	} else if (unmatched) {
-		/* unmatched holds an older entry of the same type: either an
-		 * skb if we are handling skb, or a timestamp if we are handling
-		 * timestamp. We can't match that up, so save what we have.
+	} else {
+		/* Either there is no entry to match, or one that is there is
+		 * incompatible.
 		 */
-		conflict = mlxsw_sp1_ptp_unmatched_save(mlxsw_sp, key,
-							skb, timestamp);
-		if (IS_ERR(conflict)) {
-			if (skb)
-				mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
-							    key.local_port,
-							    key.ingress, NULL);
-		} else {
-			/* Above, we removed an object with this key from the
-			 * hash table, under lock, so conflict can not be a
-			 * valid pointer.
-			 */
-			WARN_ON_ONCE(conflict);
-		}
+		if (length < 100)
+			err = mlxsw_sp1_ptp_unmatched_save(mlxsw_sp, key,
+							   skb, timestamp);
+		else
+			err = -E2BIG;
+		if (err && skb)
+			mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
+						    key.local_port,
+						    key.ingress, NULL);
+		unmatched = NULL;
+	}
+
+	if (unmatched) {
+		err = mlxsw_sp1_ptp_unmatched_remove(mlxsw_sp, unmatched);
+		WARN_ON_ONCE(err);
 	}
 
 	spin_unlock(&mlxsw_sp->ptp_state->unmatched_lock);
@@ -669,9 +642,8 @@ mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
 	local_bh_disable();
 
 	spin_lock(&ptp_state->unmatched_lock);
-	err = rhashtable_remove_fast(&ptp_state->unmatched_ht,
-				     &unmatched->ht_node,
-				     mlxsw_sp1_ptp_unmatched_ht_params);
+	err = rhltable_remove(&ptp_state->unmatched_ht, &unmatched->ht_node,
+			      mlxsw_sp1_ptp_unmatched_ht_params);
 	spin_unlock(&ptp_state->unmatched_lock);
 
 	if (err)
@@ -702,7 +674,7 @@ static void mlxsw_sp1_ptp_ht_gc(struct work_struct *work)
 	ptp_state = container_of(dwork, struct mlxsw_sp_ptp_state, ht_gc_dw);
 	gc_cycle = ptp_state->gc_cycle++;
 
-	rhashtable_walk_enter(&ptp_state->unmatched_ht, &iter);
+	rhltable_walk_enter(&ptp_state->unmatched_ht, &iter);
 	rhashtable_walk_start(&iter);
 	while ((obj = rhashtable_walk_next(&iter))) {
 		if (IS_ERR(obj))
@@ -855,8 +827,8 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 
 	spin_lock_init(&ptp_state->unmatched_lock);
 
-	err = rhashtable_init(&ptp_state->unmatched_ht,
-			      &mlxsw_sp1_ptp_unmatched_ht_params);
+	err = rhltable_init(&ptp_state->unmatched_ht,
+			    &mlxsw_sp1_ptp_unmatched_ht_params);
 	if (err)
 		goto err_hashtable_init;
 
@@ -891,7 +863,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 err_mtptpt1_set:
 	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
 err_mtptpt_set:
-	rhashtable_destroy(&ptp_state->unmatched_ht);
+	rhltable_destroy(&ptp_state->unmatched_ht);
 err_hashtable_init:
 	kfree(ptp_state);
 	return ERR_PTR(err);
@@ -906,8 +878,8 @@ void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 	mlxsw_sp1_ptp_set_fifo_clr_on_trap(mlxsw_sp, false);
 	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
 	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
-	rhashtable_free_and_destroy(&ptp_state->unmatched_ht,
-				    &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
+	rhltable_free_and_destroy(&ptp_state->unmatched_ht,
+				  &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
 	kfree(ptp_state);
 }
 
-- 
2.21.0

