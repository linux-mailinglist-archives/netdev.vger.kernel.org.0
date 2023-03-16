Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A366BC685
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCPHJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCPHIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:08:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB84AA705;
        Thu, 16 Mar 2023 00:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vm4QQODugxP21veNxiJbI+Iv8a5kuObjwxh4J6Hr7xUVh1AzgcTyopi6245w5Y3+7srCB9RCaWxpINKtqGl/5iaI5fkzFmqM57GKkzPg2Jt7ntxt0E1bwDIyYmT35lg3OEMEph2qoQEiy9wZZfz6TvBaYA5W+ApfxddrIajS+NEdrRvT4uh9oE/4gi1enbSQKthFP2SA7YqlevJqsGxHO8EfxtFd/RvyPA0o1KZWcVe2m9ih0wEbUpjpF0ZdhoiPpMmM+b5xg5VLYH532FvBr6F/MUdeNdt9ugGGJTuxY6wCFKGnNh4yUAmcPaVVQt3PA8hNues4wdx3ilZqLzmtfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=867d9tqcipev6pp+cyH/8vIIszW3gb03//lacZcyfDA=;
 b=KOYP2iWdoHsPM1xU2b+K9mZXcSlY+RUbGq/eQtCk1akE1fi7FuqqncNlHIE2KHhrDUbppcQAUBbmY4YGJyTPPjuJbJ9IHk1SPPgM8TY81LtkvKA6/u+MkjlBFEJNAAciIEJdlbSRQr2h2bswVjAfVppwAqBuTbd+Cy+pmQqek5TOoQimL+qstVrFYrnKynP8K3ZZxOTjltmWVYINWMNyZGdMSqTx7jEjHJnaKN5Rc3Y1YhURsEFqbLvxo7JCeFVrz4I04fC3C1PuQEzAuJF7YBa2qGH87OBHL8LVqfxA8mm/0YWHLIaM5TZw5oQSHxFINDlYZp9Z1KxLp8+tvK9xPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=867d9tqcipev6pp+cyH/8vIIszW3gb03//lacZcyfDA=;
 b=eGCa7oJVik/g+yXW3d1OSNljyECqSoSXBUuOYqoJLG+b6vn/86y3akZ76c06eYThoCUtCvw3Xvass1PJ9GZsvDDOfVdNbSDfuqIa/kkVOZF6EjrSNHNUA+orMVfcNSL9ykHOkqvmQ4yvMG8Pd8HMm5mSb7PNwMVzDIL/qRqabogCM2BixDH0V5P0yivw82oD21jWXKO0nsCL8YWw3SpXqJ56+WzWuN342d/BvXP2hvawAEUlcAaH7AxDXEcGYxwsuXa4c3/tECmWhELmT1DdR5M/SGuvdLKerT2/AdXMmihbrIUI3O1qkBN7wIvBG4u3nG1tSpYD4XX82SsWykQ5VA==
Received: from CYZPR17CA0005.namprd17.prod.outlook.com (2603:10b6:930:8c::21)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 07:08:37 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:8c:cafe::69) by CYZPR17CA0005.outlook.office365.com
 (2603:10b6:930:8c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31 via Frontend
 Transport; Thu, 16 Mar 2023 07:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.7 via Frontend Transport; Thu, 16 Mar 2023 07:08:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 00:08:22 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 00:08:18 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v8 1/5] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Thu, 16 Mar 2023 09:07:54 +0200
Message-ID: <20230316070758.83512-2-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea84ea4-9a8b-4c2f-295a-08db25ed4392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Ua2Y069YwcHUtLEMBTdbWkmNw057QaCXwi21ReCNnSGPZn5VXECQf3bWLG+GvCATvxgU06fc+KUlh8ei6NyLokr0PlL34bWYEZpC8T1cGpGtIxM0xwIEfs8hbX/4x19MXPdEHvZ/hD2qysWjHB0clTwoNucb+602t3mqJT3+i7pGPRZL5vYtHPKfvRCUNG7Yy72FhUhztkUOhzSE9QSh7bg0TY7fjUoJY8cKLqMQ7PoJVWMWosfAW9d6V/KPoG8m3gczZcYLYnljJ8KqMiNlGI0ISKyGYGm2HlOk8pICxGAJX2oAplk/sSZHvXjwEvB2Dqy3NKMswfLg1UKpTXi63PW8BYXe92FSPzu+kntXNfQeFTwpwKAJtxpDKsws5FhzGwWWe6txilOBscV84eyD+/JT51JZ+QX6VI3+ZBqcc07I4/Cuar2vznZoOPd1yeXjtUX8viPfB3lCHs5KjVemjLDNy2Fscghx92pChFW/isAM2iveuWWPruswmmv1LQULufyJNgVhv8PFpR7D4vs3ged1l230HCXV+HxLkqUACmiVtoci0FLPhsQyEP3l2cj4M0AEGaYTdKzCVwle/ekIVt8GMohD4l+x2ZLZSyUaw9Q3VKljOIQrTnz85twUQlEsJ7ifPf1gOacPKFCEygv5KaYnmj/4W5v+Iss7vt0JMpjVw66Bc+d9ELBhZr/W7mIlZKp4F8fXXIQ/kWYBKorKW8E0tizWeV630gRDstSxsKgKd9YnFHBaPo70dtHyHJT
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(82740400003)(86362001)(36860700001)(356005)(7636003)(36756003)(2906002)(41300700001)(4326008)(8936002)(5660300002)(55016003)(40460700003)(82310400005)(40480700001)(186003)(16526019)(6286002)(2616005)(336012)(83380400001)(1076003)(47076005)(426003)(26005)(110136005)(316002)(54906003)(6666004)(478600001)(70206006)(7696005)(70586007)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 07:08:37.2780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea84ea4-9a8b-4c2f-295a-08db25ed4392
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874
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
index f2c30214cae8..d5e9e1ee033a 100644
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

