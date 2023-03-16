Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E740E6BC687
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCPHJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjCPHIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:08:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BD5ACBB3;
        Thu, 16 Mar 2023 00:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqFepxGHJZAe+LInCF51PmosFqjuQOS/0OAYfB88EL5OB5KNG0dpIWH5jpGs5GskH5TRXmKwkEFJZiFRwsxtNUQPWNe3Dl+xZVFqbdWsvyxerAV8Mgb0OeJKUvy7LCbWheVOovLMwcXz1A/RqsRyag0NB/+8AhjPlLs6Kmu6boz3mGyI1pOTno1MWMfKRlDKXU0ZUv6jK7+7IBVZxRAiLnDq37G1qYHPWCrD3TJ6kfAYvRg6A8pLTmGLJHeYrwtA2YG9p/fsMdg8KTvrUfJQ/7epaaLPwdAGyLHP0tB6B2n5Dl9Z/pCG18qLnfFGubR18lB3EB+k/NCQUQaDVskmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N179DlG4Bn/W8g7JOeG9FuYbjDYjXPaJecv7CzHK2fc=;
 b=Vts8FIbYEhrnNnCrd9xcC6rZ9LhosUXOny01KbBwfaIw9CfgJGhSbWsIWtGqmvF36nrQ+ZNsgdVUb9PzPE7IMayjP0/gqDwo+JJXgjihMFu7+vabzZaAhLA3sgbUmcbve89ASDgsu1ogkpYCxUOeXKGJJFwsuPX/GJUidRDeDTJS13eAouAHQ8GphCGFYta43ukgQCOGMRBlI5HCEXIsBr+rRWh1SEWSFaWsTAEI17CA8jOzrPfHtNe7E6w03vrMD2EcsrDE8lzhA0s+P3sxoOXaQmLe/VKx+of7OQFQ4dCz6KSvdY72cWXoVTOBGWbRqgwjNqM4+dywe2EsxxuApA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N179DlG4Bn/W8g7JOeG9FuYbjDYjXPaJecv7CzHK2fc=;
 b=fKNZwCqJg6XeamyvVh2cj7Kd9BBOkoTUNdnRS10rWfDnRj5rd0wI103uZBIYuyIJ2Kwh28Wovc5R/ZRWe4KR+71EmPVFNrlt/4+fOlORrCrlP4rntorgapVMPBmVA4R3gnfAckFCPhEFHUWBD2S8n5ikfxw12H2rBz0yHiXvW5cOqETq2JYMHd20bFtwUy5cY8MvVSsTONmFgohlgpKa7VJfJLAeqpBOVCOmImyclsx05rEWu0NYLo0ZYzyh5QQ7Zk0HGHwlOFdggBHWmzZdcQ/Y2RX3HjP5gZ/IJINO7s63uxTkhXBtcUyAlLzT95Ml9i7uN8PlN++tup7or40n5A==
Received: from CY8PR11CA0024.namprd11.prod.outlook.com (2603:10b6:930:48::24)
 by IA1PR12MB7542.namprd12.prod.outlook.com (2603:10b6:208:42e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 07:08:46 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:930:48:cafe::c3) by CY8PR11CA0024.outlook.office365.com
 (2603:10b6:930:48::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31 via Frontend
 Transport; Thu, 16 Mar 2023 07:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.8 via Frontend Transport; Thu, 16 Mar 2023 07:08:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 00:08:30 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 00:08:26 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v8 3/5] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Thu, 16 Mar 2023 09:07:56 +0200
Message-ID: <20230316070758.83512-4-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316070758.83512-1-gavinl@nvidia.com>
References: <20230316070758.83512-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|IA1PR12MB7542:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e7b0830-5cf7-41e1-9021-08db25ed4866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UlMihTuAFHVlR6GglpWxOQefmrLuov9b1dOzh8Sm1PAD7leyiJBggKJEFfgIJyl4nfGEFZ8v0kPeGTfgaLSl7kSfR+fuzVsUzN27eLZ8xIy4lEqW9XXUoGaCL0qqInYAw34jM+Md7FsCDLhpbZTf8yyFCwLJjsvXzXkvEP8inHYelzW8sEV0j6tNZRO5fa+/mFxHqCirxHmBTtBOFE/aqhYtFr4AKUCMFdqaZQJ5BQ4rmuhlJPheQGzgScb8bL4bEzydHFuUitz99/wvbfd9o2tHMdrNk/XIUoEnA9n0h9aTGUiVydiMT0cfrZtu/80DmuBxmgE4NvGnag3i0a3g6nlQMD1Sa40XoA/352Vatxa3MZG8FxMkeTQzNOM8GNB3ZCyZ4qaZStqRhwv9SiA0pj7e2NYLoqjNE6d9NJ6iYKAji/XXUB50PbInihHrlWu7f2vL+HT/KRtNTe/BhgPSCcRpCUhtsuAt5IZ644JNZ6gjDrBjXATaAjCY2ned6Lhcs1EkntwnZ1KJCNbJ/eqTDjPMO+KlWwdo/0lbp+bxfWYovsv2zN7aH6+PZOeu0EDCtwlVRs0/BguqwfAofX7qttKJDIp3zSXDs+KSePJdUkUVUKnCuuoQXKM49H3cUTz/WhYOhRYpXNHC8Zt2xzBCU28YA4jbKNIxmWXE5URFdzzomURxXjIewkUAoMkUtK/lfgEfqy7L1QeDlAxSSznSxGOCIaPRoaUG8nk/lIHnfm4pVXtTxczwZPFdnAXL7T1K
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(82310400005)(356005)(36860700001)(7636003)(55016003)(40480700001)(36756003)(70586007)(4326008)(40460700003)(86362001)(41300700001)(54906003)(8676002)(82740400003)(70206006)(110136005)(8936002)(478600001)(7696005)(316002)(2906002)(426003)(83380400001)(336012)(47076005)(2616005)(5660300002)(186003)(6666004)(16526019)(1076003)(6286002)(26005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 07:08:45.3809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7b0830-5cf7-41e1-9021-08db25ed4866
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7542
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

