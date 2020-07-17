Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41108222FA9
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgGQAFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:00 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:33630
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbgGQAE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Km8ormHRCyxqtdTGw36vrf1Ac1ZdIW3lLFGXChmJf1AdU8W4tfExYJv5Qbv+D/pA/2L5xk9t/6JmTy4qfcoGsPNjx0voZ3cXxwoy8zQpN2YfaXYkZUfGfJ+Y7QAIhmU7xOPsgeQ4Fo1WsASL+rLtb7uCIPkakNF8em4/HIM/HbTwt5AnABY7gh4LFnyyKgjgkzV8QONOBMOpT2JLQZ7FVnZUCuoBSebAC6plO0FAk+wU4SRZ1nvCX88nX5K3U9fLr8OsRVLsi7BTOfBa5jsyt7NtAt1gZy8QkJ+eKiguA5LjNG2hPU1tGju5GguKpQ/VP307mXXOMTp1PS9i2FEFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEQnCybcx0O4HW0gje45jrCze7DDb257wOGboIPi0L0=;
 b=ic8nOqmvM8DJG537XnRYS11cpur3txchZ9meEDMqgZM7GEyeCzpxZG1mD9vCNpWyx4aiKsSqxaYE/H93HwvD0rRvVtEZcF2t8CGxwUDC2PQvOYV0YyiAUYeNCaitlKdd7coHaEy3xFYjgmFVtMG8qLoEXcmzFJqCDGobs5YDGiA4jgbGjJeERayatJP3EjqaKQ4TJWkMO/TtAGlTX0lrv0I+Z9NAGUPZ/0lC00+dXAOyobUhmbFVh3qOuxhz83NPKM8Q/GOHJHD+c4dvr/xHVtnP6J8xEQivLPeOg8tMXav68AAKbjeOQqicmtLL8MoN/j/8AOwBc0TnPfPWdPCHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEQnCybcx0O4HW0gje45jrCze7DDb257wOGboIPi0L0=;
 b=KK8frs1NQaILBougyAn/6YRAbxcnT7gWI5tBiQ62JtsoLEfBuKPJujqI2tVfxXURq0aBdItP+ZSHqmFgYLQ3foxzdNxRBKshf5Ymmhe4XjMQ8bwgmPXY/MPsOdGpL4u+dBAL6RjJdFc6itrrFzBOSanyoqDV3x/2dtpYHDpd1zM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 06/15] net/mlx5: Accel, Add core IPsec support for the Connect-X family
Date:   Thu, 16 Jul 2020 17:04:01 -0700
Message-Id: <20200717000410.55600-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd4df321-b211-41a4-b381-08d829e502a4
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24482406121255A1D28C56C4BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0A1BCuHQ8QooeTIl+TbVdyNxUYP9AdrRBHqhEyySrCVff5E5YSAc39SrAQFA02+tDOID5Ft8XWLJ4Ld7KPF/bWeNCfqt8Jy46egjmRYriSwCbkxnJydBu9FjFDW2w1k3SQokCBfZNDr0KnuO/fA3wfsW/RIF0HMrDyf8ATIxEZR0uKFIXyZ60703HkSkPIuu1VVsSdoTfEbI6X49PP7gJwddb9b+dX6shcSV2pNVs6zqusRFA7pc/p6p4ul3R/IQXn0bS3JbFymoDi0SLn6UU6BgiQZgS8zocL4xmrN6vc8wYH8FWI5tbDBDFqoLx2N22rARNMBTvucTRGOldCAGj06chRPahY6tjQIL7D6BUc2CyhtgiSkAw57Ky+TuOFH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(30864003)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mp2Iol3v4ZMJa6TCc4NMFd/tVkPrUk/oQ0X2I//V5y0SO507QNDwftNfiQAtl3/4/+fIOqjKM78WP2ZCu8zDo9Cwpi++Vv4P5/MXrnc89qp8xmjp+qPRpH6ignYw9GtyArLLawPW3EUmn5/UBD7EpjS7hwdOwNBt6owzzQwEwwtLcORq1lgoq0Uu8uU9ltua4krVi60Ay1oztKuYmfPpJ1ghUf+K/Q40xMpBEMJs2b0gfnczJZG91ordrO+T0vNtbDikQCP6BxuqXzhzEXRJTyzKR430cZfg2HbeHXLfD3pjfByqPbsF11M412qdMKZTzIahc2o7j8ltQ8kO82m+mWtXAwRu/YzsR83GqrmqrV1iHwrqbnEOUtoP7+xCE+dHyYps3kTd7/VzWIbzGx1K8fFs04GeLiswIwkllAMtRg0MIWMwkXeAWtboMZ+V0Ago+AygeYidSSZ+ccR5Tg6aa2fPNXKqeCt7IyiD4lKJmxg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4df321-b211-41a4-b381-08d829e502a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:44.5610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzqRGI/jVWKHUe0Ejhf9nzY1z/bCdYDqS5ZJ6thEohWqge1erxr2z4jvkAjVD6MGuSqQHETpc/gb3AYckHdAAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This to set the base for downstream patches to support
the new IPsec implementation of the Connect-X family.

Following modifications made:
- Remove accel layer dependency from MLX5_FPGA_IPSEC.
- Introduce accel_ipsec_ops, each IPsec device will
  have to support these ops.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c | 103 +++++++++++++-----
 .../ethernet/mellanox/mlx5/core/accel/ipsec.h |  45 ++++----
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   4 +-
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.c  |  51 ++++++---
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.h  |  37 ++-----
 .../net/ethernet/mellanox/mlx5/core/main.c    |   9 +-
 include/linux/mlx5/accel.h                    |   6 +-
 include/linux/mlx5/driver.h                   |   3 +
 8 files changed, 154 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index 8a4985d8cbfe5..628c8887f0869 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -31,37 +31,83 @@
  *
  */
 
-#ifdef CONFIG_MLX5_FPGA_IPSEC
-
 #include <linux/mlx5/device.h>
 
 #include "accel/ipsec.h"
 #include "mlx5_core.h"
 #include "fpga/ipsec.h"
 
+void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mlx5_fpga_ipsec_ops(mdev);
+	int err = 0;
+
+	if (!ipsec_ops || !ipsec_ops->init) {
+		mlx5_core_dbg(mdev, "IPsec ops is not supported\n");
+		return;
+	}
+
+	err = ipsec_ops->init(mdev);
+	if (err) {
+		mlx5_core_warn_once(mdev, "Failed to start IPsec device, err = %d\n", err);
+		return;
+	}
+
+	mdev->ipsec_ops = ipsec_ops;
+}
+
+void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
+{
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->cleanup)
+		return;
+
+	ipsec_ops->cleanup(mdev);
+}
+
 u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
-	return mlx5_fpga_ipsec_device_caps(mdev);
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->device_caps)
+		return 0;
+
+	return ipsec_ops->device_caps(mdev);
 }
 EXPORT_SYMBOL_GPL(mlx5_accel_ipsec_device_caps);
 
 unsigned int mlx5_accel_ipsec_counters_count(struct mlx5_core_dev *mdev)
 {
-	return mlx5_fpga_ipsec_counters_count(mdev);
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->counters_count)
+		return -EOPNOTSUPP;
+
+	return ipsec_ops->counters_count(mdev);
 }
 
 int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 				   unsigned int count)
 {
-	return mlx5_fpga_ipsec_counters_read(mdev, counters, count);
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->counters_read)
+		return -EOPNOTSUPP;
+
+	return ipsec_ops->counters_read(mdev, counters, count);
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 				       struct mlx5_accel_esp_xfrm *xfrm,
 				       u32 *sa_handle)
 {
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
 	__be32 saddr[4] = {}, daddr[4] = {};
 
+	if (!ipsec_ops || !ipsec_ops->create_hw_context)
+		return  ERR_PTR(-EOPNOTSUPP);
+
 	if (!xfrm->attrs.is_ipv6) {
 		saddr[3] = xfrm->attrs.saddr.a4;
 		daddr[3] = xfrm->attrs.daddr.a4;
@@ -70,29 +116,18 @@ void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
 	}
 
-	return mlx5_fpga_ipsec_create_sa_ctx(mdev, xfrm, saddr,
-					     daddr, xfrm->attrs.spi,
-					     xfrm->attrs.is_ipv6, sa_handle);
+	return ipsec_ops->create_hw_context(mdev, xfrm, saddr, daddr, xfrm->attrs.spi,
+					    xfrm->attrs.is_ipv6, sa_handle);
 }
 
-void mlx5_accel_esp_free_hw_context(void *context)
+void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
 {
-	mlx5_fpga_ipsec_delete_sa_ctx(context);
-}
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
 
-int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
-{
-	return mlx5_fpga_ipsec_init(mdev);
-}
-
-void mlx5_accel_ipsec_build_fs_cmds(void)
-{
-	mlx5_fpga_ipsec_build_fs_cmds();
-}
+	if (!ipsec_ops || !ipsec_ops->free_hw_context)
+		return;
 
-void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
-{
-	mlx5_fpga_ipsec_cleanup(mdev);
+	ipsec_ops->free_hw_context(context);
 }
 
 struct mlx5_accel_esp_xfrm *
@@ -100,9 +135,13 @@ mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs,
 			   u32 flags)
 {
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = mdev->ipsec_ops;
 	struct mlx5_accel_esp_xfrm *xfrm;
 
-	xfrm = mlx5_fpga_esp_create_xfrm(mdev, attrs, flags);
+	if (!ipsec_ops || !ipsec_ops->esp_create_xfrm)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	xfrm = ipsec_ops->esp_create_xfrm(mdev, attrs, flags);
 	if (IS_ERR(xfrm))
 		return xfrm;
 
@@ -113,15 +152,23 @@ EXPORT_SYMBOL_GPL(mlx5_accel_esp_create_xfrm);
 
 void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 {
-	mlx5_fpga_esp_destroy_xfrm(xfrm);
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->esp_destroy_xfrm)
+		return;
+
+	ipsec_ops->esp_destroy_xfrm(xfrm);
 }
 EXPORT_SYMBOL_GPL(mlx5_accel_esp_destroy_xfrm);
 
 int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 			       const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	return mlx5_fpga_esp_modify_xfrm(xfrm, attrs);
+	const struct mlx5_accel_ipsec_ops *ipsec_ops = xfrm->mdev->ipsec_ops;
+
+	if (!ipsec_ops || !ipsec_ops->esp_modify_xfrm)
+		return -EOPNOTSUPP;
+
+	return ipsec_ops->esp_modify_xfrm(xfrm, attrs);
 }
 EXPORT_SYMBOL_GPL(mlx5_accel_esp_modify_xfrm);
-
-#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index e89747674712c..fbb9c5415d539 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -37,7 +37,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/accel.h>
 
-#ifdef CONFIG_MLX5_FPGA_IPSEC
+#ifdef CONFIG_MLX5_ACCEL
 
 #define MLX5_IPSEC_DEV(mdev) (mlx5_accel_ipsec_device_caps(mdev) & \
 			      MLX5_ACCEL_IPSEC_CAP_DEVICE)
@@ -49,12 +49,30 @@ int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 				       struct mlx5_accel_esp_xfrm *xfrm,
 				       u32 *sa_handle);
-void mlx5_accel_esp_free_hw_context(void *context);
+void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
 
-int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
-void mlx5_accel_ipsec_build_fs_cmds(void);
+void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
 void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
 
+struct mlx5_accel_ipsec_ops {
+	u32 (*device_caps)(struct mlx5_core_dev *mdev);
+	unsigned int (*counters_count)(struct mlx5_core_dev *mdev);
+	int (*counters_read)(struct mlx5_core_dev *mdev, u64 *counters, unsigned int count);
+	void* (*create_hw_context)(struct mlx5_core_dev *mdev,
+				   struct mlx5_accel_esp_xfrm *xfrm,
+				   const __be32 saddr[4], const __be32 daddr[4],
+				   const __be32 spi, bool is_ipv6, u32 *sa_handle);
+	void (*free_hw_context)(void *context);
+	int (*init)(struct mlx5_core_dev *mdev);
+	void (*cleanup)(struct mlx5_core_dev *mdev);
+	struct mlx5_accel_esp_xfrm* (*esp_create_xfrm)(struct mlx5_core_dev *mdev,
+						       const struct mlx5_accel_esp_xfrm_attrs *attrs,
+						       u32 flags);
+	int (*esp_modify_xfrm)(struct mlx5_accel_esp_xfrm *xfrm,
+			       const struct mlx5_accel_esp_xfrm_attrs *attrs);
+	void (*esp_destroy_xfrm)(struct mlx5_accel_esp_xfrm *xfrm);
+};
+
 #else
 
 #define MLX5_IPSEC_DEV(mdev) false
@@ -67,23 +85,12 @@ mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 	return NULL;
 }
 
-static inline void mlx5_accel_esp_free_hw_context(void *context)
-{
-}
-
-static inline int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
+static inline void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context) {}
 
-static inline void mlx5_accel_ipsec_build_fs_cmds(void)
-{
-}
+static inline void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev) {}
 
-static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
-{
-}
+static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev) {}
 
-#endif
+#endif /* CONFIG_MLX5_ACCEL */
 
 #endif	/* __MLX5_ACCEL_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index bc55c82b55ba8..8d797cd56e264 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -342,7 +342,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_hw_ctx:
-	mlx5_accel_esp_free_hw_context(sa_entry->hw_context);
+	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
 err_xfrm:
 	mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 err_sa_entry:
@@ -372,7 +372,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
-		mlx5_accel_esp_free_hw_context(sa_entry->hw_context);
+		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
 		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index b463787d6ca16..cc67366495b09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -359,7 +359,7 @@ u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	return ret;
 }
 
-unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev)
+static unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_fpga_device *fdev = mdev->fpga;
 
@@ -370,8 +370,8 @@ unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev)
 			number_of_ipsec_counters);
 }
 
-int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
-				  unsigned int counters_count)
+static int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
+					 unsigned int counters_count)
 {
 	struct mlx5_fpga_device *fdev = mdev->fpga;
 	unsigned int i;
@@ -665,12 +665,10 @@ static bool mlx5_is_fpga_egress_ipsec_rule(struct mlx5_core_dev *dev,
 	return true;
 }
 
-void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
-				    struct mlx5_accel_esp_xfrm *accel_xfrm,
-				    const __be32 saddr[4],
-				    const __be32 daddr[4],
-				    const __be32 spi, bool is_ipv6,
-				    u32 *sa_handle)
+static void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
+					   struct mlx5_accel_esp_xfrm *accel_xfrm,
+					   const __be32 saddr[4], const __be32 daddr[4],
+					   const __be32 spi, bool is_ipv6, u32 *sa_handle)
 {
 	struct mlx5_fpga_ipsec_sa_ctx *sa_ctx;
 	struct mlx5_fpga_esp_xfrm *fpga_xfrm =
@@ -862,7 +860,7 @@ mlx5_fpga_ipsec_release_sa_ctx(struct mlx5_fpga_ipsec_sa_ctx *sa_ctx)
 	mutex_unlock(&fipsec->sa_hash_lock);
 }
 
-void mlx5_fpga_ipsec_delete_sa_ctx(void *context)
+static void mlx5_fpga_ipsec_delete_sa_ctx(void *context)
 {
 	struct mlx5_fpga_esp_xfrm *fpga_xfrm =
 			((struct mlx5_fpga_ipsec_sa_ctx *)context)->fpga_xfrm;
@@ -1264,7 +1262,7 @@ const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flo
 	}
 }
 
-int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev)
+static int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_fpga_conn_attr init_attr = {0};
 	struct mlx5_fpga_device *fdev = mdev->fpga;
@@ -1346,7 +1344,7 @@ static void destroy_rules_rb(struct rb_root *root)
 	}
 }
 
-void mlx5_fpga_ipsec_cleanup(struct mlx5_core_dev *mdev)
+static void mlx5_fpga_ipsec_cleanup(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_fpga_device *fdev = mdev->fpga;
 
@@ -1451,7 +1449,7 @@ mlx5_fpga_esp_validate_xfrm_attrs(struct mlx5_core_dev *mdev,
 	return 0;
 }
 
-struct mlx5_accel_esp_xfrm *
+static struct mlx5_accel_esp_xfrm *
 mlx5_fpga_esp_create_xfrm(struct mlx5_core_dev *mdev,
 			  const struct mlx5_accel_esp_xfrm_attrs *attrs,
 			  u32 flags)
@@ -1479,7 +1477,7 @@ mlx5_fpga_esp_create_xfrm(struct mlx5_core_dev *mdev,
 	return &fpga_xfrm->accel_xfrm;
 }
 
-void mlx5_fpga_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+static void mlx5_fpga_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 {
 	struct mlx5_fpga_esp_xfrm *fpga_xfrm =
 			container_of(xfrm, struct mlx5_fpga_esp_xfrm,
@@ -1488,8 +1486,8 @@ void mlx5_fpga_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 	kfree(fpga_xfrm);
 }
 
-int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			      const struct mlx5_accel_esp_xfrm_attrs *attrs)
+static int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				     const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_core_dev *mdev = xfrm->mdev;
 	struct mlx5_fpga_device *fdev = mdev->fpga;
@@ -1560,3 +1558,24 @@ int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 	mutex_unlock(&fpga_xfrm->lock);
 	return err;
 }
+
+static const struct mlx5_accel_ipsec_ops fpga_ipsec_ops = {
+	.device_caps = mlx5_fpga_ipsec_device_caps,
+	.counters_count = mlx5_fpga_ipsec_counters_count,
+	.counters_read = mlx5_fpga_ipsec_counters_read,
+	.create_hw_context = mlx5_fpga_ipsec_create_sa_ctx,
+	.free_hw_context = mlx5_fpga_ipsec_delete_sa_ctx,
+	.init = mlx5_fpga_ipsec_init,
+	.cleanup = mlx5_fpga_ipsec_cleanup,
+	.esp_create_xfrm = mlx5_fpga_esp_create_xfrm,
+	.esp_modify_xfrm = mlx5_fpga_esp_modify_xfrm,
+	.esp_destroy_xfrm = mlx5_fpga_esp_destroy_xfrm,
+};
+
+const struct mlx5_accel_ipsec_ops *mlx5_fpga_ipsec_ops(struct mlx5_core_dev *mdev)
+{
+	if (!mlx5_fpga_is_ipsec_device(mdev))
+		return NULL;
+
+	return &fpga_ipsec_ops;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index 9ba637f0f0f27..db88eb4c49e34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -38,44 +38,23 @@
 #include "fs_cmd.h"
 
 #ifdef CONFIG_MLX5_FPGA_IPSEC
+const struct mlx5_accel_ipsec_ops *mlx5_fpga_ipsec_ops(struct mlx5_core_dev *mdev);
 u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev);
-unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev);
-int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
-				  unsigned int counters_count);
-
-void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
-				    struct mlx5_accel_esp_xfrm *accel_xfrm,
-				    const __be32 saddr[4],
-				    const __be32 daddr[4],
-				    const __be32 spi, bool is_ipv6,
-				    u32 *sa_handle);
-void mlx5_fpga_ipsec_delete_sa_ctx(void *context);
-
-int mlx5_fpga_ipsec_init(struct mlx5_core_dev *mdev);
-void mlx5_fpga_ipsec_cleanup(struct mlx5_core_dev *mdev);
-void mlx5_fpga_ipsec_build_fs_cmds(void);
-
-struct mlx5_accel_esp_xfrm *
-mlx5_fpga_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			  const struct mlx5_accel_esp_xfrm_attrs *attrs,
-			  u32 flags);
-void mlx5_fpga_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			      const struct mlx5_accel_esp_xfrm_attrs *attrs);
-
 const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type);
+void mlx5_fpga_ipsec_build_fs_cmds(void);
 #else
-static inline u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev)
-{
-	return 0;
-}
-
+static inline
+const struct mlx5_accel_ipsec_ops *mlx5_fpga_ipsec_ops(struct mlx5_core_dev *mdev)
+{ return NULL; }
+static inline u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev) { return 0; }
 static inline const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type)
 {
 	return mlx5_fs_cmd_get_default(type);
 }
 
+static inline void mlx5_fpga_ipsec_build_fs_cmds(void) {};
+
 #endif /* CONFIG_MLX5_FPGA_IPSEC */
 #endif	/* __MLX5_FPGA_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b658908f0442..e32d46c337011 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1089,11 +1089,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_fpga_start;
 	}
 
-	err = mlx5_accel_ipsec_init(dev);
-	if (err) {
-		mlx5_core_err(dev, "IPSec device start failed %d\n", err);
-		goto err_ipsec_start;
-	}
+	mlx5_accel_ipsec_init(dev);
 
 	err = mlx5_accel_tls_init(dev);
 	if (err) {
@@ -1135,7 +1131,6 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	mlx5_accel_tls_cleanup(dev);
 err_tls_start:
 	mlx5_accel_ipsec_cleanup(dev);
-err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
 	mlx5_rsc_dump_cleanup(dev);
@@ -1628,7 +1623,7 @@ static int __init init(void)
 	get_random_bytes(&sw_owner_id, sizeof(sw_owner_id));
 
 	mlx5_core_verify_params();
-	mlx5_accel_ipsec_build_fs_cmds();
+	mlx5_fpga_ipsec_build_fs_cmds();
 	mlx5_register_debugfs();
 
 	err = pci_register_driver(&mlx5_core_driver);
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 96ebaa94a92e5..dacf69516002e 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -126,7 +126,7 @@ enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN	= 1 << 7,
 };
 
-#ifdef CONFIG_MLX5_FPGA_IPSEC
+#ifdef CONFIG_MLX5_ACCEL
 
 u32 mlx5_accel_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
@@ -152,5 +152,5 @@ static inline int
 mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs) { return -EOPNOTSUPP; }
 
-#endif
-#endif
+#endif /* CONFIG_MLX5_ACCEL */
+#endif /* __MLX5_ACCEL_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1e6ca716635a9..6a97ad601991e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -707,6 +707,9 @@ struct mlx5_core_dev {
 	} roce;
 #ifdef CONFIG_MLX5_FPGA
 	struct mlx5_fpga_device *fpga;
+#endif
+#ifdef CONFIG_MLX5_ACCEL
+	const struct mlx5_accel_ipsec_ops *ipsec_ops;
 #endif
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
-- 
2.26.2

