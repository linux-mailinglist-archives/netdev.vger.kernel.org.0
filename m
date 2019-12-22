Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150EB128D96
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLVL1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:27:03 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38963 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfLVL1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:27:03 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so7338594pga.6
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wNOdmgzrHgeScM7jVhYxiF1KrU4S0/aIH90VluQlvrk=;
        b=cGqeCnddOH4YZ7FLIey3lmKX2XAuXOVC/rOBqpHhzaCwXJ6oXj2IZws4WWVcDtizzk
         0v7DKGZBfFtF8zpGvdx0IVriHuk2rj7vkgxNIvRg/3rJsnAEhinn48wtOVeHRPHZz9Tg
         rlT/KsAIn8ir5obH2RhhaIj2ob6ZMgxVjqjm/sRRw4zIttbBjnhC3TILD4uvFu1lXUeq
         X/11Lan//R5RrBm692G5c4eD0zlsMeZ6JyaGS1pAykRW8ARdHQQNxnmN3D8IwbEgI2lj
         Bi0Eg/YU3bKOM6DV5aWTdu3dvoULeL5rSZ1GYuLAu7hGzSDLxhYVDuerfgLGyB+HQaaU
         qKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wNOdmgzrHgeScM7jVhYxiF1KrU4S0/aIH90VluQlvrk=;
        b=j3Ve5o+Y+SltZyal2H6wVnG1aKkLOEWReH5uLTmHfZsi2VLJ+V7yrcxct0SKWSUqk+
         ZLr9OCKCL0o2+aOKUkTKZZ1q90lt4MNtFIiB2Cs9mbr+f1FpYyc7Aase/OrsAds5Lcja
         EdkARRGQ5Y1O5iP4VSsIW2ch9ZtHjQLFXmA72wzZYFw3JltGN31y6Bqq4dbmJSEoUMXV
         anZ3pOT9rudK9vGMc9BVjYy05+PcQ59Gh1XtUWBfM/YMrsOkxI2eZKBgzklRkiBlLiLq
         X1TVaZpAvKHOknaYM3t9mUW8cdXuYA5usjoWAUAAXCNBf8xG4c78AA7NuQ2EvNRTje9I
         C9Sw==
X-Gm-Message-State: APjAAAU0AesXEIPhLZg23dgyp34igGsqIFn+PfaPyUdndOrm5dy2C4gu
        am1cPmpvlx2mmrcTADlzl+yXAvHH
X-Google-Smtp-Source: APXvYqzUEejHwW7OqwrbWIvnchJuqYMWTYDZhFlILfxO9N+GnPCtxQYZ1K8fusPxPxiZ+98dBI1GAA==
X-Received: by 2002:a63:4664:: with SMTP id v36mr25197990pgk.147.1577014021779;
        Sun, 22 Dec 2019 03:27:01 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id g24sm19087806pfk.92.2019.12.22.03.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:27:00 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 5/6] hsr: fix a race condition in node list insertion and deletion
Date:   Sun, 22 Dec 2019 11:26:54 +0000
Message-Id: <20191222112654.3334-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr nodes are protected by RCU and there is no write side lock.
But node insertions and deletions could be being operated concurrently.
So write side locking is needed.

Test commands:
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst
    ip link set veth0 up
    ip link set veth2 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set veth3 up
    ip netns exec nst ip link add hsr1 type hsr slave1 veth1 slave2 veth3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set hsr1 up

    for i in {0..9}
    do
        for j in {0..9}
	do
	    for k in {0..9}
	    do
	        for l in {0..9}
		do
	        arping 192.168.100.2 -I hsr0 -s 00:01:3$i:4$j:5$k:6$l -c1 &
		done
	    done
	done
    done

Splat looks like:
[  236.066091][ T3286] list_add corruption. next->prev should be prev (ffff8880a5940300), but was ffff8880a5940d0.
[  236.069617][ T3286] ------------[ cut here ]------------
[  236.070545][ T3286] kernel BUG at lib/list_debug.c:25!
[  236.071391][ T3286] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  236.072343][ T3286] CPU: 0 PID: 3286 Comm: arping Tainted: G        W         5.5.0-rc1+ #209
[  236.073463][ T3286] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  236.074695][ T3286] RIP: 0010:__list_add_valid+0x74/0xd0
[  236.075499][ T3286] Code: 48 39 da 75 27 48 39 f5 74 36 48 39 dd 74 31 48 83 c4 08 b8 01 00 00 00 5b 5d c3 48 b
[  236.078277][ T3286] RSP: 0018:ffff8880aaa97648 EFLAGS: 00010286
[  236.086991][ T3286] RAX: 0000000000000075 RBX: ffff8880d4624c20 RCX: 0000000000000000
[  236.088000][ T3286] RDX: 0000000000000075 RSI: 0000000000000008 RDI: ffffed1015552ebf
[  236.098897][ T3286] RBP: ffff88809b53d200 R08: ffffed101b3c04f9 R09: ffffed101b3c04f9
[  236.099960][ T3286] R10: 00000000308769a1 R11: ffffed101b3c04f8 R12: ffff8880d4624c28
[  236.100974][ T3286] R13: ffff8880d4624c20 R14: 0000000040310100 R15: ffff8880ce17ee02
[  236.138967][ T3286] FS:  00007f23479fa680(0000) GS:ffff8880d9c00000(0000) knlGS:0000000000000000
[  236.144852][ T3286] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  236.145720][ T3286] CR2: 00007f4a14bab210 CR3: 00000000a61c6001 CR4: 00000000000606f0
[  236.146776][ T3286] Call Trace:
[  236.147222][ T3286]  hsr_add_node+0x314/0x490 [hsr]
[  236.153633][ T3286]  hsr_forward_skb+0x2b6/0x1bc0 [hsr]
[  236.154362][ T3286]  ? rcu_read_lock_sched_held+0x90/0xc0
[  236.155091][ T3286]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  236.156607][ T3286]  hsr_dev_xmit+0x70/0xd0 [hsr]
[  236.157254][ T3286]  dev_hard_start_xmit+0x160/0x740
[  236.157941][ T3286]  __dev_queue_xmit+0x1961/0x2e10
[  236.158565][ T3286]  ? netdev_core_pick_tx+0x2e0/0x2e0
[ ... ]

Reported-by: syzbot+3924327f9ad5f4d2b343@syzkaller.appspotmail.com
Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c   |  7 ++--
 net/hsr/hsr_framereg.c | 73 ++++++++++++++++++++++++++----------------
 net/hsr/hsr_framereg.h |  6 ++--
 net/hsr/hsr_main.c     |  2 +-
 net/hsr/hsr_main.h     |  5 +--
 5 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index e73549075a03..62c03f0d0079 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -368,7 +368,7 @@ static void hsr_dev_destroy(struct net_device *hsr_dev)
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
 
-	hsr_del_self_node(&hsr->self_node_db);
+	hsr_del_self_node(hsr);
 	hsr_del_nodes(&hsr->node_db);
 }
 
@@ -440,11 +440,12 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	INIT_LIST_HEAD(&hsr->ports);
 	INIT_LIST_HEAD(&hsr->node_db);
 	INIT_LIST_HEAD(&hsr->self_node_db);
+	spin_lock_init(&hsr->list_lock);
 
 	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
 
 	/* Make sure we recognize frames from ourselves in hsr_rcv() */
-	res = hsr_create_self_node(&hsr->self_node_db, hsr_dev->dev_addr,
+	res = hsr_create_self_node(hsr, hsr_dev->dev_addr,
 				   slave[1]->dev_addr);
 	if (res < 0)
 		return res;
@@ -502,7 +503,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
 err_add_master:
-	hsr_del_self_node(&hsr->self_node_db);
+	hsr_del_self_node(hsr);
 
 	return res;
 }
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 292be446007b..27dc65d7de67 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -75,10 +75,11 @@ static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
 /* Helper for device init; the self_node_db is used in hsr_rcv() to recognize
  * frames from self that's been looped over the HSR ring.
  */
-int hsr_create_self_node(struct list_head *self_node_db,
+int hsr_create_self_node(struct hsr_priv *hsr,
 			 unsigned char addr_a[ETH_ALEN],
 			 unsigned char addr_b[ETH_ALEN])
 {
+	struct list_head *self_node_db = &hsr->self_node_db;
 	struct hsr_node *node, *oldnode;
 
 	node = kmalloc(sizeof(*node), GFP_KERNEL);
@@ -88,33 +89,33 @@ int hsr_create_self_node(struct list_head *self_node_db,
 	ether_addr_copy(node->macaddress_A, addr_a);
 	ether_addr_copy(node->macaddress_B, addr_b);
 
-	rcu_read_lock();
+	spin_lock_bh(&hsr->list_lock);
 	oldnode = list_first_or_null_rcu(self_node_db,
 					 struct hsr_node, mac_list);
 	if (oldnode) {
 		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
-		rcu_read_unlock();
-		synchronize_rcu();
-		kfree(oldnode);
+		spin_unlock_bh(&hsr->list_lock);
+		kfree_rcu(oldnode, rcu_head);
 	} else {
-		rcu_read_unlock();
 		list_add_tail_rcu(&node->mac_list, self_node_db);
+		spin_unlock_bh(&hsr->list_lock);
 	}
 
 	return 0;
 }
 
-void hsr_del_self_node(struct list_head *self_node_db)
+void hsr_del_self_node(struct hsr_priv *hsr)
 {
+	struct list_head *self_node_db = &hsr->self_node_db;
 	struct hsr_node *node;
 
-	rcu_read_lock();
+	spin_lock_bh(&hsr->list_lock);
 	node = list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
-	rcu_read_unlock();
 	if (node) {
 		list_del_rcu(&node->mac_list);
-		kfree(node);
+		kfree_rcu(node, rcu_head);
 	}
+	spin_unlock_bh(&hsr->list_lock);
 }
 
 void hsr_del_nodes(struct list_head *node_db)
@@ -130,30 +131,43 @@ void hsr_del_nodes(struct list_head *node_db)
  * seq_out is used to initialize filtering of outgoing duplicate frames
  * originating from the newly added node.
  */
-struct hsr_node *hsr_add_node(struct list_head *node_db, unsigned char addr[],
-			      u16 seq_out)
+static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
+				     struct list_head *node_db,
+				     unsigned char addr[],
+				     u16 seq_out)
 {
-	struct hsr_node *node;
+	struct hsr_node *new_node, *node;
 	unsigned long now;
 	int i;
 
-	node = kzalloc(sizeof(*node), GFP_ATOMIC);
-	if (!node)
+	new_node = kzalloc(sizeof(*new_node), GFP_ATOMIC);
+	if (!new_node)
 		return NULL;
 
-	ether_addr_copy(node->macaddress_A, addr);
+	ether_addr_copy(new_node->macaddress_A, addr);
 
 	/* We are only interested in time diffs here, so use current jiffies
 	 * as initialization. (0 could trigger an spurious ring error warning).
 	 */
 	now = jiffies;
 	for (i = 0; i < HSR_PT_PORTS; i++)
-		node->time_in[i] = now;
+		new_node->time_in[i] = now;
 	for (i = 0; i < HSR_PT_PORTS; i++)
-		node->seq_out[i] = seq_out;
-
-	list_add_tail_rcu(&node->mac_list, node_db);
+		new_node->seq_out[i] = seq_out;
 
+	spin_lock_bh(&hsr->list_lock);
+	list_for_each_entry_rcu(node, node_db, mac_list) {
+		if (ether_addr_equal(node->macaddress_A, addr))
+			goto out;
+		if (ether_addr_equal(node->macaddress_B, addr))
+			goto out;
+	}
+	list_add_tail_rcu(&new_node->mac_list, node_db);
+	spin_unlock_bh(&hsr->list_lock);
+	return new_node;
+out:
+	spin_unlock_bh(&hsr->list_lock);
+	kfree(new_node);
 	return node;
 }
 
@@ -163,6 +177,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 			      bool is_sup)
 {
 	struct list_head *node_db = &port->hsr->node_db;
+	struct hsr_priv *hsr = port->hsr;
 	struct hsr_node *node;
 	struct ethhdr *ethhdr;
 	u16 seq_out;
@@ -196,7 +211,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 		seq_out = HSR_SEQNR_START;
 	}
 
-	return hsr_add_node(node_db, ethhdr->h_source, seq_out);
+	return hsr_add_node(hsr, node_db, ethhdr->h_source, seq_out);
 }
 
 /* Use the Supervision frame's info about an eventual macaddress_B for merging
@@ -206,10 +221,11 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 			  struct hsr_port *port_rcv)
 {
-	struct ethhdr *ethhdr;
-	struct hsr_node *node_real;
+	struct hsr_priv *hsr = port_rcv->hsr;
 	struct hsr_sup_payload *hsr_sp;
+	struct hsr_node *node_real;
 	struct list_head *node_db;
+	struct ethhdr *ethhdr;
 	int i;
 
 	ethhdr = (struct ethhdr *)skb_mac_header(skb);
@@ -231,7 +247,7 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 	node_real = find_node_by_addr_A(node_db, hsr_sp->macaddress_A);
 	if (!node_real)
 		/* No frame received from AddrA of this node yet */
-		node_real = hsr_add_node(node_db, hsr_sp->macaddress_A,
+		node_real = hsr_add_node(hsr, node_db, hsr_sp->macaddress_A,
 					 HSR_SEQNR_START - 1);
 	if (!node_real)
 		goto done; /* No mem */
@@ -252,7 +268,9 @@ void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
 	}
 	node_real->addr_B_port = port_rcv->type;
 
+	spin_lock_bh(&hsr->list_lock);
 	list_del_rcu(&node_curr->mac_list);
+	spin_unlock_bh(&hsr->list_lock);
 	kfree_rcu(node_curr, rcu_head);
 
 done:
@@ -368,12 +386,13 @@ void hsr_prune_nodes(struct timer_list *t)
 {
 	struct hsr_priv *hsr = from_timer(hsr, t, prune_timer);
 	struct hsr_node *node;
+	struct hsr_node *tmp;
 	struct hsr_port *port;
 	unsigned long timestamp;
 	unsigned long time_a, time_b;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(node, &hsr->node_db, mac_list) {
+	spin_lock_bh(&hsr->list_lock);
+	list_for_each_entry_safe(node, tmp, &hsr->node_db, mac_list) {
 		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
 		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
 		 * the master port. Thus the master node will be repeatedly
@@ -421,7 +440,7 @@ void hsr_prune_nodes(struct timer_list *t)
 			kfree_rcu(node, rcu_head);
 		}
 	}
-	rcu_read_unlock();
+	spin_unlock_bh(&hsr->list_lock);
 
 	/* Restart timer */
 	mod_timer(&hsr->prune_timer,
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index 89a3ce38151d..0f0fa12b4329 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -12,10 +12,8 @@
 
 struct hsr_node;
 
-void hsr_del_self_node(struct list_head *self_node_db);
+void hsr_del_self_node(struct hsr_priv *hsr);
 void hsr_del_nodes(struct list_head *node_db);
-struct hsr_node *hsr_add_node(struct list_head *node_db, unsigned char addr[],
-			      u16 seq_out);
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
 			      bool is_sup);
 void hsr_handle_sup_frame(struct sk_buff *skb, struct hsr_node *node_curr,
@@ -33,7 +31,7 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 
 void hsr_prune_nodes(struct timer_list *t);
 
-int hsr_create_self_node(struct list_head *self_node_db,
+int hsr_create_self_node(struct hsr_priv *hsr,
 			 unsigned char addr_a[ETH_ALEN],
 			 unsigned char addr_b[ETH_ALEN]);
 
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index ea23eb7408e4..d2ee7125a7f1 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -67,7 +67,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 
 		/* Make sure we recognize frames from ourselves in hsr_rcv() */
 		port = hsr_port_get_hsr(hsr, HSR_PT_SLAVE_B);
-		res = hsr_create_self_node(&hsr->self_node_db,
+		res = hsr_create_self_node(hsr,
 					   master->dev->dev_addr,
 					   port ?
 						port->dev->dev_addr :
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 8d885bc6a54d..d40de84a637f 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -160,8 +160,9 @@ struct hsr_priv {
 	int announce_count;
 	u16 sequence_nr;
 	u16 sup_sequence_nr;	/* For HSRv1 separate seq_nr for supervision */
-	u8 prot_version;		/* Indicate if HSRv0 or HSRv1. */
-	spinlock_t seqnr_lock;			/* locking for sequence_nr */
+	u8 prot_version;	/* Indicate if HSRv0 or HSRv1. */
+	spinlock_t seqnr_lock;	/* locking for sequence_nr */
+	spinlock_t list_lock;	/* locking for node list */
 	unsigned char		sup_multicast_addr[ETH_ALEN];
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
-- 
2.17.1

