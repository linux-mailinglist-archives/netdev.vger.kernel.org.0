Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BD2511504
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 12:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiD0KpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiD0KpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:45:05 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF8A384662;
        Wed, 27 Apr 2022 03:26:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzieKU7ai89Qv1ksL1IC7H+QAgjmAeVCP1kGh261f0b7Vhr/E5eDxLDjn+q0DKxAPL9lrfc3SkwTG1EenZ6r464tI5rtFWAnNvQRvl/rVUSut+hT1YYSOXImRT3TC4R7JMjaKNpYSqAUfiewReQM9/A92GutNiuvwm/Ol265M1vCPSFKk2aanomrF68FmAaQ31hJsCECO1LCj0pxqC7AAJZ4BTDcKCGjssizFra5A69vCTT29fWtTGMtLet2V6NWEjs0GodMHDufZkWFVE7cp7IZX1xnvWL2pk2J2703ajF0J4ra7g86PjujCIoR96RquC+J8QWhL7kTvAnQbVhUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mehOFMmezpB3Nm2VUVqVz95S2QpxVntg2U5Q59QWCwE=;
 b=KXCgKLFfZwMAbdJDmz5gXqw8loN5VE1FGtqicm8NX/6GDN4+k1TtFdYvbIBgrBsFM1gBLayjKP0X2SF6A/YDdjZZO/KFD7ixHUy8mB85vyquoH5Zw5jXEZgkr+xZ75a1OVsnhrUQnqtdxWYwOdc1qo8Ms68iRrXwr/UO8Ija5MRct/TB4a4MhHJOJMO7WP6ZGUWjyMHfl8KiEHQ3ELIKx+JhfpfYrcbqmJ8XGy1EHXdpZETEhlJcLTfQaCZF/Zu5SqOActY+Fnn9DZ2yQKPKTu+EJV+UXVpt41ujhigmP7bVjmuz9u092jDRUv6r5AWCpJMUy3hCj9vnQU0rHdRBPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mehOFMmezpB3Nm2VUVqVz95S2QpxVntg2U5Q59QWCwE=;
 b=oaZUGyt2MiuMmTLyXNvCsDcynBlpx61qlI+l1uOgjgjPc56OWl6xoo1CATDU0axlUnJWfkYpuYG40hZSTb0+VLr91eOAIFmBubWMcrS1mGLslzheFUSAJBNjRELE1irwfhLQAweMg0p/uxcEPrm+qOIQADxe9REdxjka3krqzLsmB9j4V9WY924h6pOF6Rd1x+GSkAj7+2urbN6kokgO73mzOPeziVIorrI5Bp7iYpSXQpF9SYzbok0ZJgOR1xdMuehHt5nqKrg1az3/4qS3TN+zg+KOlHtE6kncMTjoSSCrtoGSPp6JOWMN/2xzuC4iJr6VXV1ch5x7KLU9fzKe+g==
Received: from DM6PR12CA0033.namprd12.prod.outlook.com (2603:10b6:5:1c0::46)
 by MWHPR12MB1614.namprd12.prod.outlook.com (2603:10b6:301:f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 09:31:59 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::cb) by DM6PR12CA0033.outlook.office365.com
 (2603:10b6:5:1c0::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Wed, 27 Apr 2022 09:31:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 09:31:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 09:31:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 02:31:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 02:31:55 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH mlx5-next 1/5] vfio/mlx5: Reorganize the VF is migratable code
Date:   Wed, 27 Apr 2022 12:31:16 +0300
Message-ID: <20220427093120.161402-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220427093120.161402-1-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae572416-f0ba-46c2-430f-08da2830c754
X-MS-TrafficTypeDiagnostic: MWHPR12MB1614:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB16143420601D8BC8F39410EEC3FA9@MWHPR12MB1614.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nlV9PYSvmCUVuQ0C3CXgBpduWOdhT8mxtQIbibTsIg6G9yHVK1zJBMCcVH2x9/Pa8BjShPw7azqNKttLTOMhNI6ZGxM2yT/1AtEb9KC4Ec12aufqaadaoSXnFDftQET4Oq2iuMVlYUUQQ6oDnCjWtC5ohmxGpLC5/NOduXvJD4uERH9QJHP0XSGqUVCgM5fXNgflp//IkiKJQfTIQG65jyAnT60/0G9uirMth81Doh4LBBO7QQSBUzyTEkCd75LUVsAuT+pJEc90/Eio3YKK1qzDl5vFJ7sKwstlXCYTfOGuDm337I3Ym/ITSoxOBll4yD444MeZKC8pC59TzTA7FTZPDX6ht0bRe5dOvUG6ZqDgxklSjUDCopNa1ppVCBDH2ToIdYvgTJOWuIr5CPeYmZt1p7a4qjkNaj2SXf8WyEbVO44pNAU+EWHJ1EC7CHYGPJ4jihFV/nG47tGVsdB/SJvjoCZL5uIpBRAelzP66isOkaSCkPSKunjp849GBenwzCE4DYyFj17TRABJPN9TkdIBMEX2KxVxYHZkvl10z/2S7FRUh5XuPAL03IDj0AgcwBY6GIkoz9ggiDB199ftrX/KrZphrMw1cl22vDIX+60/a6ZNX8sUTF39iE4ROsT7KusDJ6AuftehpTJBQs5jiNwpb+EBvtThFdx+xn3t5oCKs233Gnm8zlqVc/kHzggw9H1FGYh564fqdoR0UpsQtA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(316002)(6666004)(110136005)(4326008)(47076005)(8676002)(356005)(40460700003)(86362001)(70586007)(81166007)(70206006)(54906003)(6636002)(336012)(426003)(5660300002)(7696005)(2906002)(36756003)(82310400005)(83380400001)(26005)(186003)(8936002)(1076003)(2616005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 09:31:59.2826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae572416-f0ba-46c2-430f-08da2830c754
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1614
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorganize the VF is migratable code to be in a separate function, next
patches from the series may use this.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 18 ++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h  |  1 +
 drivers/vfio/pci/mlx5/main.c | 22 +++++++---------------
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5c9f9218cc1d..d608b8167f58 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -71,6 +71,24 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
 	return ret;
 }
 
+bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	bool migratable = false;
+
+	if (!mdev)
+		return false;
+
+	if (!MLX5_CAP_GEN(mdev, migration))
+		goto end;
+
+	migratable = true;
+
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return migratable;
+}
+
 int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
 {
 	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 1392a11a9cc0..2da6a1c0ec5c 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -29,6 +29,7 @@ int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
 					  size_t *state_size);
 int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
+bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev);
 int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee..2578f61eaeae 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -597,21 +597,13 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
 
-	if (pdev->is_virtfn) {
-		struct mlx5_core_dev *mdev =
-			mlx5_vf_get_core_dev(pdev);
-
-		if (mdev) {
-			if (MLX5_CAP_GEN(mdev, migration)) {
-				mvdev->migrate_cap = 1;
-				mvdev->core_device.vdev.migration_flags =
-					VFIO_MIGRATION_STOP_COPY |
-					VFIO_MIGRATION_P2P;
-				mutex_init(&mvdev->state_mutex);
-				spin_lock_init(&mvdev->reset_lock);
-			}
-			mlx5_vf_put_core_dev(mdev);
-		}
+	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(pdev)) {
+		mvdev->migrate_cap = 1;
+		mvdev->core_device.vdev.migration_flags =
+			VFIO_MIGRATION_STOP_COPY |
+			VFIO_MIGRATION_P2P;
+		mutex_init(&mvdev->state_mutex);
+		spin_lock_init(&mvdev->reset_lock);
 	}
 
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
-- 
2.18.1

