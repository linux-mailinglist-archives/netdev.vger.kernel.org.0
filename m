Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517BE233D0D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgGaB63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:58:29 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:58208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731162AbgGaB62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:58:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyLJf5eDnNluUVdoQZFGfMS1eZDXwbyJrgoVO1PuZgSak+LCb6Owepf2HemvECH/ply9dkjujPW+Cqge/w65qlrAHGJcQrRTJdfTZgEoV2FMHN38Y3rumLB2Or9C+7uO6vCRr52jkEq/2fFIfwPXdXng8Td1Cyko2v4Y3KcYQv4HdHK60LS6wDiMwiggkZeqxAnTpY7edDMjWdBVSYumufmvSFUTHE/9hMvmEvt2T7WAzkLZ8ZiphXUqIwNcg3EuIrn0AuUO5boMgq6BluLRtD4oAzAU1zLRaDUvtv0i0p8vPwHFRvrrjWd5t6GgZYvnQGlHQyBfOMpwjWwyKwFY6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnqMfe+puJzhIlPKhruOBlPQum0NBHYFy0e4meR8mvs=;
 b=hgDaadOWfIiiYUDuF2YxKycF5jeuDMArcwDkKIodLHvx6ZgLOQ5MDs6MbRYpxzUtBi24WWss6kh3SbP7phSvTFaXBA8h2krADRVL02+Huiaf5u6r+h50ujeunNcxAyaFopfYprrmxYheJL5K5dwD1HNA/upo6pKwXkUKKO9XwBmw4afc5wvN42TcwvoZolwNh1+2t8iun+FzRG9zRMlcN46vL6upvuMXD74V68UoOY/IAM2TxtKfdj77hurjv1MJmppj7qz0QM0IqUbKpj0iprRacftaoGlm8iYUo0a/5eRue7Dy7yYJ+/PP90/cvNvby5ln7VpCg3YI072DnT9nWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnqMfe+puJzhIlPKhruOBlPQum0NBHYFy0e4meR8mvs=;
 b=IhWDy/Pu5r4GCr4jF1RxWCyVleoNTrJU8FiDcedoUearHD61yZjS7L/jJY9iZ5JsS5wJa5jBFHgvLmj5yaHFjnmsRZ8/Sh2m+ZAYW2VEiP7XR7lWZt+bbKLN0OmgJiNjcaeCLT8PGMU+ByHKCI0GRLwdBJg/5Tk6sqrpSUbkFPs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3997.eurprd05.prod.outlook.com (2603:10a6:803:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 01:58:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 01:58:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@mellanox.com>,
        Chris Mi <chrism@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/4] net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring
Date:   Thu, 30 Jul 2020 18:57:50 -0700
Message-Id: <20200731015752.28665-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731015752.28665-1-saeedm@mellanox.com>
References: <20200731015752.28665-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0075.namprd07.prod.outlook.com (2603:10b6:a03:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 01:58:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7294df7e-a344-4555-e0e6-08d834f53240
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3997D9B422E0A3EFFF377BC5BE4E0@VI1PR0502MB3997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pU6IU0YEskcJ8DWqtER/P2CxRG8zumPisgZBz55PdcJxtvsm5T1xVw3hnt9N1eWWedXcTevGUxHaNwV1CTD/yM7zRZEndJIsRMWOIK1O8QmwJGqd8dNXe4nSg2tnqrsAjG0cFltrLhr5xNvTPTbgdkVTLdHG0BfWRj29lca8EvImopiDUBgCjXOFAiITvwXF25/UE7SahkK0zdh83JSzIW/YXa9SUE1n4Yk77AUAjKNpCn4BlueZBYFAUVZUAiCYCWv+ql7BwL9vWlJx6I113EN6Oj0XRrasycZqq9oAt+Dt1eRbhbu2J66pXHogAza/k4QI4bc5YmPVGRAAqmYYdu+TWWTXsY5XRZcM2duAh4pAcGzFKO0vm45LssWGzn9+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(4326008)(5660300002)(1076003)(16526019)(6506007)(6666004)(52116002)(186003)(26005)(478600001)(107886003)(6512007)(316002)(54906003)(6916009)(8936002)(36756003)(66946007)(66476007)(66556008)(2906002)(83380400001)(2616005)(956004)(86362001)(6486002)(8676002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fH3nMYK5rTSgXyanU5pXYb8eFkb4F97qoPlioTnlUxzt9ENYjurwq8F899xPNjWbSwYOzegWB38R97DMX+SD5Kin3c7SQLMsdr0AV1CdPlFfikA2gEHkA/1Ws7AUri54Jc2OEhzVj63pNbrtzNJ2p3R9bPtxm9Vad1JFWMQKTQ1Fyi2H/oU9mgqYlvHl1YqjlmXXcaWAuB9VXqOEnNTt/fRMvJAUIjA3oNgxYeZRrPGEWT3oRswRASK4eKaTGwT//k1jKDHDVepMZucvjHxKxCvQuGeGtv8+tmsxeUHWPa3g2FCk2f66BrnKRD2NHukKj/E5FeNCz5wJ7uqV3vm+5JifkVqo71WIrxvNJGocJaxSxqMXiBHGjTys71rkrogG6m9ZtUFgUCxZvkp2ShU5ShsfqD7++HPBYD92XKiA7SmJxNw7VP8ErRhKu/8v1UhkcRe4EOEgy60wgXCs9yYF/xhld/OW1HkyIgSJiSrSch/XcvPDNXE0Hh/iEZ/s0rKWHzh3LH5F1eyL34dHyee2genxZypefhSslddWEtnbbN0MtGsVkUbZI4Os67wxZJGDm2zUHj3P+/R0K+As2OGNLmyEoJ1+3Tqpm0vSoFEZ/AjfVYKqWpjSrEbkEuYLt23FUF9At7eaMEbBEuI/TFe76g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7294df7e-a344-4555-e0e6-08d834f53240
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 01:58:18.9426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WRt2GiWSKI3pcoS6w1LfGAkC2l9dQjE8c6pCgR43uJ81VXrH/lNJb1AMV2e2b6Ni2QwCez45a5KXHRSEwh5Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

The modified flow_context fields in FTE must be indicated in
modify_enable bitmask. Previously, the misc bit in modify_enable is
always set as source vport must be set for each rule. So, when parsing
vxlan/gre/geneve/qinq rules, this bit is not set because those are all
from the same misc fileds that source vport fields are located at, and
we don't need to set the indicator twice.

After adding per vport tables for mirroring, misc bit is not set, then
firmware syndrome happens. To fix it, set the bit wherever misc fileds
are changed. This also makes it unnecessary to check misc fields and set
the misc bit accordingly in metadata matching, so here remove it.

Besides, flow_source must be specified for uplink because firmware
will check it and some actions are only allowed for packets received
from uplink.

Fixes: 96e326878fa5 ("net/mlx5e: Eswitch, Use per vport tables for mirroring")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Chris Mi <chrism@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 6 +++---
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 951ea26d96bc3..e472ed0eacfbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -301,6 +301,8 @@ static int mlx5e_tc_tun_parse_geneve_params(struct mlx5e_priv *priv,
 		MLX5_SET(fte_match_set_misc, misc_v, geneve_protocol_type, ETH_P_TEB);
 	}
 
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
index 58b13192df239..2805416c32a3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
@@ -80,6 +80,8 @@ static int mlx5e_tc_tun_parse_gretap(struct mlx5e_priv *priv,
 			 gre_key.key, be32_to_cpu(enc_keyid.key->keyid));
 	}
 
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 37b176801bccb..038a0f1cecec6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -136,6 +136,8 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni,
 		 be32_to_cpu(enc_keyid.key->keyid));
 
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cc8412151ca09..fcedb5bdca9e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2356,6 +2356,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				 match.key->vlan_priority);
 
 			*match_level = MLX5_MATCH_L2;
+			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 060354bb211ad..d70d6c099582c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -259,9 +259,6 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 			 mlx5_eswitch_get_vport_metadata_mask());
 
 		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
-		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
-		if (memchr_inv(misc, 0, MLX5_ST_SZ_BYTES(fte_match_set_misc)))
-			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 	} else {
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
 		MLX5_SET(fte_match_set_misc, misc, source_port, attr->in_rep->vport);
@@ -380,6 +377,9 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		flow_act.modify_hdr = attr->modify_hdr;
 
 	if (split) {
+		if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
+		    attr->in_rep->vport == MLX5_VPORT_UPLINK)
+			spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 		fdb = esw_vport_tbl_get(esw, attr);
 	} else {
 		if (attr->chain || attr->prio)
-- 
2.26.2

