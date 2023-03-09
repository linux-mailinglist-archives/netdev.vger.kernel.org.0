Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42CD6B25D3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjCINtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCINsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CDF7BA30;
        Thu,  9 Mar 2023 05:48:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMohm7F+Pxnc6M7aDi8cAjNfK/HdsFHzG4RyR7xMj0+YZAjgR6sCklxc1GuKNakh97u/DOO5eDxvbi5Z5t7T6A+NuY3PPcGdxWFpcXgCtNreB8aHYP/+fUz2DZSmdkvXWfXJvkTjDAf9Oyv8/tLKYIZ1JiELG9gcudJ4xHKjME/b5Lr8FwNE3c+PCPRobEcomm7tMRBKqUH69ZJoaXwhW/r70eqDlt00aeC1yW8lA5P4nC0rlAfxfNzn+6qFyE8msnhPWOFIbZWFN5yRbUAdRrmLLnDzbhDEurU0aDeYAwWnsFNPCZq2y20t6GWl/UoR3fkE5oWZonxMQVc72WWoDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N179DlG4Bn/W8g7JOeG9FuYbjDYjXPaJecv7CzHK2fc=;
 b=WUqqbGEhE2yZwjgoFDMsQdlZzgKlRiBaJPFLxHcNLXPJZnU3Xw2d1QwQhhVw/6GnQp8xPWsb8cWH7nMWgokOSUKKJPfiejs/6ZHV+qWGgdW0Dw5dvGh/pgSaVHHmfkGlEo3BjgxQbMsGvyQUiemIAsBaM29cuLIHrrWQr61UUWWDOcVBdkg1G9o4fCW5n3kIQNBn/pTt6NFc+dtGLjlJX0JtGvHsoWdS/RgmbWbnl5GMjKa4dtILRIJEPHnT15wQ8WEyet1bqaCDTC8dlM1gC/1iwbRtCV/ub78/+6VIGOJSce3z5EiJOI3eswutTrimcw0nSAaBOHrDCb2xUt2GZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N179DlG4Bn/W8g7JOeG9FuYbjDYjXPaJecv7CzHK2fc=;
 b=KBQS/NrDj00aVLL7uga/WdlB6jCKzZms9A7/hOy8mnYNP06oG0ZUyYxYyzG0HK/eciN6tLrQnx/MnG3YHhS/1elRW9cpy3P8pqlv445K9ikjFlhNG83SStga7ZTiN89SAjQr4TW69TLArq5SkZVeR36Y8a/iCrABmU2GdQIT4aHP9LOC6iRZfvUkvdvOBFtxEeLOSOGsSkySj0wivub4HxWLKlqo5ZxiQNh9TyG/VRNht3GA7jZdwHvbWxyxFRxuJAGtQ7toYSYiv94O8EC39+ht0gLN5HEGDVEQDRZasUP1YhXxlcyuqYk34+DFVEtexyoOYHzTkU/SFI2ERjUQBg==
Received: from BN9PR03CA0881.namprd03.prod.outlook.com (2603:10b6:408:13c::16)
 by DS0PR12MB7801.namprd12.prod.outlook.com (2603:10b6:8:140::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 13:48:24 +0000
Received: from BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::4a) by BN9PR03CA0881.outlook.office365.com
 (2603:10b6:408:13c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 13:48:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT096.mail.protection.outlook.com (10.13.177.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19 via Frontend Transport; Thu, 9 Mar 2023 13:48:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 05:48:10 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 05:48:06 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v6 3/5] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Thu, 9 Mar 2023 15:47:16 +0200
Message-ID: <20230309134718.306570-4-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309134718.306570-1-gavinl@nvidia.com>
References: <20230309134718.306570-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT096:EE_|DS0PR12MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: f73af92b-1e5d-4eac-7d4a-08db20a4f3ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/Pkt2OGO8ynED6YA7al9FLxOmRJ4jSCyXhtfuqb5qv7jAtsiC6kUyAMG/eVuctjQppgXWAzFfPoPTtAEzA64XhmnSBRwnzcnMJO1rvOiCLNDy69qNBVS/3PG4YQQW+U8Qc0MOJiKhSv0Z4gNpxrH18KqxEIJsxUDPBKl+/95GquAdmbX8mdnKfOrqpORJiDrGrJ5+tXwlEI1pGwVHmKaZtu7SXY2QX3vdtRtTY7yANw7isK9O8y1zAvAbsfpm8b+K8OhTCWWqqqb5liaqvKEKKVgFd8YdfdS9Zz78+JkULShlLvM2ZwLsMlPRk9uWA5VeOSZsdKsTI9x5jQwdrl2UVC6QgZ1Yba2RVe6x/pWlJ4pnWNu5qtf39y0HNUKzFGs1Nre6UCqiS5Sw0R7sJOgUHMAvPzfTLygjEJfhisKHkt5/ZDApO4vQ6ZCewN25uvTzqmKMhpEV7KK3/bnXcxLDcc4LKb8WIGqsVPK+FYenVLRe8t7Y5FKpee+4e27LLu9sm3RJJHTqPkVQbcSVbjPylVYTOdUi/O/2PgDbBHPRVG5sJVuHVgLJxHHBjaQSXYwCXJTST98G2O7LWu/HlCAGA2Set3JCy0p8Gm2M+5kfhYiNRMVLUVYOKTjDpnpsND88se6ILGk+SCjoETiceZWVFvSkIjbe48sJmuJcGRZg7BzTzZC2l4C1XNWNbGm3QGPySQjcK+WTRDRAYCO50jy1m4WyENEbMQTh1s+HOCdmc1jxXtgvs3sYF/xPqhv080
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(86362001)(36860700001)(356005)(82740400003)(6666004)(7636003)(41300700001)(4326008)(70206006)(7696005)(36756003)(40480700001)(70586007)(8936002)(8676002)(5660300002)(2906002)(82310400005)(426003)(40460700003)(186003)(6286002)(2616005)(336012)(26005)(16526019)(83380400001)(47076005)(316002)(54906003)(478600001)(55016003)(1076003)(110136005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:48:23.8147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f73af92b-1e5d-4eac-7d4a-08db20a4f3ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7801
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 780224fd67a1..a108e73c9f66 100644
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
+		       ip_tunnel_info_opts(b_info),
+		       a_info->options_len);
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

