Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45B36B7069
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCMHwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCMHwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:52:03 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6762B53721;
        Mon, 13 Mar 2023 00:51:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxjR+RF2gbDlqvvi2JI6407bdRAAlQLg+j6eWyF4Gueit4XEEPLz6Vp5nqbV5HzBRQi1aDyE0dobPmQLRbpcUamREHbr5nEtb/nSbJRGCJLsxkbBYlpNXBbnFuKO1QM0paij1PZWywymLoqEyXuCE+9hurW7GmHUofuIJGZuBPlp/d8i4kS0hmkZMGU92qZHLLPoayS2x3g/CA6t+Z8Ev/oTlRPrM2o3M8Ke743nYfP2JYWKeQfxGsus3tgYL7SGtAWX4BQMx8/2u1bV+HSSyT0nqn3e65b2zMWGCNiX/RUsUXh1DfdPCTD/XgqIQzXYzk+hlHi2d3OApeoyIfjQ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=EQqu8cxVEOWxSviIM3lA7JcuafdzI8ii67iLKZZZ0rziNgmHYB0cO26HSiZ8D6f66UubErjQUaiqkoaM94i/8S7DRchDK4bnep0GYXrDxkXYI3qSooAwE0lgNBwNDjXAWr33cXzIrlhOOqluGR+4S7LGKotyUEWaVhUZGEeVUHN+zk175PqOxyRMlmukDLljh394hhOzJ9h9bE3e29CpfeV9wWUoq8lIKT2Wu2AM7UvLgsnKAprIF2VXTRRqrrC96I72D6gyRc0qTVl1KOMsR/o0pB5L8I7eXbpsqXy4i2X3IzClBhY/XycL6FpxTJamjaSAgQrRR7mNnpG9s6J3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=AIvFeXNZUoGnEBrXueewx+d5/2t7hJw6tvjtxs4VZmYSVEnzoiL2BrJ/hOgCocxGzs0gZ2TSFXdTkzOkM8VXGbe5t+xP3nOJiIQs0usQ5nLYXqikB9SegJrHNk9Jd8VunXfyXQ8ZF0xfbNCphVbJM6HFDNLWOTjoh28jaN0Eft0HJWF6Jd0VW00XA3f2/2U8osVqb+q564EFs2oJIqmzWTDXWcWaPJ0tPixNNTYlT6RpUCXXxQXT+/Gi4aI54gYrKFCyHRbWvqqb2pfURIIUE0/XusOsMsdH0WzbhhO7tHq1AxFcr0Dpao6Er3sD+DseoJYwKbYOeuLf6BDPZt4zew==
Received: from CY5PR19CA0091.namprd19.prod.outlook.com (2603:10b6:930:83::16)
 by LV2PR12MB5848.namprd12.prod.outlook.com (2603:10b6:408:173::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:51:42 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:83:cafe::f8) by CY5PR19CA0091.outlook.office365.com
 (2603:10b6:930:83::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 07:51:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Mon, 13 Mar 2023 07:51:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 00:51:35 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 13 Mar
 2023 00:51:32 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v7 1/5] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Mon, 13 Mar 2023 09:51:03 +0200
Message-ID: <20230313075107.376898-2-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|LV2PR12MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 8480dff1-489c-4f61-7cfb-08db2397c8b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XE8+7x7y/SznNGA1CdvoorEpy5DpZIDThCfYEV4K8XOPD03nKz2MS25cxVLckCEX61mfNlRF+enUg51WBmhbbVJ6sc+d4SAOSjDB1ht/ncazD5HJGTLnFnfm+pEyJRBkdAuNd9egF8zS35n/GJKIWhYlxXF1pUpgk1xP+4zfAbzJjr4NLo6qVIeU87L/TVAhk0TxvlU+edcdIiuUGTAmXkfVpjQwd9Y7zmzB7OMzHpKbvGtRR+Xi7MfC3PhseaaX8zbLzQci8YRHjvdRAqihuTDKF2y+zfNgF6hh1bM1YVtYxdanxaP207tCNLAJp23T4ohTrOzoHJpqlm1U2fBLpzHODiDOVhAF3+XEXkeuyHSLgvcN+EB8jkjI9RjY0dO5ngorQ7qLY7Ifwc/Gar88EhTFgNwySAmVQ1/tYLUpYdKnLj2Roe7DsxR8pPHsX96HnaZZWJ2zGxS7mvvHR8eEqF8CVnd/cWXDRTkZ+YYjpAQDaPNtNZW1Eqr4Bmx4yk54GlXyMI3l03Ou+Z/mmfARr3WbaeKpkM3G5k6RuJpToQB1BAcaaXUxMInIOjvGmxeLCfhUyhIjWNIHLJ19Lht1JCtsOKrh1vChX04SUw7ENPVipn3VOeOdiUubb5odQ2S67hoRDwIYae6gnVsqImDLgpOWGwO37/+cb/JT0+IIwV+CKPovNjpx0Ig878SiCUZcojSz+kLcuqqGp6Ce96eN/LIzwCNh0lIxShJuSZZ67+vt0dGYkMsNEK+Vpt+KKpqv
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(7636003)(83380400001)(36756003)(5660300002)(40460700003)(55016003)(40480700001)(8676002)(70206006)(41300700001)(8936002)(356005)(4326008)(16526019)(70586007)(36860700001)(82740400003)(54906003)(86362001)(316002)(110136005)(82310400005)(478600001)(186003)(47076005)(426003)(7696005)(336012)(6286002)(2616005)(26005)(6666004)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:51:41.6596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8480dff1-489c-4f61-7cfb-08db2397c8b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5848
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused argument (i.e. u32 vxflags) in vxlan_build_gbp_hdr( ) and
vxlan_build_gpe_hdr( ) function arguments.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/vxlan/vxlan_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..86967277ab97 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,8 +2140,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
-				struct vxlan_metadata *md)
+static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
 {
 	struct vxlanhdr_gbp *gbp;
 
@@ -2160,8 +2159,7 @@ static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
 	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
 }
 
-static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
-			       __be16 protocol)
+static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
 {
 	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
 
@@ -2224,9 +2222,9 @@ static int vxlan_build_skb(struct sk_buff *skb, struct dst_entry *dst,
 	}
 
 	if (vxflags & VXLAN_F_GBP)
-		vxlan_build_gbp_hdr(vxh, vxflags, md);
+		vxlan_build_gbp_hdr(vxh, md);
 	if (vxflags & VXLAN_F_GPE) {
-		err = vxlan_build_gpe_hdr(vxh, vxflags, skb->protocol);
+		err = vxlan_build_gpe_hdr(vxh, skb->protocol);
 		if (err < 0)
 			return err;
 		inner_protocol = skb->protocol;
-- 
2.31.1

