Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A469792B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbjBOJlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjBOJlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:41:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD0F24C8E;
        Wed, 15 Feb 2023 01:41:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnFgOONpu7Kf6oDv/tvU8Lz0wjd8OlIkR/uU3M7GWf0wKRIcAjUIjGdXI4cH48il1DAmfXajzne7Tjtn0GL6SnsplejfKNLtkeWvjk7uJuT/njKBCuEuKVwG1AKFZYxyHuiH81iPEFo2cTeQVhv1IyHmTfktWToFHtwQ75bBSstUf9u9rQPOjH/OP6SFIYbLKlidfxXHg0JXYLiM1QjDrzYX3ID924VjQcPWSmaxE2hTeINxNyUg/wrrEvk7EHLIjcGbryX6GvTy8rMISEhuUfhxZ3c1QxPPxbpTX6vUI34jYTKB5SyJrSLCxY/jFMikUB9KTPHZHvQ+YbJkR6o2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymu261mhpVJFhq0BrBDC/tGyuis+W4MXM+B9jDeJk68=;
 b=dEpzSImUpdRN0niYBVzQQE5kkQK1MZLabUB2A16T3DldEmMEYaq5QA924a/h+hpHOBL25HPkLXgKW0Nk5H8HdkAiWVUxm6nFBTFO3eqC7wdZF03HRYNqTBVjh9JypJtNASLLFmRyE1NzxRdkEfXIWVZnHF6XRleBGIvbsURfpb+eihFPNgGqy1MGItaVcw/hdjd2ucYyB75eGddIL8NWrmVz5hco14jRAvNciqnntzGbtyyrt6J005nGM9NBixrIWwmqDqnpfqot+g6q768TFT5EgelbUKlkpGvXKnpTpWZw30nIbEFjV17AII6M1Jw9Kuenk9vfFHLmuKU6OayEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymu261mhpVJFhq0BrBDC/tGyuis+W4MXM+B9jDeJk68=;
 b=h6mMX2kF1yK+ZRa+5tVnUVoTNYj7YTHY9W8aelKwiiFggFNcn0p6EPKosaSkB42UJ5+m6/FrU/tpmEppnmyrNl9ahClvlQsjl5vYn6dI/54jzfuKaQ9b0lqZ9CKkRaM16xo92JlPtGLeLbbMctCowJNNLlTyJos83iozNArf4FVfpC7pbGQR1KBeqZSc+ShNcSM7sqhykgBx/s+cmIhyTVs7e4pl14C4XRfaF4BlKtFxbxdCkwObZc2lTGy1GFUU91FLNDX8YoehSmft6bYGA4Gk34WZRXyTt72PDBA0Wcx+u62loTwPM/3iv9K89GW+Oik8EcVhTZRo3zCOqX37fQ==
Received: from BN8PR07CA0013.namprd07.prod.outlook.com (2603:10b6:408:ac::26)
 by BY5PR12MB4920.namprd12.prod.outlook.com (2603:10b6:a03:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 09:41:38 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::70) by BN8PR07CA0013.outlook.office365.com
 (2603:10b6:408:ac::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:41:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 09:41:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 01:41:28 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 01:41:24 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Gavi Teitz <gavi@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 2/3] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Wed, 15 Feb 2023 11:41:01 +0200
Message-ID: <20230215094102.36844-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215094102.36844-1-gavinl@nvidia.com>
References: <20230215094102.36844-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT040:EE_|BY5PR12MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f61550-c51b-416e-d767-08db0f38d564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gX/By91EjirP1VIvzzHqSlfwZ+DMWBD91PaLaZRBqaOGqRBFNEwTSWo4uAEJr7Vi3u1q5p5G5dC1U+0H7Neq+FyfwNPloR0GeKKh6djA3pHYEamdiZEkVgPLgyUe3BgaXFYOmh+oNTPlRy9cSgKbXoAaRTndfA7DxrF2wrj08jA0CAIHk/rWCtWCZHE+qvPYQ0bZsbSRApd0BEzGjm2tMBq1Qqab/UJDwHI14yaopRnmGwXRaDMa4J4jho9KDi3NXmIoczBsCva7BZJf307gJgEquO2bSwLIEWK3ySQ0oLba92D/jUTGV0uIY508Fuq22JM6VyDr/HSIzWAZEoDCuc5VOnZKoJMUnadxM/8hwIKXDIoWFUR8bJBgr5GDA5ouob6PMNLXO644lkzAkfUwgstKOARi1ELTLvnRcjPLjYK22cHOHpCdUzeHPrLQXM4mMim02zPTUs+lSaJO3qnO4ItDIUxRrRgLYLaCWKgFhfWKEBDBmczK4MDugtYT5r1hYenMqbAn9TLg7nQXP2aTMahrU9ibf8q9K/6rASGumdg/h0g6NqgaK6ghbJu7oSHWwhVNorvqI6nylyBN7IzhuMBIaC3ZOHIIxRMRw4+2VbwiIjdgO9ER0bm0mrGZj1+vE/EAi/W0TCGUq1UjDZN0yQelj4G0cktk6ahAbX8pKpUQNURv4SiS1XL0nfgpVrjdF/mJ6gTJ1bidwcJsnrTlIQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(40470700004)(46966006)(36840700001)(6286002)(356005)(5660300002)(2616005)(36756003)(107886003)(478600001)(86362001)(1076003)(316002)(40460700003)(70206006)(55016003)(70586007)(54906003)(110136005)(7696005)(4326008)(40480700001)(8676002)(26005)(8936002)(16526019)(186003)(41300700001)(6666004)(2906002)(82740400003)(7636003)(36860700001)(336012)(83380400001)(426003)(82310400005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:41:37.3767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f61550-c51b-416e-d767-08db0f38d564
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4920
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For tunnels with options, eg, geneve and vxlan with gbp, they share the
same way to compare the headers and options. Extract the code as a common
function for them

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 ++
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 +++++++++++++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-------------
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index b38f693bbb52..92065568bb19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -115,6 +115,9 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 					   struct mlx5e_encap_key *b);
 
+bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
+					   struct mlx5e_encap_key *b,
+					   __be16 tun_flags);
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif //__MLX5_EN_TC_TUNNEL_H__
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 780224fd67a1..f1d132f16fcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -3,6 +3,7 @@
 
 #include <net/fib_notifier.h>
 #include <net/nexthop.h>
+#include <net/ip_tunnels.h>
 #include "tc_tun_encap.h"
 #include "en_tc.h"
 #include "tc_tun.h"
@@ -571,6 +572,37 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 		a->tc_tunnel->tunnel_type == b->tc_tunnel->tunnel_type;
 }
 
+bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
+					   struct mlx5e_encap_key *b,
+					   __be16 tun_flags)
+{
+	struct ip_tunnel_info *a_info;
+	struct ip_tunnel_info *b_info;
+	bool a_has_opts, b_has_opts;
+
+	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
+		return false;
+
+	a_has_opts = !!(a->ip_tun_key->tun_flags & tun_flags);
+	b_has_opts = !!(b->ip_tun_key->tun_flags & tun_flags);
+
+	/* keys are equal when both don't have any options attached */
+	if (!a_has_opts && !b_has_opts)
+		return true;
+
+	if (a_has_opts != b_has_opts)
+		return false;
+
+	/* options stored in memory next to ip_tunnel_info struct */
+	a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
+	b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
+
+	return a_info->options_len == b_info->options_len &&
+		!memcmp(ip_tunnel_info_opts(a_info),
+			ip_tunnel_info_opts(b_info),
+			a_info->options_len);
+}
+
 static int cmp_decap_info(struct mlx5e_decap_key *a,
 			  struct mlx5e_decap_key *b)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 054d80c4e65c..2bcd10b6d653 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -337,29 +337,7 @@ static int mlx5e_tc_tun_parse_geneve(struct mlx5e_priv *priv,
 static bool mlx5e_tc_tun_encap_info_equal_geneve(struct mlx5e_encap_key *a,
 						 struct mlx5e_encap_key *b)
 {
-	struct ip_tunnel_info *a_info;
-	struct ip_tunnel_info *b_info;
-	bool a_has_opts, b_has_opts;
-
-	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
-		return false;
-
-	a_has_opts = !!(a->ip_tun_key->tun_flags & TUNNEL_GENEVE_OPT);
-	b_has_opts = !!(b->ip_tun_key->tun_flags & TUNNEL_GENEVE_OPT);
-
-	/* keys are equal when both don't have any options attached */
-	if (!a_has_opts && !b_has_opts)
-		return true;
-
-	if (a_has_opts != b_has_opts)
-		return false;
-
-	/* geneve options stored in memory next to ip_tunnel_info struct */
-	a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
-	b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
-
-	return a_info->options_len == b_info->options_len &&
-		memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
+	return mlx5e_tc_tun_encap_info_equal_options(a, b, TUNNEL_GENEVE_OPT);
 }
 
 struct mlx5e_tc_tunnel geneve_tunnel = {
-- 
2.31.1

