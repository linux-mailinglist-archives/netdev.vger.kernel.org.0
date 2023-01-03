Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E03A65BFAC
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbjACMMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbjACMMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:12:20 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9131005;
        Tue,  3 Jan 2023 04:12:18 -0800 (PST)
Received: from kwepemm600005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NmWln5731zRqHD;
        Tue,  3 Jan 2023 20:10:45 +0800 (CST)
Received: from [10.67.103.158] (10.67.103.158) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 3 Jan 2023 20:12:15 +0800
Subject: Re: [RFC PATCH v2 vfio 1/7] vfio/pds: Initial support for pds_vfio
 VFIO driver
To:     Brett Creeley <brett.creeley@amd.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>
References: <20221214232136.64220-1-brett.creeley@amd.com>
 <20221214232136.64220-2-brett.creeley@amd.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <a62bb7e5-e5f5-8fa5-27e2-c682725d7139@huawei.com>
Date:   Tue, 3 Jan 2023 20:12:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221214232136.64220-2-brett.creeley@amd.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.158]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/15 7:21, Brett Creeley wrote:
> This is the initial framework for the new pds_vfio device driver. This
> does the very basics of registering the PCI device 1dd8:1006 and
> configuring as a VFIO PCI device.
> 
> With this change, the VF device can be bound to the pds_vfio driver on
> the host and presented to the VM as an NVMe VF.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/Makefile   |   6 ++
>  drivers/vfio/pci/pds/pci_drv.c  | 102 ++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/vfio_dev.c |  74 +++++++++++++++++++++++
>  drivers/vfio/pci/pds/vfio_dev.h |  23 +++++++
>  include/linux/pds/pds_core_if.h |   1 +
>  5 files changed, 206 insertions(+)
>  create mode 100644 drivers/vfio/pci/pds/Makefile
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
> 
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
> new file mode 100644
> index 000000000000..dcc8f6beffe2
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
> +
> +pds_vfio-y := \
> +	pci_drv.o	\
> +	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> new file mode 100644
> index 000000000000..09cab0dbb0e9
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +#include <linux/vfio.h>
> +
> +#include <linux/pds/pds_core_if.h>
> +
> +#include "vfio_dev.h"
> +
> +#define PDS_VFIO_DRV_NAME		"pds_vfio"
> +#define PDS_VFIO_DRV_DESCRIPTION	"Pensando VFIO Device Driver"
> +#define PCI_VENDOR_ID_PENSANDO		0x1dd8
> +
> +static int
> +pds_vfio_pci_probe(struct pci_dev *pdev,
> +		   const struct pci_device_id *id)
> +{
> +	struct pds_vfio_pci_device *pds_vfio;
> +	int err;
> +
> +	pds_vfio = vfio_alloc_device(pds_vfio_pci_device, vfio_coredev.vdev,
> +				     &pdev->dev,  pds_vfio_ops_info());
> +	if (IS_ERR(pds_vfio))
> +		return PTR_ERR(pds_vfio);
> +
> +	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
> +	pds_vfio->pdev = pdev;
> +
> +	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
> +	if (err)
> +		goto out_put_vdev;
> +
> +	return 0;
> +
> +out_put_vdev:
> +	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
> +	return err;
> +}
> +
> +static void
> +pds_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
> +
> +	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
> +	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
> +}
> +
> +static const struct pci_device_id
> +pds_vfio_pci_table[] = {
> +	{
> +		.class = PCI_CLASS_STORAGE_EXPRESS,
> +		.class_mask = 0xffffff,
> +		.vendor = PCI_VENDOR_ID_PENSANDO,
> +		.device = PCI_DEVICE_ID_PENSANDO_NVME_VF,
> +		.subvendor = PCI_ANY_ID,
> +		.subdevice = PCI_ANY_ID,
> +		.override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE,
> +	},
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
> +
> +static struct pci_driver
> +pds_vfio_pci_driver = {
> +	.name = PDS_VFIO_DRV_NAME,
> +	.id_table = pds_vfio_pci_table,
> +	.probe = pds_vfio_pci_probe,
> +	.remove = pds_vfio_pci_remove,
> +	.driver_managed_dma = true,
> +};
> +
> +static void __exit
> +pds_vfio_pci_cleanup(void)
> +{
> +	pci_unregister_driver(&pds_vfio_pci_driver);
> +}
> +module_exit(pds_vfio_pci_cleanup);
> +
> +static int __init
> +pds_vfio_pci_init(void)
> +{
> +	int err;
> +
> +	err = pci_register_driver(&pds_vfio_pci_driver);
> +	if (err) {
> +		pr_err("pci driver register failed: %pe\n", ERR_PTR(err));
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +module_init(pds_vfio_pci_init);

It would be better to use module_pci_driver(pds_vfio_pci_driver) instead

Thanks,
Longfang.

> +
> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Pensando Systems, Inc");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> new file mode 100644
> index 000000000000..f8f4006c0915
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +
> +struct pds_vfio_pci_device *
> +pds_vfio_pci_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct pds_vfio_pci_device,
> +			    vfio_coredev);
> +}
> +
> +static int
> +pds_vfio_init_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	struct pci_dev *pdev = to_pci_dev(vdev->dev);
> +	int err;
> +
> +	err = vfio_pci_core_init_dev(vdev);
> +	if (err)
> +		return err;
> +
> +	pds_vfio->vf_id = pci_iov_vf_id(pdev);
> +	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
> +
> +	return 0;
> +}
> +
> +static int
> +pds_vfio_open_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	int err;
> +
> +	err = vfio_pci_core_enable(&pds_vfio->vfio_coredev);
> +	if (err)
> +		return err;
> +
> +	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
> +
> +	return 0;
> +}
> +
> +static const struct vfio_device_ops
> +pds_vfio_ops = {
> +	.name = "pds-vfio",
> +	.init = pds_vfio_init_device,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = pds_vfio_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +};
> +
> +const struct vfio_device_ops *
> +pds_vfio_ops_info(void)
> +{
> +	return &pds_vfio_ops;
> +}
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> new file mode 100644
> index 000000000000..289479a08dce
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#ifndef _VFIO_DEV_H_
> +#define _VFIO_DEV_H_
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +
> +struct pds_vfio_pci_device {
> +	struct vfio_pci_core_device vfio_coredev;
> +	struct pci_dev *pdev;
> +
> +	int vf_id;
> +	int pci_id;
> +};
> +
> +const struct vfio_device_ops *
> +pds_vfio_ops_info(void);
> +struct pds_vfio_pci_device *
> +pds_vfio_pci_drvdata(struct pci_dev *pdev);
> +
> +#endif /* _VFIO_DEV_H_ */
> diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
> index 6e92697657e4..4362b94a7666 100644
> --- a/include/linux/pds/pds_core_if.h
> +++ b/include/linux/pds/pds_core_if.h
> @@ -9,6 +9,7 @@
>  #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>  #define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
>  #define PCI_DEVICE_ID_PENSANDO_VDPA_VF          0x100b
> +#define PCI_DEVICE_ID_PENSANDO_NVME_VF		0x1006
>  
>  #define PDS_CORE_BARS_MAX			4
>  #define PDS_CORE_PCI_BAR_DBELL			1
> 
