Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18349222E10
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGPVeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:22 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgGPVeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n43Lpanjm73Q6cshysvek2O8TG+HXYQUzgbccUtExq7l5SndbdB/czvkH9czDk6Ov//+nyK2qtFVEV5BoT1b2TWYhTZI2pkT4BpJc9aI7Ym++OCRagUuxxeZoGHihiuXhd7Zln0OLoVNuyVKaBGH6A8siYrvqjRJkD3Qba7uLLwFp8PuxXZ+jG4q5D5Y09YzR/TNELawxbOsQT6bOgtBQxFd8TrjF9ep4kUMKVW//RtVJ0vfCqzleYRFZwrbRiCx0CYspkPZ4SCwn6i5L76evf5OZIgVf5K4o+qpRv0n8gVjuXUhInEsZtRoogV7GKn3OPXX3dt9dfowxHj8OsKZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKQExny7RLz1xPz04OmggmZuqEv4bA6BZigXgRrKLEc=;
 b=Na4Ka/Xw0imgFAxu5S6SVUelL+RYuECkvEKebbSvgCUjlsVY8FX7gw9j/pReRNmViv8aDd85mGPHa2UZe6qboNP25+ZTs/GF4wBhY6R9Fl0KdHKXvxH64VD27O4fxNI6ktS8ByFJBRtgTatKiLkBGQjU79oSa+5Fe3fbFoqbKgiuUonFIcMEByLIKJDh9EY2dMA1WXwCs6BcJSiVqNElOdv4TaO+Znyj7pIhLtOvATbR1Z4NPWH3EqHRJpCnC0Nj3AueYGO7W0Cl/D7tq2YkggxuRb+lidtt7C08esP6mq79u8tfLM/BEMF4JWiM2k2wsVJ252vmmr5TM5qevL0+ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKQExny7RLz1xPz04OmggmZuqEv4bA6BZigXgRrKLEc=;
 b=jzbz+keqruP2C1fPPOakIXT73nJacIJoY+pt2Z+WKjJTCJ26hF3UJU+Xn+Ax6hjzRT42IkNyQRh2bcY2puZlS1GaFgAyk9LTHxT5/2fkB4mfzvfi5UC6W1DyQFKsDF5De/L6peyYDTwZSuEkEDTLV90nZrIyZseYJ3EtaSRO8BY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] net/mlx5e: IPsec: Add IPsec steering in local NIC RX
Date:   Thu, 16 Jul 2020 14:33:15 -0700
Message-Id: <20200716213321.29468-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d8e5ae69-cf3f-4f3b-27d0-08d829cff4fe
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992A22C1C642AC1BC66E696BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IITlImeTcsQzRTM1k2bnnv/L2OFvLoYdn3jW7UyzRmEkD7RiMWRBeF9tb/lGGDoS0LkS/dgQ/VYn7y+txhCoj80WmGQDdwr0ByMY6tNAI64g2MCHUc6zbDzuTf0n4nApNkQGRClnaRQWjvpH60a9PxK5nz4A6GDMhs/lpg43tjCAYdXkphqlhEJ0orP5Zaqrur9hp8VC3FDQTCTtC6bxREv2T1sT5jzLdVMgriVyJDZEiTzni4N2qxV/qxgd1iK8N479b/vA65dF07dkmy+f0iJMK/cFawAgYbNtb0WacRGhYGUdIijPdBW3O4BGf93de7GSwbW2SOlHTf8DIZhnmiKEapgdRDKW2erHjVxRLJ8nLxY2ODQaUuVTL+oAryBPE06Mr1hREEMMadjAn+V0Z3jWSgmEXCg68loctd+nZQU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(30864003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(83323001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Vrb2FVmyx7VKdART63yaijcA+vCQ2ohM5kPxe7cWwMiMgvR4hC8icPs+xsQ4TYHzFy697G0y9su3Cp4t+1T5DW9DymUopL9uIG2okDRA+5AKh3YMYIXEbG0M0wdOKc5KmDlVge6udBQKCL09+3E/i7UufQ9C5jgz/VWzVHjFD3lgqygml+uojMMtU3TrblwB+nsNhJSDSe2m3g171Oh0kgaC8MJGJz5gHlX9jsqDgUzIFCN7nbwjnZQ3/FtpwYJFHNbzIgLR8V8fPuR8rW7xK/oHadEb8Z+p28xqeBoGV7t6DxSNWYaQiKAAeG7AkXNY4YPaP/Znt+U7hja3JNw3+Tot0MIaell44rLFyA2DJSYmUBDHsHyivVGWiVPoMQUx3VuIFodg9JHZCuskgS/ZJe282Fvdfuv08QEooxZLpc8GQsG0K8bbPwKKsUDqGobvz33Lpm/bvmvUd+HTz3irTMyTx9qioKXWpvhfgwCJfq4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e5ae69-cf3f-4f3b-27d0-08d829cff4fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:02.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOSqw2yOJdcFaScy6ELRM3t8+tJVMhr6L9/mWz1NVRjxsoubQFrPcwIaFC80AGblEs5rFzWJEqpv00/kCk72jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Introduce decrypt FT, the RX error FT and the default rules.

The IPsec RX decrypt flow table is pointed by the TTC
(Traffic Type Classifier) ESP steering rules.
The decrypt flow table has two flow groups. The first flow group
keeps the decrypt steering rule programmed via the "ip xfrm s" interface.
The second flow group has a default rule to forward all non-offloaded
ESP packet to the TTC ESP default RSS TIR.

The RX error flow table is the destination of the decrypt steering rules
in the IPsec RX decrypt flow table. It has a fixed rule with single
copy action that copies ipsec_syndrome to metadata_regB[0:6]. The IPsec
syndrome is used to filter out non-ipsec packet and to return the IPsec
crypto offload status in Rx flow. The destination of RX error flow table
is the TTC ESP default RSS TIR.

All the FTs (decrypt FT and error FT) are created only when IPsec SAs
are added. If there is no IPsec SAs, the FTs are removed.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/accel/ipsec_offload.c  |   6 +
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  37 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  10 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 544 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  26 +
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 9 files changed, 630 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 375c8a2d42fa8..10e6886c96ba8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -72,7 +72,7 @@ mlx5_core-$(CONFIG_MLX5_ACCEL)      += lib/crypto.o accel/tls.o accel/ipsec.o
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
-				     en_accel/ipsec_stats.o
+				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
index 1c8923f42b093..c49699d580fff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
@@ -4,9 +4,11 @@
 #include "mlx5_core.h"
 #include "ipsec_offload.h"
 #include "lib/mlx5.h"
+#include "en_accel/ipsec_fs.h"
 
 #define MLX5_IPSEC_DEV_BASIC_CAPS (MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 | \
 				   MLX5_ACCEL_IPSEC_CAP_LSO)
+
 struct mlx5_ipsec_sa_ctx {
 	struct rhash_head hash;
 	u32 enc_key_id;
@@ -30,6 +32,10 @@ static u32 mlx5_ipsec_offload_device_caps(struct mlx5_core_dev *mdev)
 	if (!mlx5_is_ipsec_device(mdev))
 		return 0;
 
+	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ipsec_encrypt) ||
+	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ipsec_decrypt))
+		return 0;
+
 	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
 	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
 		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 6f4767324044e..6fdcd5e694764 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -129,7 +129,11 @@ enum {
 	MLX5E_ACCEL_FS_TCP_FT_LEVEL,
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
-	MLX5E_ARFS_FT_LEVEL
+	MLX5E_ARFS_FT_LEVEL,
+#endif
+#ifdef CONFIG_MLX5_EN_IPSEC
+	MLX5E_ACCEL_FS_ESP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
+	MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 #endif
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 147191b7a98a6..d39989cddd905 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -40,7 +40,7 @@
 #include "en.h"
 #include "en_accel/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
-
+#include "en_accel/ipsec_fs.h"
 
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
@@ -284,6 +284,27 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 	return 0;
 }
 
+static int mlx5e_xfrm_fs_add_rule(struct mlx5e_priv *priv,
+				  struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	if (!mlx5_is_ipsec_device(priv->mdev))
+		return 0;
+
+	return mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
+					     sa_entry->ipsec_obj_id,
+					     &sa_entry->ipsec_rule);
+}
+
+static void mlx5e_xfrm_fs_del_rule(struct mlx5e_priv *priv,
+				   struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	if (!mlx5_is_ipsec_device(priv->mdev))
+		return;
+
+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+				      &sa_entry->ipsec_rule);
+}
+
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
@@ -331,10 +352,15 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 		goto err_xfrm;
 	}
 
+	sa_entry->ipsec_obj_id = sa_handle;
+	err = mlx5e_xfrm_fs_add_rule(priv, sa_entry);
+	if (err)
+		goto err_hw_ctx;
+
 	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		err = mlx5e_ipsec_sadb_rx_add(sa_entry, sa_handle);
 		if (err)
-			goto err_hw_ctx;
+			goto err_add_rule;
 	} else {
 		sa_entry->set_iv_op = (x->props.flags & XFRM_STATE_ESN) ?
 				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
@@ -343,6 +369,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	goto out;
 
+err_add_rule:
+	mlx5e_xfrm_fs_del_rule(priv, sa_entry);
 err_hw_ctx:
 	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
 err_xfrm:
@@ -368,12 +396,14 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
+	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
 	if (!sa_entry)
 		return;
 
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
+		mlx5e_xfrm_fs_del_rule(priv, sa_entry);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
 		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 	}
@@ -407,6 +437,8 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 		kfree(ipsec);
 		return -ENOMEM;
 	}
+
+	mlx5e_accel_ipsec_fs_init(priv);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
 }
@@ -418,6 +450,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
+	mlx5e_accel_ipsec_fs_cleanup(priv);
 	destroy_workqueue(ipsec->wq);
 
 	ida_destroy(&ipsec->halloc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index c85151a1e008b..0fc8b4d4f4a34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -75,6 +75,8 @@ struct mlx5e_ipsec_stats {
 	u64 ipsec_cmd_drop;
 };
 
+struct mlx5e_accel_fs_esp;
+
 struct mlx5e_ipsec {
 	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
@@ -84,6 +86,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_sw_stats sw_stats;
 	struct mlx5e_ipsec_stats stats;
 	struct workqueue_struct *wq;
+	struct mlx5e_accel_fs_esp *rx_fs;
 };
 
 struct mlx5e_ipsec_esn_state {
@@ -92,6 +95,11 @@ struct mlx5e_ipsec_esn_state {
 	u8 overlap: 1;
 };
 
+struct mlx5e_ipsec_rule {
+	struct mlx5_flow_handle *rule;
+	struct mlx5_modify_hdr *set_modify_hdr;
+};
+
 struct mlx5e_ipsec_sa_entry {
 	struct hlist_node hlist; /* Item in SADB_RX hashtable */
 	struct mlx5e_ipsec_esn_state esn_state;
@@ -102,6 +110,8 @@ struct mlx5e_ipsec_sa_entry {
 	void *hw_context;
 	void (*set_iv_op)(struct sk_buff *skb, struct xfrm_state *x,
 			  struct xfrm_offload *xo);
+	u32 ipsec_obj_id;
+	struct mlx5e_ipsec_rule ipsec_rule;
 };
 
 void mlx5e_ipsec_build_inverse_table(void);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
new file mode 100644
index 0000000000000..429428bbc903c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -0,0 +1,544 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#include <linux/netdevice.h>
+#include "accel/ipsec_offload.h"
+#include "ipsec_fs.h"
+#include "fs_core.h"
+
+#define NUM_IPSEC_FTE BIT(15)
+
+enum accel_fs_esp_type {
+	ACCEL_FS_ESP4,
+	ACCEL_FS_ESP6,
+	ACCEL_FS_ESP_NUM_TYPES,
+};
+
+struct mlx5e_ipsec_rx_err {
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_modify_hdr *copy_modify_hdr;
+};
+
+struct mlx5e_accel_fs_esp_prot {
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *miss_group;
+	struct mlx5_flow_handle *miss_rule;
+	struct mlx5_flow_destination default_dest;
+	struct mlx5e_ipsec_rx_err rx_err;
+	u32 refcnt;
+	struct mutex prot_mutex; /* protect ESP4/ESP6 protocol */
+};
+
+struct mlx5e_accel_fs_esp {
+	struct mlx5e_accel_fs_esp_prot fs_prot[ACCEL_FS_ESP_NUM_TYPES];
+};
+
+/* IPsec RX flow steering */
+static enum mlx5e_traffic_types fs_esp2tt(enum accel_fs_esp_type i)
+{
+	if (i == ACCEL_FS_ESP4)
+		return MLX5E_TT_IPV4_IPSEC_ESP;
+	return MLX5E_TT_IPV6_IPSEC_ESP;
+}
+
+static int rx_err_add_rule(struct mlx5e_priv *priv,
+			   struct mlx5e_accel_fs_esp_prot *fs_prot,
+			   struct mlx5e_ipsec_rx_err *rx_err)
+{
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_flow_handle *fte;
+	struct mlx5_flow_spec *spec;
+	int err = 0;
+
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	/* Action to copy 7 bit ipsec_syndrome to regB[0:6] */
+	MLX5_SET(copy_action_in, action, action_type, MLX5_ACTION_TYPE_COPY);
+	MLX5_SET(copy_action_in, action, src_field, MLX5_ACTION_IN_FIELD_IPSEC_SYNDROME);
+	MLX5_SET(copy_action_in, action, src_offset, 0);
+	MLX5_SET(copy_action_in, action, length, 7);
+	MLX5_SET(copy_action_in, action, dst_field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
+	MLX5_SET(copy_action_in, action, dst_offset, 0);
+
+	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL,
+					      1, action);
+
+	if (IS_ERR(modify_hdr)) {
+		err = PTR_ERR(modify_hdr);
+		netdev_err(priv->netdev,
+			   "fail to alloc ipsec copy modify_header_id err=%d\n", err);
+		goto out_spec;
+	}
+
+	/* create fte */
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
+			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	flow_act.modify_hdr = modify_hdr;
+	fte = mlx5_add_flow_rules(rx_err->ft, spec, &flow_act,
+				  &fs_prot->default_dest, 1);
+	if (IS_ERR(fte)) {
+		err = PTR_ERR(fte);
+		netdev_err(priv->netdev, "fail to add ipsec rx err copy rule err=%d\n", err);
+		goto out;
+	}
+
+	rx_err->rule = fte;
+	rx_err->copy_modify_hdr = modify_hdr;
+
+out:
+	if (err)
+		mlx5_modify_header_dealloc(mdev, modify_hdr);
+out_spec:
+	kfree(spec);
+	return err;
+}
+
+static void rx_err_del_rule(struct mlx5e_priv *priv,
+			    struct mlx5e_ipsec_rx_err *rx_err)
+{
+	if (rx_err->rule) {
+		mlx5_del_flow_rules(rx_err->rule);
+		rx_err->rule = NULL;
+	}
+
+	if (rx_err->copy_modify_hdr) {
+		mlx5_modify_header_dealloc(priv->mdev, rx_err->copy_modify_hdr);
+		rx_err->copy_modify_hdr = NULL;
+	}
+}
+
+static void rx_err_destroy_ft(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx_err *rx_err)
+{
+	rx_err_del_rule(priv, rx_err);
+
+	if (rx_err->ft) {
+		mlx5_destroy_flow_table(rx_err->ft);
+		rx_err->ft = NULL;
+	}
+}
+
+static int rx_err_create_ft(struct mlx5e_priv *priv,
+			    struct mlx5e_accel_fs_esp_prot *fs_prot,
+			    struct mlx5e_ipsec_rx_err *rx_err)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_table *ft;
+	int err;
+
+	ft_attr.max_fte = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		netdev_err(priv->netdev, "fail to create ipsec rx inline ft err=%d\n", err);
+		return err;
+	}
+
+	rx_err->ft = ft;
+	err = rx_err_add_rule(priv, fs_prot, rx_err);
+	if (err)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	mlx5_destroy_flow_table(ft);
+	rx_err->ft = NULL;
+	return err;
+}
+
+static void rx_fs_destroy(struct mlx5e_accel_fs_esp_prot *fs_prot)
+{
+	if (fs_prot->miss_rule) {
+		mlx5_del_flow_rules(fs_prot->miss_rule);
+		fs_prot->miss_rule = NULL;
+	}
+
+	if (fs_prot->miss_group) {
+		mlx5_destroy_flow_group(fs_prot->miss_group);
+		fs_prot->miss_group = NULL;
+	}
+
+	if (fs_prot->ft) {
+		mlx5_destroy_flow_table(fs_prot->ft);
+		fs_prot->ft = NULL;
+	}
+}
+
+static int rx_fs_create(struct mlx5e_priv *priv,
+			struct mlx5e_accel_fs_esp_prot *fs_prot)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_group *miss_group;
+	struct mlx5_flow_handle *miss_rule;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_spec *spec;
+	struct mlx5_flow_table *ft;
+	u32 *flow_group_in;
+	int err = 0;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!flow_group_in || !spec) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Create FT */
+	ft_attr.max_fte = NUM_IPSEC_FTE;
+	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft_attr.autogroup.num_reserved_entries = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		netdev_err(priv->netdev, "fail to create ipsec rx ft err=%d\n", err);
+		goto out;
+	}
+	fs_prot->ft = ft;
+
+	/* Create miss_group */
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ft->max_fte - 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ft->max_fte - 1);
+	miss_group = mlx5_create_flow_group(ft, flow_group_in);
+	if (IS_ERR(miss_group)) {
+		err = PTR_ERR(miss_group);
+		netdev_err(priv->netdev, "fail to create ipsec rx miss_group err=%d\n", err);
+		goto out;
+	}
+	fs_prot->miss_group = miss_group;
+
+	/* Create miss rule */
+	miss_rule = mlx5_add_flow_rules(ft, spec, &flow_act, &fs_prot->default_dest, 1);
+	if (IS_ERR(miss_rule)) {
+		err = PTR_ERR(miss_rule);
+		netdev_err(priv->netdev, "fail to create ipsec rx miss_rule err=%d\n", err);
+		goto out;
+	}
+	fs_prot->miss_rule = miss_rule;
+
+out:
+	kfree(flow_group_in);
+	kfree(spec);
+	return err;
+}
+
+static int rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+{
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5e_accel_fs_esp *accel_esp;
+
+	accel_esp = priv->ipsec->rx_fs;
+
+	/* The netdev unreg already happened, so all offloaded rule are already removed */
+	fs_prot = &accel_esp->fs_prot[type];
+
+	rx_fs_destroy(fs_prot);
+
+	rx_err_destroy_ft(priv, &fs_prot->rx_err);
+
+	return 0;
+}
+
+static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+{
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5e_accel_fs_esp *accel_esp;
+	int err;
+
+	accel_esp = priv->ipsec->rx_fs;
+	fs_prot = &accel_esp->fs_prot[type];
+
+	fs_prot->default_dest = mlx5e_ttc_get_default_dest(priv, fs_esp2tt(type));
+
+	err = rx_err_create_ft(priv, fs_prot, &fs_prot->rx_err);
+	if (err)
+		return err;
+
+	err = rx_fs_create(priv, fs_prot);
+	if (err)
+		rx_destroy(priv, type);
+
+	return err;
+}
+
+static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+{
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5e_accel_fs_esp *accel_esp;
+	int err = 0;
+
+	accel_esp = priv->ipsec->rx_fs;
+	fs_prot = &accel_esp->fs_prot[type];
+	mutex_lock(&fs_prot->prot_mutex);
+	if (fs_prot->refcnt++)
+		goto out;
+
+	/* create FT */
+	err = rx_create(priv, type);
+	if (err) {
+		fs_prot->refcnt--;
+		goto out;
+	}
+
+	/* connect */
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = fs_prot->ft;
+	mlx5e_ttc_fwd_dest(priv, fs_esp2tt(type), &dest);
+
+out:
+	mutex_unlock(&fs_prot->prot_mutex);
+	return err;
+}
+
+static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+{
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5e_accel_fs_esp *accel_esp;
+
+	accel_esp = priv->ipsec->rx_fs;
+	fs_prot = &accel_esp->fs_prot[type];
+	mutex_lock(&fs_prot->prot_mutex);
+	if (--fs_prot->refcnt)
+		goto out;
+
+	/* disconnect */
+	mlx5e_ttc_fwd_default_dest(priv, fs_esp2tt(type));
+
+	/* remove FT */
+	rx_destroy(priv, type);
+
+out:
+	mutex_unlock(&fs_prot->prot_mutex);
+}
+
+static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     u32 ipsec_obj_id,
+			     struct mlx5_flow_spec *spec,
+			     struct mlx5_flow_act *flow_act)
+{
+	u8 ip_version = attrs->is_ipv6 ? 6 : 4;
+
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS;
+
+	/* ip_version */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, ip_version);
+
+	/* Non fragmented */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.frag);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.frag, 0);
+
+	/* ESP header */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_ESP);
+
+	/* SPI number */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi,
+		 be32_to_cpu(attrs->spi));
+
+	if (ip_version == 4) {
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4),
+		       &attrs->saddr.a4, 4);
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
+		       &attrs->daddr.a4, 4);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+	} else {
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       &attrs->saddr.a6, 16);
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       &attrs->daddr.a6, 16);
+		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       0xff, 16);
+		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       0xff, 16);
+	}
+
+	flow_act->ipsec_obj_id = ipsec_obj_id;
+	flow_act->flags |= FLOW_ACT_NO_APPEND;
+}
+
+static int rx_add_rule(struct mlx5e_priv *priv,
+		       struct mlx5_accel_esp_xfrm_attrs *attrs,
+		       u32 ipsec_obj_id,
+		       struct mlx5e_ipsec_rule *ipsec_rule)
+{
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	struct mlx5_modify_hdr *modify_hdr = NULL;
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5_flow_destination dest = {};
+	struct mlx5e_accel_fs_esp *accel_esp;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *rule;
+	enum accel_fs_esp_type type;
+	struct mlx5_flow_spec *spec;
+	int err = 0;
+
+	accel_esp = priv->ipsec->rx_fs;
+	type = attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4;
+	fs_prot = &accel_esp->fs_prot[type];
+
+	err = rx_ft_get(priv, type);
+	if (err)
+		return err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
+
+	/* Set 1  bit ipsec marker */
+	/* Set 24 bit ipsec_obj_id */
+	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
+	MLX5_SET(set_action_in, action, data, (ipsec_obj_id << 1) | 0x1);
+	MLX5_SET(set_action_in, action, offset, 7);
+	MLX5_SET(set_action_in, action, length, 25);
+
+	modify_hdr = mlx5_modify_header_alloc(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL,
+					      1, action);
+	if (IS_ERR(modify_hdr)) {
+		err = PTR_ERR(modify_hdr);
+		netdev_err(priv->netdev,
+			   "fail to alloc ipsec set modify_header_id err=%d\n", err);
+		modify_hdr = NULL;
+		goto out_err;
+	}
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT |
+			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	flow_act.modify_hdr = modify_hdr;
+	dest.ft = fs_prot->rx_err.ft;
+	rule = mlx5_add_flow_rules(fs_prot->ft, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
+			   attrs->action, err);
+		goto out_err;
+	}
+
+	ipsec_rule->rule = rule;
+	ipsec_rule->set_modify_hdr = modify_hdr;
+	goto out;
+
+out_err:
+	if (modify_hdr)
+		mlx5_modify_header_dealloc(priv->mdev, modify_hdr);
+	rx_ft_put(priv, type);
+
+out:
+	kvfree(spec);
+	return err;
+}
+
+static void rx_del_rule(struct mlx5e_priv *priv,
+			struct mlx5_accel_esp_xfrm_attrs *attrs,
+			struct mlx5e_ipsec_rule *ipsec_rule)
+{
+	mlx5_del_flow_rules(ipsec_rule->rule);
+	ipsec_rule->rule = NULL;
+
+	mlx5_modify_header_dealloc(priv->mdev, ipsec_rule->set_modify_hdr);
+	ipsec_rule->set_modify_hdr = NULL;
+
+	rx_ft_put(priv, attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
+}
+
+int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
+				  struct mlx5_accel_esp_xfrm_attrs *attrs,
+				  u32 ipsec_obj_id,
+				  struct mlx5e_ipsec_rule *ipsec_rule)
+{
+	if (!priv->ipsec->rx_fs || attrs->action != MLX5_ACCEL_ESP_ACTION_DECRYPT)
+		return -EOPNOTSUPP;
+
+	return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
+}
+
+void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
+				   struct mlx5_accel_esp_xfrm_attrs *attrs,
+				   struct mlx5e_ipsec_rule *ipsec_rule)
+{
+	if (!priv->ipsec->rx_fs)
+		return;
+
+	rx_del_rule(priv, attrs, ipsec_rule);
+}
+
+static void fs_cleanup_rx(struct mlx5e_priv *priv)
+{
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5e_accel_fs_esp *accel_esp;
+	enum accel_fs_esp_type i;
+
+	accel_esp = priv->ipsec->rx_fs;
+	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
+		fs_prot = &accel_esp->fs_prot[i];
+		mutex_destroy(&fs_prot->prot_mutex);
+		WARN_ON(fs_prot->refcnt);
+	}
+	kfree(priv->ipsec->rx_fs);
+	priv->ipsec->rx_fs = NULL;
+}
+
+static int fs_init_rx(struct mlx5e_priv *priv)
+{
+	struct mlx5e_accel_fs_esp_prot *fs_prot;
+	struct mlx5e_accel_fs_esp *accel_esp;
+	enum accel_fs_esp_type i;
+
+	priv->ipsec->rx_fs =
+		kzalloc(sizeof(struct mlx5e_accel_fs_esp), GFP_KERNEL);
+	if (!priv->ipsec->rx_fs)
+		return -ENOMEM;
+
+	accel_esp = priv->ipsec->rx_fs;
+	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
+		fs_prot = &accel_esp->fs_prot[i];
+		mutex_init(&fs_prot->prot_mutex);
+	}
+
+	return 0;
+}
+
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv)
+{
+	if (!priv->ipsec->rx_fs)
+		return;
+
+	fs_cleanup_rx(priv);
+}
+
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
+{
+	if (!mlx5_is_ipsec_device(priv->mdev) || !priv->ipsec)
+		return -EOPNOTSUPP;
+
+	return fs_init_rx(priv);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
new file mode 100644
index 0000000000000..3389b3bb3ef80
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_IPSEC_STEERING_H__
+#define __MLX5_IPSEC_STEERING_H__
+
+#include "en.h"
+#include "ipsec.h"
+#include "accel/ipsec_offload.h"
+#include "en/fs.h"
+
+#ifdef CONFIG_MLX5_EN_IPSEC
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
+int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
+				  struct mlx5_accel_esp_xfrm_attrs *attrs,
+				  u32 ipsec_obj_id,
+				  struct mlx5e_ipsec_rule *ipsec_rule);
+void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
+				   struct mlx5_accel_esp_xfrm_attrs *attrs,
+				   struct mlx5e_ipsec_rule *ipsec_rule);
+#else
+static inline void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv) {}
+static inline int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv) { return 0; }
+#endif
+#endif /* __MLX5_IPSEC_STEERING_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 465a1076a4777..fee169732de74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -459,6 +459,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 		MLX5_SET(flow_context, in_flow_context, modify_header_id,
 			 fte->action.modify_hdr->id);
 
+	MLX5_SET(flow_context, in_flow_context, ipsec_obj_id, fte->action.ipsec_obj_id);
+
 	vlan = MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan);
 
 	MLX5_SET(vlan, vlan, ethtype, fte->action.vlan[0].ethtype);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 785b2960d6b59..6904ad96af48b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -105,7 +105,7 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Vlan, mac, ttc, inner ttc, {aRFS/accel} */
+/* Vlan, mac, ttc, inner ttc, {aRFS/accel and esp/esp_err} */
 #define KERNEL_NIC_PRIO_NUM_LEVELS 6
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
-- 
2.26.2

