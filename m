Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CE5118CC2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLJPkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfLJPkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 10:40:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77F38206D5;
        Tue, 10 Dec 2019 15:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575992401;
        bh=oAC4tgr1G3fJw6y2dBgr994HWOHowaSSAxovKb0AOIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=si4ucwK9rUhJRuOwMdb7jPNudjIX0wgcS1UYu+EvIhL3YMQZxfKkCZdhKA8PSAmfj
         nF/ewOxUajbifRDOEypejE7K3dDT70JB4ekZ+HCOEDC4tY0U5gfGGU4H2uvWU5sP4Z
         sp/+7a7vQG7zQXVm7zSdBL3gSgaeZ0msT/k54QWQ=
Date:   Tue, 10 Dec 2019 16:39:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Shiraz Saleem <shiraz.saleem@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Message-ID: <20191210153959.GD4053085@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:19PM -0800, Jeff Kirsher wrote:
> From: Shiraz Saleem <shiraz.saleem@intel.com>
> 
> Register client virtbus device on the virtbus for the RDMA
> virtbus driver (irdma) to bind to. It allows to realize a
> single RDMA driver capable of working with multiple netdev
> drivers over multi-generation Intel HW supporting RDMA.
> There is also no load ordering dependencies between i40e and
> irdma.
> 
> Summary of changes:
> * Support to add/remove virtbus devices
> * Add 2 new client ops.
> 	* i40e_client_device_register() which is called during RDMA
> 	  probe() per PF. Validate client drv OPs and schedule service
> 	  task to call open()
> 	* i40e_client_device_unregister() called during RDMA remove()
> 	  per PF. Call client close() and release_qvlist.
> * The global register/unregister calls exported for i40iw are retained
>   until i40iw is removed from the kernel.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/infiniband/hw/i40iw/Makefile          |   1 -
>  drivers/infiniband/hw/i40iw/i40iw.h           |   2 +-
>  drivers/net/ethernet/intel/Kconfig            |   1 +
>  drivers/net/ethernet/intel/i40e/i40e.h        |   3 +-
>  drivers/net/ethernet/intel/i40e/i40e_client.c | 109 +++++++++++++++---
>  .../linux/net/intel}/i40e_client.h            |  20 +++-
>  6 files changed, 112 insertions(+), 24 deletions(-)
>  rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (92%)
> 
> diff --git a/drivers/infiniband/hw/i40iw/Makefile b/drivers/infiniband/hw/i40iw/Makefile
> index 8942f8229945..34da9eba8a7c 100644
> --- a/drivers/infiniband/hw/i40iw/Makefile
> +++ b/drivers/infiniband/hw/i40iw/Makefile
> @@ -1,5 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
> -ccflags-y :=  -I $(srctree)/drivers/net/ethernet/intel/i40e
>  
>  obj-$(CONFIG_INFINIBAND_I40IW) += i40iw.o
>  
> diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
> index 8feec35f95a7..3197e3536d5c 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw.h
> +++ b/drivers/infiniband/hw/i40iw/i40iw.h
> @@ -57,7 +57,7 @@
>  #include "i40iw_d.h"
>  #include "i40iw_hmc.h"
>  
> -#include <i40e_client.h>
> +#include <linux/net/intel/i40e_client.h>
>  #include "i40iw_type.h"
>  #include "i40iw_p.h"
>  #include <rdma/i40iw-abi.h>
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index b88328fea1d0..8595f578fbe7 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -241,6 +241,7 @@ config I40E
>  	tristate "Intel(R) Ethernet Controller XL710 Family support"
>  	imply PTP_1588_CLOCK
>  	depends on PCI
> +	select VIRTUAL_BUS
>  	---help---
>  	  This driver supports Intel(R) Ethernet Controller XL710 Family of
>  	  devices.  For more information on how to identify your adapter, go
> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> index cb6367334ca7..4321e81d347c 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> @@ -38,7 +38,7 @@
>  #include <net/xdp_sock.h>
>  #include "i40e_type.h"
>  #include "i40e_prototype.h"
> -#include "i40e_client.h"
> +#include <linux/net/intel/i40e_client.h>
>  #include <linux/avf/virtchnl.h>
>  #include "i40e_virtchnl_pf.h"
>  #include "i40e_txrx.h"
> @@ -655,6 +655,7 @@ struct i40e_pf {
>  	u16 last_sw_conf_valid_flags;
>  	/* List to keep previous DDP profiles to be rolled back in the future */
>  	struct list_head ddp_old_prof;
> +	int peer_idx;
>  };
>  
>  /**
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
> index e81530ca08d0..a3dee729719b 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_client.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
> @@ -1,12 +1,12 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright(c) 2013 - 2018 Intel Corporation. */
>  
> +#include <linux/net/intel/i40e_client.h>
>  #include <linux/list.h>
>  #include <linux/errno.h>
>  
>  #include "i40e.h"
>  #include "i40e_prototype.h"
> -#include "i40e_client.h"
>  
>  static const char i40e_client_interface_version_str[] = I40E_CLIENT_VERSION_STR;
>  static struct i40e_client *registered_client;
> @@ -30,11 +30,17 @@ static int i40e_client_update_vsi_ctxt(struct i40e_info *ldev,
>  				       bool is_vf, u32 vf_id,
>  				       u32 flag, u32 valid_flag);
>  
> +static int i40e_client_device_register(struct i40e_info *ldev);
> +
> +static void i40e_client_device_unregister(struct i40e_info *ldev);
> +
>  static struct i40e_ops i40e_lan_ops = {
>  	.virtchnl_send = i40e_client_virtchnl_send,
>  	.setup_qvlist = i40e_client_setup_qvlist,
>  	.request_reset = i40e_client_request_reset,
>  	.update_vsi_ctxt = i40e_client_update_vsi_ctxt,
> +	.client_device_register = i40e_client_device_register,
> +	.client_device_unregister = i40e_client_device_unregister,
>  };
>  
>  /**
> @@ -275,6 +281,27 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
>  	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
>  }
>  
> +static int i40e_init_client_virtdev(struct i40e_pf *pf)
> +{
> +	struct i40e_info *ldev = &pf->cinst->lan_info;
> +	struct pci_dev *pdev = pf->pdev;
> +	struct virtbus_device *vdev;
> +	int ret;
> +
> +	vdev = &ldev->vdev;
> +	vdev->name = I40E_PEER_RDMA_NAME;
> +	vdev->dev.parent = &pf->pdev->dev;

What a total and complete mess of a tangled web you just wove here.

Ok, so you pass in a single pointer, that then dereferences 3 pointers
deep to find the pointer to the virtbus_device structure, but then you
point the parent of that device, back at the original structure's
sub-pointer's device itself.

WTF?

And who owns the memory of this thing that is supposed to be
dynamically controlled by something OUTSIDE of this driver?  Who created
that thing 3 pointers deep?  What happens when you leak the memory below
(hint, you did), and who is supposed to clean it up if you need to
properly clean it up if something bad happens?

> +
> +	ret = virtbus_dev_register(vdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failure adding client virtbus dev %s %d\n",
> +			I40E_PEER_RDMA_NAME, ret);

Again, the core should handle this, right?

> +		return ret;

Did you just leak memory?

Yup, you did, you never actually checked the return value of this
function :(

Ugh.

I feel like the virtual bus code is getting better, but this use of the
code, um, no, not ok.

Either way, this series is NOT ready to be merged anywhere, please do
not try to rush things.

Also, what ever happened to my "YOU ALL MUST AGREE TO WORK TOGETHER"
requirement between this group, and the other group trying to do the
same thing?  I want to see signed-off-by from EVERYONE involved before
we are going to consider this thing.

thanks,

greg k-h
