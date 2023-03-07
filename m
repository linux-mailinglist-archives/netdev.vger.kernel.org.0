Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521206ADAD8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjCGJrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCGJrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:47:33 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38F95616C;
        Tue,  7 Mar 2023 01:47:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlyLGutR3gAAaHrQUzWUoztcZwfVijp8v+cYyc1GZrso8GObH24v/uoRlxzP3e5+oytIfbPjC+I3KztgS+x1RYat4k2TvskPaYUrbV5xKf5HagY4wJd99qLw8GO1EX98TT10T7unjiM9EZJfGwrJYd4sGEliGMbTc4vaM/oThuAUZXUWKaptabob+0tUMlKxd6/A6mTnJq7S8RahGTM+h78nB8+sHRZLBklotNf74gHxFErd/VezgRbLGYA3WfIoANOu465wnnStOHTYNve2hMXKStC+j/Mdkk+f8/0QerYamf8Ea0IiVn+fO4UZqkWnHlkwV4Rd728DzjP7VzuSRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9+KU7YTv70LcPI9sTqYHjSPOzTytRYs0gJXbtLQBCw=;
 b=iYmk/v7CX6jrCawdk1cVXbP5vs3X/e4YJxL2miM7w0ZHwT5qoH+Gytiz1EssadI8mP1ATMvM2N5KrjKMg9g/eDHeE1OIRySWWYc2UoO78STWLCy/F454y9rLcMz6s7TZiAHnkPx3luumudUJz1WMPnq3rf/RSARAdsCN9ZwYii0BrGKSGHY4b0nH12J0gK86OlpueIGNENMt+lw7tqIdVAq2B1lCWnKGrKtkAEPP4luRdkWaZkje+q7AEWXMFu/ZS0Yho6GLCBKqv69FYYZWhCqFxewNit5iejiOLWID46SZpZku2fYUgTPjgE8Qm0nZyigs3ShTof5ttcs7EAOCGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9+KU7YTv70LcPI9sTqYHjSPOzTytRYs0gJXbtLQBCw=;
 b=OS2I7PLM7qkKybRdsx8PLyOvfEIcJO0L3lzaJ9nE+YiF4jc3gtYhMqzgUiuODGGaoGyzeTby9CU6d2gyt3+kQe2Nbn9NXkQwMmz8MuMDcx9QAz+07NvrXCfmTYsKJf9vfiQi9uJM61xUeoRqDOSd1g7QewyQ7Lu4r4WJ2Sme0AibykvIp+Wo8HVTuW4U14JXjqnCXnooPmjzD72H/M0oAWdLHyaAomFhe6yoe3eCMTiZ5JBxPkNnGyd9iOiABM2PWPuIHLVC/sZw8t+WMs2cxTdXxj7SkWw5q1V7rgVZOaC3b+fj+4OEl1t9IP5lUFyrkHy99e/me2bFzI0msURX8g==
Received: from BN9PR03CA0298.namprd03.prod.outlook.com (2603:10b6:408:f5::33)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 09:47:13 +0000
Received: from BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::2a) by BN9PR03CA0298.outlook.office365.com
 (2603:10b6:408:f5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 09:47:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT088.mail.protection.outlook.com (10.13.177.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 09:47:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 7 Mar 2023
 01:47:08 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 7 Mar 2023
 01:47:05 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v5 2/4] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Tue, 7 Mar 2023 11:46:35 +0200
Message-ID: <20230307094637.246993-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307094637.246993-1-gavinl@nvidia.com>
References: <20230307094637.246993-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT088:EE_|DM6PR12MB4499:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b3b545f-0576-47af-3ec6-08db1ef0eda5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVH1GWLBFBV40WjGU0J2Ty7CCpAIpusatoPHlRO5B8EWDmQihO/aL2WsU/MqunBEPhB/KHUWIIU8AARoejQx6yVZzHXO1IgP2IxPKioTKWTJhg2Ny7wwOjfZGqAMWl7TGuSLvIkDD3bhGhW3WN5qU9wtXzclBqSLR0KZ5QeQvM1jZijDhAyPV3SA4cPfblI1VF+81J2rElXfV4ginFf3/q+6zQIgVpp2DLZN0aAIlw9JGM26fUBMijgOwnuoUfrZ/FokmVwJpEihLNvMGjsJ2kEeRi8JxFK5Ui0KaTzTf2Z8JdV5Zcxv9Bl0/XTrOV3wCCppQBwAwhjTXTsDy7XZ6IqlpgMPw2qIJooxrAVAiJxAaXj8SzA09SoaRRA8qbgkDJtaIvViAsi9jRKEH8kOQsP9ecsiWc7hVnXrtUbcXMBP2P0jB3tcuvQmel4XRkqKlUq/NxpG+lHX7o1m6882ct7KO/HzNm2+w+ODecs8C4c30+N28nXaN3wx4C2xAZXW2eXh971CH0m2KJA+Q15Ucm94fjF+Jo5Tv6JrshoBy2YgIcZX+yS7epAeUM19vLHygBKVD/9uAph/Kvlajwz7WZ3E8uw8zIKD2CQX4Vhg/lIB97Cjc463hVtXsjmQbVtC2sffRmJ7y6GoK0rCUVUPtjqtH3+Bv/oH10UrNSM/NbQGF9OF38NR/oDsRkD5bfIoORYtE6dvARzjLNjXkjm7Wg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(7636003)(356005)(36860700001)(86362001)(36756003)(2906002)(82740400003)(5660300002)(4326008)(8676002)(41300700001)(70586007)(70206006)(8936002)(40480700001)(82310400005)(40460700003)(336012)(186003)(26005)(16526019)(6286002)(83380400001)(426003)(2616005)(47076005)(55016003)(316002)(478600001)(1076003)(7696005)(54906003)(110136005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 09:47:12.9040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b3b545f-0576-47af-3ec6-08db1ef0eda5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4499
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

