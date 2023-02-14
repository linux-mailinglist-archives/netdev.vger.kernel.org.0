Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE01A696533
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjBNNoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbjBNNoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:44:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B17629408;
        Tue, 14 Feb 2023 05:43:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY1mUVs8OO29I2v4kMC7BeieydWdm2dP1f5OS9JxPNVyp2EFxG8ui3QonbmASRBA/x5S0pOkDWp5Ee77pnsUoykTTDRgXB3+4D9PS/bIPWO/IlMCY/aqpEAMNmE+6dT2vhm2zjgGymPcj/cVfa5H5nde3CrQ1T4KTZvu6r8ri/aY1BihI4mxGOnfmVtJCvCbIDG7onR7rYLA+s3fbLd840c/cwPGgPkG01BDVVIyp7KOA5ISbd5StQ+XpyMU+LYPuy6E7Lcf1eKJZbsVDGobF8h2YW0BGTlkTY+2sVRANx/zY3s4F3t7t6CuVU54SeKQF2vOA09GOjOGlQD5zO6bKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QvPB67zcpn4UFNOSQRxcsU9kM7hP91sBmGQT+dDNOg=;
 b=MYrpYGeqMw0sCCoSoyKODqKqmzwHafzEV2LDzuAmkLbYtNvLrfcLHtxBzql5AGs5NLLDpHGs0UqiA7JxX8Iv9CygXWIoHQbb5ltgpJvw2Zt+UpBia6dxxT5ayCPPCf9WVXu0kpl8YU9mLYbIkme+KwPJlkbkRFQeu0U9JBxFT8PkbDa6SchYMDFWsogxpMB9bgVRv/pkPLYohvizdUKXKV34ZiiG3W0OjNnHS8FPWU2I2SMJXT7H8OuaKOShrXVNZK0nMw9cIPz5hiuXoCWyOzj03H+A/GttB54Ge7NO2tEt/vQMFprPE4yfSGYRgWKldPQDCRMmQq/EF6oPxa24qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QvPB67zcpn4UFNOSQRxcsU9kM7hP91sBmGQT+dDNOg=;
 b=VnwlmlZQ3gyoEy71vgwT4Lr8HfzMaR5OaUy6ecpY69D8RBgUT5TiZ8GK3KPBnumiIDlBeggPk6kHX8firYdTzp9Qskts5a6ie4OUOKWVEst1V8R1wruGptMnEE1stD3l7PYgpI4STDJltnwT/VrTgSKRn+mYtFpTcxQW0u7ELa24yLoShf0r2LeqZnm6Nlz1j/zD1F9cj5ilNeOzxgTRM2T/O61odHvmymjOKfyugqyXOsO0ufvD55ewiYVd8Z7dVwS9uLgKv+i3rwHMhB7ApE8OjRIm1dRn4PT2SAgfseQFxC292EEV1tS0Eg47M/5fv9HhF//+Ec0qIfiILZTY3w==
Received: from DS7PR05CA0107.namprd05.prod.outlook.com (2603:10b6:8:56::25) by
 MW3PR12MB4522.namprd12.prod.outlook.com (2603:10b6:303:5f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.22; Tue, 14 Feb 2023 13:42:19 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::a0) by DS7PR05CA0107.outlook.office365.com
 (2603:10b6:8:56::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Tue, 14 Feb 2023 13:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 13:42:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:13 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:10 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 2/3] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Tue, 14 Feb 2023 15:41:36 +0200
Message-ID: <20230214134137.225999-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214134137.225999-1-gavinl@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|MW3PR12MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: a1536cba-a3c1-4057-9692-08db0e914ac7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2X8iAxV16dwdSvvA+2DCBirAa9iEc8B8NDs1AZEd5p2la7zVFZUE6FyvRZFi+GnjrKoHI7IbZhxSsjALoe8IUj0Yn3ZLe9bVFKgB2dfHJYkyDXL4VNXpK2FN1Yb+Im9q0S29AZ6eKCJeSFvpYPnjaSYXG9oNr9nz3t7rcmSBk9/jF+F9KVRvteiJa+toUptjNZ/fX3NE8LmdNkQg4cTRo1yOnoohOarXgopJ1GMgPfbRzDB8A4fLjw4yBYlNNa06PgzRkZusvu/hYtYFFc095qUycjgwiBVVZ5qTXmkYIG1MIrT8pnZFwlfeg2X1PWmUdQcPs04poXkg/8SoDwKYUm70X0bU3aVTkLUbjQ333Hg/HwUtU2LPkjaPKSeJkPsFK0oA8QJiBlIrbWz0Yc3e391L8DL8qdfmNvcqbtGyD4FVE78DvCWXdm3u7y3xajsTVl+r9nz3HAbGh//VkfxYN9z8thN8TB1Uxyr6Q9f3xboDUUYnkQnZVo9R+OmVZbIllc8cL/s5AWpSz2LR60OsiKNQDkGoDOvMVq0stpNv+rgPBgLdSN2ejGlnfhioFkL3dpn8m789CimmGck5plu9FZt+tXp8wuhkKR/a6hhKR4os14A+30fHXGD9Gi1rf742o3H+ij30930OiSedHw3mhqMUAWMJHaMav3YfGat6ZCSBMCVGJVo4g2QLfPyiP/HhDoKLWG6Q0yu5pcJ1P5qXDQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(82310400005)(83380400001)(36860700001)(7696005)(36756003)(107886003)(6666004)(2906002)(1076003)(82740400003)(186003)(54906003)(7636003)(70586007)(2616005)(4326008)(70206006)(16526019)(26005)(336012)(8676002)(6286002)(478600001)(47076005)(40460700003)(8936002)(426003)(41300700001)(86362001)(110136005)(5660300002)(316002)(55016003)(356005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:42:18.9292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1536cba-a3c1-4057-9692-08db0e914ac7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4522
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

Change-Id: I3ea697293c8d5d66c0c20080dbde88f60bcbd62f
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 ++
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 29 +++++++++++++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +--------------
 3 files changed, 33 insertions(+), 23 deletions(-)

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
index 780224fd67a1..4df9d27a63ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -571,6 +571,35 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
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
+		memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
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

