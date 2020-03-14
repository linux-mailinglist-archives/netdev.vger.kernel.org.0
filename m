Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563011853C4
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgCNBRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:12 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgCNBRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMm/ioGE9qWVHNkW2EXDU75IszpPTzwyyGYzYfnG3nHIKrOLUc2+xai+Hhi3FgtWyIiyXv2Fyuef/kY95a+rx3iVlT9BsE+lvrf10eVjPJ5APgEclm+KFpw/yxd9STCdXeerKWYCz25mIZfwosSEk81pr8GtnSh01u0WzrxEGnSYkD/UeotsZdtzgh6r/MWncbzCzoYU7ea628JZMWsXQgnPVdsCnP2/WEYiGQuNX4hm+JBxTvN7XmmwaWwaUxBYEYg7FWF4fmqayTMP28BGoXG44hKylDt41rJP8QufSAVNU3/aEWasQU7M2tGL5gA+9tEEVayuPxqckQU0lY/XHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIad8sfLztGvQUHEWRgVAH80DgRn9XDSWVwkIV1ACmI=;
 b=SLIBiAfCrIGGc2Xgb6c1ZkNRORLore+iQ6Cr7d6/5ptwx10Q78zSbtnnMIyAZm4KeNd617hfsBAIyd1OpR9/Ij6bQ13uLM8aHRGy1MPdfDfDqvHp/Mb3oTsiZMvRj51uNKAznMqfqKKihvCtKOjXoGwLp/gvzMyyH5Ub70EgQLw6kMSiNI5gXPvhY2g+R9ZhsttgbfCXemabaI7Hx/WQvc5unQEoiPJ8ExBHS5eXWeb99Vs6gDY8O2wjcLcj9uikCoTEnHjUGSPZOOUW4kMHoj4kOV/fPsBoA+DYik4v0g8j/VtLIQbME5Bj4Slf8UEC/ulzPe27l8puXJz0IVsVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIad8sfLztGvQUHEWRgVAH80DgRn9XDSWVwkIV1ACmI=;
 b=JODXXERdctPNxZeGH1P8HwB3cBgPfbnNzAOQWkR0l1CSeEE5nA0eqsGY2hRMnuh68EWB8odEhXWHYH5MV9Xgm1qt/eztOEqjJfz6+JKjCwsPhT+32RVVJFhBVH+aTKlGGX68LpSenjugGkJakoqso28d9R/eyGnWMgiIBKK0kLw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/14] net/mlx5: Accept flow rules without match
Date:   Fri, 13 Mar 2020 18:16:17 -0700
Message-Id: <20200314011622.64939-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:17:01 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ed30cfe-56a0-45f2-fd11-08d7c7b5671c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845EF3F2F4ED427A967F9E0BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:35;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U4njHRfo3pJFYZKVhJpOmqCUCRrx1H1QwD3YcT+LPE5AM8oevQjQn43ylZuyxF0DYgm8tR5UqTKNr14RCUsYDy6Gl+VfHOwMKnDpJO4RHgYpxIpnkXwo+2gqTAEKTlyRj5B8tTz5QEXfK1tMF514dsnCuZI5kDRKHHa5iZUtMAMikYItzHjepNzVbB041anRnktXDBJP+weGo3ASP/xohlxVq/4uNbtAP3aB+sA++e7PfejqtEJB261krS8RTIHGoxNU6nW8QmcH25bDyCZwQAd55SzNMBZSyOuqKQclq8uNxBVpKeT2NRGqEpXGpcao1o502iQnf5KfVV4/LWdal7uWZWiBxdVZbfUfUrEM6oR2rzm7yMj+1WLDRHGJMHfaQwnA/mjdAGcSfxuOOo4P5qxjv9OAMmgoF302IM6V+He1EZkR8w0v1Yok7iYRtX51mkX+iCC5TxfvPBRJvQMxmab3E4eLCoZxbtA1Kb7G/l0vcP0IVPRHYdJZv8LaHRJ3gDQYAU4P5wb0wkeKiIUckjwv4Z2xRux1/v2u7s6NZlA=
X-MS-Exchange-AntiSpam-MessageData: 5PaQK5cAT8o6eWEMBQdl1pDicDkb+2jvU+EnRUErcle3XUMej9f4qcuT8dd8taIw/Rxce1xlsgDGysJqoCmQlV5+ekg1twRhREMZCnhZc0AJpWxoXYF8MpHqdfsmNlCgNmABVN4omAB8tRfDVLMvrw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed30cfe-56a0-45f2-fd11-08d7c7b5671c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:03.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfdujpMaVwC3PrnfEKXlAPqUiCQWAfSbSS9aY+ivYz3OZkWpygjQetb9iwvo6MST7gpxxzCZo7dil4zzeW80+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Allow passing NULL spec when creating a flow rule. Such rules will act
as "catch all" flow rules.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c   | 15 +++------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c   | 17 ++++-------------
 .../mellanox/mlx5/core/eswitch_offloads.c       |  3 +--
 .../mlx5/core/eswitch_offloads_chains.c         |  3 +--
 .../mlx5/core/eswitch_offloads_termtbl.c        |  3 +--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c   |  4 ++++
 6 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 2c75b2752f58..014639ea06e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -175,28 +175,20 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 	struct mlx5e_tir *tir = priv->indir_tir;
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
-	struct mlx5_flow_spec *spec;
 	enum mlx5e_traffic_types tt;
 	int err = 0;
 
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 	tt = arfs_get_tt(type);
 	if (tt == -EINVAL) {
 		netdev_err(priv->netdev, "%s: bad arfs_type: %d\n",
 			   __func__, type);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	dest.tir_num = tir[tt].tirn;
 
-	arfs_t->default_rule = mlx5_add_flow_rules(arfs_t->ft.t, spec,
+	arfs_t->default_rule = mlx5_add_flow_rules(arfs_t->ft.t, NULL,
 						   &flow_act,
 						   &dest, 1);
 	if (IS_ERR(arfs_t->default_rule)) {
@@ -205,8 +197,7 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 		netdev_err(priv->netdev, "%s: add rule failed, arfs type=%d\n",
 			   __func__, type);
 	}
-out:
-	kvfree(spec);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 1de2472a72e7..54e5334f02a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1334,7 +1334,6 @@ static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
-	memset(spec, 0, sizeof(*spec));
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 
 	/* Attach drop flow counter */
@@ -1346,7 +1345,7 @@ static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 		dest_num++;
 	}
 	vport->ingress.legacy.drop_rule =
-		mlx5_add_flow_rules(vport->ingress.acl, spec,
+		mlx5_add_flow_rules(vport->ingress.acl, NULL,
 				    &flow_act, dst, dest_num);
 	if (IS_ERR(vport->ingress.legacy.drop_rule)) {
 		err = PTR_ERR(vport->ingress.legacy.drop_rule);
@@ -1409,7 +1408,6 @@ static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 	struct mlx5_flow_destination drop_ctr_dst = {0};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_spec *spec;
 	int dest_num = 0;
 	int err = 0;
 
@@ -1438,11 +1436,6 @@ static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 	if (err)
 		return err;
 
-	/* Drop others rule (star rule) */
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec)
-		goto out;
-
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 
 	/* Attach egress drop flow counter */
@@ -1454,7 +1447,7 @@ static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 		dest_num++;
 	}
 	vport->egress.legacy.drop_rule =
-		mlx5_add_flow_rules(vport->egress.acl, spec,
+		mlx5_add_flow_rules(vport->egress.acl, NULL,
 				    &flow_act, dst, dest_num);
 	if (IS_ERR(vport->egress.legacy.drop_rule)) {
 		err = PTR_ERR(vport->egress.legacy.drop_rule);
@@ -1463,8 +1456,7 @@ static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 			 vport->vport, err);
 		vport->egress.legacy.drop_rule = NULL;
 	}
-out:
-	kvfree(spec);
+
 	return err;
 }
 
@@ -2481,12 +2473,11 @@ static int _mlx5_eswitch_set_vepa_locked(struct mlx5_eswitch *esw,
 	}
 
 	/* Star rule to forward all traffic to uplink vport */
-	memset(spec, 0, sizeof(*spec));
 	memset(&dest, 0, sizeof(dest));
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = MLX5_VPORT_UPLINK;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	flow_rule = mlx5_add_flow_rules(esw->fdb_table.legacy.vepa_fdb, spec,
+	flow_rule = mlx5_add_flow_rules(esw->fdb_table.legacy.vepa_fdb, NULL,
 					&flow_act, &dest, 1);
 	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index aedbb026ed99..8ff52e237bcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1881,7 +1881,6 @@ static int esw_vport_add_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
 						     struct mlx5_vport *vport)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)] = {};
-	static const struct mlx5_flow_spec spec = {};
 	struct mlx5_flow_act flow_act = {};
 	int err = 0;
 	u32 key;
@@ -1913,7 +1912,7 @@ static int esw_vport_add_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
 	flow_act.modify_hdr = vport->ingress.offloads.modify_metadata;
 	vport->ingress.offloads.modify_metadata_rule =
 				mlx5_add_flow_rules(vport->ingress.acl,
-						    &spec, &flow_act, NULL, 0);
+						    NULL, &flow_act, NULL, 0);
 	if (IS_ERR(vport->ingress.offloads.modify_metadata_rule)) {
 		err = PTR_ERR(vport->ingress.offloads.modify_metadata_rule);
 		esw_warn(esw->dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 0702c216a031..81421d4fb18d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -410,7 +410,6 @@ mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
 			      struct mlx5_flow_table *fdb,
 			      struct mlx5_flow_table *next_fdb)
 {
-	static const struct mlx5_flow_spec spec = {};
 	struct mlx5_eswitch *esw = fdb_chain->esw;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act act = {};
@@ -425,7 +424,7 @@ mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
 		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	}
 
-	return mlx5_add_flow_rules(fdb, &spec, &act, &dest, 1);
+	return mlx5_add_flow_rules(fdb, NULL, &act, &dest, 1);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index f3a925e5ba88..269eddc3d38b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -49,7 +49,6 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 			    struct mlx5_termtbl_handle *tt,
 			    struct mlx5_flow_act *flow_act)
 {
-	static const struct mlx5_flow_spec spec = {};
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *root_ns;
 	int err;
@@ -73,7 +72,7 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 		return -EOPNOTSUPP;
 	}
 
-	tt->rule = mlx5_add_flow_rules(tt->termtbl, &spec, flow_act,
+	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
 				       &tt->dest, 1);
 
 	if (IS_ERR(tt->rule)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index bd0b2e4f3446..c93bd55fab06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1892,12 +1892,16 @@ mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 		    int num_dest)
 {
 	struct mlx5_flow_root_namespace *root = find_root(&ft->node);
+	static const struct mlx5_flow_spec zero_spec = {};
 	struct mlx5_flow_destination gen_dest = {};
 	struct mlx5_flow_table *next_ft = NULL;
 	struct mlx5_flow_handle *handle = NULL;
 	u32 sw_action = flow_act->action;
 	struct fs_prio *prio;
 
+	if (!spec)
+		spec = &zero_spec;
+
 	fs_get_obj(prio, ft->node.parent);
 	if (flow_act->action == MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO) {
 		if (!fwd_next_prio_supported(ft))
-- 
2.24.1

