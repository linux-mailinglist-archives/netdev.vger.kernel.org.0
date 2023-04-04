Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBDF6D680C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjDDP6D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Apr 2023 11:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjDDP5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:57:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7DC40FD;
        Tue,  4 Apr 2023 08:57:24 -0700 (PDT)
Received: from lhrpeml100004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PrX0k5wXDz67QSs;
        Tue,  4 Apr 2023 23:36:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100004.china.huawei.com (7.191.162.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 4 Apr 2023 16:36:52 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Tue, 4 Apr 2023 16:36:52 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
CC:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>
Subject: RE: [PATCH v7 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Thread-Topic: [PATCH v7 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Thread-Index: AQHZY2jany1ARLMPKUScPIkzk/Kj7q8bTOWA
Date:   Tue, 4 Apr 2023 15:36:52 +0000
Message-ID: <bfef568736b34c3988bbc463b1be91ce@huawei.com>
References: <20230331003612.17569-1-brett.creeley@amd.com>
 <20230331003612.17569-3-brett.creeley@amd.com>
In-Reply-To: <20230331003612.17569-3-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.155.16]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 31 March 2023 01:36
> To: kvm@vger.kernel.org; netdev@vger.kernel.org;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kevin.tian@intel.com
> Cc: brett.creeley@amd.com; shannon.nelson@amd.com;
> drivers@pensando.io; simon.horman@corigine.com
> Subject: [PATCH v7 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO driver
> 
> This is the initial framework for the new pds_vfio device driver. This
> does the very basics of registering the PDS PCI device and configuring
> it as a VFIO PCI device.
> 
> With this change, the VF device can be bound to the pds_vfio driver on
> the host and presented to the VM as the VF's device type.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/Makefile       |  2 +
>  drivers/vfio/pci/pds/Makefile   |  8 ++++
>  drivers/vfio/pci/pds/pci_drv.c  | 74
> +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/vfio_dev.c | 74 +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/vfio_dev.h | 21 ++++++++++
>  5 files changed, 179 insertions(+)
>  create mode 100644 drivers/vfio/pci/pds/Makefile
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
> 
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 24c524224da5..45167be462d8 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> 
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> +
> +obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
> new file mode 100644
> index 000000000000..e1a55ae0f079
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Advanced Micro Devices, Inc.
> +
> +obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
> +
> +pds_vfio-y := \
> +	pci_drv.o	\
> +	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> new file mode 100644
> index 000000000000..5e554420792e
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
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
> +#define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device
> Driver"
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
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_PENSANDO,
> 0x1003) }, /* Ethernet VF */
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
> +module_pci_driver(pds_vfio_pci_driver);
> +
> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Advanced Micro Devices, Inc.");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> new file mode 100644
> index 000000000000..f1221f14e4f6
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +
> +struct pds_vfio_pci_device *
> +pds_vfio_pci_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device =
> dev_get_drvdata(&pdev->dev);
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

Hi,

Any reason why this driver is not providing the default iommufd
callbacks(bind/unbind/attach) ?

Thanks,
Shameer

> +
> +const struct vfio_device_ops *
> +pds_vfio_ops_info(void)
> +{
> +	return &pds_vfio_ops;
> +}
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> new file mode 100644
> index 000000000000..a66f8069b88c
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
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
> +const struct vfio_device_ops *pds_vfio_ops_info(void);
> +struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
> +
> +#endif /* _VFIO_DEV_H_ */
> --
> 2.17.1

