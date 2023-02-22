Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9AD69ED1F
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjBVC5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjBVC5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:57:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10hn2230.outbound.protection.outlook.com [52.100.155.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD930F1;
        Tue, 21 Feb 2023 18:57:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fi4yF9nnLy566kzz7PyByNosJhcSx8z0qpY/Jk/+/5RkAmtcqpMevROYvxnGM4iw/p+WkkeYwpY1331xP12lF9tirqh4qVR6Rgqlv6MGZ7Ic4xWnWQYI3mLlSAE6zr3rQ9MZaQT4tur9nfeHwuJGZKMT1mZ27FzjHdJQ/n806U5aJKrAZMBLUbjYnFAsvkAdtHX2/fogN59cFy3FAqf7UG2JQajINpYzowox7wKYLR6dCJL5EbMOm4SjX9qVY/wCQtfmHahdwwFTYWPONc/8Hb8DTqNKg1PqRd8ztWZgVsVyZeU7eWur2xBZQzCrzJjcmHrYZs0k+/62PGH/PPrOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=LI81qJdOim5xrCRJ8oa6gFGyO1ef0JaqvcY0aMj63g8gxRshVlEAmHa4abKkIP8L9ncU0PsikT/lVaT9BfTgMfZC7+hGMH3mcgDaG5/5ssXkRpbBLCaIki7iGsb6duWHCM7FfyqNk2SCqnZlGCkqHRkQ+zMKc4SQaXYL5zP9zL3eXA1VOot/5H1ViGvJK90Omek22TPMvKQQ4qEMppMnJVOKFu5aPm25rJGdl0JPgPc++S75FHtvRADe4Mz5qsPxjnuzsXbl0EouWjvuHWHRyu3oHwc7nTFNTlVqMH2NPZGN/nX1BoRXjIJj8XZbsf8AD7+8HLdAy66T/xCkDdrkqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=fXphH2MJ1mdvUbpjZVwd9kn95t89rxvpU3xOOeG0Bv66/YvpGrYywwUHQkfsxd4GpR2+GsTPddjdm2iizkklIJ/uGoyA1msZV6nnswNXDX2JHaDcCCUdPcx3ybKLWyGEEYsljeLHBtglFS2cihXymwCVSLCUe6XNVSX2/yOZt6MDIxILVnEwXiJVQ4cAIZGg7/vdiKx4oWnqfocGpVvAN/MaJIkuSpiquinTgdNSgd5HP+UAx8qkZmO4EsZICvWcnFB9w4CZr1PG0NQ6mQAWLWPwGVl4keioZXaA0NB/LacP7YEFSn57+CAOS396BOaRVVMroeVEe+Gt16r2aT29xQ==
Received: from BN9PR03CA0623.namprd03.prod.outlook.com (2603:10b6:408:106::28)
 by CH0PR12MB5140.namprd12.prod.outlook.com (2603:10b6:610:bf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 02:57:43 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::2) by BN9PR03CA0623.outlook.office365.com
 (2603:10b6:408:106::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21 via Frontend
 Transport; Wed, 22 Feb 2023 02:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.17 via Frontend Transport; Wed, 22 Feb 2023 02:57:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:25 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:21 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 1/4] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Wed, 22 Feb 2023 04:56:50 +0200
Message-ID: <20230222025653.20425-2-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|CH0PR12MB5140:EE_
X-MS-Office365-Filtering-Correlation-Id: c07ded3c-bb1a-41a2-e919-08db14809183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTqTX6S19wBnScVnn+QAaFP38zwU5lnByujZx7D7d6iSheKzVBKUUB5GZzMQCW+ZWZTpLhXi5/JES1s509zcAVIrhtnbZYg76t+p2E8glgL66x/Odckx/IxxhuttSdTlddrBrMMFkHggw6zMfwvHVgKTgN0uSbWIKkpq5OmlJMTTB0Bw0LOBoSBWNpWvKSGX+ev4jakbJoAYn3zP9sVY+XTubjHIMs5/CtCLIfBa37gicO8HahTQXaLAi/KRg2pthGyxY4Avx4tCAOPKvIo2aI0Imn9IYhmTchXE1G+KUsYdOYTjuRgsH/RrY8lWy078/HJp9BSeAtbvW9cKY04UZiUMjqxDJYmo/KAG17gzBkpTJINdKFO07e6rrVciSfuj31inycrdOabZkxXblpWClZHVdxXMOeeShCoak4+eJRiAOdkytcqvo8xNaFf0GDniZ96Qi4igAURxTfPDHG3eOJaE0w+IK607wHUW+9jT9OtCzVYLdweaj/GaznCpqW8uWogSrBx62PT8nvnErCfHyDivSeO16AE5NU+d9Qjc941KJOL2FGa/TOm3rCQ49YvGJtUCo+Z1QvnJ9lQp6/bJtrMCEvC3jTOF0LqExhucEE8pCSRdJDWNDVvK6YVw4VYRYwliGMtZu0QxmaFutgx8IW+xEbAJl16d55SixEgkqQamkOkW6TdpvjJavqT2uKJOSCS0LyeNLPCIYVpNmEky7Zn6+drjicFvtkdYou5y995TeP5PtLo/9GJl8yo58nKT617+x+wvaGffN4Rv8RxANQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(39860400002)(136003)(5400799012)(451199018)(40470700004)(46966006)(36840700001)(7636003)(36860700001)(2906002)(82740400003)(8936002)(34070700002)(5660300002)(26005)(54906003)(6286002)(16526019)(82310400005)(83380400001)(41300700001)(47076005)(186003)(2616005)(8676002)(36756003)(356005)(426003)(4326008)(70206006)(70586007)(86362001)(6666004)(478600001)(7696005)(40460700003)(316002)(1076003)(40480700001)(336012)(55016003)(110136005)(12100799015);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:57:43.0736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c07ded3c-bb1a-41a2-e919-08db14809183
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5140
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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

