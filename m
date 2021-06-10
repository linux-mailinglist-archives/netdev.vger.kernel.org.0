Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6E3A2271
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFJDAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhFJDAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6290A61429;
        Thu, 10 Jun 2021 02:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293900;
        bh=7bJiASbB8gAPfnGQtyUoG0Q7kOHxe6YkJKVwUPasGis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E535yM0cXJBvU42ZHEaRyiM36NkuFfMaaFwG2HCBQe5YpsM9qbpgxcF+wIwsHU9xd
         Fp9yajudPrVb17WAfYlS5JuH2IhVhYGUCEX4oJiyKThbnop33qdC8Dxmuk4gp4Zy/b
         s+hj67yCYVXRUPja+ut8ZNtjdZcdk5xvGjNu2waLpfhZhiUgWapef1Mj9HxFwijwNi
         5Z8emgDc/Bx651y/jzpSUqUteK6mrZMyjDgXePDUynVqsD0Gj6JWjWy7Uzluf8wQg0
         owRXwLTwllv0+8kyBuq08his2RLrogsJmrw2d57LgDObBCOPC1vxbvDrvmvk0Hxx5/
         cl9DodAeF11bA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: Added new parameters to reformat context
Date:   Wed,  9 Jun 2021 19:58:02 -0700
Message-Id: <20210610025814.274607-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Adding new reformat context type (INSERT_HEADER) requires adding two new
parameters to reformat context - reformat_param_0 and reformat_param_1.
As defined by HW spec, these parameters have different meaning for
different reformat context type.

The first parameter (reformat_param_0) is not new to HW spec, but it
wasn't used by any of the supported reformats. The second parameter
(reformat_param_1) is new to the HW spec - it was added to allow
supporting INSERT_HEADER.

For NSERT_HEADER, reformat_param_0 indicates the header used to
reference the location of the inserted header, and reformat_param_1
indicates the offset of the inserted header from the reference point
defined by reformat_param_0.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c               |  9 ++++-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 38 +++++++++++++------
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 17 ++++++---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 29 +++++++-------
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  9 ++---
 .../mellanox/mlx5/core/steering/dr_action.c   |  2 +
 .../mellanox/mlx5/core/steering/fs_dr.c       | 17 +++++----
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  2 +
 include/linux/mlx5/fs.h                       | 12 ++++--
 10 files changed, 86 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 2fc6a60c4e77..941adf5cf3d0 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2280,6 +2280,7 @@ static int mlx5_ib_flow_action_create_packet_reformat_ctx(
 	u8 ft_type, u8 dv_prt,
 	void *in, size_t len)
 {
+	struct mlx5_pkt_reformat_params reformat_params;
 	enum mlx5_flow_namespace_type namespace;
 	u8 prm_prt;
 	int ret;
@@ -2292,9 +2293,13 @@ static int mlx5_ib_flow_action_create_packet_reformat_ctx(
 	if (ret)
 		return ret;
 
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = prm_prt;
+	reformat_params.size = len;
+	reformat_params.data = in;
 	maction->flow_action_raw.pkt_reformat =
-		mlx5_packet_reformat_alloc(dev->mdev, prm_prt, len,
-					   in, namespace);
+		mlx5_packet_reformat_alloc(dev->mdev, &reformat_params,
+					   namespace);
 	if (IS_ERR(maction->flow_action_raw.pkt_reformat)) {
 		ret = PTR_ERR(maction->flow_action_raw.pkt_reformat);
 		return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 172e0474f2e6..8f79f04eccd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -212,6 +212,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	struct mlx5_pkt_reformat_params reformat_params;
 	struct mlx5e_neigh m_neigh = {};
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	int ipv4_encap_size;
@@ -295,9 +296,12 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 		 */
 		goto release_neigh;
 	}
-	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     e->reformat_type,
-						     ipv4_encap_size, encap_header,
+
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = e->reformat_type;
+	reformat_params.size = ipv4_encap_size;
+	reformat_params.data = encap_header;
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev, &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
 	if (IS_ERR(e->pkt_reformat)) {
 		err = PTR_ERR(e->pkt_reformat);
@@ -324,6 +328,7 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	struct mlx5_pkt_reformat_params reformat_params;
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	int ipv4_encap_size;
 	char *encap_header;
@@ -396,9 +401,12 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 		 */
 		goto release_neigh;
 	}
-	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     e->reformat_type,
-						     ipv4_encap_size, encap_header,
+
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = e->reformat_type;
+	reformat_params.size = ipv4_encap_size;
+	reformat_params.data = encap_header;
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev, &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
 	if (IS_ERR(e->pkt_reformat)) {
 		err = PTR_ERR(e->pkt_reformat);
@@ -471,6 +479,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	struct mlx5_pkt_reformat_params reformat_params;
 	struct mlx5e_neigh m_neigh = {};
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	struct ipv6hdr *ip6h;
@@ -553,9 +562,11 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 		goto release_neigh;
 	}
 
-	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     e->reformat_type,
-						     ipv6_encap_size, encap_header,
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = e->reformat_type;
+	reformat_params.size = ipv6_encap_size;
+	reformat_params.data = encap_header;
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev, &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
 	if (IS_ERR(e->pkt_reformat)) {
 		err = PTR_ERR(e->pkt_reformat);
@@ -582,6 +593,7 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 {
 	int max_encap_size = MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
+	struct mlx5_pkt_reformat_params reformat_params;
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	struct ipv6hdr *ip6h;
 	int ipv6_encap_size;
@@ -654,9 +666,11 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 		goto release_neigh;
 	}
 
-	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     e->reformat_type,
-						     ipv6_encap_size, encap_header,
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = e->reformat_type;
+	reformat_params.size = ipv6_encap_size;
+	reformat_params.data = encap_header;
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev, &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
 	if (IS_ERR(e->pkt_reformat)) {
 		err = PTR_ERR(e->pkt_reformat);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index f1fb11680d20..0dfd51d2d178 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -120,6 +120,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 			      struct list_head *flow_list)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_pkt_reformat_params reformat_params;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_attr *attr;
@@ -130,9 +131,12 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	if (e->flags & MLX5_ENCAP_ENTRY_NO_ROUTE)
 		return;
 
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = e->reformat_type;
+	reformat_params.size = e->encap_size;
+	reformat_params.data = e->encap_header;
 	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     e->reformat_type,
-						     e->encap_size, e->encap_header,
+						     &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
 	if (IS_ERR(e->pkt_reformat)) {
 		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %lu\n",
@@ -812,6 +816,7 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
+	struct mlx5_pkt_reformat_params reformat_params;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_decap_entry *d;
 	struct mlx5e_decap_key key;
@@ -853,10 +858,12 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	hash_add_rcu(esw->offloads.decap_tbl, &d->hlist, hash_key);
 	mutex_unlock(&esw->offloads.decap_tbl_lock);
 
+	memset(&reformat_params, 0, sizeof(reformat_params));
+	reformat_params.type = MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2;
+	reformat_params.size = sizeof(parse_attr->eth);
+	reformat_params.data = &parse_attr->eth;
 	d->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2,
-						     sizeof(parse_attr->eth),
-						     &parse_attr->eth,
+						     &reformat_params,
 						     MLX5_FLOW_NAMESPACE_FDB);
 	if (IS_ERR(d->pkt_reformat)) {
 		err = PTR_ERR(d->pkt_reformat);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index b7aae8b75760..896a6c3dbdb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -111,9 +111,7 @@ static int mlx5_cmd_stub_delete_fte(struct mlx5_flow_root_namespace *ns,
 }
 
 static int mlx5_cmd_stub_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
-					       int reformat_type,
-					       size_t size,
-					       void *reformat_data,
+					       struct mlx5_pkt_reformat_params *params,
 					       enum mlx5_flow_namespace_type namespace,
 					       struct mlx5_pkt_reformat *pkt_reformat)
 {
@@ -701,9 +699,7 @@ int mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, u32 base_id, int bulk_len,
 }
 
 static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
-					  int reformat_type,
-					  size_t size,
-					  void *reformat_data,
+					  struct mlx5_pkt_reformat_params *params,
 					  enum mlx5_flow_namespace_type namespace,
 					  struct mlx5_pkt_reformat *pkt_reformat)
 {
@@ -721,14 +717,14 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 	else
 		max_encap_size = MLX5_CAP_FLOWTABLE(dev, max_encap_header_size);
 
-	if (size > max_encap_size) {
+	if (params->size > max_encap_size) {
 		mlx5_core_warn(dev, "encap size %zd too big, max supported is %d\n",
-			       size, max_encap_size);
+			       params->size, max_encap_size);
 		return -EINVAL;
 	}
 
-	in = kzalloc(MLX5_ST_SZ_BYTES(alloc_packet_reformat_context_in) + size,
-		     GFP_KERNEL);
+	in = kzalloc(MLX5_ST_SZ_BYTES(alloc_packet_reformat_context_in) +
+		     params->size, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
@@ -737,15 +733,20 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 	reformat = MLX5_ADDR_OF(packet_reformat_context_in,
 				packet_reformat_context_in,
 				reformat_data);
-	inlen = reformat - (void *)in  + size;
+	inlen = reformat - (void *)in + params->size;
 
 	MLX5_SET(alloc_packet_reformat_context_in, in, opcode,
 		 MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT);
 	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
-		 reformat_data_size, size);
+		 reformat_data_size, params->size);
 	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
-		 reformat_type, reformat_type);
-	memcpy(reformat, reformat_data, size);
+		 reformat_type, params->type);
+	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
+		 reformat_param_0, params->param_0);
+	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
+		 reformat_param_1, params->param_1);
+	if (params->data && params->size)
+		memcpy(reformat, params->data, params->size);
 
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index c2e102ed82ad..5ecd33cdc087 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -77,9 +77,7 @@ struct mlx5_flow_cmds {
 			      bool disconnect);
 
 	int (*packet_reformat_alloc)(struct mlx5_flow_root_namespace *ns,
-				     int reformat_type,
-				     size_t size,
-				     void *reformat_data,
+				     struct mlx5_pkt_reformat_params *params,
 				     enum mlx5_flow_namespace_type namespace,
 				     struct mlx5_pkt_reformat *pkt_reformat);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 1b7a1cde097c..c0936b4e53a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3165,9 +3165,7 @@ void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
 EXPORT_SYMBOL(mlx5_modify_header_dealloc);
 
 struct mlx5_pkt_reformat *mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
-						     int reformat_type,
-						     size_t size,
-						     void *reformat_data,
+						     struct mlx5_pkt_reformat_params *params,
 						     enum mlx5_flow_namespace_type ns_type)
 {
 	struct mlx5_pkt_reformat *pkt_reformat;
@@ -3183,9 +3181,8 @@ struct mlx5_pkt_reformat *mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 		return ERR_PTR(-ENOMEM);
 
 	pkt_reformat->ns_type = ns_type;
-	pkt_reformat->reformat_type = reformat_type;
-	err = root->cmds->packet_reformat_alloc(root, reformat_type, size,
-						reformat_data, ns_type,
+	pkt_reformat->reformat_type = params->type;
+	err = root->cmds->packet_reformat_alloc(root, params, ns_type,
 						pkt_reformat);
 	if (err) {
 		kfree(pkt_reformat);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 1b7a0e94d432..13fceba11d3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -937,6 +937,8 @@ struct mlx5dr_action *mlx5dr_action_create_push_vlan(struct mlx5dr_domain *dmn,
 struct mlx5dr_action *
 mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
 				     enum mlx5dr_action_reformat_type reformat_type,
+				     u8 reformat_param_0,
+				     u8 reformat_param_1,
 				     size_t data_sz,
 				     void *data)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index ee0e9d79aaec..d866cd609d0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -289,7 +289,8 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 			DR_ACTION_REFORMAT_TYP_TNL_L2_TO_L2;
 
 		tmp_action = mlx5dr_action_create_packet_reformat(domain,
-								  decap_type, 0,
+								  decap_type,
+								  0, 0, 0,
 								  NULL);
 		if (!tmp_action) {
 			err = -ENOMEM;
@@ -522,9 +523,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 }
 
 static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
-					     int reformat_type,
-					     size_t size,
-					     void *reformat_data,
+					     struct mlx5_pkt_reformat_params *params,
 					     enum mlx5_flow_namespace_type namespace,
 					     struct mlx5_pkt_reformat *pkt_reformat)
 {
@@ -532,7 +531,7 @@ static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns
 	struct mlx5dr_action *action;
 	int dr_reformat;
 
-	switch (reformat_type) {
+	switch (params->type) {
 	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
 	case MLX5_REFORMAT_TYPE_L2_TO_NVGRE:
 	case MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
@@ -546,14 +545,16 @@ static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns
 		break;
 	default:
 		mlx5_core_err(ns->dev, "Packet-reformat not supported(%d)\n",
-			      reformat_type);
+			      params->type);
 		return -EOPNOTSUPP;
 	}
 
 	action = mlx5dr_action_create_packet_reformat(dr_domain,
 						      dr_reformat,
-						      size,
-						      reformat_data);
+						      params->param_0,
+						      params->param_1,
+						      params->size,
+						      params->data);
 	if (!action) {
 		mlx5_core_err(ns->dev, "Failed allocating packet-reformat action\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 612b0ac31db2..8d821bbe3309 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -105,6 +105,8 @@ mlx5dr_action_create_flow_counter(u32 counter_id);
 struct mlx5dr_action *
 mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
 				     enum mlx5dr_action_reformat_type reformat_type,
+				     u8 reformat_param_0,
+				     u8 reformat_param_1,
 				     size_t data_sz,
 				     void *data);
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 1f51f4c3b1af..f69f68fba946 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -254,10 +254,16 @@ struct mlx5_modify_hdr *mlx5_modify_header_alloc(struct mlx5_core_dev *dev,
 void mlx5_modify_header_dealloc(struct mlx5_core_dev *dev,
 				struct mlx5_modify_hdr *modify_hdr);
 
+struct mlx5_pkt_reformat_params {
+	int type;
+	u8 param_0;
+	u8 param_1;
+	size_t size;
+	void *data;
+};
+
 struct mlx5_pkt_reformat *mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
-						     int reformat_type,
-						     size_t size,
-						     void *reformat_data,
+						     struct mlx5_pkt_reformat_params *params,
 						     enum mlx5_flow_namespace_type ns_type);
 void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
 				  struct mlx5_pkt_reformat *reformat);
-- 
2.31.1

