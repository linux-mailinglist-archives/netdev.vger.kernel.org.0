Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A533B6DCC39
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 22:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDJUmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 16:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJUmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 16:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D0019A8
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 13:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681159314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vzKWp3SjV4UXwjPHMyrsBH+AoS2v8O725iundtJdVbI=;
        b=A6GGARj7iq/S7R5we7sVQcpvzNsK2GYGnrgv220PyQzrfubR5ScXs9sFZBelCFKb8PkHwR
        RG+6qrL3YgqUtePPKDmfGh+vztdMJ4QPhxfwDsezBWvDAoTWaVJa9kxK/ZI2td/5sAi/o1
        yGayKwGaMMvRF6zZIGQheoFwJg5mtZo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-mwEks_7RNEKjWSyliDBm5Q-1; Mon, 10 Apr 2023 16:41:53 -0400
X-MC-Unique: mwEks_7RNEKjWSyliDBm5Q-1
Received: by mail-io1-f71.google.com with SMTP id p68-20020a6b8d47000000b007583ebb18fdso4366286iod.19
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 13:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681159312; x=1683751312;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vzKWp3SjV4UXwjPHMyrsBH+AoS2v8O725iundtJdVbI=;
        b=QsX6VOtxiP9qGqjZXDJlpngou4/oozJIkxE2feEOsU8aAGz2DPF75zZPTmfVlSjDv9
         4+gjoqs0oubDxPGHTQmrv00tpewNUWMqGudCsmPwdvCXxz3wtOQJraOdb4ofUh8FJ43z
         KDLwXl8MubMWN0IYgd1ATmfYMFgOuitDYkt1tGk3p5pHyU5sGdmt7Sxhs+VULV0VrbSu
         cIAkMX4HJyUc69mmEjk3WEgTn+KPJ2rSvhNEaDjK966liI6nGur6/nUaCqbJQJhu5TEI
         9kAnMqedkMjp4YKE88k4Q2ujgGLVcxNHhM+JNbjtZ660L6FaM+WAoXR7h70TGd35RtBF
         sYpQ==
X-Gm-Message-State: AAQBX9e7gfkJJrSdKh0r12VyWW0K48h8wsVXPQbhTi7LgqKLagFuNb2/
        4pwOHH8hJiH7kFn42WWPl7NZMFVlO6+zXN9p6xTiTVUOx9XxIoFlSqEepJJir0yA7eYYwG2b2/i
        LTEj4x0jNDp+DO0eS
X-Received: by 2002:a6b:d908:0:b0:753:989:ebb5 with SMTP id r8-20020a6bd908000000b007530989ebb5mr7160630ioc.7.1681159312226;
        Mon, 10 Apr 2023 13:41:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350aqM9kknOX0dNZu4ELwrc46JKRUXSmrC8Xz//1Q26RiZmrlYcHMe8O+vMKG+LscMcH1lPvzHA==
X-Received: by 2002:a6b:d908:0:b0:753:989:ebb5 with SMTP id r8-20020a6bd908000000b007530989ebb5mr7160617ioc.7.1681159311932;
        Mon, 10 Apr 2023 13:41:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e2-20020a5d8ac2000000b007594fbab87fsm3333809iot.1.2023.04.10.13.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 13:41:51 -0700 (PDT)
Date:   Mon, 10 Apr 2023 14:41:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: Re: [PATCH v8 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <20230410144149.6a602c6e.alex.williamson@redhat.com>
In-Reply-To: <20230404190141.57762-4-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
        <20230404190141.57762-4-brett.creeley@amd.com>
Organization: Red Hat
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

On Tue, 4 Apr 2023 12:01:37 -0700
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
>  drivers/vfio/pci/pds/cmds.c     | 69 +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/cmds.h     | 10 +++++
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
> index 000000000000..7807dbb2c72c
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -0,0 +1,69 @@
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
> +	int err;
> +	u32 id;
> +	u16 ci;
> +
> +	id = PCI_DEVID(pds_vfio->pdev->bus->number,
> +		       pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));

Does this actually work?

pds_vfio_pci_probe() is presumably called with a VF pdev because it
calls pdsc_get_pf_struct() -> pci_iov_get_pf_drvdata(), which returns
an error if !dev->is_virtfn.  pds_vfio_init_device() also stores the
vf_id from pci_iov_vf_id(), which requires that it's called on a VF,
not PF.  This same pdev gets stored at pds_vfio->pdev.

OTOH, pci_iov_virtfn_devfn() used here errors if !dev->is_physfn.  So I
expect we're calling PCI_DEVID with the second arg as -EINVAL.  The
first arg would also be suspicious if pds_vfio->pdev were the PF since
then we'd be making a PCI_DEVID combining the PF bus number and the VF
devfn.

We've also already stored the VF PCI_DEVID at pds_vfio->pci_id, so
creating it again seems entirely unnecessary.

Also, since we never check the return of pdsc_get_pf_struct() I'd guess
we take a segfault referencing off of pds_vfio->pdsc should the driver
bind to something other than expected.  Validating the PF drvdata
before anything else seems like a good first stop in
pds_vfio_pci_probe().

It's also a little curious why we're storing the pdev at all  in the
pds_vfio_pci_device when it's readily available from the embedded
vfio_pci_core_device.  Thanks,

Alex

> +
> +	dev = &pds_vfio->pdev->dev;
> +	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
> +	snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
> +		 "%s.%d-%u", PDS_LM_DEV_NAME,
> +		 pci_domain_nr(pds_vfio->pdev->bus), id);
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
> index 000000000000..4c592afccf89
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _CMDS_H_
> +#define _CMDS_H_
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
> index 0f70efec01e1..056715dea512 100644
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
> index a66f8069b88c..10557e8dc829 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -10,9 +10,11 @@
>  struct pds_vfio_pci_device {
>  	struct vfio_pci_core_device vfio_coredev;
>  	struct pci_dev *pdev;
> +	void *pdsc;
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

