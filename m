Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8C1E52D1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgE1BTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:19:00 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:32229
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726519AbgE1BTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:19:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2sd+3vte/k1dnW9kzC1MRP/vsXNMkgcIFCYTa26FTMhAq7dajE6AhkpqvKPPnlWUQzYpsopz/BSxKgSf5GGFVYSVt+vylFP2VNUyM0aq8iPKLyM1VhZKjE6wdGXqxDSY/gjMgXORThTUu/QwA1KpYxZyF49pLBuBwS9Q9CLe7E5zWHzLP3q4yDnnMSchAT8YeD22TmquqHvEhUymLin/lShP7rXUuVEvEiHwJbo4e69UtarkOO4460b9Nm9d8Z1qXdTF35I1m0t+xF2snF1LvK46K7o/yyo+7NvF+kiXjOGbrsgrtSX1P9DujvWFjfnc3/kwqnfsoj+1Yn1WTviUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzeOtiCizllkbssRo1ZnMPKQ3+lB8ArU6snimmf1hpc=;
 b=dVd+HCqKE817FW3h5gI4F1T0rvq89NFmQNNZLsY+duPU6zfaQ4uH3ziMFZxf+SUPhWiszp1eEjU2vYnlrsjMKtZSMj5Upeg06IPiFOS4d3Vj/bbxP0PJHrbF6yTk5Q9yHTS5pOmZ7naq4UlOrLu01mJpq0vPh4KFTU0s+gkjjE/Utvq0uAG5SIg8bLu0hSbYBM53vbKWvzfWzM+uwkO1/Ptvc0IkE4q9ckE4f8ekjF9IxLlrQceK6cnpyBvXwj0IToWTPv1gT6A+0pA49TWpkt9KUV/JS/+hvEyGjCYELw75M8KFHGzHR5JazDKsHpnXj4QM+ayx4eYJNozU7By0vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzeOtiCizllkbssRo1ZnMPKQ3+lB8ArU6snimmf1hpc=;
 b=ZIfaDbBk3XYTKnI/cAVVI6qZ3zgvIaZnbOi2+J9K+LjHDlU7NHBsoLFG6SyTyk5DS93k5GVfeOX7Refh9DaoU4XnXwvC70sp1pnGGP3ZxcgcRPcsG5QuqVPOSRHwJDNFAs3wssy0ESHrvrh70gAyjAxIh84neMVB+BnlEDwvpbs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 13/15] net/mlx5e: Optimize performance for IPv4/IPv6 ethertype
Date:   Wed, 27 May 2020 18:16:54 -0700
Message-Id: <20200528011656.559914-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:53 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4568eac2-ad9c-420c-c38f-08d802a4f33f
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB436830862BDF4F325F9C2C7CBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbXRNyC2fhUD1duYk5Lsu2vHxw/wySlT4S6BfyevJgIaSiQt0UqatOBpZzCN5ddoAR/styr7Aq/XtUZcPsS03+K2CCIKLeikaSgunfpPVx8wpQ5vnFim6Vg7kz5VL1289s5+nJZSAs0kFsItQrdJySApXz8KY6ujURHlKWKY8ttQRHSZ6JkJN861jvTfNjZAVPxCkuAjLBIYMTaOfktYhfW51sQbmK15Mj77supQCTvBih6d3h5ZkCsOxOT5VgCD+mfrgw81bcmhni+aq3KyqPZ1Gbhy8cLf0HctCeG+uQjtSVBepj8Y6+GnxwzzHKngWbsEwnB7ThV3EowBmpnOHvCQeX+3/A/RIhg6EyMDYvF7jACJk4XuayCqPwUb3BN8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(30864003)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NrPhSke4wDyyMnPpnj1uM3lapeIlmMhhPQFhGbAviWqKUg0eyd87mnlyEo5umLM/6HJS0pYMAuVTiU+qWzGkJOkAKY1RhJyuspgIulMQ2tUufY3Xaskn8AA8WYismhvo/sYInU2AlT7mY5XShfBxJYlPPP48z6UtDG8LlPbJpQUPE76WzNwTCwrL3cRGGZ51u+p/CPmQAEY7yL+XDgcyGallvUhWGYlMq63p9DkI/LAlVnrn0xfHPyydz0FimhEjFrbircohj9QpHR9IPRbJVs5JtnAOWJsDOs7BA73zJMjXh8HsoYZ4dfNImp7Cs2gLiSHHnZsng9lHv2lyQupjjFGn/jhwNIgy3yx84Zd4SpbPeIqQ4ds3RlFEuYGTLVspQyIwsCXRV+/FvFOAKdKCOFS/bePPy0SzRuzMVf7Q22hAfn98QbtdYaLgsbcalxDw/JauwVrnawNJh/oCvDiE8kGJd9VyX4uwLn09wlZNzJQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4568eac2-ad9c-420c-c38f-08d802a4f33f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:55.3898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbhSO08kYEv/Vcs1R99iQ4n5RWHsl2p9XASuhj3MLDeDbUqGZADfc+Em3x4VMQSdrI5XdWRZyrBFZip8QZxbuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
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
index 6d7fded75264..7cce85faa16f 100644
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
index 680b9e090057..0f119c08b835 100644
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
+	if (ip_version_cap && match->mask->n_proto == htons(0xFFFF) &&
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

