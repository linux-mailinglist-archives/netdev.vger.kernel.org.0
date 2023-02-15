Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB98697929
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbjBOJll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbjBOJlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:41:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB37928205;
        Wed, 15 Feb 2023 01:41:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTlNdwmpOPyvDlAL7Y6shFc+QlAdKGnAzQDiRh3QtOoKxl7731eXJuGT2f7B48FV2PbVyArTMgK8D4WMG8Rb4MrGiKmkP/YlEk/AENl4Bq07f0i/mOIUh72VLXnw6WoRP0eSo6ABsxxem5Jj5PWr02iMYXTYd2iS8R4bCGbXIzPetQyc+tCIA0VSJCcDWt0jY+eNe8mVQrSzmBghbWj28sxPDEcZjL0vOiax5+DR6AG7RCObxT3NkK0IlkXHf8Ya0wvnI60aT3TpJ3VkRJW1p0keknRhI/xdFWdCGgPLoCjR2YhYJqjLSphBnor324t6Bt3v6MRrtE0zExewRY+a2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMXstPUdnPhcsJUfLxNRhxudvHD0h1nE1zDKqX4xHks=;
 b=ADbTHWPs8X4C5pet4sNT0vQCpJzCwEdB/yq3tpnF5hjIWPVMdTayx3mj0Xw/HE2ONJ49HjtVs+pPReWUFKopm0mqA0I0YYJVlnh99CYJwXqzrFhkn2mGWERkOfK3vbsT6IdmP92omNYw9IzLI0i1fkEfa+2UpAwgynmtLKY5Px8sDUnMvOAkJVRGYIfTFrUnuzI1KuZWleWAKMIHqwyNYYFfJ4/saEVrCNHyEWLI6xmEcfcpOhD+8lZenVPCFYXL7mJ5DpyGJ2n7qb3r/GUMZgeJbbL3Lb2tqFeSLGeywowlfOcbPaiKj6f24XaW+vMgiv4FiYezH6v9n+2TpjWBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMXstPUdnPhcsJUfLxNRhxudvHD0h1nE1zDKqX4xHks=;
 b=izLv9ONqSfpl5H2of5fTI5fDAoUDGvscivaHxFUtb/DyxTy8px0ksid5stq95N9hLFa7mdPibELmrU2YPN2sUb2YVJwXzc0QxdwuuSirPQKSUy/zIdN2RSCu1bDGxsdlaV6F9Jl8gBZRu0nF1ZFshqYNsWELEJXTV817uxQSarLr3gWtdZnTBLZQwwAjWHEnjQsjNNisS14d+nCG71jj2dfGGYcS4vWY3irrV0kzYwxSKYTnAC1uno9DidrOZ23LFA02PsW1iIE7s5lSEdZB4XVTM2bOJlAfBPls7/6UhGplXs2YMOB90oa4lShzgGXMuVy//45jliH2pAnI1gP4VA==
Received: from MW4P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::35)
 by IA1PR12MB6234.namprd12.prod.outlook.com (2603:10b6:208:3e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 09:41:35 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::d1) by MW4P222CA0030.outlook.office365.com
 (2603:10b6:303:114::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:41:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Wed, 15 Feb 2023 09:41:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 01:41:24 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 01:41:20 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Gavi Teitz <gavi@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 1/3] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Wed, 15 Feb 2023 11:41:00 +0200
Message-ID: <20230215094102.36844-2-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|IA1PR12MB6234:EE_
X-MS-Office365-Filtering-Correlation-Id: 1965a9f5-e911-4d16-cdf0-08db0f38d3cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjgjeOO5rA4nl23AjRWdyYhewsqofA1Gz9d/tnn72KGC4kwsBV/0vFNpaqpR6pzHcuo0jcKl0UFE6Y/b+EZ1mxZ+h1aXioDF+R4Z4LsStKHMmn4zEq4Iem0x/hTeIsx79h1bRW3LulXedp/TGFvk15UF7jLPV19t06YVTnH+F7KyuBc/MbCXWccFeQoHOAXvC3saaCWZZNj72xVfVZ1YSxROVJ2GLgRCDGkL/iJN8kqbvOxm9jE7QO8BZLSlJXqYW2eFG28yYTgdl9+BwO0Ob6+GoBYjiYyI23VPn4NS2YQRhaNQym9vufyloKqxIm7JkX2IX7yJS3A6FMNS7gFYMHTDT9qIyZ1uToNtbH09e+Jvjt7/AT9s7hTCbcm3EgQRe5MTkiI5RgTr8vX8stbcjKT+dCFoV7fDxuBNzakl+PifqN/EsVmg4HvUh3B7iyDmmXBQ6U4DDQ+nyMbPi3QuGWc1X22uWKcVu0Kwbc+4PsygnFNRxJSR83OhK7fh3jeMDw5fyb5AqrKF9suNx+G4Cxf2v2uK3hh0aEH5p6tlje73m67eUsMUQiYTxUZjAtFBjvD0P9i9BKYNtrU/FID1y22LYxTsmU8Q94YrYfGHAZD7qBZNJB79nP01/YwWrS+xyn9+ciS4PBwo9lJPp+BIFl/3951MqiqXH07a6wQEq+y5g+waxYmeJV/1aoBQdAHo3YEkkcxdo6RQ+P5ynRJ4Eg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(36756003)(478600001)(7696005)(4326008)(1076003)(70206006)(426003)(2616005)(83380400001)(55016003)(70586007)(8936002)(6286002)(47076005)(336012)(36860700001)(2906002)(41300700001)(8676002)(40480700001)(6666004)(54906003)(356005)(316002)(110136005)(40460700003)(82310400005)(107886003)(26005)(86362001)(7636003)(186003)(82740400003)(5660300002)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:41:34.8054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1965a9f5-e911-4d16-cdf0-08db0f38d3cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6234
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan_build_gbp_hdr will be used by other modules to build gbp option in
vxlan header according to gbp flags.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 20 --------------------
 include/net/vxlan.h            | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..bd44467a5a39 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,26 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
-				struct vxlan_metadata *md)
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
 static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
 			       __be16 protocol)
 {
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index bca5b01af247..02b01a6034a2 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -566,4 +566,24 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
 	return true;
 }
 
+static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
+				       const struct vxlan_metadata *md)
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

