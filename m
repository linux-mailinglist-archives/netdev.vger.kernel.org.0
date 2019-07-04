Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DF65F94D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfGDNqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbfGDNqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 09:46:17 -0400
Received: from localhost (unknown [89.205.128.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E675D2189E;
        Thu,  4 Jul 2019 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562247976;
        bh=AXnRNQUafGRHcVyDEFkv9IFuGasR/5dXwZzfCjSG21g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c9gN5a25Ci2ryGM/qjco9FAXQ28FFwIWklshW6JvuayZ7exndB4KeQZnzjHeMvRAF
         kah2IZqSOISeKMlyEUE6xNN9wwD0M17rswD+MwapyW3Wnbqur/iMm4ezIU5R/fpe8/
         Iss8Yf6nE2N3NZUxJOYkE6MvqHu9dTg+uO/rFh6I=
Date:   Thu, 4 Jul 2019 15:46:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Message-ID: <20190704134612.GB10963@kroah.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com>
 <20190704122950.GA6007@kroah.com>
 <20190704123729.GF3401@mellanox.com>
 <20190704124247.GA6807@kroah.com>
 <20190704124824.GK3401@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704124824.GK3401@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 12:48:29PM +0000, Jason Gunthorpe wrote:
> On Thu, Jul 04, 2019 at 02:42:47PM +0200, Greg KH wrote:
> > On Thu, Jul 04, 2019 at 12:37:33PM +0000, Jason Gunthorpe wrote:
> > > On Thu, Jul 04, 2019 at 02:29:50PM +0200, Greg KH wrote:
> > > > On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> > > > > On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > > > 
> > > > > > The RDMA block does not advertise on the PCI bus or any other bus.
> > > > > > Thus the ice driver needs to provide access to the RDMA hardware block
> > > > > > via a virtual bus; utilize the platform bus to provide this access.
> > > > > > 
> > > > > > This patch initializes the driver to support RDMA as well as creates
> > > > > > and registers a platform device for the RDMA driver to register to. At
> > > > > > this point the driver is fully initialized to register a platform
> > > > > > driver, however, can not yet register as the ops have not been
> > > > > > implemented.
> > > > > 
> > > > > I think you need Greg's ack on all this driver stuff - particularly
> > > > > that a platform_device is OK.
> > > > 
> > > > A platform_device is almost NEVER ok.
> > > > 
> > > > Don't abuse it, make a real device on a real bus.  If you don't have a
> > > > real bus and just need to create a device to hang other things off of,
> > > > then use the virtual one, that's what it is there for.
> > > 
> > > Ideally I'd like to see all the RDMA drivers that connect to ethernet
> > > drivers use some similar scheme.
> > 
> > Why?  They should be attached to a "real" device, why make any up?
> 
> ? A "real" device, like struct pci_device, can only bind to one
> driver. How can we bind it concurrently to net, rdma, scsi, etc?

MFD was designed for this very problem.

> > > This is for a PCI device that plugs into multiple subsystems in the
> > > kernel, ie it has net driver functionality, rdma functionality, some
> > > even have SCSI functionality
> > 
> > Sounds like a MFD device, why aren't you using that functionality
> > instead?
> 
> This was also my advice, but in another email Jeff says:
> 
>   MFD architecture was also considered, and we selected the simpler
>   platform model. Supporting a MFD architecture would require an
>   additional MFD core driver, individual platform netdev, RDMA function
>   drivers, and stripping a large portion of the netdev drivers into
>   MFD core. The sub-devices registered by MFD core for function
>   drivers are indeed platform devices.  

So, "mfd is too hard, let's abuse a platform device" is ok?

People have been wanting to do MFD drivers for PCI devices for a long
time, it's about time someone actually did the work for it, I bet it
will not be all that complex if tiny embedded drivers can do it :)

thanks,

greg k-h
