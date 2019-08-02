Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837847EE7C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403900AbfHBIMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:12:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43576 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403812AbfHBIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:12:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so35634311pfg.10;
        Fri, 02 Aug 2019 01:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7y8/k1WJ13LiLJ8t/pEsQb/rnx57udaYAH47tsYlDHI=;
        b=Hov+Q17tbzGZWVlBAeKpJxsRtrRGKHanLCKAdxU/SuciQiNoubVJvec5tuL9mfsV5S
         mY35S6wMF24aD8JwxlB0VG5Z8s+fg31ZaO2fjcCNTPVu4rHY5s+Ug7UJW2t3Ul1ANfCV
         DyCfW6gBCtZad4hA5KwYSiOWrGOAXG5dish61pnYSLHPimBE3Yd7xM5HD0N6FBUB9ciq
         W3F8orH2EQGOvOrXI+1N4ZAN9QpytWz904qWKXUegX7+31QYCp/jEHPKSAnsilyCXkeK
         xr3HIzk50heCUbqdoXnFL6+wEH4e31xGOVq2dnGV5mKa3VIxmrMlkVNsOPF3hhUZb4OR
         NUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7y8/k1WJ13LiLJ8t/pEsQb/rnx57udaYAH47tsYlDHI=;
        b=nh4QqFNtPIfi4foAVmUHpaaqB4bJzpkGgyqrbjXkwmbWCRgQYLh/acPwSQgql01IAs
         vqiYNxeFNcVXDTZVHNI4D7YQxK+D0hxYb3tIfCY0SFYqsr/OFNxsNFetft21JcKdTl71
         6ZWToLCO2Z4/ewnKo1kdsKncZQz6T7xXijC70kvP0VNW7ipQdWJIB5fRaDvnhkIdhwSh
         5Qnd2zXeEbHwDd79uR2moGRPNTS18egBwFS3f/uRUZOwy5JCYF2xO5vv2IBrK6uqMCcI
         LBGckkFz+FOHyD9tXTN78My94zMvDc6EbwB3tXE6L4JLZwN7pK8/Yg5i3188WXl/6eys
         WLFQ==
X-Gm-Message-State: APjAAAWXD+KL8d1Js/LKbVeSbcqdmvulqm20BwiINKE+/2Pt8JcSKdQx
        4kmO2ll0YFBfUDTL+Qlz9OI=
X-Google-Smtp-Source: APXvYqxzI5ouWV/Ynz3bRh0k+dtDTanysImgUlZI+93fID1+ROIbhk2cgwpObc/2/M8OJhBS5cph6Q==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr3112447pjs.119.1564733536808;
        Fri, 02 Aug 2019 01:12:16 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id e5sm4054338pgt.91.2019.08.02.01.12.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:12:16 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 1/2] xsk: remove AF_XDP socket from map when the socket is released
Date:   Fri,  2 Aug 2019 10:11:53 +0200
Message-Id: <20190802081154.30962-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802081154.30962-1-bjorn.topel@gmail.com>
References: <20190802081154.30962-1-bjorn.topel@gmail.com>
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
fill/complete/rx/tx queues. This results in that all applications need
to explicitly clear the map entry from the old "zombie state"
socket. This should be done automatically.

In this patch, the sockets tracks, and have a reference to, which maps
it resides in. When the socket is released, it will remove itself from
all maps.

Suggested-by: Bruce Richardson <bruce.richardson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h |  18 +++++++
 kernel/bpf/xskmap.c    | 113 ++++++++++++++++++++++++++++++++++-------
 net/xdp/xsk.c          |  48 +++++++++++++++++
 3 files changed, 160 insertions(+), 19 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 69796d264f06..066e3ae446a8 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -50,6 +50,16 @@ struct xdp_umem {
 	struct list_head xsk_list;
 };
 
+/* Nodes are linked in the struct xdp_sock map_list field, and used to
+ * track which maps a certain socket reside in.
+ */
+struct xsk_map;
+struct xsk_map_node {
+	struct list_head node;
+	struct xsk_map *map;
+	struct xdp_sock **map_entry;
+};
+
 struct xdp_sock {
 	/* struct sock must be the first member of struct xdp_sock */
 	struct sock sk;
@@ -75,6 +85,9 @@ struct xdp_sock {
 	/* Protects generic receive. */
 	spinlock_t rx_lock;
 	u64 rx_dropped;
+	struct list_head map_list;
+	/* Protects map_list */
+	spinlock_t map_list_lock;
 };
 
 struct xdp_buff;
@@ -96,6 +109,11 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
 void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
 struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
 
+void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
+			     struct xdp_sock **map_entry);
+int xsk_map_inc(struct xsk_map *map);
+void xsk_map_put(struct xsk_map *map);
+
 static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
 {
 	return umem->pages[addr >> PAGE_SHIFT].addr + (addr & (PAGE_SIZE - 1));
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 9bb96ace9fa1..780639309f6b 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -13,8 +13,71 @@ struct xsk_map {
 	struct bpf_map map;
 	struct xdp_sock **xsk_map;
 	struct list_head __percpu *flush_list;
+	spinlock_t lock; /* Synchronize map updates */
 };
 
+int xsk_map_inc(struct xsk_map *map)
+{
+	struct bpf_map *m = &map->map;
+
+	m = bpf_map_inc(m, false);
+	return IS_ERR(m) ? PTR_ERR(m) : 0;
+}
+
+void xsk_map_put(struct xsk_map *map)
+{
+	bpf_map_put(&map->map);
+}
+
+static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
+					       struct xdp_sock **map_entry)
+{
+	struct xsk_map_node *node;
+	int err;
+
+	node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
+	if (!node)
+		return NULL;
+
+	err = xsk_map_inc(map);
+	if (err) {
+		kfree(node);
+		return ERR_PTR(err);
+	}
+
+	node->map = map;
+	node->map_entry = map_entry;
+	return node;
+}
+
+static void xsk_map_node_free(struct xsk_map_node *node)
+{
+	xsk_map_put(node->map);
+	kfree(node);
+}
+
+static void xsk_map_sock_add(struct xdp_sock *xs, struct xsk_map_node *node)
+{
+	spin_lock_bh(&xs->map_list_lock);
+	list_add_tail(&node->node, &xs->map_list);
+	spin_unlock_bh(&xs->map_list_lock);
+}
+
+static void xsk_map_sock_delete(struct xdp_sock *xs,
+				struct xdp_sock **map_entry)
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
+}
+
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
 	struct xsk_map *m;
@@ -34,6 +97,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 
 	bpf_map_init_from_attr(&m->map, attr);
+	spin_lock_init(&m->lock);
 
 	cost = (u64)m->map.max_entries * sizeof(struct xdp_sock *);
 	cost += sizeof(struct list_head) * num_possible_cpus();
@@ -71,21 +135,9 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 static void xsk_map_free(struct bpf_map *map)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	int i;
 
 	bpf_clear_redirect_map(map);
 	synchronize_net();
-
-	for (i = 0; i < map->max_entries; i++) {
-		struct xdp_sock *xs;
-
-		xs = m->xsk_map[i];
-		if (!xs)
-			continue;
-
-		sock_put((struct sock *)xs);
-	}
-
 	free_percpu(m->flush_list);
 	bpf_map_area_free(m->xsk_map);
 	kfree(m);
@@ -165,7 +217,8 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 	u32 i = *(u32 *)key, fd = *(u32 *)value;
-	struct xdp_sock *xs, *old_xs;
+	struct xdp_sock *xs, *old_xs, **entry;
+	struct xsk_map_node *node;
 	struct socket *sock;
 	int err;
 
@@ -192,11 +245,19 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EOPNOTSUPP;
 	}
 
-	sock_hold(sock->sk);
+	entry = &m->xsk_map[i];
+	node = xsk_map_node_alloc(m, entry);
+	if (IS_ERR(node)) {
+		sockfd_put(sock);
+		return PTR_ERR(node);
+	}
 
-	old_xs = xchg(&m->xsk_map[i], xs);
+	spin_lock_bh(&m->lock);
+	xsk_map_sock_add(xs, node);
+	old_xs = xchg(entry, xs);
 	if (old_xs)
-		sock_put((struct sock *)old_xs);
+		xsk_map_sock_delete(old_xs, entry);
+	spin_unlock_bh(&m->lock);
 
 	sockfd_put(sock);
 	return 0;
@@ -205,19 +266,33 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct xdp_sock *old_xs;
+	struct xdp_sock *old_xs, **map_entry;
 	int k = *(u32 *)key;
 
 	if (k >= map->max_entries)
 		return -EINVAL;
 
-	old_xs = xchg(&m->xsk_map[k], NULL);
+	spin_lock_bh(&m->lock);
+	map_entry = &m->xsk_map[k];
+	old_xs = xchg(map_entry, NULL);
 	if (old_xs)
-		sock_put((struct sock *)old_xs);
+		xsk_map_sock_delete(old_xs, map_entry);
+	spin_unlock_bh(&m->lock);
 
 	return 0;
 }
 
+void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
+			     struct xdp_sock **map_entry)
+{
+	spin_lock_bh(&map->lock);
+	if (READ_ONCE(*map_entry) == xs) {
+		WRITE_ONCE(*map_entry, NULL);
+		xsk_map_sock_delete(xs, map_entry);
+	}
+	spin_unlock_bh(&map->lock);
+}
+
 const struct bpf_map_ops xsk_map_ops = {
 	.map_alloc = xsk_map_alloc,
 	.map_free = xsk_map_free,
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 59b57d708697..c3447bad608a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -362,6 +362,50 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 	dev_put(dev);
 }
 
+static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
+					      struct xdp_sock ***map_entry)
+{
+	struct xsk_map *map = NULL;
+	struct xsk_map_node *node;
+
+	*map_entry = NULL;
+
+	spin_lock_bh(&xs->map_list_lock);
+	node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
+					node);
+	if (node) {
+		WARN_ON(xsk_map_inc(node->map));
+		map = node->map;
+		*map_entry = node->map_entry;
+	}
+	spin_unlock_bh(&xs->map_list_lock);
+	return map;
+}
+
+static void xsk_delete_from_maps(struct xdp_sock *xs)
+{
+	/* This function removes the current XDP socket from all the
+	 * maps it resides in. We need to take extra care here, due to
+	 * the two locks involved. Each map has a lock synchronizing
+	 * updates to the entries, and each socket has a lock that
+	 * synchronizes access to the list of maps (map_list). For
+	 * deadlock avoidance the locks need to be taken in the order
+	 * "map lock"->"socket map list lock". We start off by
+	 * accessing the socket map list, and take a reference to the
+	 * map to guarantee existence. Then we ask the map to remove
+	 * the socket, which tries to remove the socket from the
+	 * map. Note that there might be updates to the map between
+	 * xsk_get_map_list_entry() and xsk_map_try_sock_delete().
+	 */
+	struct xdp_sock **map_entry = NULL;
+	struct xsk_map *map;
+
+	while ((map = xsk_get_map_list_entry(xs, &map_entry))) {
+		xsk_map_try_sock_delete(map, xs, map_entry);
+		xsk_map_put(map);
+	}
+}
+
 static int xsk_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -381,6 +425,7 @@ static int xsk_release(struct socket *sock)
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
 	local_bh_enable();
 
+	xsk_delete_from_maps(xs);
 	xsk_unbind_dev(xs);
 
 	xskq_destroy(xs->rx);
@@ -855,6 +900,9 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	spin_lock_init(&xs->rx_lock);
 	spin_lock_init(&xs->tx_completion_lock);
 
+	INIT_LIST_HEAD(&xs->map_list);
+	spin_lock_init(&xs->map_list_lock);
+
 	mutex_lock(&net->xdp.lock);
 	sk_add_node_rcu(sk, &net->xdp.list);
 	mutex_unlock(&net->xdp.lock);
-- 
2.20.1

