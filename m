Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF835B25E6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiIHSfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiIHSfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA5BA8333;
        Thu,  8 Sep 2022 11:35:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7Aht97i4XcgPicUOT8c0LesvGdUj4osdyzSvDv0MxqfFSwLhKrgxExBOpX0BCXoa03OgJ+WVUPIw5whXBbA5bDA3gIFIv4gDcrXRW7idoTRRiCzfdFSQrEWGsGRt2VGbIPUzTPNuRfjNYmKACBAfaQ+cOZa5JLphPC2CU+MxJ9gmilSUn1yD0rXyXDsL7TJIEyRUfP506PcdPXgthFTjD9JAKi9atNB960T83mJgcO4qTJYg0HSSGVdAXYbyLDdtiBfeaUX5CVo8iwbb2hmJju4adUHySKi7o7WJ4WYqo3OqNExmS9U4Sw91CEHn2aBinypxESfyIjpc4558+vCvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1y1weOeUhIVHMpPTvEEH+fwq7NIzTXdy+2EV+T7Hpc=;
 b=Ag8jG/QSygU5+rScjEm4MkfGGNUppMfMIn/N7VrNWvAQN6tc5ve8z5E5iDhohMRDgwF3sQQf9xCr7jQ8WH/KDISIC6xekBmrVzyJOnNT8WSUfd0NDlKJQbLLui9A9ESw+mSVMku2lpzt6qQJJ3TuVzyOTBv1tdH8gGGy7AMDusN1242vL48EIJ+085faYtBX2PqCg5hsZDhbMtqJH7tZv4HFqla4VxXjxtIQiXjn/8jaoZ8Ak1UtD9mFJMy9oO+VPedSwdqRzkmXsWnD/e+bh2j/yNyLywXpkqZ7TfMwBc1sPwlZAq4xU6eauyIvzy9QqbPbjugc+UHv0uYKvnUKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1y1weOeUhIVHMpPTvEEH+fwq7NIzTXdy+2EV+T7Hpc=;
 b=i/tkg7tce8xQDm+w5QqHsgOeBa+uzoGn6fu5g16N+qtMocxGM1gsvVqmF98ppm2FIShnzPSd/0esHDVbPRwVjpfjJWXuO8qUO426/82m66pF/bOe+PV2H2jfZTaWjt27tQspn6AtFYLl3JR2CAIlg+nbg9cw2UW3afwrOObij4NypnoYdaQmiT1U7PmQKN/xQvdNDg/BYifNaxHw0I+FK+ZLVK74dWabO3k5rjs13VZ7pOMktHD0iLkJSrxbCoaqrYFLzKRqdmSE+nZv1Q156LsVIKBbu9ttQ9cp9zdNrbZosPTZjwxbL3dfYUFxDtjhvxSKHrtiv3GNpABGgtgnkQ==
Received: from BN9PR03CA0551.namprd03.prod.outlook.com (2603:10b6:408:138::16)
 by SA1PR12MB6798.namprd12.prod.outlook.com (2603:10b6:806:25a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Thu, 8 Sep
 2022 18:35:18 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::b5) by BN9PR03CA0551.outlook.office365.com
 (2603:10b6:408:138::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 18:35:18 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:13 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, Leon Romanovsky <leon@kernel.org>
Subject: [PATCH V7 vfio 02/10] net/mlx5: Query ADV_VIRTUALIZATION capabilities
Date:   Thu, 8 Sep 2022 21:34:40 +0300
Message-ID: <20220908183448.195262-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|SA1PR12MB6798:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f957739-867f-4c5e-f8bd-08da91c8e143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g71BbW0J3Mo453Ck6GgSku3fSFGj3O/KvmZiR49CBFgqifSuHlwI98SROPv6AB7SV0npP3wXWdPYtXVzq89D9jN1MNQMjQB/G507TCD/6J3S8ts1NSuF5lcBmxzRH6ib3SIHBF0sd/q/Y0xDIe0HzG+2wmGOyHh03bpVXHxQzjw/NHpfMte/GeZPNVW87MddJ8a0t8yuIfJWStU2Q75E8epV+5jRtCF33BWdDhcSzDv1wcfwPUTWGRWXlFOzmCIBYMnYp1sns8C6Nw7rAgfBQXnDPczfGWudCWotje28xIOeM1QlyV4YQheBUz5XViNpHYv2fOmIGgFL6owFbISeHFmYFV+tYtbRfCxfu26JbHkm8b4F9/bRM1+gfwiExKdlnnFz51wlqNNGzxwLK8+F4O4PbDiPb7S1VzvucMp1Ft9zvtDwluPro+85GwTlTMvVXOMbByhEoXZKjC73BKEdk/YYq6IIlnuQFY6iRfkdqWfsc4ILisoeaM5yUWXsWmgq5VblK8pIUOZNqPau23khvKy3IfQx1xZetPGayL9GQ4H2ulQYqcAMljqBHqboR+fktxfJ6CzFtq5PN6xTscZbR2S8AHOIBK9prrXIF+Bm6paXHgyjNU0vq6cu8iPy8ORgyzxybqfD0rF8U5nFv/bg0afzHDMaVJN9mtoii38PhyKRSfnDUTjmPbUTZbwEOKdHsWFXa+a4WTvmPEj/5vdCLyYGzLJREdsQbFlD1Wkhc5AoaTabJKMbk/D6s7Bjm6qdpqeZ/su/x+qVilaz1xSL+8Y58L0K4rxblD2it/ErV+8OlYUwIxEBtN5X4HZsZyu/id1w2F6UuNuJX17zW9F9EerVod/XOuw23VWloOYt2UAHWySpaVjuHYqqsK5S4UxZ
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(40470700004)(36840700001)(8936002)(5660300002)(40480700001)(36860700001)(356005)(2906002)(81166007)(478600001)(40460700003)(82740400003)(966005)(41300700001)(54906003)(7696005)(316002)(110136005)(6666004)(6636002)(26005)(82310400005)(70206006)(4326008)(1076003)(8676002)(336012)(36756003)(2616005)(186003)(70586007)(47076005)(86362001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:18.3286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f957739-867f-4c5e-f8bd-08da91c8e143
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6798
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Query ADV_VIRTUALIZATION capabilities which provide information for
advanced virtualization related features.

Current capabilities refer to the page tracker object which is used for
tracking the pages that are dirtied by the device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20220905105852.26398-3-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 include/linux/mlx5/device.h                    | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 079fa44ada71..483a51870505 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -273,6 +273,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, adv_virtualization)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ADV_VIRTUALIZATION);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c085b031abfc..de9c315a85fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1488,6 +1488,7 @@ static const int types[] = {
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_PORT_SELECTION,
 	MLX5_CAP_DEV_SHAMPO,
+	MLX5_CAP_ADV_VIRTUALIZATION,
 };
 
 static void mlx5_hca_caps_free(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b5f58fd37a0f..5b41b9fb3d48 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1200,6 +1200,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	MLX5_CAP_PORT_SELECTION = 0x25,
+	MLX5_CAP_ADV_VIRTUALIZATION = 0x26,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1365,6 +1366,14 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET(port_selection_cap, \
 		 mdev->caps.hca[MLX5_CAP_PORT_SELECTION]->max, cap)
 
+#define MLX5_CAP_ADV_VIRTUALIZATION(mdev, cap) \
+	MLX5_GET(adv_virtualization_cap, \
+		 mdev->caps.hca[MLX5_CAP_ADV_VIRTUALIZATION]->cur, cap)
+
+#define MLX5_CAP_ADV_VIRTUALIZATION_MAX(mdev, cap) \
+	MLX5_GET(adv_virtualization_cap, \
+		 mdev->caps.hca[MLX5_CAP_ADV_VIRTUALIZATION]->max, cap)
+
 #define MLX5_CAP_FLOWTABLE_PORT_SELECTION(mdev, cap) \
 	MLX5_CAP_PORT_SELECTION(mdev, flow_table_properties_port_selection.cap)
 
-- 
2.18.1

