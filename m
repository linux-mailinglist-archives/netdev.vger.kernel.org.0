Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8CF681A
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 10:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfKJJS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 04:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfKJJS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 04:18:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47065207FA;
        Sun, 10 Nov 2019 09:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573377538;
        bh=HENjYPHpx8XdJuc97Kcps4wI2ju7odHLqyyI5EhwMOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zGDKM/gPVZS9seW11AGICGDQj8nNqY8WBGFGfMMAKJ7LM07RP0hprson+uGeimkFO
         2xzA6iiKTrph+7vYzxUZRdNCrIEBqFwbFESJj6FNnusbjE9fT/1m+HvITqdw/y7tDl
         3dKagfDYI2JqNGxPaFUMcO05QhVr+msa9N2phi1s=
Date:   Sun, 10 Nov 2019 10:18:55 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>,
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
Message-ID: <20191110091855.GE1435668@kroah.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
 <20191109004426.GB31761@ziepe.ca>
 <20191109092747.26a1a37e@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109092747.26a1a37e@cakuba>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 09:27:47AM -0800, Jakub Kicinski wrote:
> On Fri, 8 Nov 2019 20:44:26 -0400, Jason Gunthorpe wrote:
> > On Fri, Nov 08, 2019 at 01:45:59PM -0800, Jakub Kicinski wrote:
> > > Yes, my suggestion to use mdev was entirely based on the premise that
> > > the purpose of this work is to get vfio working.. otherwise I'm unclear
> > > as to why we'd need a bus in the first place. If this is just for
> > > containers - we have macvlan offload for years now, with no need for a
> > > separate device.  
> > 
> > This SF thing is a full fledged VF function, it is not at all like
> > macvlan. This is perhaps less important for the netdev part of the
> > world, but the difference is very big for the RDMA side, and should
> > enable VFIO too..
> 
> Well, macvlan used VMDq so it was pretty much a "legacy SR-IOV" VF.
> I'd perhaps need to learn more about RDMA to appreciate the difference.
> 
> > > On the RDMA/Intel front, would you mind explaining what the main
> > > motivation for the special buses is? I'm a little confurious.  
> > 
> > Well, the issue is driver binding. For years we have had these
> > multi-function netdev drivers that have a single PCI device which must
> > bind into multiple subsystems, ie mlx5 does netdev and RDMA, the cxgb
> > drivers do netdev, RDMA, SCSI initiator, SCSI target, etc. [And I
> > expect when NVMe over TCP rolls out we will have drivers like cxgb4
> > binding to 6 subsytems in total!]
> 
> What I'm missing is why is it so bad to have a driver register to
> multiple subsystems.

Because these PCI devices seem to do "different" things all in one PCI
resource set.  Blame the hardware designers :)

> I've seen no end of hacks caused people trying to split their driver
> too deeply by functionality. Separate sub-drivers, buses and modules.
> 
> The nfp driver was split up before I upstreamed it, I merged it into
> one monolithic driver/module. Code is still split up cleanly internally,
> the architecture doesn't change in any major way. Sure 5% of developers
> were upset they can't do some partial reloads they were used to, but
> they got used to the new ways, and 100% of users were happy about the
> simplicity.

I agree, you should stick with the "one device/driver" thing where ever
possible, like you did.

> For the nfp I think the _real_ reason to have a bus was that it
> was expected to have some out-of-tree modules bind to it. Something 
> I would not encourage :)

That's not ok, and I agree with you.

But there seems to be some more complex PCI devices that do lots of
different things all at once.  Kind of like a PCI device that wants to
be both a keyboard and a storage device at the same time (i.e. a button
on a disk drive...)

thanks,

greg k-h
