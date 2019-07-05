Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD18E60955
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfGEPaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:30:52 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52397 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727624AbfGEPat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:49 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOc029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 03/12] net/mlx5: Add crypto library to support create/destroy encryption key
Date:   Fri,  5 Jul 2019 18:30:13 +0300
Message-Id: <1562340622-4423-4-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Encryption key create / destroy is done via
CREATE_GENERAL_OBJECT / DESTROY_GENERAL_OBJECT commands.

To be used in downstream patches by TLS API wrappers, to configure
the TIS context with the encryption key.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   | 72 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 ++
 3 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index d3409870646a..5a1ee9ec8659 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -55,7 +55,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 mlx5_core-$(CONFIG_MLX5_FPGA_IPSEC) += fpga/ipsec.o
 mlx5_core-$(CONFIG_MLX5_FPGA_TLS)   += fpga/tls.o
-mlx5_core-$(CONFIG_MLX5_ACCEL)      += accel/tls.o accel/ipsec.o
+mlx5_core-$(CONFIG_MLX5_ACCEL)      += lib/crypto.o accel/tls.o accel/ipsec.o
 
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
new file mode 100644
index 000000000000..ea9ee88491e5
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "mlx5_core.h"
+
+int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
+			       void *key, u32 sz_bytes,
+			       u32 *p_key_id)
+{
+	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	u32 sz_bits = sz_bytes * BITS_PER_BYTE;
+	u8  general_obj_key_size;
+	u64 general_obj_types;
+	void *obj, *key_p;
+	int err;
+
+	obj = MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object);
+	key_p = MLX5_ADDR_OF(encryption_key_obj, obj, key);
+
+	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
+	if (!(general_obj_types &
+	      MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY))
+		return -EINVAL;
+
+	switch (sz_bits) {
+	case 128:
+		general_obj_key_size =
+			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128;
+		break;
+	case 256:
+		general_obj_key_size =
+			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	memcpy(key_p, key, sz_bytes);
+
+	MLX5_SET(encryption_key_obj, obj, key_size, general_obj_key_size);
+	MLX5_SET(encryption_key_obj, obj, key_type,
+		 MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_DEK);
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	MLX5_SET(encryption_key_obj, obj, pd, mdev->mlx5e_res.pdn);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*p_key_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	/* avoid leaking key on the stack */
+	memzero_explicit(in, sizeof(in));
+
+	return err;
+}
+
+void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, key_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index d918e44491f4..b99d469e4e64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -79,4 +79,9 @@ struct mlx5_pme_stats {
 void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
 int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
 
+/* Crypto */
+int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
+			       void *key, u32 sz_bytes, u32 *p_key_id);
+void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
+
 #endif
-- 
1.8.3.1

