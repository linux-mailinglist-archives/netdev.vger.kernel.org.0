Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024FD63C5CC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiK2Q6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiK2Q5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB8C65E53
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:42 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0FtgL0rFSjRrN+VK5M60a6mQGctH+j2IkY4op/B+D0E=;
        b=a+1b8cu/XEqHSHMzjJaIvX1nKz6srG1wJhCvOsAw3dOtJIZLY+CioHQsIEmhzS9T+vzXbj
        D9iSt82DodOGhwSMnBkUGtqLDp6TXNXSaYJpyMJIqoVrBB67EbdxBug46Vw1DbT3sjeMWw
        KRnTgcNu01UNZvMRv0h18YlA8x/rMfsadehTpXI++pA2BIrF8Eg701zLbpKcWtI7+fezxW
        SujAJWgrU6C7LpoxgDHIuxRXEgz9820BHjvQa0HjxuBMiBgJKdUghZaRobQrounq9U8qQp
        RzI4jjuZeVF2kmp87/cQSPmeII2SW9unMhtDaJzYdlSR6oA3awodxuNaHbHT6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0FtgL0rFSjRrN+VK5M60a6mQGctH+j2IkY4op/B+D0E=;
        b=EvDbNz3B285vH9bE8u0a1HoY8WiGtjggTEANGybNIswFGQANPG3qqi3PwQe6h6I0ghEU93
        mRkVwo+LLWyU70DQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH v5 net-next 1/8] Revert "net: hsr: use hlist_head instead of list_head for mac addresses"
Date:   Tue, 29 Nov 2022 17:48:08 +0100
Message-Id: <20221129164815.128922-2-bigeasy@linutronix.de>
In-Reply-To: <20221129164815.128922-1-bigeasy@linutronix.de>
References: <20221129164815.128922-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hlist optimisation (which not only uses hlist_head instead of
list_head but also splits hsr_priv::node_db into an array of 256 slots)
does not consider the "node merge":
Upon starting the hsr network (with three nodes) a packet that is
sent from node1 to node3 will also be sent from node1 to node2 and then
forwarded to node3.
As a result node3 will receive 2 packets because it is not able
to filter out the duplicate. Each packet received will create a new
struct hsr_node with macaddress_A only set the MAC address it received
from (the two MAC addesses from node1).
At some point (early in the process) two supervision frames will be
received from node1. They will be processed by hsr_handle_sup_frame()
and one frame will leave early ("Node has already been merged") and does
nothing. The other frame will be merged as portB and have its MAC
address written to macaddress_B and the hsr_node (that was created for
it as macaddress_A) will be removed.
From now on HSR is able to identify a duplicate because both packets
sent from one node will result in the same struct hsr_node because
hsr_get_node() will find the MAC address either on macaddress_A or
macaddress_B.

Things get tricky with the optimisation: If sender's MAC address is
saved as macaddress_A then the lookup will work as usual. If the MAC
address has been merged into macaddress_B of another hsr_node then the
lookup won't work because it is likely that the data structure is in
another bucket. This results in creating a new struct hsr_node and not
recognising a possible duplicate.

A way around it would be to add another hsr_node::mac_list_B and attach
it to the other bucket to ensure that this hsr_node will be looked up
either via macaddress_A _or_ macaddress_B.

I however prefer to revert it because it sounds like an academic problem
rather than real life workload plus it adds complexity. I'm not an HSR
expert with what is usual size of a network but I would guess 40 to 60
nodes. With 10.000 nodes and assuming 60us for pass-through (from node
to node) then it would take almost 600ms for a packet to almost wrap
around which sounds a lot.

Revert the hash MAC addresses optimisation.

Fixes: 4acc45db71158 ("net: hsr: use hlist_head instead of list_head for ma=
c addresses")
Cc: Juhee Kang <claudiajkang@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_debugfs.c  |  38 +++-----
 net/hsr/hsr_device.c   |  10 +-
 net/hsr/hsr_forward.c  |   7 +-
 net/hsr/hsr_framereg.c | 201 +++++++++++++++--------------------------
 net/hsr/hsr_framereg.h |  14 +--
 net/hsr/hsr_main.h     |   9 +-
 net/hsr/hsr_netlink.c  |   4 +-
 7 files changed, 101 insertions(+), 182 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index de476a4176314..1a195efc79cd1 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/debugfs.h>
-#include <linux/jhash.h>
 #include "hsr_main.h"
 #include "hsr_framereg.h"
=20
@@ -21,7 +20,6 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 {
 	struct hsr_priv *priv =3D (struct hsr_priv *)sfp->private;
 	struct hsr_node *node;
-	int i;
=20
 	seq_printf(sfp, "Node Table entries for (%s) device\n",
 		   (priv->prot_version =3D=3D PRP_V1 ? "PRP" : "HSR"));
@@ -33,28 +31,22 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 		seq_puts(sfp, "DAN-H\n");
=20
 	rcu_read_lock();
+	list_for_each_entry_rcu(node, &priv->node_db, mac_list) {
+		/* skip self node */
+		if (hsr_addr_is_self(priv, node->macaddress_A))
+			continue;
+		seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
+		seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
+		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_A]);
+		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_B]);
+		seq_printf(sfp, "%14x, ", node->addr_B_port);
=20
-	for (i =3D 0 ; i < priv->hash_buckets; i++) {
-		hlist_for_each_entry_rcu(node, &priv->node_db[i], mac_list) {
-			/* skip self node */
-			if (hsr_addr_is_self(priv, node->macaddress_A))
-				continue;
-			seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
-			seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
-			seq_printf(sfp, "%10lx, ",
-				   node->time_in[HSR_PT_SLAVE_A]);
-			seq_printf(sfp, "%10lx, ",
-				   node->time_in[HSR_PT_SLAVE_B]);
-			seq_printf(sfp, "%14x, ", node->addr_B_port);
-
-			if (priv->prot_version =3D=3D PRP_V1)
-				seq_printf(sfp, "%5x, %5x, %5x\n",
-					   node->san_a, node->san_b,
-					   (node->san_a =3D=3D 0 &&
-					    node->san_b =3D=3D 0));
-			else
-				seq_printf(sfp, "%5x\n", 1);
-		}
+		if (priv->prot_version =3D=3D PRP_V1)
+			seq_printf(sfp, "%5x, %5x, %5x\n",
+				   node->san_a, node->san_b,
+				   (node->san_a =3D=3D 0 && node->san_b =3D=3D 0));
+		else
+			seq_printf(sfp, "%5x\n", 1);
 	}
 	rcu_read_unlock();
 	return 0;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 6ffef47e9be55..7518f7e930431 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -485,16 +485,12 @@ int hsr_dev_finalize(struct net_device *hsr_dev, stru=
ct net_device *slave[2],
 {
 	bool unregister =3D false;
 	struct hsr_priv *hsr;
-	int res, i;
+	int res;
=20
 	hsr =3D netdev_priv(hsr_dev);
 	INIT_LIST_HEAD(&hsr->ports);
-	INIT_HLIST_HEAD(&hsr->self_node_db);
-	hsr->hash_buckets =3D HSR_HSIZE;
-	get_random_bytes(&hsr->hash_seed, sizeof(hsr->hash_seed));
-	for (i =3D 0; i < hsr->hash_buckets; i++)
-		INIT_HLIST_HEAD(&hsr->node_db[i]);
-
+	INIT_LIST_HEAD(&hsr->node_db);
+	INIT_LIST_HEAD(&hsr->self_node_db);
 	spin_lock_init(&hsr->list_lock);
=20
 	eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index a50429a62f744..9894962847d97 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -570,23 +570,20 @@ static int fill_frame_info(struct hsr_frame_info *fra=
me,
 	struct ethhdr *ethhdr;
 	__be16 proto;
 	int ret;
-	u32 hash;
=20
 	/* Check if skb contains ethhdr */
 	if (skb->mac_len < sizeof(struct ethhdr))
 		return -EINVAL;
=20
 	memset(frame, 0, sizeof(*frame));
-
-	ethhdr =3D (struct ethhdr *)skb_mac_header(skb);
-	hash =3D hsr_mac_hash(port->hsr, ethhdr->h_source);
 	frame->is_supervision =3D is_supervision_frame(port->hsr, skb);
-	frame->node_src =3D hsr_get_node(port, &hsr->node_db[hash], skb,
+	frame->node_src =3D hsr_get_node(port, &hsr->node_db, skb,
 				       frame->is_supervision,
 				       port->type);
 	if (!frame->node_src)
 		return -1; /* Unknown node and !is_supervision, or no mem */
=20
+	ethhdr =3D (struct ethhdr *)skb_mac_header(skb);
 	frame->is_vlan =3D false;
 	proto =3D ethhdr->h_proto;
=20
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 584e217887997..9b8eaebce2549 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -15,37 +15,10 @@
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
-#include <linux/jhash.h>
 #include "hsr_main.h"
 #include "hsr_framereg.h"
 #include "hsr_netlink.h"
=20
-#ifdef CONFIG_LOCKDEP
-int lockdep_hsr_is_held(spinlock_t *lock)
-{
-	return lockdep_is_held(lock);
-}
-#endif
-
-u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
-{
-	u32 hash =3D jhash(addr, ETH_ALEN, hsr->hash_seed);
-
-	return reciprocal_scale(hash, hsr->hash_buckets);
-}
-
-struct hsr_node *hsr_node_get_first(struct hlist_head *head, spinlock_t *l=
ock)
-{
-	struct hlist_node *first;
-
-	first =3D rcu_dereference_bh_check(hlist_first_rcu(head),
-					 lockdep_hsr_is_held(lock));
-	if (first)
-		return hlist_entry(first, struct hsr_node, mac_list);
-
-	return NULL;
-}
-
 /* seq_nr_after(a, b) - return true if a is after (higher in sequence than=
) b,
  * false otherwise.
  */
@@ -67,7 +40,8 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char=
 *addr)
 {
 	struct hsr_node *node;
=20
-	node =3D hsr_node_get_first(&hsr->self_node_db, &hsr->list_lock);
+	node =3D list_first_or_null_rcu(&hsr->self_node_db, struct hsr_node,
+				      mac_list);
 	if (!node) {
 		WARN_ONCE(1, "HSR: No self node\n");
 		return false;
@@ -83,12 +57,12 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned ch=
ar *addr)
=20
 /* Search for mac entry. Caller must hold rcu read lock.
  */
-static struct hsr_node *find_node_by_addr_A(struct hlist_head *node_db,
+static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
 					    const unsigned char addr[ETH_ALEN])
 {
 	struct hsr_node *node;
=20
-	hlist_for_each_entry_rcu(node, node_db, mac_list) {
+	list_for_each_entry_rcu(node, node_db, mac_list) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			return node;
 	}
@@ -103,7 +77,7 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 			 const unsigned char addr_a[ETH_ALEN],
 			 const unsigned char addr_b[ETH_ALEN])
 {
-	struct hlist_head *self_node_db =3D &hsr->self_node_db;
+	struct list_head *self_node_db =3D &hsr->self_node_db;
 	struct hsr_node *node, *oldnode;
=20
 	node =3D kmalloc(sizeof(*node), GFP_KERNEL);
@@ -114,13 +88,14 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 	ether_addr_copy(node->macaddress_B, addr_b);
=20
 	spin_lock_bh(&hsr->list_lock);
-	oldnode =3D hsr_node_get_first(self_node_db, &hsr->list_lock);
+	oldnode =3D list_first_or_null_rcu(self_node_db,
+					 struct hsr_node, mac_list);
 	if (oldnode) {
-		hlist_replace_rcu(&oldnode->mac_list, &node->mac_list);
+		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
 		spin_unlock_bh(&hsr->list_lock);
 		kfree_rcu(oldnode, rcu_head);
 	} else {
-		hlist_add_tail_rcu(&node->mac_list, self_node_db);
+		list_add_tail_rcu(&node->mac_list, self_node_db);
 		spin_unlock_bh(&hsr->list_lock);
 	}
=20
@@ -129,25 +104,25 @@ int hsr_create_self_node(struct hsr_priv *hsr,
=20
 void hsr_del_self_node(struct hsr_priv *hsr)
 {
-	struct hlist_head *self_node_db =3D &hsr->self_node_db;
+	struct list_head *self_node_db =3D &hsr->self_node_db;
 	struct hsr_node *node;
=20
 	spin_lock_bh(&hsr->list_lock);
-	node =3D hsr_node_get_first(self_node_db, &hsr->list_lock);
+	node =3D list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
 	if (node) {
-		hlist_del_rcu(&node->mac_list);
+		list_del_rcu(&node->mac_list);
 		kfree_rcu(node, rcu_head);
 	}
 	spin_unlock_bh(&hsr->list_lock);
 }
=20
-void hsr_del_nodes(struct hlist_head *node_db)
+void hsr_del_nodes(struct list_head *node_db)
 {
 	struct hsr_node *node;
-	struct hlist_node *tmp;
+	struct hsr_node *tmp;
=20
-	hlist_for_each_entry_safe(node, tmp, node_db, mac_list)
-		kfree_rcu(node, rcu_head);
+	list_for_each_entry_safe(node, tmp, node_db, mac_list)
+		kfree(node);
 }
=20
 void prp_handle_san_frame(bool san, enum hsr_port_type port,
@@ -168,7 +143,7 @@ void prp_handle_san_frame(bool san, enum hsr_port_type =
port,
  * originating from the newly added node.
  */
 static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
-				     struct hlist_head *node_db,
+				     struct list_head *node_db,
 				     unsigned char addr[],
 				     u16 seq_out, bool san,
 				     enum hsr_port_type rx_port)
@@ -198,14 +173,14 @@ static struct hsr_node *hsr_add_node(struct hsr_priv =
*hsr,
 		hsr->proto_ops->handle_san_frame(san, rx_port, new_node);
=20
 	spin_lock_bh(&hsr->list_lock);
-	hlist_for_each_entry_rcu(node, node_db, mac_list,
-				 lockdep_hsr_is_held(&hsr->list_lock)) {
+	list_for_each_entry_rcu(node, node_db, mac_list,
+				lockdep_is_held(&hsr->list_lock)) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			goto out;
 		if (ether_addr_equal(node->macaddress_B, addr))
 			goto out;
 	}
-	hlist_add_tail_rcu(&new_node->mac_list, node_db);
+	list_add_tail_rcu(&new_node->mac_list, node_db);
 	spin_unlock_bh(&hsr->list_lock);
 	return new_node;
 out:
@@ -225,7 +200,7 @@ void prp_update_san_info(struct hsr_node *node, bool is=
_sup)
=20
 /* Get the hsr_node from which 'skb' was sent.
  */
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *no=
de_db,
+struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *nod=
e_db,
 			      struct sk_buff *skb, bool is_sup,
 			      enum hsr_port_type rx_port)
 {
@@ -241,7 +216,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, st=
ruct hlist_head *node_db,
=20
 	ethhdr =3D (struct ethhdr *)skb_mac_header(skb);
=20
-	hlist_for_each_entry_rcu(node, node_db, mac_list) {
+	list_for_each_entry_rcu(node, node_db, mac_list) {
 		if (ether_addr_equal(node->macaddress_A, ethhdr->h_source)) {
 			if (hsr->proto_ops->update_san_info)
 				hsr->proto_ops->update_san_info(node, is_sup);
@@ -291,12 +266,11 @@ void hsr_handle_sup_frame(struct hsr_frame_info *fram=
e)
 	struct hsr_sup_tlv *hsr_sup_tlv;
 	struct hsr_node *node_real;
 	struct sk_buff *skb =3D NULL;
-	struct hlist_head *node_db;
+	struct list_head *node_db;
 	struct ethhdr *ethhdr;
 	int i;
 	unsigned int pull_size =3D 0;
 	unsigned int total_pull_size =3D 0;
-	u32 hash;
=20
 	/* Here either frame->skb_hsr or frame->skb_prp should be
 	 * valid as supervision frame always will have protocol
@@ -334,13 +308,11 @@ void hsr_handle_sup_frame(struct hsr_frame_info *fram=
e)
 	hsr_sp =3D (struct hsr_sup_payload *)skb->data;
=20
 	/* Merge node_curr (registered on macaddress_B) into node_real */
-	node_db =3D port_rcv->hsr->node_db;
-	hash =3D hsr_mac_hash(hsr, hsr_sp->macaddress_A);
-	node_real =3D find_node_by_addr_A(&node_db[hash], hsr_sp->macaddress_A);
+	node_db =3D &port_rcv->hsr->node_db;
+	node_real =3D find_node_by_addr_A(node_db, hsr_sp->macaddress_A);
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
-		node_real =3D hsr_add_node(hsr, &node_db[hash],
-					 hsr_sp->macaddress_A,
+		node_real =3D hsr_add_node(hsr, node_db, hsr_sp->macaddress_A,
 					 HSR_SEQNR_START - 1, true,
 					 port_rcv->type);
 	if (!node_real)
@@ -374,8 +346,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		hsr_sp =3D (struct hsr_sup_payload *)skb->data;
=20
 		/* Check if redbox mac and node mac are equal. */
-		if (!ether_addr_equal(node_real->macaddress_A,
-				      hsr_sp->macaddress_A)) {
+		if (!ether_addr_equal(node_real->macaddress_A, hsr_sp->macaddress_A)) {
 			/* This is a redbox supervision frame for a VDAN! */
 			goto done;
 		}
@@ -395,7 +366,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	node_real->addr_B_port =3D port_rcv->type;
=20
 	spin_lock_bh(&hsr->list_lock);
-	hlist_del_rcu(&node_curr->mac_list);
+	list_del_rcu(&node_curr->mac_list);
 	spin_unlock_bh(&hsr->list_lock);
 	kfree_rcu(node_curr, rcu_head);
=20
@@ -433,7 +404,6 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, str=
uct sk_buff *skb,
 			 struct hsr_port *port)
 {
 	struct hsr_node *node_dst;
-	u32 hash;
=20
 	if (!skb_mac_header_was_set(skb)) {
 		WARN_ONCE(1, "%s: Mac header not set\n", __func__);
@@ -443,8 +413,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, str=
uct sk_buff *skb,
 	if (!is_unicast_ether_addr(eth_hdr(skb)->h_dest))
 		return;
=20
-	hash =3D hsr_mac_hash(port->hsr, eth_hdr(skb)->h_dest);
-	node_dst =3D find_node_by_addr_A(&port->hsr->node_db[hash],
+	node_dst =3D find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
 		if (net_ratelimit())
@@ -520,73 +489,59 @@ static struct hsr_port *get_late_port(struct hsr_priv=
 *hsr,
 void hsr_prune_nodes(struct timer_list *t)
 {
 	struct hsr_priv *hsr =3D from_timer(hsr, t, prune_timer);
-	struct hlist_node *tmp;
 	struct hsr_node *node;
+	struct hsr_node *tmp;
 	struct hsr_port *port;
 	unsigned long timestamp;
 	unsigned long time_a, time_b;
-	int i;
=20
 	spin_lock_bh(&hsr->list_lock);
+	list_for_each_entry_safe(node, tmp, &hsr->node_db, mac_list) {
+		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
+		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
+		 * the master port. Thus the master node will be repeatedly
+		 * pruned leading to packet loss.
+		 */
+		if (hsr_addr_is_self(hsr, node->macaddress_A))
+			continue;
=20
-	for (i =3D 0; i < hsr->hash_buckets; i++) {
-		hlist_for_each_entry_safe(node, tmp, &hsr->node_db[i],
-					  mac_list) {
-			/* Don't prune own node.
-			 * Neither time_in[HSR_PT_SLAVE_A]
-			 * nor time_in[HSR_PT_SLAVE_B], will ever be updated
-			 * for the master port. Thus the master node will be
-			 * repeatedly pruned leading to packet loss.
-			 */
-			if (hsr_addr_is_self(hsr, node->macaddress_A))
-				continue;
+		/* Shorthand */
+		time_a =3D node->time_in[HSR_PT_SLAVE_A];
+		time_b =3D node->time_in[HSR_PT_SLAVE_B];
=20
-			/* Shorthand */
-			time_a =3D node->time_in[HSR_PT_SLAVE_A];
-			time_b =3D node->time_in[HSR_PT_SLAVE_B];
+		/* Check for timestamps old enough to risk wrap-around */
+		if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET / 2))
+			node->time_in_stale[HSR_PT_SLAVE_A] =3D true;
+		if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET / 2))
+			node->time_in_stale[HSR_PT_SLAVE_B] =3D true;
=20
-			/* Check for timestamps old enough to
-			 * risk wrap-around
-			 */
-			if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET / 2))
-				node->time_in_stale[HSR_PT_SLAVE_A] =3D true;
-			if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET / 2))
-				node->time_in_stale[HSR_PT_SLAVE_B] =3D true;
+		/* Get age of newest frame from node.
+		 * At least one time_in is OK here; nodes get pruned long
+		 * before both time_ins can get stale
+		 */
+		timestamp =3D time_a;
+		if (node->time_in_stale[HSR_PT_SLAVE_A] ||
+		    (!node->time_in_stale[HSR_PT_SLAVE_B] &&
+		    time_after(time_b, time_a)))
+			timestamp =3D time_b;
=20
-			/* Get age of newest frame from node.
-			 * At least one time_in is OK here; nodes get pruned
-			 * long before both time_ins can get stale
-			 */
-			timestamp =3D time_a;
-			if (node->time_in_stale[HSR_PT_SLAVE_A] ||
-			    (!node->time_in_stale[HSR_PT_SLAVE_B] &&
-			     time_after(time_b, time_a)))
-				timestamp =3D time_b;
+		/* Warn of ring error only as long as we get frames at all */
+		if (time_is_after_jiffies(timestamp +
+				msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) {
+			rcu_read_lock();
+			port =3D get_late_port(hsr, node);
+			if (port)
+				hsr_nl_ringerror(hsr, node->macaddress_A, port);
+			rcu_read_unlock();
+		}
=20
-			/* Warn of ring error only as long as we get
-			 * frames at all
-			 */
-			if (time_is_after_jiffies(timestamp +
-						  msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) {
-				rcu_read_lock();
-				port =3D get_late_port(hsr, node);
-				if (port)
-					hsr_nl_ringerror(hsr,
-							 node->macaddress_A,
-							 port);
-				rcu_read_unlock();
-			}
-
-			/* Prune old entries */
-			if (time_is_before_jiffies(timestamp +
-						   msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
-				hsr_nl_nodedown(hsr, node->macaddress_A);
-				hlist_del_rcu(&node->mac_list);
-				/* Note that we need to free this
-				 * entry later:
-				 */
-				kfree_rcu(node, rcu_head);
-			}
+		/* Prune old entries */
+		if (time_is_before_jiffies(timestamp +
+				msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
+			hsr_nl_nodedown(hsr, node->macaddress_A);
+			list_del_rcu(&node->mac_list);
+			/* Note that we need to free this entry later: */
+			kfree_rcu(node, rcu_head);
 		}
 	}
 	spin_unlock_bh(&hsr->list_lock);
@@ -600,20 +555,17 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_=
pos,
 			unsigned char addr[ETH_ALEN])
 {
 	struct hsr_node *node;
-	u32 hash;
-
-	hash =3D hsr_mac_hash(hsr, addr);
=20
 	if (!_pos) {
-		node =3D hsr_node_get_first(&hsr->node_db[hash],
-					  &hsr->list_lock);
+		node =3D list_first_or_null_rcu(&hsr->node_db,
+					      struct hsr_node, mac_list);
 		if (node)
 			ether_addr_copy(addr, node->macaddress_A);
 		return node;
 	}
=20
 	node =3D _pos;
-	hlist_for_each_entry_continue_rcu(node, mac_list) {
+	list_for_each_entry_continue_rcu(node, &hsr->node_db, mac_list) {
 		ether_addr_copy(addr, node->macaddress_A);
 		return node;
 	}
@@ -633,11 +585,8 @@ int hsr_get_node_data(struct hsr_priv *hsr,
 	struct hsr_node *node;
 	struct hsr_port *port;
 	unsigned long tdiff;
-	u32 hash;
=20
-	hash =3D hsr_mac_hash(hsr, addr);
-
-	node =3D find_node_by_addr_A(&hsr->node_db[hash], addr);
+	node =3D find_node_by_addr_A(&hsr->node_db, addr);
 	if (!node)
 		return -ENOENT;
=20
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index f3762e9e42b54..bdbb8c822ba1a 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -28,17 +28,9 @@ struct hsr_frame_info {
 	bool is_from_san;
 };
=20
-#ifdef CONFIG_LOCKDEP
-int lockdep_hsr_is_held(spinlock_t *lock);
-#else
-#define lockdep_hsr_is_held(lock)	1
-#endif
-
-u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr);
-struct hsr_node *hsr_node_get_first(struct hlist_head *head, spinlock_t *l=
ock);
 void hsr_del_self_node(struct hsr_priv *hsr);
-void hsr_del_nodes(struct hlist_head *node_db);
-struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *no=
de_db,
+void hsr_del_nodes(struct list_head *node_db);
+struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *nod=
e_db,
 			      struct sk_buff *skb, bool is_sup,
 			      enum hsr_port_type rx_port);
 void hsr_handle_sup_frame(struct hsr_frame_info *frame);
@@ -76,7 +68,7 @@ void prp_handle_san_frame(bool san, enum hsr_port_type po=
rt,
 void prp_update_san_info(struct hsr_node *node, bool is_sup);
=20
 struct hsr_node {
-	struct hlist_node	mac_list;
+	struct list_head	mac_list;
 	unsigned char		macaddress_A[ETH_ALEN];
 	unsigned char		macaddress_B[ETH_ALEN];
 	/* Local slave through which AddrB frames are received from this node */
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index b158ba409f9a4..16ae9fb09ccd2 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -47,9 +47,6 @@
=20
 #define HSR_V1_SUP_LSDUSIZE		52
=20
-#define HSR_HSIZE_SHIFT	8
-#define HSR_HSIZE	BIT(HSR_HSIZE_SHIFT)
-
 /* The helper functions below assumes that 'path' occupies the 4 most
  * significant bits of the 16-bit field shared by 'path' and 'LSDU_size' (=
or
  * equivalently, the 4 most significant bits of HSR tag byte 14).
@@ -188,8 +185,8 @@ struct hsr_proto_ops {
 struct hsr_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
-	struct hlist_head	node_db[HSR_HSIZE];	/* Known HSR nodes */
-	struct hlist_head	self_node_db;	/* MACs of slaves */
+	struct list_head	node_db;	/* Known HSR nodes */
+	struct list_head	self_node_db;	/* MACs of slaves */
 	struct timer_list	announce_timer;	/* Supervision frame dispatch */
 	struct timer_list	prune_timer;
 	int announce_count;
@@ -199,8 +196,6 @@ struct hsr_priv {
 	spinlock_t seqnr_lock;	/* locking for sequence_nr */
 	spinlock_t list_lock;	/* locking for node list */
 	struct hsr_proto_ops	*proto_ops;
-	u32 hash_buckets;
-	u32 hash_seed;
 #define PRP_LAN_ID	0x5     /* 0x1010 for A and 0x1011 for B. Bit 0 is set
 				 * based on SLAVE_A or SLAVE_B
 				 */
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 7174a90929002..78fe40eb9f012 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -105,7 +105,6 @@ static int hsr_newlink(struct net *src_net, struct net_=
device *dev,
 static void hsr_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct hsr_priv *hsr =3D netdev_priv(dev);
-	int i;
=20
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
@@ -114,8 +113,7 @@ static void hsr_dellink(struct net_device *dev, struct =
list_head *head)
 	hsr_del_ports(hsr);
=20
 	hsr_del_self_node(hsr);
-	for (i =3D 0; i < hsr->hash_buckets; i++)
-		hsr_del_nodes(&hsr->node_db[i]);
+	hsr_del_nodes(&hsr->node_db);
=20
 	unregister_netdevice_queue(dev, head);
 }
--=20
2.38.1

