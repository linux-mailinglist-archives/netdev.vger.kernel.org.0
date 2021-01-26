Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D2B305B47
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314068AbhAZW4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388030AbhAZFiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 00:38:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E152223D;
        Tue, 26 Jan 2021 05:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611639464;
        bh=ibjvNJg6Y0oi3XXh3+5AHtIS0a4DyHJrTtmFzGR2s3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVqbUo+MC5RZRtnp7Zy2iObRa7Dn8FgjHwhY6BiZNKyIeKKC5aVIFKgaQUIqvzSZl
         5kQ2eV+97bfMjUiTh4uCzUeQclvCcrE9aS0KYa4krkPbmnTe9suKpVggDuNXS4K1g3
         g1ktbO4J28pJFxzlouL0G/9RDUWPtfbVUOJvXptjbajvTA7NNTblE6Be5OAgaC29UT
         Gs1nYPp5UL2i4sQj1te/94rjmzHNe0zQ6IGaVfnfbadpWmqocdkCbxuGyiyiPRKHXc
         eusbu0FvmDCPpLD99P5z3k4rAIsbTudgGULAbkzjyqNjXAYciFzbzgCy+9kacH60Z8
         iyoaDiRRiUW7w==
Date:   Tue, 26 Jan 2021 07:37:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210126053740.GO579511@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125184248.GS4147@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 02:42:48PM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > +/**
> > + * irdma_init_dev - GEN_2 device init
> > + * @aux_dev: auxiliary device
> > + *
> > + * Create device resources, set up queues, pble and hmc objects.
> > + * Return 0 if successful, otherwise return error
> > + */
> > +int irdma_init_dev(struct auxiliary_device *aux_dev)
> > +{
> > +	struct iidc_auxiliary_object *vo = container_of(aux_dev,
> > +							struct iidc_auxiliary_object,
> > +							adev);
> > +	struct iidc_peer_obj *peer_info = vo->peer_obj;
> > +	struct irdma_handler *hdl;
> > +	struct irdma_pci_f *rf;
> > +	struct irdma_sc_dev *dev;
> > +	struct irdma_priv_peer_info *priv_peer_info;
> > +	int err;
> > +
> > +	hdl = irdma_find_handler(peer_info->pdev);
> > +	if (hdl)
> > +		return -EBUSY;
> > +
> > +	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
> > +	if (!hdl)
> > +		return -ENOMEM;
> > +
> > +	rf = &hdl->rf;
> > +	priv_peer_info = &rf->priv_peer_info;
> > +	rf->aux_dev = aux_dev;
> > +	rf->hdl = hdl;
> > +	dev = &rf->sc_dev;
> > +	dev->back_dev = rf;
> > +	rf->gen_ops.init_hw = icrdma_init_hw;
> > +	rf->gen_ops.request_reset = icrdma_request_reset;
> > +	rf->gen_ops.register_qset = irdma_lan_register_qset;
> > +	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
> > +	priv_peer_info->peer_info = peer_info;
> > +	rf->rdma_ver = IRDMA_GEN_2;
> > +	irdma_set_config_params(rf);
> > +	dev->pci_rev = peer_info->pdev->revision;
> > +	rf->default_vsi.vsi_idx = peer_info->pf_vsi_num;
> > +	/* save information from peer_info to priv_peer_info*/
> > +	priv_peer_info->fn_num = PCI_FUNC(peer_info->pdev->devfn);
> > +	rf->hw.hw_addr = peer_info->hw_addr;
> > +	rf->pcidev = peer_info->pdev;
> > +	rf->netdev = peer_info->netdev;
> > +	priv_peer_info->ftype = peer_info->ftype;
> > +	priv_peer_info->msix_count = peer_info->msix_count;
> > +	priv_peer_info->msix_entries = peer_info->msix_entries;
> > +	irdma_add_handler(hdl);
> > +	if (irdma_ctrl_init_hw(rf)) {
> > +		err = -EIO;
> > +		goto err_ctrl_init;
> > +	}
> > +	peer_info->peer_ops = &irdma_peer_ops;
> > +	peer_info->peer_drv = &irdma_peer_drv;
> > +	err = peer_info->ops->peer_register(peer_info);
> > +	if (err)
> > +		goto err_peer_reg;
>
> No to this, I don't want to see aux bus layered on top of another
> management framework in new drivers. When this driver uses aux bus get
> rid of the old i40iw stuff. I already said this in one of the older
> postings of this driver.
>
> auxbus probe() for a RDMA driver should call ib_alloc_device() near
> its start and ib_register_device() near the end its end.
>
> drvdata for the aux device should point to the driver struct
> containing the ib_device.

My other expectation is to see at least two aux_drivers, one for the
RoCE and another for the iWARP. It will allow easy management for the
users if they decide to disable/enable specific functionality
(/sys/bus/auxiliary/device/*). It will simplify code management too.

Thanks
