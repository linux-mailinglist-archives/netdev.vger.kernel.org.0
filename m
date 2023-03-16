Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9B76BC683
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCPHI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCPHIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:08:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1A4AB8A5;
        Thu, 16 Mar 2023 00:08:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQgOTg1Eifj5iq9dZMhUoMR6bSOfbMQQGarJCY2bWo5kgb8ngnRhNIGDAvqXnGOc+cV8qeuskt7SDMjGA8wQcoVnMzHHzvk8oBmRQBVpJwqP4cJ5p+icSfI2d+ySE5YPcQcCUbil3JDmfG1ib6nMPadVdx6qkvIgdkUixue+2jQ+wxju7n36TPndujE4LmywTiTFaMu4A09Iaw3Gj4jn8nkFvM91+ImRuqbnHnvhwc8FmwgS9ghj2DB8EpvR2wN3GxantDZleIwpOlb5B2jkw0UWD9C6CfmaTaKg8hguxdBYuy4NVq8oBIlo1NgnwCjmEeRxzAau0pFXhMVs7JAL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YfL0T1YDsrYwt0J+M/cZtIzjATWwYMf/KzwDTro9HI=;
 b=NwNOS29Zscaw7zq4ldwHdEJkRidNvYwu5M25Atr2G1v8SYTfs2omhbMOwjVwHKVsTOcA1ATct98vgfQdOWaGAsTydERRFo84OEhja32O9LI6bA7P6vQlhEYF3NgU1Jqbj/zzVtyl54lpNtbCOmvItg3xirJsoYAmR+oKM/PRqfLfLVTKsu1LOwMzs/uqjXuT58FtRxDZFp4+1vWzwygfGeiy23gs16zhE93/DDRaQvupa83CT4TjMiZeystWa6mpRu0eljiKIt6b/5aHPa9hy8+g+9bDht809EeChHkjT/glFXC/3fi0urV5HMnnmLnk1BqNPW8+qN2tmqjhCKyzwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YfL0T1YDsrYwt0J+M/cZtIzjATWwYMf/KzwDTro9HI=;
 b=MsfxrFtAYJeuaoe4YWr+r8yrlDig0GnvZrxRvxOCXPdf07Xg/+rD+a3xeuBCxb/P2dzGeUnXy+2/lMlkMTTmfzEUAokxM+qlA1j27EOO8ROg37ut3N8wSM/pyzMZFbZiX+/Lpou3dVRcWF/FCuwC92o7EwHESqVHPbV+E9jHnoxwVP4D5ewmu3Y4tkVdtZRO2wUoJ9PDz4Q8YB3gbqzNzQCzN51sXSZslUmtnhFJFc6Cb3+M9MITrpKJOsreiaPX4IIbvda6NiEV32PC2CzFJqQALuZ2n9SA76p8XdMspQDqFpgfkBPr2elOzyb40eQxD5FMu49AWYpZKPProQ2d7g==
Received: from CY5PR17CA0020.namprd17.prod.outlook.com (2603:10b6:930:17::32)
 by CH2PR12MB5513.namprd12.prod.outlook.com (2603:10b6:610:68::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 07:08:41 +0000
Received: from CY4PEPF0000C972.namprd02.prod.outlook.com
 (2603:10b6:930:17:cafe::82) by CY5PR17CA0020.outlook.office365.com
 (2603:10b6:930:17::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30 via Frontend
 Transport; Thu, 16 Mar 2023 07:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C972.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Thu, 16 Mar 2023 07:08:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 00:08:26 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 00:08:22 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v8 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Thu, 16 Mar 2023 09:07:55 +0200
Message-ID: <20230316070758.83512-3-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C972:EE_|CH2PR12MB5513:EE_
X-MS-Office365-Filtering-Correlation-Id: 15447acc-e94d-416e-be2a-08db25ed45ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kR5QRZQckTovw7U0kcaJZUErC9LlxMqp4q4qNGpBNG5Da+64NkGhEGcCokU86N1xvHf8JeHejL6V9XSLZD5QfrQvssAiBbn6IPagO/DwUvlxoVXIluix4fsUglmfBkFc0sCHp+cwn8gL8C8WA8NafVG4IpdTSCRl35pciv0a6B/4I2Zh1RJggYbq1a8Ogmto9BH7wI4Fca7YgbLBBlVuEcexGBh199IzAWE2+t1sOIZA4JScqFqCga1yt7eps1fEKAxeochLoOtEnd9aAKyD67PH3tdUxACqp06ioH41qvFkSGECwD6e4lb0lxA/I8/bj3xAQCEn5Y7TCcdLyvNyifpRny/pzfrcwNEBICrvIDcq+uwYHgMtzTTbo7XNdziOcxtLHZRPe7PB0Ngpv47QaY6YA4KxeeZ7dtvAjcnPvtMgZcvZ2MN/AmwfdShphfHHvSJTgV3VOmx02PXjH62/Es37gXIZjAbMgusyHhmyM1GKmuyoGwhJam69b/qv2jBe2pe4eQrf1Aac6wpqEKDbmt2ZbrvElqC6rkHZVh5wT6rVAnsbm329rkEfdEy2T+rEU6uuzDCrZ2sZCX5UQ60UhKBE920djN6frLTru/kblFaVGifHC1YA6OG5UwJDQA+rpz0ZR2nhU50slzU5RnzEnrScOiH9nJS7IyZ5RVM7z/8w4gVc5L9v1+PDVePlr6RBeSU/sqS8HNn9MzRYj53SLsPKarFVnFigZmW0b8UGul+BOs/NUGbtTK2lpu7AlPnl
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(86362001)(36756003)(36860700001)(7636003)(356005)(41300700001)(2906002)(5660300002)(8936002)(55016003)(82310400005)(40460700003)(40480700001)(4326008)(47076005)(186003)(26005)(83380400001)(16526019)(2616005)(1076003)(336012)(316002)(54906003)(6286002)(426003)(110136005)(6666004)(8676002)(7696005)(478600001)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 07:08:40.8454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15447acc-e94d-416e-be2a-08db25ed45ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C972.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function vxlan_build_gbp_hdr will be used by other modules to build
gbp option in vxlan header according to gbp flags.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/vxlan/vxlan_core.c | 19 -------------------
 include/net/vxlan.h            | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index d5e9e1ee033a..3f0416992eb0 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,25 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
-{
-	struct vxlanhdr_gbp *gbp;
-
-	if (!md->gbp)
-		return;
-
-	gbp = (struct vxlanhdr_gbp *)vxh;
-	vxh->vx_flags |= VXLAN_HF_GBP;
-
-	if (md->gbp & VXLAN_GBP_DONT_LEARN)
-		gbp->dont_learn = 1;
-
-	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
-		gbp->policy_applied = 1;
-
-	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
-}
-
 static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
 {
 	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index bca5b01af247..b6d419fa7ab1 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -566,4 +566,23 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
 	return true;
 }
 
+static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct vxlan_metadata *md)
+{
+	struct vxlanhdr_gbp *gbp;
+
+	if (!md->gbp)
+		return;
+
+	gbp = (struct vxlanhdr_gbp *)vxh;
+	vxh->vx_flags |= VXLAN_HF_GBP;
+
+	if (md->gbp & VXLAN_GBP_DONT_LEARN)
+		gbp->dont_learn = 1;
+
+	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
+		gbp->policy_applied = 1;
+
+	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
+}
+
 #endif
-- 
2.31.1

