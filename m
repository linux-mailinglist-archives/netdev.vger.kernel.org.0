Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7876D6EA11C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjDUBjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbjDUBjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA640EF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325AE642F7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDAEC433EF;
        Fri, 21 Apr 2023 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041168;
        bh=PaoqT1KxHcYsLrx4cBn73855HjSchbWu6yopB+S5Zhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djqIXYKYroPDcLmHqAqMtCYGnNqFjdTPqytNmDTg0UDN16sO+V7YLlJtj+SyplvRf
         joeUgEjDj68BhtJpiJhmC2aJtnvAiZ4JPIPKW88RjZD0yEoHDBTTaZzmTC1G5U6R6M
         1j1K7kKqzBdwln4o0cd7la3jJDHJje+C0aGWln/l/RSj72gSsF+gmZ706QfzvOKUUu
         MNc/QucfsIfo4JZrOSpSKlUXGzzl46V3dibfft76C7y0tRT6AcG4eHY/udaaig60h5
         ELvGjVsCrzi41FBQNwOmDRNxBdZWNyNuiVg0Dp1cXk08Uz4rhmWGLGuXHn+fGaRO4L
         x03VZIbw7rRwA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Add vnic devlink health reporter to PFs/VFs
Date:   Thu, 20 Apr 2023 18:38:42 -0700
Message-Id: <20230421013850.349646-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

Create a vnic devlink health reporter for PFs/VFs interfaces.
The reporter's diagnose callback displays the values of vNIC/vport
transport debug counters of PFs/VFs, as follows:

$ devlink health diagnose pci/0000:08:00.0 reporter vnic
 vNIC env counters:
    total_error_queues: 0 send_queue_priority_update_flow: 0
    comp_eq_overrun: 0 async_eq_overrun: 0 cq_overrun: 0
    invalid_command: 0 quota_exceeded_command: 0
    nic_receive_steering_discard: 0

Moreover, add documentation on the reporter functionality and the
counters description.

While at it, expose the vNIC counters diagnose function to be used by
the downstream patch, which will reveal the counters for representor
interfaces.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst        |  30 +++++
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/diag/reporter_vnic.c   | 125 ++++++++++++++++++
 .../mellanox/mlx5/core/diag/reporter_vnic.h   |  16 +++
 .../net/ethernet/mellanox/mlx5/core/health.c  |   4 +
 include/linux/mlx5/driver.h                   |   1 +
 6 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 0995e4e5acd7..ceab18e46456 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -257,3 +257,33 @@ User commands examples:
     $ devlink health dump show pci/0000:82:00.1 reporter fw_fatal
 
 NOTE: This command can run only on PF.
+
+vnic reporter
+-------------
+The vnic reporter implements only the `diagnose` callback.
+It is responsible for querying the vnic diagnostic counters from fw and displaying
+them in realtime.
+
+Description of the vnic counters:
+total_q_under_processor_handle: number of queues in an error state due to
+an async error or errored command.
+send_queue_priority_update_flow: number of QP/SQ priority/SL update
+events.
+cq_overrun: number of times CQ entered an error state due to an
+overflow.
+async_eq_overrun: number of times an EQ mapped to async events was
+overrun.
+comp_eq_overrun: number of times an EQ mapped to completion events was
+overrun.
+quota_exceeded_command: number of commands issued and failed due to quota
+exceeded.
+invalid_command: number of commands issued and failed dues to any reason
+other than quota exceeded.
+nic_receive_steering_discard: number of packets that completed RX flow
+steering but were discarded due to a mismatch in flow table.
+
+User commands examples:
+- Diagnose PF/VF vnic counters
+        $ devlink health diagnose pci/0000:82:00.1 reporter vnic
+
+NOTE: This command can run only on PF/VF ports.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 68f6a4544f7e..ddf1e352f51d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -16,7 +16,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o fs_ft_pool.o rl.o lag/debugfs.o lag/lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
-		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
+		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o diag/reporter_vnic.o \
 		fw_reset.o qos.o lib/tout.o lib/aso.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
new file mode 100644
index 000000000000..9114661cd967
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. */
+
+#include "reporter_vnic.h"
+#include "devlink.h"
+
+#define VNIC_ENV_GET64(vnic_env_stats, c) \
+	MLX5_GET64(query_vnic_env_out, (vnic_env_stats)->query_vnic_env_out, \
+		 vport_env.c)
+
+struct mlx5_vnic_diag_stats {
+	__be64 query_vnic_env_out[MLX5_ST_SZ_QW(query_vnic_env_out)];
+};
+
+int mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
+					 struct devlink_fmsg *fmsg,
+					 u16 vport_num, bool other_vport)
+{
+	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
+	struct mlx5_vnic_diag_stats vnic;
+	int err;
+
+	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
+	MLX5_SET(query_vnic_env_in, in, vport_number, vport_num);
+	MLX5_SET(query_vnic_env_in, in, other_vport, !!other_vport);
+
+	err = mlx5_cmd_exec_inout(dev, query_vnic_env, in, &vnic.query_vnic_env_out);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, "vNIC env counters");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "total_error_queues",
+					VNIC_ENV_GET64(&vnic, total_error_queues));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "send_queue_priority_update_flow",
+					VNIC_ENV_GET64(&vnic, send_queue_priority_update_flow));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "comp_eq_overrun",
+					VNIC_ENV_GET64(&vnic, comp_eq_overrun));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "async_eq_overrun",
+					VNIC_ENV_GET64(&vnic, async_eq_overrun));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "cq_overrun",
+					VNIC_ENV_GET64(&vnic, cq_overrun));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "invalid_command",
+					VNIC_ENV_GET64(&vnic, invalid_command));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "quota_exceeded_command",
+					VNIC_ENV_GET64(&vnic, quota_exceeded_command));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_pair_put(fmsg, "nic_receive_steering_discard",
+					VNIC_ENV_GET64(&vnic, nic_receive_steering_discard));
+	if (err)
+		return err;
+
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int mlx5_reporter_vnic_diagnose(struct devlink_health_reporter *reporter,
+				       struct devlink_fmsg *fmsg,
+				       struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
+
+	return mlx5_reporter_vnic_diagnose_counters(dev, fmsg, 0, false);
+}
+
+static const struct devlink_health_reporter_ops mlx5_reporter_vnic_ops = {
+	.name = "vnic",
+	.diagnose = mlx5_reporter_vnic_diagnose,
+};
+
+void mlx5_reporter_vnic_create(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	health->vnic_reporter =
+		devlink_health_reporter_create(devlink,
+					       &mlx5_reporter_vnic_ops,
+					       0, dev);
+	if (IS_ERR(health->vnic_reporter))
+		mlx5_core_warn(dev,
+			       "Failed to create vnic reporter, err = %ld\n",
+			       PTR_ERR(health->vnic_reporter));
+}
+
+void mlx5_reporter_vnic_destroy(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	if (!IS_ERR_OR_NULL(health->vnic_reporter))
+		devlink_health_reporter_destroy(health->vnic_reporter);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.h
new file mode 100644
index 000000000000..eba87a39e9b1
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef __MLX5_REPORTER_VNIC_H
+#define __MLX5_REPORTER_VNIC_H
+
+#include "mlx5_core.h"
+
+void mlx5_reporter_vnic_create(struct mlx5_core_dev *dev);
+void mlx5_reporter_vnic_destroy(struct mlx5_core_dev *dev);
+
+int mlx5_reporter_vnic_diagnose_counters(struct mlx5_core_dev *dev,
+					 struct devlink_fmsg *fmsg,
+					 u16 vport_num, bool other_vport);
+
+#endif /* __MLX5_REPORTER_VNIC_H */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 016c5f99c470..871c32dda66e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -42,6 +42,7 @@
 #include "lib/pci_vsc.h"
 #include "lib/tout.h"
 #include "diag/fw_tracer.h"
+#include "diag/reporter_vnic.h"
 
 enum {
 	MAX_MISSES			= 3,
@@ -898,6 +899,7 @@ void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 
 	cancel_delayed_work_sync(&health->update_fw_log_ts_work);
 	destroy_workqueue(health->wq);
+	mlx5_reporter_vnic_destroy(dev);
 	mlx5_fw_reporters_destroy(dev);
 }
 
@@ -907,6 +909,7 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	char *name;
 
 	mlx5_fw_reporters_create(dev);
+	mlx5_reporter_vnic_create(dev);
 
 	health = &dev->priv.health;
 	name = kmalloc(64, GFP_KERNEL);
@@ -926,6 +929,7 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	return 0;
 
 out_err:
+	mlx5_reporter_vnic_destroy(dev);
 	mlx5_fw_reporters_destroy(dev);
 	return -ENOMEM;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 135a3c8d8237..5d25c4c73046 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -439,6 +439,7 @@ struct mlx5_core_health {
 	struct work_struct		report_work;
 	struct devlink_health_reporter *fw_reporter;
 	struct devlink_health_reporter *fw_fatal_reporter;
+	struct devlink_health_reporter *vnic_reporter;
 	struct delayed_work		update_fw_log_ts_work;
 };
 
-- 
2.39.2

