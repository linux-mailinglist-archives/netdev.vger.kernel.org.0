Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69F06AB4DE
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 04:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCFDEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 22:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCFDEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 22:04:09 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743F09035;
        Sun,  5 Mar 2023 19:03:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JufbEIp/V2gAiTqctqaKH7UTmRL1GVlKHdZafsuQ/2BR1/ZFAi7MVK1rnD1Dz0wtHYjgGja3oaEVpmXOOzrCWqvK9/dqcw/FAvKzArQf4dHdH5NelPm8N1bpQM9jEVIeS5O3utlIp6gERYT6DZ5D142FCNg4wZV8whwM0N8W/ETFDQzeTyWqux5BHMV2aRaALRR0iBHJL/D52ET8Uw5ycaCgamGNBhvKqg2DY8oIIhywz61eQD/7BouTlYn9zUZX7hlhNVeX372RuEz64mIYT4apeP5Y7327+CpQFE74qUwbIbCy1NKdBNSgm7TjEP4rUZ+CHwLp7WTVUtJb5rxFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=EKkSDCHTYwRchVQDJ8W0oUpVlA24GcP4SLDWDwbBwIEgs6U0nE2AJof7/jc61J2h4kKVDARwfG7PrS6PPKsSk1WXHky2GKc0makbIxytLvNkxJJvFyGA7R/Xd48WLCd2z5b5TrK4XHf9gfd0jmckoFWwRVfh3p03TrP4J06GOWawWrxto9ABrYl8ubsqgbRssJP3oiQXZ7ctlVHxLtshvxCwteCcE+MdhZ1dBuSsa5C6/8ON2z/bzPpZikIn8iNtjheDOIqw6ljGFNs0mepgDULoCHFu1wy8abgfw0PEOHNcuozZDQV7ElqIDxr0+mglxnpj9x0SZBDzYlELrhq6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=MV415suvDSlV5+eDGX14Uv2DBmzpTAwXNGlkw32i32RBMqDMVfTdQ2jh2Pw1otPMP7PQf1CYuXSnzjdWF9XeI2/W5oifDHLWiRYqkNxcb4laK/xFt0LV9X2ZIytBUMKh0ImE8Sa4qCk1tFyQvGO6KXWamJrGGYJBgc3SQhMemIBy7Nzdj8SyBkHDx48W7I/hYpyZyKnbYoGQlk3EHjWRb/ZiQC05hYt/4jFqlbIvV8ZwtfOFUuV1mmIra20bpVq8xbXiFs8YVpAkNhblDnSFX82pXlcSM9TSMxwrXH7S2niULhuqQvdew0mAUtGx+wCteXwf8or3XHLPMU1X2jOAAg==
Received: from DM5PR07CA0084.namprd07.prod.outlook.com (2603:10b6:4:ad::49) by
 IA1PR12MB8080.namprd12.prod.outlook.com (2603:10b6:208:3fd::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.23; Mon, 6 Mar 2023 03:03:52 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::e) by DM5PR07CA0084.outlook.office365.com
 (2603:10b6:4:ad::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 03:03:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 03:03:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 5 Mar 2023
 19:03:42 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 5 Mar 2023
 19:03:38 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH RESEND net-next v4 1/4] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Mon, 6 Mar 2023 05:02:59 +0200
Message-ID: <20230306030302.224414-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306030302.224414-1-gavinl@nvidia.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT034:EE_|IA1PR12MB8080:EE_
X-MS-Office365-Filtering-Correlation-Id: 99fe44c5-32f5-48c8-4a59-08db1def6a2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6Ngr1l56NPrSxE7kHvTpyCXWPJ4tCNhQMHjbMBeaqY09wpgq//xR7TWejcQqEwhrlBVxOuSFwdFd2/AqlJHVQAoIrr67TuY2WaYci2aZDx5NdFWsnnR0Gs45gemSnTH/kVojyxuzXNEbE7MehfxthUUQDRtKEChS9EXFlD+tAtKMvnbQ8BbvoBROPUKLj04R3L0A7f8Zj0QIb890Kk/B9QWBCChdW9b8hTu3twG1v3qKNorvMMEM8TLswn9MWHXlXiSIWp+XmE2dX4RiYlSWI6VGAxXLCdn4zu5teJnZnGmLOkWTormiiXZKdl4sS2E5hyS+ASzYVBVkQ/BJ3oytidJCPfE+5cQtNVLuYMkJw78aki450Ybx9AEC2CDd5VOQFd1ERsUb9IrupIi09fNbjZhvvTWuJFKz0X5cocbBm3wjg3MeLHCEOMpzjGQsCbPlANn2oGgVUY4ptZ8xsw8R4FOYsi1kZikHJyQdZWpJIEt7XgebBA4J/DzCMomBIGRWJ+PNd31Ol704WZBZW/t3F8AgfSsng4/a4C8b8Fx4qAbOe6FOveQE3MaYrLJhw9QELO0RVuVOz44QIlcinLi2/9GWG6nsJ9uYs1E3hHMmiloZfHbd6ELWie7KWp6RZxpDYPKuhKHEc/k+oNtWxgqCG2pI5/ldmq59sOacWRt9quk10SZjdAJwoq3LldXrIIN5HAevpg4ndfRT5R8KqnBuw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(6666004)(36756003)(82310400005)(47076005)(83380400001)(426003)(36860700001)(478600001)(7696005)(1076003)(6286002)(336012)(186003)(26005)(16526019)(70586007)(8936002)(2906002)(41300700001)(40480700001)(70206006)(4326008)(8676002)(5660300002)(2616005)(40460700003)(86362001)(110136005)(82740400003)(54906003)(356005)(55016003)(316002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 03:03:51.7196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fe44c5-32f5-48c8-4a59-08db1def6a2a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8080
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

