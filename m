Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7B41B21E7
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgDUIoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUIoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:44:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31FC72072D;
        Tue, 21 Apr 2020 08:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587458657;
        bh=vsQlr1gciJx4R74jHKq+EyyVwW79oBb2TKFKEJ8IcMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vOec6tn0iR35kS8JmmG2fzZLnQF2nqyX77Ya9mM4Vh6sJBq2dEt/6XsQftBJ2Az+S
         aX5431JOq4P4Zw7leWx4+Jg8Ty5EDDwtJX6ZPVpqmcOm6oYCfk3QK6f2M5oCurpaC4
         r0I4QmXnuMRuOoLaoqZGMkvZhd8lVzT1hUU2EQqQ=
Date:   Tue, 21 Apr 2020 10:44:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 2/9] ice: Create and register virtual bus for RDMA
Message-ID: <20200421084415.GD716720@kroah.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-3-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421080235.6515-3-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:02:28AM -0700, Jeff Kirsher wrote:
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 5c11448bfbb3..529a6743fd4e 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -33,6 +33,7 @@
>  #include <linux/if_bridge.h>
>  #include <linux/ctype.h>
>  #include <linux/bpf.h>
> +#include <linux/virtual_bus.h>

Why do you need this #include?  You don't use anything from this file in
this .h file.

> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -825,7 +825,8 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
>  				 GLNVM_ULD_POR_DONE_1_M |\
>  				 GLNVM_ULD_PCIER_DONE_2_M)
>  
> -	uld_mask = ICE_RESET_DONE_MASK;
> +	uld_mask = ICE_RESET_DONE_MASK | (hw->func_caps.common_cap.iwarp ?
> +					  GLNVM_ULD_PE_DONE_M : 0);
>  
>  	/* Device is Active; check Global Reset processes are done */
>  	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
> @@ -1678,6 +1679,11 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
>  				  "%s: msix_vector_first_id = %d\n", prefix,
>  				  caps->msix_vector_first_id);
>  			break;
> +		case ICE_AQC_CAPS_IWARP:
> +			caps->iwarp = (number == 1);
> +			ice_debug(hw, ICE_DBG_INIT,
> +				  "%s: iwarp = %d\n", prefix, caps->iwarp);
> +			break;
>  		case ICE_AQC_CAPS_MAX_MTU:
>  			caps->max_mtu = number;
>  			ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
> @@ -1701,6 +1707,16 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
>  		ice_debug(hw, ICE_DBG_INIT,
>  			  "%s: maxtc = %d (based on #ports)\n", prefix,
>  			  caps->maxtc);
> +		if (caps->iwarp) {
> +			ice_debug(hw, ICE_DBG_INIT, "%s: forcing RDMA off\n",
> +				  prefix);
> +			caps->iwarp = 0;
> +		}
> +
> +		/* print message only when processing device capabilities */
> +		if (dev_p)
> +			dev_info(ice_hw_to_dev(hw),
> +				 "RDMA functionality is not available with the current device configuration.\n");

Shouldn't that be dev_err()?

And why are you adding new functionality to the driver when you should
only be adding virtual bus support?  This feels like you are mixing two
different things into one patch, making it _really_ hard to review.


> +/**
> + * ice_init_peer_devices - initializes peer devices
> + * @pf: ptr to ice_pf
> + *
> + * This function initializes peer devices on the virtual bus.
> + */
> +int ice_init_peer_devices(struct ice_pf *pf)
> +{
> +	struct ice_vsi *vsi = pf->vsi[0];
> +	struct pci_dev *pdev = pf->pdev;
> +	struct device *dev = &pdev->dev;
> +	int status = 0;
> +	unsigned int i;
> +
> +	/* Reserve vector resources */
> +	status = ice_reserve_peer_qvector(pf);
> +	if (status < 0) {
> +		dev_err(dev, "failed to reserve vectors for peer drivers\n");
> +		return status;
> +	}
> +	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
> +		struct ice_peer_dev_int *peer_dev_int;
> +		struct ice_peer_drv_int *peer_drv_int;
> +		struct iidc_qos_params *qos_info;
> +		struct iidc_virtbus_object *vbo;
> +		struct msix_entry *entry = NULL;
> +		struct iidc_peer_dev *peer_dev;
> +		struct virtbus_device *vdev;
> +		int j;
> +
> +		/* structure layout needed for container_of's looks like:
> +		 * ice_peer_dev_int (internal only ice peer superstruct)
> +		 * |--> iidc_peer_dev
> +		 * |--> *ice_peer_drv_int
> +		 *
> +		 * iidc_virtbus_object (container_of parent for vdev)
> +		 * |--> virtbus_device
> +		 * |--> *iidc_peer_dev (pointer from internal struct)
> +		 *
> +		 * ice_peer_drv_int (internal only peer_drv struct)
> +		 */
> +		peer_dev_int = kzalloc(sizeof(*peer_dev_int), GFP_KERNEL);
> +		if (!peer_dev_int)
> +			return -ENOMEM;
> +
> +		vbo = kzalloc(sizeof(*vbo), GFP_KERNEL);
> +		if (!vbo) {
> +			kfree(peer_dev_int);
> +			return -ENOMEM;
> +		}
> +
> +		peer_drv_int = kzalloc(sizeof(*peer_drv_int), GFP_KERNEL);
> +		if (!peer_drv_int) {
> +			kfree(peer_dev_int);
> +			kfree(vbo);
> +			return -ENOMEM;

So any errors cause you to break out of your loop and leave things
around?

And isn't goto the best thing for unwinding stuff?


> +		}
> +
> +		pf->peers[i] = peer_dev_int;
> +		vbo->peer_dev = &peer_dev_int->peer_dev;
> +		peer_dev_int->peer_drv_int = peer_drv_int;
> +		peer_dev_int->peer_dev.vdev = &vbo->vdev;
> +
> +		/* Initialize driver values */
> +		for (j = 0; j < IIDC_EVENT_NBITS; j++)
> +			bitmap_zero(peer_drv_int->current_events[j].type,
> +				    IIDC_EVENT_NBITS);
> +
> +		mutex_init(&peer_dev_int->peer_dev_state_mutex);
> +
> +		peer_dev = &peer_dev_int->peer_dev;
> +		peer_dev->peer_ops = NULL;
> +		peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
> +		peer_dev->peer_dev_id = ice_peers[i].id;
> +		peer_dev->pf_vsi_num = vsi->vsi_num;
> +		peer_dev->netdev = vsi->netdev;
> +
> +		peer_dev_int->ice_peer_wq =
> +			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
> +						i);
> +		if (!peer_dev_int->ice_peer_wq) {
> +			kfree(peer_dev_int);
> +			kfree(peer_drv_int);
> +			kfree(vbo);
> +			return -ENOMEM;
> +		}
> +
> +		peer_dev->pdev = pdev;
> +		qos_info = &peer_dev->initial_qos_info;
> +
> +		/* setup qos_info fields with defaults */
> +		qos_info->num_apps = 0;
> +		qos_info->num_tc = 1;
> +
> +		for (j = 0; j < IIDC_MAX_USER_PRIORITY; j++)
> +			qos_info->up2tc[j] = 0;
> +
> +		qos_info->tc_info[0].rel_bw = 100;
> +		for (j = 1; j < IEEE_8021QAZ_MAX_TCS; j++)
> +			qos_info->tc_info[j].rel_bw = 0;
> +
> +		/* for DCB, override the qos_info defaults. */
> +		ice_setup_dcb_qos_info(pf, qos_info);
> +
> +		/* make sure peer specific resources such as msix_count and
> +		 * msix_entries are initialized
> +		 */
> +		switch (ice_peers[i].id) {
> +		case IIDC_PEER_RDMA_ID:
> +			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
> +				peer_dev->msix_count = pf->num_rdma_msix;
> +				entry = &pf->msix_entries[pf->rdma_base_vector];
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		peer_dev->msix_entries = entry;
> +		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT,
> +				      false);
> +
> +		vdev = &vbo->vdev;
> +		vdev->name = ice_peers[i].name;
> +		vdev->release = ice_peer_vdev_release;
> +		vdev->dev.parent = &pdev->dev;
> +
> +		status = virtbus_register_device(vdev);
> +		if (status) {
> +			kfree(peer_dev_int);
> +			kfree(peer_drv_int);
> +			vdev = NULL;

I doubt you need to set a local variable to NULL right before exiting
the function :)

And what about all of the other things you need to unwind that you
created above here?

> +			return status;

Again, you are breaking out of here and leaving the other things
allocated in this loop around to just stay there for forever???

greg k-h
