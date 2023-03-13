Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59FC6B706C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCMHxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCMHwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:52:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA928EA0;
        Mon, 13 Mar 2023 00:51:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFXYiy9/6eSFIZyqb26a9XdbkXhhlSSdBIvMf1mv537MvRku+5rt52PEDZwvI0mBzY9z525A/oh6QNkeIBu1AG7vnXWkqtqotDpJ7rS/IqmsEI1mr2Vd/F4VPslaausjs60oY9A8BVgZSIqzZcFjhVUZbNMAyfaHY4+4Tx0c6s3uW09w15tuYL5hj428xgziNnsQf3qUfx7HIToCSsWPM6bnu4MnB5BKj/HJccFTXAtJj/P/4G5aancln5EGHmKPC3/2GuGrM4NZYsF15yV6In3xdyfBMEpy3CwSjD5COUZOMDE9B8GYLQsyXgKqVwifi72ILFDZtdc4yU+K4dGR2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9+KU7YTv70LcPI9sTqYHjSPOzTytRYs0gJXbtLQBCw=;
 b=kU1ZLTR3b8xvGnS+kVKC+EHwXa2EibVqrmVMFapocwT7Sx1urdfFHd80cgMb3p+LevBuMkZYPVWaNoCT+bSUYG7+iaouHSfne3zvp8aEpV2ssC5+Ee987mUuVJfQHM+MvT6DGLAaPvSz1WZBTOB4qWzo1u8iuQbdjC8g+e1Ai437FmSZgnRAOFnGLBGQ/QXMeZTmTNQtNtJxzFk2QG4n1ppoQXWjXIvxqpsCBRBsZOVs2sJ8kK8pX0tVk4mD3xNNPe9JeaaEivfaakUWFehcq/pw0m2hO4ArTVLEjIa8sYCDkfiuBdhDgs5037qHyRkm3iQABNMLcgESqBuE4Eh//A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9+KU7YTv70LcPI9sTqYHjSPOzTytRYs0gJXbtLQBCw=;
 b=hK3+jyQOF3mTXybWZd+NqRwK49bladuzB+UZKv4GHHDEE4m7itQDH8LZQKRnP5+NkrxPLV19zqjQDVWIJc1/qkj3yIoBi2ykHcghH0tBVHYOrHn/ugntbOu+ENyFnhGsOfVOX82cmS44KO9QsGv2tpR5GJxLtPObXPjyJRO2a914utfhDPEO4gnilATvzTSCUFic/f7OkjxE/42oBWw1iFOz7aCRQx1sLaAVd/fzq7qASUCxkWD6ztQWURAC58+D0UNtl9lzfNtHnLMJ0QRsoW3N7IvpUnfVKuqNzroPiAMwzCC3MyfcJlwyn2COyG903bzxm8u53x/2gStay/XYhA==
Received: from CYZPR20CA0002.namprd20.prod.outlook.com (2603:10b6:930:a2::10)
 by BY5PR12MB5015.namprd12.prod.outlook.com (2603:10b6:a03:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:51:45 +0000
Received: from CY4PEPF0000C964.namprd02.prod.outlook.com
 (2603:10b6:930:a2:cafe::a7) by CYZPR20CA0002.outlook.office365.com
 (2603:10b6:930:a2::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 07:51:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C964.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Mon, 13 Mar 2023 07:51:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 00:51:39 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 13 Mar
 2023 00:51:35 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v7 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Mon, 13 Mar 2023 09:51:04 +0200
Message-ID: <20230313075107.376898-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313075107.376898-1-gavinl@nvidia.com>
References: <20230313075107.376898-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C964:EE_|BY5PR12MB5015:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c51c11-7fe5-4b19-afd1-08db2397caf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQpxC3khOkdAeYXDnnnR5s8PuLcwTTF1h8hA+3YvyOZqZpPImLVz+9LfpNZRUrJ108kNVDWJ8JNMdqq1RO/wIUPbk1cSqfu/9rIbmvxe52u+icGxGaH3k4t0HpPvQFS/Q1osrLsfGNvut9joyMEBXQJOtTF9qKKNV17yspNbaVVSIn4pjfo3Z7Rki47xyBUOHjO8u2NjUDOsTCEF/k2sbAqjmaFLjWLvG2NvQSUJNzvaM+zliQtEti2x8c/xRGHyxwqCw9Ls3Klzkv5BuQiMNwhKVdl8t7e5+whz263/+GvYmuzD0WaoOXCwsip4Za1iAZMhJbfRFwJt5y66kLQhPcrtcIZ8gCdnHMvsLpdJ6OKDADnNTAiThodio3UYv1qPMKftUPJxRZMLs3wxY5v1c4dsO+OBygP4rcoMPVKwFXmNRnGq90eyccjWMYDJLe1KfmQtFopuCIn1PD37TTIA3NYRZFUigjzViw8CWL+bbvULRp2XxCYO1y2MK6wpS/3yWBg9zI56yRMJaNdk9vG1ipK4DjtGT+2ClXga8mZbMV0LPlS5T22dhFYNQZAhqaxTQ1KJtvn/+oUalZoVaeshXfet6pmynOI1Wxq2Rv+GEyHYXKtP74sWhazBI7HKaQrHslOz7RP9oTSQRziYiU2jnOfkqZ8MiE/ztuK0C7EydVxmUb8muBRWo4SD/lDKwwWFmYjeP1ql/R7tgPCw8HJ4XKu3Q7xJQLH94uuDP9kvSTM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39850400004)(346002)(136003)(451199018)(46966006)(36840700001)(2906002)(83380400001)(6666004)(7696005)(36756003)(26005)(4326008)(5660300002)(8936002)(16526019)(55016003)(186003)(40480700001)(1076003)(6286002)(86362001)(2616005)(41300700001)(426003)(70206006)(47076005)(70586007)(356005)(336012)(8676002)(7636003)(82740400003)(110136005)(316002)(54906003)(36860700001)(82310400005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:51:45.3586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c51c11-7fe5-4b19-afd1-08db2397caf2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5015
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

