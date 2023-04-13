Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095556E0BEB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjDMK5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjDMK5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:57:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076085FFF
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpJEWpkKyNyaQ8o75H0WSFjaMHuuBpASeV0zE8fGAbCUibVC6H3k3N5vMtSTmGSxnKDPTN/Z5IdVD0VMG0glhad+7vFByRle9VROPIDyxhutvWSXdPdfMyYRaDwkYtv7wOHsshJPhwZo8aluqLTOHYicGWIO/Xu+uV5TMQSBhlxbn1Py6POLUVM1b+e7xgPUlac2+LE729R1GwyEAHBR3oAbcY5TBFzeL4+ryiiTL0PRCTC+zHcRw2JrU2pdnskoJkDn0HKYpagaQ3qQOARjbqvBAUmBhwejnQBkRO3jM+wx+amY1gBFY3yXVw20cc5yFrWOJ6snG3Nrr6IrP7bIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=jMBLckV+lzZEjFKCeXIpHMA7Q3/y13AB0ez1//7ppR4KZ7S0NElr2hk8Si+s6uozteYNBOGKT4WA9Nca7efTCrVee1Ou6IaLbXTxKgPnyuUBI8f0UF7N5kwHBdCGAwjKTIa1oMuE8cYvUtEb0fFFb8VtuAqhhuxoprOYMpSpdI8pfBTWSktqgeFmnGPXqRYCzzRkiXL9EFRTqJ34pClFJYbJcVl+Hr6y1KjAs0iQTDT2dSraROyKEvQVM0PPh2s6Ds/GP1d7of/8LRNi8rm/l7cgZpe89zzEywRaP/C16KXtUwgoewrXKZP0WSdA3zWTQ/AdbJLqqUFXCb6vAdX7tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=BPRakz7h7BQModEMiqoKCqJTRAIbOOo7+48C/5o8X2OCWYI5NlS0vL6NpUBijKEKEPmUBewtw9uPq5LJNZWTIUGUBuJbN4Ky/r0nyi4wGUzGmH9k/kWBa9v0+L2lm6dDnwSebJQuP0txSnJiShD9moYL9a205wivKzoJRt1z1jseAQAFDCMqDEAGBKNrjGXw84moNzSM2fLbhj9YajMr60Y7JXGIy0i3hWuXkQAgczlK6k33n/ncZqKyXYuFKm8M05xgU4H+FTw68G4ZhcI+vwnruTF7iYRpftNMITz3uPJk4vl0d9ijhaHFf8kmzPIczgwxer9WhwAzT17hAFQjHg==
Received: from DM6PR08CA0042.namprd08.prod.outlook.com (2603:10b6:5:1e0::16)
 by PH7PR12MB5904.namprd12.prod.outlook.com (2603:10b6:510:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Thu, 13 Apr
 2023 10:56:55 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::37) by DM6PR08CA0042.outlook.office365.com
 (2603:10b6:5:1e0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.32 via Frontend
 Transport; Thu, 13 Apr 2023 10:56:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.31 via Frontend Transport; Thu, 13 Apr 2023 10:56:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 13 Apr 2023
 03:56:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 13 Apr
 2023 03:56:45 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 13 Apr
 2023 03:56:43 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v5 4/5] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Thu, 13 Apr 2023 13:56:21 +0300
Message-ID: <20230413105622.32697-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230413105622.32697-1-ehakim@nvidia.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT064:EE_|PH7PR12MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e9a66c1-43ea-4f8d-7411-08db3c0dcba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efm7GSHQfkWzJ7BixKLONQjML+kuHpJQZ4mWLSM3Smf9YMXVEhpfXDkaUMpibZXZ8SZZiIIolYukfsmdAzhdfQShyLwfkidoeSPFfR8NsZhP/XqBAylbPNSdzrD12s5vWdRuLxnrgPreqNXvOKADQ632aQSfW9rSMDJ0yHDro9suGc2mOkAgMSL6Ox5gZ9XMX26ZtMwtt8omLqBJcn2bB/FUhxjJWVdLh91bOOsoGaRUyWqGh/+KQMDEp5D70rLxVCyRYoUhvCVECEs7jbQ2sjqKRTbJftU+L6PCIK5enSO+TkXEksR2u45OwSQXBORepk5eFQ0/4/eXuuXUMKvqfxPeM3LYUUehjwM8S1kdW93yMVLmRPi8/hpNRCAs5fARv5aNCrg+2ukg6QyHYT1uCtNtA70waZqYtYJQsitTgzHeyDaVU9GlX4qcXVAgkKrBw00DmCqnRaD94COHZkYMu6LfOaGEA7CowaFFiVtRAh2Z2sl67kwI6oh4bhoxcUnaOKAhyZGE/QYcb+2tL0S1K/YGV+fgVkY11F08DPMnSHvCFhlUzOYrfPb/qwfc4Xehxgp3G+4Q8EffhtFUsVHW3dLB8szmwM6OmGs3iqQaXefmAVz+3DKt+Hyh8Dh33u8fjVgung1Z+WGL3OrT2rbqijOMEJZ1uAS6ELYwEB/kuUntST9Ak/NpxrkUUwRjglAkkcYNKxuc/Oo943yDfBlD0/nVG3zUlvdts/V9CLQ/T3ywQMABAS7EfLdNVsYZefcdPPcp/2Wde2RGq11y2z2/f0JF9LTjVPrEpiO/FBGciUs=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(478600001)(7696005)(6666004)(1076003)(40480700001)(83380400001)(36756003)(7636003)(356005)(47076005)(86362001)(82740400003)(36860700001)(2616005)(34020700004)(2906002)(336012)(26005)(110136005)(316002)(54906003)(5660300002)(186003)(107886003)(4326008)(8676002)(8936002)(41300700001)(40460700003)(82310400005)(70586007)(70206006)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:56:55.0575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9a66c1-43ea-4f8d-7411-08db3c0dcba6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5904
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 9173b67becef..7fc901a6ec5f 100644
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
@@ -508,6 +509,8 @@ static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+#define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
+
 static union mlx5e_macsec_rule *
 macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		      const struct macsec_context *macsec_ctx,
@@ -553,6 +556,10 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
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

