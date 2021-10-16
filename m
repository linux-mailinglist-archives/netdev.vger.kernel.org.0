Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C2742FF79
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhJPAlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236655AbhJPAlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7624761245;
        Sat, 16 Oct 2021 00:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344744;
        bh=09GipYYgS1ppxLSKiufRdaY95dHzxfGWveeWloBXus8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm4Z6mSDyQJRIjhhXnZPiwkvA9oKewrI1qrZ9BeYkGOJsH8j2xBEvYC8XTtUMMsZb
         66+GGULl7Qrvnr2/8YQYb5WkORHgCzRWp9YJCmfcj+IaMS0kAxw6xqs/4w6EjLbfAl
         kCA9BCMu3Wya4nDJt068w5rTvemSVM8muHpeYtS26q8UoOvt9ADmoJaB1SuHfT6iU2
         ViMuYMswF9PjiDMGH1LlKGjhC9xdrjkmLrItGWa5pEt7YrIERtb5RXF6snNU+n+Riv
         HoQfyKWkQBcFg3OM/5M8HGRCinXcLFaxpJjfh8DX9akOdipfMYdIcf0Zj+AY0c3KeO
         Bi3n/bBWG76+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Amir Tzin <amirtz@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/13] net/mlx5: Read timeout values from init segment
Date:   Fri, 15 Oct 2021 17:38:51 -0700
Message-Id: <20211016003902.57116-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amir Tzin <amirtz@mellanox.com>

Replace hard coded timeouts with values stored in firmware's init
segment. Timeouts are read from init segment during driver load. If init
segment timeouts are not supported then fallback to hard coded defaults
instead. Also move pre initialization timeouts which cannot be read from
firmware to the new mechanism.

Signed-off-by: Amir Tzin <amirtz@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 18 +++-
 .../ethernet/mellanox/mlx5/core/lib/tout.c    | 96 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/tout.h    | 28 ++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 38 ++++----
 include/linux/mlx5/driver.h                   |  5 +-
 6 files changed, 161 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 63032cd6efb1..a151575be51f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -17,7 +17,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		fs_counters.o fs_ft_pool.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
-		fw_reset.o qos.o
+		fw_reset.o qos.o lib/tout.o
 
 #
 # Netdev basic
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 4dc3a822907a..f71ec4d9d68e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -45,6 +45,7 @@
 
 #include "mlx5_core.h"
 #include "lib/eq.h"
+#include "lib/tout.h"
 
 enum {
 	CMD_IF_REV = 5,
@@ -225,9 +226,13 @@ static void set_signature(struct mlx5_cmd_work_ent *ent, int csum)
 
 static void poll_timeout(struct mlx5_cmd_work_ent *ent)
 {
-	unsigned long poll_end = jiffies + msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC + 1000);
+	struct mlx5_core_dev *dev = container_of(ent->cmd, struct mlx5_core_dev, cmd);
+	u64 cmd_to_ms = mlx5_tout_ms(dev, CMD);
+	unsigned long poll_end;
 	u8 own;
 
+	poll_end = jiffies + msecs_to_jiffies(cmd_to_ms + 1000);
+
 	do {
 		own = READ_ONCE(ent->lay->status_own);
 		if (!(own & CMD_OWNER_HW)) {
@@ -925,15 +930,18 @@ static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
 	struct mlx5_cmd *cmd = ent->cmd;
-	struct mlx5_core_dev *dev = container_of(cmd, struct mlx5_core_dev, cmd);
-	unsigned long cb_timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC);
+	bool poll_cmd = ent->polling;
 	struct mlx5_cmd_layout *lay;
+	struct mlx5_core_dev *dev;
+	unsigned long cb_timeout;
 	struct semaphore *sem;
 	unsigned long flags;
-	bool poll_cmd = ent->polling;
 	int alloc_ret;
 	int cmd_mode;
 
+	dev = container_of(cmd, struct mlx5_core_dev, cmd);
+	cb_timeout = msecs_to_jiffies(mlx5_tout_ms(dev, CMD));
+
 	complete(&ent->handling);
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
@@ -1073,7 +1081,7 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 {
-	unsigned long timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC);
+	unsigned long timeout = msecs_to_jiffies(mlx5_tout_ms(dev, CMD));
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
new file mode 100644
index 000000000000..ee266e0d122a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/mlx5/driver.h>
+#include "lib/tout.h"
+
+struct mlx5_timeouts {
+	u64 to[MAX_TIMEOUT_TYPES];
+};
+
+static const u32 tout_def_sw_val[MAX_TIMEOUT_TYPES] = {
+	[MLX5_TO_FW_PRE_INIT_TIMEOUT_MS] = 120000,
+	[MLX5_TO_FW_PRE_INIT_WARN_MESSAGE_INTERVAL_MS] = 20000,
+	[MLX5_TO_FW_PRE_INIT_WAIT_MS] = 2,
+	[MLX5_TO_FW_INIT_MS] = 2000,
+	[MLX5_TO_CMD_MS] = 60000
+};
+
+static void tout_set(struct mlx5_core_dev *dev, u64 val, enum mlx5_timeouts_types type)
+{
+	dev->timeouts->to[type] = val;
+}
+
+static void tout_set_def_val(struct mlx5_core_dev *dev)
+{
+	int i;
+
+	for (i = MLX5_TO_FW_PRE_INIT_TIMEOUT_MS; i < MAX_TIMEOUT_TYPES; i++)
+		tout_set(dev, tout_def_sw_val[i], i);
+}
+
+int mlx5_tout_init(struct mlx5_core_dev *dev)
+{
+	dev->timeouts = kmalloc(sizeof(*dev->timeouts), GFP_KERNEL);
+	if (!dev->timeouts)
+		return -ENOMEM;
+
+	tout_set_def_val(dev);
+	return 0;
+}
+
+void mlx5_tout_cleanup(struct mlx5_core_dev *dev)
+{
+	kfree(dev->timeouts);
+}
+
+/* Time register consists of two fields to_multiplier(time out multiplier)
+ * and to_value(time out value). to_value is the quantity of the time units and
+ * to_multiplier is the type and should be one off these four values.
+ * 0x0: millisecond
+ * 0x1: seconds
+ * 0x2: minutes
+ * 0x3: hours
+ * this function converts the time stored in the two register fields into
+ * millisecond.
+ */
+static u64 tout_convert_reg_field_to_ms(u32 to_mul, u32 to_val)
+{
+	u64 msec = to_val;
+
+	to_mul &= 0x3;
+	/* convert hours/minutes/seconds to miliseconds */
+	if (to_mul)
+		msec *= 1000 * int_pow(60, to_mul - 1);
+
+	return msec;
+}
+
+static u64 tout_convert_iseg_to_ms(u32 iseg_to)
+{
+	return tout_convert_reg_field_to_ms(iseg_to >> 29, iseg_to & 0xfffff);
+}
+
+static bool tout_is_supported(struct mlx5_core_dev *dev)
+{
+	return !!ioread32be(&dev->iseg->cmd_q_init_to);
+}
+
+void mlx5_tout_query_iseg(struct mlx5_core_dev *dev)
+{
+	u32 to;
+
+	if (!tout_is_supported(dev))
+		return;
+
+	to = ioread32be(&dev->iseg->cmd_q_init_to);
+	tout_set(dev, tout_convert_iseg_to_ms(to), MLX5_TO_FW_INIT_MS);
+
+	to = ioread32be(&dev->iseg->cmd_exec_to);
+	tout_set(dev, tout_convert_iseg_to_ms(to), MLX5_TO_CMD_MS);
+}
+
+u64 _mlx5_tout_ms(struct mlx5_core_dev *dev, enum mlx5_timeouts_types type)
+{
+	return dev->timeouts->to[type];
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
new file mode 100644
index 000000000000..7e6fc61c5b45
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef MLX5_TIMEOUTS_H
+#define MLX5_TIMEOUTS_H
+
+enum mlx5_timeouts_types {
+	/* pre init timeouts (not read from FW) */
+	MLX5_TO_FW_PRE_INIT_TIMEOUT_MS,
+	MLX5_TO_FW_PRE_INIT_WARN_MESSAGE_INTERVAL_MS,
+	MLX5_TO_FW_PRE_INIT_WAIT_MS,
+
+	/* init segment timeouts */
+	MLX5_TO_FW_INIT_MS,
+	MLX5_TO_CMD_MS,
+
+	MAX_TIMEOUT_TYPES
+};
+
+struct mlx5_core_dev;
+int mlx5_tout_init(struct mlx5_core_dev *dev);
+void mlx5_tout_cleanup(struct mlx5_core_dev *dev);
+void mlx5_tout_query_iseg(struct mlx5_core_dev *dev);
+u64 _mlx5_tout_ms(struct mlx5_core_dev *dev, enum mlx5_timeouts_types type);
+
+#define mlx5_tout_ms(dev, type) _mlx5_tout_ms(dev, MLX5_TO_##type##_MS)
+
+# endif /* MLX5_TIMEOUTS_H */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 65313448a47c..b4893eac6ed6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -60,6 +60,7 @@
 #include "devlink.h"
 #include "fw_reset.h"
 #include "lib/mlx5.h"
+#include "lib/tout.h"
 #include "fpga/core.h"
 #include "fpga/ipsec.h"
 #include "accel/ipsec.h"
@@ -176,11 +177,6 @@ static struct mlx5_profile profile[] = {
 	},
 };
 
-#define FW_INIT_TIMEOUT_MILI		2000
-#define FW_INIT_WAIT_MS			2
-#define FW_PRE_INIT_TIMEOUT_MILI	120000
-#define FW_INIT_WARN_MESSAGE_INTERVAL	20000
-
 static int fw_initializing(struct mlx5_core_dev *dev)
 {
 	return ioread32be(&dev->iseg->initializing) >> 31;
@@ -193,8 +189,6 @@ static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
 	unsigned long end = jiffies + msecs_to_jiffies(max_wait_mili);
 	int err = 0;
 
-	BUILD_BUG_ON(FW_PRE_INIT_TIMEOUT_MILI < FW_INIT_WARN_MESSAGE_INTERVAL);
-
 	while (fw_initializing(dev)) {
 		if (time_after(jiffies, end)) {
 			err = -EBUSY;
@@ -205,7 +199,7 @@ static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
 				       jiffies_to_msecs(end - warn) / 1000);
 			warn = jiffies + msecs_to_jiffies(warn_time_mili);
 		}
-		msleep(FW_INIT_WAIT_MS);
+		msleep(mlx5_tout_ms(dev, FW_PRE_INIT_WAIT));
 	}
 
 	return err;
@@ -975,25 +969,34 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 	if (mlx5_core_is_pf(dev))
 		pcie_print_link_status(dev->pdev);
 
+	err = mlx5_tout_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed initializing timeouts, aborting\n");
+		return err;
+	}
+
 	/* wait for firmware to accept initialization segments configurations
 	 */
-	err = wait_fw_init(dev, FW_PRE_INIT_TIMEOUT_MILI, FW_INIT_WARN_MESSAGE_INTERVAL);
+	err = wait_fw_init(dev, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT),
+			   mlx5_tout_ms(dev, FW_PRE_INIT_WARN_MESSAGE_INTERVAL));
 	if (err) {
-		mlx5_core_err(dev, "Firmware over %d MS in pre-initializing state, aborting\n",
-			      FW_PRE_INIT_TIMEOUT_MILI);
-		return err;
+		mlx5_core_err(dev, "Firmware over %llu MS in pre-initializing state, aborting\n",
+			      mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
+		goto err_tout_cleanup;
 	}
 
 	err = mlx5_cmd_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed initializing command interface, aborting\n");
-		return err;
+		goto err_tout_cleanup;
 	}
 
-	err = wait_fw_init(dev, FW_INIT_TIMEOUT_MILI, 0);
+	mlx5_tout_query_iseg(dev);
+
+	err = wait_fw_init(dev, mlx5_tout_ms(dev, FW_INIT), 0);
 	if (err) {
-		mlx5_core_err(dev, "Firmware over %d MS in initializing state, aborting\n",
-			      FW_INIT_TIMEOUT_MILI);
+		mlx5_core_err(dev, "Firmware over %llu MS in initializing state, aborting\n",
+			      mlx5_tout_ms(dev, FW_INIT));
 		goto err_cmd_cleanup;
 	}
 
@@ -1062,6 +1065,8 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 err_cmd_cleanup:
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
+err_tout_cleanup:
+	mlx5_tout_cleanup(dev);
 
 	return err;
 }
@@ -1080,6 +1085,7 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	mlx5_core_disable_hca(dev, 0);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
+	mlx5_tout_cleanup(dev);
 
 	return 0;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ccbd87fbd3bf..fb06e8870aee 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -66,10 +66,6 @@ enum {
 };
 
 enum {
-	/* one minute for the sake of bringup. Generally, commands must always
-	 * complete and we may need to increase this timeout value
-	 */
-	MLX5_CMD_TIMEOUT_MSEC	= 60 * 1000,
 	MLX5_CMD_WQ_MAX_NAME	= 32,
 };
 
@@ -755,6 +751,7 @@ struct mlx5_core_dev {
 		u32 qcam[MLX5_ST_SZ_DW(qcam_reg)];
 		u8  embedded_cpu;
 	} caps;
+	struct mlx5_timeouts	*timeouts;
 	u64			sys_image_guid;
 	phys_addr_t		iseg_base;
 	struct mlx5_init_seg __iomem *iseg;
-- 
2.31.1

