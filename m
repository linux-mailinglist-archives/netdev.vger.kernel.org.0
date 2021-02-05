Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860C31051C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhBEGrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhBEGpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:45:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B7F64F9D;
        Fri,  5 Feb 2021 06:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507455;
        bh=mrsmtxf/xKXkwA5f3Xgb+frPcv8s9DSjUz58ZaugFOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqmaPuFXQ3C5IBwPVKM2a9qZm4gJlP5TTj/Pa/ixb6ICzXDNAyHeGMlkfuEASnwiX
         onf893h7h+JyDeUy6Z4j1fQrezdHBEva1APTWN8Lzw+ZYovN7CVP64x1NWF4x+k8r8
         4j/yaPL0kVrQm374PO2tf3Ex51JMo/ujkWNyErj14GNGWcgf+4Qzn8k/gYoMZuzJ7/
         zQgvmMxg5Q8YM5ac2KKC0wZOKJvr0qP7fOSDwM2u1PG4XY0KWoXRjBebDSc0FXKsVC
         V84cZ+mppSgFCtANgTJhQW6aZIxIrre6JnuacYqEi7cAm/5TWIW69YNN5wXjs9rmbU
         QdH0TWlXq9alw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/17] net/mlx5e: Refactor neigh update infrastructure
Date:   Thu,  4 Feb 2021 22:40:48 -0800
Message-Id: <20210205064051.89592-15-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series implements route update which can cause encap
entries to migrate between routing devices. Consecutively, their parent
nhe's need to be also transferable between devices instead of having neigh
device as a part of their immutable key. Move neigh device from struct
mlx5_neigh to struct mlx5e_neigh_hash_entry and check that nhe and neigh
devices are the same in workqueue neigh update handler.

Save neigh net_device that can change dynamically in dedicated nhe->dev
field. With FIB event handler that is implemented in following patches
changing nhe->dev, NETEVENT_DELAY_PROBE_TIME_UPDATE handler can
concurrently access the nhe entry when traversing neigh list under rcu read
lock. Processing stale values in that handler doesn't change the handler
logic, so just wrap all accesses to the dev pointer in {WRITE|READ}_ONCE()
helpers.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/diag/en_rep_tracepoint.h        |  4 ++--
 .../mlx5/core/diag/en_tc_tracepoint.h         |  4 ++--
 .../mellanox/mlx5/core/en/rep/neigh.c         | 16 +++++++++-----
 .../mellanox/mlx5/core/en/rep/neigh.h         |  3 ++-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  8 ++++---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.h   |  4 +++-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 22 +++++++------------
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  3 +--
 9 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
index 1177860a2ee4..f15718db5d0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
@@ -15,7 +15,7 @@ TRACE_EVENT(mlx5e_rep_neigh_update,
 	    TP_PROTO(const struct mlx5e_neigh_hash_entry *nhe, const u8 *ha,
 		     bool neigh_connected),
 	    TP_ARGS(nhe, ha, neigh_connected),
-	    TP_STRUCT__entry(__string(devname, nhe->m_neigh.dev->name)
+	    TP_STRUCT__entry(__string(devname, nhe->neigh_dev->name)
 			     __array(u8, ha, ETH_ALEN)
 			     __array(u8, v4, 4)
 			     __array(u8, v6, 16)
@@ -25,7 +25,7 @@ TRACE_EVENT(mlx5e_rep_neigh_update,
 			struct in6_addr *pin6;
 			__be32 *p32;
 
-			__assign_str(devname, mn->dev->name);
+			__assign_str(devname, nhe->neigh_dev->name);
 			__entry->neigh_connected = neigh_connected;
 			memcpy(__entry->ha, ha, ETH_ALEN);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
index d4e6cfaaade3..ac52ef37f38a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
@@ -77,7 +77,7 @@ TRACE_EVENT(mlx5e_stats_flower,
 TRACE_EVENT(mlx5e_tc_update_neigh_used_value,
 	    TP_PROTO(const struct mlx5e_neigh_hash_entry *nhe, bool neigh_used),
 	    TP_ARGS(nhe, neigh_used),
-	    TP_STRUCT__entry(__string(devname, nhe->m_neigh.dev->name)
+	    TP_STRUCT__entry(__string(devname, nhe->neigh_dev->name)
 			     __array(u8, v4, 4)
 			     __array(u8, v6, 16)
 			     __field(bool, neigh_used)
@@ -86,7 +86,7 @@ TRACE_EVENT(mlx5e_tc_update_neigh_used_value,
 			struct in6_addr *pin6;
 			__be32 *p32;
 
-			__assign_str(devname, mn->dev->name);
+			__assign_str(devname, nhe->neigh_dev->name);
 			__entry->neigh_used = neigh_used;
 
 			p32 = (__be32 *)__entry->v4;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
index 616ee585a985..be0ee03de721 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -129,10 +129,10 @@ static void mlx5e_rep_neigh_update(struct work_struct *work)
 							     work);
 	struct mlx5e_neigh_hash_entry *nhe = update_work->nhe;
 	struct neighbour *n = update_work->n;
+	bool neigh_connected, same_dev;
 	struct mlx5e_encap_entry *e;
 	unsigned char ha[ETH_ALEN];
 	struct mlx5e_priv *priv;
-	bool neigh_connected;
 	u8 nud_state, dead;
 
 	rtnl_lock();
@@ -146,12 +146,16 @@ static void mlx5e_rep_neigh_update(struct work_struct *work)
 	memcpy(ha, n->ha, ETH_ALEN);
 	nud_state = n->nud_state;
 	dead = n->dead;
+	same_dev = READ_ONCE(nhe->neigh_dev) == n->dev;
 	read_unlock_bh(&n->lock);
 
 	neigh_connected = (nud_state & NUD_VALID) && !dead;
 
 	trace_mlx5e_rep_neigh_update(nhe, ha, neigh_connected);
 
+	if (!same_dev)
+		goto out;
+
 	list_for_each_entry(e, &nhe->encap_list, encap_list) {
 		if (!mlx5e_encap_take(e))
 			continue;
@@ -160,6 +164,7 @@ static void mlx5e_rep_neigh_update(struct work_struct *work)
 		mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
 		mlx5e_encap_put(priv, e);
 	}
+out:
 	rtnl_unlock();
 	mlx5e_release_neigh_update_work(update_work);
 }
@@ -175,7 +180,6 @@ static struct neigh_update_work *mlx5e_alloc_neigh_update_work(struct mlx5e_priv
 	if (WARN_ON(!update_work))
 		return NULL;
 
-	m_neigh.dev = n->dev;
 	m_neigh.family = n->ops->family;
 	memcpy(&m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
 
@@ -246,7 +250,7 @@ static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 		rcu_read_lock();
 		list_for_each_entry_rcu(nhe, &neigh_update->neigh_list,
 					neigh_list) {
-			if (p->dev == nhe->m_neigh.dev) {
+			if (p->dev == READ_ONCE(nhe->neigh_dev)) {
 				found = true;
 				break;
 			}
@@ -369,7 +373,8 @@ mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
 }
 
 int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh *m_neigh,
+				 struct net_device *neigh_dev,
 				 struct mlx5e_neigh_hash_entry **nhe)
 {
 	int err;
@@ -379,10 +384,11 @@ int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
 		return -ENOMEM;
 
 	(*nhe)->priv = priv;
-	memcpy(&(*nhe)->m_neigh, &e->m_neigh, sizeof(e->m_neigh));
+	memcpy(&(*nhe)->m_neigh, m_neigh, sizeof(*m_neigh));
 	spin_lock_init(&(*nhe)->encap_list_lock);
 	INIT_LIST_HEAD(&(*nhe)->encap_list);
 	refcount_set(&(*nhe)->refcnt, 1);
+	WRITE_ONCE((*nhe)->neigh_dev, neigh_dev);
 
 	err = mlx5e_rep_neigh_entry_insert(priv, *nhe);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
index 32b239189c95..6fe0ab970943 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
@@ -16,7 +16,8 @@ struct mlx5e_neigh_hash_entry *
 mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
 			     struct mlx5e_neigh *m_neigh);
 int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh *m_neigh,
+				 struct net_device *neigh_dev,
 				 struct mlx5e_neigh_hash_entry **nhe);
 void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 14bcebd4a0b6..a7ba1c84371d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -26,7 +26,9 @@ struct mlx5e_rep_indr_block_priv {
 };
 
 int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e)
+				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh *m_neigh,
+				 struct net_device *neigh_dev)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
@@ -39,9 +41,9 @@ int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
 		return err;
 
 	mutex_lock(&rpriv->neigh_update.encap_lock);
-	nhe = mlx5e_rep_neigh_entry_lookup(priv, &e->m_neigh);
+	nhe = mlx5e_rep_neigh_entry_lookup(priv, m_neigh);
 	if (!nhe) {
-		err = mlx5e_rep_neigh_entry_create(priv, e, &nhe);
+		err = mlx5e_rep_neigh_entry_create(priv, m_neigh, neigh_dev, &nhe);
 		if (err) {
 			mutex_unlock(&rpriv->neigh_update.encap_lock);
 			mlx5_tun_entropy_refcount_dec(tun_entropy,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
index fdf9702c2d7d..d0661578467b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
@@ -27,7 +27,9 @@ void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 			    unsigned char ha[ETH_ALEN]);
 
 int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e);
+				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh *m_neigh,
+				 struct net_device *neigh_dev);
 void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 				  struct mlx5e_encap_entry *e);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index def2335c39e4..0ad22f5709a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -212,6 +212,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	struct mlx5e_neigh m_neigh = {};
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	int ipv4_encap_size;
 	char *encap_header;
@@ -247,12 +248,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 		goto release_neigh;
 	}
 
-	/* used by mlx5e_detach_encap to lookup a neigh hash table
-	 * entry in the neigh hash table when a user deletes a rule
-	 */
-	e->m_neigh.dev = attr.n->dev;
-	e->m_neigh.family = attr.n->ops->family;
-	memcpy(&e->m_neigh.dst_ip, attr.n->primary_key, attr.n->tbl->key_len);
+	m_neigh.family = attr.n->ops->family;
+	memcpy(&m_neigh.dst_ip, attr.n->primary_key, attr.n->tbl->key_len);
 	e->out_dev = attr.out_dev;
 	e->route_dev_ifindex = attr.route_dev->ifindex;
 
@@ -261,7 +258,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	 * neigh changes it's validity state, we would find the relevant neigh
 	 * in the hash.
 	 */
-	err = mlx5e_rep_encap_entry_attach(netdev_priv(attr.out_dev), e);
+	err = mlx5e_rep_encap_entry_attach(netdev_priv(attr.out_dev), e, &m_neigh, attr.n->dev);
 	if (err)
 		goto free_encap;
 
@@ -375,6 +372,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	struct mlx5e_neigh m_neigh = {};
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	struct ipv6hdr *ip6h;
 	int ipv6_encap_size;
@@ -409,12 +407,8 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 		goto release_neigh;
 	}
 
-	/* used by mlx5e_detach_encap to lookup a neigh hash table
-	 * entry in the neigh hash table when a user deletes a rule
-	 */
-	e->m_neigh.dev = attr.n->dev;
-	e->m_neigh.family = attr.n->ops->family;
-	memcpy(&e->m_neigh.dst_ip, attr.n->primary_key, attr.n->tbl->key_len);
+	m_neigh.family = attr.n->ops->family;
+	memcpy(&m_neigh.dst_ip, attr.n->primary_key, attr.n->tbl->key_len);
 	e->out_dev = attr.out_dev;
 	e->route_dev_ifindex = attr.route_dev->ifindex;
 
@@ -423,7 +417,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	 * neigh changes it's validity state, we would find the relevant neigh
 	 * in the hash.
 	 */
-	err = mlx5e_rep_encap_entry_attach(netdev_priv(attr.out_dev), e);
+	err = mlx5e_rep_encap_entry_attach(netdev_priv(attr.out_dev), e, &m_neigh, attr.n->dev);
 	if (err)
 		goto free_encap;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 75fcffecfe3d..577216744a17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -310,7 +310,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 		/* find the relevant neigh according to the cached device and
 		 * dst ip pair
 		 */
-		n = neigh_lookup(tbl, &m_neigh->dst_ip, m_neigh->dev);
+		n = neigh_lookup(tbl, &m_neigh->dst_ip, READ_ONCE(nhe->neigh_dev));
 		if (!n)
 			return;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 8e04126f088a..e947921a2d5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -110,7 +110,6 @@ struct mlx5e_rep_priv *mlx5e_rep_to_rep_priv(struct mlx5_eswitch_rep *rep)
 }
 
 struct mlx5e_neigh {
-	struct net_device *dev;
 	union {
 		__be32	v4;
 		struct in6_addr v6;
@@ -122,6 +121,7 @@ struct mlx5e_neigh_hash_entry {
 	struct rhash_head rhash_node;
 	struct mlx5e_neigh m_neigh;
 	struct mlx5e_priv *priv;
+	struct net_device *neigh_dev;
 
 	/* Save the neigh hash entry in a list on the representor in
 	 * addition to the hash table. In order to iterate easily over the
@@ -175,7 +175,6 @@ struct mlx5e_encap_entry {
 	struct mlx5e_neigh_hash_entry *nhe;
 	/* neigh hash entry list of encaps sharing the same neigh */
 	struct list_head encap_list;
-	struct mlx5e_neigh m_neigh;
 	/* a node of the eswitch encap hash table which keeping all the encap
 	 * entries
 	 */
-- 
2.29.2

