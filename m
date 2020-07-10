Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A564C21ADAE
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgGJDsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:22 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727065AbgGJDsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThG2pzF5A0+ZcFUJHmTjpRg4o35DRMd2yDNE8l1ber9gkkxUql+f2MiC4a4myKxvjOOPjJFnY9EaBRbE6gJvw+ahe+pNgX9YZEjWbHvqHf2JlSEmHRQWc7OVv+93efzzauRV/PoFb6Ko6xD3HXG1JPoM5iU6rvgIhnsFJ22gd5oRpKwQJvsRVL9c72XvdJ38XBHPMR4ZdCAe2RykXY2UDfWjjyi3aLrXUFeWMqfrXtefIOcgZRLJs8q18g1kdBPpDwmSHV/JrxI9T4H6e/yxfRyiSK+2jy7uxIIbbLC5lLeIZTGkwgUGkgFduAAdVq4C+ZkzNK5YL97ksVjE72n8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhUJy6JqyuxwDQK0T6sf8K/2PgGtQxV5t7P3nposfnk=;
 b=bWPTt3MLVbKZ37x2OkLahl8D7VlHC7uoNLaeX5614zjr4LIDs2Na9dn1cNsizrP2j5rivRe8RJPA6+SBT9fuPlIdBCzmI9hoHkQwmWyFvZEO4ZwLCJHiAKRVRzuWSrORm7YYkpdJ03HIwio/HPXJwEOWpj3xyLAfxkqZtsNz2U42S4bvogVwQNTFN1eJoQCzlFzTSdnY8oHMg5l/y2wqc73Iz8f1BAu6sdh3qlx6M3KYZT+tbiAHsV4wISE72ZVvo4leI6Z3f2xhAj4eWHEPffsKv8NFB2GtU5rpBm8qVyM2t13Xt360if9zqETOpBa9qpa344F4rMvNcaNoDdeOKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhUJy6JqyuxwDQK0T6sf8K/2PgGtQxV5t7P3nposfnk=;
 b=Ag5DHpJCDOpXrIsmOQZntriUJNY9zqWn4PgGIwEskIaM1wQm+I7C48iyVA8AXxtEf3uvSjahSqlRkCabi1Hv9woJP+ghThdP4lDzq4pGI8Fq1BP5F4Z1y5mLogZRxuxYed8Lvly1qGHEipj1owUpDE263Kpia/eEYNwOzH8KBro=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:48:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:48:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/13] net/mlx5e: CT: Use mapping for zone restore register
Date:   Thu,  9 Jul 2020 20:44:28 -0700
Message-Id: <20200710034432.112602-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58e752c8-0004-47c9-cea0-08d824840a44
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512A153DB836F1C79D59CE6BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rRZ1GSwX9LjhIUkqn/fto68R0w5qZjVbp932xhuPGvfGz6ltQdoWO00Ge9iSDCJwFTzhdXZMnqJ2q1V23yZv5nt0uNkXu1LUqSmpH9hRN2avy+pKWYSijwTCpU0aoO9Bg493znfEhW37bLnZMWwJo8WhET3PVZoxU/VGUQk8C6W+aaGYYOhBsbfOfWio6NUNRCJTgvaDfeS56flC9C7S7YFlRuTNlAKswzB+9qouWaBc12KpYGhvpBbLnBh1zOgwHLvOOhlzu+22iJ8maEjmA6iHFUV5FaKd2V/k5NY2cEWoiaDW+WSjqDfJBVj1Ppuu64vy5H2B6zEf+PYazPr3RMs65fLZ1kHCC4Iwc+dRxOTuXGi/n34QOKTuygieMPkd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TeOHJLVRqWqr5KXmNMH6Mapl49gbDQfk9K97Yx29YaxgI4IWhN0oNsTykSk0BaJBnNQI1E7pQavMYF2dUIijeUFoUCGbWuuSK2pAKqsdOxEQrdvKPcZlB5MHCRDcWbstrHmWVG3dIuhzzQNf0P0f/aMvw2JPQfUSJVPK8qBkK8Qd3i6yKp0/xd6G0dfWB5QXhHfnIHTqLQev8mbXyMuVMj01RbDdJyjXywMxV2gEluguKX9sNqR057jvtwUD3hTF2y4NBrbiAPaJIblhWxUjO+wE1ioRR/1seRFux4GCfRVMYTc+GqoS05/fWltXFsciwCZ8avQyxArevJ4SC9jsTpki2lVExuAbFTfPzJaBLIYcRCe5J0uNLn/D9Et1t48KJSR5SOTeWU2ScUiMgmLK2QsZ7Aawj3wic34metPak39YA3eWFXE4ZwXuP1RxX8HaCfTqGPzn7dqb4BXcAUmWw5yJPblaCdeqIUAhU+ZLYxo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e752c8-0004-47c9-cea0-08d824840a44
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:48:00.3057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwSuhMwKVr4Afni8nfNtBqyvEEepZeV79kb+XUZ6f0UnNFXqBccA8PAD9Ro6oDiFB7uy9SfdGxHahKrAJKxv3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Use a single byte mapping for zone restore register (zone matching
remains 16 bit).

This makes room for using the freed 8 bits on register C1 for
mapping more tunnels and tunnel options.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  7 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 67 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    | 10 +--
 3 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index e27963b80c11..ece8f535ce80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -594,7 +594,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct mlx5e_tc_update_priv *tc_priv)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, reg_c0, reg_c1, tunnel_id, zone;
+	u32 chain = 0, reg_c0, reg_c1, tunnel_id, zone_restore_id;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tc_skb_ext *tc_skb_ext;
@@ -631,11 +631,12 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		tc_skb_ext->chain = chain;
 
-		zone = reg_c1 & ZONE_RESTORE_MAX;
+		zone_restore_id = reg_c1 & ZONE_RESTORE_MAX;
 
 		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, zone))
+		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb,
+					      zone_restore_id))
 			return false;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 7b5963593bf1..3802a26e944c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -17,6 +17,7 @@
 #include "esw/chains.h"
 #include "en/tc_ct.h"
 #include "en/mod_hdr.h"
+#include "en/mapping.h"
 #include "en.h"
 #include "en_tc.h"
 #include "en_rep.h"
@@ -46,6 +47,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_flow_table *ct_nat;
 	struct mlx5_flow_table *post_ct;
 	struct mutex control_lock; /* guards parallel adds/dels */
+	struct mapping_ctx *zone_mapping;
 };
 
 struct mlx5_ct_flow {
@@ -77,6 +79,7 @@ struct mlx5_tc_ct_pre {
 struct mlx5_ct_ft {
 	struct rhash_head node;
 	u16 zone;
+	u32 zone_restore_id;
 	refcount_t refcount;
 	struct nf_flowtable *nf_ft;
 	struct mlx5_tc_ct_priv *ct_priv;
@@ -434,7 +437,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 			       u8 ct_state,
 			       u32 mark,
 			       u32 label,
-			       u16 zone)
+			       u8 zone_restore_id)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
@@ -455,7 +458,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 		return err;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
-					ZONE_RESTORE_TO_REG, zone + 1);
+					ZONE_RESTORE_TO_REG, zone_restore_id);
 	if (err)
 		return err;
 
@@ -583,7 +586,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_esw_flow_attr *attr,
 				struct flow_rule *flow_rule,
 				struct mlx5e_mod_hdr_handle **mh,
-				u16 zone, bool nat)
+				u8 zone_restore_id, bool nat)
 {
 	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
 	struct flow_action_entry *meta;
@@ -615,7 +618,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 					     ct_state,
 					     meta->ct_metadata.mark,
 					     meta->ct_metadata.labels[0],
-					     zone);
+					     zone_restore_id);
 	if (err)
 		goto err_mapping;
 
@@ -641,7 +644,7 @@ static int
 mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 			  struct flow_rule *flow_rule,
 			  struct mlx5_ct_entry *entry,
-			  bool nat)
+			  bool nat, u8 zone_restore_id)
 {
 	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
@@ -657,7 +660,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
 					      &zone_rule->mh,
-					      entry->tuple.zone, nat);
+					      zone_restore_id, nat);
 	if (err) {
 		ct_dbg("Failed to create ct entry mod hdr");
 		goto err_mod_hdr;
@@ -701,7 +704,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 static int
 mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 			   struct flow_rule *flow_rule,
-			   struct mlx5_ct_entry *entry)
+			   struct mlx5_ct_entry *entry,
+			   u8 zone_restore_id)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
@@ -713,11 +717,13 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 		return err;
 	}
 
-	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
+	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false,
+					zone_restore_id);
 	if (err)
 		goto err_orig;
 
-	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
+	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true,
+					zone_restore_id);
 	if (err)
 		goto err_nat;
 
@@ -781,7 +787,8 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 			goto err_tuple_nat;
 	}
 
-	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
+	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry,
+					 ft->zone_restore_id);
 	if (err)
 		goto err_rules;
 
@@ -1007,7 +1014,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	}
 
 	if (mask->ct_zone)
-		mlx5e_tc_match_to_reg_match(spec, ZONE_RESTORE_TO_REG,
+		mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
 					    key->ct_zone, MLX5_CT_ZONE_MASK);
 	if (ctstate_mask)
 		mlx5e_tc_match_to_reg_match(spec, CTSTATE_TO_REG,
@@ -1037,18 +1044,6 @@ mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	/* To mark that the need restore ct state on a skb, we mark the
-	 * packet with the zone restore register. To distinguise from an
-	 * uninitalized 0 value for this register, we write zone + 1 on the
-	 * packet.
-	 *
-	 * This restricts us to a max zone of 0xFFFE.
-	 */
-	if (act->ct.zone == (u16)~0) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported ct zone");
-		return -EOPNOTSUPP;
-	}
-
 	attr->ct_attr.zone = act->ct.zone;
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
@@ -1305,6 +1300,10 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	if (!ft)
 		return ERR_PTR(-ENOMEM);
 
+	err = mapping_add(ct_priv->zone_mapping, &zone, &ft->zone_restore_id);
+	if (err)
+		goto err_mapping;
+
 	ft->zone = zone;
 	ft->nf_ft = nf_ft;
 	ft->ct_priv = ct_priv;
@@ -1337,6 +1336,8 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 err_init:
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 err_alloc_pre_ct:
+	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
+err_mapping:
 	kfree(ft);
 	return ERR_PTR(err);
 }
@@ -1363,6 +1364,7 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
+	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);
 }
 
@@ -1786,6 +1788,12 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_alloc;
 	}
 
+	ct_priv->zone_mapping = mapping_create(sizeof(u16), 0, true);
+	if (IS_ERR(ct_priv->zone_mapping)) {
+		err = PTR_ERR(ct_priv->zone_mapping);
+		goto err_mapping;
+	}
+
 	ct_priv->esw = esw;
 	ct_priv->netdev = rpriv->netdev;
 	ct_priv->ct = mlx5_esw_chains_create_global_table(esw);
@@ -1827,6 +1835,8 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 err_ct_nat_tbl:
 	mlx5_esw_chains_destroy_global_table(esw, ct_priv->ct);
 err_ct_tbl:
+	mapping_destroy(ct_priv->zone_mapping);
+err_mapping:
 	kfree(ct_priv);
 err_alloc:
 err_support:
@@ -1845,6 +1855,7 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->post_ct);
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct_nat);
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct);
+	mapping_destroy(ct_priv->zone_mapping);
 
 	rhashtable_destroy(&ct_priv->ct_tuples_ht);
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
@@ -1858,16 +1869,20 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 
 bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
-			 struct sk_buff *skb, u16 zone)
+			 struct sk_buff *skb, u8 zone_restore_id)
 {
 	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
 	struct mlx5_ct_tuple tuple = {};
 	struct mlx5_ct_entry *entry;
+	u16 zone;
 
-	if (!ct_priv || !zone)
+	if (!ct_priv || !zone_restore_id)
 		return true;
 
-	if (!mlx5_tc_ct_skb_to_tuple(skb, &tuple, zone - 1))
+	if (mapping_find(ct_priv->zone_mapping, zone_restore_id, &zone))
+		return false;
+
+	if (!mlx5_tc_ct_skb_to_tuple(skb, &tuple, zone))
 		return false;
 
 	entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, &tuple,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index b5e07bff843b..5e10a72f5f24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -70,9 +70,9 @@ struct mlx5_ct_attr {
 #define zone_restore_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,\
 	.moffset = 0,\
-	.mlen = 2,\
+	.mlen = 1,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
-				 misc_parameters_2.metadata_reg_c_1),\
+				 misc_parameters_2.metadata_reg_c_1) + 3,\
 }
 
 #define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
@@ -113,7 +113,7 @@ mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 
 bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
-			 struct sk_buff *skb, u16 zone);
+			 struct sk_buff *skb, u8 zone_restore_id);
 
 #else /* CONFIG_MLX5_TC_CT */
 
@@ -181,9 +181,9 @@ mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 
 static inline bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
-			 struct sk_buff *skb, u16 zone)
+			 struct sk_buff *skb, u8 zone_restore_id)
 {
-	if (!zone)
+	if (!zone_restore_id)
 		return true;
 
 	return false;
-- 
2.26.2

