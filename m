Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B755869ED25
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjBVC56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjBVC5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:57:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10hn2212.outbound.protection.outlook.com [52.100.157.212])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E44E61A6;
        Tue, 21 Feb 2023 18:57:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3o6SYg4SFGR2zpbnoVq2niV5jq7Uhc/fkUvUvtWmmJ/P1xzYp2q06DuVF3Q5POpylbLeDPEVGSQCs6J94eHLaLZUemAfFrsR5YjXyA0Q4fW3mvVxFTohBFpKfXhXl0gSEjBBESpMQQpdr718QChzgfVbhV7o/OrzfnNkUXOmmJny3CkIOju8/bKSww4mMNuteZg/xoYKjB2f8+JXI3RIhBRkNgpzIwfDN+JMupdmPs2g6x1eZ5nKsFhUm4q10D86t87xIenzvMchjiSfGA0Q9VBqnvbloVuNa0z2Wqz2OxQplvOQBr5apFZdLAZ/ynsyhl9zwQju7hRFPaZAPY8KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tu2ICu0s2wYjLnOfl6UtqdKNQ1fAFRawAQ+8tUbcWyU=;
 b=auxsZ+D6QSi/GRg2sab2u692avvI5munZCo1ZrzNmgddYjurmCuUBO+6XVnosKiJWRIpqN461LcmFYb57EUDjknvsZMjkvf+8gmbP3uL1BVSLBhMO9zEqMR6dj1pT0VafxXS0xYeErqeC6flUnM9bt3vc3Ihr80YgivBTEkmKBJP8Tc/TeCG0AnmlbNeJTmDlxCKuK9/4rjYTTe+lg3JyQymnbmAepwN4juVa++JepKHKV/D6kh3jciRvQ7jzCi0eWaKxLzKH2vPtGfUgGoeJzPV4aXNGwsIv5Gf8fG1u/w5OHBV6fAWkoZQn7NyjUwrHt+eHGUx8viyXwyt+KkU8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tu2ICu0s2wYjLnOfl6UtqdKNQ1fAFRawAQ+8tUbcWyU=;
 b=MuKMqiZ0j+oPU72MMkksimHpt6F9Z4+drsBPUOD85rjce36WqyVLL2D0vpWlgg9TgZ6LJ3/TCBETspCJ/0JTMLFa5wMaW0F4I5n8sLBayqLV1pyZ2k6dzY2JnPcKUHUFWtxBmu/YmUU4X3cFpQpvC45PJ4s/litvtSKxX/KaaDNqHPeQzbFi5zp9T9zwjTBM265DvR81/JzEGoqUz5Bp8t24kWGYbuhYKTUOF2+mOF20p3MB1ES6nRU5inC+n6j/QhFanVShYPnBWQ7mXltr8jADLJDm32SzS6nZuUpxUOaP1rZfwwDET6h2YHpGSaLXPi7W8eHgrI8WMObEhQZ1zg==
Received: from BN9PR03CA0970.namprd03.prod.outlook.com (2603:10b6:408:109::15)
 by IA0PR12MB8085.namprd12.prod.outlook.com (2603:10b6:208:400::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 02:57:52 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::4a) by BN9PR03CA0970.outlook.office365.com
 (2603:10b6:408:109::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21 via Frontend
 Transport; Wed, 22 Feb 2023 02:57:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.19 via Frontend Transport; Wed, 22 Feb 2023 02:57:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:34 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:30 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v4 3/4] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Wed, 22 Feb 2023 04:56:52 +0200
Message-ID: <20230222025653.20425-4-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230222025653.20425-1-gavinl@nvidia.com>
References: <20230222025653.20425-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT067:EE_|IA0PR12MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 68ff5748-23dc-4a5f-8e29-08db14809658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJcw8tPijGnITMlDnbrf/5X4draFYbEujuI6F7SmAUTI4p6zoYR8a0Vrd0NEOlrgSMx4uHHHD3O6xQIMxHmS4XrZEvD1Pyb31y9/M0xnXkqU6qUbH2PiFWI73eKlrubCiVJ4J8FvtNo8DEOq0ct49rhzbaE3NoEW6Gfy4z1+aAO3NVbGKm/i++VbhBUjndDTQOAEkoABtvBpP1X4YhCMTlbMGeY5DPIAVeReBReoUv55cTrCefelNcyFuVtzspaqyfWY92sZrwzTAj8CTDmFSYGI1ZTya3fDBkKPXD1s9wGXGfSSTJW8ADY3czpoOa4IiM70Kmqt8YLppB8aFGosotluKGFOTYMnpFPL91AKj0pQNp/LVEy0h8MpOIndyIUF8bEea4DCaTjpSHUKCIMCiUaOuMhvVmyl19JcroXbJUytwxlR8HB9B5xYjyOWqKZKLn6HsaRXVsDwNe2vmJwzbeJVjtio3a9EeiFGYnQYYz5ka38DW2DotgMmN44LpeAGgiEJBX1/9B+E0e5vj8YthZHfIUhgSi0xDtWDJJ8PuRmzdfjMozfxTyMlsmzITPNn85pxgcm9QRcOEIzW8dSXC97wrE7YZ1dI1LnZ1aWspCz3HJDUUukx/j938UZ8YwN1HeDoX6JJy7jVL6wYS1tDdRQwdAxjtzArw7I2/nqiRkbjdiTKXeQ6zGX/4AMcxguiTkV3ZDbx47F+yFhS2iUfxpdODontSOnivXFprjzwvCvsZpEaY27Kl8zQSiNdXs7nys3ejq2/8ahjyAATDo2TUQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(5400799012)(451199018)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(83380400001)(336012)(426003)(2616005)(47076005)(356005)(82740400003)(7636003)(82310400005)(34070700002)(55016003)(36860700001)(40480700001)(5660300002)(41300700001)(8936002)(2906002)(16526019)(6666004)(6286002)(26005)(186003)(1076003)(7696005)(86362001)(70206006)(316002)(478600001)(110136005)(54906003)(70586007)(4326008)(8676002)(107886003)(12100799015);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:57:51.1625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ff5748-23dc-4a5f-8e29-08db14809658
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8085
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For tunnels with options, eg, geneve and vxlan with gbp, they share the
same way to compare the headers and options. Extract the code as a common
function for them.

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
index 780224fd67a1..a01f386ae7ca 100644
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
+	       !memcmp(ip_tunnel_info_opts(a_info),
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

