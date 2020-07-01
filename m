Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5A21045F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 09:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgGAG73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGAG73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 02:59:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0445120663;
        Wed,  1 Jul 2020 06:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593586768;
        bh=4jKtzZ1ko40boFbo3mjqHjL+8suyK1q4OV3g1eDS5lA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QghhqMlZjaCgN1+/PNq0GTU/AgNQx7L1iD7YN81Rp+TEvVl8a6tgXTyLEpRwIQJ3V
         zic4udlUPfSFw878t/1qKr6QKbbdT51K2TMjgl89n6QO8yCeXhE7Vi8T0yT+vuJyPT
         hbjXm6rI34VUdtEfP1dJH+k1kT25CtY6Mv3rFTr0=
Date:   Wed, 1 Jul 2020 08:59:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200701065915.GF2044019@kroah.com>
References: <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 10:24:04AM -0700, Ranjani Sridharan wrote:
> On Tue, 2020-06-30 at 08:32 -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 30, 2020 at 11:31:41AM +0100, Mark Brown wrote:
> > > On Mon, Jun 29, 2020 at 07:59:59PM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> > > > > On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:
> > > > > > Ok, that's good to hear.  But platform devices should never
> > > > > > be showing
> > > > > > up as a child of a PCI device.  In the "near future" when we
> > > > > > get the
> > > > > > virtual bus code merged, we can convert any existing users
> > > > > > like this to
> > > > > > the new code.
> > > > > What are we supposed to do with things like PCI attached FPGAs
> > > > > and ASICs
> > > > > in that case?  They can have host visible devices with physical
> > > > > resources like MMIO ranges and interrupts without those being
> > > > > split up
> > > > > neatly as PCI subfunctions - the original use case for MFD was
> > > > > such
> > > > > ASICs, there's a few PCI drivers in there now. 
> > > > Greg has been pretty clear that MFD shouldn't have been used on
> > > > top of
> > > > PCI drivers.
> > > 
> > > The proposed bus lacks resource handling, an equivalent of
> > > platform_get_resource() and friends for example, which would be
> > > needed
> > > for use with physical devices.  Both that and the name suggest that
> > > it's
> > > for virtual devices.
> > 
> > Resource handling is only useful if the HW has a hard distinction
> > between it's functional blocks. This scheme is intended for devices
> > where that doesn't exist. The driver that attaches to the PCI device
> > and creates the virtual devices is supposed to provide SW
> > abstractions
> > for the other drivers to sit on.
> >  
> > I'm not sure why we are calling it virtual bus.
> Hi Jason,
> 
> We're addressing the naming in the next version as well. We've had
> several people reject the name virtual bus and we've narrowed in on
> "ancillary bus" for the new name suggesting that we have the core
> device that is attached to the primary bus and one or more sub-devices
> that are attached to the ancillary bus. Please let us know what you
> think of it.

I'm thinking that the primary person who keeps asking you to create this
"virtual bus" was not upset about that name, nor consulted, so why are
you changing this?  :(

Right now this feels like the old technique of "keep throwing crap at a
maintainer until they get so sick of it that they do the work
themselves..."

greg k-h
