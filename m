Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECBD6B25CC
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjCINsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCINsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:15 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63906186;
        Thu,  9 Mar 2023 05:48:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC8dXWSX2ItWOZ6hskwhiQAFsBperp2WmlDZcqRJoLg09ywixQP4fhPqG/nBw9mIv8vNHXIyZhnDxJtETT2Eqh0rPUUNDpkNKz0Hr5Nyl+GNkMuWC1xF22xYIS3Ab1aXGIi+qYbSBcPhTswYRZdNnvwEwPaB7hKhfv6CEb3kONsyfqDbd3HKDw2nhAcCoxn7sXVHntHSap4IAv/cUgkx6tRptds1K0BneGusZMPq2M4InTJQ/XP1cYCPTo2mOxRXe6uL8uL6lVq0EPd8ZGkNxo82Th5zCSeQeArFF4HreZgXq99YsNVNlytgjI0g75P+0WfSTAbTQvpsviQRNb7Vug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=bSbm5z6vA9hf6Xfa0ZpNkZGXUJiXybT8l4mdWXK765QPpXxu31iGgwtfR2AGSCtGV9wqxYGg8eBvUadXW2uyHNI7CHGqnvi44+pVfno/p6zN8N5VaJjuvzbUmel7PWSZrvAVgmBIpWMh+PIuyRd4fKJfQLCHsBK3VGXfSofEEBjf7B0WMr98sMIEZh+EbC+NSoKII7jxt+c8TXSBfdTiZzELIXwBGeQmEX6yEFiJtmZZf0wuX+KJ1UhHgkDMvPTNq9MBjJ3F1abpVQvuIDPkPm2+BQo4Xg2zCpbPn0PWUrBfU3bHgpwRRnHI/fW+4wYFM9TzRFJ6cllW978OtBAq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=pk0mQ8kju3pEUmGFkrTITzGKjTK/QlwRZDPL0UTcMMP7wkI288X9FjXryfOQXbUmGEhkBLb7mY13emKwFiRMeybMOIUz5sZVPxDaPhtTtHwYYk3SZSdLDtEHYuyI8YA1FitogAuKLvKrbiD+FSS48rlJ2Tvq7xpqh+b1/6JXFLL1hQL8PmVOKM0em1ruILc8rA+rgFv8H6NqLyFOkT5VTpkpRm4LOoTzVbtVIk3ZVKazNJT1HT5oTYHQhU6ZEtu673/PRaDOAH8EkMok9bczZDK2GLAFnz9KyFud9kPNfOZbvOg2EXlgB7N6t8EN0F043547SXZy4EiKAsqlXeMeHg==
Received: from DS7PR03CA0282.namprd03.prod.outlook.com (2603:10b6:5:3ad::17)
 by MN2PR12MB4343.namprd12.prod.outlook.com (2603:10b6:208:26f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 13:48:11 +0000
Received: from DS1PEPF0000E645.namprd02.prod.outlook.com
 (2603:10b6:5:3ad:cafe::9f) by DS7PR03CA0282.outlook.office365.com
 (2603:10b6:5:3ad::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 13:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E645.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Thu, 9 Mar 2023 13:48:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 05:48:03 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 05:47:59 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v6 1/5] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Thu, 9 Mar 2023 15:47:14 +0200
Message-ID: <20230309134718.306570-2-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E645:EE_|MN2PR12MB4343:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d7d830-3c9d-49ce-a806-08db20a4ec53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TZL+ByCJp4LcSwuU1oEf7T6HBhriMCzzo1q7r/tLo4j7+I63LlxJLIPml49duU2TOv6auJ8obDOhBQbSXUlNbbQkGbK9RCUv3O6WagU/8zzU4VElulGrUJa2IQO2mCYxm97E0V76bdasgqbKi8mLHHXPozhXpXRFamE+3BiBFM+I5s91UelRcbFhGtlQokpFjsW+yRJ6MjrbPcXYifiptmVVmQB4mtSW3Q9q4HSTxA/cHjINP5K8+qzCeyWiwxdU0uxSMU1RpCnS3cuouL3aBE3m5+okFP8qrVp0RuO5uCKQlWwT040Fbd4yGOnUrxGNjjpXy4lwQz8vusdPqNxSVJ+I82mxVRCPLTt0Gx6ljUoAZPm9rzCUEG4xnLK2hie25OV/AUWs6m+OuiNcA2zMJ6D/VM745F9nNkNkpKN3bhJrUPKnMuVAPd8vYEZQ67Qu/uT49jK1Hl+9nAs3SeZLlDg8vbfSKvzG+1y6Tvm0Xd/xKxShinzndHvSILzOWaQgUJR40AYGD4X6dfRwD88gUy0svJZrtwQTsEOjDmSI8itYoTQ/0ftDFzT3xCoKl2mZcbQvy0kKNKrP8MFd7xQjRK4+94USpHQP55EeqJN5sISeXDn7lV9IFNkORLVN7HB+Rw7Ezf2MHHmfvil3By5thVgOBEd2vLhq5Gtd/wn/qCd+yiv/XmIuR4SghRXnpnDgUHO6Nu21P48/md+HCke5qB4eiZ2R0zxFEGY5iOi36Bm2tKAS/t02AtFCnc0/gn0s
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(336012)(47076005)(426003)(110136005)(54906003)(40460700003)(36756003)(55016003)(186003)(40480700001)(356005)(86362001)(7636003)(82740400003)(36860700001)(1076003)(26005)(82310400005)(83380400001)(6666004)(16526019)(6286002)(2616005)(7696005)(5660300002)(316002)(478600001)(4326008)(41300700001)(2906002)(8936002)(8676002)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:48:11.3125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d7d830-3c9d-49ce-a806-08db20a4ec53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E645.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4343
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

