Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DE14146B3
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhIVKlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235237AbhIVKkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:40:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE2AD6127B;
        Wed, 22 Sep 2021 10:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632307165;
        bh=xOTZ47fmx+uIZvI/Fo0JFPpoeZXkq/9twGVoQpazB4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmY0naqBax2lSjpsiQSvd+dw10WvvYR0dCwpnDYR0RCMZa7w4Xed83rLxdR8UCz/u
         y8idDe0zzF64Yn+fxLnh1q1k5zaVD1lYHPXYWtPksGjp1NsSdvd946gEvtfAt9BKip
         6bGV+nnxS0amkTfqIQkJMnvp1X/UUDGWHMjOHUJkCJmwUnZMERFZR2SlfIl72PGJNJ
         V8+nQWJi60qyKY7iVWkWsf9BEWW7MDHCAuisT0uC5NWRKpON7359RhsySmhfoty/Fz
         5QRdNTdnesXy9s22qvanbgglPUGo9K1GV+JHDEwQC/ZP05ZuxFcQFNvIGra65VHNZS
         N82lKmr0lLgmQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 7/7] mlx5_vfio_pci: Implement vfio_pci driver for mlx5 devices
Date:   Wed, 22 Sep 2021 13:38:56 +0300
Message-Id: <51624515f1fe2d4043e0d10056f65b69f523bdc3.1632305919.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

This patch adds support for vfio_pci driver for mlx5 devices.

It uses vfio_pci_core to register to the VFIO subsystem and then
implements the mlx5 specific logic in the migration area.

The migration implementation follows the definition from uapi/vfio.h and
uses the mlx5 VF->PF command channel to achieve it.

This patch implements the suspend/resume flows.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/Kconfig         |  11 +
 drivers/vfio/pci/Makefile        |   3 +
 drivers/vfio/pci/mlx5_vfio_pci.c | 736 +++++++++++++++++++++++++++++++
 3 files changed, 750 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 860424ccda1b..c10b53028309 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -43,4 +43,15 @@ config VFIO_PCI_IGD
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
 endif
+
+config MLX5_VFIO_PCI
+	tristate "VFIO support for MLX5 PCI devices"
+	depends on MLX5_CORE
+	select VFIO_PCI_CORE
+	help
+	  This provides a PCI support for MLX5 devices using the VFIO
+	  framework. The device specific driver supports suspend/resume
+	  of the MLX5 device.
+
+	  If you don't know what to do here, say N.
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 349d68d242b4..b9448bba0c83 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,3 +7,6 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+
+mlx5-vfio-pci-y := mlx5_vfio_pci.o mlx5_vfio_pci_cmd.o
+obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
diff --git a/drivers/vfio/pci/mlx5_vfio_pci.c b/drivers/vfio/pci/mlx5_vfio_pci.c
new file mode 100644
index 000000000000..710a3ff9cbcc
--- /dev/null
+++ b/drivers/vfio/pci/mlx5_vfio_pci.c
@@ -0,0 +1,736 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/sched/mm.h>
+#include <linux/vfio_pci_core.h>
+
+#include "mlx5_vfio_pci_cmd.h"
+
+enum {
+	MLX5VF_PCI_QUIESCED = 1 << 0,
+	MLX5VF_PCI_FREEZED = 1 << 1,
+};
+
+enum {
+	MLX5VF_REGION_PENDING_BYTES = 1 << 0,
+	MLX5VF_REGION_DATA_SIZE = 1 << 1,
+};
+
+#define MLX5VF_MIG_REGION_DATA_SIZE SZ_128K
+/* Data section offset from migration region */
+#define MLX5VF_MIG_REGION_DATA_OFFSET                                          \
+	(sizeof(struct vfio_device_migration_info))
+
+#define VFIO_DEVICE_MIGRATION_OFFSET(x)                                        \
+	(offsetof(struct vfio_device_migration_info, x))
+
+struct mlx5vf_pci_migration_info {
+	u32 vfio_dev_state; /* VFIO_DEVICE_STATE_XXX */
+	u32 dev_state; /* device migration state */
+	u32 region_state; /* Use MLX5VF_REGION_XXX */
+	u16 vhca_id;
+	struct mlx5_vhca_state_data vhca_state_data;
+};
+
+struct mlx5vf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	u8 migrate_cap:1;
+	struct mlx5vf_pci_migration_info vmig;
+};
+
+static int mlx5vf_pci_unquiesce_device(struct mlx5vf_pci_core_device *mvdev)
+{
+	int ret;
+
+	if (!(mvdev->vmig.dev_state & MLX5VF_PCI_QUIESCED))
+		return 0;
+
+	ret = mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
+				     mvdev->vmig.vhca_id,
+				     MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER);
+	if (ret)
+		return ret;
+
+	mvdev->vmig.dev_state &= ~MLX5VF_PCI_QUIESCED;
+	return 0;
+}
+
+static int mlx5vf_pci_quiesce_device(struct mlx5vf_pci_core_device *mvdev)
+{
+	int ret;
+
+	if (mvdev->vmig.dev_state & MLX5VF_PCI_QUIESCED)
+		return 0;
+
+	ret = mlx5vf_cmd_suspend_vhca(
+		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
+		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER);
+	if (ret)
+		return ret;
+
+	mvdev->vmig.dev_state |= MLX5VF_PCI_QUIESCED;
+	return 0;
+}
+
+static int mlx5vf_pci_unfreeze_device(struct mlx5vf_pci_core_device *mvdev)
+{
+	int ret;
+
+	if (!(mvdev->vmig.dev_state & MLX5VF_PCI_FREEZED))
+		return 0;
+
+	ret = mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
+				     mvdev->vmig.vhca_id,
+				     MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE);
+	if (ret)
+		return ret;
+
+	mvdev->vmig.dev_state &= ~MLX5VF_PCI_FREEZED;
+	return 0;
+}
+
+static int mlx5vf_pci_freeze_device(struct mlx5vf_pci_core_device *mvdev)
+{
+	int ret;
+
+	if (mvdev->vmig.dev_state & MLX5VF_PCI_FREEZED)
+		return 0;
+
+	ret = mlx5vf_cmd_suspend_vhca(
+		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
+		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE);
+	if (ret)
+		return ret;
+
+	mvdev->vmig.dev_state |= MLX5VF_PCI_FREEZED;
+	return 0;
+}
+
+static int mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
+{
+	u32 state_size = 0;
+	int ret;
+
+	if (!(mvdev->vmig.vfio_dev_state & VFIO_DEVICE_STATE_SAVING))
+		return -EFAULT;
+
+	if (!(mvdev->vmig.dev_state & MLX5VF_PCI_FREEZED))
+		return -EFAULT;
+
+	/* If we already read state no reason to re-read */
+	if (mvdev->vmig.vhca_state_data.state_size)
+		return 0;
+
+	ret = mlx5vf_cmd_query_vhca_migration_state(
+		mvdev->core_device.pdev, mvdev->vmig.vhca_id, &state_size);
+	if (ret)
+		return ret;
+
+	return mlx5vf_cmd_save_vhca_state(mvdev->core_device.pdev,
+					  mvdev->vmig.vhca_id, state_size,
+					  &mvdev->vmig.vhca_state_data);
+}
+
+static int mlx5vf_pci_new_write_window(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5_vhca_state_data *state_data = &mvdev->vmig.vhca_state_data;
+	u32 num_pages_needed;
+	u64 allocated_ready;
+	u32 bytes_needed;
+
+	/* Check how many bytes are available from previous flows */
+	WARN_ON(state_data->num_pages * PAGE_SIZE <
+		state_data->win_start_offset);
+	allocated_ready = (state_data->num_pages * PAGE_SIZE) -
+			  state_data->win_start_offset;
+	WARN_ON(allocated_ready > MLX5VF_MIG_REGION_DATA_SIZE);
+
+	bytes_needed = MLX5VF_MIG_REGION_DATA_SIZE - allocated_ready;
+	if (!bytes_needed)
+		return 0;
+
+	num_pages_needed = DIV_ROUND_UP_ULL(bytes_needed, PAGE_SIZE);
+	return mlx5vf_add_migration_pages(state_data, num_pages_needed);
+}
+
+static ssize_t
+mlx5vf_pci_handle_migration_data_size(struct mlx5vf_pci_core_device *mvdev,
+				      char __user *buf, bool iswrite)
+{
+	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
+	u64 data_size;
+	int ret;
+
+	if (iswrite) {
+		/* data_size is writable only during resuming state */
+		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_RESUMING)
+			return -EINVAL;
+
+		ret = copy_from_user(&data_size, buf, sizeof(data_size));
+		if (ret)
+			return -EFAULT;
+
+		vmig->vhca_state_data.state_size += data_size;
+		vmig->vhca_state_data.win_start_offset += data_size;
+		ret = mlx5vf_pci_new_write_window(mvdev);
+		if (ret)
+			return ret;
+
+	} else {
+		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_SAVING)
+			return -EINVAL;
+
+		data_size = min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE,
+				  vmig->vhca_state_data.state_size -
+				  vmig->vhca_state_data.win_start_offset);
+		ret = copy_to_user(buf, &data_size, sizeof(data_size));
+		if (ret)
+			return -EFAULT;
+	}
+
+	vmig->region_state |= MLX5VF_REGION_DATA_SIZE;
+	return sizeof(data_size);
+}
+
+static ssize_t
+mlx5vf_pci_handle_migration_data_offset(struct mlx5vf_pci_core_device *mvdev,
+					char __user *buf, bool iswrite)
+{
+	static const u64 data_offset = MLX5VF_MIG_REGION_DATA_OFFSET;
+	int ret;
+
+	/* RO field */
+	if (iswrite)
+		return -EFAULT;
+
+	ret = copy_to_user(buf, &data_offset, sizeof(data_offset));
+	if (ret)
+		return -EFAULT;
+
+	return sizeof(data_offset);
+}
+
+static ssize_t
+mlx5vf_pci_handle_migration_pending_bytes(struct mlx5vf_pci_core_device *mvdev,
+					  char __user *buf, bool iswrite)
+{
+	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
+	u64 pending_bytes;
+	int ret;
+
+	/* RO field */
+	if (iswrite)
+		return -EFAULT;
+
+	if (vmig->vfio_dev_state == (VFIO_DEVICE_STATE_SAVING |
+				     VFIO_DEVICE_STATE_RUNNING)) {
+		/* In pre-copy state we have no data to return for now,
+		 * return 0 pending bytes
+		 */
+		pending_bytes = 0;
+	} else {
+		/*
+		 * In case that the device is quiesced, we can freeze the device
+		 * since it's guaranteed that all other DMA masters are quiesced
+		 * as well.
+		 */
+		if (vmig->dev_state & MLX5VF_PCI_QUIESCED) {
+			ret = mlx5vf_pci_freeze_device(mvdev);
+			if (ret)
+				return ret;
+		}
+
+		ret = mlx5vf_pci_save_device_data(mvdev);
+		if (ret)
+			return ret;
+
+		pending_bytes = vmig->vhca_state_data.state_size -
+				vmig->vhca_state_data.win_start_offset;
+	}
+
+	ret = copy_to_user(buf, &pending_bytes, sizeof(pending_bytes));
+	if (ret)
+		return -EFAULT;
+
+	/* Window moves forward once data from previous iteration was read */
+	if (vmig->region_state & MLX5VF_REGION_DATA_SIZE)
+		vmig->vhca_state_data.win_start_offset +=
+			min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE, pending_bytes);
+
+	WARN_ON(vmig->vhca_state_data.win_start_offset >
+		vmig->vhca_state_data.state_size);
+
+	/* New iteration started */
+	vmig->region_state = MLX5VF_REGION_PENDING_BYTES;
+	return sizeof(pending_bytes);
+}
+
+static int mlx5vf_load_state(struct mlx5vf_pci_core_device *mvdev)
+{
+	if (!mvdev->vmig.vhca_state_data.state_size)
+		return 0;
+
+	return mlx5vf_cmd_load_vhca_state(mvdev->core_device.pdev,
+					  mvdev->vmig.vhca_id,
+					  &mvdev->vmig.vhca_state_data);
+}
+
+static void mlx5vf_reset_mig_state(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
+
+	vmig->region_state = 0;
+	mlx5vf_reset_vhca_state(&vmig->vhca_state_data);
+}
+
+static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
+				       u32 state)
+{
+	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
+	int ret;
+
+	if (state == vmig->vfio_dev_state)
+		return 0;
+
+	if (!vfio_change_migration_state_allowed(state, vmig->vfio_dev_state))
+		return -EINVAL;
+
+	switch (state) {
+	case VFIO_DEVICE_STATE_RUNNING:
+		/*
+		 * (running) - When we move to _RUNNING state we must:
+		 *             1. stop dirty track (in case we got here
+		 *                after recovering from error).
+		 *             2. reset device migration info fields
+		 *             3. make sure device is unfreezed
+		 *             4. make sure device is unquiesced
+		 */
+
+		/* When moving from resuming to running we may load state
+		 * to the device if was previously set.
+		 */
+		if (vmig->vfio_dev_state == VFIO_DEVICE_STATE_RESUMING) {
+			ret = mlx5vf_load_state(mvdev);
+			if (ret)
+				return ret;
+		}
+
+		/* Any previous migration state if exists should be reset */
+		mlx5vf_reset_mig_state(mvdev);
+
+		ret = mlx5vf_pci_unfreeze_device(mvdev);
+		if (ret)
+			return ret;
+		ret = mlx5vf_pci_unquiesce_device(mvdev);
+		break;
+	case VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING:
+		/*
+		 * (pre-copy) - device should start logging data.
+		 */
+		ret = 0;
+		break;
+	case VFIO_DEVICE_STATE_SAVING:
+		/*
+		 * (stop-and-copy) - Stop the device as DMA master.
+		 *                   At this stage the device can't dirty more
+		 *                   pages so we can stop logging for it.
+		 */
+		ret = mlx5vf_pci_quiesce_device(mvdev);
+		break;
+	case VFIO_DEVICE_STATE_STOP:
+		/*
+		 * (stop) - device stopped, not saving or resuming data.
+		 */
+		ret = 0;
+		break;
+	case VFIO_DEVICE_STATE_RESUMING:
+		/*
+		 * (resuming) - device stopped, should soon start resuming
+		 * data. Device must be quiesced (not a DMA master) and
+		 * freezed (not a DMA slave). Also migration info should
+		 * reset.
+		 */
+		ret = mlx5vf_pci_quiesce_device(mvdev);
+		if (ret)
+			break;
+		ret = mlx5vf_pci_freeze_device(mvdev);
+		if (ret)
+			break;
+		mlx5vf_reset_mig_state(mvdev);
+		ret = mlx5vf_pci_new_write_window(mvdev);
+		break;
+	default:
+		return -EFAULT;
+	}
+	if (ret)
+		return ret;
+
+	vmig->vfio_dev_state = state;
+	return 0;
+}
+
+static ssize_t
+mlx5vf_pci_handle_migration_device_state(struct mlx5vf_pci_core_device *mvdev,
+					 char __user *buf, bool iswrite)
+{
+	size_t count = sizeof(mvdev->vmig.vfio_dev_state);
+	int ret;
+
+	if (iswrite) {
+		u32 device_state;
+
+		ret = copy_from_user(&device_state, buf, count);
+		if (ret)
+			return -EFAULT;
+
+		ret = mlx5vf_pci_set_device_state(mvdev, device_state);
+		if (ret)
+			return ret;
+	} else {
+		ret = copy_to_user(buf, &mvdev->vmig.vfio_dev_state, count);
+		if (ret)
+			return -EFAULT;
+	}
+
+	return count;
+}
+
+static ssize_t
+mlx5vf_pci_copy_user_data_to_device_state(struct mlx5vf_pci_core_device *mvdev,
+					  char __user *buf, size_t count,
+					  u64 offset)
+{
+	struct mlx5_vhca_state_data *state_data = &mvdev->vmig.vhca_state_data;
+	u32 curr_offset;
+	char *from_buff = buf;
+	u32 win_page_offset;
+	u32 copy_count;
+	struct page *page;
+	char *to_buff;
+	int ret;
+
+	curr_offset = state_data->win_start_offset + offset;
+
+	do {
+		page = mlx5vf_get_migration_page(&state_data->mig_data,
+						 curr_offset);
+		if (!page)
+			return -EINVAL;
+
+		win_page_offset = curr_offset % PAGE_SIZE;
+		copy_count = min_t(u32, PAGE_SIZE - win_page_offset, count);
+
+		to_buff = kmap_local_page(page);
+		ret = copy_from_user(to_buff + win_page_offset, from_buff,
+				     copy_count);
+		kunmap_local(to_buff);
+		if (ret)
+			return -EFAULT;
+
+		from_buff += copy_count;
+		curr_offset += copy_count;
+		count -= copy_count;
+	} while (count > 0);
+
+	return 0;
+}
+
+static ssize_t
+mlx5vf_pci_copy_device_state_to_user(struct mlx5vf_pci_core_device *mvdev,
+				     char __user *buf, u64 offset, size_t count)
+{
+	struct mlx5_vhca_state_data *state_data = &mvdev->vmig.vhca_state_data;
+	u32 win_available_bytes;
+	u32 win_page_offset;
+	char *to_buff = buf;
+	u32 copy_count;
+	u32 curr_offset;
+	char *from_buff;
+	struct page *page;
+	int ret;
+
+	win_available_bytes =
+		min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE,
+		      mvdev->vmig.vhca_state_data.state_size -
+			      mvdev->vmig.vhca_state_data.win_start_offset);
+
+	if (count + offset > win_available_bytes)
+		return -EINVAL;
+
+	curr_offset = state_data->win_start_offset + offset;
+
+	do {
+		page = mlx5vf_get_migration_page(&state_data->mig_data,
+						 curr_offset);
+		if (!page)
+			return -EINVAL;
+
+		win_page_offset = curr_offset % PAGE_SIZE;
+		copy_count = min_t(u32, PAGE_SIZE - win_page_offset, count);
+
+		from_buff = kmap_local_page(page);
+		ret = copy_to_user(buf, from_buff + win_page_offset,
+				   copy_count);
+		kunmap_local(from_buff);
+		if (ret)
+			return -EFAULT;
+
+		curr_offset += copy_count;
+		count -= copy_count;
+		to_buff += copy_count;
+	} while (count);
+
+	return 0;
+}
+
+static ssize_t
+mlx5vf_pci_migration_data_rw(struct mlx5vf_pci_core_device *mvdev,
+			     char __user *buf, size_t count, u64 offset,
+			     bool iswrite)
+{
+	int ret;
+
+	if (offset + count > MLX5VF_MIG_REGION_DATA_SIZE)
+		return -EINVAL;
+
+	if (iswrite)
+		ret = mlx5vf_pci_copy_user_data_to_device_state(mvdev, buf,
+								count, offset);
+	else
+		ret = mlx5vf_pci_copy_device_state_to_user(mvdev, buf, offset,
+							   count);
+	if (ret)
+		return ret;
+	return count;
+}
+
+static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
+				 char __user *buf, size_t count, loff_t *ppos,
+				 bool iswrite)
+{
+	struct mlx5vf_pci_core_device *mvdev =
+		container_of(vdev, struct mlx5vf_pci_core_device, core_device);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	/* Copy to/from the migration region data section */
+	if (pos >= MLX5VF_MIG_REGION_DATA_OFFSET)
+		return mlx5vf_pci_migration_data_rw(
+			mvdev, buf, count, pos - MLX5VF_MIG_REGION_DATA_OFFSET,
+			iswrite);
+
+	switch (pos) {
+	case VFIO_DEVICE_MIGRATION_OFFSET(device_state):
+		/* This is RW field. */
+		if (count != sizeof(mvdev->vmig.vfio_dev_state)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = mlx5vf_pci_handle_migration_device_state(mvdev, buf,
+							       iswrite);
+		break;
+	case VFIO_DEVICE_MIGRATION_OFFSET(pending_bytes):
+		/*
+		 * The number of pending bytes still to be migrated from the
+		 * vendor driver. This is RO field.
+		 * Reading this field indicates on the start of a new iteration
+		 * to get device data.
+		 *
+		 */
+		ret = mlx5vf_pci_handle_migration_pending_bytes(mvdev, buf,
+								iswrite);
+		break;
+	case VFIO_DEVICE_MIGRATION_OFFSET(data_offset):
+		/*
+		 * The user application should read data_offset field from the
+		 * migration region. The user application should read the
+		 * device data from this offset within the migration region
+		 * during the _SAVING mode or write the device data during the
+		 * _RESUMING mode. This is RO field.
+		 */
+		ret = mlx5vf_pci_handle_migration_data_offset(mvdev, buf,
+							      iswrite);
+		break;
+	case VFIO_DEVICE_MIGRATION_OFFSET(data_size):
+		/*
+		 * The user application should read data_size to get the size
+		 * in bytes of the data copied to the migration region during
+		 * the _SAVING state by the device. The user application should
+		 * write the size in bytes of the data that was copied to
+		 * the migration region during the _RESUMING state by the user.
+		 * This is RW field.
+		 */
+		ret = mlx5vf_pci_handle_migration_data_size(mvdev, buf,
+							    iswrite);
+		break;
+	default:
+		ret = -EFAULT;
+		break;
+	}
+
+	return ret;
+}
+
+static struct vfio_pci_regops migration_ops = {
+	.rw = mlx5vf_pci_mig_rw,
+};
+
+static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &mvdev->core_device;
+	int vf_id;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (!mvdev->migrate_cap) {
+		vfio_pci_core_finish_enable(vdev);
+		return 0;
+	}
+
+	vf_id = pci_iov_vf_id(vdev->pdev);
+	if (vf_id < 0) {
+		ret = vf_id;
+		goto out_disable;
+	}
+
+	ret = mlx5vf_cmd_get_vhca_id(vdev->pdev, vf_id + 1,
+				     &mvdev->vmig.vhca_id);
+	if (ret)
+		goto out_disable;
+
+	ret = vfio_pci_register_dev_region(vdev, VFIO_REGION_TYPE_MIGRATION,
+					   VFIO_REGION_SUBTYPE_MIGRATION,
+					   &migration_ops,
+					   MLX5VF_MIG_REGION_DATA_OFFSET +
+					   MLX5VF_MIG_REGION_DATA_SIZE,
+					   VFIO_REGION_INFO_FLAG_READ |
+					   VFIO_REGION_INFO_FLAG_WRITE,
+					   NULL);
+	if (ret)
+		goto out_disable;
+
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+out_disable:
+	vfio_pci_core_disable(vdev);
+	return ret;
+}
+
+static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+
+	vfio_pci_core_close_device(core_vdev);
+	mlx5vf_reset_mig_state(mvdev);
+}
+
+static const struct vfio_device_ops mlx5vf_pci_ops = {
+	.name = "mlx5-vfio-pci",
+	.open_device = mlx5vf_pci_open_device,
+	.close_device = mlx5vf_pci_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+};
+
+static int mlx5vf_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *id)
+{
+	struct mlx5vf_pci_core_device *mvdev;
+	int ret;
+
+	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
+	if (!mvdev)
+		return -ENOMEM;
+	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
+
+	if (pdev->is_virtfn) {
+		struct mlx5_core_dev *mdev =
+			mlx5_get_core_dev(pci_physfn(pdev));
+
+		if (mdev) {
+			if (MLX5_CAP_GEN(mdev, migration))
+				mvdev->migrate_cap = 1;
+			mlx5_put_core_dev(mdev);
+		}
+	}
+
+	ret = vfio_pci_core_register_device(&mvdev->core_device);
+	if (ret)
+		goto out_free;
+
+	dev_set_drvdata(&pdev->dev, mvdev);
+	return 0;
+
+out_free:
+	vfio_pci_core_uninit_device(&mvdev->core_device);
+	kfree(mvdev);
+	return ret;
+}
+
+static void mlx5vf_pci_remove(struct pci_dev *pdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(&mvdev->core_device);
+	vfio_pci_core_uninit_device(&mvdev->core_device);
+	kfree(mvdev);
+}
+
+static const struct pci_device_id mlx5vf_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101e) }, /* ConnectX Family mlx5Gen Virtual Function */
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
+
+static struct pci_driver mlx5vf_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = mlx5vf_pci_table,
+	.probe = mlx5vf_pci_probe,
+	.remove = mlx5vf_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+};
+
+static void __exit mlx5vf_pci_cleanup(void)
+{
+	pci_unregister_driver(&mlx5vf_pci_driver);
+}
+
+static int __init mlx5vf_pci_init(void)
+{
+	return pci_register_driver(&mlx5vf_pci_driver);
+}
+
+module_init(mlx5vf_pci_init);
+module_exit(mlx5vf_pci_cleanup);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
+MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
+MODULE_DESCRIPTION(
+	"MLX5 VFIO PCI - User Level meta-driver for MLX5 device family");
-- 
2.31.1

