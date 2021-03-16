Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B635633D043
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhCPJBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhCPJBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 05:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 065DF65001;
        Tue, 16 Mar 2021 09:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615885271;
        bh=BAFtxdkU03/IGeq7+qwRwODdw11YmUzHYubpZWdDoH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfMTDPnNyiFnhJo17fCmm2npDlUuyGB87P40KcHXhR8vZ9872LACEpz/a6CNFfYLG
         TX73LAL3oMLG0FquAZomNU3niEeIAUekkmf3aiXB9rnISFpwJX2Cr0LIhnVxv6PU6h
         VIESBQxJuEraODdLeHSR75n1DCbhz26iFePB/Cso=
Date:   Tue, 16 Mar 2021 10:01:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v10 00/20] dlb: introduce DLB device driver
Message-ID: <YFBz1BICsjDsSJwv@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com>
 <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
 <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
 <BYAPR11MB309515F449B8660043A559E5D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR11MB309515F449B8660043A559E5D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 08:18:10PM +0000, Chen, Mike Ximing wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> > On Fri, Mar 12, 2021 at 1:55 PM Chen, Mike Ximing <mike.ximing.chen@intel.com> wrote:
> > >
> > > We support up to 16/32 VF/VDEVs (depending on version) with SRIOV and
> > > SIOV. Role of the kernel driver includes VDEV Composition (vdcm
> > > module), functional level reset, live migration, error handling, power
> > > management, and etc..
> > 
> > Need some more specificity here. What about those features requires the kernel to get involved with a
> > DLB2 specific ABI to manage ports, queues, credits, sequence numbers, etc...?
> 
> Role of the dlb kernel driver:
> 
> VDEV Composition
> For example writing 1024 to the VDEV_CREDITS[0] register will allocate 1024 credits to VDEV 0. In this way, VFs or VDEVs can be composed  as mini-versions of the full device.
> VDEV composition will leverage vfio-mdev to create the VDEV devices while the KMD will implement the VDCM.

What is a vdev?

What is KMD?

What is VDCM?

What is VF?

And how does this all work?

> Dynamic Composition
> Such composition can be dynamic – the PF/VF interface supports scenarios whereby, for example, an application may wish to boost its credit allocation – can I have 100 more credits?

What applications?  What "credits"  For what resources?

> Functional Level Reset
> Much of the internal storage is RAM based and not resettable by hardware schemes. There are also internal SRAM  based control structures (BCAM) that have to be flushed. 
> The planned way to do this is, roughly:
>   -- Kernel driver disables access from the associated ports  (to prevent any SW access, the application should be deadso this is a precaution).

What is a "port" here?


>   -- Kernel masquerades as the application to drain all data from internal queues. It can poll some internal counters to verify everything is fully drained.

What queues?

Why would the kernel mess with userspace data?

>   -- Only at this point can the resources associated with the VDEV be returned to the pool of available resources for handing to another application/VDEV.

What is a VDEV and how does an application be "associated with it"?

> Migration
> Requirement is fairly similar to FLR. A VDEV has to be manually drained and reconstituted on another server, Kernel driver is responsible on both sides.

What is FLR?

> Error Handling
> Errors include “Credit Excursions” where a VDEV attempts to use more of the internal capacity (credits) than has been allocated. In such a case, 
> the data is dropped and an interrupt generated. All such interrupts are directed to the PF driver, which may simply forward them to a VF (via the PF/VF comms mechanism).

What data is going where?

> Power Management
> The kernel driver keeps the device in D3Hot when not in use. The driver transitions the device to D0 when the first device file is opened or a VF or VDEV is created, 
> and keeps it in that state until there are no open device files, memory mappings, or VFs/VDEVs.

That's just normal power management for any device, why is this anything
special?

> Ioctl interface
> Kernel driver provides ioctl interface for user applications to setup and configure dlb domains, ports, queues, scheduling types, credits, 
> sequence numbers, and links between ports and queues.  Applications also use the interface to start, stop and inquire the dlb operations.

What applications use any of this?  What userspace implementation today
interacts with this?  Where is that code located?

Too many TLAs here, I have even less of an understanding of what this
driver is supposed to be doing, and what this hardware is now than
before.

And here I thought I understood hardware devices, and if I am confused,
I pity anyone else looking at this code...

You all need to get some real documentation together to explain
everything here in terms that anyone can understand.  Without that, this
code is going nowhere.

good luck!

greg k-h
