Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B334F60F72
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfGFIZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 04:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbfGFIZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 04:25:29 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346A620989;
        Sat,  6 Jul 2019 08:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562401528;
        bh=b98nN4JNq6saIDTsKmDicyJKC3+th7WUAwVzPS21I0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vb/JaB1fq1ghXZphPlB6Ctmfx2SzNM5ocv5U84XGoI9zqhBdFU/PDsqJK8OKmy7ZP
         AfeiPeF9+ip86fVcyBtQI3LyVgdo4FxYBcIB9D5kEwtvKHrAF2ZP/wACuEeo/BgQoi
         YpUCsgUg5AWPRqsv3+T6lL2qmFSaQd9pdCV9mP/M=
Date:   Sat, 6 Jul 2019 10:25:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Message-ID: <20190706082523.GA8727@kroah.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com>
 <20190704122950.GA6007@kroah.com>
 <20190704123729.GF3401@mellanox.com>
 <20190704124247.GA6807@kroah.com>
 <20190704124824.GK3401@mellanox.com>
 <20190704134612.GB10963@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7A684DA23@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A684DA23@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 04:33:07PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [net-next 1/3] ice: Initialize and register platform device to provide
> > RDMA
> > 
> > On Thu, Jul 04, 2019 at 12:48:29PM +0000, Jason Gunthorpe wrote:
> > > On Thu, Jul 04, 2019 at 02:42:47PM +0200, Greg KH wrote:
> > > > On Thu, Jul 04, 2019 at 12:37:33PM +0000, Jason Gunthorpe wrote:
> > > > > On Thu, Jul 04, 2019 at 02:29:50PM +0200, Greg KH wrote:
> > > > > > On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> > > > > > > On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > > > > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > > > > >
> > > > > > > > The RDMA block does not advertise on the PCI bus or any other bus.
> > > > > > > > Thus the ice driver needs to provide access to the RDMA
> > > > > > > > hardware block via a virtual bus; utilize the platform bus to provide this
> > access.
> > > > > > > >
> > > > > > > > This patch initializes the driver to support RDMA as well as
> > > > > > > > creates and registers a platform device for the RDMA driver
> > > > > > > > to register to. At this point the driver is fully
> > > > > > > > initialized to register a platform driver, however, can not
> > > > > > > > yet register as the ops have not been implemented.
> > > > > > >
> > > > > > > I think you need Greg's ack on all this driver stuff -
> > > > > > > particularly that a platform_device is OK.
> > > > > >
> > > > > > A platform_device is almost NEVER ok.
> > > > > >
> > > > > > Don't abuse it, make a real device on a real bus.  If you don't
> > > > > > have a real bus and just need to create a device to hang other
> > > > > > things off of, then use the virtual one, that's what it is there for.
> > > > >
> > > > > Ideally I'd like to see all the RDMA drivers that connect to
> > > > > ethernet drivers use some similar scheme.
> > > >
> > > > Why?  They should be attached to a "real" device, why make any up?
> > >
> > > ? A "real" device, like struct pci_device, can only bind to one
> > > driver. How can we bind it concurrently to net, rdma, scsi, etc?
> > 
> > MFD was designed for this very problem.
> > 
> > > > > This is for a PCI device that plugs into multiple subsystems in
> > > > > the kernel, ie it has net driver functionality, rdma
> > > > > functionality, some even have SCSI functionality
> > > >
> > > > Sounds like a MFD device, why aren't you using that functionality
> > > > instead?
> > >
> > > This was also my advice, but in another email Jeff says:
> > >
> > >   MFD architecture was also considered, and we selected the simpler
> > >   platform model. Supporting a MFD architecture would require an
> > >   additional MFD core driver, individual platform netdev, RDMA function
> > >   drivers, and stripping a large portion of the netdev drivers into
> > >   MFD core. The sub-devices registered by MFD core for function
> > >   drivers are indeed platform devices.
> > 
> > So, "mfd is too hard, let's abuse a platform device" is ok?
> > 
> > People have been wanting to do MFD drivers for PCI devices for a long time, it's
> > about time someone actually did the work for it, I bet it will not be all that complex
> > if tiny embedded drivers can do it :)
> > 
> Hi Greg - Thanks for your feedback!
> 
> We currently have 2 PCI function netdev drivers in the kernel (i40e & ice) that support devices (x722 & e810)
> which are RDMA capable. Our objective is to add a single unified RDMA driver
> (as this a subsystem specific requirement) which needs to access HW resources from the
> netdev PF drivers. Attaching platform devices from the netdev drivers to the platform bus
> and having a single RDMA platform driver bind to them and access these resources seemed
> like a simple approach to realize our objective. But seems like attaching platform devices is
> wrong. I would like to understand why. 

Because that is NOT what a platform device is for.

It was originally created for those types of devices that live on the
"platform" bus, i.e. things that are hard-wired and you just "know" are
in your system because they are located at specific locations.  We used
to generate them from board files, and then when we got DT, we create
them from the resources that DT says where the locations of the devices
are.

They are NOT to be abused and used whenever someone wants to put them
somewhere in the "middle" of the device tree because they feel like they
are easier to use instead of creating a real bus and drivers.

Yes, they do get abused, and I need to sweep the tree again and fix up
all of the places where this has crept back in.  But now that I know you
are thinking of doing this, I'll keep saying to NOT do it for your use
case either :)

> Are platform sub devices only to be added from an MFD core driver? I
> am also wondering if MFD arch.  would allow for realizing a single
> RDMA driver and whether we need an MFD core driver for each device,
> x722 & e810 or whether it can be a single driver.

I do not know the details of how MFD works, please ask those developers
for specifics.  If MFD doesn't work, then create a tiny virtual bus and
make sub-devices out of that.  If you need a "generic" way to do this
for PCI devices, then please create that as you are not the only one
that keeps wanting this, as for some reason PCI hardware vendors don't
like dividing up their devices in ways that would have made it much
simpler to create individual devices (probably saves some gates and
firmware complexity on the device).

thanks,

greg k-h
