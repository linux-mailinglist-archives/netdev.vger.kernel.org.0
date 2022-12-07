Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62BE6459F2
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLGMic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLGMiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:38:18 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2668C326C1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:38:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTcuj5Qj3X5wSVORKk18OwsXJ5iwqHY893EHAFETRrffs07jgKk6d9Oi3Qlvh19y6SCzVZT0hyREt/vsj32xtk11ou5mOuaKVwG72OlS9Lmq21xH9/LC6/aPV00QbNenFQg0vG7FfJynfEcshsbiLCTFAiZyMWqBLmDHOrC6nPy+eoz3shGWerPHLwmU+6s2r7+KVDkPee9M3KekDDYyc2JeCe0CSuWLXaX//S2GBctazPTqd3Bl/ey6RQyBH7AZxuXuGXzrVYrwvAYTARA+uM6oKctoFeO9rcorMu8mReY0sqd74v9KVS0CknU0qhfmfLmQv5l8o5NojW8a3bzETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUGTCysD/WqZkHq5++L09bTmohZg/AbvZyb0iM6fcPU=;
 b=WzbvuwbL/+Axu33Ow8exAkrXzpm/ao+EQgbB/Hb1BBu5hqrmB6hEPmNIITP+2ci7f+uZrIm9Mq/QWTihKxFg3upNstf2M9uiuX1zfizrV2RkcAj3wotH4SFU6UMUttJSyFfLNBK84BcX3bBIfUYFAKY+mDInT5pC0V8uJmMl4s+Fott1y6uEwgPq6ogKShmFi0umLIfplGkD0ZzCGzjIkmlA+uAs3kiyS+SoUPWBwpVBrUWnaok4VBeMjFlsqXhgJgFWn1AJmcFgEKRn+6SKXU9wpgJwLQ8p/qLAkzRMlkACBOYhxRrkAvaaZ5I90yDbdEBNuIQTVf2ewFO2926o3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUGTCysD/WqZkHq5++L09bTmohZg/AbvZyb0iM6fcPU=;
 b=nnkA0uXf0AOs9+nzuTtPDvDe2T5fNAHmQ4KfG+pSfDjPc///suEwGLeQquqNrV6cClDyB7SPTpfFQx/oCprtjahbezvTb+TPYkFu8iF2bsvzxHCxeqflzbIuqEHiKfR+HwknUcuf+COh6T2yR2uCzHnM26wVmUpLsIFPuNZ0UEIH/GPyFrR8Gkhl1yTBduzBITfQTVZb5sLx6nyQ3+e5KpHbL7NYqeYA3XU2/iMYlRytPcj/JkNcZz7bVp9Qup3rVnvXWxNiQokcuHFA9a43reiSftd2SlbyULdZijQs12Eb+1Q+Wey3r4VlfNW0ViaiNHBViwe07bRk3NfukWIhFw==
Received: from DS7PR03CA0134.namprd03.prod.outlook.com (2603:10b6:5:3b4::19)
 by CH2PR12MB4183.namprd12.prod.outlook.com (2603:10b6:610:7a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 12:38:04 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::4f) by DS7PR03CA0134.outlook.office365.com
 (2603:10b6:5:3b4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 12:38:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 12:38:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:52 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:50 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 5/6] mlxsw: spectrum_ipip: Add Spectrum-1 ip6gre support
Date:   Wed, 7 Dec 2022 13:36:46 +0100
Message-ID: <ccb4359fb983a248c3b7bdbca1e1548a0217b496.1670414573.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
References: <cover.1670414573.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|CH2PR12MB4183:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b71c2bb-15d2-4cef-63f5-08dad84fe278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /r5lTV3HTT3NXzP3UPWQ7ZUz/tvK5IqTTB095Y+xMDxL4veTOQn92KzYVLi7eqllFbFygaSY2YCVA0RE0G0MDj/YXhBWixQ+dfyjfmdohl+LRcnF3V48F/ceZpRWKJ2YXSXvreJkGjKGBT1rvmag5K8qDcKNGXQJ10h9swjxYpxijRQAtmKKy+SfZ1FlohQTaFPf9vlnT+IqWt7kSP1Ai/59D4sFFrbI+7bwhkMXhJ8z8gZ4UOlJm1jOgVIuEC39ylxiEd8QF1iIsF8kKmeGvbLXSM5OE2Q3rIE/ljSbEsa9/xuSqrc/eMxS3hCzeVddIoe/0csRyOudUjRysp7vqgiA1MZ9ZADElvxn/6eGRYtEtfteyxsdeVDFbtvDGOQjec7yKnLENWDCWvA0AcpprqPA5qCYlnVLufs/23NnZ76EsU9yPsEX5xR3cprUxsshDmgv5aa8vrBI/fXPtwRT4vv2lKjSljcdn6W92Y/Q2jlPgGErfr8eU5z2uGQXYgB1V4jcsnMXEe7fufxenaVK6uwi9cDgBiLpWtJ7NKaDHPBRsxH1NXZMdpqMCt6dE3X+m2yyPgzGOipUUjavQ9vIfKPRhvP1S7CN0i8vm20VGW/oWVnk0OWyacHBDQDia7+u/R86L9XXf2+JXJI2BfKxknGF4GR4DBzwWuIR8kdCp588t/IyMQkxMKNPz94303fBi5+I73/Z9Lnnljuovow7PC6gHHoEWZxpXWPqR8BTMZU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(7636003)(8936002)(356005)(86362001)(40460700003)(4326008)(41300700001)(2906002)(5660300002)(36860700001)(83380400001)(70206006)(54906003)(110136005)(316002)(70586007)(8676002)(2616005)(82740400003)(40480700001)(82310400005)(16526019)(478600001)(186003)(107886003)(426003)(6666004)(47076005)(7696005)(26005)(336012)(32563001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:38:03.8340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b71c2bb-15d2-4cef-63f5-08dad84fe278
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4183
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

As explained in the previous patch, the existing Spectrum-2 ip6gre
implementation can be reused for Spectrum-1. Change the Spectrum-1
ip6gre operations structure to use the common operations.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 83 ++-----------------
 1 file changed, 8 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index fd421fbfc71b..3340b4a694c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -362,73 +362,6 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.rem_ip_addr_unset = mlxsw_sp_ipip_rem_addr_unset_gre4,
 };
 
-static struct mlxsw_sp_ipip_parms
-mlxsw_sp1_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
-{
-	struct mlxsw_sp_ipip_parms parms = {0};
-
-	WARN_ON_ONCE(1);
-	return parms;
-}
-
-static int
-mlxsw_sp1_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				   struct mlxsw_sp_ipip_entry *ipip_entry,
-				   bool force, char *ratr_pl)
-{
-	WARN_ON_ONCE(1);
-	return -EINVAL;
-}
-
-static int
-mlxsw_sp1_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_ipip_entry *ipip_entry,
-				 u32 tunnel_index)
-{
-	WARN_ON_ONCE(1);
-	return -EINVAL;
-}
-
-static bool mlxsw_sp1_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
-					    const struct net_device *ol_dev)
-{
-	return false;
-}
-
-static struct mlxsw_sp_rif_ipip_lb_config
-mlxsw_sp1_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
-				       const struct net_device *ol_dev)
-{
-	struct mlxsw_sp_rif_ipip_lb_config config = {0};
-
-	WARN_ON_ONCE(1);
-	return config;
-}
-
-static int
-mlxsw_sp1_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
-				     struct mlxsw_sp_ipip_entry *ipip_entry,
-				     struct netlink_ext_ack *extack)
-{
-	WARN_ON_ONCE(1);
-	return -EINVAL;
-}
-
-static int
-mlxsw_sp1_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_ipip_entry *ipip_entry)
-{
-	WARN_ON_ONCE(1);
-	return -EINVAL;
-}
-
-static void
-mlxsw_sp1_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_sp_ipip_entry *ipip_entry)
-{
-	WARN_ON_ONCE(1);
-}
-
 static struct mlxsw_sp_ipip_parms
 mlxsw_sp_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
 {
@@ -566,14 +499,14 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
 	.inc_parsing_depth = true,
 	.double_rif_entry = true,
-	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
-	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
-	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
-	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
-	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
-	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
-	.rem_ip_addr_set = mlxsw_sp1_ipip_rem_addr_set_gre6,
-	.rem_ip_addr_unset = mlxsw_sp1_ipip_rem_addr_unset_gre6,
+	.parms_init = mlxsw_sp_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp_ipip_rem_addr_unset_gre6,
 };
 
 const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
-- 
2.35.3

