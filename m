Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C777118C93
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfLJPca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfLJPca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 10:32:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3616920828;
        Tue, 10 Dec 2019 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575991948;
        bh=o7ds9DqGI0T2S9wAYWGKbK7rA7T/ldHgVwVYwxhGhNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vAmlrvhy+2QWxynmBWJDK6V9N5OfbgmxL4nAl7rQgo6qRwT+e6NMTbJbX9mobLLRp
         FEnjJtk711aOMyQaiY37c7zfwHIvS5z9sLAJ5jLjuO3aLKBwGtr4ZKqlPg17BgmjAA
         mCxxG5u/+L5esF9uT/EJ+WJUfGWCa75ttfIf+wU8=
Date:   Tue, 10 Dec 2019 16:32:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v3 02/20] ice: Initialize and register a virtual bus to
 provide RDMA
Message-ID: <20191210153226.GB4053085@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-3-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-3-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:17PM -0800, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The RDMA block does not have its own PCI function, instead it must utilize
> the ice driver to gain access to the PCI device. Create a virtual bus
> for the RDMA driver to bind to the device data. The device data contains
> all of the relevant information that the IRDMA peer will need to access
> this PF's IIDC API callbacks.
> 
> Note the header file iidc.h is located under include/linux/net/intel
> as this is a unified header file to be used by all consumers of the
> IIDC interface.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/intel/Kconfig            |   1 +
>  drivers/net/ethernet/intel/ice/Makefile       |   1 +
>  drivers/net/ethernet/intel/ice/ice.h          |  14 +
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
>  drivers/net/ethernet/intel/ice/ice_common.c   |  15 +
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  31 ++
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   3 +
>  .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
>  drivers/net/ethernet/intel/ice/ice_idc.c      | 410 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_idc_int.h  |  79 ++++
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  11 +
>  drivers/net/ethernet/intel/ice/ice_lib.h      |   1 +
>  drivers/net/ethernet/intel/ice/ice_main.c     |  65 ++-
>  drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
>  include/linux/net/intel/iidc.h                | 336 ++++++++++++++
>  16 files changed, 969 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
>  create mode 100644 include/linux/net/intel/iidc.h


You have a lot of different things all mushed together into one patch,
so much so that this is pretty much impossible for me to review.  How
did you all handle it?

Can't this be broken up into smaller, logical, changes that make it
obvious that what you are doing here is correct and makes sense?  As it
is, my few comments below show total confusion on my part...

I can think of a few ways that this can be handled better, but as you
know the code best, I'm sure you can come up with a better way.

> +int
> +ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int,
> +		      void __always_unused *data)
> +{
> +	struct ice_peer_drv_int *peer_drv_int;
> +	struct iidc_peer_dev *peer_dev;
> +	struct pci_dev *pdev;
> +	struct device *dev;
> +	struct ice_pf *pf;
> +
> +	if (!peer_dev_int)
> +		return 0;
> +
> +	peer_dev = ice_get_peer_dev(peer_dev_int);
> +	pdev = peer_dev->pdev;
> +	if (!pdev)
> +		return 0;
> +
> +	pf = pci_get_drvdata(pdev);
> +	if (!pf)
> +		return 0;
> +	dev = ice_pf_to_dev(pf);
> +
> +	virtbus_dev_unregister(&peer_dev_int->vobj.vdev);
> +
> +	peer_drv_int = peer_dev_int->peer_drv_int;
> +
> +	if (peer_dev_int->ice_peer_wq) {
> +		if (peer_dev_int->peer_prep_task.func)
> +			cancel_work_sync(&peer_dev_int->peer_prep_task);
> +
> +		if (peer_dev_int->peer_close_task.func)
> +			cancel_work_sync(&peer_dev_int->peer_close_task);
> +		destroy_workqueue(peer_dev_int->ice_peer_wq);
> +	}
> +
> +	devm_kfree(dev, peer_drv_int);
> +
> +	devm_kfree(dev, peer_dev_int);

I had to stare at this multiple times to make sure this really is
correct.  Shouldn't the devm api handle this for you?

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
> +	int i;
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
> +		struct msix_entry *entry = NULL;
> +		struct iidc_peer_dev *peer_dev;
> +		struct virtbus_device *vdev;
> +		int j;
> +
> +		peer_dev_int = devm_kzalloc(dev, sizeof(*peer_dev_int),
> +					    GFP_KERNEL);
> +		if (!peer_dev_int)
> +			return -ENOMEM;
> +		pf->peers[i] = peer_dev_int;
> +
> +		peer_drv_int = devm_kzalloc(dev, sizeof(*peer_drv_int),
> +					    GFP_KERNEL);
> +		if (!peer_drv_int) {
> +			devm_kfree(dev, peer_dev_int);
> +			return -ENOMEM;
> +		}
> +
> +		peer_dev_int->peer_drv_int = peer_drv_int;
> +
> +		/* Initialize driver values */
> +		for (j = 0; j < IIDC_EVENT_NBITS; j++)
> +			bitmap_zero(peer_drv_int->current_events[j].type,
> +				    IIDC_EVENT_NBITS);
> +
> +		mutex_init(&peer_dev_int->peer_dev_state_mutex);
> +
> +		peer_dev = ice_get_peer_dev(peer_dev_int);
> +		peer_dev->peer_ops = NULL;
> +		peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
> +		peer_dev->peer_dev_id = ice_peers[i].id;
> +		peer_dev->pf_vsi_num = vsi->vsi_num;
> +		peer_dev->netdev = vsi->netdev;
> +
> +		peer_dev_int->ice_peer_wq =
> +			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
> +						i);
> +		if (!peer_dev_int->ice_peer_wq)
> +			return -ENOMEM;
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
> +		vdev = &peer_dev_int->vobj.vdev;

The virtual device is embedded in another structure that is embedded
inside another one which is next to another object in the same
structure?  Am I reading this right?

Who controls the lifetime rules here?  virtbus _should_ but it seems
really really complex here and I can't figure it out.

Why so complex?

> +		vdev->name = ice_peers[i].name;
> +		vdev->dev.parent = &pdev->dev;
> +
> +		status = virtbus_dev_register(vdev);
> +		if (status) {
> +			dev_err(dev, "Failure adding peer dev %s %d\n",
> +				ice_peers[i].name, status);

Shouldn't virtbus_dev_register() print the error message as to what went
wrong?  Callers should not be responsible for that.

> +			virtbus_dev_unregister(vdev);
> +			vdev = NULL;
> +			return status;
> +		}
> +	}
> +
> +	return status;
> +}

> +static inline struct
> +iidc_peer_dev *ice_get_peer_dev(struct ice_peer_dev_int *peer_dev_int)
> +{
> +	if (peer_dev_int)
> +		return &peer_dev_int->vobj.peer_dev;
> +	else
> +		return NULL;
> +}

get_/put_ functions usually grab a reference count.  You didn't do that
here :(


> +	/* init peers only if supported */
> +	if (ice_is_peer_ena(pf)) {
> +		pf->peers = devm_kcalloc(dev, IIDC_MAX_NUM_PEERS,
> +					 sizeof(*pf->peers), GFP_KERNEL);
> +		if (!pf->peers) {
> +			err = -ENOMEM;
> +			goto err_init_peer_unroll;
> +		}
> +
> +		err = ice_init_peer_devices(pf);
> +		if (err) {
> +			dev_err(dev,
> +				"Failed to initialize peer devices: 0x%x\n",
> +				err);

Wait the memory for the virtual devices is allocated using
devm_kcalloc()?  Is that true?  And then that memory is handled by the
reference count logic of the child objects in that structure?  That
feels really wrong...

Or am I just still confused about the whole object hierarchy here?

> +err_init_peer_unroll:
> +	if (ice_is_peer_ena(pf)) {
> +		ice_for_each_peer(pf, NULL, ice_unroll_peer);
> +		if (pf->peers) {
> +			devm_kfree(dev, pf->peers);

Isn't the joy of using devm* functions such that you never have to free
the memory on your own?  Why are you doing that here?

totally lost,

greg k-h
