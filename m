Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FABEF3F65
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKHFFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:05:30 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32966 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726307AbfKHFFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:05:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 53AF74AB15;
        Fri,  8 Nov 2019 16:05:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:content-type:content-type
        :mime-version:references:in-reply-to:x-mailer:message-id:date
        :date:subject:subject:from:from:received:received:received; s=
        mail_dkim; t=1573189524; bh=clQnhI9PMmPQMRCO8rZtUokNsD5YbCMgYEAZ
        glXxCWg=; b=h0NdDL59xhZs8Q1idraWTfkCHUpk9kkJpBbytKZSlb3oVocFR+bj
        Z6FHwusQBXybAFXTVpY230czPZ/DeoAoKeUMHQnvz+HzHtPNZp9nitu/5lbRz9PF
        YLh+oRpKpVx62tOMofCL0Diki9fDQ9ASqkVf+uJlFC6dchr4PCsZ9TI=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gt39sGP5OoDd; Fri,  8 Nov 2019 16:05:24 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 3593C4AB1D;
        Fri,  8 Nov 2019 16:05:24 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 268124AB15;
        Fri,  8 Nov 2019 16:05:23 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v2 2/5] tipc: enable creating a "preliminary" node
Date:   Fri,  8 Nov 2019 12:05:09 +0700
Message-Id: <20191108050512.4156-3-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191108050512.4156-1-tuong.t.lien@dektech.com.au>
References: <20191108050512.4156-1-tuong.t.lien@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user sets RX key for a peer not existing on the own node, a new
node entry is needed to which the RX key will be attached. However,
since the peer node address (& capabilities) is unknown at that moment,
only the node-ID is provided, this commit allows the creation of a node
with only the data that we call as =E2=80=9Cpreliminary=E2=80=9D.

A preliminary node is not the object of the =E2=80=9Ctipc_node_find()=E2=80=
=9D but the
=E2=80=9Ctipc_node_find_by_id()=E2=80=9D. Once the first message i.e. LIN=
K_CONFIG comes
from that peer, and is successfully decrypted by the own node, the
actual peer node data will be properly updated and the node will
function as usual.

In addition, the node timer always starts when a node object is created
so if a preliminary node is not used, it will be cleaned up.

The later encryption functions will also use the node timer and be able
to create a preliminary node automatically when needed.

Acked-by: Ying Xue <ying.xue@windreiver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/node.c | 99 +++++++++++++++++++++++++++++++++++++++++----------=
------
 net/tipc/node.h |  1 +
 2 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index b66d2f67b1dd..43d12a630f34 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -89,6 +89,7 @@ struct tipc_bclink_entry {
  * @links: array containing references to all links to node
  * @action_flags: bit mask of different types of node actions
  * @state: connectivity state vs peer node
+ * @preliminary: a preliminary node or not
  * @sync_point: sequence number where synch/failover is finished
  * @list: links to adjacent nodes in sorted list of cluster's nodes
  * @working_links: number of working links to node (both active and stan=
dby)
@@ -112,6 +113,7 @@ struct tipc_node {
 	int action_flags;
 	struct list_head list;
 	int state;
+	bool preliminary;
 	bool failover_sent;
 	u16 sync_point;
 	int link_cnt;
@@ -120,6 +122,7 @@ struct tipc_node {
 	u32 signature;
 	u32 link_id;
 	u8 peer_id[16];
+	char peer_id_string[NODE_ID_STR_LEN];
 	struct list_head publ_list;
 	struct list_head conn_sks;
 	unsigned long keepalive_intv;
@@ -245,6 +248,16 @@ u16 tipc_node_get_capabilities(struct net *net, u32 =
addr)
 	return caps;
 }
=20
+u32 tipc_node_get_addr(struct tipc_node *node)
+{
+	return (node) ? node->addr : 0;
+}
+
+char *tipc_node_get_id_str(struct tipc_node *node)
+{
+	return node->peer_id_string;
+}
+
 static void tipc_node_kref_release(struct kref *kref)
 {
 	struct tipc_node *n =3D container_of(kref, struct tipc_node, kref);
@@ -274,7 +287,7 @@ static struct tipc_node *tipc_node_find(struct net *n=
et, u32 addr)
=20
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(node, &tn->node_htable[thash], hash) {
-		if (node->addr !=3D addr)
+		if (node->addr !=3D addr || node->preliminary)
 			continue;
 		if (!kref_get_unless_zero(&node->kref))
 			node =3D NULL;
@@ -400,17 +413,39 @@ static void tipc_node_assign_peer_net(struct tipc_n=
ode *n, u32 hash_mixes)
=20
 static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
 					  u8 *peer_id, u16 capabilities,
-					  u32 signature, u32 hash_mixes)
+					  u32 hash_mixes, bool preliminary)
 {
 	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
 	struct tipc_node *n, *temp_node;
 	struct tipc_link *l;
+	unsigned long intv;
 	int bearer_id;
 	int i;
=20
 	spin_lock_bh(&tn->node_list_lock);
-	n =3D tipc_node_find(net, addr);
+	n =3D tipc_node_find(net, addr) ?:
+		tipc_node_find_by_id(net, peer_id);
 	if (n) {
+		if (!n->preliminary)
+			goto update;
+		if (preliminary)
+			goto exit;
+		/* A preliminary node becomes "real" now, refresh its data */
+		tipc_node_write_lock(n);
+		n->preliminary =3D false;
+		n->addr =3D addr;
+		hlist_del_rcu(&n->hash);
+		hlist_add_head_rcu(&n->hash,
+				   &tn->node_htable[tipc_hashfn(addr)]);
+		list_del_rcu(&n->list);
+		list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
+			if (n->addr < temp_node->addr)
+				break;
+		}
+		list_add_tail_rcu(&n->list, &temp_node->list);
+		tipc_node_write_unlock_fast(n);
+
+update:
 		if (n->peer_hash_mix ^ hash_mixes)
 			tipc_node_assign_peer_net(n, hash_mixes);
 		if (n->capabilities =3D=3D capabilities)
@@ -438,7 +473,9 @@ static struct tipc_node *tipc_node_create(struct net =
*net, u32 addr,
 		pr_warn("Node creation failed, no memory\n");
 		goto exit;
 	}
+	tipc_nodeid2string(n->peer_id_string, peer_id);
 	n->addr =3D addr;
+	n->preliminary =3D preliminary;
 	memcpy(&n->peer_id, peer_id, 16);
 	n->net =3D net;
 	n->peer_net =3D NULL;
@@ -463,22 +500,14 @@ static struct tipc_node *tipc_node_create(struct ne=
t *net, u32 addr,
 	n->signature =3D INVALID_NODE_SIG;
 	n->active_links[0] =3D INVALID_BEARER_ID;
 	n->active_links[1] =3D INVALID_BEARER_ID;
-	if (!tipc_link_bc_create(net, tipc_own_addr(net),
-				 addr, U16_MAX,
-				 tipc_link_window(tipc_bc_sndlink(net)),
-				 n->capabilities,
-				 &n->bc_entry.inputq1,
-				 &n->bc_entry.namedq,
-				 tipc_bc_sndlink(net),
-				 &n->bc_entry.link)) {
-		pr_warn("Broadcast rcv link creation failed, no memory\n");
-		kfree(n);
-		n =3D NULL;
-		goto exit;
-	}
+	n->bc_entry.link =3D NULL;
 	tipc_node_get(n);
 	timer_setup(&n->timer, tipc_node_timeout, 0);
-	n->keepalive_intv =3D U32_MAX;
+	/* Start a slow timer anyway, crypto needs it */
+	n->keepalive_intv =3D 10000;
+	intv =3D jiffies + msecs_to_jiffies(n->keepalive_intv);
+	if (!mod_timer(&n->timer, intv))
+		tipc_node_get(n);
 	hlist_add_head_rcu(&n->hash, &tn->node_htable[tipc_hashfn(addr)]);
 	list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
 		if (n->addr < temp_node->addr)
@@ -1001,6 +1030,8 @@ u32 tipc_node_try_addr(struct net *net, u8 *id, u32=
 addr)
 {
 	struct tipc_net *tn =3D tipc_net(net);
 	struct tipc_node *n;
+	bool preliminary;
+	u32 sugg_addr;
=20
 	/* Suggest new address if some other peer is using this one */
 	n =3D tipc_node_find(net, addr);
@@ -1016,9 +1047,11 @@ u32 tipc_node_try_addr(struct net *net, u8 *id, u3=
2 addr)
 	/* Suggest previously used address if peer is known */
 	n =3D tipc_node_find_by_id(net, id);
 	if (n) {
-		addr =3D n->addr;
+		sugg_addr =3D n->addr;
+		preliminary =3D n->preliminary;
 		tipc_node_put(n);
-		return addr;
+		if (!preliminary)
+			return sugg_addr;
 	}
=20
 	/* Even this node may be in conflict */
@@ -1035,7 +1068,7 @@ void tipc_node_check_dest(struct net *net, u32 addr=
,
 			  bool *respond, bool *dupl_addr)
 {
 	struct tipc_node *n;
-	struct tipc_link *l;
+	struct tipc_link *l, *snd_l;
 	struct tipc_link_entry *le;
 	bool addr_match =3D false;
 	bool sign_match =3D false;
@@ -1049,12 +1082,27 @@ void tipc_node_check_dest(struct net *net, u32 ad=
dr,
 	*dupl_addr =3D false;
 	*respond =3D false;
=20
-	n =3D tipc_node_create(net, addr, peer_id, capabilities, signature,
-			     hash_mixes);
+	n =3D tipc_node_create(net, addr, peer_id, capabilities, hash_mixes,
+			     false);
 	if (!n)
 		return;
=20
 	tipc_node_write_lock(n);
+	if (unlikely(!n->bc_entry.link)) {
+		snd_l =3D tipc_bc_sndlink(net);
+		if (!tipc_link_bc_create(net, tipc_own_addr(net),
+					 addr, U16_MAX,
+					 tipc_link_window(snd_l),
+					 n->capabilities,
+					 &n->bc_entry.inputq1,
+					 &n->bc_entry.namedq, snd_l,
+					 &n->bc_entry.link)) {
+			pr_warn("Broadcast rcv link creation failed, no mem\n");
+			tipc_node_write_unlock_fast(n);
+			tipc_node_put(n);
+			return;
+		}
+	}
=20
 	le =3D &n->links[b->identity];
=20
@@ -2134,6 +2182,8 @@ int tipc_nl_node_dump(struct sk_buff *skb, struct n=
etlink_callback *cb)
 	}
=20
 	list_for_each_entry_rcu(node, &tn->node_list, list) {
+		if (node->preliminary)
+			continue;
 		if (last_addr) {
 			if (node->addr =3D=3D last_addr)
 				last_addr =3D 0;
@@ -2649,11 +2699,6 @@ int tipc_nl_node_dump_monitor_peer(struct sk_buff =
*skb,
 	return skb->len;
 }
=20
-u32 tipc_node_get_addr(struct tipc_node *node)
-{
-	return (node) ? node->addr : 0;
-}
-
 /**
  * tipc_node_dump - dump TIPC node data
  * @n: tipc node to be dumped
diff --git a/net/tipc/node.h b/net/tipc/node.h
index c39cd861c07d..50f8838b32c2 100644
--- a/net/tipc/node.h
+++ b/net/tipc/node.h
@@ -75,6 +75,7 @@ enum {
 void tipc_node_stop(struct net *net);
 bool tipc_node_get_id(struct net *net, u32 addr, u8 *id);
 u32 tipc_node_get_addr(struct tipc_node *node);
+char *tipc_node_get_id_str(struct tipc_node *node);
 u32 tipc_node_try_addr(struct net *net, u8 *id, u32 addr);
 void tipc_node_check_dest(struct net *net, u32 onode, u8 *peer_id128,
 			  struct tipc_bearer *bearer,
--=20
2.13.7

