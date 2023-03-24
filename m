Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCBD6C87F4
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjCXWDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjCXWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:03:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FA810EB
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679695377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkdKpUhRJP9VEDGxy2ljm69baU8C0urR7xxEuXUu0S4=;
        b=i8v/Gu8GMwPi1cIKXu27Hq5KV90yLLmGsHNqFs5TyzzNAogc6gSzG8SnChiMy/xDZrie8x
        pNoKD29NX6gMry8c3f26J+1Rs4c7LNhjv9Z6yEtWvInhvMvo9lbDctOkmJwlRal8E7fss7
        ikVwkHR2tTXMhtSlgmzo7RmTU0+78fM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-A2LNqUeKMeyY7IYJA-r1zw-1; Fri, 24 Mar 2023 18:02:56 -0400
X-MC-Unique: A2LNqUeKMeyY7IYJA-r1zw-1
Received: by mail-io1-f70.google.com with SMTP id y69-20020a6bc848000000b00758ac1b67f8so1927476iof.17
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OkdKpUhRJP9VEDGxy2ljm69baU8C0urR7xxEuXUu0S4=;
        b=UG3YpHtfx80qTOQLpZ9K73CV2tmgJcLIdT4wD87EwUxE47/kbcNnez+vCmBF4ZAVUP
         CTTEA5t+pigR9uh/zu22ic7eEo4yC9sT5BWBLSA6PAQ3ENdE8PwefG1v0GsyRI3P7aYY
         x/61FmetSmk4Z408QXGDpQgBTVxMSzWl5YI7EsvS4rtkOYPapa8YceptHysafkJF7z+P
         8stZQTkGpQrKSXJ0oeS9QVuhDjZNZ5AhbZ5smF4xs2SObjdFkKwJwwm79DVIgpo811HY
         gPrMZWYmODkjnKrkVFrqNfk1PaisRjTGHtKpFILBDt6GpTN+9WAVNS4b+VYw8Zn5Zirf
         2Exg==
X-Gm-Message-State: AAQBX9fZyt9EcQD1+aRclbYzO8fa1kNDjBwT3l9sZhsaRcOOCn6dgqaC
        wOJGfI9Rct8CXuNmKC9uTo90m+l9FzTXPt0saqCbuHxnNwxJcO7BGJHbnK2nW5hC7bmDchuCl1+
        XMwZpcs9W6NnuX/xb
X-Received: by 2002:a92:4b0d:0:b0:325:a550:eb06 with SMTP id m13-20020a924b0d000000b00325a550eb06mr3385272ilg.12.1679695373992;
        Fri, 24 Mar 2023 15:02:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350b+rFxy4zjwUD6vkG3euFUvg4RTywX9D5pFpqRtI1jJWxwOUmi2DNeY3O6WonDJhZcnFqLVcg==
X-Received: by 2002:a92:4b0d:0:b0:325:a550:eb06 with SMTP id m13-20020a924b0d000000b00325a550eb06mr3385254ilg.12.1679695373621;
        Fri, 24 Mar 2023 15:02:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ce16-20020a0566381a9000b00404f3266fd7sm6938190jab.159.2023.03.24.15.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 15:02:53 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:02:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <shannon.nelson@amd.com>,
        <drviers@pensando.io>
Subject: Re: [PATCH v5 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <20230324160251.4014b4e5.alex.williamson@redhat.com>
In-Reply-To: <20230322203442.56169-4-brett.creeley@amd.com>
References: <20230322203442.56169-1-brett.creeley@amd.com>
        <20230322203442.56169-4-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 13:34:38 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> The pds_core driver will supply adminq services, so find the PF
> and register with the DSC services.
> 
> Use the following commands to enable a VF:
> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/Makefile   |  1 +
>  drivers/vfio/pci/pds/cmds.c     | 67 +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/cmds.h     | 12 ++++++
>  drivers/vfio/pci/pds/pci_drv.c  | 16 +++++++-
>  drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
>  drivers/vfio/pci/pds/vfio_dev.c |  5 +++
>  drivers/vfio/pci/pds/vfio_dev.h |  2 +
>  include/linux/pds/pds_lm.h      | 12 ++++++
>  8 files changed, 123 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vfio/pci/pds/cmds.c
>  create mode 100644 drivers/vfio/pci/pds/cmds.h
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>  create mode 100644 include/linux/pds/pds_lm.h
> 
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
> index e1a55ae0f079..87581111fa17 100644
> --- a/drivers/vfio/pci/pds/Makefile
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -4,5 +4,6 @@
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
>  
>  pds_vfio-y := \
> +	cmds.o		\
>  	pci_drv.o	\
>  	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> new file mode 100644
> index 000000000000..26e383ec4544
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/io.h>
> +#include <linux/types.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_lm.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +int
> +pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_comp comp = { 0 };
> +	union pds_core_adminq_cmd cmd = { 0 };
> +	struct device *dev;
> +	int err, id;
> +	u16 ci;
> +
> +	id = PCI_DEVID(pds_vfio->pdev->bus->number,
> +		       pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
> +
> +	dev = &pds_vfio->pdev->dev;
> +	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
> +	snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
> +		 "%s.%d", PDS_LM_DEV_NAME, id);

Does this devname need to be unique, and if so should it factor in
pci_domain_nr()?  The array seems to be wide enough to easily hold the
VF dev_name() but I haven't followed if there are additional
constraints.  Thanks,

Alex

> +
> +	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
> +	if (err) {
> +		dev_info(dev, "register with DSC failed, status %d: %pe\n",
> +			 comp.status, ERR_PTR(err));
> +		return err;
> +	}
> +
> +	ci = le16_to_cpu(comp.client_reg.client_id);
> +	if (!ci) {
> +		dev_err(dev, "%s: device returned null client_id\n", __func__);
> +		return -EIO;
> +	}
> +	pds_vfio->client_id = ci;
> +
> +	return 0;
> +}
> +
> +void
> +pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_comp comp = { 0 };
> +	union pds_core_adminq_cmd cmd = { 0 };
> +	struct device *dev;
> +	int err;
> +
> +	dev = &pds_vfio->pdev->dev;
> +	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
> +	cmd.client_unreg.client_id = cpu_to_le16(pds_vfio->client_id);
> +
> +	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
> +	if (err)
> +		dev_info(dev, "unregister from DSC failed, status %d: %pe\n",
> +			 comp.status, ERR_PTR(err));
> +
> +	pds_vfio->client_id = 0;
> +}
> diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
> new file mode 100644
> index 000000000000..baf0695b5576
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _CMDS_H_
> +#define _CMDS_H_
> +
> +struct pds_vfio_pci_device;
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
> +
> +#endif /* _CMDS_H_ */
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> index 5e554420792e..46537afdee2d 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -8,9 +8,13 @@
>  #include <linux/types.h>
>  #include <linux/vfio.h>
>  
> +#include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
>  
>  #include "vfio_dev.h"
> +#include "pci_drv.h"
> +#include "cmds.h"
>  
>  #define PDS_VFIO_DRV_NAME		"pds_vfio"
>  #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
> @@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
>  
>  	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>  	pds_vfio->pdev = pdev;
> +	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
> +
> +	err = pds_vfio_register_client_cmd(pds_vfio);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to register as client: %pe\n",
> +			ERR_PTR(err));
> +		goto out_put_vdev;
> +	}
>  
>  	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>  	if (err)
> -		goto out_put_vdev;
> +		goto out_unreg_client;
>  
>  	return 0;
>  
> +out_unreg_client:
> +	pds_vfio_unregister_client_cmd(pds_vfio);
>  out_put_vdev:
>  	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>  	return err;
> diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
> new file mode 100644
> index 000000000000..e79bed12ed14
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/pci_drv.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _PCI_DRV_H
> +#define _PCI_DRV_H
> +
> +#include <linux/pci.h>
> +
> +#endif /* _PCI_DRV_H */
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index f1221f14e4f6..592b10a279f0 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -31,6 +31,11 @@ pds_vfio_init_device(struct vfio_device *vdev)
>  	pds_vfio->vf_id = pci_iov_vf_id(pdev);
>  	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>  
> +	dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
> +		__func__, pci_dev_id(pdev->physfn),
> +		pds_vfio->pci_id, pds_vfio->pci_id, pds_vfio->vf_id,
> +		pci_domain_nr(pdev->bus), pds_vfio);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> index a66f8069b88c..0c7932c6e1e8 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -10,9 +10,11 @@
>  struct pds_vfio_pci_device {
>  	struct vfio_pci_core_device vfio_coredev;
>  	struct pci_dev *pdev;
> +	struct pdsc *pdsc;
>  
>  	int vf_id;
>  	int pci_id;
> +	u16 client_id;
>  };
>  
>  const struct vfio_device_ops *pds_vfio_ops_info(void);
> diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
> new file mode 100644
> index 000000000000..2bc2bf79426e
> --- /dev/null
> +++ b/include/linux/pds/pds_lm.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2022 Pensando Systems, Inc */
> +
> +#ifndef _PDS_LM_H_
> +#define _PDS_LM_H_
> +
> +#include "pds_common.h"
> +
> +#define PDS_DEV_TYPE_LM_STR	"LM"
> +#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
> +
> +#endif /* _PDS_LM_H_ */

