Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F217213B12
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfEDQGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:06:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42827 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:06:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id p6so4238732pgh.9;
        Sat, 04 May 2019 09:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Pbh75MA0Sc6gp7xSNI1N6ulWiMO3topHIlqyybYORk=;
        b=ujBv4g1EPRhTfClJyCNyPoIFSL850khbJO9cXz5FgEDJ20jluy7/OKsJ62A0NiJF8S
         KE98s1HyJH9sXpxHFKkYciw/IricSL3MU/M2SlVKgp6Yvdw+ovPPxcr/CVwM85eDHq8s
         HE4dOSlWEgZ+pGfJqGp4sGv0mOpPao7bstY7vi/ZLnUfknM6vtYw8u3LVqL0TF5Yl74q
         O+iIqa7NcAmt9CZsefssxwxoboDo1LYwc14lemNEfrXLgiKGKsDFi1VQC/JI5KWh15nF
         fagxF75cb7DJXjWH54BiHglbjbkRJ1XLsx1vqvdboDe4gdG30WR5IKj46h7t0MtND7l+
         5FPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Pbh75MA0Sc6gp7xSNI1N6ulWiMO3topHIlqyybYORk=;
        b=iH0f6hffpNB1aWSZZXNFwoFhP9TNeClHY6G1zprjnWXkRs/BUgQWZAA9sqs/NnVqNh
         tSh5N1waqdmz9Vhd+Wf2vgjJ4aKx+2jiXlDPGgL9TpcOwqWfn2jROcrOO7wAucOTgIvt
         8hrFlZ6fqzK3v78pSSqtcXLkaIVBtZj40SNydzyV0dgCq+6YR81SGBDgZMu7chscOy4P
         ZCTXRxsIoYn/vtFHuPFLHwROHlf5CQZ9WbDVZ7kcNUsHq3qO5mYH3ckFnpe0U9BORmxi
         3TP6FI5oLCI9l7zkhRgdln5OsFiO2plYFtuHGi+Lgg4ETGxp1I5OGZ0ROAbgMzOJtpwP
         QawQ==
X-Gm-Message-State: APjAAAVpPEQY0i+ecEFVYW8i9+0vReITn0RTJxyzYd1S7GNXbeWyUHwc
        ATn/gzWZtjuG7tLEFiC0z+o=
X-Google-Smtp-Source: APXvYqz3IzBdLZSfgmu74omLOH70kLRbmmvA0mcfwdisQcl/c4aftw982u2c3O+JrzkQd79V+vABuA==
X-Received: by 2002:a63:570d:: with SMTP id l13mr19520561pgb.55.1556986013485;
        Sat, 04 May 2019 09:06:53 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id n67sm8032593pfn.22.2019.05.04.09.06.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:06:52 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bruce.richarson@intel.com, bpf@vger.kernel.org,
        Bruce Richardson <bruce.richardson@intel.com>
Subject: [PATCH bpf-next 1/2] xsk: remove AF_XDP socket from map when the socket is released
Date:   Sat,  4 May 2019 18:06:02 +0200
Message-Id: <20190504160603.10173-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504160603.10173-1-bjorn.topel@gmail.com>
References: <20190504160603.10173-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

When an AF_XDP socket is released/closed the XSKMAP still holds a
reference to the socket in a "released" state. The socket will still
use the netdev queue resource, and block newly created sockets from
attaching to that queue, but no user application can access the
fill/complete/rx/tx rings. This results in that all applications need
to explicitly clear the map entry from the old "zombie state"
socket. This should be done automatically.

After this patch, when a socket is released, it will remove itself
from all the XSKMAPs it resides in, allowing the socket application to
remove the code that cleans the XSKMAP entry.

This behavior is also closer to that of SOCKMAP, making the two socket
maps more consistent.

Reported-by: Bruce Richardson <bruce.richardson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h |   3 ++
 kernel/bpf/xskmap.c    | 106 +++++++++++++++++++++++++++++++++++------
 net/xdp/xsk.c          |  25 ++++++++++
 3 files changed, 120 insertions(+), 14 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..b5f8f9f826d0 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -68,6 +68,8 @@ struct xdp_sock {
 	 */
 	spinlock_t tx_completion_lock;
 	u64 rx_dropped;
+	struct list_head map_list;
+	spinlock_t map_list_lock;
 };
 
 struct xdp_buff;
@@ -87,6 +89,7 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
 					  struct xdp_umem_fq_reuse *newq);
 void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
 struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
+void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head *node);
 
 static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
 {
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 686d244e798d..ad15e8e92a87 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -13,8 +13,58 @@ struct xsk_map {
 	struct bpf_map map;
 	struct xdp_sock **xsk_map;
 	struct list_head __percpu *flush_list;
+	spinlock_t lock;
 };
 
+/* Nodes are linked in the struct xdp_sock map_list field, and used to
+ * track which maps a certain socket reside in.
+ */
+struct xsk_map_node {
+	struct list_head node;
+	struct xsk_map *map;
+	struct xdp_sock **map_entry;
+};
+
+static struct xsk_map_node *xsk_map_node_alloc(void)
+{
+	return kzalloc(sizeof(struct xsk_map_node), GFP_ATOMIC | __GFP_NOWARN);
+}
+
+static void xsk_map_node_free(struct xsk_map_node *node)
+{
+	kfree(node);
+}
+
+static void xsk_map_node_init(struct xsk_map_node *node,
+			      struct xsk_map *map,
+			      struct xdp_sock **map_entry)
+{
+	node->map = map;
+	node->map_entry = map_entry;
+}
+
+static void xsk_map_add_node(struct xdp_sock *xs, struct xsk_map_node *node)
+{
+	spin_lock_bh(&xs->map_list_lock);
+	list_add_tail(&node->node, &xs->map_list);
+	spin_unlock_bh(&xs->map_list_lock);
+}
+
+static void xsk_map_del_node(struct xdp_sock *xs, struct xdp_sock **map_entry)
+{
+	struct xsk_map_node *n, *tmp;
+
+	spin_lock_bh(&xs->map_list_lock);
+	list_for_each_entry_safe(n, tmp, &xs->map_list, node) {
+		if (map_entry == n->map_entry) {
+			list_del(&n->node);
+			xsk_map_node_free(n);
+		}
+	}
+	spin_unlock_bh(&xs->map_list_lock);
+
+}
+
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
 	int cpu, err = -EINVAL;
@@ -34,6 +84,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 
 	bpf_map_init_from_attr(&m->map, attr);
+	spin_lock_init(&m->lock);
 
 	cost = (u64)m->map.max_entries * sizeof(struct xdp_sock *);
 	cost += sizeof(struct list_head) * num_possible_cpus();
@@ -70,6 +121,19 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	return ERR_PTR(err);
 }
 
+static void __xsk_map_delete_elem(struct xsk_map *map,
+				  struct xdp_sock **map_entry)
+{
+	struct xdp_sock *old_xs;
+
+	spin_lock_bh(&map->lock);
+	old_xs = xchg(map_entry, NULL);
+	if (old_xs)
+		xsk_map_del_node(old_xs, map_entry);
+	spin_unlock_bh(&map->lock);
+
+}
+
 static void xsk_map_free(struct bpf_map *map)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
@@ -78,15 +142,16 @@ static void xsk_map_free(struct bpf_map *map)
 	bpf_clear_redirect_map(map);
 	synchronize_net();
 
+	spin_lock_bh(&m->lock);
 	for (i = 0; i < map->max_entries; i++) {
+		struct xdp_sock **entry = &m->xsk_map[i];
 		struct xdp_sock *xs;
 
-		xs = m->xsk_map[i];
-		if (!xs)
-			continue;
-
-		sock_put((struct sock *)xs);
+		xs = xchg(entry, NULL);
+		if (xs)
+			__xsk_map_delete_elem(m, entry);
 	}
+	spin_unlock_bh(&m->lock);
 
 	free_percpu(m->flush_list);
 	bpf_map_area_free(m->xsk_map);
@@ -162,7 +227,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 	u32 i = *(u32 *)key, fd = *(u32 *)value;
-	struct xdp_sock *xs, *old_xs;
+	struct xdp_sock *xs, *old_xs, **entry;
+	struct xsk_map_node *node;
 	struct socket *sock;
 	int err;
 
@@ -189,11 +255,20 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EOPNOTSUPP;
 	}
 
-	sock_hold(sock->sk);
+	node = xsk_map_node_alloc();
+	if (!node) {
+		sockfd_put(sock);
+		return -ENOMEM;
+	}
 
-	old_xs = xchg(&m->xsk_map[i], xs);
+	spin_lock_bh(&m->lock);
+	entry = &m->xsk_map[i];
+	xsk_map_node_init(node, m, entry);
+	xsk_map_add_node(xs, node);
+	old_xs = xchg(entry, xs);
 	if (old_xs)
-		sock_put((struct sock *)old_xs);
+		xsk_map_del_node(old_xs, entry);
+	spin_unlock_bh(&m->lock);
 
 	sockfd_put(sock);
 	return 0;
@@ -202,19 +277,22 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct xdp_sock *old_xs;
 	int k = *(u32 *)key;
 
 	if (k >= map->max_entries)
 		return -EINVAL;
 
-	old_xs = xchg(&m->xsk_map[k], NULL);
-	if (old_xs)
-		sock_put((struct sock *)old_xs);
-
+	__xsk_map_delete_elem(m, &m->xsk_map[k]);
 	return 0;
 }
 
+void xsk_map_delete_from_node(struct xdp_sock *xs, struct list_head *node)
+{
+	struct xsk_map_node *n = list_entry(node, struct xsk_map_node, node);
+
+	__xsk_map_delete_elem(n->map, n->map_entry);
+}
+
 const struct bpf_map_ops xsk_map_ops = {
 	.map_alloc = xsk_map_alloc,
 	.map_free = xsk_map_free,
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..1931d98a7754 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -335,6 +335,27 @@ static int xsk_init_queue(u32 entries, struct xsk_queue **queue,
 	return 0;
 }
 
+static struct list_head *xsk_map_list_pop(struct xdp_sock *xs)
+{
+	struct list_head *node = NULL;
+
+	spin_lock_bh(&xs->map_list_lock);
+	if (!list_empty(&xs->map_list)) {
+		node = xs->map_list.next;
+		list_del(node);
+	}
+	spin_unlock_bh(&xs->map_list_lock);
+	return node;
+}
+
+static void xsk_delete_from_maps(struct xdp_sock *xs)
+{
+	struct list_head *node;
+
+	while ((node = xsk_map_list_pop(xs)))
+		xsk_map_delete_from_node(xs, node);
+}
+
 static int xsk_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -354,6 +375,7 @@ static int xsk_release(struct socket *sock)
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
 	local_bh_enable();
 
+	xsk_delete_from_maps(xs);
 	if (xs->dev) {
 		struct net_device *dev = xs->dev;
 
@@ -767,6 +789,9 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	mutex_init(&xs->mutex);
 	spin_lock_init(&xs->tx_completion_lock);
 
+	INIT_LIST_HEAD(&xs->map_list);
+	spin_lock_init(&xs->map_list_lock);
+
 	mutex_lock(&net->xdp.lock);
 	sk_add_node_rcu(sk, &net->xdp.list);
 	mutex_unlock(&net->xdp.lock);
-- 
2.20.1

