Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD466708C
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjALLJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjALLIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:08:00 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BADB3E875
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:59:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bu/qlI1j2WfDSQnFE58sOfv4ea7cBZ5tCpjBk6GJCx8ehrHqUJ1SKXnCAet/Yjy8PyVmKZaqzaPSS2aBjCH9K7tpaqRgwjVdRX+3IGA+2anuHp1+DCcm1T7sFsXCVeXHuUd2DO8mI+Bfwx/+6kh3rUUdArJFWqY1D1oomIz2eATczOEbLwnggv81YXzLT2NAEJJkla/bl77UNx7aRy9jaT5Cw25d8Ii/RmvzaKaWWKY6NbRKUdlmDqNLIcX+uplDey1MI44ySddBb5KRJ69UHGHwghb2VdXDFF07VsX4vYNhLvbXNAEefaG8kEl1rosMgYSQ96Peqsd7c40cLmHBJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8H+5MsM6Ui0/GkEVmJbJbZECDMDdNqT08TS5jWgdkI=;
 b=GkLfv3Jh6H+6j1lMMf3EjzkAWnTqpIgeIAev72JWqAJtuHnURxE0K9t0ZiGeqw5Ioeoi6vG4FLQzMiQofXhCFyD/3enT+f7atjH52bg2XK6CNmTBqw3AywBEUa0mS/ONpACyDgp3eGQI6tZn4AjxZnvy3XvIOzkTQtV8KN36X6EQgQjBY3vra+1zdEhLlSVM3Lnh4Bt7heHQKbubXyscw9hNU7CHjG9yOPtWFtPEf8s4zQ2lBwmlFj94gqtrxK+U3xe24UtJHzRQOxqhi78f+iqyJHTDfkqldLKTNXfkLWxBlI5997v/wZgzCrTKj+VeLJq0O8MJGto+IByL/H9OBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8H+5MsM6Ui0/GkEVmJbJbZECDMDdNqT08TS5jWgdkI=;
 b=l0sY1qr5sdz+5CePYchQ41txlgBbJ8+HaaKVySKmjtuOJgpOPb2lk6nHBvU/IXq9Ov84+ENelmY5pxl5V4rzTQh2v120WvGc0w574PRxjdjnnjfGak9cxLN1llgfChz510kOuykqN1YUQBF1gFac0E5sIvI6l81eyIEtDJQx8ph+i5r5pmAQGUYYG2swCwNDrNMNbTfGmQ6cl/pm7U0SNeko8VGtIzbIBmk8QSL0CuP9BAaJQDpqyrFx0tgD6nqlkwh0DdYuj1fwblEabMLh1dGVpzIrEl/xu+TXDsU0LvIL2rNd6jFjnqTePojUlp/sAXfUEQLFsFwrC+xXbZewGw==
Received: from MW4PR03CA0024.namprd03.prod.outlook.com (2603:10b6:303:8f::29)
 by DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 10:59:55 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::b0) by MW4PR03CA0024.outlook.office365.com
 (2603:10b6:303:8f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 10:59:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 10:59:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:37 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:36 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 12 Jan 2023 02:59:33 -0800
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
Subject: [PATCH net-next 6/6] net/mlx5: TC, Set CT miss to the specific ct action instance
Date:   Thu, 12 Jan 2023 12:59:05 +0200
Message-ID: <20230112105905.1738-7-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112105905.1738-1-paulb@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|DS7PR12MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ab85025-cf1f-4462-a7bb-08daf48c2348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPY/T0a/EK1KCY8AzBBD2Dme0TCQTLcqjcjYW8ihJO7OVa/NNqbR1QKmSudh9SXaDaOCjigCa5xcoQ1o2Wo6uZduNUAiNlyAakULSop90XPJY7EMuQNbPZZY2A7WF3a83z/MG9AaoIPozvKRusoVci5y5hqkvu3rljpJnmTbatQeb0FURpUinkxOBF8013nVSvv595lcv0MUGL4TSCWn+6vkRPVZGCKeA24D7t/L/O4YdpRYCcvrgx6hCdZLSn3jWCCo3JoH1Z1C9swo7iE+3mVhaehE7YI1YYKTT77U2y5nywuKC2NnkxgBgRLGzlFnPdkBa4lBLiCNLz1tEafH4s1MKKh4zAYDcnOGAafxtV5nYQQvM6Edl4oBaxIf2rvHtVaRX1de9zg3n0GZSLQZ2ToazSBW54eUBnZHVWdeVPoca4qUDsLsRQXg8ABkKv+IpzzqWfNPaZct/uyf4ACilm2b63REYJyE2SZIZMl9L/H3sET6pRuG0A09vhikxP1MSWlcZdzCIk/g6HP+w/UUGkgonYCb5M8CE9DmpBNXknU/CglFIPJffAZQr8mqkt6R3X7GPtfn9q3+nSQnTJEazRuCeHx7yL3Zj8NXzrGokPS0ldVwTRz8MvKgcjj0q+FE6rGT0q3T7DVM39ySFz1ocBxMgo8ZtgeGzOLCQr7XHbK3dOD+x/B+GyEcJfS5UeuUTl4vhbQHMSzr9ljSWpj5ew==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(70586007)(107886003)(30864003)(36756003)(8936002)(1076003)(316002)(4326008)(5660300002)(8676002)(82740400003)(41300700001)(336012)(26005)(426003)(47076005)(7636003)(82310400005)(2616005)(36860700001)(83380400001)(186003)(54906003)(356005)(40480700001)(110136005)(40460700003)(86362001)(70206006)(6666004)(478600001)(2906002)(66899015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:59:54.9346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab85025-cf1f-4462-a7bb-08daf48c2348
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6309
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 2390b227b5037..daacac5144034 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3828,6 +3828,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
 	attr2->dest_ft = NULL;
+	attr2->act_id_restore_rule = NULL;
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		attr2->esw_attr->out_count = 0;
@@ -5683,15 +5684,18 @@ static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb
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
 
@@ -5701,7 +5705,12 @@ static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_pr
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
 
@@ -5772,8 +5781,9 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
 
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
@@ -5811,3 +5821,40 @@ bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 
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
index 306e8b20941a2..3033afa23d0ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -100,6 +100,7 @@ struct mlx5_flow_attr {
 	struct mlx5_flow_attr *branch_true;
 	struct mlx5_flow_attr *branch_false;
 	struct mlx5_flow_attr *jumping_attr;
+	struct mlx5_flow_handle *act_id_restore_rule;
 	/* keep this union last */
 	union {
 		DECLARE_FLEX_ARRAY(struct mlx5_esw_flow_attr, esw_attr);
@@ -400,4 +401,9 @@ mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
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

