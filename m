Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DB02DE7EE
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 18:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgLRRQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 12:16:19 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:34059 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgLRRQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 12:16:19 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 780871BF207;
        Fri, 18 Dec 2020 17:15:34 +0000 (UTC)
Date:   Fri, 18 Dec 2020 18:15:34 +0100
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
Message-ID: <20201218171534.GF3143569@piout.net>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218162817.GX552508@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/12/2020 12:28:17-0400, Jason Gunthorpe wrote:
> On Fri, Dec 18, 2020 at 03:52:04PM +0000, Mark Brown wrote:
> > On Fri, Dec 18, 2020 at 10:08:54AM -0400, Jason Gunthorpe wrote:
> > > On Fri, Dec 18, 2020 at 01:17:09PM +0000, Mark Brown wrote:
> > 
> > > > As previously discussed this will need the auxilliary bus extending to
> > > > support at least interrupts and possibly also general resources.
> > 
> > > I thought the recent LWN article summed it up nicely, auxillary bus is
> > > for gluing to subsystems together using a driver specific software API
> > > to connect to the HW, MFD is for splitting a physical HW into disjoint
> > > regions of HW.
> > 
> > This conflicts with the statements from Greg about not using the
> > platform bus for things that aren't memory mapped or "direct firmware",
> > a large proportion of MFD subfunctions are neither at least in so far as
> > I can understand what direct firmware means.
> 
> I assume MFD will keep existing and it will somehow stop using
> platform device for the children it builds.
> 
> That doesn't mean MFD must use aux device, so I don't see what you
> mean by conflicts?
> 
> If someone has a PCI device and they want to split it up, they should
> choose between aux device and MFD (assuming MFD gets fixed, as Greg
> has basically blanket NAK'd adding more of them to MFD as is)
> 

I have an SoC with for example, a designware SPI controller (handled by
drivers/spi/spi-dw-mmio.c), a designware I2C controller (handled by
drivers/i2c/busses/i2c-designware-platdrv.c).
So, those are MMIO and described using device tree. On this particular
SoC, I can disable the CPU and connect it to another SoC using PCIe. In
that case it will expose one BAR, with all the HW IPs.

The question here is why would I use something different from platform
devices to register the SPI and I2C controllers? It seems that by using
auxiliary devices, I would have to reinvent parsing device property and
children/clients description. This isn't great from a code reuse
perspective.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
