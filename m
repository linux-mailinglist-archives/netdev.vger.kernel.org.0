Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D716CB4FF
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjC1DlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbjC1DlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:41:23 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C10C198B;
        Mon, 27 Mar 2023 20:41:19 -0700 (PDT)
X-UUID: b1670cf888f84dab9788b343001e7cdb-20230328
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:4924d34c-98e4-4057-8ba2-3e0330e3e5fe,IP:-32
        768,URL:-32768,TC:-32768,Content:-32768,EDM:-32768,RT:-32768,SF:-32768,FIL
        E:-32768,BULK:-32768,RULE:Release_Ham,ACTION:release,TS:0
X-CID-INFO: VERSION:1.1.20,REQID:4924d34c-98e4-4057-8ba2-3e0330e3e5fe,IP:-3276
        8,URL:-32768,TC:-32768,Content:-32768,EDM:-32768,RT:-32768,SF:-32768,FILE:
        -32768,BULK:-32768,RULE:Release_Ham,ACTION:release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:nil,BulkID:nil,BulkQuantity:0,Recheck:
        0,SF:nil,TC:nil,Content:nil,EDM:nil,IP:nil,URL:nil,File:nil,Bulk:nil,QS:ni
        l,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-UUID: b1670cf888f84dab9788b343001e7cdb-20230328
X-User: sujing@kylinos.cn
Received: from localhost.localdomain [(210.12.40.82)] by mailgw
        (envelope-from <sujing@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1177435070; Tue, 28 Mar 2023 11:40:46 +0800
From:   sujing <sujing@kylinos.cn>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andy@greyhouse.net, j.vosburgh@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sujing <sujing@kylinos.cn>
Subject: [PATCH] net: bonding: avoid use-after-free with tx_hashtbl/rx_hashtbl
Date:   Tue, 28 Mar 2023 11:40:37 +0800
Message-Id: <20230328034037.2076930-1-sujing@kylinos.cn>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bonding mode 6 (Balance-alb),
there are some potential race conditions between the 'bond_close' process
and the tx/rx processes that use tx_hashtbl/rx_hashtbl,
which may lead to use-after-free.

For instance, when the bond6 device is in the 'bond_close' process
while some backlogged packets from upper level are transmitted
to 'bond_start_xmit', there is a spinlock contention between
'tlb_deinitialize' and 'tlb_choose_channel'.

If 'tlb_deinitialize' preempts the lock before 'tlb_choose_channel',
a NULL pointer kernel panic will be triggered.

Here's the timeline:

bond_close  ------------------  bond_start_xmit
bond_alb_deinitialize  -------  __bond_start_xmit
tlb_deinitialize  ------------  bond_alb_xmit
spin_lock_bh  ----------------  bond_xmit_alb_slave_get
tx_hashtbl = NULL  -----------  tlb_choose_channel
spin_unlock_bh  --------------  //wait for spin_lock_bh
------------------------------  spin_lock_bh
------------------------------  __tlb_choose_channel
causing kernel panic ========>  tx_hashtbl[hash_index].tx_slave
------------------------------  spin_unlock_bh

Signed-off-by: sujing <sujing@kylinos.cn>
---
 drivers/net/bonding/bond_alb.c  | 32 +++++++++------------------
 drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++++++++------
 include/net/bond_alb.h          |  5 ++++-
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index b9dbad3a8af8..f6ff5ea835c4 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -71,7 +71,7 @@ static inline u8 _simple_hash(const u8 *hash_start, int hash_size)
 
 /*********************** tlb specific functions ***************************/
 
-static inline void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
+void tlb_init_table_entry(struct tlb_client_info *entry, int save_load)
 {
 	if (save_load) {
 		entry->load_history = 1 + entry->tx_bytes /
@@ -269,8 +269,8 @@ static void rlb_update_entry_from_arp(struct bonding *bond, struct arp_pkt *arp)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
-static int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
-			struct slave *slave)
+int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond,
+		 struct slave *slave)
 {
 	struct arp_pkt *arp, _arp;
 
@@ -756,7 +756,7 @@ static void rlb_init_table_entry_src(struct rlb_client_info *entry)
 	entry->src_next = RLB_NULL_INDEX;
 }
 
-static void rlb_init_table_entry(struct rlb_client_info *entry)
+void rlb_init_table_entry(struct rlb_client_info *entry)
 {
 	memset(entry, 0, sizeof(struct rlb_client_info));
 	rlb_init_table_entry_dst(entry);
@@ -874,9 +874,6 @@ static int rlb_initialize(struct bonding *bond)
 
 	spin_unlock_bh(&bond->mode_lock);
 
-	/* register to receive ARPs */
-	bond->recv_probe = rlb_arp_recv;
-
 	return 0;
 }
 
@@ -888,7 +885,6 @@ static void rlb_deinitialize(struct bonding *bond)
 
 	kfree(bond_info->rx_hashtbl);
 	bond_info->rx_hashtbl = NULL;
-	bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
 
 	spin_unlock_bh(&bond->mode_lock);
 }
@@ -1303,7 +1299,7 @@ static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
 
 /************************ exported alb functions ************************/
 
-int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
+int bond_alb_initialize(struct bonding *bond)
 {
 	int res;
 
@@ -1311,15 +1307,10 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
 	if (res)
 		return res;
 
-	if (rlb_enabled) {
-		res = rlb_initialize(bond);
-		if (res) {
-			tlb_deinitialize(bond);
-			return res;
-		}
-		bond->alb_info.rlb_enabled = 1;
-	} else {
-		bond->alb_info.rlb_enabled = 0;
+	res = rlb_initialize(bond);
+	if (res) {
+		tlb_deinitialize(bond);
+		return res;
 	}
 
 	return 0;
@@ -1327,12 +1318,9 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
 
 void bond_alb_deinitialize(struct bonding *bond)
 {
-	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-
 	tlb_deinitialize(bond);
 
-	if (bond_info->rlb_enabled)
-		rlb_deinitialize(bond);
+	rlb_deinitialize(bond);
 }
 
 static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 236e5219c811..8fcb5d3ac0a2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4217,6 +4217,7 @@ static int bond_open(struct net_device *bond_dev)
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct list_head *iter;
 	struct slave *slave;
+	int i;
 
 	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter) {
 		bond->rr_tx_counter = alloc_percpu(u32);
@@ -4239,11 +4240,29 @@ static int bond_open(struct net_device *bond_dev)
 	}
 
 	if (bond_is_lb(bond)) {
-		/* bond_alb_initialize must be called before the timer
-		 * is started.
-		 */
-		if (bond_alb_initialize(bond, (BOND_MODE(bond) == BOND_MODE_ALB)))
-			return -ENOMEM;
+		struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+
+		spin_lock_bh(&bond->mode_lock);
+
+		for (i = 0; i < TLB_HASH_TABLE_SIZE; i++)
+			tlb_init_table_entry(&bond_info->tx_hashtbl[i], 0);
+
+		spin_unlock_bh(&bond->mode_lock);
+
+		if (BOND_MODE(bond) == BOND_MODE_ALB) {
+			bond->alb_info.rlb_enabled = 1;
+			spin_lock_bh(&bond->mode_lock);
+
+			bond_info->rx_hashtbl_used_head = RLB_NULL_INDEX;
+			for (i = 0; i < RLB_HASH_TABLE_SIZE; i++)
+				rlb_init_table_entry(bond_info->rx_hashtbl + i);
+
+			spin_unlock_bh(&bond->mode_lock);
+			bond->recv_probe = rlb_arp_recv;
+		} else {
+			bond->alb_info.rlb_enabled = 0;
+		}
+
 		if (bond->params.tlb_dynamic_lb || BOND_MODE(bond) == BOND_MODE_ALB)
 			queue_delayed_work(bond->wq, &bond->alb_work, 0);
 	}
@@ -4279,8 +4298,6 @@ static int bond_close(struct net_device *bond_dev)
 
 	bond_work_cancel_all(bond);
 	bond->send_peer_notif = 0;
-	if (bond_is_lb(bond))
-		bond_alb_deinitialize(bond);
 	bond->recv_probe = NULL;
 
 	if (bond_uses_primary(bond)) {
@@ -5854,6 +5871,8 @@ static void bond_uninit(struct net_device *bond_dev)
 	struct list_head *iter;
 	struct slave *slave;
 
+	bond_alb_deinitialize(bond);
+
 	bond_netpoll_cleanup(bond_dev);
 
 	/* Release the bonded slaves */
@@ -6295,6 +6314,12 @@ static int bond_init(struct net_device *bond_dev)
 	    bond_dev->addr_assign_type == NET_ADDR_PERM)
 		eth_hw_addr_random(bond_dev);
 
+	/* bond_alb_initialize must be called before the timer
+	 * is started.
+	 */
+	if (bond_alb_initialize(bond))
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index 9dc082b2d543..9fd16e20ef82 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -150,7 +150,7 @@ struct alb_bond_info {
 						 */
 };
 
-int bond_alb_initialize(struct bonding *bond, int rlb_enabled);
+int bond_alb_initialize(struct bonding *bond);
 void bond_alb_deinitialize(struct bonding *bond);
 int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
@@ -165,5 +165,8 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 void bond_alb_monitor(struct work_struct *);
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
 void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
+int rlb_arp_recv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
+void tlb_init_table_entry(struct tlb_client_info *entry, int save_load);
+void rlb_init_table_entry(struct rlb_client_info *entry);
 #endif /* _NET_BOND_ALB_H */
 
-- 
2.27.0

