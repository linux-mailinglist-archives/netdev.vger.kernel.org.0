Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB626B25CE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjCINs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjCINsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89721B544;
        Thu,  9 Mar 2023 05:48:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJjCAofF9JTQQtJ4i/gYed5VcgbvWKVg/EQUaYsx0tWRl60fz4NdUdbR1+ogFhMUKkEmCJtnauehvtfLOmaBL9MIa/5LtilN6HOk0TRBGv0A05k/8WwQ4g5i0T3izXyvmI1u+kAl6ajBQnLKInQ+pYEaE2AHtx9dl/8ceUu91j/wzJlJbZM10sN1LerjGBOSU2QuDLCVp75HyOWEZswpU+fYxDwDGHdi/5yJPkEgBJchN2NBQ6pwZC8sFLf2uWHCSb+UjybEw+s9wg4u7JU8YRQiQEdbW37nn6sE4Es5gBvQ58NA6uCrP4rYyn4BWIoO+1IoTqRFCTRRFZ09zFNQHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9+KU7YTv70LcPI9sTqYHjSPOzTytRYs0gJXbtLQBCw=;
 b=ghlRiI4aRxmH4giGaeu5shNjLOzPHYZrKiirrrQDHDIR5MyKUTooiRJporYsnBxlz8QfvKUdYzmhP7ST8HKcDVcVpK5yPrBe+mAgv/OMaGizdALY9RTnLXrBlR2+AvLVR2RagrccB+3/cRLMaWlRiq9rQBj2TZNL+lMDfP2OLZOsAvNJp3vG9w6WUj8Y/uuCY3IxG1u9BLXjilIzG72+b8kOMU+ITqYJFmfbuY7pco7MSENMITA4qhMXl2DDbmM8wPeoVUd1LOqO3eH9XpGKW67N8G5v2KnahzVdCi0JskF4Mq0LYweNOHovOnSqQuIrgMSXiR4b0zNbqkJ5pKInlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9+KU7YTv70LcPI9sTqYHjSPOzTytRYs0gJXbtLQBCw=;
 b=hO7W2bmpp9Vy5ZQ2DEEScNuNZcY5Ocr2l/2ik/9jVIJL9bsvyOeTdFop4rgB1/cyZtWFalt++Qgh+mTq5qCoCcc1erS/VM/qqnI5N5LWDL5V53UD6BXMU3c+/7y93rNVW8zcJIRb9N/b+4lwNCm7ZDqJtr0KKldFvEQ5Z4VJKZ8nFwZQ7eLd3M3Siv/8sHp9iahQ7VqFbeGJwpdEX8EgryxQgD9WXR935jIBC2UjQ7zfkqgAw1o9XuYkXJLndomuVMfS3hZag4rFyh7F/ykqdClwGuq1DLVrKcPXZ2V3s79Ev0jb8LpO4WCSo/ZuniTJXK0kYBvq9r7LvYXRzX/nUg==
Received: from DS7PR03CA0129.namprd03.prod.outlook.com (2603:10b6:5:3b4::14)
 by PH7PR12MB7260.namprd12.prod.outlook.com (2603:10b6:510:208::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 13:48:16 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:5:3b4:cafe::b2) by DS7PR03CA0129.outlook.office365.com
 (2603:10b6:5:3b4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Thu, 9 Mar 2023 13:48:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Thu, 9 Mar 2023 13:48:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 05:48:06 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 05:48:03 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v6 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Thu, 9 Mar 2023 15:47:15 +0200
Message-ID: <20230309134718.306570-3-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|PH7PR12MB7260:EE_
X-MS-Office365-Filtering-Correlation-Id: af069598-db71-43b1-a53a-08db20a4ef06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XvJwr0LNTF/D2Bf08EwPfQQJ5uUXDhO60zlmsP743BjzCbRFdfmTjOhBEhgGq5P+XoOsZLJuxNdJrlGtoLtPouyLebYH38clmoX94nq4+6Vw8bTczvycysvVKe8tHFKyOVUX6qeAJpHcFnQNctgBWidLKCa/ib3eIAU1/FgRLWp/P/8iGc6Ng9g3068Tkg5GyNE3NeesD5Hhh1p7O/toVU/dXSbpaxFWSZsMINE0gCW1qqKAf1VnEKpi1UzpGEMKGNqypPVlT3PPbSMfXx9IMJL9v6Vew1dW8N7EgAaHpccAxo9sz3HFFFTDRgZ5X0Bt46VdAexyJLzZR97yA1e4SemqDG2qnnvFI6bkhqkL3OfCozmCD+eIh+eNE+TEOThVU5YM3TH7g8FhuonHkwLIpp99/9TrwMdnkT6qto8p9qBLEDzXQXqJFjnyUzYh5x6AoetsEx7RaqxsapJQ0aKrn884uvhidtuXU7FUbvPgtkyLMNJsp0zPrhGtqgM94ub267BlKvYyrN1u+YmoOqpL8hcEh5xx15P/FuayhqEORcSZXPnOPkLChngHCX3mQ0RkvUZHOfO8mPrFJiLngmHEXNsnKCgYUk6BXsMrH0/6gHL1raNJjGU9+J3GmZgF72NkKBirZgOvpoT2wErafQi5pzJexar/ZUTXh46lsfgehWU1byFnoEz5q+XtqFRjkJx28vqXgVGaHyxJmBBIS71WdeWkE9gb6Uhavge156lDgf2Xjd8uAqCI7mBJLlgqDolA
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(36756003)(110136005)(54906003)(478600001)(7696005)(316002)(5660300002)(2906002)(8936002)(8676002)(70206006)(70586007)(41300700001)(4326008)(82740400003)(7636003)(36860700001)(356005)(55016003)(40480700001)(86362001)(1076003)(186003)(6286002)(16526019)(6666004)(2616005)(26005)(83380400001)(82310400005)(47076005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:48:15.8410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af069598-db71-43b1-a53a-08db20a4ef06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7260
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
index 86967277ab97..13faab36b3e1 100644
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

