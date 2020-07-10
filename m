Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734CE21ADA9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgGJDsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:04 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbgGJDsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbcohYsTB6e9/YFL6Ofl9TtV259UJGVg/xT1MStrXB2G8vgw54vbAsh+h5NevTm3bt4OVQWv9y+TNicWfqWoF315ofSm344PyGcYVW7+iZKloLy9T9EJUpuvY5sOKdEwdRVuVE8pDX4uERkcagvZAGb0+N/f4mmonH5r72FtgHQEzAbAkr8d5IaD6xF/LNLe2Mr/k2U/evVm7dVbmNhqYXP1eyzFJFeYjs6h+VjaD4sz4aqvEs1RpI491oICXSoeHk1JiBfHkdfFUZz8FPsnn5969aKVTc3Vv3pvC49Y4z8RAcnnR1XhrAXxxg4ci2nG+F5ZHlE++qbW6me9s9oiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhxZicwLG6K4wJ2AoCyK/8gvLQcri9hhNERn0fa3zyI=;
 b=QM/HIDM+DGBZNwtBWWIUVKK37Ak03MieJIWOZKJFlmZrv1krxsXLiZ7qeDDIplU8Q0IUMIcfzj182PSzzBfENAwurdaFi78REVSP+2+3iYIeNZ4vmtt9hGpmKWaXRkVInqylAyRo989hz0cT2qPzzUz+wopU/YBrTrJKUOPYaMxYYG/Ae+fP2U3wx3XtDQU5+AFDZ95lF03DXH1Ekf8K/p9KGW5rWLb7bgRNHhD+05H9ppbl7zA7wYw19PpNbJuRi6W5RjDxhHSve89CFgPtpj6xfOQA5Wk/4N0pw7Kw5bx5sP3ao/E00PNDfwAAC/pZys4VDsMJAhv8XGNnNRSrEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhxZicwLG6K4wJ2AoCyK/8gvLQcri9hhNERn0fa3zyI=;
 b=T39HI79HRqZN7A5jKkSklkxDs6dZZra0PcxFxWhXVzeOmyHgeUiR3/4wvXzLjiBro89GXt3L7JcCfFEwQOq0YW+uBl2t35TbNj0fYN9OuPT8rywe3QNZiZKgyyu4yOd7nLMSzFFNZrp62+NVGAL5xA3D6/jXTiaAs73GHekU29U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/13] net/mlx5e: CT: Restore ct state from lookup in zone instead of tupleid
Date:   Thu,  9 Jul 2020 20:44:25 -0700
Message-Id: <20200710034432.112602-7-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2428c223-4b98-4686-1fcc-08d824840619
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB451259D045A392232E79D01BBE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:451;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: agyqiwlrE1syxxVCEMs2BUu8V1RUYqayRTvhyunhHzSO3XbizPbCS3hc+UB6KIl8Re5+3FwNzk89aV3mDjcmugca7vyu08lkVix03Qzw+TCpEX9EnKgv+fNBn7iecm/sCDmwfItJ55L93+Xeq/2Y3BsfHvw/QFXGN2BCNsyztcPxse3q7lCDIR2e8BTLZej1K/XP9QOF7KTpmfdf/l9LT2YTGyeZQkz4Km5oWuzsW5YXh6X5keHM2/0czCCk5P80eM9CPQR/ZNu2dIL0o1mSCYZmecpD2COXOwCIs+pY+ireJzmkqsfSXNnljyiA50UOxLswgpIbeAz/Lknuk8eN/+ykzRAcsoO9lliCO3ycdum9mHVhcGH6AjsRvSkec55m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(30864003)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: szb1CCTeOumjTO/0LOSzfsy8D+cVhPcO32CiUDpGZzXEKQQ1o0ilhQCc2XiJtVKb27hrnPl5MEoJdmBpQptIQUmqTPakdXT66OnhyG4eMTBBJxbsZZUodnjRoxAOVVAFzuDvk1CFmR3sTAk2qLKZ6ovFnahtevZk48lTjAZjWKFYv9kCFmi+yMdbRkYjI8yk7KxcqMFzWS/aAOv+2sXeZnoXe0csnRn++ZjBBMhxvFiuwO52VW7hu984GMhEKqkzYIkZH1Dic1ioDoJqXm7bcZVvt/th7cNiS416+vKtbL8/Xc/75FbhdUbMvjCBdtALoenXo25pWESerpEcFzrTgm6RFX4+gLA4NkFrkndQfMihaqmiAd4cvvi9t6tSX9nbqH1y+I3WIy0EKDx/gtUF9H5Z86rXxbk4d8Ak4uz9z55jxXl5WesHJVp8RratyYUrkuKCTos3FrJKxP6M8FCpfYA6VOT8N5EVMdyWXh92ZMs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2428c223-4b98-4686-1fcc-08d824840619
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:53.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ra1hhtD8092dXPdHvUlmJ5FdKJKJgJRvJmS9oWuy3rpySloGsS2MV1pI7leKBQ7QrYLV7ah93/EnXF+SbmZrgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Remove tupleid, and replace it with zone_restore, which is the zone an
established tuple sets after match. On miss, Use this zone + tuple
taken from the skb, to lookup the ct entry and restore it.

This improves flow insertion rate by avoiding the allocation of a header
rewrite context.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 113 ++++++++++++------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  17 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   2 +-
 5 files changed, 90 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index eefeb1cdc2ee..e27963b80c11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -594,7 +594,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct mlx5e_tc_update_priv *tc_priv)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
+	u32 chain = 0, reg_c0, reg_c1, tunnel_id, zone;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tc_skb_ext *tc_skb_ext;
@@ -631,11 +631,11 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		tc_skb_ext->chain = chain;
 
-		tuple_id = reg_c1 & TUPLE_ID_MAX;
+		zone = reg_c1 & ZONE_RESTORE_MAX;
 
 		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
+		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, zone))
 			return false;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 08ebce35b2fc..c6e92f818ecf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -60,7 +60,6 @@ struct mlx5_ct_flow {
 struct mlx5_ct_zone_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_esw_flow_attr attr;
-	int tupleid;
 	bool nat;
 };
 
@@ -107,7 +106,6 @@ struct mlx5_ct_tuple {
 };
 
 struct mlx5_ct_entry {
-	u16 zone;
 	struct rhash_head node;
 	struct rhash_head tuple_node;
 	struct rhash_head tuple_nat_node;
@@ -396,11 +394,10 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 
-	ct_dbg("Deleting ct entry rule in zone %d", entry->zone);
+	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
 
 	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
-	xa_erase(&ct_priv->tuple_ids, zone_rule->tupleid);
 }
 
 static void
@@ -434,7 +431,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 			       u8 ct_state,
 			       u32 mark,
 			       u32 label,
-			       u32 tupleid)
+			       u16 zone)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
@@ -455,7 +452,7 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 		return err;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_acts,
-					TUPLEID_TO_REG, tupleid);
+					ZONE_RESTORE_TO_REG, zone + 1);
 	if (err)
 		return err;
 
@@ -582,8 +579,7 @@ static int
 mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_esw_flow_attr *attr,
 				struct flow_rule *flow_rule,
-				u32 tupleid,
-				bool nat)
+				u16 zone, bool nat)
 {
 	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
 	struct mlx5_eswitch *esw = ct_priv->esw;
@@ -617,7 +613,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 					     ct_state,
 					     meta->ct_metadata.mark,
 					     meta->ct_metadata.labels[0],
-					     tupleid);
+					     zone);
 	if (err)
 		goto err_mapping;
 
@@ -648,7 +644,6 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_spec *spec = NULL;
-	u32 tupleid;
 	int err;
 
 	zone_rule->nat = nat;
@@ -657,18 +652,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	if (!spec)
 		return -ENOMEM;
 
-	/* Get tuple unique id */
-	err = xa_alloc(&ct_priv->tuple_ids, &tupleid, zone_rule,
-		       XA_LIMIT(1, TUPLE_ID_MAX), GFP_KERNEL);
-	if (err) {
-		netdev_warn(ct_priv->netdev,
-			    "Failed to allocate tuple id, err: %d\n", err);
-		goto err_xa_alloc;
-	}
-	zone_rule->tupleid = tupleid;
-
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
-					      tupleid, nat);
+					      entry->tuple.zone, nat);
 	if (err) {
 		ct_dbg("Failed to create ct entry mod hdr");
 		goto err_mod_hdr;
@@ -686,7 +671,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
-				    entry->zone & MLX5_CT_ZONE_MASK,
+				    entry->tuple.zone & MLX5_CT_ZONE_MASK,
 				    MLX5_CT_ZONE_MASK);
 
 	zone_rule->rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
@@ -697,15 +682,13 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	}
 
 	kfree(spec);
-	ct_dbg("Offloaded ct entry rule in zone %d", entry->zone);
+	ct_dbg("Offloaded ct entry rule in zone %d", entry->tuple.zone);
 
 	return 0;
 
 err_rule:
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
 err_mod_hdr:
-	xa_erase(&ct_priv->tuple_ids, zone_rule->tupleid);
-err_xa_alloc:
 	kfree(spec);
 	return err;
 }
@@ -766,7 +749,6 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	if (!entry)
 		return -ENOMEM;
 
-	entry->zone = ft->zone;
 	entry->tuple.zone = ft->zone;
 	entry->cookie = flow->cookie;
 	entry->restore_cookie = meta_action->ct_metadata.cookie;
@@ -894,6 +876,48 @@ mlx5_tc_ct_block_flow_offload(enum tc_setup_type type, void *type_data,
 	return -EOPNOTSUPP;
 }
 
+static bool
+mlx5_tc_ct_skb_to_tuple(struct sk_buff *skb, struct mlx5_ct_tuple *tuple,
+			u16 zone)
+{
+	struct flow_keys flow_keys;
+
+	skb_reset_network_header(skb);
+	skb_flow_dissect_flow_keys(skb, &flow_keys, 0);
+
+	tuple->zone = zone;
+
+	if (flow_keys.basic.ip_proto != IPPROTO_TCP &&
+	    flow_keys.basic.ip_proto != IPPROTO_UDP)
+		return false;
+
+	tuple->port.src = flow_keys.ports.src;
+	tuple->port.dst = flow_keys.ports.dst;
+	tuple->n_proto = flow_keys.basic.n_proto;
+	tuple->ip_proto = flow_keys.basic.ip_proto;
+
+	switch (flow_keys.basic.n_proto) {
+	case htons(ETH_P_IP):
+		tuple->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		tuple->ip.src_v4 = flow_keys.addrs.v4addrs.src;
+		tuple->ip.dst_v4 = flow_keys.addrs.v4addrs.dst;
+		break;
+
+	case htons(ETH_P_IPV6):
+		tuple->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		tuple->ip.src_v6 = flow_keys.addrs.v6addrs.src;
+		tuple->ip.dst_v6 = flow_keys.addrs.v6addrs.dst;
+		break;
+	default:
+		goto out;
+	}
+
+	return true;
+
+out:
+	return false;
+}
+
 int
 mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
 			    struct mlx5_flow_spec *spec)
@@ -978,7 +1002,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	}
 
 	if (mask->ct_zone)
-		mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
+		mlx5e_tc_match_to_reg_match(spec, ZONE_RESTORE_TO_REG,
 					    key->ct_zone, MLX5_CT_ZONE_MASK);
 	if (ctstate_mask)
 		mlx5e_tc_match_to_reg_match(spec, CTSTATE_TO_REG,
@@ -1008,6 +1032,18 @@ mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	/* To mark that the need restore ct state on a skb, we mark the
+	 * packet with the zone restore register. To distinguise from an
+	 * uninitalized 0 value for this register, we write zone + 1 on the
+	 * packet.
+	 *
+	 * This restricts us to a max zone of 0xFFFE.
+	 */
+	if (act->ct.zone == (u16)~0) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ct zone");
+		return -EOPNOTSUPP;
+	}
+
 	attr->ct_attr.zone = act->ct.zone;
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
@@ -1349,6 +1385,7 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  *      | set mark
  *      | set label
  *      | set established
+ *	| set zone_restore
  *      | do nat (if needed)
  *      v
  * +--------------+
@@ -1770,7 +1807,6 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	}
 
 	idr_init(&ct_priv->fte_ids);
-	xa_init_flags(&ct_priv->tuple_ids, XA_FLAGS_ALLOC1);
 	mutex_init(&ct_priv->control_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
@@ -1809,7 +1845,6 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
-	xa_destroy(&ct_priv->tuple_ids);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
 
@@ -1818,22 +1853,26 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 
 bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
-			 struct sk_buff *skb, u32 tupleid)
+			 struct sk_buff *skb, u16 zone)
 {
 	struct mlx5_tc_ct_priv *ct_priv = uplink_priv->ct_priv;
-	struct mlx5_ct_zone_rule *zone_rule;
+	struct mlx5_ct_tuple tuple = {};
 	struct mlx5_ct_entry *entry;
 
-	if (!ct_priv || !tupleid)
+	if (!ct_priv || !zone)
 		return true;
 
-	zone_rule = xa_load(&ct_priv->tuple_ids, tupleid);
-	if (!zone_rule)
+	if (!mlx5_tc_ct_skb_to_tuple(skb, &tuple, zone - 1))
 		return false;
 
-	entry = container_of(zone_rule, struct mlx5_ct_entry,
-			     zone_rules[zone_rule->nat]);
-	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
+	entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, &tuple,
+				       tuples_ht_params);
+	if (!entry)
+		entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_nat_ht,
+					       &tuple, tuples_nat_ht_params);
+	if (!entry)
+		return false;
 
+	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 94f74cf71ce4..b5e07bff843b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -67,16 +67,17 @@ struct mlx5_ct_attr {
 				 misc_parameters_2.metadata_reg_c_5),\
 }
 
-#define tupleid_to_reg_ct {\
+#define zone_restore_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,\
 	.moffset = 0,\
-	.mlen = 3,\
+	.mlen = 2,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_1),\
 }
 
-#define TUPLE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[TUPLEID_TO_REG].mlen * 8)
-#define TUPLE_ID_MAX GENMASK(TUPLE_ID_BITS - 1, 0)
+#define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
+#define ZONE_RESTORE_BITS (REG_MAPPING_MLEN(ZONE_RESTORE_TO_REG) * 8)
+#define ZONE_RESTORE_MAX GENMASK(ZONE_RESTORE_BITS - 1, 0)
 
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
@@ -112,7 +113,7 @@ mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 
 bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
-			 struct sk_buff *skb, u32 tupleid);
+			 struct sk_buff *skb, u16 zone);
 
 #else /* CONFIG_MLX5_TC_CT */
 
@@ -180,10 +181,10 @@ mlx5_tc_ct_delete_flow(struct mlx5e_priv *priv,
 
 static inline bool
 mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
-			 struct sk_buff *skb, u32 tupleid)
+			 struct sk_buff *skb, u16 zone)
 {
-	if  (!tupleid)
-		return  true;
+	if (!zone)
+		return true;
 
 	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fd984ef234b2..090069e936b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -186,11 +186,11 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 					 misc_parameters_2.metadata_reg_c_1),
 	},
 	[ZONE_TO_REG] = zone_to_reg_ct,
+	[ZONE_RESTORE_TO_REG] = zone_restore_to_reg_ct,
 	[CTSTATE_TO_REG] = ctstate_to_reg_ct,
 	[MARK_TO_REG] = mark_to_reg_ct,
 	[LABELS_TO_REG] = labels_to_reg_ct,
 	[FTEID_TO_REG] = fteid_to_reg_ct,
-	[TUPLEID_TO_REG] = tupleid_to_reg_ct,
 };
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 68d49b945184..856e034b92f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -129,10 +129,10 @@ enum mlx5e_tc_attr_to_reg {
 	TUNNEL_TO_REG,
 	CTSTATE_TO_REG,
 	ZONE_TO_REG,
+	ZONE_RESTORE_TO_REG,
 	MARK_TO_REG,
 	LABELS_TO_REG,
 	FTEID_TO_REG,
-	TUPLEID_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
-- 
2.26.2

