Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA38E845
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbfHOJaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:30:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39198 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOJaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:30:39 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so893152pln.6;
        Thu, 15 Aug 2019 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nf+IQABFR+iDwwNUddMdUjg1MymTWCize031vAsvClk=;
        b=JjaibfSrayny4mxx5IPC3WuEfZFcj1GiIvJSpg5zSofutwzqFPb4A/+se9+JqGV/Wg
         G2/LOXiEhGOAGMwnzbeuwRW/jwpc5HLkSvZtdzrOoNT0MyvhkyBAyaYMO7iFCkzrdxf1
         bnzn2GZnFofZb8ziCXOyZE7mAPMGrAhJ3aCJmtXTnQXub+uA25GcM3UgbLpW6+Pmf/H4
         GByqoy9GJ3W2xDNBdn9T0P8WCIOhfMgC5/pulz6dlLKasTVerK3TlfxzqYD0qdX34Kgo
         Pr3QwvN9Mu3ESqTmhj0iEGkDqGINrVSnayD8BD98PQGa2jYtOiTZ4m9TVPADsvKk4cB6
         IHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nf+IQABFR+iDwwNUddMdUjg1MymTWCize031vAsvClk=;
        b=NlV2eclgerp5c2+3QG990hQ77u7QXlj5EWUuBsi/eGKQKQX2dBrxWDpI1bMF2Z90BO
         We4JPJo/PFZGmcB/RiKWJB19c3ali38iOVoHshHdEwl4UEtW8zkdmTqS56/cwnMn1Glm
         wOI3dnr1BwLfsUp1KYI05VLxsfX8DHlYeYcfKFdHT91lvZ8//IZLqk3L9FPbrzWz58VZ
         8s6TYnCLJauZYpzeJWh03aiJFFcIbVgN0lce/IVhrG+O2QEdclcGM3RZK2kNCKA6eDju
         1xqe5jt++gvm9ANTzMPgZSTtET4Hw69iTj9m0LacYl5SQEnYf6ipBIWwvUsvFRdxpH/R
         PTlA==
X-Gm-Message-State: APjAAAXTsv1D3RhXXmHb08M5zMaOuSBNtRqIYMpyOEIYKnu7aIOJO4Zb
        0huLdjOfZUOgIJORR+O1nn0=
X-Google-Smtp-Source: APXvYqxsRgk31LNhHck6+cBtuB+1chCVuiRUHC2BLOMePyYp24tOYDIlwgOdPXbAtdmmYlDg/ReK2w==
X-Received: by 2002:a17:902:b28:: with SMTP id 37mr3523097plq.2.1565861438575;
        Thu, 15 Aug 2019 02:30:38 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g10sm2204195pfb.95.2019.08.15.02.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 02:30:38 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        bruce.richardson@intel.com, songliubraving@fb.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 1/2] xsk: remove AF_XDP socket from map when the socket is released
Date:   Thu, 15 Aug 2019 11:30:13 +0200
Message-Id: <20190815093014.31174-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190815093014.31174-1-bjorn.topel@gmail.com>
References: <20190815093014.31174-1-bjorn.topel@gmail.com>
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
 include/net/xdp_sock.h |  18 ++++++
 kernel/bpf/xskmap.c    | 125 ++++++++++++++++++++++++++++++++++-------
 net/xdp/xsk.c          |  50 +++++++++++++++++
 3 files changed, 173 insertions(+), 20 deletions(-)

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
index 9bb96ace9fa1..16031d489173 100644
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
@@ -164,8 +216,9 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 			       u64 map_flags)
 {
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
+	struct xdp_sock *xs, *old_xs, **map_entry;
 	u32 i = *(u32 *)key, fd = *(u32 *)value;
-	struct xdp_sock *xs, *old_xs;
+	struct xsk_map_node *node;
 	struct socket *sock;
 	int err;
 
@@ -192,32 +245,64 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EOPNOTSUPP;
 	}
 
-	sock_hold(sock->sk);
+	map_entry = &m->xsk_map[i];
+	node = xsk_map_node_alloc(m, map_entry);
+	if (IS_ERR(node)) {
+		sockfd_put(sock);
+		return PTR_ERR(node);
+	}
 
-	old_xs = xchg(&m->xsk_map[i], xs);
+	spin_lock_bh(&m->lock);
+	old_xs = READ_ONCE(*map_entry);
+	if (old_xs == xs) {
+		err = 0;
+		goto out;
+	}
+	xsk_map_sock_add(xs, node);
+	WRITE_ONCE(*map_entry, xs);
 	if (old_xs)
-		sock_put((struct sock *)old_xs);
-
+		xsk_map_sock_delete(old_xs, map_entry);
+	spin_unlock_bh(&m->lock);
 	sockfd_put(sock);
 	return 0;
+
+out:
+	spin_unlock_bh(&m->lock);
+	sockfd_put(sock);
+	xsk_map_node_free(node);
+	return err;
 }
 
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
index 59b57d708697..c3d027aa693d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -362,6 +362,52 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
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
+	 * map to guarantee existence between the
+	 * xsk_get_map_list_entry() and xsk_map_try_sock_delete()
+	 * calls. Then we ask the map to remove the socket, which
+	 * tries to remove the socket from the map. Note that there
+	 * might be updates to the map between
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
@@ -381,6 +427,7 @@ static int xsk_release(struct socket *sock)
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
 	local_bh_enable();
 
+	xsk_delete_from_maps(xs);
 	xsk_unbind_dev(xs);
 
 	xskq_destroy(xs->rx);
@@ -855,6 +902,9 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
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

