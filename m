Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB26811F0F6
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 09:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfLNIh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 03:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfLNIh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 03:37:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2349B24125;
        Sat, 14 Dec 2019 08:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576312676;
        bh=bBqXNqepPrUnfTEsgIJIVQE60S3PLIE7bqcl+SWbyf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2B1MmkBN2XkZO/EHfDdd0M5ZuY81cL9M8usKucsCiVupHXMYl1oJZT8nyWkt0Y9BK
         zJZ1IZliqNl7dCFC2Z9pi193DcRNnNO02Mkr6lplLFJOvsxJ84e8Vqz8IjsmVxC4y5
         8wXiE2RiWPPdXkDxnkHM6RDn1ROdwhFu7ZAgWD4Q=
Date:   Sat, 14 Dec 2019 09:37:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Message-ID: <20191214083753.GB3318534@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 11:08:34PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
> > 
> 
> [....]
> 
> > >  /**
> > > @@ -275,6 +281,27 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
> > >  	cdev->lan_info.msix_entries =
> > > &pf->msix_entries[pf->iwarp_base_vector];
> > >  }
> > >
> > > +static int i40e_init_client_virtdev(struct i40e_pf *pf) {
> > > +	struct i40e_info *ldev = &pf->cinst->lan_info;
> > > +	struct pci_dev *pdev = pf->pdev;
> > > +	struct virtbus_device *vdev;
> > > +	int ret;
> > > +
> > > +	vdev = &ldev->vdev;
> > > +	vdev->name = I40E_PEER_RDMA_NAME;
> > > +	vdev->dev.parent = &pf->pdev->dev;
> > 
> > What a total and complete mess of a tangled web you just wove here.
> > 
> > Ok, so you pass in a single pointer, that then dereferences 3 pointers deep to find
> > the pointer to the virtbus_device structure, but then you point the parent of that
> > device, back at the original structure's sub-pointer's device itself.
> > 
> > WTF?
> 
> OK. This is convoluted. Passing a pointer to the i40e_info object should suffice. So something like,
> 
> +static int i40e_init_client_virtdev(struct i40e_info *ldev) {
> +       struct pci_dev *pdev = ldev->pcidev;
> +       struct virtbus_device *vdev = &ldev->vdev;
> +       int ret;
> +
> +       vdev->name = I40E_PEER_RDMA_NAME;
> +       vdev->dev.parent = &pdev->dev;
> +       ret = virtbus_dev_register(vdev);
> +       if (ret)
> +               return ret;
> +
> +       return 0;
> +}
> +
> 
> > 
> > And who owns the memory of this thing that is supposed to be dynamically
> > controlled by something OUTSIDE of this driver?  Who created that thing 3
> > pointers deep?  What happens when you leak the memory below (hint, you did),
> > and who is supposed to clean it up if you need to properly clean it up if something
> > bad happens?
> 
> The i40e_info object memory is tied to the PF driver.

What is a "PF"?

> The object hierarchy is,
> 
> i40e_pf: pointer to i40e_client_instance 
> 	----- i40e_client_instance: i40e_info
> 		----- i40e_info: virtbus_device

So you are 3 pointers deep to get a structure that is dynamically
controlled?  Why are those "3 pointers" not also represented in sysfs?
You have a heiarchy within the kernel that is not being represented that
way to userspace, why?

Hint, I think this is totally wrong, you need to rework this to be sane.

> For each PF, there is a client_instance object allocated.

Great, make it dynamic and in the device tree.

> The i40e_info object is populated and the virtbus_device hanging off this object is registered.

Great, make that dynamic and inthe device tree.

If you think this is too much, then your whole mess here is too much and
needs to be made a lot simpler.

> In irdma probe(), we use the container_of macro to get to this i40e_info object from the
> virtbus_device. It contains all the ops/info which RDMA driver needs from the PCI function driver.

Ok, that's what you are supposed to do, but why walk back 3 levels?

> The lifetime of the i40e_info object (and the virtbus device) is tied to the PF.

Careful, these are dynamic structures, you don't get to fully "tie"
anything here.

> When PF goes away, virtbus_device is unregistered and the client_instance object memory
> is freed.

Hopefully, if no one else has a reference (hint, you never know this.)
If you are relying on this, then you are not using the driver model
correctly.

> > Also, what ever happened to my "YOU ALL MUST AGREE TO WORK TOGETHER"
> > requirement between this group, and the other group trying to do the same thing?  I
> > want to see signed-off-by from EVERYONE involved before we are going to
> > consider this thing.
> > 
> We will have all parties cc'ed in the next submission. Would encourage folks to review
> and hopefully we can get some consensus.

Then when you post your patches, do so to be obvious that is what you
are asking for, don't try to do a "here's a pull request to take!" type
request like you did here, that's not nice.

thanks,

greg k-h
