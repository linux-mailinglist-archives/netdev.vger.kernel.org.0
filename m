Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CF311B65
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhBFFMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhBFFGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739DC64FAD;
        Sat,  6 Feb 2021 05:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587768;
        bh=SYdjmXT8A8oPrNYNjjwRd82j5jFH9105k+cFuJ5Y4nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKUMRvqv2TZBH5fiLJsMtAlLTPkbHEECTS9ggPIBTBske48bct8uoUWWMlMDSImQw
         s3sBUIBzvmGIobz+Dyw/oP3m7KxmXiNG29rWtmu+fLAj4mv5wN1qrehrM454IAupF6
         Wd5jeTR8LvNtoj5G23VpiLbTvLNW882XqG8pGicxNCEBimAulZY6gv+o1bHa8UhZQp
         f/wKX3dvXriGRTKlLm0vKypWAscfGqSiY1y2kYTIfU73FJ0JNXuwUKqzk/MCmQyhG9
         ZdA+N/+XVBjcHlRTpHt2GNEavsf4SJiPn/rCZVLJEZuaMqfzNF/qAJCc7TQltZQu4Z
         O5H5Bc/e3FWAA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 15/17] net/mlx5e: TC preparation refactoring for routing update event
Date:   Fri,  5 Feb 2021 21:02:38 -0800
Message-Id: <20210206050240.48410-16-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patch in series implement routing update event which requires
ability to modify rule match_to_reg modify header actions dynamically
during rule lifetime. In order to accommodate such behavior, refactor and
extend TC infrastructure in following ways:

- Modify mod_hdr infrastructure to preserve its parse attribute for whole
rule lifetime, instead of deallocating it after rule creation.

- Extend match_to_reg infrastructure with new function
mlx5e_tc_match_to_reg_set_and_get_id() that returns mod_hdr action id that
can be used afterwards to update the action, and
mlx5e_tc_match_to_reg_mod_hdr_change() that can modify existing actions by
its id.

- Extend tun API with new functions mlx5e_tc_tun_update_header_ipv{4|6}()
that are used to updated existing encap entry tunnel header.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |   1 -
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 198 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  10 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  73 ++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  15 ++
 5 files changed, 288 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 3fb75dcdc68d..0b503ebe59ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1763,7 +1763,6 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
 		goto err_set_registers;
 	}
 
-	dealloc_mod_hdr_actions(mod_acts);
 	pre_ct_attr->modify_hdr = mod_hdr;
 	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 0ad22f5709a1..f8075a604605 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -318,6 +318,105 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	return err;
 }
 
+int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
+				    struct net_device *mirred_dev,
+				    struct mlx5e_encap_entry *e)
+{
+	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
+	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	TC_TUN_ROUTE_ATTR_INIT(attr);
+	int ipv4_encap_size;
+	char *encap_header;
+	struct iphdr *ip;
+	u8 nud_state;
+	int err;
+
+	/* add the IP fields */
+	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
+	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
+	attr.ttl = tun_key->ttl;
+
+	err = mlx5e_route_lookup_ipv4_get(priv, mirred_dev, &attr);
+	if (err)
+		return err;
+
+	ipv4_encap_size =
+		(is_vlan_dev(attr.route_dev) ? VLAN_ETH_HLEN : ETH_HLEN) +
+		sizeof(struct iphdr) +
+		e->tunnel->calc_hlen(e);
+
+	if (max_encap_size < ipv4_encap_size) {
+		mlx5_core_warn(priv->mdev, "encap size %d too big, max supported is %d\n",
+			       ipv4_encap_size, max_encap_size);
+		err = -EOPNOTSUPP;
+		goto release_neigh;
+	}
+
+	encap_header = kzalloc(ipv4_encap_size, GFP_KERNEL);
+	if (!encap_header) {
+		err = -ENOMEM;
+		goto release_neigh;
+	}
+
+	e->route_dev_ifindex = attr.route_dev->ifindex;
+
+	read_lock_bh(&attr.n->lock);
+	nud_state = attr.n->nud_state;
+	ether_addr_copy(e->h_dest, attr.n->ha);
+	WRITE_ONCE(e->nhe->neigh_dev, attr.n->dev);
+	read_unlock_bh(&attr.n->lock);
+
+	/* add ethernet header */
+	ip = (struct iphdr *)gen_eth_tnl_hdr(encap_header, attr.route_dev, e,
+					     ETH_P_IP);
+
+	/* add ip header */
+	ip->tos = tun_key->tos;
+	ip->version = 0x4;
+	ip->ihl = 0x5;
+	ip->ttl = attr.ttl;
+	ip->daddr = attr.fl.fl4.daddr;
+	ip->saddr = attr.fl.fl4.saddr;
+
+	/* add tunneling protocol header */
+	err = mlx5e_gen_ip_tunnel_header((char *)ip + sizeof(struct iphdr),
+					 &ip->protocol, e);
+	if (err)
+		goto free_encap;
+
+	e->encap_size = ipv4_encap_size;
+	kfree(e->encap_header);
+	e->encap_header = encap_header;
+
+	if (!(nud_state & NUD_VALID)) {
+		neigh_event_send(attr.n, NULL);
+		/* the encap entry will be made valid on neigh update event
+		 * and not used before that.
+		 */
+		goto release_neigh;
+	}
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
+						     e->reformat_type,
+						     ipv4_encap_size, encap_header,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(e->pkt_reformat)) {
+		err = PTR_ERR(e->pkt_reformat);
+		goto free_encap;
+	}
+
+	e->flags |= MLX5_ENCAP_ENTRY_VALID;
+	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
+	mlx5e_route_lookup_ipv4_put(&attr);
+	return err;
+
+free_encap:
+	kfree(encap_header);
+release_neigh:
+	mlx5e_route_lookup_ipv4_put(&attr);
+	return err;
+}
+
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
 				       struct net_device *mirred_dev,
@@ -476,6 +575,105 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	mlx5e_route_lookup_ipv6_put(&attr);
 	return err;
 }
+
+int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
+				    struct net_device *mirred_dev,
+				    struct mlx5e_encap_entry *e)
+{
+	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
+	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	TC_TUN_ROUTE_ATTR_INIT(attr);
+	struct ipv6hdr *ip6h;
+	int ipv6_encap_size;
+	char *encap_header;
+	u8 nud_state;
+	int err;
+
+	attr.ttl = tun_key->ttl;
+
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
+	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
+
+	err = mlx5e_route_lookup_ipv6_get(priv, mirred_dev, &attr);
+	if (err)
+		return err;
+
+	ipv6_encap_size =
+		(is_vlan_dev(attr.route_dev) ? VLAN_ETH_HLEN : ETH_HLEN) +
+		sizeof(struct ipv6hdr) +
+		e->tunnel->calc_hlen(e);
+
+	if (max_encap_size < ipv6_encap_size) {
+		mlx5_core_warn(priv->mdev, "encap size %d too big, max supported is %d\n",
+			       ipv6_encap_size, max_encap_size);
+		err = -EOPNOTSUPP;
+		goto release_neigh;
+	}
+
+	encap_header = kzalloc(ipv6_encap_size, GFP_KERNEL);
+	if (!encap_header) {
+		err = -ENOMEM;
+		goto release_neigh;
+	}
+
+	e->route_dev_ifindex = attr.route_dev->ifindex;
+
+	read_lock_bh(&attr.n->lock);
+	nud_state = attr.n->nud_state;
+	ether_addr_copy(e->h_dest, attr.n->ha);
+	WRITE_ONCE(e->nhe->neigh_dev, attr.n->dev);
+	read_unlock_bh(&attr.n->lock);
+
+	/* add ethernet header */
+	ip6h = (struct ipv6hdr *)gen_eth_tnl_hdr(encap_header, attr.route_dev, e,
+						 ETH_P_IPV6);
+
+	/* add ip header */
+	ip6_flow_hdr(ip6h, tun_key->tos, 0);
+	/* the HW fills up ipv6 payload len */
+	ip6h->hop_limit   = attr.ttl;
+	ip6h->daddr	  = attr.fl.fl6.daddr;
+	ip6h->saddr	  = attr.fl.fl6.saddr;
+
+	/* add tunneling protocol header */
+	err = mlx5e_gen_ip_tunnel_header((char *)ip6h + sizeof(struct ipv6hdr),
+					 &ip6h->nexthdr, e);
+	if (err)
+		goto free_encap;
+
+	e->encap_size = ipv6_encap_size;
+	kfree(e->encap_header);
+	e->encap_header = encap_header;
+
+	if (!(nud_state & NUD_VALID)) {
+		neigh_event_send(attr.n, NULL);
+		/* the encap entry will be made valid on neigh update event
+		 * and not used before that.
+		 */
+		goto release_neigh;
+	}
+
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
+						     e->reformat_type,
+						     ipv6_encap_size, encap_header,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(e->pkt_reformat)) {
+		err = PTR_ERR(e->pkt_reformat);
+		goto free_encap;
+	}
+
+	e->flags |= MLX5_ENCAP_ENTRY_VALID;
+	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
+	mlx5e_route_lookup_ipv6_put(&attr);
+	return err;
+
+free_encap:
+	kfree(encap_header);
+release_neigh:
+	mlx5e_route_lookup_ipv6_put(&attr);
+	return err;
+}
 #endif
 
 int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 9d6ee9405eaf..fa992e869044 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -59,16 +59,26 @@ int mlx5e_tc_tun_init_encap_attr(struct net_device *tunnel_dev,
 int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e);
+int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
+				    struct net_device *mirred_dev,
+				    struct mlx5e_encap_entry *e);
 
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e);
+int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
+				    struct net_device *mirred_dev,
+				    struct mlx5e_encap_entry *e);
 #else
 static inline int
 mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				struct net_device *mirred_dev,
 				struct mlx5e_encap_entry *e) { return -EOPNOTSUPP; }
+int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
+				    struct net_device *mirred_dev,
+				    struct mlx5e_encap_entry *e)
+{ return -EOPNOTSUPP; }
 #endif
 int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 			      struct mlx5_flow_spec *spec,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2cc31f99db9b..e6150c7597f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -170,11 +170,11 @@ mlx5e_tc_match_to_reg_get_match(struct mlx5_flow_spec *spec,
 }
 
 int
-mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
-			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
-			  enum mlx5_flow_namespace_type ns,
-			  enum mlx5e_tc_attr_to_reg type,
-			  u32 data)
+mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
+				     struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+				     enum mlx5_flow_namespace_type ns,
+				     enum mlx5e_tc_attr_to_reg type,
+				     u32 data)
 {
 	int moffset = mlx5e_tc_attr_to_reg_mappings[type].moffset;
 	int mfield = mlx5e_tc_attr_to_reg_mappings[type].mfield;
@@ -198,9 +198,10 @@ mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 	MLX5_SET(set_action_in, modact, offset, moffset * 8);
 	MLX5_SET(set_action_in, modact, length, mlen * 8);
 	MLX5_SET(set_action_in, modact, data, data);
+	err = mod_hdr_acts->num_actions;
 	mod_hdr_acts->num_actions++;
 
-	return 0;
+	return err;
 }
 
 static struct mlx5_tc_ct_priv *
@@ -249,6 +250,41 @@ mlx5_tc_rule_delete(struct mlx5e_priv *priv,
 	mlx5e_del_offloaded_nic_rule(priv, rule, attr);
 }
 
+int
+mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
+			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			  enum mlx5_flow_namespace_type ns,
+			  enum mlx5e_tc_attr_to_reg type,
+			  u32 data)
+{
+	int ret = mlx5e_tc_match_to_reg_set_and_get_id(mdev, mod_hdr_acts, ns, type, data);
+
+	return ret < 0 ? ret : 0;
+}
+
+void mlx5e_tc_match_to_reg_mod_hdr_change(struct mlx5_core_dev *mdev,
+					  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+					  enum mlx5e_tc_attr_to_reg type,
+					  int act_id, u32 data)
+{
+	int moffset = mlx5e_tc_attr_to_reg_mappings[type].moffset;
+	int mfield = mlx5e_tc_attr_to_reg_mappings[type].mfield;
+	int mlen = mlx5e_tc_attr_to_reg_mappings[type].mlen;
+	char *modact;
+
+	modact = mod_hdr_acts->actions + (act_id * MLX5_MH_ACT_SZ);
+
+	/* Firmware has 5bit length field and 0 means 32bits */
+	if (mlen == 4)
+		mlen = 0;
+
+	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, modact, field, mfield);
+	MLX5_SET(set_action_in, modact, offset, moffset * 8);
+	MLX5_SET(set_action_in, modact, length, mlen * 8);
+	MLX5_SET(set_action_in, modact, data, data);
+}
+
 struct mlx5e_hairpin {
 	struct mlx5_hairpin *pair;
 
@@ -1214,6 +1250,26 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	return err;
 }
 
+int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow_parse_attr *parse_attr,
+			      struct mlx5e_tc_flow *flow)
+{
+	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &parse_attr->mod_hdr_acts;
+	struct mlx5_modify_hdr *mod_hdr;
+
+	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
+					   get_flow_name_space(flow),
+					   mod_hdr_acts->num_actions,
+					   mod_hdr_acts->actions);
+	if (IS_ERR(mod_hdr))
+		return PTR_ERR(mod_hdr);
+
+	WARN_ON(flow->attr->modify_hdr);
+	flow->attr->modify_hdr = mod_hdr;
+
+	return 0;
+}
+
 static int
 mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct mlx5e_tc_flow *flow,
@@ -1293,7 +1349,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
 		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-		dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 		if (err)
 			return err;
 	}
@@ -1376,8 +1431,10 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		dealloc_mod_hdr_actions(&attr->parse_attr->mod_hdr_acts);
 		mlx5e_detach_mod_hdr(priv, flow);
+	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(esw_attr->counter_dev, attr->counter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 5434bbb9a217..9042e64a96ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -214,6 +214,11 @@ int mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 			      enum mlx5e_tc_attr_to_reg type,
 			      u32 data);
 
+void mlx5e_tc_match_to_reg_mod_hdr_change(struct mlx5_core_dev *mdev,
+					  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+					  enum mlx5e_tc_attr_to_reg type,
+					  int act_id, u32 data);
+
 void mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
 				 enum mlx5e_tc_attr_to_reg type,
 				 u32 data,
@@ -224,6 +229,16 @@ void mlx5e_tc_match_to_reg_get_match(struct mlx5_flow_spec *spec,
 				     u32 *data,
 				     u32 *mask);
 
+int mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
+					 struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+					 enum mlx5_flow_namespace_type ns,
+					 enum mlx5e_tc_attr_to_reg type,
+					 u32 data);
+
+int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
+			      struct mlx5e_tc_flow_parse_attr *parse_attr,
+			      struct mlx5e_tc_flow *flow);
+
 int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 			  int namespace,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
-- 
2.29.2

