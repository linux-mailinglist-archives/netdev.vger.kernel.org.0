Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6C3F58E9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbfKHUwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfKHUwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:52:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8172D215EA;
        Fri,  8 Nov 2019 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573246327;
        bh=rZ2fzRBjTIttDv3ZKd9CF9dBPvTjqYQBSYwZ0sNc1TU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1SdgK2KQQ8K5KhLdq9xeml+m1kO8wwQl6pj6zXQi3GutHANkGEeHPsMAHoiDHbQqm
         Z2RHe10OEOfrBHyS3s+Z2UYWDjC8Fxo5MKqbFnnsJdto3XrsiHKtov7+ZcMMN+br2G
         hIyywKk3i7RmpkxFtDhBcJRJkQcW2jxQuBTE3Ccw=
Date:   Fri, 8 Nov 2019 21:52:04 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108205204.GB1277001@kroah.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <AM0PR05MB4866299C3AE2448C8226DC00D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108203209.GF10956@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108203209.GF10956@ziepe.ca>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 04:32:09PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2019 at 08:20:43PM +0000, Parav Pandit wrote:
> > 
> > 
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > > > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
> > > > > > The new intel driver has been having a very similar discussion
> > > > > > about how to model their 'multi function device' ie to bind RDMA
> > > > > > and other drivers to a shared PCI function, and I think that discussion
> > > settled on adding a new bus?
> > > > > >
> > > > > > Really these things are all very similar, it would be nice to have
> > > > > > a clear methodology on how to use the device core if a single PCI
> > > > > > device is split by software into multiple different functional
> > > > > > units and attached to different driver instances.
> > > > > >
> > > > > > Currently there is alot of hacking in this area.. And a consistent
> > > > > > scheme might resolve the ugliness with the dma_ops wrappers.
> > > > > >
> > > > > > We already have the 'mfd' stuff to support splitting platform
> > > > > > devices, maybe we need to create a 'pci-mfd' to support splitting PCI
> > > devices?
> > > > > >
> > > > > > I'm not really clear how mfd and mdev relate, I always thought
> > > > > > mdev was strongly linked to vfio.
> > > > > >
> > > > >
> > > > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > > > above it is addressing more use case.
> > > > >
> > > > > I observed that discussion, but was not sure of extending mdev further.
> > > > >
> > > > > One way to do for Intel drivers to do is after series [9].
> > > > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO RDMA driver
> > > > > mdev_register_driver(), matches on it and does the probe().
> > > >
> > > > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > > > muddying the purpose of mdevs is not a clear trade off.
> > > 
> > > IMHO, mdev has amdev_parent_ops structure clearly intended to link it to vfio,
> > > so using a mdev for something not related to vfio seems like a poor choice.
> > > 
> > Splitting mdev_parent_ops{} is already in works for larger use case in series [1] for virtio.
> > 
> > [1] https://patchwork.kernel.org/patch/11233127/
> 
> Weird. So what is mdev actually providing and what does it represent
> if the entire driver facing API surface is under a union?
> 
> This smells a lot like it is re-implementing a bus.. AFAIK bus is
> supposed to represent the in-kernel API the struct device presents to
> drivers.

Yes, yes yes yes...

I'm getting tired of saying the same thing here, just use a bus, that's
what it is there for.

greg k-h
