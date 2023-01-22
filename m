Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE61676DD7
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjAVO4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAVO4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:56:00 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0731CAEA
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:55:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUhHlb8UhxO4UVLeNSmXf3q+j+JE/C8p6FQ6jpiQwAi5QVmWbuf+lng8ZeqvGmaRuc4eeyLMSpAnLHneIJfeP1T6P9CaKmsf/G2jXGt9n54XDETqy+0l+OO1X7djf6ano13i6K0LWeboErV3T0ZOrY3ntcsHjBzc0tPwSnYVw5tZG2ri1JwikgwahSnpxkARh4Z4oLk9AOErOQb5I/tZdUnByvP3v/qPYrQBLF24GOGaSH5MHVzE93aTulmcQS10FQeT6Oak1k0PItZA4/oSFxe81eXHljtaQTfbOGfdbdwIz7kDKJMrYOfnF6WmHIs6oH40q2EoqiYaaJ7w5JDPHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rm77IZKLy3Yphfxa9WsPLvuhc3qW7PUsq1xWqzLc9nw=;
 b=YVw3pfPGqbcW7I8/q6LZTgo6ytOS/VTsJ6eLvVmFLdnub9P8c/WPQkWzGyog7XFKoSGAu6eEirNjyu571rTOkeT1VzLGBOeqPwC+PaO6GIJTT8IzT0cJhGjv8AedRCq+XXULGxo9oZ2SRyjRoQ4Ch+XCZ/YaOOpLi4WtlpgHJq+qb++pazc3WVamD6OaBVtMbxWaiipOiaX7DCk0bAifLCJgphUmCA4NuZid95Hlugw5gPtZBNsQzt/PoOfrnwMDTLA6C0DogN8Ncsgk/o5FDPrgi0l6otBELvrA0ZyqOTqjmoRLmmGiO6+SybKVZZrE8iKX04lemcHYeoQ2EoIdnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rm77IZKLy3Yphfxa9WsPLvuhc3qW7PUsq1xWqzLc9nw=;
 b=lpJrrDDwj7AvEkIWWRyJUse+1OYAaOc1BFCbaeCL3En6Uo2PI5Y4wuHPXvkdjUm9Iw9ppmmRdl3jDpGcrtFY1WMNXdctW6y+iuna01szSKGKEIg1p5BVfXOHmQc+mYr10lLZ9f2XNPzcaPecOfFTYWsGmKiBRfPDvLjy5FBh0Bsf4CAxXGdVYGvPIKw8MtGTEG/tqaZaKpxn01r/t2zjsjLajhqfKIpZNDeZbf0wMhea+mSLHt70UboD7nUE28qHKWQVkBrPvdDK35gno71V3FrGndn+eB1F1pNNcrQDDi1g1pbkIr+HrPijAGYDITZOWMaof8oxRw9sLuLC+BARQg==
Received: from MW4PR03CA0160.namprd03.prod.outlook.com (2603:10b6:303:8d::15)
 by DM4PR12MB6256.namprd12.prod.outlook.com (2603:10b6:8:a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13; Sun, 22 Jan 2023 14:55:50 +0000
Received: from CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::73) by MW4PR03CA0160.outlook.office365.com
 (2603:10b6:303:8d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.31 via Frontend
 Transport; Sun, 22 Jan 2023 14:55:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT108.mail.protection.outlook.com (10.13.175.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 14:55:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 06:55:47 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 06:55:47 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 22 Jan 2023 06:55:44 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 6/6] net/mlx5: TC, Set CT miss to the specific ct action instance
Date:   Sun, 22 Jan 2023 16:55:12 +0200
Message-ID: <20230122145512.8920-7-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230122145512.8920-1-paulb@nvidia.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT108:EE_|DM4PR12MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: cdf3249d-a50d-4c8f-7fff-08dafc88c027
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6/yGR14NiUsZgl91lxdNkwe9Sa77IacakMS9SkIC1RhAOEjTnZY79MmKcjJKR5RzJ7B8AMoXTO4gYbo964kDG7OQS7TvV+wBWi+ZTYRxWiam2KPJu67yo/xy1BreP6vTU3AoyA9QbYu9qbA2ddzlcQuJn+sfAKAUwS/G9aVPbs3E0BZ7RTg9OB/rMJGwvX8iVZiUIDu0vBUM6CbunLUW7EUGtox7Lo2BoCHnvwksgJ//nSLqqz2tAI0DCjZ/yE+qN5Xe+Ux8NwVe+YVtb/xxtJFW5D/GJ8oyOA9jkuPQyHXSmomIxra94Ib33Dx8jmMZbxbsOwrKKoVhBjMfKnRcNTIuZbHMHTOWW12f2+QD1e3GXao6Z70Jhgt5xKeiZ3LLfjCdB7tEtMjH3SJ9YAw+WM8ragrUP63mOtt4c8ftrDGYmsrC4Wo0OUmCj3haLu0l6FfN43gsBMZvj7VF2gCQBzX1kMBDD0CcyV3PsM9FPMwRlHTZ17vmb0Ar+WhJ+xZRK3wE/trEG9QE1y9EXw0ZSUfl1JjYC4liAvhjQNbjgxAyg9gwvxHrL0dtAkBvIMijzXAF6ZPyFuuua7XMcoMxHiLapATnAY/1j3a7Nvc1sygt1899zGUIu7wdLasdk6qxgI2aIGE0Y5sWEPFLbOVOE5CVGSpqszgVUVXoKVXNkIN0QpRW7etVBI332KC+IT2HrPqXafTNL9ZTdMqCI8F4w==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(66899015)(82310400005)(36756003)(8676002)(478600001)(4326008)(426003)(47076005)(1076003)(2616005)(70586007)(336012)(70206006)(41300700001)(26005)(186003)(86362001)(2906002)(40480700001)(36860700001)(83380400001)(30864003)(82740400003)(54906003)(6666004)(107886003)(40460700003)(110136005)(7636003)(356005)(5660300002)(316002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 14:55:49.5131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf3249d-a50d-4c8f-7fff-08dafc88c027
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6256
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, CT misses restore the missed chain on the tc skb extension so
tc will continue from the relevant chain. Instead, restore the CT action's
miss cookie on the extension, which will instruct tc to continue from the
this specific CT action instance on the relevant filter's action list.

Map the CT action's miss_cookie to a new miss object (ACT_MISS), and use
this miss mapping instead of the current chain miss object (CHAIN_MISS)
for CT action misses.

To restore this new miss mapping value, add a RX restore rule for each
such mapping value.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Sholmo <ozsh@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 32 +++++-----
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 61 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +
 5 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e1a2861cc13ba..71d8a906add97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -59,6 +59,7 @@ struct mlx5_tc_ct_debugfs {
 
 struct mlx5_tc_ct_priv {
 	struct mlx5_core_dev *dev;
+	struct mlx5e_priv *priv;
 	const struct net_device *netdev;
 	struct mod_hdr_tbl *mod_hdr_tbl;
 	struct xarray tuple_ids;
@@ -85,7 +86,6 @@ struct mlx5_ct_flow {
 	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_flow_handle *pre_ct_rule;
 	struct mlx5_ct_ft *ft;
-	u32 chain_mapping;
 };
 
 struct mlx5_ct_zone_rule {
@@ -1441,6 +1441,7 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	attr->ct_attr.zone = act->ct.zone;
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
+	attr->ct_attr.act_miss_cookie = act->miss_cookie;
 
 	return 0;
 }
@@ -1778,7 +1779,7 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  *	+ ft prio (tc chain)  +
  *	+ original match      +
  *	+---------------------+
- *		 | set chain miss mapping
+ *		 | set act_miss_cookie mapping
  *		 | set fte_id
  *		 | set tunnel_id
  *		 | do decap
@@ -1823,7 +1824,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_flow_attr *pre_ct_attr;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_ct_flow *ct_flow;
-	int chain_mapping = 0, err;
+	int act_miss_mapping = 0, err;
 	struct mlx5_ct_ft *ft;
 	u16 zone;
 
@@ -1858,22 +1859,18 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			       MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
-	/* Write chain miss tag for miss in ct table as we
-	 * don't go though all prios of this chain as normal tc rules
-	 * miss.
-	 */
-	err = mlx5_chains_get_chain_mapping(ct_priv->chains, attr->chain,
-					    &chain_mapping);
+	err = mlx5e_tc_action_miss_mapping_get(ct_priv->priv, attr, attr->ct_attr.act_miss_cookie,
+					       &act_miss_mapping);
 	if (err) {
-		ct_dbg("Failed to get chain register mapping for chain");
-		goto err_get_chain;
+		ct_dbg("Failed to get register mapping for act miss");
+		goto err_get_act_miss;
 	}
-	ct_flow->chain_mapping = chain_mapping;
+	attr->ct_attr.act_miss_mapping = act_miss_mapping;
 
 	err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-					MAPPED_OBJ_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, act_miss_mapping);
 	if (err) {
-		ct_dbg("Failed to set chain register mapping");
+		ct_dbg("Failed to set act miss register mapping");
 		goto err_mapping;
 	}
 
@@ -1937,8 +1934,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 err_mapping:
 	mlx5e_mod_hdr_dealloc(pre_mod_acts);
-	mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
-err_get_chain:
+	mlx5e_tc_action_miss_mapping_put(ct_priv->priv, attr, act_miss_mapping);
+err_get_act_miss:
 	kfree(ct_flow->pre_ct_attr);
 err_alloc_pre:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
@@ -1977,7 +1974,7 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_rule_delete(priv, ct_flow->pre_ct_rule, pre_ct_attr);
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 
-	mlx5_chains_put_chain_mapping(ct_priv->chains, ct_flow->chain_mapping);
+	mlx5e_tc_action_miss_mapping_put(ct_priv->priv, attr, attr->ct_attr.act_miss_mapping);
 	mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
 
 	kfree(ct_flow->pre_ct_attr);
@@ -2157,6 +2154,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	}
 
 	spin_lock_init(&ct_priv->ht_lock);
+	ct_priv->priv = priv;
 	ct_priv->ns_type = ns_type;
 	ct_priv->chains = chains;
 	ct_priv->netdev = priv->netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 5bbd6b92840fb..5c5ddaa83055d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -28,6 +28,8 @@ struct mlx5_ct_attr {
 	struct mlx5_ct_flow *ct_flow;
 	struct nf_flowtable *nf_ft;
 	u32 ct_labels_id;
+	u32 act_miss_mapping;
+	u64 act_miss_cookie;
 };
 
 #define zone_to_reg_ct {\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0bccc23f97ff0..8c7125844e619 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3801,6 +3801,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
 	attr2->dest_ft = NULL;
+	attr2->act_id_restore_rule = NULL;
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		attr2->esw_attr->out_count = 0;
@@ -5654,15 +5655,18 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
 	return true;
 }
 
-static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
-				       u32 chain, u32 zone_restore_id,
-				       u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
+static bool mlx5e_tc_restore_skb_tc_meta(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
+					 struct mlx5_mapped_obj *mapped_obj, u32 zone_restore_id,
+					 u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
 {
+	u32 chain = mapped_obj->type == MLX5_MAPPED_OBJ_CHAIN ? mapped_obj->chain : 0;
+	u64 act_miss_cookie = mapped_obj->type == MLX5_MAPPED_OBJ_ACT_MISS ?
+			      mapped_obj->act_miss_cookie : 0;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct tc_skb_ext *tc_skb_ext;
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (chain) {
+	if (chain || act_miss_cookie) {
 		if (!mlx5e_tc_ct_restore_flow(ct_priv, skb, zone_restore_id))
 			return false;
 
@@ -5672,7 +5676,12 @@ static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_pr
 			return false;
 		}
 
-		tc_skb_ext->chain = chain;
+		if (act_miss_cookie) {
+			tc_skb_ext->act_miss_cookie = act_miss_cookie;
+			tc_skb_ext->act_miss = 1;
+		} else {
+			tc_skb_ext->chain = chain;
+		}
 	}
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
@@ -5743,8 +5752,9 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
 
 	switch (mapped_obj.type) {
 	case MLX5_MAPPED_OBJ_CHAIN:
-		return mlx5e_tc_restore_skb_chain(skb, ct_priv, mapped_obj.chain, zone_restore_id,
-						  tunnel_id, tc_priv);
+	case MLX5_MAPPED_OBJ_ACT_MISS:
+		return mlx5e_tc_restore_skb_tc_meta(skb, ct_priv, &mapped_obj, zone_restore_id,
+						    tunnel_id, tc_priv);
 	case MLX5_MAPPED_OBJ_SAMPLE:
 		mlx5e_tc_restore_skb_sample(priv, skb, &mapped_obj, tc_priv);
 		tc_priv->skb_done = true;
@@ -5782,3 +5792,40 @@ bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 
 	return true;
 }
+
+int mlx5e_tc_action_miss_mapping_get(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				     u64 act_miss_cookie, u32 *act_miss_mapping)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_mapped_obj mapped_obj = {};
+	struct mapping_ctx *ctx;
+	int err;
+
+	ctx = esw->offloads.reg_c0_obj_pool;
+
+	mapped_obj.type = MLX5_MAPPED_OBJ_ACT_MISS;
+	mapped_obj.act_miss_cookie = act_miss_cookie;
+	err = mapping_add(ctx, &mapped_obj, act_miss_mapping);
+	if (err)
+		return err;
+
+	attr->act_id_restore_rule = esw_add_restore_rule(esw, *act_miss_mapping);
+	if (IS_ERR(attr->act_id_restore_rule))
+		goto err_rule;
+
+	return 0;
+
+err_rule:
+	mapping_remove(ctx, *act_miss_mapping);
+	return err;
+}
+
+void mlx5e_tc_action_miss_mapping_put(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				      u32 act_miss_mapping)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mapping_ctx *ctx = esw->offloads.reg_c0_obj_pool;
+
+	mlx5_del_flow_rules(attr->act_id_restore_rule);
+	mapping_remove(ctx, act_miss_mapping);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index eb985f7bdea75..60bff94ba2b62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -101,6 +101,7 @@ struct mlx5_flow_attr {
 	struct mlx5_flow_attr *branch_true;
 	struct mlx5_flow_attr *branch_false;
 	struct mlx5_flow_attr *jumping_attr;
+	struct mlx5_flow_handle *act_id_restore_rule;
 	/* keep this union last */
 	union {
 		DECLARE_FLEX_ARRAY(struct mlx5_esw_flow_attr, esw_attr);
@@ -404,4 +405,9 @@ mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 { return true; }
 #endif
 
+int mlx5e_tc_action_miss_mapping_get(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				     u64 act_miss_cookie, u32 *act_miss_mapping);
+void mlx5e_tc_action_miss_mapping_put(struct mlx5e_priv *priv, struct mlx5_flow_attr *attr,
+				      u32 act_miss_mapping);
+
 #endif /* __MLX5_EN_TC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 92644fbb50816..6aa48c003ba63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -52,12 +52,14 @@ enum mlx5_mapped_obj_type {
 	MLX5_MAPPED_OBJ_CHAIN,
 	MLX5_MAPPED_OBJ_SAMPLE,
 	MLX5_MAPPED_OBJ_INT_PORT_METADATA,
+	MLX5_MAPPED_OBJ_ACT_MISS,
 };
 
 struct mlx5_mapped_obj {
 	enum mlx5_mapped_obj_type type;
 	union {
 		u32 chain;
+		u64 act_miss_cookie;
 		struct {
 			u32 group_id;
 			u32 rate;
-- 
2.30.1

