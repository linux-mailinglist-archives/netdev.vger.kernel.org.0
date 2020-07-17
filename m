Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E69B222FAB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGQAFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:04 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:58740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbgGQAE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fy0a43P/Ome7yjgnsBFvybbmPL7sVen75PcxfR3EPPqa69saRoF9iLSoKaVFgpqy0Mm/HIfomJaxW7NdX2I5PkmaVve+t8pBNaH7sJPR3vVqU2LEmxFtEk/rSXNDUyOH6Ris/+UU2vzkwkq1ZAGHaTm2n6cdDq13ugmiVWD2g60QjQUAF7ifOr+oFDfO2kQeboww1V/kjLF/GaglwA/ln/BGOuszQ0eIEGc6QP1Uwp2gk6Xw+HlR5N0Aq4XajbFFTGn21zkbFsFc35fjWslSXMmqj25fdJPu0dFF1LJkgmTF/HajtxWsDu4TUJJAaARSCrmSghL1UFHd3Wph9IPvkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkuEasTvbOWdFjnnQycRuYQ2olNopUTxJjis8ntnMvE=;
 b=LzLCIJipJn6kYhtfQbuE0DK1BrOS2q6jPei6uQokDJ+OzeVoHMo+SRAm6EzRtxW65moLto0/gYlClN3ABVprUG8wh42SkSDTb7iIFFVL+/wEG/NZVKlsAWKgi7k4WA07tKs6qMyghDdER6HjUyA630YxlvmNGKOe5UNkofw/LvnkqwaAAzwA0o8+yIlkkYRAemILIoaFVWHJ4lU13fyuXpWGaINrqxYnT3bckWCtXpnNnainbyFb7NKLaz0FO9MkO84RqrckuD7g7AI4pFMYxgaDIRGsWdT259NRYp7m84u3AXtoqatOJyoSU2OZp390yOIodwFOVszW7ZaCIELGmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkuEasTvbOWdFjnnQycRuYQ2olNopUTxJjis8ntnMvE=;
 b=jAq3D8Pto3yoDVUVR2q5wO/HgwDejt9sjcwJz7fxkYE7eFKQlAc3Kiv95/ZlVmXY3J12Kdb78p5IxOmVC8habpLnsO/QzsGzSvK3dz4mgNpw0O3Dtuujm1kaI5+DRoqPMq17+51NnE1lv4Q+ci6rrkncwcM6XCT2q+oH+AdGYFc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 07/15] net/mlx5: IPsec: Add HW crypto offload support
Date:   Thu, 16 Jul 2020 17:04:02 -0700
Message-Id: <20200717000410.55600-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09efac84-e020-4c15-eb15-08d829e5041c
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244858798BA93FEFDB22AEAABE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJEl8oB3tGamXJi9moYIKu+UI06rA1g9rt0TKoNMxgAK4Vz/pwt+5lXHdiUUi24qsLIaHaujR63Sb+T/Ct3wbgaR3CY6zAdxgygvA3aaappeC8eonxEV3/ZNRwH37lsUxx1CaSxG6PYni+gD38q0O90GDnYew9t92wqq/V2MehjjpDxFRSFrhgk7lRkGeWpXGEUC2UEWOMKdMMVNPcrYVq3fPMI6jjvF+kUcvhg17nHi99DDmGSnT3ekvJNCMsny22IEbqvJNtJKu1P8zK1AHSRkRl4K8bwtd42o4AV3AjIjXrVUZr3/md1GDHt6GCOlG9LO07HWniQq7G+WO+QKEvbbMbBKRocSDr9/+ywIqWxhgeydh4FWPdMaaaCeN9w3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(30864003)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WHG3WvvH1kAA0WEXItThOsRFlZJOFCLbJusIBsyHbzVkj+N1enNAfU7e3cTGN1IzzE5T/KXHxzrXGMoFYiVLlCexLpc8n+IR6zsSliIluZNdqHfITaEly+abZdwrkqDymFwtRvTgUQLASXYmn3Lmgjnk6tFmoo/vDVrR/m6j8ryryp0fJD2HZ1j4XD0vSlV7pc3TUWkwYsiVE6evFMs9mKADESIH3CbuOaH3TvJlCZdt2zi5M+XW+jkcRZ+fNrS6VNXJQvo2yfeu+m59HY88/rHb7dt30aomUVfr4JMBDfhhsZLNusbwWxgIban+UAHTKPSFiNLHzHVBL5r7BToWIq+wzlhsNnp6UiN3dV6PAw8PVV4Lr9zP3ExrRk7oIBt526PawP639H3NR46xdtjHb9FdX2MM4UGdHJ1Iw6pwQN3FZNyxcAoTLFQ1ms94q9HAS/dXsdLa3rIQNf/FvkTG6qM7UNU1sxCMmPcMPRXA8g8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09efac84-e020-4c15-eb15-08d829e5041c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:46.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PHY7SlGOv4q8lWJP0Ai45zCJAkcu73hKdAMMljJVEEwGKx/zwrWzmtzYoYQn2DJ3AOG5VVy936v/TqbL6Wpe9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This patch adds support for Connect-X IPsec crypto offload
by implementing the IPsec acceleration layer needed routines,
which delegates IPsec offloads to Connect-X routines.

In Connect-X IPsec, a Security Association (SA) is added or deleted
via allocating a HW context of an encryption/decryption key and
a HW context of a matching SA (IPsec object).
The Security Policy (SP) is added or deleted by creating matching Tx/Rx
steering rules whith an action of encryption/decryption respectively,
executed using the previously allocated SA HW context.

When new xfrm state (SA) is added:
- Use a separate crypto key HW context.
- Create a separate IPsec context in HW to inlcude the SA properties:
 - aes-gcm salt.
 - ICV properties (ICV length, implicit IV).
 - on supported devices also update ESN.
 - associate the allocated crypto key with this IPsec context.

Introduce a new compilation flag MLX5_IPSEC for it.

Downstream patches will implement the Rx,Tx steering
and will add the update esn.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  15 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   1 +
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c |   7 +-
 .../mellanox/mlx5/core/accel/ipsec_offload.c  | 291 ++++++++++++++++++
 .../mellanox/mlx5/core/accel/ipsec_offload.h  |  38 +++
 .../ethernet/mellanox/mlx5/core/accel/tls.c   |   4 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   8 +-
 10 files changed, 372 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 7d7148c9b7440..99f1ec3b2575b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -134,12 +134,25 @@ config MLX5_FPGA_IPSEC
 	mlx5_core driver will include the Innova FPGA core and allow building
 	sandbox-specific client drivers.
 
+config MLX5_IPSEC
+	bool "Mellanox Technologies IPsec Connect-X support"
+	depends on MLX5_CORE_EN
+	depends on XFRM_OFFLOAD
+	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
+	select MLX5_ACCEL
+	default n
+	help
+	Build IPsec support for the Connect-X family of network cards by Mellanox
+	Technologies.
+	Note: If you select this option, the mlx5_core driver will include
+	IPsec support for the Connect-X family.
+
 config MLX5_EN_IPSEC
 	bool "IPSec XFRM cryptography-offload accelaration"
 	depends on MLX5_CORE_EN
 	depends on XFRM_OFFLOAD
 	depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
-	depends on MLX5_FPGA_IPSEC
+	depends on MLX5_FPGA_IPSEC || MLX5_IPSEC
 	default n
 	help
 	  Build support for IPsec cryptography-offload accelaration in the NIC.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 124caec65a347..375c8a2d42fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -64,6 +64,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 # Accelerations & FPGA
 #
+mlx5_core-$(CONFIG_MLX5_IPSEC) += accel/ipsec_offload.o
 mlx5_core-$(CONFIG_MLX5_FPGA_IPSEC) += fpga/ipsec.o
 mlx5_core-$(CONFIG_MLX5_FPGA_TLS)   += fpga/tls.o
 mlx5_core-$(CONFIG_MLX5_ACCEL)      += lib/crypto.o accel/tls.o accel/ipsec.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index 628c8887f0869..09f5ce97af46b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -36,12 +36,17 @@
 #include "accel/ipsec.h"
 #include "mlx5_core.h"
 #include "fpga/ipsec.h"
+#include "accel/ipsec_offload.h"
 
 void mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
 {
-	const struct mlx5_accel_ipsec_ops *ipsec_ops = mlx5_fpga_ipsec_ops(mdev);
+	const struct mlx5_accel_ipsec_ops *ipsec_ops;
 	int err = 0;
 
+	ipsec_ops = (mlx5_ipsec_offload_ops(mdev)) ?
+		     mlx5_ipsec_offload_ops(mdev) :
+		     mlx5_fpga_ipsec_ops(mdev);
+
 	if (!ipsec_ops || !ipsec_ops->init) {
 		mlx5_core_dbg(mdev, "IPsec ops is not supported\n");
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
new file mode 100644
index 0000000000000..1c8923f42b093
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
@@ -0,0 +1,291 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIBt
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "ipsec_offload.h"
+#include "lib/mlx5.h"
+
+#define MLX5_IPSEC_DEV_BASIC_CAPS (MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 | \
+				   MLX5_ACCEL_IPSEC_CAP_LSO)
+struct mlx5_ipsec_sa_ctx {
+	struct rhash_head hash;
+	u32 enc_key_id;
+	u32 ipsec_obj_id;
+	/* hw ctx */
+	struct mlx5_core_dev *dev;
+	struct mlx5_ipsec_esp_xfrm *mxfrm;
+};
+
+struct mlx5_ipsec_esp_xfrm {
+	/* reference counter of SA ctx */
+	struct mlx5_ipsec_sa_ctx *sa_ctx;
+	struct mutex lock; /* protects mlx5_ipsec_esp_xfrm */
+	struct mlx5_accel_esp_xfrm accel_xfrm;
+};
+
+static u32 mlx5_ipsec_offload_device_caps(struct mlx5_core_dev *mdev)
+{
+	u32 caps = MLX5_IPSEC_DEV_BASIC_CAPS;
+
+	if (!mlx5_is_ipsec_device(mdev))
+		return 0;
+
+	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
+	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
+		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
+
+	if (MLX5_CAP_IPSEC(mdev, ipsec_esn)) {
+		caps |= MLX5_ACCEL_IPSEC_CAP_ESN;
+		caps |= MLX5_ACCEL_IPSEC_CAP_TX_IV_IS_ESN;
+	}
+
+	/* We can accommodate up to 2^24 different IPsec objects
+	 * because we use up to 24 bit in flow table metadata
+	 * to hold the IPsec Object unique handle.
+	 */
+	WARN_ON_ONCE(MLX5_CAP_IPSEC(mdev, log_max_ipsec_offload) > 24);
+	return caps;
+}
+
+static int
+mlx5_ipsec_offload_esp_validate_xfrm_attrs(struct mlx5_core_dev *mdev,
+					   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	if (attrs->replay_type != MLX5_ACCEL_ESP_REPLAY_NONE) {
+		mlx5_core_err(mdev, "Cannot offload xfrm states with anti replay (replay_type = %d)\n",
+			      attrs->replay_type);
+		return -EOPNOTSUPP;
+	}
+
+	if (attrs->keymat_type != MLX5_ACCEL_ESP_KEYMAT_AES_GCM) {
+		mlx5_core_err(mdev, "Only aes gcm keymat is supported (keymat_type = %d)\n",
+			      attrs->keymat_type);
+		return -EOPNOTSUPP;
+	}
+
+	if (attrs->keymat.aes_gcm.iv_algo !=
+	    MLX5_ACCEL_ESP_AES_GCM_IV_ALGO_SEQ) {
+		mlx5_core_err(mdev, "Only iv sequence algo is supported (iv_algo = %d)\n",
+			      attrs->keymat.aes_gcm.iv_algo);
+		return -EOPNOTSUPP;
+	}
+
+	if (attrs->keymat.aes_gcm.key_len != 128 &&
+	    attrs->keymat.aes_gcm.key_len != 256) {
+		mlx5_core_err(mdev, "Cannot offload xfrm states with key length other than 128/256 bit (key length = %d)\n",
+			      attrs->keymat.aes_gcm.key_len);
+		return -EOPNOTSUPP;
+	}
+
+	if ((attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) &&
+	    !MLX5_CAP_IPSEC(mdev, ipsec_esn)) {
+		mlx5_core_err(mdev, "Cannot offload xfrm states with ESN triggered\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static struct mlx5_accel_esp_xfrm *
+mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
+				   const struct mlx5_accel_esp_xfrm_attrs *attrs,
+				   u32 flags)
+{
+	struct mlx5_ipsec_esp_xfrm *mxfrm;
+	int err = 0;
+
+	err = mlx5_ipsec_offload_esp_validate_xfrm_attrs(mdev, attrs);
+	if (err)
+		return ERR_PTR(err);
+
+	mxfrm = kzalloc(sizeof(*mxfrm), GFP_KERNEL);
+	if (!mxfrm)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&mxfrm->lock);
+	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
+	       sizeof(mxfrm->accel_xfrm.attrs));
+
+	return &mxfrm->accel_xfrm;
+}
+
+static void mlx5_ipsec_offload_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+{
+	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
+							 accel_xfrm);
+
+	/* assuming no sa_ctx are connected to this xfrm_ctx */
+	WARN_ON(mxfrm->sa_ctx);
+	kfree(mxfrm);
+}
+
+struct mlx5_ipsec_obj_attrs {
+	const struct aes_gcm_keymat *aes_gcm;
+	u32 accel_flags;
+	u32 esn_msb;
+	u32 enc_key_id;
+};
+
+static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
+				 struct mlx5_ipsec_obj_attrs *attrs,
+				 u32 *ipsec_id)
+{
+	const struct aes_gcm_keymat *aes_gcm = attrs->aes_gcm;
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
+	void *obj, *salt_p, *salt_iv_p;
+	int err;
+
+	obj = MLX5_ADDR_OF(create_ipsec_obj_in, in, ipsec_object);
+
+	/* salt and seq_iv */
+	salt_p = MLX5_ADDR_OF(ipsec_obj, obj, salt);
+	memcpy(salt_p, &aes_gcm->salt, sizeof(aes_gcm->salt));
+
+	switch (aes_gcm->icv_len) {
+	case 64:
+		MLX5_SET(ipsec_obj, obj, icv_length,
+			 MLX5_IPSEC_OBJECT_ICV_LEN_8B);
+		break;
+	case 96:
+		MLX5_SET(ipsec_obj, obj, icv_length,
+			 MLX5_IPSEC_OBJECT_ICV_LEN_12B);
+		break;
+	case 128:
+		MLX5_SET(ipsec_obj, obj, icv_length,
+			 MLX5_IPSEC_OBJECT_ICV_LEN_16B);
+		break;
+	default:
+		return -EINVAL;
+	}
+	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
+	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
+	/* esn */
+	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
+		MLX5_SET(ipsec_obj, obj, esn_en, 1);
+		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
+		if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
+			MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
+	}
+
+	MLX5_SET(ipsec_obj, obj, dekn, attrs->enc_key_id);
+
+	/* general object fields set */
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*ipsec_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	return err;
+}
+
+static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
+					      struct mlx5_accel_esp_xfrm *accel_xfrm,
+					      const __be32 saddr[4], const __be32 daddr[4],
+					      const __be32 spi, bool is_ipv6, u32 *hw_handle)
+{
+	struct mlx5_accel_esp_xfrm_attrs *xfrm_attrs = &accel_xfrm->attrs;
+	struct aes_gcm_keymat *aes_gcm = &xfrm_attrs->keymat.aes_gcm;
+	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
+	struct mlx5_ipsec_esp_xfrm *mxfrm;
+	struct mlx5_ipsec_sa_ctx *sa_ctx;
+	int err;
+
+	/* alloc SA context */
+	sa_ctx = kzalloc(sizeof(*sa_ctx), GFP_KERNEL);
+	if (!sa_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	sa_ctx->dev = mdev;
+
+	mxfrm = container_of(accel_xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
+	mutex_lock(&mxfrm->lock);
+	sa_ctx->mxfrm = mxfrm;
+
+	/* key */
+	err = mlx5_create_encryption_key(mdev, aes_gcm->aes_key,
+					 aes_gcm->key_len / BITS_PER_BYTE,
+					 MLX5_ACCEL_OBJ_IPSEC_KEY,
+					 &sa_ctx->enc_key_id);
+	if (err) {
+		mlx5_core_dbg(mdev, "Failed to create encryption key (err = %d)\n", err);
+		goto err_sa_ctx;
+	}
+
+	ipsec_attrs.aes_gcm = aes_gcm;
+	ipsec_attrs.accel_flags = accel_xfrm->attrs.flags;
+	ipsec_attrs.esn_msb = accel_xfrm->attrs.esn;
+	ipsec_attrs.enc_key_id = sa_ctx->enc_key_id;
+	err = mlx5_create_ipsec_obj(mdev, &ipsec_attrs,
+				    &sa_ctx->ipsec_obj_id);
+	if (err) {
+		mlx5_core_dbg(mdev, "Failed to create IPsec object (err = %d)\n", err);
+		goto err_enc_key;
+	}
+
+	*hw_handle = sa_ctx->ipsec_obj_id;
+	mxfrm->sa_ctx = sa_ctx;
+	mutex_unlock(&mxfrm->lock);
+
+	return sa_ctx;
+
+err_enc_key:
+	mlx5_destroy_encryption_key(mdev, sa_ctx->enc_key_id);
+err_sa_ctx:
+	mutex_unlock(&mxfrm->lock);
+	kfree(sa_ctx);
+	return ERR_PTR(err);
+}
+
+static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
+{
+	struct mlx5_ipsec_sa_ctx *sa_ctx = (struct mlx5_ipsec_sa_ctx *)context;
+	struct mlx5_ipsec_esp_xfrm *mxfrm = sa_ctx->mxfrm;
+
+	mutex_lock(&mxfrm->lock);
+	mlx5_destroy_ipsec_obj(sa_ctx->dev, sa_ctx->ipsec_obj_id);
+	mlx5_destroy_encryption_key(sa_ctx->dev, sa_ctx->enc_key_id);
+	kfree(sa_ctx);
+	mxfrm->sa_ctx = NULL;
+	mutex_unlock(&mxfrm->lock);
+}
+
+static int mlx5_ipsec_offload_init(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
+
+static const struct mlx5_accel_ipsec_ops ipsec_offload_ops = {
+	.device_caps = mlx5_ipsec_offload_device_caps,
+	.create_hw_context = mlx5_ipsec_offload_create_sa_ctx,
+	.free_hw_context = mlx5_ipsec_offload_delete_sa_ctx,
+	.init = mlx5_ipsec_offload_init,
+	.esp_create_xfrm = mlx5_ipsec_offload_esp_create_xfrm,
+	.esp_destroy_xfrm = mlx5_ipsec_offload_esp_destroy_xfrm,
+};
+
+const struct mlx5_accel_ipsec_ops *mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev)
+{
+	if (!mlx5_ipsec_offload_device_caps(mdev))
+		return NULL;
+
+	return &ipsec_offload_ops;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
new file mode 100644
index 0000000000000..970c66d19c1dc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_IPSEC_OFFLOAD_H__
+#define __MLX5_IPSEC_OFFLOAD_H__
+
+#include <linux/mlx5/driver.h>
+#include "accel/ipsec.h"
+
+#ifdef CONFIG_MLX5_IPSEC
+
+const struct mlx5_accel_ipsec_ops *mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev);
+static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
+{
+	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
+		return false;
+
+	if (!MLX5_CAP_GEN(mdev, log_max_dek))
+		return false;
+
+	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
+	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
+		return false;
+
+	return MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
+		MLX5_CAP_ETH(mdev, insert_trailer);
+}
+
+#else
+static inline const struct mlx5_accel_ipsec_ops *
+mlx5_ipsec_offload_ops(struct mlx5_core_dev *mdev) { return NULL; }
+static inline bool mlx5_is_ipsec_device(struct mlx5_core_dev *mdev)
+{
+	return false;
+}
+
+#endif /* CONFIG_MLX5_IPSEC */
+#endif /* __MLX5_IPSEC_OFFLOAD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
index cbf3d76c05a88..6c2b86a26863b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
@@ -113,7 +113,9 @@ int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
 		return -EINVAL;
 	}
 
-	return mlx5_create_encryption_key(mdev, key, sz_bytes, p_key_id);
+	return mlx5_create_encryption_key(mdev, key, sz_bytes,
+					  MLX5_ACCEL_OBJ_TLS_KEY,
+					  p_key_id);
 }
 
 void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 8d797cd56e264..147191b7a98a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -111,7 +111,7 @@ static void mlx5e_ipsec_sadb_rx_del(struct mlx5e_ipsec_sa_entry *sa_entry)
 static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct xfrm_replay_state_esn *replay_esn;
-	u32 seq_bottom;
+	u32 seq_bottom = 0;
 	u8 overlap;
 	u32 *esn;
 
@@ -121,7 +121,9 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 
 	replay_esn = sa_entry->x->replay_esn;
-	seq_bottom = replay_esn->seq - replay_esn->replay_window + 1;
+	if (replay_esn->seq >= replay_esn->replay_window)
+		seq_bottom = replay_esn->seq - replay_esn->replay_window + 1;
+
 	overlap = sa_entry->esn_state.overlap;
 
 	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index c3095863372cd..02558ac2ace69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -250,6 +250,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, ipsec_offload)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_IPSEC);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index dcea87ec59770..57eb91bcbca79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -6,7 +6,7 @@
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       void *key, u32 sz_bytes,
-			       u32 *p_key_id)
+			       u32 key_type, u32 *p_key_id)
 {
 	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
@@ -41,8 +41,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 	memcpy(key_p, key, sz_bytes);
 
 	MLX5_SET(encryption_key_obj, obj, key_size, general_obj_key_size);
-	MLX5_SET(encryption_key_obj, obj, key_type,
-		 MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS);
+	MLX5_SET(encryption_key_obj, obj, key_type, key_type);
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
 		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 249539247e2e7..d046db7bb047d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -80,8 +80,14 @@ void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats)
 int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
 
 /* Crypto */
+enum {
+	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS,
+	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC,
+};
+
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
-			       void *key, u32 sz_bytes, u32 *p_key_id);
+			       void *key, u32 sz_bytes,
+			       u32 key_type, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
 
 static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
-- 
2.26.2

