Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077FA1DF353
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgEVXw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:57 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387437AbgEVXw4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLgGs7JHbv8XWtoArR4qd+bleE7DCZMrPk16qKLReFdHGsl6DE5D3QD7A/BCGhx0DC3eSEwvU1+XuIQpWjAliTycEtnDx6u812Q8NkDhraBFFdEoMX+df4DlCSqTxViLis9AM7T8p+bC+Bzfc+1oKLXNgS7u93yw56krW4uLNHzVuDDxnijwPlhK5owmm10qvQeTZam4P9fZxjpLe5iDU7hJQJop/ssr6/p2425oXJ5CnQNW4XEIEbM3qHD4dbpAFxRqxgiknVkr8SBtNdaK3jfSbCC5bIBFkQIgrj/cyS5A0j3uscD1bHqZTwhot4IxJK094N2a8BbkfHMmFUxD7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUQDrmpP/MaCjo0/suKyL/pKspCSSYwkodmx8r1E+dQ=;
 b=nDx+KTVsdDBJQapHlMewv0HW591DFmAjYPf7sMjW1rLaupAG7AqYFLiM1nZg2RhT4cqI8CgyHobIy/LIuEWk5lktu8zELwMBn9Ygc5qy+DxVZcMKEYAV20YFg9zZPXSl8rC6dwpF8pgjTq0Kp2MZeM1v1peimS7y8oTE7W8cPlYIr+SmSVScL0ahtXZbnpOmQY8n3eoO4P+QIuD1W2QZ6Ry/tVP/9HAAnmMAquM60MM5H5MMcS0AWLuhS2wLgvbYaZ0O1u4g5MMGTWfX3KWEH/x2RDUtrcCMy5U7doch3JIUCU5rRki4JZaXFUdXtSGkZVbNQnlIrDfr+OjVdIgELg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUQDrmpP/MaCjo0/suKyL/pKspCSSYwkodmx8r1E+dQ=;
 b=bKX9Ls/lGKJOL5lzDyhEfsc0aoWNUDN+jgO7NR7ldUPayc317xw3YE4w0uEicr3BDosW8t6a16Q7gfJ7/g1aaN0PjxA2sKlPxnY50zIyx3F6XuFBTzj06sJDMDA+eyefT4gnySGY2rHmpkIwII6BlHFH35cOaoTTBanQKI0bNtE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/10] net/mlx5e: Allow to match on mpls parameters
Date:   Fri, 22 May 2020 16:51:46 -0700
Message-Id: <20200522235148.28987-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:25 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa46aa2a-2172-45b7-ed74-08d7feab2ecd
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4544DA376EA91D3505F48CAFBEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14gZrWBlVAzDdVDtM0mrCd0+3y7NXf/aY1vvjPlMLupVIoMp1Q7FSk8BWmsHFNrUprOQT8L98sbOGmoSZfalV3sVXqVw4bR9ZNgtTYWT8KnoSNPZ/592TgsgZEdANEOevL2E9kYxSXXhkS/6J2D9IXK+fBkVnQsSCr9sW56mHammiXIGb7029RIkIxZ/Cvz6LgpT3dkfKN1zmUyVR2EKXWGwGikFWFWYKHTzD2CDX6mC/pxPGXXba9nHl4aHYSCRUferdG1Y72CRek2yDeUhYxZklroweWdcxC0hrcPTG/TFL1jmrzqBSbhmyKaRibzS9Xf0c66vqx/09wgKp+Cg66DB2JsmChWd0Av6+qTA7LO9+tQ4YGCty839s8UJyycD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FPotP2KOgpZSp21S1GJiZFDfDvdz3oMTR97Y6dyKg1U7LxVC88xd5qbaA96GIrIJd9HOAFPefPE9GJOLOM+Zcw/EqFNzi9juUPHFQBnzYWLOdOaZCBQ+A63DqjVZCZyrmYuRItOuK57S0jsplQAMS5o13oRI0NlwCDBuxSjWNd+x566WMAmUlpGU6Tb0TbiiwRV1di/IuPqoiAXKznm1MOzIvUVPTYGW7Wm2V7bH/serhmPt9DGt0Ne9CBaz4NIn3/yFIuAbf4mPVz65tyUvsudKvoLBYEeRW0zrfv02Ea7f2U3XqSw36HwqbRZRsFmd9WX0MrQ8njk2I/WNPSq8fIwaxsw/1pqUsJSoDxFZHCdmmwQ09zTPsXl2es/zwMCjmnQULpsVYBqBc5996Ncg5jnZysYiN9ggCdAxKHcpm3eNBWX/qn7rg91cqxBrTFHnnKf8TUHkOjjZGAuWWbVcWVCGjTteN4EgqcmJWxyN7Lk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa46aa2a-2172-45b7-ed74-08d7feab2ecd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:27.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ke4d4MK2qS6ptdw9+aKeRO6gid2XcrsEnHr+x86DxWO8/H7mzZnGY8RU4j7DKukjllxizbERx9AxbLtHHH5fkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Support matching on MPLS over UDP parameters using misc2 section of
match parameters.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c   | 49 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 +++++++-
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index ff296c0a32c4..98ee62e427d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -73,6 +73,55 @@ static int parse_tunnel(struct mlx5e_priv *priv,
 			void *headers_c,
 			void *headers_v)
 {
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_match_enc_keyid enc_keyid;
+	struct flow_match_mpls match;
+	void *misc2_c;
+	void *misc2_v;
+
+	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			       misc_parameters_2);
+	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			       misc_parameters_2);
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
+		return 0;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
+		return 0;
+
+	flow_rule_match_enc_keyid(rule, &enc_keyid);
+
+	if (!enc_keyid.mask->keyid)
+		return 0;
+
+	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
+	      MLX5_FLEX_PROTO_CW_MPLS_UDP))
+		return -EOPNOTSUPP;
+
+	flow_rule_match_mpls(rule, &match);
+
+	MLX5_SET(fte_match_set_misc2, misc2_c,
+		 outer_first_mpls_over_udp.mpls_label, match.mask->mpls_label);
+	MLX5_SET(fte_match_set_misc2, misc2_v,
+		 outer_first_mpls_over_udp.mpls_label, match.key->mpls_label);
+
+	MLX5_SET(fte_match_set_misc2, misc2_c,
+		 outer_first_mpls_over_udp.mpls_exp, match.mask->mpls_tc);
+	MLX5_SET(fte_match_set_misc2, misc2_v,
+		 outer_first_mpls_over_udp.mpls_exp, match.key->mpls_tc);
+
+	MLX5_SET(fte_match_set_misc2, misc2_c,
+		 outer_first_mpls_over_udp.mpls_s_bos, match.mask->mpls_bos);
+	MLX5_SET(fte_match_set_misc2, misc2_v,
+		 outer_first_mpls_over_udp.mpls_s_bos, match.key->mpls_bos);
+
+	MLX5_SET(fte_match_set_misc2, misc2_c,
+		 outer_first_mpls_over_udp.mpls_ttl, match.mask->mpls_ttl);
+	MLX5_SET(fte_match_set_misc2, misc2_v,
+		 outer_first_mpls_over_udp.mpls_ttl, match.key->mpls_ttl);
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2cebbd03bc57..801fcd1b5f85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2073,6 +2073,20 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 	return 0;
 }
 
+static bool skip_key_basic(struct net_device *filter_dev,
+			   struct flow_cls_offload *f)
+{
+	/* When doing mpls over udp decap, the user needs to provide
+	 * MPLS_UC as the protocol in order to be able to match on mpls
+	 * label fields.  However, the actual ethertype is IP so we want to
+	 * avoid matching on this, otherwise we'll fail the match.
+	 */
+	if (netif_is_bareudp(filter_dev) && f->common.chain_index == 0)
+		return true;
+
+	return false;
+}
+
 static int __parse_cls_flower(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec,
@@ -2117,7 +2131,8 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	      BIT(FLOW_DISSECTOR_KEY_IP)  |
 	      BIT(FLOW_DISSECTOR_KEY_CT) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
-	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS))) {
+	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
+	      BIT(FLOW_DISSECTOR_KEY_MPLS))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
 		netdev_warn(priv->netdev, "Unsupported key used: 0x%x\n",
 			    dissector->used_keys);
@@ -2147,7 +2162,8 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC) &&
+	    !skip_key_basic(filter_dev, f)) {
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
-- 
2.25.4

