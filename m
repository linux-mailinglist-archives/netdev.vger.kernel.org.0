Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519526DBFD1
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 14:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDIMXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 08:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIMXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 08:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D0F359E
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 05:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5427660B86
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 12:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E5C433D2;
        Sun,  9 Apr 2023 12:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681043000;
        bh=PiunAeqSJnX599m/WFFy/F83c9QmZysQ8vCMYH52Hqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ueQ4G4/v1rNyQThmuDuZfYE7RI479QzXE1OJAMx+TDelmvUfxXuG8NdYqoCfBJsOc
         wPSLPiFGgdxhbw9C1uRZJd7XRTSBqmTCZK8XZInCyXKtAii4BoRl/oLCZMVvH1pPHh
         EY8FRC59xCV9hW5rwHCB09J/jUEocC0YqQbRM2z8np02jEeOX/ycewZmgbej7KfF02
         8AexjG9RDnScOnC1QiLyFTmSNnfBBm8kNambWwsaGgDYWWDC8IHRPQcWsYKUCK+rX3
         vEIxiiJlONoOPyExOPDrjPfoZ3FDDu3MOoIZDlr0qX8yu1QcphzQ8hwxCd7qxpNPL3
         +q/ZEhTThpq5g==
Date:   Sun, 9 Apr 2023 15:23:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 10/14] pds_core: add auxiliary_bus devices
Message-ID: <20230409122316.GF182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-11-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-11-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:39PM -0700, Shannon Nelson wrote:
> An auxiliary_bus device is created for each vDPA type VF at VF
> probe and destroyed at VF remove.  The aux device name comes
> from the driver name + VIF type + the unique id assigned at PCI
> probe.  The VFs are always removed on PF remove, so there should
> be no issues with VFs trying to access missing PF structures.
> 
> The auxiliary_device names will look like "pds_core.vDPA.nn"
> where 'nn' is the VF's uid.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>  drivers/net/ethernet/amd/pds_core/auxbus.c | 112 +++++++++++++++++++++
>  drivers/net/ethernet/amd/pds_core/core.h   |   6 ++
>  drivers/net/ethernet/amd/pds_core/main.c   |  36 ++++++-
>  include/linux/pds/pds_auxbus.h             |  16 +++
>  include/linux/pds/pds_common.h             |   1 +
>  6 files changed, 170 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
>  create mode 100644 include/linux/pds/pds_auxbus.h
> 
> diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
> index 6d1d6c58a1fa..0abc33ce826c 100644
> --- a/drivers/net/ethernet/amd/pds_core/Makefile
> +++ b/drivers/net/ethernet/amd/pds_core/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
>  
>  pds_core-y := main.o \
>  	      devlink.o \
> +	      auxbus.o \
>  	      dev.o \
>  	      adminq.o \
>  	      core.o \
> diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
> new file mode 100644
> index 000000000000..6757a5174eb7
> --- /dev/null
> +++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/pci.h>
> +
> +#include "core.h"
> +#include <linux/pds/pds_auxbus.h>
> +
> +static void pdsc_auxbus_dev_release(struct device *dev)
> +{
> +	struct pds_auxiliary_dev *padev =
> +		container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
> +
> +	kfree(padev);
> +}
> +
> +static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
> +							  struct pdsc *pf,
> +							  char *name)
> +{
> +	struct auxiliary_device *aux_dev;
> +	struct pds_auxiliary_dev *padev;
> +	int err;
> +
> +	padev = kzalloc(sizeof(*padev), GFP_KERNEL);
> +	if (!padev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	padev->vf_pdev = vf->pdev;
> +	padev->pf_pdev = pf->pdev;

Why do you need to store pointer to PF device in your VF devices?
pci_physfn() will return it from vf_pdev for you.

> +
> +	aux_dev = &padev->aux_dev;
> +	aux_dev->name = name;
> +	aux_dev->id = vf->uid;
> +	aux_dev->dev.parent = vf->dev;
> +	aux_dev->dev.release = pdsc_auxbus_dev_release;
> +
> +	err = auxiliary_device_init(aux_dev);
> +	if (err < 0) {
> +		dev_warn(vf->dev, "auxiliary_device_init of %s failed: %pe\n",
> +			 name, ERR_PTR(err));
> +		goto err_out;
> +	}
> +
> +	err = auxiliary_device_add(aux_dev);
> +	if (err) {
> +		dev_warn(vf->dev, "auxiliary_device_add of %s failed: %pe\n",
> +			 name, ERR_PTR(err));
> +		goto err_out_uninit;
> +	}
> +
> +	return padev;
> +
> +err_out_uninit:
> +	auxiliary_device_uninit(aux_dev);
> +err_out:
> +	kfree(padev);
> +	return ERR_PTR(err);
> +}
> +
> +int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
> +{
> +	struct pds_auxiliary_dev *padev;
> +	int err = 0;
> +
> +	mutex_lock(&pf->config_lock);
> +
> +	padev = pf->vfs[vf->vf_id].padev;
> +	if (padev) {
> +		auxiliary_device_delete(&padev->aux_dev);
> +		auxiliary_device_uninit(&padev->aux_dev);
> +	}
> +	pf->vfs[vf->vf_id].padev = NULL;
> +
> +	mutex_unlock(&pf->config_lock);
> +	return err;
> +}
> +
> +int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
> +{
> +	struct pds_auxiliary_dev *padev;
> +	enum pds_core_vif_types vt;
> +	int err = 0;
> +
> +	mutex_lock(&pf->config_lock);
> +
> +	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
> +		u16 vt_support;
> +
> +		/* Verify that the type is supported and enabled */
> +		vt_support = !!le16_to_cpu(pf->dev_ident.vif_types[vt]);
> +		if (!(vt_support &&
> +		      pf->viftype_status[vt].supported &&
> +		      pf->viftype_status[vt].enabled))
> +			continue;
> +
> +		padev = pdsc_auxbus_dev_register(vf, pf,
> +						 pf->viftype_status[vt].name);
> +		if (IS_ERR(padev)) {
> +			err = PTR_ERR(padev);
> +			goto out_unlock;
> +		}
> +		pf->vfs[vf->vf_id].padev = padev;
> +
> +		/* We only support a single type per VF, so jump out here */
> +		break;

You need to decide, or you implement loop correctly (without break and
proper unfolding) or you don't implement loop yet at all.

And can we please find another name for functions and parameters which
don't include VF in it as it is not correct anymore.

In ideal world, it will be great to have same probe flow for PF and VF
while everything is controlled through FW and auxbus. For PF, you won't
advertise any aux devices, but the flow will continue to be the same.

Thanks

> +	}
> +
> +out_unlock:
> +	mutex_unlock(&pf->config_lock);
> +	return err;
> +}
> diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
> index 5be2b986c4d9..16b20bd705e4 100644
> --- a/drivers/net/ethernet/amd/pds_core/core.h
> +++ b/drivers/net/ethernet/amd/pds_core/core.h
> @@ -30,8 +30,11 @@ struct pdsc_dev_bar {
>  	int res_index;
>  };
>  
> +struct pdsc;
> +
>  struct pdsc_vf {
>  	struct pds_auxiliary_dev *padev;
> +	struct pdsc *vf;
>  	u16     index;
>  	__le16  vif_types[PDS_DEV_TYPE_MAX];
>  };
> @@ -300,6 +303,9 @@ int pdsc_start(struct pdsc *pdsc);
>  void pdsc_stop(struct pdsc *pdsc);
>  void pdsc_health_thread(struct work_struct *work);
>  
> +int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
> +int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
> +
>  void pdsc_process_adminq(struct pdsc_qcq *qcq);
>  void pdsc_work_thread(struct work_struct *work);
>  irqreturn_t pdsc_adminq_isr(int irq, void *data);
> diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
> index 5bda66d2a0df..16a2d8a048a3 100644
> --- a/drivers/net/ethernet/amd/pds_core/main.c
> +++ b/drivers/net/ethernet/amd/pds_core/main.c
> @@ -180,6 +180,12 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
>  static int pdsc_init_vf(struct pdsc *vf)
>  {
>  	struct devlink *dl;
> +	struct pdsc *pf;
> +	int err;
> +
> +	pf = pdsc_get_pf_struct(vf->pdev);
> +	if (IS_ERR_OR_NULL(pf))
> +		return PTR_ERR(pf) ?: -1;
>  
>  	vf->vf_id = pci_iov_vf_id(vf->pdev);
>  
> @@ -188,7 +194,15 @@ static int pdsc_init_vf(struct pdsc *vf)
>  	devl_register(dl);
>  	devl_unlock(dl);
>  
> -	return 0;
> +	pf->vfs[vf->vf_id].vf = vf;
> +	err = pdsc_auxbus_dev_add_vf(vf, pf);
> +	if (err) {
> +		devl_lock(dl);
> +		devl_unregister(dl);
> +		devl_unlock(dl);
> +	}
> +
> +	return err;
>  }
>  
>  static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
> @@ -379,7 +393,19 @@ static void pdsc_remove(struct pci_dev *pdev)
>  	}
>  	devl_unlock(dl);
>  
> -	if (!pdev->is_virtfn) {
> +	if (pdev->is_virtfn) {
> +		struct pdsc *pf;
> +
> +		pf = pdsc_get_pf_struct(pdsc->pdev);
> +		if (!IS_ERR(pf)) {
> +			pdsc_auxbus_dev_del_vf(pdsc, pf);
> +			pf->vfs[pdsc->vf_id].vf = NULL;
> +		}
> +	} else {
> +		/* Remove the VFs and their aux_bus connections before other
> +		 * cleanup so that the clients can use the AdminQ to cleanly
> +		 * shut themselves down.
> +		 */
>  		pdsc_sriov_configure(pdev, 0);
>  
>  		del_timer_sync(&pdsc->wdtimer);
> @@ -419,6 +445,12 @@ static struct pci_driver pdsc_driver = {
>  	.sriov_configure = pdsc_sriov_configure,
>  };
>  
> +void *pdsc_get_pf_struct(struct pci_dev *vf_pdev)
> +{
> +	return pci_iov_get_pf_drvdata(vf_pdev, &pdsc_driver);
> +}
> +EXPORT_SYMBOL_GPL(pdsc_get_pf_struct);
> +
>  static int __init pdsc_init_module(void)
>  {
>  	pdsc_debugfs_create();
> diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
> new file mode 100644
> index 000000000000..aa0192af4a29
> --- /dev/null
> +++ b/include/linux/pds/pds_auxbus.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _PDSC_AUXBUS_H_
> +#define _PDSC_AUXBUS_H_
> +
> +#include <linux/auxiliary_bus.h>
> +
> +struct pds_auxiliary_dev {
> +	struct auxiliary_device aux_dev;
> +	struct pci_dev *vf_pdev;
> +	struct pci_dev *pf_pdev;
> +	u16 client_id;
> +	void *priv;
> +};
> +#endif /* _PDSC_AUXBUS_H_ */
> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
> index 350295091d9d..898f3c7b14b7 100644
> --- a/include/linux/pds/pds_common.h
> +++ b/include/linux/pds/pds_common.h
> @@ -91,4 +91,5 @@ enum pds_core_logical_qtype {
>  	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
>  };
>  
> +void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
>  #endif /* _PDS_COMMON_H_ */
> -- 
> 2.17.1
> 
