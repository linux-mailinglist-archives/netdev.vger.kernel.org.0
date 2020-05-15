Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07ED1D5C88
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgEOWtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:43 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEOWtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIEeJJczzzoL1+ch1HI+A2GqVV+i5PpwR++kZMh997YUVoS2IIApWQ/GtIWLttaY2ppeM+uP1xE2Vla5jLuaWWNlwopQ1UF57mAXUt17N/ToT2pwsbZEsU3HhGx5lvLZCVcr6/edJuJeR12FSouvPOyevax5wWS+KgKvBte8d5jtVB98/xZehhXpZ71OFmX+Fgn4FY5JoWj6UceOFytGWM9wSqPsGgMBnADMbhc7aXg4kpqUjxxndg1xb3MiCxDHMjHE30sAhUMsLWzzhlpmTWeOQ5KcVZ/el7SQd+8xoMiMbBTNc4Fvdi+fOtjL0eHSMWtaJqwgaYGofjjhZtuhlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5rUoQkxlW/5asPFb187nV4+YaEQpEo+8lpROXncA54=;
 b=XqSVYMk3s5JfBYgYGkoO1hck06O9bBfhxXjQFYNg5un7ywOK+oyeivV2OZEOVvci3mYyGGLzNsHxdZnkqYMbZRAZBdGl20nxtsIIFf6dRFzIBcF7ozYQ3Sbm4j4Rc8SfuyfHm12RRhlVN8vDccMPRDJgcQ7NLEwP6LW3i/IFmcABVgOIzkd9L9kwTWm5T7/6x1tVFOA5yTuwB28s6uEtL5zMUnNkdA3m9VsDmkfPbpodg4ViuLCRHPoIg/mVWYofxLmZ4LGg4YKOwWNKLo32au3ZJMfmvGHo65YxG4L309Spm/Bd4vQZNFl2H2iWDxdUY486iF2m07lu/bNQ3PQdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5rUoQkxlW/5asPFb187nV4+YaEQpEo+8lpROXncA54=;
 b=C9jAcA9owWG9BTvsAB2FMzIhe+lL6OMiLDTsU9G6nHIS47Y+cstkNfVy4vWx6smqTS64fxA5bPFJKtpCIZmvbbDjRWfbv0p1w7QCLizSY/iLspotrhpG9ftvsGdH4u9NZec2C1RmgLbAnNOr52Q6japTvz2LR3NhLNvxpwV154M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/11] net/mlx5e: CT: Fix offload with CT action after CT NAT action
Date:   Fri, 15 May 2020 15:48:50 -0700
Message-Id: <20200515224854.20390-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:31 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c6ae02f-f31b-4876-0b66-08d7f9223c16
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB320083FB4E0C59263F984E13BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NusAGY40Y0PhFRGhicfoYeJe+QNg2zs1BrfNmDavpp51Wjhyghoz94sczilaIyX9Qu6kTuec+2sjxpGRXRel98RPltQ2LbJn8xsw5dXCQdTU5Gz8Qqiy8Lhlcs5BdMMljEnYoEuXV70D3tV1UqoVoOc9CYGWnM6HlkD69gqBzh+JJOQYupnRk4IjeEjelSU678RkK5sKmQVrw0ki/0AZh/5xNsIMrIMFfwe+yf4CkHapQAOE4FJ57PHmy+YkoIIzSgAp5rBHT7GqyF1RfjjVTpUC1ojy86xL5m16ipIrSl3sUMQayURBylMUXkGPTLry60DzYdzOeHCDJfJYauB/deInJ7mcC0Yrg2X6dXgGX2zNHuEDW9+Vemwtkp99ZvgJfbZVFxQXRlDzbauZ64UgiGnqSOoOE4Gh5nyxx5xsMmYK34Gp5ruaqbBA2DqgUkEWLD+CY3mC86DfEDGhyAdpiXGIhWcmwPAwGaiBEUKqLFLqVJc1gEXcVNgOrZ8ulrTr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(30864003)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qWV4wsV5R0I5n8FWdAyLZOi62gegLhe24g6+fYDJaFf5hkikjy7VnnbtYMkwoa8vuhSykt1cL0c0vl3477wmcXAyFOjKqqTd3c+gdn1UsoFW0azVFtpsyhoDeylcOkqPc0nkpn63f+B1MrVpX17hwYK1SFAQXl+VQLHNm7lONKdT01iV1w11jv2qs5/opsUMQdiDvz2ij/DlKFbzkdiIg9dmtHlTO720XkfdX1G2/rxw3FfLIrkiXxR3ePZt3uiMHNO6B6EGyFjHWLjUULX9VnAjlKO3btxJZKIJFrsAgegFlykwkTnt+Ru3+ZmNQCKHaAqwZSCOdY80b6ZM6FjFaMqdizJ6LVwljsOLD5MjqUxgzag5dnS2MgXO8vSJ7FV5DpI7AkIH9fpwOmrL0TdOdsE53UZJYs9xCg26rWdVW60EOW7/Jx0/emcKxCtdbGvlZVt45lSlsd+NGb0nTe5knqW8sk4kLoSwPZYTvQ1m5Zs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6ae02f-f31b-4876-0b66-08d7f9223c16
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:33.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmZcIMY/2wWd+4dBMmZff0QRAmhGkhGKoDgXgv5gWXk4GYgtsS0RAR1oFeGYeKPc5OJYpCzHxE1yhcpYxKGhgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

It could be a chain of rules will do action CT again after CT NAT
Before this fix matching will break as we get into the CT table
after NAT changes and not CT NAT.
Fix this by adding pre ct and pre ct nat tables to skip ct/ct_nat
tables and go straight to post_ct table if ct/nat was already done.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 308 ++++++++++++++++--
 1 file changed, 286 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 5568ded97e0b..98263f00ee43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -24,6 +24,7 @@
 #define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
 #define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
 #define MLX5_CT_STATE_TRK_BIT BIT(2)
+#define MLX5_CT_STATE_NAT_BIT BIT(3)
 
 #define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen * 8)
 #define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
@@ -61,6 +62,15 @@ struct mlx5_ct_zone_rule {
 	bool nat;
 };
 
+struct mlx5_tc_ct_pre {
+	struct mlx5_flow_table *fdb;
+	struct mlx5_flow_group *flow_grp;
+	struct mlx5_flow_group *miss_grp;
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5_flow_handle *miss_rule;
+	struct mlx5_modify_hdr *modify_hdr;
+};
+
 struct mlx5_ct_ft {
 	struct rhash_head node;
 	u16 zone;
@@ -68,6 +78,8 @@ struct mlx5_ct_ft {
 	struct nf_flowtable *nf_ft;
 	struct mlx5_tc_ct_priv *ct_priv;
 	struct rhashtable ct_entries_ht;
+	struct mlx5_tc_ct_pre pre_ct;
+	struct mlx5_tc_ct_pre pre_ct_nat;
 };
 
 struct mlx5_ct_entry {
@@ -426,6 +438,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_modify_hdr *mod_hdr;
 	struct flow_action_entry *meta;
+	u16 ct_state = 0;
 	int err;
 
 	meta = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
@@ -444,11 +457,13 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 						  &mod_acts);
 		if (err)
 			goto err_mapping;
+
+		ct_state |= MLX5_CT_STATE_NAT_BIT;
 	}
 
+	ct_state |= MLX5_CT_STATE_ESTABLISHED_BIT | MLX5_CT_STATE_TRK_BIT;
 	err = mlx5_tc_ct_entry_set_registers(ct_priv, &mod_acts,
-					     (MLX5_CT_STATE_ESTABLISHED_BIT |
-					      MLX5_CT_STATE_TRK_BIT),
+					     ct_state,
 					     meta->ct_metadata.mark,
 					     meta->ct_metadata.labels[0],
 					     tupleid);
@@ -791,6 +806,238 @@ mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static int tc_ct_pre_ct_add_rules(struct mlx5_ct_ft *ct_ft,
+				  struct mlx5_tc_ct_pre *pre_ct,
+				  bool nat)
+{
+	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
+	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
+	struct mlx5_core_dev *dev = ct_priv->esw->dev;
+	struct mlx5_flow_table *fdb = pre_ct->fdb;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_modify_hdr *mod_hdr;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	u32 ctstate;
+	u16 zone;
+	int err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	zone = ct_ft->zone & MLX5_CT_ZONE_MASK;
+	err = mlx5e_tc_match_to_reg_set(dev, &pre_mod_acts, ZONE_TO_REG, zone);
+	if (err) {
+		ct_dbg("Failed to set zone register mapping");
+		goto err_mapping;
+	}
+
+	mod_hdr = mlx5_modify_header_alloc(dev,
+					   MLX5_FLOW_NAMESPACE_FDB,
+					   pre_mod_acts.num_actions,
+					   pre_mod_acts.actions);
+
+	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
+		ct_dbg("Failed to create pre ct mod hdr");
+		goto err_mapping;
+	}
+	pre_ct->modify_hdr = mod_hdr;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	flow_act.modify_hdr = mod_hdr;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+
+	/* add flow rule */
+	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
+				    zone, MLX5_CT_ZONE_MASK);
+	ctstate = MLX5_CT_STATE_TRK_BIT;
+	if (nat)
+		ctstate |= MLX5_CT_STATE_NAT_BIT;
+	mlx5e_tc_match_to_reg_match(spec, CTSTATE_TO_REG, ctstate, ctstate);
+
+	dest.ft = ct_priv->post_ct;
+	rule = mlx5_add_flow_rules(fdb, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		ct_dbg("Failed to add pre ct flow rule zone %d", zone);
+		goto err_flow_rule;
+	}
+	pre_ct->flow_rule = rule;
+
+	/* add miss rule */
+	memset(spec, 0, sizeof(*spec));
+	dest.ft = nat ? ct_priv->ct_nat : ct_priv->ct;
+	rule = mlx5_add_flow_rules(fdb, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		ct_dbg("Failed to add pre ct miss rule zone %d", zone);
+		goto err_miss_rule;
+	}
+	pre_ct->miss_rule = rule;
+
+	dealloc_mod_hdr_actions(&pre_mod_acts);
+	kvfree(spec);
+	return 0;
+
+err_miss_rule:
+	mlx5_del_flow_rules(pre_ct->flow_rule);
+err_flow_rule:
+	mlx5_modify_header_dealloc(dev, pre_ct->modify_hdr);
+err_mapping:
+	dealloc_mod_hdr_actions(&pre_mod_acts);
+	kvfree(spec);
+	return err;
+}
+
+static void
+tc_ct_pre_ct_del_rules(struct mlx5_ct_ft *ct_ft,
+		       struct mlx5_tc_ct_pre *pre_ct)
+{
+	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
+	struct mlx5_core_dev *dev = ct_priv->esw->dev;
+
+	mlx5_del_flow_rules(pre_ct->flow_rule);
+	mlx5_del_flow_rules(pre_ct->miss_rule);
+	mlx5_modify_header_dealloc(dev, pre_ct->modify_hdr);
+}
+
+static int
+mlx5_tc_ct_alloc_pre_ct(struct mlx5_ct_ft *ct_ft,
+			struct mlx5_tc_ct_pre *pre_ct,
+			bool nat)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_tc_ct_priv *ct_priv = ct_ft->ct_priv;
+	struct mlx5_core_dev *dev = ct_priv->esw->dev;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *g;
+	u32 metadata_reg_c_2_mask;
+	u32 *flow_group_in;
+	void *misc;
+	int err;
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
+	if (!ns) {
+		err = -EOPNOTSUPP;
+		ct_dbg("Failed to get FDB flow namespace");
+		return err;
+	}
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	ft_attr.flags = MLX5_FLOW_TABLE_UNMANAGED;
+	ft_attr.prio = FDB_TC_OFFLOAD;
+	ft_attr.max_fte = 2;
+	ft_attr.level = 1;
+	ft = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		ct_dbg("Failed to create pre ct table");
+		goto out_free;
+	}
+	pre_ct->fdb = ft;
+
+	/* create flow group */
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_MISC_PARAMETERS_2);
+
+	misc = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
+			    match_criteria.misc_parameters_2);
+
+	metadata_reg_c_2_mask = MLX5_CT_ZONE_MASK;
+	metadata_reg_c_2_mask |= (MLX5_CT_STATE_TRK_BIT << 16);
+	if (nat)
+		metadata_reg_c_2_mask |= (MLX5_CT_STATE_NAT_BIT << 16);
+
+	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_2,
+		 metadata_reg_c_2_mask);
+
+	g = mlx5_create_flow_group(ft, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		ct_dbg("Failed to create pre ct group");
+		goto err_flow_grp;
+	}
+	pre_ct->flow_grp = g;
+
+	/* create miss group */
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+	g = mlx5_create_flow_group(ft, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		ct_dbg("Failed to create pre ct miss group");
+		goto err_miss_grp;
+	}
+	pre_ct->miss_grp = g;
+
+	err = tc_ct_pre_ct_add_rules(ct_ft, pre_ct, nat);
+	if (err)
+		goto err_add_rules;
+
+	kvfree(flow_group_in);
+	return 0;
+
+err_add_rules:
+	mlx5_destroy_flow_group(pre_ct->miss_grp);
+err_miss_grp:
+	mlx5_destroy_flow_group(pre_ct->flow_grp);
+err_flow_grp:
+	mlx5_destroy_flow_table(ft);
+out_free:
+	kvfree(flow_group_in);
+	return err;
+}
+
+static void
+mlx5_tc_ct_free_pre_ct(struct mlx5_ct_ft *ct_ft,
+		       struct mlx5_tc_ct_pre *pre_ct)
+{
+	tc_ct_pre_ct_del_rules(ct_ft, pre_ct);
+	mlx5_destroy_flow_group(pre_ct->miss_grp);
+	mlx5_destroy_flow_group(pre_ct->flow_grp);
+	mlx5_destroy_flow_table(pre_ct->fdb);
+}
+
+static int
+mlx5_tc_ct_alloc_pre_ct_tables(struct mlx5_ct_ft *ft)
+{
+	int err;
+
+	err = mlx5_tc_ct_alloc_pre_ct(ft, &ft->pre_ct, false);
+	if (err)
+		return err;
+
+	err = mlx5_tc_ct_alloc_pre_ct(ft, &ft->pre_ct_nat, true);
+	if (err)
+		goto err_pre_ct_nat;
+
+	return 0;
+
+err_pre_ct_nat:
+	mlx5_tc_ct_free_pre_ct(ft, &ft->pre_ct);
+	return err;
+}
+
+static void
+mlx5_tc_ct_free_pre_ct_tables(struct mlx5_ct_ft *ft)
+{
+	mlx5_tc_ct_free_pre_ct(ft, &ft->pre_ct_nat);
+	mlx5_tc_ct_free_pre_ct(ft, &ft->pre_ct);
+}
+
 static struct mlx5_ct_ft *
 mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 		     struct nf_flowtable *nf_ft)
@@ -813,6 +1060,10 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	ft->ct_priv = ct_priv;
 	refcount_set(&ft->refcount, 1);
 
+	err = mlx5_tc_ct_alloc_pre_ct_tables(ft);
+	if (err)
+		goto err_alloc_pre_ct;
+
 	err = rhashtable_init(&ft->ct_entries_ht, &cts_ht_params);
 	if (err)
 		goto err_init;
@@ -834,6 +1085,8 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 err_insert:
 	rhashtable_destroy(&ft->ct_entries_ht);
 err_init:
+	mlx5_tc_ct_free_pre_ct_tables(ft);
+err_alloc_pre_ct:
 	kfree(ft);
 	return ERR_PTR(err);
 }
@@ -859,21 +1112,40 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
+	mlx5_tc_ct_free_pre_ct_tables(ft);
 	kfree(ft);
 }
 
 /* We translate the tc filter with CT action to the following HW model:
  *
- * +-------------------+      +--------------------+    +--------------+
- * + pre_ct (tc chain) +----->+ CT (nat or no nat) +--->+ post_ct      +----->
- * + original match    +  |   + tuple + zone match + |  + fte_id match +  |
- * +-------------------+  |   +--------------------+ |  +--------------+  |
- *                        v                          v                    v
- *                       set chain miss mapping  set mark             original
- *                       set fte_id              set label            filter
- *                       set zone                set established      actions
- *                       set tunnel_id           do nat (if needed)
- *                       do decap
+ * +---------------------+
+ * + fdb prio (tc chain) +
+ * + original match      +
+ * +---------------------+
+ *      | set chain miss mapping
+ *      | set fte_id
+ *      | set tunnel_id
+ *      | do decap
+ *      v
+ * +---------------------+
+ * + pre_ct/pre_ct_nat   +  if matches     +---------------------+
+ * + zone+nat match      +---------------->+ post_ct (see below) +
+ * +---------------------+  set zone       +---------------------+
+ *      | set zone
+ *      v
+ * +--------------------+
+ * + CT (nat or no nat) +
+ * + tuple + zone match +
+ * +--------------------+
+ *      | set mark
+ *      | set label
+ *      | set established
+ *      | do nat (if needed)
+ *      v
+ * +--------------+
+ * + post_ct      + original filter actions
+ * + fte_id match +------------------------>
+ * +--------------+
  */
 static int
 __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
@@ -888,7 +1160,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	struct mlx5_flow_spec *post_ct_spec = NULL;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_esw_flow_attr *pre_ct_attr;
-	struct  mlx5_modify_hdr *mod_hdr;
+	struct mlx5_modify_hdr *mod_hdr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_ct_flow *ct_flow;
 	int chain_mapping = 0, err;
@@ -951,14 +1223,6 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 		goto err_mapping;
 	}
 
-	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts, ZONE_TO_REG,
-					attr->ct_attr.zone &
-					MLX5_CT_ZONE_MASK);
-	if (err) {
-		ct_dbg("Failed to set zone register mapping");
-		goto err_mapping;
-	}
-
 	err = mlx5e_tc_match_to_reg_set(esw->dev, &pre_mod_acts,
 					FTEID_TO_REG, fte_id);
 	if (err) {
@@ -1018,7 +1282,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 
 	/* Change original rule point to ct table */
 	pre_ct_attr->dest_chain = 0;
-	pre_ct_attr->dest_ft = nat ? ct_priv->ct_nat : ct_priv->ct;
+	pre_ct_attr->dest_ft = nat ? ft->pre_ct_nat.fdb : ft->pre_ct.fdb;
 	ct_flow->pre_ct_rule = mlx5_eswitch_add_offloaded_rule(esw,
 							       orig_spec,
 							       pre_ct_attr);
-- 
2.25.4

