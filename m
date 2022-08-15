Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8342759316C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiHOPNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243031AbiHOPMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:12:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2058.outbound.protection.outlook.com [40.107.102.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA9C25E94;
        Mon, 15 Aug 2022 08:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHRddC6nvVkHvCUiF+VM2lkGc17OdCmpB9bCxi2AfhEFv7jnAptIpBSSoAYKwsNve0j3q/eTKley89iMenVBvF/0RZcXu3Cw7KwJM7Ms98921Tpxe189Abm+PxhMQi2ULslarfy8w/s0CUXYj4u7BHk4twYspwcd3jwRbKhdT42EEYdLjP/BIfjZGxdpK2PTIFN8mWOT4Jg3ACvUfI7v9Ua1CY5iYN8+3KWqs+igfVKmH4s3UcgNo1zBy3xYb02I2BgR1Le4K12WDV1RQwLd/PaIil7rtQaFQoBmkTDiuGDlPUeG+7bH7+P1ICxKPPvY8tUrX9IDP+UhkGcnyfdUSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=OgOqt813LCOoRuh7HJQJ6A9i4/eS255WJzIDBypH/uy1EKFDiLRmFbfsDMiu0gWk7FJGeqR1VMcG1DOBpMLko5DS4bRbKo93ZbIwRN9v7gl6If7cucsBAU/SNOJnWJXOck2QRN3AQlToEeMBlLYvt2hpGf/UvJuryt9BWusTfjJUS/KM4ZWLyvvvHXkTJN+VASxbUFFEL1NR/FgzuIowjbxAmr8clc8UsQSX2iSnF57LbwJUfwo9G1AQUzwOvfOCo7EpZbCfihuNFCr5gD4lTCQNmUjH3pW8zVrlwbtiQ9CxCRzZe0vI1MJgqz8Dxwa0M5pgMcb1BqSqVnw6+AZ6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE6sjx0oSA79BfIgkJVMlmUd3p6BL3oGNTJ2eCqwAtA=;
 b=tjApvT1MFBSwTIuMsL726EiicpvPEFVtfisEdzjMkO4EAIRw2uF+Z9zWaroAGo6BiNT/WQoN6+hWGDmk0H5vQPZE5EZiM6El+6fFud5Ddfz7AAZcKxvu0309Y8Q70PAh1dJuzZ0eaQ90k87BtU2jp4QPMtjqhKgm8lOD6SueqAfK/icDaUK01eJ0zDPOuRe328OJj/JUJN3TAfhe6ZbeXN4I1ZmkgJK+oW8oXJGMHSWU05ZKbSOZXmnmgh4OM/pCMWMiyEZdtPBvAIARefTIOYkWg2TfC/PaKKEqXDDC00SEZOkGVJlNzP5vnMNqCDLk/XsCpF1spK7I9/bY68wAFA==
Received: from MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::13)
 by DM4PR12MB5294.namprd12.prod.outlook.com (2603:10b6:5:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 15:12:16 +0000
Received: from CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::f6) by MW4P221CA0008.outlook.office365.com
 (2603:10b6:303:8b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.21 via Frontend
 Transport; Mon, 15 Aug 2022 15:12:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT090.mail.protection.outlook.com (10.13.175.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 15:12:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 15:12:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 08:12:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 08:12:11 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V4 vfio 10/10] vfio/mlx5: Set the driver DMA logging callbacks
Date:   Mon, 15 Aug 2022 18:11:09 +0300
Message-ID: <20220815151109.180403-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220815151109.180403-1-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc6164ce-7e04-4a61-cbd3-08da7ed089cc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5294:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U6DmtcLlZ5miUof+gA611LzDErlED0YNJ1Tbog4088vg9KAwXTt6BhA6WU0fegGii/sigcFQJrEMeNjMzIBlXODrhFLvlHe0rblC/N9vHwbjGlwcPxGtwRbZWGYLjdwrM8eDwU/VFFJ/GC9rWuut6u4XcQEnFm57xSYOZ36OfmOLYPp55fa0nrAbRHgck1Q0hN9yzb3P2p2zzBRJbC1hCotwZrEBGORxLmzyiDtRWwMoMdq48sg/2Uop12pvZ9PEVLN2W8dmwJdJenmjfXA0P7mM/kWGqxoI2ivJekw1PRWXM0SaCKxIuMnkujqtus7QaEYA6Ib7kt/OczznAkjh3DLsh4JelIGbVwAW+VbvAjDUTAluxvQ5NFUhmKLOC0YTdg6Ii+b1mE4WSrsfwL76tzObDHzE/v2PntVOYRXLSrRBI7PZBwvxi9Z/kKg0bFXNcA6bYjrKVpzAxwK6qCWi9bJPKuKKhpZVBbC1KH7GlAAveUf84qq8UdtZUEeIrqUKUjNwh8TJ73sjiYMNLku5rImDMJD7CAWY0w109qbZMSk47l+5MpExRypSRd7ITqfBMnZFQSyiGha6AZUaq4uAE55dTt3yNyiX3kgUH9YEeJ3YmeDNyTCjBBxzGurfc1tq5bI7FZqUBfaOPo/TOTy9J/JZf6exSU4acLQinLDyftwr7OIwnSBFvTPUeKNUX2BuopVTMb00Y5DVnE3IA1nvQLH+duHkoP89+TBECJVXEZWx7/jdiaJMqyJSaloUnSEL2C3IMzc2w9Dg9uu5H7uSoZWsYWl56Sqx2dJjfApdDbsc3E8mqQJznaTsYthUMRi+oQZpze80L1Fyxl2irlliwg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(40470700004)(41300700001)(6636002)(316002)(54906003)(478600001)(26005)(40460700003)(70206006)(40480700001)(70586007)(82310400005)(4326008)(110136005)(8676002)(8936002)(5660300002)(2906002)(36860700001)(36756003)(82740400003)(186003)(86362001)(356005)(1076003)(336012)(81166007)(426003)(2616005)(47076005)(83380400001)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:12:15.5450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6164ce-7e04-4a61-cbd3-08da7ed089cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that everything is ready set the driver DMA logging callbacks if
supported by the device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 5 ++++-
 drivers/vfio/pci/mlx5/cmd.h  | 3 ++-
 drivers/vfio/pci/mlx5/main.c | 9 ++++++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 3e92b4d92be2..c604b70437a5 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -126,7 +126,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 }
 
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
-			       const struct vfio_migration_ops *mig_ops)
+			       const struct vfio_migration_ops *mig_ops,
+			       const struct vfio_log_ops *log_ops)
 {
 	struct pci_dev *pdev = mvdev->core_device.pdev;
 	int ret;
@@ -169,6 +170,8 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 		VFIO_MIGRATION_P2P;
 	mvdev->core_device.vdev.mig_ops = mig_ops;
 	init_completion(&mvdev->tracker_comp);
+	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
+		mvdev->core_device.vdev.log_ops = log_ops;
 
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 8b0ae40c620c..921d5720a1e5 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -118,7 +118,8 @@ int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
-			       const struct vfio_migration_ops *mig_ops);
+			       const struct vfio_migration_ops *mig_ops,
+			       const struct vfio_log_ops *log_ops);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index a9b63d15c5d3..759a5f5f7b3f 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -579,6 +579,12 @@ static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
 	.migration_get_state = mlx5vf_pci_get_device_state,
 };
 
+static const struct vfio_log_ops mlx5vf_pci_log_ops = {
+	.log_start = mlx5vf_start_page_tracker,
+	.log_stop = mlx5vf_stop_page_tracker,
+	.log_read_and_clear = mlx5vf_tracker_read_and_clear,
+};
+
 static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.name = "mlx5-vfio-pci",
 	.open_device = mlx5vf_pci_open_device,
@@ -602,7 +608,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (!mvdev)
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
+	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops,
+				  &mlx5vf_pci_log_ops);
 	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
-- 
2.18.1

