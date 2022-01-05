Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE8484EA9
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 08:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiAEHTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 02:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiAEHTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 02:19:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1059AC061761;
        Tue,  4 Jan 2022 23:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B758961671;
        Wed,  5 Jan 2022 07:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571A1C36AE3;
        Wed,  5 Jan 2022 07:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641367149;
        bh=VYnahk5EgZvYfCNM9v+X0rxi6o7/fOUowHA8VDmAD5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXMPNjg3XfHn1hbCHOVjA4BgZkISV6LajhQc1jbYr8tjkjiTeM0P36TZ4QOOcGoHM
         lxYJKAghnXBrN7iolpSqeXgOlbFX0d1YSWxU5yWqQVCSodJvK1gG4KppqEtZaicmTG
         L73t1jygT7J1XgEi+e7CM6NFD92Z5mX8WWgXO3ki2Zzysavz+cXSf/zd43LqRwvgVj
         NcGzjdFoO24Wj6z1BmjkWpWji+WkjED+qTjLmcMW1usOBQLBUQRXuYb+i8uwHW06dA
         zBhnjsu7/4+akjE7Gh7VGaeg/HNxHcUexrH4crd4FtNq/Uae5UGvzIwGe11lSEWnUX
         MYO7uglO/gdoQ==
Date:   Wed, 5 Jan 2022 09:19:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: Re: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA
 support
Message-ID: <YdVGaK1uMUv7frZ1@unreal>
References: <20220105000456.2510590-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105000456.2510590-1-anthony.l.nguyen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 04:04:56PM -0800, Tony Nguyen wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The status of support for RDMA is currently being tracked with two
> separate status flags.  This is unnecessary with the current state of
> the driver.
> 
> Simplify status tracking down to a single flag.
> 
> Rename the helper function to denote the RDMA specific status and
> universally use the helper function to test the status bit.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |  3 ---
>  drivers/net/ethernet/intel/ice/ice_idc.c  |  6 +++---
>  drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++++----
>  drivers/net/ethernet/intel/ice/ice_lib.h  |  2 +-
>  drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++--------
>  5 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 4e16d185077d..6f445cc3390f 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -468,7 +468,6 @@ enum ice_pf_flags {
>  	ICE_FLAG_FD_ENA,
>  	ICE_FLAG_PTP_SUPPORTED,		/* PTP is supported by NVM */
>  	ICE_FLAG_PTP,			/* PTP is enabled by software */
> -	ICE_FLAG_AUX_ENA,
>  	ICE_FLAG_ADV_FEATURES,
>  	ICE_FLAG_TC_MQPRIO,		/* support for Multi queue TC */
>  	ICE_FLAG_CLS_FLOWER,
> @@ -886,7 +885,6 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
>  {
>  	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
>  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> -		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
>  		ice_plug_aux_dev(pf);
>  	}
>  }
> @@ -899,6 +897,5 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
>  {
>  	ice_unplug_aux_dev(pf);
>  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> -	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
>  }
>  #endif /* _ICE_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
> index fc3580167e7b..9493a38182f5 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -79,7 +79,7 @@ int ice_add_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset)
>  
>  	dev = ice_pf_to_dev(pf);
>  
> -	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> +	if (!ice_is_rdma_ena(pf))
>  		return -EINVAL;
>  
>  	vsi = ice_get_main_vsi(pf);
> @@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
>   */
>  static int ice_reserve_rdma_qvector(struct ice_pf *pf)
>  {
> -	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> +	if (ice_is_rdma_ena(pf)) {
>  		int index;
>  
>  		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
> @@ -274,7 +274,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>  	/* if this PF doesn't support a technology that requires auxiliary
>  	 * devices, then gracefully exit
>  	 */
> -	if (!ice_is_aux_ena(pf))
> +	if (!ice_is_rdma_ena(pf))
>  		return 0;

This check is redundant, you already checked it in ice_probe.

>  
>  	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 0c187cf04fcf..b1c164b8066c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -732,14 +732,14 @@ bool ice_is_safe_mode(struct ice_pf *pf)
>  }
>  
>  /**
> - * ice_is_aux_ena
> + * ice_is_rdma_ena
>   * @pf: pointer to the PF struct
>   *
> - * returns true if AUX devices/drivers are supported, false otherwise
> + * returns true if RDMA is currently supported, false otherwise
>   */
> -bool ice_is_aux_ena(struct ice_pf *pf)
> +bool ice_is_rdma_ena(struct ice_pf *pf)
>  {
> -	return test_bit(ICE_FLAG_AUX_ENA, pf->flags);
> +	return test_bit(ICE_FLAG_RDMA_ENA, pf->flags);
>  }
>  
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
> index b2ed189527d6..a2f54fbdc170 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.h
> @@ -110,7 +110,7 @@ void ice_set_q_vector_intrl(struct ice_q_vector *q_vector);
>  int ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
>  
>  bool ice_is_safe_mode(struct ice_pf *pf);
> -bool ice_is_aux_ena(struct ice_pf *pf);
> +bool ice_is_rdma_ena(struct ice_pf *pf);
>  bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
>  
>  bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index e29176889c23..078eb588f41e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3653,11 +3653,8 @@ static void ice_set_pf_caps(struct ice_pf *pf)
>  	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
>  
>  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> -	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
> -	if (func_caps->common_cap.rdma) {
> +	if (func_caps->common_cap.rdma)
>  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> -		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
> -	}
>  	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
>  	if (func_caps->common_cap.dcb)
>  		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
> @@ -3785,7 +3782,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
>  	v_left -= needed;
>  
>  	/* reserve vectors for RDMA auxiliary driver */
> -	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> +	if (ice_is_rdma_ena(pf)) {
>  		needed = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
>  		if (v_left < needed)
>  			goto no_hw_vecs_left_err;
> @@ -3826,7 +3823,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
>  			int v_remain = v_actual - v_other;
>  			int v_rdma = 0, v_min_rdma = 0;
>  
> -			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> +			if (ice_is_rdma_ena(pf)) {
>  				/* Need at least 1 interrupt in addition to
>  				 * AEQ MSIX
>  				 */
> @@ -3860,7 +3857,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
>  			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
>  				   pf->num_lan_msix);
>  
> -			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> +			if (ice_is_rdma_ena(pf))
>  				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
>  					   pf->num_rdma_msix);
>  		}
> @@ -4688,7 +4685,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
>  
>  	/* ready to go, so clear down state bit */
>  	clear_bit(ICE_DOWN, pf->state);

Why don't you clear this bit after RDMA initialization?

> -	if (ice_is_aux_ena(pf)) {
> +	if (ice_is_rdma_ena(pf)) {
>  		pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
>  		if (pf->aux_idx < 0) {
>  			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
> -- 
> 2.31.1
> 
