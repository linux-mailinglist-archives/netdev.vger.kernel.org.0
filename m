Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D032DEC58
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgLSAWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:22:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51157 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgLSAWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:22:53 -0500
X-Greylist: delayed 97350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2020 19:22:52 EST
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 73881E0002;
        Sat, 19 Dec 2020 00:22:08 +0000 (UTC)
Date:   Sat, 19 Dec 2020 01:22:08 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, lee.jones@linaro.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201219002208.GI3143569@piout.net>
References: <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com>
 <20201218211658.GH3143569@piout.net>
 <20201218233608.GA552508@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218233608.GA552508@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/12/2020 19:36:08-0400, Jason Gunthorpe wrote:
> On Fri, Dec 18, 2020 at 10:16:58PM +0100, Alexandre Belloni wrote:
> 
> > But then again, what about non-enumerable devices on the PCI device? I
> > feel this would exactly fit MFD. This is a collection of IPs that exist
> > as standalone but in this case are grouped in a single device.
> 
> So, if mfd had a mfd_device and a mfd bus_type then drivers would need
> to have both a mfd_driver and a platform_driver to bind. Look at
> something like drivers/char/tpm/tpm_tis.c to see how a multi-probe
> driver is structured
> 
> See Mark's remarks about the old of_platform_device, to explain why we
> don't have a 'dt_device' today
> 

So, what would that mfd_driver have that the platform_driver doesn't
already provide?

> > Note that I then have another issue because the kernel doesn't support
> > irq controllers on PCI and this is exactly what my SoC has. But for now,
> > I can just duplicate the irqchip driver in the MFD driver.
> 
> I think Thomas fixed that recently on x86 at least.. 
> 
> Having to put dummy irq chip drivers in MFD anything sounds scary :|
> 

This isn't a dummy driver it is a real irqchip, what issue is there to
register an irqchip from MFD ?

> > Let me point to drivers/net/ethernet/cadence/macb_pci.c which is a
> > fairly recent example. It does exactly that and I'm not sure you could
> > do it otherwise while still not having to duplicate most of macb_probe.
> 
> Creating a platform_device to avoid restructuring the driver's probe
> and device logic to be generic is a *really* horrible reason to use a
> platform device.
> 

Definitively but it made it in and seemed reasonable at the time it
seems. I stumbled upon that a while ago because I wanted to remove
platform_data support from the macb driver and this is the last user. I
never got the time to tackle that.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
