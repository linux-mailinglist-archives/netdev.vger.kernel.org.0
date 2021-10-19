Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB534332F4
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhJSKBU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Oct 2021 06:01:20 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4003 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhJSKBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:01:19 -0400
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HYTcZ2GMhz6H7nK;
        Tue, 19 Oct 2021 17:54:54 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Tue, 19 Oct 2021 11:59:04 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 10:59:03 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.015; Tue, 19 Oct 2021 10:59:03 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Topic: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Index: AQHXwBe44UEbHr+D60+Uqj0Ty2ZNXqvaHB4A
Date:   Tue, 19 Oct 2021 09:59:03 +0000
Message-ID: <ed08f3350c594a63982856434d19d728@huawei.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
In-Reply-To: <20211013094707.163054-12-yishaih@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.94.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Yishai Hadas [mailto:yishaih@nvidia.com]
> Sent: 13 October 2021 10:47
> To: alex.williamson@redhat.com; bhelgaas@google.com; jgg@nvidia.com;
> saeedm@nvidia.com
> Cc: linux-pci@vger.kernel.org; kvm@vger.kernel.org; netdev@vger.kernel.org;
> kuba@kernel.org; leonro@nvidia.com; kwankhede@nvidia.com;
> mgurtovoy@nvidia.com; yishaih@nvidia.com; maorg@nvidia.com
> Subject: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver for
> mlx5 devices
> 
> This patch adds support for vfio_pci driver for mlx5 devices.
> 
> It uses vfio_pci_core to register to the VFIO subsystem and then
> implements the mlx5 specific logic in the migration area.
> 
> The migration implementation follows the definition from uapi/vfio.h and
> uses the mlx5 VF->PF command channel to achieve it.
> 
> This patch implements the suspend/resume flows.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  MAINTAINERS                    |   6 +
>  drivers/vfio/pci/Kconfig       |   3 +
>  drivers/vfio/pci/Makefile      |   2 +
>  drivers/vfio/pci/mlx5/Kconfig  |  11 +
>  drivers/vfio/pci/mlx5/Makefile |   4 +
>  drivers/vfio/pci/mlx5/main.c   | 692 +++++++++++++++++++++++++++++++++
>  6 files changed, 718 insertions(+)
>  create mode 100644 drivers/vfio/pci/mlx5/Kconfig
>  create mode 100644 drivers/vfio/pci/mlx5/Makefile
>  create mode 100644 drivers/vfio/pci/mlx5/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index abdcbcfef73d..e824bfab4a01 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19699,6 +19699,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/
> 
> +VFIO MLX5 PCI DRIVER
> +M:	Yishai Hadas <yishaih@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/mlx5/
> +
>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 860424ccda1b..187b9c259944 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -43,4 +43,7 @@ config VFIO_PCI_IGD
> 
>  	  To enable Intel IGD assignment through vfio-pci, say Y.
>  endif
> +
> +source "drivers/vfio/pci/mlx5/Kconfig"
> +
>  endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 349d68d242b4..ed9d6f2e0555 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -7,3 +7,5 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>  vfio-pci-y := vfio_pci.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
> +
> +obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
> new file mode 100644
> index 000000000000..a3ce00add4fe
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config MLX5_VFIO_PCI
> +	tristate "VFIO support for MLX5 PCI devices"
> +	depends on MLX5_CORE
> +	select VFIO_PCI_CORE
> +	help
> +	  This provides a PCI support for MLX5 devices using the VFIO
> +	  framework. The device specific driver supports suspend/resume
> +	  of the MLX5 device.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/mlx5/Makefile b/drivers/vfio/pci/mlx5/Makefile
> new file mode 100644
> index 000000000000..689627da7ff5
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
> +mlx5-vfio-pci-y := main.o cmd.o
> +
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> new file mode 100644
> index 000000000000..e36302b444a6
> --- /dev/null
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -0,0 +1,692 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/sched/mm.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "cmd.h"
> +
> +enum {
> +	MLX5VF_PCI_FREEZED = 1 << 0,
> +};
> +
> +enum {
> +	MLX5VF_REGION_PENDING_BYTES = 1 << 0,
> +	MLX5VF_REGION_DATA_SIZE = 1 << 1,
> +};
> +
> +#define MLX5VF_MIG_REGION_DATA_SIZE SZ_128K
> +/* Data section offset from migration region */
> +#define MLX5VF_MIG_REGION_DATA_OFFSET
> \
> +	(sizeof(struct vfio_device_migration_info))
> +
> +#define VFIO_DEVICE_MIGRATION_OFFSET(x)
> \
> +	(offsetof(struct vfio_device_migration_info, x))
> +
> +struct mlx5vf_pci_migration_info {
> +	u32 vfio_dev_state; /* VFIO_DEVICE_STATE_XXX */
> +	u32 dev_state; /* device migration state */
> +	u32 region_state; /* Use MLX5VF_REGION_XXX */
> +	u16 vhca_id;
> +	struct mlx5_vhca_state_data vhca_state_data;
> +};
> +
> +struct mlx5vf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 migrate_cap:1;
> +	/* protect migartion state */
> +	struct mutex state_mutex;
> +	struct mlx5vf_pci_migration_info vmig;
> +};
> +
> +static int mlx5vf_pci_unquiesce_device(struct mlx5vf_pci_core_device
> *mvdev)
> +{
> +	return mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
> +				      mvdev->vmig.vhca_id,
> +
> MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER);
> +}
> +
> +static int mlx5vf_pci_quiesce_device(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	return mlx5vf_cmd_suspend_vhca(
> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
> +		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER);
> +}
> +
> +static int mlx5vf_pci_unfreeze_device(struct mlx5vf_pci_core_device
> *mvdev)
> +{
> +	int ret;
> +
> +	ret = mlx5vf_cmd_resume_vhca(mvdev->core_device.pdev,
> +				     mvdev->vmig.vhca_id,
> +
> MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE);
> +	if (ret)
> +		return ret;
> +
> +	mvdev->vmig.dev_state &= ~MLX5VF_PCI_FREEZED;
> +	return 0;
> +}
> +
> +static int mlx5vf_pci_freeze_device(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	int ret;
> +
> +	ret = mlx5vf_cmd_suspend_vhca(
> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id,
> +		MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE);
> +	if (ret)
> +		return ret;
> +
> +	mvdev->vmig.dev_state |= MLX5VF_PCI_FREEZED;
> +	return 0;
> +}
> +
> +static int mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device
> *mvdev)
> +{
> +	u32 state_size = 0;
> +	int ret;
> +
> +	if (!(mvdev->vmig.dev_state & MLX5VF_PCI_FREEZED))
> +		return -EFAULT;
> +
> +	/* If we already read state no reason to re-read */
> +	if (mvdev->vmig.vhca_state_data.state_size)
> +		return 0;
> +
> +	ret = mlx5vf_cmd_query_vhca_migration_state(
> +		mvdev->core_device.pdev, mvdev->vmig.vhca_id, &state_size);
> +	if (ret)
> +		return ret;
> +
> +	return mlx5vf_cmd_save_vhca_state(mvdev->core_device.pdev,
> +					  mvdev->vmig.vhca_id, state_size,
> +					  &mvdev->vmig.vhca_state_data);
> +}
> +
> +static int mlx5vf_pci_new_write_window(struct mlx5vf_pci_core_device
> *mvdev)
> +{
> +	struct mlx5_vhca_state_data *state_data =
> &mvdev->vmig.vhca_state_data;
> +	u32 num_pages_needed;
> +	u64 allocated_ready;
> +	u32 bytes_needed;
> +
> +	/* Check how many bytes are available from previous flows */
> +	WARN_ON(state_data->num_pages * PAGE_SIZE <
> +		state_data->win_start_offset);
> +	allocated_ready = (state_data->num_pages * PAGE_SIZE) -
> +			  state_data->win_start_offset;
> +	WARN_ON(allocated_ready > MLX5VF_MIG_REGION_DATA_SIZE);
> +
> +	bytes_needed = MLX5VF_MIG_REGION_DATA_SIZE - allocated_ready;
> +	if (!bytes_needed)
> +		return 0;
> +
> +	num_pages_needed = DIV_ROUND_UP_ULL(bytes_needed, PAGE_SIZE);
> +	return mlx5vf_add_migration_pages(state_data, num_pages_needed);
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_data_size(struct mlx5vf_pci_core_device
> *mvdev,
> +				      char __user *buf, bool iswrite)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u64 data_size;
> +	int ret;
> +
> +	if (iswrite) {
> +		/* data_size is writable only during resuming state */
> +		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_RESUMING)
> +			return -EINVAL;
> +
> +		ret = copy_from_user(&data_size, buf, sizeof(data_size));
> +		if (ret)
> +			return -EFAULT;
> +
> +		vmig->vhca_state_data.state_size += data_size;
> +		vmig->vhca_state_data.win_start_offset += data_size;
> +		ret = mlx5vf_pci_new_write_window(mvdev);
> +		if (ret)
> +			return ret;
> +
> +	} else {
> +		if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_SAVING)
> +			return -EINVAL;
> +
> +		data_size = min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE,
> +				  vmig->vhca_state_data.state_size -
> +				  vmig->vhca_state_data.win_start_offset);
> +		ret = copy_to_user(buf, &data_size, sizeof(data_size));
> +		if (ret)
> +			return -EFAULT;
> +	}
> +
> +	vmig->region_state |= MLX5VF_REGION_DATA_SIZE;
> +	return sizeof(data_size);
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_data_offset(struct mlx5vf_pci_core_device
> *mvdev,
> +					char __user *buf, bool iswrite)
> +{
> +	static const u64 data_offset = MLX5VF_MIG_REGION_DATA_OFFSET;
> +	int ret;
> +
> +	/* RO field */
> +	if (iswrite)
> +		return -EFAULT;
> +
> +	ret = copy_to_user(buf, &data_offset, sizeof(data_offset));
> +	if (ret)
> +		return -EFAULT;
> +
> +	return sizeof(data_offset);
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_pending_bytes(struct mlx5vf_pci_core_device
> *mvdev,
> +					  char __user *buf, bool iswrite)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u64 pending_bytes;
> +	int ret;
> +
> +	/* RO field */
> +	if (iswrite)
> +		return -EFAULT;
> +
> +	if (vmig->vfio_dev_state == (VFIO_DEVICE_STATE_SAVING |
> +				     VFIO_DEVICE_STATE_RUNNING)) {
> +		/* In pre-copy state we have no data to return for now,
> +		 * return 0 pending bytes
> +		 */
> +		pending_bytes = 0;
> +	} else {
> +		if (!vmig->vhca_state_data.state_size)
> +			return 0;
> +		pending_bytes = vmig->vhca_state_data.state_size -
> +				vmig->vhca_state_data.win_start_offset;
> +	}
> +
> +	ret = copy_to_user(buf, &pending_bytes, sizeof(pending_bytes));
> +	if (ret)
> +		return -EFAULT;
> +
> +	/* Window moves forward once data from previous iteration was read */
> +	if (vmig->region_state & MLX5VF_REGION_DATA_SIZE)
> +		vmig->vhca_state_data.win_start_offset +=
> +			min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE, pending_bytes);
> +
> +	WARN_ON(vmig->vhca_state_data.win_start_offset >
> +		vmig->vhca_state_data.state_size);
> +
> +	/* New iteration started */
> +	vmig->region_state = MLX5VF_REGION_PENDING_BYTES;
> +	return sizeof(pending_bytes);
> +}
> +
> +static int mlx5vf_load_state(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	if (!mvdev->vmig.vhca_state_data.state_size)
> +		return 0;
> +
> +	return mlx5vf_cmd_load_vhca_state(mvdev->core_device.pdev,
> +					  mvdev->vmig.vhca_id,
> +					  &mvdev->vmig.vhca_state_data);
> +}
> +
> +static void mlx5vf_reset_mig_state(struct mlx5vf_pci_core_device *mvdev)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +
> +	vmig->region_state = 0;
> +	mlx5vf_reset_vhca_state(&vmig->vhca_state_data);
> +}
> +
> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device
> *mvdev,
> +				       u32 state)
> +{
> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> +	u32 old_state = vmig->vfio_dev_state;
> +	int ret = 0;
> +
> +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
> +		return -EINVAL;
> +
> +	/* Running switches off */
> +	if ((old_state & VFIO_DEVICE_STATE_RUNNING) !=
> +	    (state & VFIO_DEVICE_STATE_RUNNING) &&
> +	    (old_state & VFIO_DEVICE_STATE_RUNNING)) {
> +		ret = mlx5vf_pci_quiesce_device(mvdev);
> +		if (ret)
> +			return ret;
> +		ret = mlx5vf_pci_freeze_device(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;
> +			return ret;
> +		}
> +	}
> +
> +	/* Resuming switches off */
> +	if ((old_state & VFIO_DEVICE_STATE_RESUMING) !=
> +	    (state & VFIO_DEVICE_STATE_RESUMING) &&
> +	    (old_state & VFIO_DEVICE_STATE_RESUMING)) {
> +		/* deserialize state into the device */
> +		ret = mlx5vf_load_state(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;
> +			return ret;
> +		}
> +	}
> +
> +	/* Resuming switches on */
> +	if ((old_state & VFIO_DEVICE_STATE_RESUMING) !=
> +	    (state & VFIO_DEVICE_STATE_RESUMING) &&
> +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
> +		mlx5vf_reset_mig_state(mvdev);
> +		ret = mlx5vf_pci_new_write_window(mvdev);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Saving switches on */
> +	if ((old_state & VFIO_DEVICE_STATE_SAVING) !=
> +	    (state & VFIO_DEVICE_STATE_SAVING) &&
> +	    (state & VFIO_DEVICE_STATE_SAVING)) {
> +		if (!(state & VFIO_DEVICE_STATE_RUNNING)) {
> +			/* serialize post copy */
> +			ret = mlx5vf_pci_save_device_data(mvdev);

Does it actually get into post-copy here? The pre-copy state(old_state) 
has the _SAVING bit set already and post-copy state( new state) also
has _SAVING set. It looks like we need to handle the post copy in the above
"Running switches off" and check for (state & _SAVING). 

Or Am I missing something?

Thanks,
Shameer

> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	/* Running switches on */
> +	if ((old_state & VFIO_DEVICE_STATE_RUNNING) !=
> +	    (state & VFIO_DEVICE_STATE_RUNNING) &&
> +	    (state & VFIO_DEVICE_STATE_RUNNING)) {
> +		ret = mlx5vf_pci_unfreeze_device(mvdev);
> +		if (ret)
> +			return ret;
> +		ret = mlx5vf_pci_unquiesce_device(mvdev);
> +		if (ret) {
> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_INVALID;
> +			return ret;
> +		}
> +	}
> +
> +	vmig->vfio_dev_state = state;
> +	return 0;
> +}
> +
> +static ssize_t
> +mlx5vf_pci_handle_migration_device_state(struct mlx5vf_pci_core_device
> *mvdev,
> +					 char __user *buf, bool iswrite)
> +{
> +	size_t count = sizeof(mvdev->vmig.vfio_dev_state);
> +	int ret;
> +
> +	if (iswrite) {
> +		u32 device_state;
> +
> +		ret = copy_from_user(&device_state, buf, count);
> +		if (ret)
> +			return -EFAULT;
> +
> +		ret = mlx5vf_pci_set_device_state(mvdev, device_state);
> +		if (ret)
> +			return ret;
> +	} else {
> +		ret = copy_to_user(buf, &mvdev->vmig.vfio_dev_state, count);
> +		if (ret)
> +			return -EFAULT;
> +	}
> +
> +	return count;
> +}
> +
> +static ssize_t
> +mlx5vf_pci_copy_user_data_to_device_state(struct mlx5vf_pci_core_device
> *mvdev,
> +					  char __user *buf, size_t count,
> +					  u64 offset)
> +{
> +	struct mlx5_vhca_state_data *state_data =
> &mvdev->vmig.vhca_state_data;
> +	char __user *from_buff = buf;
> +	u32 curr_offset;
> +	u32 win_page_offset;
> +	u32 copy_count;
> +	struct page *page;
> +	char *to_buff;
> +	int ret;
> +
> +	curr_offset = state_data->win_start_offset + offset;
> +
> +	do {
> +		page = mlx5vf_get_migration_page(&state_data->mig_data,
> +						 curr_offset);
> +		if (!page)
> +			return -EINVAL;
> +
> +		win_page_offset = curr_offset % PAGE_SIZE;
> +		copy_count = min_t(u32, PAGE_SIZE - win_page_offset, count);
> +
> +		to_buff = kmap_local_page(page);
> +		ret = copy_from_user(to_buff + win_page_offset, from_buff,
> +				     copy_count);
> +		kunmap_local(to_buff);
> +		if (ret)
> +			return -EFAULT;
> +
> +		from_buff += copy_count;
> +		curr_offset += copy_count;
> +		count -= copy_count;
> +	} while (count > 0);
> +
> +	return 0;
> +}
> +
> +static ssize_t
> +mlx5vf_pci_copy_device_state_to_user(struct mlx5vf_pci_core_device
> *mvdev,
> +				     char __user *buf, u64 offset, size_t count)
> +{
> +	struct mlx5_vhca_state_data *state_data =
> &mvdev->vmig.vhca_state_data;
> +	char __user *to_buff = buf;
> +	u32 win_available_bytes;
> +	u32 win_page_offset;
> +	u32 copy_count;
> +	u32 curr_offset;
> +	char *from_buff;
> +	struct page *page;
> +	int ret;
> +
> +	win_available_bytes =
> +		min_t(u64, MLX5VF_MIG_REGION_DATA_SIZE,
> +		      mvdev->vmig.vhca_state_data.state_size -
> +			      mvdev->vmig.vhca_state_data.win_start_offset);
> +
> +	if (count + offset > win_available_bytes)
> +		return -EINVAL;
> +
> +	curr_offset = state_data->win_start_offset + offset;
> +
> +	do {
> +		page = mlx5vf_get_migration_page(&state_data->mig_data,
> +						 curr_offset);
> +		if (!page)
> +			return -EINVAL;
> +
> +		win_page_offset = curr_offset % PAGE_SIZE;
> +		copy_count = min_t(u32, PAGE_SIZE - win_page_offset, count);
> +
> +		from_buff = kmap_local_page(page);
> +		ret = copy_to_user(buf, from_buff + win_page_offset,
> +				   copy_count);
> +		kunmap_local(from_buff);
> +		if (ret)
> +			return -EFAULT;
> +
> +		curr_offset += copy_count;
> +		count -= copy_count;
> +		to_buff += copy_count;
> +	} while (count);
> +
> +	return 0;
> +}
> +
> +static ssize_t
> +mlx5vf_pci_migration_data_rw(struct mlx5vf_pci_core_device *mvdev,
> +			     char __user *buf, size_t count, u64 offset,
> +			     bool iswrite)
> +{
> +	int ret;
> +
> +	if (offset + count > MLX5VF_MIG_REGION_DATA_SIZE)
> +		return -EINVAL;
> +
> +	if (iswrite)
> +		ret = mlx5vf_pci_copy_user_data_to_device_state(mvdev, buf,
> +								count, offset);
> +	else
> +		ret = mlx5vf_pci_copy_device_state_to_user(mvdev, buf, offset,
> +							   count);
> +	if (ret)
> +		return ret;
> +	return count;
> +}
> +
> +static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
> +				 char __user *buf, size_t count, loff_t *ppos,
> +				 bool iswrite)
> +{
> +	struct mlx5vf_pci_core_device *mvdev =
> +		container_of(vdev, struct mlx5vf_pci_core_device, core_device);
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	mutex_lock(&mvdev->state_mutex);
> +	/* Copy to/from the migration region data section */
> +	if (pos >= MLX5VF_MIG_REGION_DATA_OFFSET) {
> +		ret = mlx5vf_pci_migration_data_rw(
> +			mvdev, buf, count, pos - MLX5VF_MIG_REGION_DATA_OFFSET,
> +			iswrite);
> +		goto end;
> +	}
> +
> +	switch (pos) {
> +	case VFIO_DEVICE_MIGRATION_OFFSET(device_state):
> +		/* This is RW field. */
> +		if (count != sizeof(mvdev->vmig.vfio_dev_state)) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +		ret = mlx5vf_pci_handle_migration_device_state(mvdev, buf,
> +							       iswrite);
> +		break;
> +	case VFIO_DEVICE_MIGRATION_OFFSET(pending_bytes):
> +		/*
> +		 * The number of pending bytes still to be migrated from the
> +		 * vendor driver. This is RO field.
> +		 * Reading this field indicates on the start of a new iteration
> +		 * to get device data.
> +		 *
> +		 */
> +		ret = mlx5vf_pci_handle_migration_pending_bytes(mvdev, buf,
> +								iswrite);
> +		break;
> +	case VFIO_DEVICE_MIGRATION_OFFSET(data_offset):
> +		/*
> +		 * The user application should read data_offset field from the
> +		 * migration region. The user application should read the
> +		 * device data from this offset within the migration region
> +		 * during the _SAVING mode or write the device data during the
> +		 * _RESUMING mode. This is RO field.
> +		 */
> +		ret = mlx5vf_pci_handle_migration_data_offset(mvdev, buf,
> +							      iswrite);
> +		break;
> +	case VFIO_DEVICE_MIGRATION_OFFSET(data_size):
> +		/*
> +		 * The user application should read data_size to get the size
> +		 * in bytes of the data copied to the migration region during
> +		 * the _SAVING state by the device. The user application should
> +		 * write the size in bytes of the data that was copied to
> +		 * the migration region during the _RESUMING state by the user.
> +		 * This is RW field.
> +		 */
> +		ret = mlx5vf_pci_handle_migration_data_size(mvdev, buf,
> +							    iswrite);
> +		break;
> +	default:
> +		ret = -EFAULT;
> +		break;
> +	}
> +
> +end:
> +	mutex_unlock(&mvdev->state_mutex);
> +	return ret;
> +}
> +
> +static struct vfio_pci_regops migration_ops = {
> +	.rw = mlx5vf_pci_mig_rw,
> +};
> +
> +static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = container_of(
> +		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
> +	struct vfio_pci_core_device *vdev = &mvdev->core_device;
> +	int vf_id;
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	if (!mvdev->migrate_cap) {
> +		vfio_pci_core_finish_enable(vdev);
> +		return 0;
> +	}
> +
> +	vf_id = pci_iov_vf_id(vdev->pdev);
> +	if (vf_id < 0) {
> +		ret = vf_id;
> +		goto out_disable;
> +	}
> +
> +	ret = mlx5vf_cmd_get_vhca_id(vdev->pdev, vf_id + 1,
> +				     &mvdev->vmig.vhca_id);
> +	if (ret)
> +		goto out_disable;
> +
> +	ret = vfio_pci_register_dev_region(vdev, VFIO_REGION_TYPE_MIGRATION,
> +					   VFIO_REGION_SUBTYPE_MIGRATION,
> +					   &migration_ops,
> +					   MLX5VF_MIG_REGION_DATA_OFFSET +
> +					   MLX5VF_MIG_REGION_DATA_SIZE,
> +					   VFIO_REGION_INFO_FLAG_READ |
> +					   VFIO_REGION_INFO_FLAG_WRITE,
> +					   NULL);
> +	if (ret)
> +		goto out_disable;
> +
> +	mutex_init(&mvdev->state_mutex);
> +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
> +	vfio_pci_core_finish_enable(vdev);
> +	return 0;
> +out_disable:
> +	vfio_pci_core_disable(vdev);
> +	return ret;
> +}
> +
> +static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = container_of(
> +		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
> +
> +	vfio_pci_core_close_device(core_vdev);
> +	mlx5vf_reset_mig_state(mvdev);
> +}
> +
> +static const struct vfio_device_ops mlx5vf_pci_ops = {
> +	.name = "mlx5-vfio-pci",
> +	.open_device = mlx5vf_pci_open_device,
> +	.close_device = mlx5vf_pci_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +};
> +
> +static int mlx5vf_pci_probe(struct pci_dev *pdev,
> +			    const struct pci_device_id *id)
> +{
> +	struct mlx5vf_pci_core_device *mvdev;
> +	int ret;
> +
> +	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
> +	if (!mvdev)
> +		return -ENOMEM;
> +	vfio_pci_core_init_device(&mvdev->core_device, pdev,
> &mlx5vf_pci_ops);
> +
> +	if (pdev->is_virtfn) {
> +		struct mlx5_core_dev *mdev =
> +			mlx5_vf_get_core_dev(pdev);
> +
> +		if (mdev) {
> +			if (MLX5_CAP_GEN(mdev, migration))
> +				mvdev->migrate_cap = 1;
> +			mlx5_vf_put_core_dev(mdev);
> +		}
> +	}
> +
> +	ret = vfio_pci_core_register_device(&mvdev->core_device);
> +	if (ret)
> +		goto out_free;
> +
> +	dev_set_drvdata(&pdev->dev, mvdev);
> +	return 0;
> +
> +out_free:
> +	vfio_pci_core_uninit_device(&mvdev->core_device);
> +	kfree(mvdev);
> +	return ret;
> +}
> +
> +static void mlx5vf_pci_remove(struct pci_dev *pdev)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(&mvdev->core_device);
> +	vfio_pci_core_uninit_device(&mvdev->core_device);
> +	kfree(mvdev);
> +}
> +
> +static const struct pci_device_id mlx5vf_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX,
> 0x101e) }, /* ConnectX Family mlx5Gen Virtual Function */
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
> +
> +static struct pci_driver mlx5vf_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = mlx5vf_pci_table,
> +	.probe = mlx5vf_pci_probe,
> +	.remove = mlx5vf_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +};
> +
> +static void __exit mlx5vf_pci_cleanup(void)
> +{
> +	pci_unregister_driver(&mlx5vf_pci_driver);
> +}
> +
> +static int __init mlx5vf_pci_init(void)
> +{
> +	return pci_register_driver(&mlx5vf_pci_driver);
> +}
> +
> +module_init(mlx5vf_pci_init);
> +module_exit(mlx5vf_pci_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
> +MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"MLX5 VFIO PCI - User Level meta-driver for MLX5 device family");
> --
> 2.18.1

