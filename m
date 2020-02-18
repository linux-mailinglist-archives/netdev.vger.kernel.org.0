Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B211628D4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgBROrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:47:02 -0500
Received: from foss.arm.com ([217.140.110.172]:53646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgBROrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 09:47:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 413291FB;
        Tue, 18 Feb 2020 06:47:01 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA7163F703;
        Tue, 18 Feb 2020 06:46:57 -0800 (PST)
Date:   Tue, 18 Feb 2020 14:46:53 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     "Pankaj Bansal (OSS)" <pankaj.bansal@oss.nxp.com>
Cc:     Hanjun Guo <guohanjun@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Will Deacon <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200218144653.GA4286@e121166-lin.cambridge.arm.com>
References: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <615c6807-c018-92c9-b66a-8afdda183699@huawei.com>
 <VI1PR04MB513558BF77192255CBE12102B0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB513558BF77192255CBE12102B0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 12:48:39PM +0000, Pankaj Bansal (OSS) wrote:

[...]

> > > In DT case, we create the domain DOMAIN_BUS_FSL_MC_MSI for MC bus and
> > it's children.
> > > And then when MC child device is created, we search the "msi-parent"
> > property from the MC
> > > DT node and get the ITS associated with MC bus. Then we search
> > DOMAIN_BUS_FSL_MC_MSI
> > > on that ITS. Once we find the domain, we can call msi_domain_alloc_irqs for
> > that domain.
> > >
> > > This is exactly what we tried to do initially with ACPI. But the searching
> > DOMAIN_BUS_FSL_MC_MSI
> > > associated to an ITS, is something that is part of drivers/acpi/arm64/iort.c.
> > > (similar to DOMAIN_BUS_PLATFORM_MSI and DOMAIN_BUS_PCI_MSI)
> > 
> > Can you have a look at mbigen driver (drivers/irqchip/irq-mbigen.c) to see if
> > it helps you?
> > 
> > mbigen is an irq converter to convert device's wired interrupts into MSI
> > (connecting to ITS), which will alloc a bunch of MSIs from ITS platform MSI
> > domain at the setup.
> 
> Unfortunately this is not the same case as ours. As I see Hisilicon IORT table
> Is using single id mapping with named components.
> 
> https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1616/D05AcpiTables/D05Iort.asl#L300
> 
> while we are not:
> 
> https://source.codeaurora.org/external/qoriq/qoriq-components/edk2-platforms/tree/Platform/NXP/LX2160aRdbPkg/AcpiTables/Iort.aslc?h=LX2160_UEFI_ACPI_EAR1#n290
> 
> This is because as I said, we are trying to represent a bus in IORT
> via named components and not individual devices connected to that bus.

I had a thorough look into this and strictly speaking there is no
*mapping* requirement at all, all you need to know is what ITS the FSL
MC bus is mapping MSIs to. Which brings me to the next question (which
is orthogonal to how to model FSL MC in IORT, that has to be discussed
but I want to have a full picture in mind first).

When you probe the FSL MC as a platform device, the ACPI core,
through IORT (if you add the 1:1 mapping as an array of single
mappings) already link the platform device to ITS platform
device MSI domain (acpi_configure_pmsi_domain()).

The associated fwnode is the *same* (IIUC) as for the
DOMAIN_BUS_FSL_MC_MSI and ITS DOMAIN_BUS_NEXUS, so in practice
you don't need IORT code to retrieve the DOMAIN_BUS_FSL_MC_MSI
domain, the fwnode is the same as the one in the FSL MC platform
device IRQ domain->fwnode pointer and you can use it to
retrieve the DOMAIN_BUS_FSL_MC_MSI domain through it.

Is my reading correct ?

Overall, DOMAIN_BUS_FSL_MC_MSI is just an MSI layer to override the
provide the MSI domain ->prepare hook (ie to stash the MC device id), no
more (ie its_fsl_mc_msi_prepare()).

That's it for the MSI layer - I need to figure out whether we *want* to
extend IORT (and/or ACPI) to defined bindings for "additional busses",
what I write above is a summary of my understanding, I have not made my
mind up yet.

As for the IOMMU code, it seems like the only thing needed is
extending named components configuration to child devices,
hierarchically.

As Marc already mentioned, IOMMU and IRQ code must be separate for
future postings but first we need to find a suitable answer to
the problem at hand.

Lorenzo
