Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A85169ED21
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjBVC5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbjBVC5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:57:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10hn2239.outbound.protection.outlook.com [52.100.157.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22E61BC9;
        Tue, 21 Feb 2023 18:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWxhVBfM/Ft9Z8CWvDKgQiVdvbJsFcjGZSpwNtapwWF4lqli8dLX/+U4LUYQ2okMNDKTEwiXZgiKfXfLBlS9eqHDVMGZTCzdl//Yh2K9cQvHpmNr7c29lVk3T9rxMdNerxjggfiCg08EPCSUbplF+jXN8ljc447bxHNbtJiZCTjD+SXVJ/VHN3V2dUZuCGZvHglFIbUXoIeDqTNvD49Y/jJND9ZhvoaCNoNUBwbUyVlsNtj34bPoWtekBuIeSUwloAVZTtDBgnO/izLBcwwF1faWsob1KzHbpDwbJ+MDEKswCOSTM1sb9WvqTWyIJJq/knAeXUuIYRwNuSUop/2oaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6jhJVBD9VDkGSbFbfkRjF65IBJnh1t3/5wWG0GoYnw=;
 b=KF4r95r15cVi1ak0moR/aaqEdMKbhQGpw3XeaDJ5QmlAIpLGfcaR5NyMoo0vYDuYwp1SOlYrWn9ceF2j42ZPQhkTl1t82o2gvUtdb7SEtAe/iyCU6TtinmCCrDpHosRNG5DLPJVSnuU4KqF9hnboJSYXTv/PFJYCmmic/euhOesJg/CARno54Qr+SugOxfcMyojKJ4lD7/LJGXpQqp09q2oT12a1+qS+1ogmJhAxPxldFNzbIDrdSBbHXxDNjvXvU+ohKe5Ljf3zB7Azrqd7q++evchad+QsIsg8tgoKXODAUqFdRhSMOOBkvRC0JD8JZcutoZ/1YGFgRvcf4PWsww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6jhJVBD9VDkGSbFbfkRjF65IBJnh1t3/5wWG0GoYnw=;
 b=csWwnSZOYnnZcmbw836V+likE+WNIRawbOTHxtjYzd853OIdJZsrbFgtropbDL31Y1pAjeFzecuPiJhrQ2jsujQOTs/y0B+P3UhDDJiSehzpzNoRO2IIefetJiSJ6/+Kwae4/sR2ViZSPvrWEJNrb9KBbV4hiHCNb8/dL2hnSNCGV094pknBgaPw/W40pI1jRSvvYyIfyPRypV/8hNWpLnUMTDEJa8FK4a3/+8fq4qo4bkOS2uLkA+p91qqpxdaDLCaeTe/R2Iig290FMWZSH0xSQAryb9zLBwp8OFAp1f16tn4RRR9XyIPskSXhWaagmJhl/BHtTw5g6vefHq2Rhg==
Received: from BN9PR03CA0601.namprd03.prod.outlook.com (2603:10b6:408:106::6)
 by DS7PR12MB6007.namprd12.prod.outlook.com (2603:10b6:8:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 02:57:46 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::a3) by BN9PR03CA0601.outlook.office365.com
 (2603:10b6:408:106::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21 via Frontend
 Transport; Wed, 22 Feb 2023 02:57:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.17 via Frontend Transport; Wed, 22 Feb 2023 02:57:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:30 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:25 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 2/4] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Wed, 22 Feb 2023 04:56:51 +0200
Message-ID: <20230222025653.20425-3-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|DS7PR12MB6007:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c0e10d-a7bc-4c0b-968e-08db14809378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOgfoKVMC+iQINOFvDP3gMn/VMRK6F18mjsVhBKkpx/B+S9P05TDQ7AqG+IJ8cuvqHsmcELErgIpqwbPqIn4PTgb2j+FT3SRSxH2uzY8LRxF5Yxx/86lQCTHZbCJApX+uBUa8S517nmgrQ+bUKnkyl789U0Ib1HC4qnJoxsDb3OdRIqubFkcPDfH6aK0HLRjP6G/BeIk9T34jxukKDcP2Ff0ovcwvNqDCZi/EZP1jk9KZf7aaguDl9S2+7esnnQlnqnzBYoNV2WS2FRWHWuCqsts3C9kAUBDAo03HDPFjHzhtMW4Tc4O6VOo3R+61CyUqnzWOQe/Jx6PQdlet+iPxFnywt28QmHisVH/2diZc3ZtAyc/VNx9REWN/zZ0KJyNL1FgbrmMVejK3fI+bO9wYRIvbUK0NkQGQ1uywDNprgXFwelcX/Q6pKN11Dw6yEDXNJVx4P79ceoWSG/9pY/DGuenqEGNfhk1X5EaYl9c1pZ7W7KkcVvwbQibds85Yzbik9w3N8yLI+xoAnxRRW7Xg+WZ0XESjU1bhrFK1usxQw5L7gmerXCrHYZtUs1E+NRVtjAcyVfreDjLDmkagPcdq5IyQx/L6VVok0kIJQLh96qaR51+sj1XMevjYd2pV796vfuS1tVesrDeCxfEuVA5BbIldhhRDtvhTY+PCJx6IT65UNnj//TX9szkXNcmcf44Q7wx7dtpPjHkuHU4IOQkD9seD7P16C3ZvNswNbmPSJDR2EmAijZrQuwSbb/HTKuL9ZqIztHtaowM9Yv11/olfw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(5400799012)(40470700004)(46966006)(36840700001)(70206006)(70586007)(8676002)(4326008)(478600001)(5660300002)(82740400003)(86362001)(6666004)(316002)(26005)(7696005)(41300700001)(8936002)(186003)(1076003)(110136005)(54906003)(6286002)(40460700003)(2616005)(2906002)(16526019)(36756003)(426003)(336012)(47076005)(55016003)(356005)(7636003)(40480700001)(83380400001)(34070700002)(82310400005)(36860700001)(12100799015);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:57:46.3549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c0e10d-a7bc-4c0b-968e-08db14809378
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6007
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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

