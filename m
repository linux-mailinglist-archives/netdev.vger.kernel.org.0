Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9BE6CD947
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjC2MVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjC2MVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:21:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F430FF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:21:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jxq/Oap+k28i1TReeDl85HWU5LvZQmIRBn9RoWXC7BSUdX7TpK1m7fXZHUCzcSy4DXuDObWlTjZEQaqs2kFFJyJry1Lv3nUUTaUPUjBvEevwWC4oTwG7cOgcIZZwDuzqhZSOObo+7j8FEwHGcwlqhpXtPCDIHdQ1b9tMhtTX8slRUBOMBx36Zdi2GyRR3P2HGdEHpuD6okU1RouPTfxYGMMjnd3VcfOakCrIoiQTweB39Z/vFZ9Pxu9XXAdmowsCoh4hCen1E5PW9vRG9UtydeZhqT0kjcZhTVMB3HRJqdanf8VGHsE/cS6mj7dmimzKw3NDB34GRa3Y8pwqViJXeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+c5205Kl3p4r4usYT/Bl6lsXRQMr6ktIsFmFZrZ5oU=;
 b=Od8K2bKBBI6Aw/K6PIMaIXJpg+yWi69J674N63UVnWv0IMkVRVks6z6N0JeFnjWlqqITE9b9xwz0rW1Wj2AhUOPPCQZGXenAmlF43mzvUqvmWVNYxtuloSToGgj2Uo5S8rPNZa0Stja7Yw3qnmzV2pQPrRxHz8OIgo0V3CU1mIyEYyWIn6Qs52h6zKoB6jTkFr9gc/nVfc03UkglNNlssa0TO2z8wlHCZwv4yP/Pji5FN+W4VHX1hB4t3F/NS9b1hub552nFDvXYmSzDGMg30VG2/Ejmj2Cu/NMr5ssbEvkifehMObROT5O8ncGj9qqvl9l78xK0RTqX8CGNJnLfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+c5205Kl3p4r4usYT/Bl6lsXRQMr6ktIsFmFZrZ5oU=;
 b=JPj7/kL8hZfqF30c1pPzWYN8SlttbWMTcePsrCaCTpApEqsa6ZO/ydIeY3SeoW23aDAbnirS7+PRs7BDDdw9LqKYqDvcmmf6u/yhXfr4RHeOy1txWGmUu3OLPB/g99juPrBL8oKunCVmITTkaGu/9cbjnU7viviAdtpMKmoESYp21aBODVHUwy2tF0MfRw3ugY8hs8Z0uDGKpQ2vzwHHLM7SbcryISIr900mkvhRgriq7E14p+iZlNQHAmv+ppdzlFldv3FPI7/MIivWCIU+AOHp6F6i/jiF9/XJ6B8HnmPAE5BtqLIdBxHuZOria3e/OuiYuZO6wxbvw9HQkw8MxA==
Received: from DS7PR06CA0022.namprd06.prod.outlook.com (2603:10b6:8:2a::10) by
 BY5PR12MB4902.namprd12.prod.outlook.com (2603:10b6:a03:1dd::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Wed, 29 Mar 2023 12:21:30 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::b) by DS7PR06CA0022.outlook.office365.com
 (2603:10b6:8:2a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 29 Mar 2023 12:21:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 12:21:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 05:21:22 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 29 Mar 2023 05:21:21 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Wed, 29 Mar
 2023 05:21:20 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 3/4] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Wed, 29 Mar 2023 15:21:06 +0300
Message-ID: <20230329122107.22658-4-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230329122107.22658-1-ehakim@nvidia.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|BY5PR12MB4902:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d9fd092-d521-4505-fbf2-08db3050206c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oUfZ3HiordjvEVH3JwUq/z1tqN+kWv1BB3Ii5kVfCgnacb3QgEA4NzcByuKvyn5kKwTqnT2c/0RACPD/kB0boasDu+dRdqBpN7uQIsaOKrrInjTBzTcYQ4lZ+08Linol6+OxCbFZ1F4OVudY4XswbIRUcU0PPLexbnxY5+suClH88qnGsO/Pya4L2QT4zv1O1vtOjwUURL3Gm+ceNVcDh9b505wz7r8FyVK0crqdm1TJT3CE6m0LPPK88angm/Ml0/E3obEk0yZ1Bgk/Gu9zu/Lmt6wHb2q8srJ0EdnC7WXdiJndPX+zoGs81ITDZcXtIaALGuZewAGJX/ncP/BjDjMDG2vE1EK7BxgB3Tl/fmm5H7OC2uBFE9fF5r466/Dgh8r1hs7sBTS1s7YLpyiibHdbNK+dE9GIAxMge234kYZn/FDumsBcrxXyXcIVIHUJUwLj9yQ0gqQF8vkkTXGiDthfefWHdZQEktZ9GtsrU3V35xlZtBtQOjzwJX/4eFReWAgOLiQ5VDBwYysmg16LYSpYDF5jnfwhbEhpPLUZqwPD1/2AtrOr1NTZMOqxIh7iskyfyjjokRyZLztoVXATNVQlqGj3LPYSxHMoyYKOn1Q5qFdWyITNFPCFT5nVwnPDW/qVKK9NvkoYujOqBWurXNyD7TmOz3wkUpyUN+4jytkv3F7Ux9tgiM2lVhiw0F18gT9RobD6kmsYf25r5L3tUU9kiNsE7MPD5DbuarbvKz61Y6ChpME+UDpOcVcXmVXy
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(46966006)(36840700001)(6666004)(107886003)(7696005)(1076003)(26005)(478600001)(316002)(110136005)(54906003)(34020700004)(47076005)(36860700001)(186003)(426003)(70206006)(70586007)(336012)(8676002)(83380400001)(2616005)(4326008)(41300700001)(7636003)(356005)(5660300002)(2906002)(82740400003)(8936002)(40480700001)(86362001)(36756003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:21:30.1024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9fd092-d521-4505-fbf2-08db3050206c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4902
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading MACsec when its configured over VLAN with current MACsec
TX steering rules will wrongly insert MACsec sec tag after inserting
the VLAN header leading to a ETHERNET | SECTAG | VLAN packet when
ETHERNET | VLAN | SECTAG is configured.

The above issue is due to adding the SECTAG by HW which is a later
stage compared to the VLAN header insertion stage.

Detect such a case and adjust TX steering rules to insert the
SECTAG in the correct place by using reformat_param_0 field in
the packet reformat to indicate the offset of SECTAG from end of
the MAC header to account for VLANs in granularity of 4Bytes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c   | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 5b658a5588c6..daaaaf344f77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -4,6 +4,7 @@
 #include <net/macsec.h>
 #include <linux/netdevice.h>
 #include <linux/mlx5/qp.h>
+#include <linux/if_vlan.h>
 #include "fs_core.h"
 #include "en/fs.h"
 #include "en_accel/macsec_fs.h"
@@ -510,6 +511,8 @@ static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+#define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
+
 static union mlx5e_macsec_rule *
 macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		      const struct macsec_context *macsec_ctx,
@@ -555,6 +558,10 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	reformat_params.type = MLX5_REFORMAT_TYPE_ADD_MACSEC;
 	reformat_params.size = reformat_size;
 	reformat_params.data = reformatbf;
+
+	if (is_vlan_dev(macsec_ctx->netdev))
+		reformat_params.param_0 = MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES;
+
 	flow_act.pkt_reformat = mlx5_packet_reformat_alloc(macsec_fs->mdev,
 							   &reformat_params,
 							   MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
-- 
2.21.3

