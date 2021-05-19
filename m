Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91780388CD8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbhESLcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhESLc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 07:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F561611BF;
        Wed, 19 May 2021 11:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621423866;
        bh=dsffP4B2KxQ0TA2m4wAHg4MsBgQovUMUcSginK2ygdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTtZJUrQUHx7dKCNUnm0nSVkxQJt/m+OOxqCuzD4gwEu7KQWYljTf4D5QhMt9d24I
         UfrA8SPJlVn6Zq3KNYl4E6Zy+DRNr0MBSYgxTLGF4/dckU+UuWH2beZNVaLOSTa0RW
         Q0/NwzZbDQLjL1KmmvMqqiIiM9aijpCk62wGBb2i9kCA5j38pSq8vbTqp55R8IB3Rk
         wnYruVA5lC/meMQtIykr8zBqRNcT3boAIRnrC92Bo4sB79Q8Yy7dHvRrvxEWMKueOy
         Mk/Z/Ka6gzRabJNFatiG+Ktqk9otAMjlPhsSiCxBk6n/f7WeHW8n+/rojA4mOBIMSi
         YdnSApwxWl6FA==
Date:   Wed, 19 May 2021 14:31:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH v5 04/22] ice: Register auxiliary device to provide RDMA
Message-ID: <YKT292HPpKRmzDC4@unreal>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
 <20210514141214.2120-5-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514141214.2120-5-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 09:11:56AM -0500, Shiraz Saleem wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> Register ice client auxiliary RDMA device on the auxiliary bus per
> PCIe device function for the auxiliary driver (irdma) to attach to.
> It allows to realize a single RDMA driver (irdma) capable of working with
> multiple netdev drivers over multi-generation Intel HW supporting RDMA.
> There is no load ordering dependencies between ice and irdma.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/net/ethernet/intel/Kconfig        |  1 +
>  drivers/net/ethernet/intel/ice/ice.h      |  8 +++-
>  drivers/net/ethernet/intel/ice/ice_idc.c  | 71 ++++++++++++++++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_main.c | 11 ++++-
>  4 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index c1d1556..d8a12da 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -294,6 +294,7 @@ config ICE
>  	tristate "Intel(R) Ethernet Connection E800 Series Support"
>  	default n
>  	depends on PCI_MSI
> +	select AUXILIARY_BUS
>  	select DIMLIB
>  	select NET_DEVLINK
>  	select PLDMFW
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 225f8a5..228055e 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -34,6 +34,7 @@
>  #include <linux/if_bridge.h>
>  #include <linux/ctype.h>
>  #include <linux/bpf.h>
> +#include <linux/auxiliary_bus.h>
>  #include <linux/avf/virtchnl.h>
>  #include <linux/cpu_rmap.h>
>  #include <linux/dim.h>
> @@ -647,6 +648,8 @@ static inline void ice_clear_sriov_cap(struct ice_pf *pf)
>  void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
>  int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
>  void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
> +int ice_plug_aux_dev(struct ice_pf *pf);
> +void ice_unplug_aux_dev(struct ice_pf *pf);
>  int ice_init_rdma(struct ice_pf *pf);
>  const char *ice_stat_str(enum ice_status stat_err);
>  const char *ice_aq_str(enum ice_aq_err aq_err);
> @@ -678,8 +681,10 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
>   */
>  static inline void ice_set_rdma_cap(struct ice_pf *pf)
>  {
> -	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix)
> +	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
>  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> +		ice_plug_aux_dev(pf);
> +	}
>  }
>  
>  /**
> @@ -688,6 +693,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
>   */
>  static inline void ice_clear_rdma_cap(struct ice_pf *pf)
>  {
> +	ice_unplug_aux_dev(pf);
>  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
>  }
>  #endif /* _ICE_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
> index ffca0d5..e7bb8f6 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -255,6 +255,71 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
>  }
>  
>  /**
> + * ice_adev_release - function to be mapped to AUX dev's release op
> + * @dev: pointer to device to free
> + */
> +static void ice_adev_release(struct device *dev)
> +{
> +	struct iidc_auxiliary_dev *iadev;
> +
> +	iadev = container_of(dev, struct iidc_auxiliary_dev, adev.dev);
> +	kfree(iadev);
> +}
> +
> +/**
> + * ice_plug_aux_dev - allocate and register AUX device
> + * @pf: pointer to pf struct
> + */
> +int ice_plug_aux_dev(struct ice_pf *pf)
> +{
> +	struct iidc_auxiliary_dev *iadev;
> +	struct auxiliary_device *adev;
> +	int ret;
> +
> +	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
> +	if (!iadev)
> +		return -ENOMEM;
> +
> +	adev = &iadev->adev;
> +	pf->adev = adev;
> +	iadev->pf = pf;
> +
> +	adev->id = pf->aux_idx;
> +	adev->dev.release = ice_adev_release;
> +	adev->dev.parent = &pf->pdev->dev;
> +	adev->name = IIDC_RDMA_ROCE_NAME;

You declared IIDC_RDMA_ROCE_NAME as intel_rdma_roce, so it will create
extremely awful device name, something like irdma.intel_rdma_roce.0

I would say that "intel" and "rdma" can be probably dropped.

Thanks
