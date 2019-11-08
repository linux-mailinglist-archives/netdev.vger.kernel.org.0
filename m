Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AE3F59AD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732881AbfKHVTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728265AbfKHVTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 16:19:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C295C207FA;
        Fri,  8 Nov 2019 21:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573247951;
        bh=a0U51YF9f9EgyVgSrBELVFo2AKXC5xwkaUrc+s+q6Oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmYrboaw+orEQo0At3suUiEualybPlAV/AM7UGRoedElW/VA3FeOHUr3fzNCM/yfl
         tSsLjhrxYdqpD19ifB5XOrtuO3iAujhDkEGUZnEuMU8Xz3LnHqHYKFOkr/bCtn/PIZ
         GP7vMwINVRgmuhUgH1URBTZ8XFKFWipgZQLpoh28=
Date:   Fri, 8 Nov 2019 22:19:09 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
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
Message-ID: <20191108211909.GA1284849@kroah.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
 <20191108210545.GG10956@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108210545.GG10956@ziepe.ca>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 05:05:45PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2019 at 01:34:35PM -0700, Alex Williamson wrote:
> > On Fri, 8 Nov 2019 16:12:53 -0400
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > > On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > > > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:  
> > > > > > The new intel driver has been having a very similar discussion about how to
> > > > > > model their 'multi function device' ie to bind RDMA and other drivers to a
> > > > > > shared PCI function, and I think that discussion settled on adding a new bus?
> > > > > > 
> > > > > > Really these things are all very similar, it would be nice to have a clear
> > > > > > methodology on how to use the device core if a single PCI device is split by
> > > > > > software into multiple different functional units and attached to different
> > > > > > driver instances.
> > > > > > 
> > > > > > Currently there is alot of hacking in this area.. And a consistent scheme
> > > > > > might resolve the ugliness with the dma_ops wrappers.
> > > > > > 
> > > > > > We already have the 'mfd' stuff to support splitting platform devices, maybe
> > > > > > we need to create a 'pci-mfd' to support splitting PCI devices?
> > > > > > 
> > > > > > I'm not really clear how mfd and mdev relate, I always thought mdev was
> > > > > > strongly linked to vfio.
> > > > > >  
> > > > >
> > > > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > > > above it is addressing more use case.
> > > > > 
> > > > > I observed that discussion, but was not sure of extending mdev further.
> > > > > 
> > > > > One way to do for Intel drivers to do is after series [9].
> > > > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > > > > RDMA driver mdev_register_driver(), matches on it and does the probe().  
> > > > 
> > > > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > > > muddying the purpose of mdevs is not a clear trade off.  
> > > 
> > > IMHO, mdev has amdev_parent_ops structure clearly intended to link it
> > > to vfio, so using a mdev for something not related to vfio seems like
> > > a poor choice.
> > 
> > Unless there's some opposition, I'm intended to queue this for v5.5:
> > 
> > https://www.spinics.net/lists/kvm/msg199613.html
> > 
> > mdev has started out as tied to vfio, but at it's core, it's just a
> > device life cycle infrastructure with callbacks between bus drivers
> > and vendor devices.  If virtio is on the wrong path with the above
> > series, please speak up.  Thanks,
> 
> Well, I think Greg just objected pretty strongly.

Yes I did.

I keep saying this again and again, and so did you here:

> IMHO it is wrong to turn mdev into some API multiplexor. That is what
> the driver core already does and AFAIK your bus type is supposed to
> represent your API contract to your drivers.

That is exactly right.  Don't re-create the driver api interface at
another layer please.

thanks,

greg k-h
