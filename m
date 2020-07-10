Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B372121ADAC
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgGJDsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:16 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:20294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbgGJDsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ0jeIyebJGx36YHFG08Hwif38x3Igd5G77iabdfR21DnKTp/Np5NbK3E+WnZdAKNnyQzaKQmt58cXHZHjJv8OMfOnG/XIXvvo2vnj/oEgOqu3d4vZkR/q4kUb8L2Id3hsEc7lo1WDyG6nXe+q3CtVnXG4RTTX49+px929cGfYnYRA7vzJ/5sGv3u9M6WPzqFJkeE5DC9x9X1Z5w1ID6i3e/e1kvHyPvviY5a+vYSNDfDMjPghEKdmwH/Q+eylWg6LpeZUgjezt/0r5VFuccH7muqrC+xnLDO89dIuJcE4aUYBROi/I25wFiytNIdSQUEb8uwKmVHFQxvYpIga8C9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUFngE4EAnGcV5H9c/Ej14kaVmIZ2T1MZgGSjYr6c+Q=;
 b=iirotHQrvOFSMOQD7ZW7+CI8UbDzkHJy8yFShz13LGFvBzbT9L2BNy8c/YWaoiIBu4Bg7eCWx6pR9Puz4nzvw+ssgHQjCvu51X8I3mt6spujrEW7rZPN4PzblP2+1Pg3KHfycdBqBYzAxTDE7Qs5gdoOC53EAfPYqs8urp6FnX/tLGA3roCD0lnWBnNNgOnZ2TwARkKQ5RxpJ/zY8gPBWnUbIwf8sN4wywl9dV8U8Hw6c4CdQsRJbX3Fc4EcGVOdSa8r2wNliVqZgI6sdLS1Hl6c5h/GvTHop219JWICOjZFgf4AypJeLAqTcI+SyeoEVxGTeE2GD+JDdo3iLGTCCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUFngE4EAnGcV5H9c/Ej14kaVmIZ2T1MZgGSjYr6c+Q=;
 b=of/qhYuN+wK0WIaeT4xXhMreixBsTzCsVF6JCm+QWY5+e8Ts2XV8XsHNowSHKGWp7bZ4Ugk9MnyYRkH3AvyrBT02b8Q9ipG/e8hfbT3h4xyDHAG0mG6MiPU0SC7VlysPYDDiD4lD+04Zr6RhgbydR2XViqzwrfoLdYvNdXNg4gY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/13] net/mlx5e: CT: Re-use tuple modify headers for identical modify actions
Date:   Thu,  9 Jul 2020 20:44:27 -0700
Message-Id: <20200710034432.112602-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:56 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 764d1b18-169f-41e7-6ada-08d8248408f0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512FC13327A9854201BD888BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwjbuTYdURUKdG5lpJuXwCkX5ctRIrTcZqmPPud5eZQBnrwTg19ibpVll4qYhlArvjYEqsFbdxafEIvNIlOM9hAcSqROjjgGGI+8nsOjhia1IvlGpPIFq792RQUabK6vUiMlnAeHOPxaU8OUfMNy+BfESKVFZcOmL7SvyQvhcGCdM8kw2cjwnRFg/ObVM7Ayk10DuPnwOG16ZiiVPBxdigUWs6rZQw5vwEQuBqY20vGIdZhZa4ASNPWETbOOgmZ/44bMqDyW0yr80FlNx9AdFMyR06SIpcGhqqO6+nt3SA70kxoPxelqI2HvqNG33wlusln2+R+N/qeiWvkbprVMaWGndEaEFPh/RRG5+FnbcQ+dH9+UFrdVye0hbBDxhqL6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Itx0eyv8iQ43wfdIrxheztr1l5nmkFLvyfjuo6Wg2Zwny00MflaCrgpm9jR2nwi4VcPtCSAjJV4yw059qR6359W1MryJb6gBMh/OX1W1xKdzddkhKEoEKDbmOaOEydQzvieG+N4/kiMgIgGwOFKXv7Xkcx3gN3pHpyviMlVLsghUGx+8LOqVIVtCn4exl9tGrCQuh735ILsHvFbglMe41r69/nxx0OqVWVXI56gchjDpR2DBt8DyXv6pJ0Fa3D6tHcaeykysJk+yKkM+DTL/DJDyOs4/i3ksvDnLridJ+S2Soruu7iYVxr7Ce72Jiq8c0Sq1k1QpbDD7sMvZ3A594M3dQDPaALNAK+kJu6vJ0zpNiHJ1qjeP2cPoUsviU8EKfaXwETAOvEj6v5yhG5Nw78MGQt6Vn2HdQ7q+wmSZb9pzz/dkOJ4O6b5qlhKXtTDozwbfxYBzlcg7R6MeiA1fwRceawDugMNMqpmsFWbEWlQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 764d1b18-169f-41e7-6ada-08d8248408f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:57.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uihbqRyoPP/f9klKhkHC4lGvbEOClLK1ole4o1r3k4X6GyxKyFM2pD2s1u+qPSMZ2f/1FpXA5FdL8WiOITlvCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

After removing the tupleid register which changed per tuple,
tuple modify headers set the ct_state, zone, mark, and label registers.
For non-natted tuples going through the same tc rules path, their values
will be the same, and all their modify headers will be the same.

Re-use tuple modify header when possible, by adding each new modify
header to an hahstable, and looking up identical ones before creating
a new one.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index c6e92f818ecf..7b5963593bf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -16,6 +16,7 @@
 
 #include "esw/chains.h"
 #include "en/tc_ct.h"
+#include "en/mod_hdr.h"
 #include "en.h"
 #include "en_tc.h"
 #include "en_rep.h"
@@ -59,6 +60,7 @@ struct mlx5_ct_flow {
 
 struct mlx5_ct_zone_rule {
 	struct mlx5_flow_handle *rule;
+	struct mlx5e_mod_hdr_handle *mh;
 	struct mlx5_esw_flow_attr attr;
 	bool nat;
 };
@@ -397,7 +399,8 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 	ct_dbg("Deleting ct entry rule in zone %d", entry->tuple.zone);
 
 	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
-	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
+	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
+			     &esw->offloads.mod_hdr, zone_rule->mh);
 }
 
 static void
@@ -579,11 +582,10 @@ static int
 mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_esw_flow_attr *attr,
 				struct flow_rule *flow_rule,
+				struct mlx5e_mod_hdr_handle **mh,
 				u16 zone, bool nat)
 {
 	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
-	struct mlx5_eswitch *esw = ct_priv->esw;
-	struct mlx5_modify_hdr *mod_hdr;
 	struct flow_action_entry *meta;
 	u16 ct_state = 0;
 	int err;
@@ -617,14 +619,15 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	mod_hdr = mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_FDB,
-					   mod_acts.num_actions,
-					   mod_acts.actions);
-	if (IS_ERR(mod_hdr)) {
-		err = PTR_ERR(mod_hdr);
+	*mh = mlx5e_mod_hdr_attach(ct_priv->esw->dev,
+				   &ct_priv->esw->offloads.mod_hdr,
+				   MLX5_FLOW_NAMESPACE_FDB,
+				   &mod_acts);
+	if (IS_ERR(*mh)) {
+		err = PTR_ERR(*mh);
 		goto err_mapping;
 	}
-	attr->modify_hdr = mod_hdr;
+	attr->modify_hdr = mlx5e_mod_hdr_get(*mh);
 
 	dealloc_mod_hdr_actions(&mod_acts);
 	return 0;
@@ -653,6 +656,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 		return -ENOMEM;
 
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
+					      &zone_rule->mh,
 					      entry->tuple.zone, nat);
 	if (err) {
 		ct_dbg("Failed to create ct entry mod hdr");
@@ -687,7 +691,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 
 err_rule:
-	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
+	mlx5e_mod_hdr_detach(ct_priv->esw->dev,
+			     &esw->offloads.mod_hdr, zone_rule->mh);
 err_mod_hdr:
 	kfree(spec);
 	return err;
-- 
2.26.2

