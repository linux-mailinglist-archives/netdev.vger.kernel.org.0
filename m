Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EEE1E49FC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391042AbgE0Q0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:26:08 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:63749
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390905AbgE0Q0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:26:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvDSD6j1dxnxsck08vn5XkUVNBQLs06lAI8T865UiLXZYsgNlmYTNiRdLVSgJW4U0Rk9lWxhPeo456CQRtQ47X6/oiJVYw1kV+KuD7tDrbDjkA70RQIjOBZheVB9Z4XCPZ2bD6YhDw8QEJLheQ06NUnd1Kft+xSIl3KJTm7OX1A4NYRUgBzvVKOkwIlHGzJHpwY/M/gaya5IOkKcjs5ri5M++yPIggFhJ9rmBmW6u1dFAV/9R0AH3um88ZoyOcIFr7uL0Pmf18OK9KLqeJJkwcaBb+c04yuMUD8BJOL/L5t2t2LK8ux/eEbAN1kiCY0KXXNdsYtoFVKktiWIZv33OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgE9v518UEKhekvXO1pAUYvHtsavZoqYPZKPBhKiwJE=;
 b=RCg5nmh/9pNfG28TOadxGrQ8Eqk8eiwozf5HvtYSsDOgco74r8jlCjTmRa3qrd/1vTpSeRL8GDjB/7+5wvsdokFV/jw9eNWcBHUsUC6InCv9RgA6nUWviBLFXRCI4mSFfxq78dYN8fUehghkWhZ1IkJP9hKbEmycroRUJoWH2YzMseFMZF7jxgViRFUMgjVr5z8nOjJ0hmlslutFANxkk63JweT/1Hvn4jQ2Z2I79R2yOwaJqKIQkSd9aPieaHAmI4Va3Rb4fRmuScP7+4m2HGn/LPq2+MEOoGn/uZLZhm/w4oKUYsD++kpE+xij5K1D4c4RHY3iYHYJ1rQLMo6JHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgE9v518UEKhekvXO1pAUYvHtsavZoqYPZKPBhKiwJE=;
 b=qU5Lf87i6uhTvFx8g5bJmvhxx/a9hC7fRfo7GEvyEj0Exo9Re2M1IX2lqZaz65jaNB/NsrlrJrz9PUYvVtUDla9ljFQNUB24sw3x/pSUOVxcVMXUzHLQ8fXmUYNwakf7CXfGKFO4AyUXsQ2Qy/LMjBbisn1m+j0WfLOOUqTnbB0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:22:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 13/15] net/mlx5e: Optimize performance for IPv4/IPv6 ethertype
Date:   Wed, 27 May 2020 09:21:37 -0700
Message-Id: <20200527162139.333643-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:24 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ff6521e-583c-4798-ccf2-08d8025a2504
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB703945781B978866A21368B3BEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3TU/BT3M4yKnPKYM9rRr5EO3tZC1A0zWORUVhc/ZCBnAgYNFg+DBP6m6VtCaLIX51qFn/mt1Q9lC+c9CPFk2UxsdPNcxCwV5aa7r6pyRCCYWyjo6R7WH3+euC71CaLwPYUcwJXuuHE2RSNjiFxZ/KTrsVoSRR65zU36a2/uiO5k1IuVwbRRdG2blMhdb+Kheuy1DEVSOH5mPQ/Y/xgj/IZEfcFCrpmrdIzHH6/vOOsoZP7+eBF0lJ1YrdAmyiAzR5NtYDqdddtnAqcj5MAe2mzZSGWDlsdloOxH2lWyii8svLO4k8Kt/NWJ2NygIi2BKWM5xAMJVsx+qKJqHaI6knzPO46u8RxeTCtG01aPqenY42cjueiK5U/373I1MsggT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(54906003)(478600001)(107886003)(6512007)(86362001)(83380400001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(30864003)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PuqU0vo8HF5fK8V2ESXtE3WYJvOXa3G3xMpVDyiC6g5stINTnAyBmnKn8QYV5PBGn18exjA7l2GM3SV5sjnfaWknH7sGbstVWYil44sy7LDS2rifb/FzNxF7M9Zdcp9P12ex5CCsPDj48VGbYjFUZQMw3Jw2jn1CtgbgVqtftA/ZJ/tCy9UW4NVK1IHGBqd9rxVG8O9YTeOyx+PyNLyuYiXnn+6nALsxGl0vIQ3jPTD+RHfPyMrZ+wsrOyDjId+TrpMEs83xfqtCae2KgtGAI/O7E8luyNIBGFuMBjUizDlFNpQJp0ODu6NSElWbCugCb3rBceOcOPToFPgIKUmH/gqWUVmGeaCgJX2+38Llz+jtBdI0GjQvIXPue6//Eu6vLTM9VM3ohUYUW1beSvcBgcX7Aew8JwEQCQUR3gtTn3n7divxEbrrZ2GFI2PqmjdH4zjhZxlHYFOWvrFhaDt72iHYqEoDNiJvGkvAKiHmKaI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff6521e-583c-4798-ccf2-08d8025a2504
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:26.6967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niepD2j+xKK3XcgFWwiKO5emui2QaavM0WDcXT8R5ANUR9G6ZbUOT3L5CtQHEfezj9q+Ui7Xybt78LJWTl4mBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

The HW is optimized for IPv4/IPv6. For such cases, pending capability,
avoid matching on ethertype, and use ip_version field instead.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/diag/fs_tracepoint.c   | 85 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  7 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  8 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 40 +++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  5 +-
 5 files changed, 85 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index 8ecac81a385d..a700f3c86899 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -76,58 +76,59 @@ static void print_lyr_2_4_hdrs(struct trace_seq *p,
 		.v = MLX5_GET(fte_match_set_lyr_2_4, value, dmac_47_16) << 16 |
 		     MLX5_GET(fte_match_set_lyr_2_4, value, dmac_15_0)};
 	MASK_VAL_L2(u16, ethertype, ethertype);
+	MASK_VAL_L2(u8, ip_version, ip_version);
 
 	PRINT_MASKED_VALP(smac, u8 *, p, "%pM");
 	PRINT_MASKED_VALP(dmac, u8 *, p, "%pM");
 	PRINT_MASKED_VAL(ethertype, p, "%04x");
 
-	if (ethertype.m == 0xffff) {
-		if (ethertype.v == ETH_P_IP) {
+	if ((ethertype.m == 0xffff && ethertype.v == ETH_P_IP) ||
+	    (ip_version.m == 0xf && ip_version.v == 4)) {
 #define MASK_VAL_L2_BE(type, name, fld) \
 	MASK_VAL_BE(type, fte_match_set_lyr_2_4, name, mask, value, fld)
-			MASK_VAL_L2_BE(u32, src_ipv4,
-				       src_ipv4_src_ipv6.ipv4_layout.ipv4);
-			MASK_VAL_L2_BE(u32, dst_ipv4,
-				       dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+		MASK_VAL_L2_BE(u32, src_ipv4,
+			       src_ipv4_src_ipv6.ipv4_layout.ipv4);
+		MASK_VAL_L2_BE(u32, dst_ipv4,
+			       dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
 
-			PRINT_MASKED_VALP(src_ipv4, typeof(&src_ipv4.v), p,
-					  "%pI4");
-			PRINT_MASKED_VALP(dst_ipv4, typeof(&dst_ipv4.v), p,
-					  "%pI4");
-		} else if (ethertype.v == ETH_P_IPV6) {
-			static const struct in6_addr full_ones = {
-				.in6_u.u6_addr32 = {__constant_htonl(0xffffffff),
-						    __constant_htonl(0xffffffff),
-						    __constant_htonl(0xffffffff),
-						    __constant_htonl(0xffffffff)},
-			};
-			DECLARE_MASK_VAL(struct in6_addr, src_ipv6);
-			DECLARE_MASK_VAL(struct in6_addr, dst_ipv6);
+		PRINT_MASKED_VALP(src_ipv4, typeof(&src_ipv4.v), p,
+				  "%pI4");
+		PRINT_MASKED_VALP(dst_ipv4, typeof(&dst_ipv4.v), p,
+				  "%pI4");
+	} else if ((ethertype.m == 0xffff && ethertype.v == ETH_P_IPV6) ||
+		   (ip_version.m == 0xf && ip_version.v == 6)) {
+		static const struct in6_addr full_ones = {
+			.in6_u.u6_addr32 = {__constant_htonl(0xffffffff),
+					    __constant_htonl(0xffffffff),
+					    __constant_htonl(0xffffffff),
+					    __constant_htonl(0xffffffff)},
+		};
+		DECLARE_MASK_VAL(struct in6_addr, src_ipv6);
+		DECLARE_MASK_VAL(struct in6_addr, dst_ipv6);
 
-			memcpy(src_ipv6.m.in6_u.u6_addr8,
-			       MLX5_ADDR_OF(fte_match_set_lyr_2_4, mask,
-					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-			       sizeof(src_ipv6.m));
-			memcpy(dst_ipv6.m.in6_u.u6_addr8,
-			       MLX5_ADDR_OF(fte_match_set_lyr_2_4, mask,
-					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-			       sizeof(dst_ipv6.m));
-			memcpy(src_ipv6.v.in6_u.u6_addr8,
-			       MLX5_ADDR_OF(fte_match_set_lyr_2_4, value,
-					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-			       sizeof(src_ipv6.v));
-			memcpy(dst_ipv6.v.in6_u.u6_addr8,
-			       MLX5_ADDR_OF(fte_match_set_lyr_2_4, value,
-					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-			       sizeof(dst_ipv6.v));
+		memcpy(src_ipv6.m.in6_u.u6_addr8,
+		       MLX5_ADDR_OF(fte_match_set_lyr_2_4, mask,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       sizeof(src_ipv6.m));
+		memcpy(dst_ipv6.m.in6_u.u6_addr8,
+		       MLX5_ADDR_OF(fte_match_set_lyr_2_4, mask,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       sizeof(dst_ipv6.m));
+		memcpy(src_ipv6.v.in6_u.u6_addr8,
+		       MLX5_ADDR_OF(fte_match_set_lyr_2_4, value,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       sizeof(src_ipv6.v));
+		memcpy(dst_ipv6.v.in6_u.u6_addr8,
+		       MLX5_ADDR_OF(fte_match_set_lyr_2_4, value,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       sizeof(dst_ipv6.v));
 
-			if (!memcmp(&src_ipv6.m, &full_ones, sizeof(full_ones)))
-				trace_seq_printf(p, "src_ipv6=%pI6 ",
-						 &src_ipv6.v);
-			if (!memcmp(&dst_ipv6.m, &full_ones, sizeof(full_ones)))
-				trace_seq_printf(p, "dst_ipv6=%pI6 ",
-						 &dst_ipv6.v);
-		}
+		if (!memcmp(&src_ipv6.m, &full_ones, sizeof(full_ones)))
+			trace_seq_printf(p, "src_ipv6=%pI6 ",
+					 &src_ipv6.v);
+		if (!memcmp(&dst_ipv6.m, &full_ones, sizeof(full_ones)))
+			trace_seq_printf(p, "dst_ipv6=%pI6 ",
+					 &dst_ipv6.v);
 	}
 
 #define PRINT_MASKED_VAL_L2(type, name, fld, p, format) {\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index ba72410c55fa..afc19dca1f5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -119,7 +119,7 @@ mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
 }
 
 static int
-mlx5_tc_ct_set_tuple_match(struct mlx5_flow_spec *spec,
+mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
 			   struct flow_rule *rule)
 {
 	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
@@ -134,7 +134,8 @@ mlx5_tc_ct_set_tuple_match(struct mlx5_flow_spec *spec,
 
 		flow_rule_match_basic(rule, &match);
 
-		mlx5e_tc_set_ethertype(headers_c, headers_v, &match);
+		mlx5e_tc_set_ethertype(priv->mdev, &match, true, headers_c,
+				       headers_v);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 match.mask->ip_proto);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
@@ -530,7 +531,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->counter = entry->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
 
-	mlx5_tc_ct_set_tuple_match(spec, flow_rule);
+	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
 				    entry->zone & MLX5_CT_ZONE_MASK,
 				    MLX5_CT_ZONE_MASK);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 105d3b2e1a87..91ca14bbab46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -545,8 +545,8 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 				 ntohl(match.key->dst));
 
 			key_basic.n_proto = htons(ETH_P_IP);
-			mlx5e_tc_set_ethertype(headers_c, headers_v,
-					       &match_basic);
+			mlx5e_tc_set_ethertype(priv->mdev, &match_basic, true,
+					       headers_c, headers_v);
 		} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
 			struct flow_match_ipv6_addrs match;
 
@@ -570,8 +570,8 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 								  ipv6));
 
 			key_basic.n_proto = htons(ETH_P_IPV6);
-			mlx5e_tc_set_ethertype(headers_c, headers_v,
-					       &match_basic);
+			mlx5e_tc_set_ethertype(priv->mdev, &match_basic, true,
+					       headers_c, headers_v);
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 680b9e090057..fdb7d2686c35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2020,13 +2020,30 @@ u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow)
 	return flow->tunnel_id;
 }
 
-void mlx5e_tc_set_ethertype(void *headers_c, void *headers_v,
-			    struct flow_match_basic *match)
-{
-	MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
-		 ntohs(match->mask->n_proto));
-	MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-		 ntohs(match->key->n_proto));
+void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
+			    struct flow_match_basic *match, bool outer,
+			    void *headers_c, void *headers_v)
+{
+	bool ip_version_cap;
+
+	ip_version_cap = outer ?
+		MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					  ft_field_support.outer_ip_version) :
+		MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					  ft_field_support.inner_ip_version);
+
+	if (ip_version_cap && match->mask->n_proto == 0xFFFF &&
+	    (match->key->n_proto == htons(ETH_P_IP) ||
+	     match->key->n_proto == htons(ETH_P_IPV6))) {
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ip_version);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_version,
+			 match->key->n_proto == htons(ETH_P_IP) ? 4 : 6);
+	} else {
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
+			 ntohs(match->mask->n_proto));
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+			 ntohs(match->key->n_proto));
+	}
 }
 
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
@@ -2250,7 +2267,9 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
-		mlx5e_tc_set_ethertype(headers_c, headers_v, &match);
+		mlx5e_tc_set_ethertype(priv->mdev, &match,
+				       match_level == outer_match_level,
+				       headers_c, headers_v);
 
 		if (match.mask->n_proto)
 			*match_level = MLX5_MATCH_L2;
@@ -3126,16 +3145,19 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 {
 	const struct flow_action_entry *act;
 	bool modify_ip_header;
+	void *headers_c;
 	void *headers_v;
 	u16 ethertype;
 	u8 ip_proto;
 	int i, err;
 
+	headers_c = get_match_headers_criteria(actions, spec);
 	headers_v = get_match_headers_value(actions, spec);
 	ethertype = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ethertype);
 
 	/* for non-IP we only re-write MACs, so we're okay */
-	if (ethertype != ETH_P_IP && ethertype != ETH_P_IPV6)
+	if (MLX5_GET(fte_match_set_lyr_2_4, headers_c, ip_version) == 0 &&
+	    ethertype != ETH_P_IP && ethertype != ETH_P_IPV6)
 		goto out_ok;
 
 	modify_ip_header = false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 144b71f571ea..5c330b0cae21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -170,8 +170,9 @@ void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 struct mlx5e_tc_flow;
 u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
 
-void mlx5e_tc_set_ethertype(void *headers_c, void *headers_v,
-			    struct flow_match_basic *match);
+void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
+			    struct flow_match_basic *match, bool outer,
+			    void *headers_c, void *headers_v);
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 
-- 
2.26.2

