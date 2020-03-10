Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D38917EE1E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgCJBne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:34 -0400
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:6098
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726617AbgCJBna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwUI6jdfg7OpBFGMhyKXdhgRqBSdeqnXY5w0URRJhRp9tyj8JsHJhaERMR+UysDmLx4SoFgELVcdiChYu+3WdvU4hZF+NYo/YtqshT6WxbJDUYWwuXTzQowgnrZGF2f0c3yikUvAHgWMUQd01k8YrVX1bNmHbdPjGeo8vW2lwRzD3s4oV65Kp1oENM639yIJes7aPwidnb/n7F3OCjAXsbitOhry9EytNhzj78VggaofQHnE84uVmqoDVTUoEjg+Tsy5RCr7Q08OnL1W2swE48kmpUDKBwXw/Jeyv08xCGEOxVsPva0sRpnNq8Dabtf8lb+haQZm95aYjowhLN8wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjSzUkIhZJbOVCRk/eMi+dQ6p7/JaDRYTnsNkFchELQ=;
 b=GlE9URz+kzsy66/Z+dWOAh9jE2Aka0ofoH1f1iTu9WieL9XetAb+enMTAAxSqUx6I504lE4PUlN+Lj3/hr8ZzHTvUo++SIVWgVvAK5Nd/4ep7x3WYo67g0sWBN61lZ9sgZULcHGu5jgZTcIe4jwe+rI5AIXlUp8YHekC3DiKczheOMtak8J0Sb/hu2qIr8UxyK6PA1Kv/4g7M9Oh+zA0STKECApLS/8HRPVOcNJeQZagB6omsKyWlq2lXLTMCXc8rWlEUc6frTAzcANV5M+aK+0GycQhp+1wwh3x2wa5Pp6t8aDtIIeTV3ySJIwHI2G4DMwuybL+zJ3RSlfBWkPpPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjSzUkIhZJbOVCRk/eMi+dQ6p7/JaDRYTnsNkFchELQ=;
 b=qlowiJZGyn0mZE9RWvIgKuPyI4Wa3M2SZ7mbgH5D4xcIcgxN2B0oWcfV1ZX5pLzGFgW4A5x1bmw8KK/43wkWBDjZ5FIlcG4K6fCLmmLw4smrCMkCWrOyU160YlGGlbo5n7Rkwn1Gb5thaYwzixrWcjOQ0W3EyiiOOJg2sgOOCbk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [net-next 08/11] net/mlx5e: Introduce root ft concept for representors netdevs
Date:   Mon,  9 Mar 2020 18:42:43 -0700
Message-Id: <20200310014246.30830-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:18 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b086b79-033a-42cd-c0ee-08d7c4946986
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5533C23A65C3323FF424EBCABEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5a23hXmqEVXpva2NS3UWGN9X2tQBVcJculBwa0v1eEFSnwHSozob2HqV1fU5D7bTVc6R3s/O8xmGpGSeQWfhaXC6KnIPlYRprv2OymnzPasFiyozJQ4n6v2LRFHsn5+KI7xWulDQsnvc5qshlZB8rbVNu3sUK1FdrQ6Z55/locSf21HyqoiNWJ6seOI6EtJvZuBPwV8hIs198v+/52YHa12u5qi9u0m9atvSybRtHwWqGQF3sel57pcQPwetjkjGg3ksfQ7X6PkqkfQrQbZc+BvKZjeuUsmpwLxGmR6/ntbYkNeNPmDsVJXpoKVxcbqYdCYvLQQFcGCkqqyjPdhABc7HMxFLKgr9B4otAWu0UcsUMdf+z/bLovS5Pyo2ycnc2ZugF5ART5kAkYVj9FVZmew1rWRKjl+k+CPf+Wng26VODIfRUa3La00PtygLoaFYOyrGkPHWmdxU1Bigp4TKFK+F3aswmxGCS/QJf+EMTpsCUYkefqSJ7Lar3DLndJ2CDppoT3Y/BDXwi9QiDESArYZpFKaiJtbHRWhjgiAS8o=
X-MS-Exchange-AntiSpam-MessageData: ko2UblAHV7vEPXmFZISmE6slJIRGCVoVBHrDWb9OJry1rj4hnZBqLS0w/tqlfooiKVtnF3yn+C+Mwdw3tFJ5lV6hlNyb4R2Wl4euQ6wmuMC2Hz/N6in8PY6tDxn1A0hAi4xK6ME0LQiwW7id4wueMg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b086b79-033a-42cd-c0ee-08d7c4946986
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:20.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3A8NvgeKYhJWHyAZPqiNEPJo+GnbmliqCWOz0f4+vAPZ0a3rNucaPwWcd+1oH4l09B7Y7scUFmvKUwVQG4kd5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uplink representor traffic will be redirected to an empty root ft rather
than directly to a direct tir or ttc table, this root ft will be empty and
will be used as a link for auto-chaining with ttc table or ethtool tables
in downstream patches.

On load, fs core will connect uplink rep root_ft with ttc table.  In case
ethtool steering will be used, fs core will auto connect root_ft with
the ethtool bypass tables, which will be connected with the ttc table.

vport_rx_rule[uplink_rep]->root_ft->ethtool->ttc.

For non-uplink representors, for simplicity root_ft will always point at
ttc table, hence the replace vport_rx rule logic is removed.

vport_rx_rule[non_uplink_rep]->root_ft(ttc).

For now ethtool steering support can only be available on uplink rep.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 116 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 3 files changed, 68 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c506143c8559..cffb5f62c304 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -253,25 +253,6 @@ static int mlx5e_rep_set_ringparam(struct net_device *dev,
 	return mlx5e_ethtool_set_ringparam(priv, param);
 }
 
-static int mlx5e_replace_rep_vport_rx_rule(struct mlx5e_priv *priv,
-					   struct mlx5_flow_destination *dest)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct mlx5_flow_handle *flow_rule;
-
-	flow_rule = mlx5_eswitch_create_vport_rx_rule(esw,
-						      rep->vport,
-						      dest);
-	if (IS_ERR(flow_rule))
-		return PTR_ERR(flow_rule);
-
-	mlx5_del_flow_rules(rpriv->vport_rx_rule);
-	rpriv->vport_rx_rule = flow_rule;
-	return 0;
-}
-
 static void mlx5e_rep_get_channels(struct net_device *dev,
 				   struct ethtool_channels *ch)
 {
@@ -284,33 +265,8 @@ static int mlx5e_rep_set_channels(struct net_device *dev,
 				  struct ethtool_channels *ch)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	u16 curr_channels_amount = priv->channels.params.num_channels;
-	u32 new_channels_amount = ch->combined_count;
-	struct mlx5_flow_destination new_dest;
-	int err = 0;
 
-	err = mlx5e_ethtool_set_channels(priv, ch);
-	if (err)
-		return err;
-
-	if (curr_channels_amount == 1 && new_channels_amount > 1) {
-		new_dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-		new_dest.ft = priv->fs.ttc.ft.t;
-	} else if (new_channels_amount == 1 && curr_channels_amount > 1) {
-		new_dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-		new_dest.tir_num = priv->direct_tir[0].tirn;
-	} else {
-		return 0;
-	}
-
-	err = mlx5e_replace_rep_vport_rx_rule(priv, &new_dest);
-	if (err) {
-		netdev_warn(priv->netdev, "Failed to update vport rx rule, when going from (%d) channels to (%d) channels\n",
-			    curr_channels_amount, new_channels_amount);
-		return err;
-	}
-
-	return 0;
+	return mlx5e_ethtool_set_channels(priv, ch);
 }
 
 static int mlx5e_rep_get_coalesce(struct net_device *netdev,
@@ -1596,6 +1552,8 @@ static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 
 static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct ttc_params ttc_params = {};
 	int tt, err;
 
@@ -1605,6 +1563,11 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 	/* The inner_ttc in the ttc params is intentionally not set */
 	ttc_params.any_tt_tirn = priv->direct_tir[0].tirn;
 	mlx5e_set_ttc_ft_params(&ttc_params);
+
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		/* To give uplik rep TTC a lower level for chaining from root ft */
+		ttc_params.ft_attr.level = MLX5E_TTC_FT_LEVEL + 1;
+
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
 
@@ -1616,6 +1579,51 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 	return 0;
 }
 
+static int mlx5e_create_rep_root_ft(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *ns;
+	int err = 0;
+
+	if (rep->vport != MLX5_VPORT_UPLINK) {
+		/* non uplik reps will skip any bypass tables and go directly to
+		 * their own ttc
+		 */
+		rpriv->root_ft = priv->fs.ttc.ft.t;
+		return 0;
+	}
+
+	/* uplink root ft will be used to auto chain, to ethtool or ttc tables */
+	ns = mlx5_get_flow_namespace(priv->mdev, MLX5_FLOW_NAMESPACE_OFFLOADS);
+	if (!ns) {
+		netdev_err(priv->netdev, "Failed to get reps offloads namespace\n");
+		return -EOPNOTSUPP;
+	}
+
+	ft_attr.max_fte = 0; /* Empty table, miss rule will always point to next table */
+	ft_attr.level = 1;
+
+	rpriv->root_ft = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(rpriv->root_ft)) {
+		err = PTR_ERR(rpriv->root_ft);
+		rpriv->root_ft = NULL;
+	}
+
+	return err;
+}
+
+static void mlx5e_destroy_rep_root_ft(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		return;
+	mlx5_destroy_flow_table(rpriv->root_ft);
+}
+
 static int mlx5e_create_rep_vport_rx_rule(struct mlx5e_priv *priv)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -1624,11 +1632,10 @@ static int mlx5e_create_rep_vport_rx_rule(struct mlx5e_priv *priv)
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_flow_destination dest;
 
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	dest.tir_num = priv->direct_tir[0].tirn;
-	flow_rule = mlx5_eswitch_create_vport_rx_rule(esw,
-						      rep->vport,
-						      &dest);
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = rpriv->root_ft;
+
+	flow_rule = mlx5_eswitch_create_vport_rx_rule(esw, rep->vport, &dest);
 	if (IS_ERR(flow_rule))
 		return PTR_ERR(flow_rule);
 	rpriv->vport_rx_rule = flow_rule;
@@ -1668,12 +1675,18 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_tirs;
 
-	err = mlx5e_create_rep_vport_rx_rule(priv);
+	err = mlx5e_create_rep_root_ft(priv);
 	if (err)
 		goto err_destroy_ttc_table;
 
+	err = mlx5e_create_rep_vport_rx_rule(priv);
+	if (err)
+		goto err_destroy_root_ft;
+
 	return 0;
 
+err_destroy_root_ft:
+	mlx5e_destroy_rep_root_ft(priv);
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_direct_tirs:
@@ -1694,6 +1707,7 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
 	mlx5_del_flow_rules(rpriv->vport_rx_rule);
+	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 	mlx5e_destroy_indirect_tirs(priv, false);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 8336301476a9..3d9c72eee9fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -87,6 +87,7 @@ struct mlx5e_rep_priv {
 	struct mlx5_eswitch_rep *rep;
 	struct mlx5e_neigh_update_table neigh_update;
 	struct net_device      *netdev;
+	struct mlx5_flow_table *root_ft;
 	struct mlx5_flow_handle *vport_rx_rule;
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 5826fd43d530..4e627e685a02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -110,7 +110,7 @@
 #define ANCHOR_NUM_PRIOS 1
 #define ANCHOR_MIN_LEVEL (BY_PASS_MIN_LEVEL + 1)
 
-#define OFFLOADS_MAX_FT 1
+#define OFFLOADS_MAX_FT 2
 #define OFFLOADS_NUM_PRIOS 1
 #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + 1)
 
@@ -145,7 +145,7 @@ static struct init_tree_node {
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(LAG_NUM_PRIOS,
 						    LAG_PRIO_NUM_LEVELS))),
-		  ADD_PRIO(0, OFFLOADS_MIN_LEVEL, 0, {},
+		  ADD_PRIO(0, OFFLOADS_MIN_LEVEL, 0, FS_CHAINING_CAPS,
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(OFFLOADS_NUM_PRIOS,
 						    OFFLOADS_MAX_FT))),
-- 
2.24.1

