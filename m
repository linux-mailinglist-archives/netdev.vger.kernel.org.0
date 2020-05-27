Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBDD1E3506
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgE0Bul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:41 -0400
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:57088
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728015AbgE0Bug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJYbk90c7OnOiVjvPAjiBih9zelAgslVYTzwdiwn+lokF1r+7k0uO3uqb5qLqkKNAlNrN65H+odOXFCJ8zbRg5t8JXk3bS9C8hhUupRtI0qpiIj4em2eo4FFjHp/2gkPNHBmk77jRAAGZE9IX18z1WTdHol0p+y4cTLDxPOpQl5nYsArNSlHjcJLqeDKkflUkM+oHqBpKbTqfmUGa+12Dxn5HOuWkm+t6oqVkvLPEvSFtKkMLlQ1dq/sE1LX77z2jZcjF9WO5Azrgy1oqvjd6KdUkpFW8/C5slPFAQRLpiifPkqvMXFl3cp9DFjJntjHuJ1zhiNsvjlIC+RTfSNhQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgE9v518UEKhekvXO1pAUYvHtsavZoqYPZKPBhKiwJE=;
 b=nBiDWQFDyHgrSnKSH8sw0iVR7AeoixPzPH1BeFrS2vgYjxW5Ayp2s+XTtVOs0X1Ud4qBXsmeSut+1gDHp/oZIYzhxcv0hRYSA8Tx5ibgIQnFFCzCk8CnFU9hNCvz0+4n4fHymGNnb77CymJAB9cGouRrqs6aOoes2EUmpREFPn6e5nNU+SkEVw+55dYwiL1mfUsGDADITRHFZ2mSQyPrTXrq0a8X/DQ0rGECaxqq6p13h7hT8DZKwv32I5h5ohBtwcdS1heNO8B4ARmiQIpTCE9pa+rzde+8BvOxiP/zUiicv+HbvIVWnqCS/RmLBgMJ5KoKdG6Nqef5e6GapHKMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgE9v518UEKhekvXO1pAUYvHtsavZoqYPZKPBhKiwJE=;
 b=ddwxxtXBfbeg24bLVvPO36kOUsY34FusDAJVMGXqpOOtHc7bIsvPkWIxuKizOWUYWM/68nsnQstkBZGYEHFHdnsKZUWN7W9x3Dbve9BmIHqC9yGbZh/m6V+R3/sP/lvbAfuu/sTlofU/3zk5nu8ljK3L5EAPOYgTrNNwmnb0tg4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4704.eurprd05.prod.outlook.com (2603:10a6:802:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 01:50:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/16] net/mlx5e: Optimize performance for IPv4/IPv6 ethertype
Date:   Tue, 26 May 2020 18:49:22 -0700
Message-Id: <20200527014924.278327-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:23 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e474a588-9bc7-4080-63d5-08d801e052e8
X-MS-TrafficTypeDiagnostic: VI1PR05MB4704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4704420F528652F5D730F43FBEB10@VI1PR05MB4704.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wVyIu1zgIlAiNxwhLA2w9S6VlXfC06kXosRMfbBUVEhmo5Q0BVTGuucml24/KhfTuVHMEEmKN/0iIPXryx6pPuoMgQKFBm7iy7UXybdZCyWdW3MJNoQrgSWZosL8vSrx62/WNGhIJaS6dKG7tScfiQjmgL/wXc64GSbg+J3nGOxFNsddK2TlYw2HdsjFGXDal9I9QOJ2BPdEm2vA5fbfHSjVBPMpKl9lpg5BEwUQy+BprZhGuC2o1rZ52MhqL13TJ4SmHyZLgkJ77SeQkqoe6ttAJ4uGz8Xv1nfoc9dzYGWo6SWZ59QIy0Ecpl6yB4IGvhyxhlSX9ZfVLwwpP3Uj4+EYmL59Qr6jYD93AD1ORrOG07k2bJmc4RlPuNumx8dc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(8936002)(30864003)(86362001)(5660300002)(83380400001)(6486002)(8676002)(6512007)(6506007)(26005)(66476007)(66946007)(956004)(1076003)(2906002)(66556008)(2616005)(186003)(316002)(107886003)(54906003)(4326008)(16526019)(52116002)(478600001)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2LcvJCEgZNLrnLNRoawWJo1pQbQxn7zXZNMICqosg2fibzDqTnurn1r+LX1myRddhAeU8kDWbq3ojOM0lkkOm+MutKRFaR741Trnng1BHRVQ2Xm3yQTcFILOfybMqkKWU8jwIgkAO5X81IAug1c9own7Er/8+CDVqv5l3POezSlSo4HihDyY2EWNPC7QDdBMr3qylW9MxnD4SiYC04j8if49hFPLImf2THKgLe4ROzGxhEGKdqeRcKnSKqHkD7/XajXjtyrM+HbujOQ4DPm1MF455Jkxftp7iy/Z6u8q/gaoiobNP6SMH5Qnvfp1WVabTOH+wty7o/31S61XaNaR21J3/LjtqmwXm63Y94RgWM75bqM95i8IRs072SHF6xWyapUThe4wdw/POYLGGZDQUlQcf0VBRXm9ayYLr6baA2UIZrIEWZ/XUn5Q5l0Zl0OuqkevF7m5ZcLj/vvNtlWdp8NFs4PqWrMLVcZeZyx0ur0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e474a588-9bc7-4080-63d5-08d801e052e8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:25.2716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAQ/PSCq0xGlvD5af8y1YOapRn9MAqlyEEyu80s2uUgoolVjk8z+YWplikHCGb0f1CAA775C5DdDJwUn7CeBWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4704
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

