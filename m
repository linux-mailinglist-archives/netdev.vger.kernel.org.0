Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8796AB4E1
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 04:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCFDE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 22:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCFDEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 22:04:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07AA9034;
        Sun,  5 Mar 2023 19:03:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBCz6MeSEAyxvd3YhYwM9y2JIfj7VZK/EY1+IE8eTMG4e6leiyvGM68mxRTin0tedr9449lTPoDKcFByFYBsMxJQV4kLMskVWEnd2wDrTL4APPxUTuGxyeRNXIKf3IWoy1iNdgONeOQvs9FB2ZK09+aqXK/d0xJGSN6HZ6Qyh8W2hFmtNtJEFr6LWgqqc+Z4xL8I9JDy7cznqmfmZBw5LTAG+MzgHohrmPS0zljb8QEvTpbP2nZ3/LUZY7Fq/iizOK6wDcLKlmRsyoByG4Gc3imWE3s4qGXe85c56grvSa84nI03WmMGvACJTR/r0d+oK+EDAS3luiUnFJ9IeW8EvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6jhJVBD9VDkGSbFbfkRjF65IBJnh1t3/5wWG0GoYnw=;
 b=gAu8NpPXYdFO/wn5WwQ8xKDE8BrFX73ndDe61KFi0B40xnVsTkvls0gn6BR/XLnMsPu9olNa7KUY95y5Q3zBJsF7d78tNpoVmw4CnCGmgDms73DujSEtRkqviZIJ333ofxPfWO+UykSvj0ALr7vZ1Nzpx4kX/KkZ3oT5rsrdAiJHUeWZqicSoShmNwf5GB1jBMyv0ClxYNZFE8NShv85L60IlAOeuM01G7dEYPd/4qnDQOz7g9COS9KDz+N+171XPR3HvM8gJzEUmkMzmPif/GS1Q1Q6zzSUEVK+N7PuIAu7OLvNEcPnuVIvPomApCuZcHxNjVwpRM7l2LZkYoLHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6jhJVBD9VDkGSbFbfkRjF65IBJnh1t3/5wWG0GoYnw=;
 b=tEOPlrjI5TNYK7cWSXCXSD9kvq0rpbMCV56X/S+TfYhgKoLwQhfnEPl3IjaV0vFtbnbiFWO6b0Wnyhj0+4TTlFcZvtpees7wVw5PiYii3KAL+4TCLVsj9AFTJGXkQ+pvY3O4O0qeb8mW+cRYZfENIIfhx4IdD/WTYtCNR9N5gVn3dv2lbdhxN8b58X6KQRj7m8jAytgGi6zMhmfFFReJ2XPm/a61ihKtcbdPf6GhHPJiIrYfCqU/XRB6Rcy+ug/wVi3JiyjhxnX5LqCvVd7KPI1RQe9JHezCokxE8gJqi7jkia2YVHvNzKz+GA+l0d4G11B/0BQ6P4lPcseEGtIqzw==
Received: from DS7PR06CA0013.namprd06.prod.outlook.com (2603:10b6:8:2a::13) by
 CH0PR12MB8529.namprd12.prod.outlook.com (2603:10b6:610:18d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.27; Mon, 6 Mar 2023 03:03:56 +0000
Received: from DM6NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::53) by DS7PR06CA0013.outlook.office365.com
 (2603:10b6:8:2a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 03:03:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT110.mail.protection.outlook.com (10.13.173.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.14 via Frontend Transport; Mon, 6 Mar 2023 03:03:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 5 Mar 2023
 19:03:46 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 5 Mar 2023
 19:03:42 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH RESEND net-next v4 2/4] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Mon, 6 Mar 2023 05:03:00 +0200
Message-ID: <20230306030302.224414-3-gavinl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT110:EE_|CH0PR12MB8529:EE_
X-MS-Office365-Filtering-Correlation-Id: e52ac802-27d7-428c-61db-08db1def6cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CulGt8m4lWPhHpB+wCZoCJg4O2RLmk7f/5LtDlZzNKbklX6kLuf5p8P2lqoYMl1cDr0Dcciw+A58rKE+VZb7zWKwD8Om7ImxzqpkiU5RVIx9YpAfPbtCEsZuXIz7AE8wdrOUoaRBp/7J++u87vTBtmYEZNn6iD6zVmYyhXM1FTBlrFqRmcNWqaAXOScCahyV7eXC/yBAHqElgHCpwJnCHCVZaZ1qPppf6laLYMNs0fVaDhRSNdNCRcNIvOQ1cy8ihYcddLPhHFJni7N9vACAJ8injK0x/3UL2mhFB3Cskk5f3xBeQb/hUE2gju10f33pX70RhqdjB9yQaXn6VR2Hy3RCUpgvfS08OhtgjOtGbh00s37vtdw8vWEbcDayiOoOD1gXrFL5AEHMZzyZMEWLprljLP5qr5DVtVzlJK2F3t1XB9NCerZLcCNLvAeNe9jgnLRuuzme8iU7kQpi6xonSJQxHqzPnbOyjXgldDjy0/VG5BO1Y3X3xZYVYHnFVLjeO73f5kKBRY63Rq1K3s0DtPQKopIR9gol27hZRFA/MOXg6iMFResP6+anyIrWIUpEawm6PB7vEi372+cOnpPqNIaB6oPhW8clXAH6BbeGiVQYzRy1ddkoH/EY5SNwbOhrHHAOOQ2W2TaIQqltzxhoaZBPMaCwJ/dr2ihrdEnjwAiLx0Q12buFBAeQrCqsku6FH1cbmO28iwKmoZeJmB9AQw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(7636003)(5660300002)(336012)(2906002)(356005)(1076003)(26005)(6286002)(16526019)(186003)(82740400003)(2616005)(6666004)(86362001)(478600001)(4326008)(8676002)(70206006)(70586007)(40460700003)(36860700001)(426003)(36756003)(40480700001)(55016003)(41300700001)(47076005)(316002)(8936002)(7696005)(83380400001)(82310400005)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 03:03:55.9538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e52ac802-27d7-428c-61db-08db1def6cb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8529
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

