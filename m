Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F6763C5CF
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiK2Q6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiK2Q5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8FB69DED
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:46 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8ZUWdmKKpxHScpBal2gNNwA7ou8leJNvjFhbk8j6wU=;
        b=QZaxzMWZtNH00eSc7C0i/bMiO9A+C7Tdm9FY0aDyiOB6qkk6UAVIpGo6DT8z0vclqSVvcD
        WKiDCyuYEmPaMEGuXKhYalIEHFEpoR7ENENSaHhXRwJ4UmtyUGp/Jv7d/eRFevzA4mntC9
        bgaSNMNfZKv2C0Meq/UYi9CXx4+UulIlByjlswEHL2jWsYCoDsptfrD01ZA8a056oNbe2f
        MB1It3isWQYuuZN5d1deW+RNxc/6SZtZqJ/SK+qUudwETLOYZYFYud0bVMHJ1xo8JMRv5W
        sMBKteZ4G43uwxPyvBIB3IsVhNfGAof9BauWVfq42+ghMmckCoT1D6uiGoZh4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8ZUWdmKKpxHScpBal2gNNwA7ou8leJNvjFhbk8j6wU=;
        b=4r4DTkGZJYQGHejHG6U7jpNpM0suxcDjg4VHM38aC66Wis5KY35eTNj1gWJOyByKCWWN3N
        oxR8nqoFa/vqo0Bw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 net-next 7/8] hsr: Use a single struct for self_node.
Date:   Tue, 29 Nov 2022 17:48:14 +0100
Message-Id: <20221129164815.128922-8-bigeasy@linutronix.de>
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

self_node_db is a list_head with one entry of struct hsr_node. The
purpose is to hold the two MAC addresses of the node itself.
It is convenient to recycle the structure. However having a list_head
and fetching always the first entry is not really optimal.

Created a new data strucure contaning the two MAC addresses named
hsr_self_node. Access that structure like an RCU protected pointer so
it can be replaced on the fly without blocking the reader.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/hsr/hsr_device.c   |  1 -
 net/hsr/hsr_framereg.c | 63 +++++++++++++++++++-----------------------
 net/hsr/hsr_main.h     |  8 +++++-
 3 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index b1e86a7265b32..5a236aae2366f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -490,7 +490,6 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct=
 net_device *slave[2],
 	hsr =3D netdev_priv(hsr_dev);
 	INIT_LIST_HEAD(&hsr->ports);
 	INIT_LIST_HEAD(&hsr->node_db);
-	INIT_LIST_HEAD(&hsr->self_node_db);
 	spin_lock_init(&hsr->list_lock);
=20
 	eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 39a6088080e93..00db74d96583d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -38,21 +38,22 @@ static bool seq_nr_after(u16 a, u16 b)
=20
 bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 {
-	struct hsr_node *node;
+	struct hsr_self_node *sn;
+	bool ret =3D false;
=20
-	node =3D list_first_or_null_rcu(&hsr->self_node_db, struct hsr_node,
-				      mac_list);
-	if (!node) {
+	rcu_read_lock();
+	sn =3D rcu_dereference(hsr->self_node);
+	if (!sn) {
 		WARN_ONCE(1, "HSR: No self node\n");
-		return false;
+		goto out;
 	}
=20
-	if (ether_addr_equal(addr, node->macaddress_A))
-		return true;
-	if (ether_addr_equal(addr, node->macaddress_B))
-		return true;
-
-	return false;
+	if (ether_addr_equal(addr, sn->macaddress_A) ||
+	    ether_addr_equal(addr, sn->macaddress_B))
+		ret =3D true;
+out:
+	rcu_read_unlock();
+	return ret;
 }
=20
 /* Search for mac entry. Caller must hold rcu read lock.
@@ -70,50 +71,42 @@ static struct hsr_node *find_node_by_addr_A(struct list=
_head *node_db,
 	return NULL;
 }
=20
-/* Helper for device init; the self_node_db is used in hsr_rcv() to recogn=
ize
+/* Helper for device init; the self_node is used in hsr_rcv() to recognize
  * frames from self that's been looped over the HSR ring.
  */
 int hsr_create_self_node(struct hsr_priv *hsr,
 			 const unsigned char addr_a[ETH_ALEN],
 			 const unsigned char addr_b[ETH_ALEN])
 {
-	struct list_head *self_node_db =3D &hsr->self_node_db;
-	struct hsr_node *node, *oldnode;
+	struct hsr_self_node *sn, *old;
=20
-	node =3D kmalloc(sizeof(*node), GFP_KERNEL);
-	if (!node)
+	sn =3D kmalloc(sizeof(*sn), GFP_KERNEL);
+	if (!sn)
 		return -ENOMEM;
=20
-	ether_addr_copy(node->macaddress_A, addr_a);
-	ether_addr_copy(node->macaddress_B, addr_b);
+	ether_addr_copy(sn->macaddress_A, addr_a);
+	ether_addr_copy(sn->macaddress_B, addr_b);
=20
 	spin_lock_bh(&hsr->list_lock);
-	oldnode =3D list_first_or_null_rcu(self_node_db,
-					 struct hsr_node, mac_list);
-	if (oldnode) {
-		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
-		spin_unlock_bh(&hsr->list_lock);
-		kfree_rcu(oldnode, rcu_head);
-	} else {
-		list_add_tail_rcu(&node->mac_list, self_node_db);
-		spin_unlock_bh(&hsr->list_lock);
-	}
+	old =3D rcu_replace_pointer(hsr->self_node, sn,
+				  lockdep_is_held(&hsr->list_lock));
+	spin_unlock_bh(&hsr->list_lock);
=20
+	if (old)
+		kfree_rcu(old, rcu_head);
 	return 0;
 }
=20
 void hsr_del_self_node(struct hsr_priv *hsr)
 {
-	struct list_head *self_node_db =3D &hsr->self_node_db;
-	struct hsr_node *node;
+	struct hsr_self_node *old;
=20
 	spin_lock_bh(&hsr->list_lock);
-	node =3D list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
-	if (node) {
-		list_del_rcu(&node->mac_list);
-		kfree_rcu(node, rcu_head);
-	}
+	old =3D rcu_replace_pointer(hsr->self_node, NULL,
+				  lockdep_is_held(&hsr->list_lock));
 	spin_unlock_bh(&hsr->list_lock);
+	if (old)
+		kfree_rcu(old, rcu_head);
 }
=20
 void hsr_del_nodes(struct list_head *node_db)
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 16ae9fb09ccd2..5584c80a5c795 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -182,11 +182,17 @@ struct hsr_proto_ops {
 	void (*update_san_info)(struct hsr_node *node, bool is_sup);
 };
=20
+struct hsr_self_node {
+	unsigned char	macaddress_A[ETH_ALEN];
+	unsigned char	macaddress_B[ETH_ALEN];
+	struct rcu_head	rcu_head;
+};
+
 struct hsr_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
 	struct list_head	node_db;	/* Known HSR nodes */
-	struct list_head	self_node_db;	/* MACs of slaves */
+	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
 	struct timer_list	announce_timer;	/* Supervision frame dispatch */
 	struct timer_list	prune_timer;
 	int announce_count;
--=20
2.38.1

