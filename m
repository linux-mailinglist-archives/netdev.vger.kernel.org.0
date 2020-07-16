Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA585222E15
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgGPVeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:36 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbgGPVeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEhfADYGTlCSmf4qGmIZqTtA4SWuGQqm4DSwft+VV0PMTBP7sf+D0z1rlANoeryaRoUSvsi/svOrIE1iJOgNY+c6wERqtIs9aU95586CBtkH9VrhZRb3byM040dkUqEWbKk5uJU/Kji1UHdQ0AZxXH4elckGfsoZtXKjgbnuesn2f/kye/lr1w8yAXOmXMt8v65PpQxEeJ6Yc+tFCrM3RpQpTuuhvxJmLf9ztHRl2A+p4WNtcIvSmanRGkCoXPtwJrLPK1Yx7vPWUCgEhKQsccrQWlM6yQY3pEnTD1gQVx2ou1rXXpFvQ0RiBvQkcrScT6kYjUyWKvfoK+6pWUeb5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbITSBu4uh6vbefgG1LLmMMfLSfl9lNV2HBnlTJRTPo=;
 b=WRnnHZ8QiSAxYZeb4QpK/gf7osWfMeftBwoafzYx4mF8kpVz7kT+qyuWrQ/rJQ83GwEHFr7imEe+HET/2eHZ/JRg89PzTO96nUZremVVaxQMXzs7aW+YLXBFEn5kCVHiE07OOwVBYBxrgF1Ocy4cYnWK9vmzzqhC2vHFWlP+y3sdMlnstYaBB1FJOVxkSW6Z8V6MIxd1s/FE9ifgwN5xCHrD5BpA7M47uyvLgBqzvFFAmlWDmf//A925hdKpsZdf0dAUFHFw6SD31XHq4T7Gbh1apYPanDNzNMgg/gUiir1tiGM8Q7jkzM7J5N8/EkuyXAHzWx51KS5QsUD/DFQ+uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbITSBu4uh6vbefgG1LLmMMfLSfl9lNV2HBnlTJRTPo=;
 b=amoMuGtMSS0Yxxstm7PazpsI6e6WxnNlThrXWv3Ahs934hXWAFNkgAZppzGZ3zbVZMJK+9pcqDceCDQAR8ArSNhLo7qNCxt6eAsM2UlCkzqBzdhtWhicO0/z9bEL/BjUVRpTAkSXPEEuh4zFP1kaJUdXeypnNKj04UVSlu6K0uM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Maor Dickman <maord@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5e: CT: Map 128 bits labels to 32 bit map ID
Date:   Thu, 16 Jul 2020 14:33:21 -0700
Message-Id: <20200716213321.29468-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:13 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c441cc8-365a-474d-9c92-08d829cffd2a
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB299207BAD82C2E34DF16DEF8BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5yRNxELdaql5v4ykvccKRUFillfebg3JM4hl3XwAog32ej1WbMSnN1iQIfGASjp3Es6RJRu3itUYsYNwwCFc76mjqZ5dydF8D3BKm7150Fb8o1KAOK57q5uQgZzP5ephxZxX8rPEZhxWSEobCnzwzdnjfKyK1e2GdfHdJUEsAzxCmgs8C9BYNQCTZI5X7menYP38qUWDdspBFcnZzUhDsfaA86PVTiJjVvl0RicYWPW/U9UdfNOY5Jsfnnn91LxY7Kd8WXO630/IXs1t0FVTfcmOOTtqyaS0eenGO0NDdvDCt0yCxQdu/7QLsmqYhS3VEeY+rv/hV3svldbvTc9e03wlbMOL3gyIS5sSFNIlXN2VGa5Ma/o/x9fza1OkMEm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4lxm7OhfCF6iFAvpW99b38AU9hZ68a/TM1h01Z9/429xEOcWhM1zrrHSimMpBoKsBw+Frq4804hsErdgEz0/XlMswBQy4PiD6p/PhWFyPbmi4TaWbYf0wvpnjEhwmjVczdvFR6Ah0Tu41W2+g9LC0cmtkluwpSXFdDEF693R7gIZ4lHkeGzM0mj8qfIGkK/E2nXzMSzUe7RDpVn865VzpTynTaLKWcorOpyuhHkhkTSBQa8/aOdWQOVzj/LEH/cSmMt+ulZQpUROVpTdQY9uvndUmXHE7MvjL5MogNRH6uSKs7FjbN7s/Gg7Y5u/Yt9OhdWpTCB1nDQ5W4yCN0DuhcNldtsxjvXjlhxerRIlwbySeBE/FV53qVouJpy243NFL5X+3iiRjqSk8INV55hgGECj1mQtJMLLCzOc7Xgd4Lsw6aweThPidDthcsMB7lwt7BO5qAptE9pTuIWd9tKVqZvd3ie/saoHNjPAGyogZSE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c441cc8-365a-474d-9c92-08d829cffd2a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:15.9010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxPjmO8+oTf4BxoYaUBVIIW/jYziaMD3uUzBvFnjQ+tzN7kak4B8dpVY6EDcuYuFm2X61PKft2/+P8y9CSZmhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

The 128 bits ct_label field is matched using a 32 bit hardware register.
As such, only the lower 32 bits of ct_label field are offloaded. Change
this logic to support setting and matching higher bits too.
Map the 128 bits data to a unique 32 bits ID. Matching is done as exact
match of the mapping ID of key & mask.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Maor Dickman <maord@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 59 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  3 +-
 3 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 4c65677feaabf..c6bc9224c3b18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -32,6 +32,9 @@
 #define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
 #define MLX5_FTE_ID_MASK MLX5_FTE_ID_MAX
 
+#define MLX5_CT_LABELS_BITS (mlx5e_tc_attr_to_reg_mappings[LABELS_TO_REG].mlen * 8)
+#define MLX5_CT_LABELS_MASK GENMASK(MLX5_CT_LABELS_BITS - 1, 0)
+
 #define ct_dbg(fmt, args...)\
 	netdev_dbg(ct_priv->netdev, "ct_debug: " fmt "\n", ##args)
 
@@ -48,6 +51,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_flow_table *post_ct;
 	struct mutex control_lock; /* guards parallel adds/dels */
 	struct mapping_ctx *zone_mapping;
+	struct mapping_ctx *labels_mapping;
 };
 
 struct mlx5_ct_flow {
@@ -404,6 +408,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
 	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
 			     &esw->offloads.mod_hdr, zone_rule->mh);
+	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 }
 
 static void
@@ -436,7 +441,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 			       struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			       u8 ct_state,
 			       u32 mark,
-			       u32 label,
+			       u32 labels_id,
 			       u8 zone_restore_id)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
@@ -453,7 +458,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 		return err;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
-					LABELS_TO_REG, label);
+					LABELS_TO_REG, labels_id);
 	if (err)
 		return err;
 
@@ -597,13 +602,10 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (!meta)
 		return -EOPNOTSUPP;
 
-	if (meta->ct_metadata.labels[1] ||
-	    meta->ct_metadata.labels[2] ||
-	    meta->ct_metadata.labels[3]) {
-		ct_dbg("Failed to offload ct entry due to unsupported label");
+	err = mapping_add(ct_priv->labels_mapping, meta->ct_metadata.labels,
+			  &attr->ct_attr.ct_labels_id);
+	if (err)
 		return -EOPNOTSUPP;
-	}
-
 	if (nat) {
 		err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule,
 						  &mod_acts);
@@ -617,7 +619,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	err = mlx5_tc_ct_entry_set_registers(ct_priv, &mod_acts,
 					     ct_state,
 					     meta->ct_metadata.mark,
-					     meta->ct_metadata.labels[0],
+					     attr->ct_attr.ct_labels_id,
 					     zone_restore_id);
 	if (err)
 		goto err_mapping;
@@ -637,6 +639,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 
 err_mapping:
 	dealloc_mod_hdr_actions(&mod_acts);
+	mapping_remove(ct_priv->labels_mapping, attr->ct_attr.ct_labels_id);
 	return err;
 }
 
@@ -959,6 +962,7 @@ int
 mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
 		       struct flow_cls_offload *f,
+		       struct mlx5_ct_attr *ct_attr,
 		       struct netlink_ext_ack *extack)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
@@ -969,6 +973,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	u16 ct_state_on, ct_state_off;
 	u16 ct_state, ct_state_mask;
 	struct flow_match_ct match;
+	u32 ct_labels[4];
 
 	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CT))
 		return 0;
@@ -995,12 +1000,6 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (mask->ct_labels[1] || mask->ct_labels[2] || mask->ct_labels[3]) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "only lower 32bits of ct_labels are supported for offload");
-		return -EOPNOTSUPP;
-	}
-
 	ct_state_on = ct_state & ct_state_mask;
 	ct_state_off = (ct_state & ct_state_mask) ^ ct_state_mask;
 	trk = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
@@ -1029,10 +1028,17 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	if (mask->ct_mark)
 		mlx5e_tc_match_to_reg_match(spec, MARK_TO_REG,
 					    key->ct_mark, mask->ct_mark);
-	if (mask->ct_labels[0])
-		mlx5e_tc_match_to_reg_match(spec, LABELS_TO_REG,
-					    key->ct_labels[0],
-					    mask->ct_labels[0]);
+	if (mask->ct_labels[0] || mask->ct_labels[1] || mask->ct_labels[2] ||
+	    mask->ct_labels[3]) {
+		ct_labels[0] = key->ct_labels[0] & mask->ct_labels[0];
+		ct_labels[1] = key->ct_labels[1] & mask->ct_labels[1];
+		ct_labels[2] = key->ct_labels[2] & mask->ct_labels[2];
+		ct_labels[3] = key->ct_labels[3] & mask->ct_labels[3];
+		if (mapping_add(ct_priv->labels_mapping, ct_labels, &ct_attr->ct_labels_id))
+			return -EOPNOTSUPP;
+		mlx5e_tc_match_to_reg_match(spec, LABELS_TO_REG, ct_attr->ct_labels_id,
+					    MLX5_CT_LABELS_MASK);
+	}
 
 	return 0;
 }
@@ -1398,7 +1404,7 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  * + tuple + zone match +
  * +--------------------+
  *      | set mark
- *      | set label
+ *      | set labels_id
  *      | set established
  *	| set zone_restore
  *      | do nat (if needed)
@@ -1789,7 +1795,13 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	ct_priv->zone_mapping = mapping_create(sizeof(u16), 0, true);
 	if (IS_ERR(ct_priv->zone_mapping)) {
 		err = PTR_ERR(ct_priv->zone_mapping);
-		goto err_mapping;
+		goto err_mapping_zone;
+	}
+
+	ct_priv->labels_mapping = mapping_create(sizeof(u32) * 4, 0, true);
+	if (IS_ERR(ct_priv->labels_mapping)) {
+		err = PTR_ERR(ct_priv->labels_mapping);
+		goto err_mapping_labels;
 	}
 
 	ct_priv->esw = esw;
@@ -1833,8 +1845,10 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 err_ct_nat_tbl:
 	mlx5_esw_chains_destroy_global_table(esw, ct_priv->ct);
 err_ct_tbl:
+	mapping_destroy(ct_priv->labels_mapping);
+err_mapping_labels:
 	mapping_destroy(ct_priv->zone_mapping);
-err_mapping:
+err_mapping_zone:
 	kfree(ct_priv);
 err_alloc:
 err_support:
@@ -1854,6 +1868,7 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct_nat);
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct);
 	mapping_destroy(ct_priv->zone_mapping);
+	mapping_destroy(ct_priv->labels_mapping);
 
 	rhashtable_destroy(&ct_priv->ct_tuples_ht);
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 5e10a72f5f240..3baef917a677a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -25,6 +25,7 @@ struct mlx5_ct_attr {
 	u16 ct_action;
 	struct mlx5_ct_flow *ct_flow;
 	struct nf_flowtable *nf_ft;
+	u32 ct_labels_id;
 };
 
 #define zone_to_reg_ct {\
@@ -90,6 +91,7 @@ int
 mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
 		       struct flow_cls_offload *f,
+		       struct mlx5_ct_attr *ct_attr,
 		       struct netlink_ext_ack *extack);
 int
 mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
@@ -132,6 +134,7 @@ static inline int
 mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
 		       struct flow_cls_offload *f,
+		       struct mlx5_ct_attr *ct_attr,
 		       struct netlink_ext_ack *extack)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b366c46a56041..7a0c22d05575a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4401,7 +4401,8 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 		goto err_free;
 
 	/* actions validation depends on parsing the ct matches first */
-	err = mlx5_tc_ct_parse_match(priv, &parse_attr->spec, f, extack);
+	err = mlx5_tc_ct_parse_match(priv, &parse_attr->spec, f,
+				     &flow->esw_attr->ct_attr, extack);
 	if (err)
 		goto err_free;
 
-- 
2.26.2

