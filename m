Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40C61617D9
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgBQQ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:26:44 -0500
Received: from foss.arm.com ([217.140.110.172]:38150 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgBQQ0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 11:26:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C490F30E;
        Mon, 17 Feb 2020 08:26:43 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 680E33F68F;
        Mon, 17 Feb 2020 08:26:40 -0800 (PST)
Date:   Mon, 17 Feb 2020 16:26:26 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Pankaj Bansal <pankaj.bansal@nxp.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>, jon@solid-run.com,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200217162604.GA24829@e121166-lin.cambridge.arm.com>
References: <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <VI1PR0401MB249622CFA9B213632F1DE955F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <7349fa0e6d62a3e0d0e540f2e17646e0@kernel.org>
 <VI1PR0401MB2496373E0C6D1097F22B3026F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214161957.GA27513@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496800C88A3A2CF912959E6F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214174949.GA30484@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496308C27B7DAA7A5396970F1160@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200217152518.GA18376@e121166-lin.cambridge.arm.com>
 <384eb5378ee2b240d6ab7d89aef2d5c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <384eb5378ee2b240d6ab7d89aef2d5c7@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 03:35:01PM +0000, Marc Zyngier wrote:
> On 2020-02-17 15:25, Lorenzo Pieralisi wrote:
> > On Mon, Feb 17, 2020 at 12:35:12PM +0000, Pankaj Bansal wrote:
> 
> Hi Lorenzo,
> 
> [...]
> 
> > > > Side note: can you explain to me please how the MSI allocation flow
> > > > and kernel data structures/drivers are modeled in DT ? I had a quick
> > > > look at:
> > > >
> > > > drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
> > > >
> > > > and to start with, does that code imply that we create a
> > > > DOMAIN_BUS_FSL_MC_MSI on ALL DT systems with an ITS device node ?
> > > 
> > > Yes. It's being done for all DT systems having ITS node.
> > 
> > This does not seem correct to me, I will let Marc comment on
> > the matter.
> 
> Unfortunately, there isn't a very good way to avoid that ATM,
> other than defering the registration of the irqdomain until
> we know that a particular bus (for example a PCIe RC) is registered.
> 
> I started working on that at some point, and ended up nowhere because
> no bus (PCI, FSL, or anything else) really give us the right information
> when it is actually required (when a device starts claiming interrupts).
> 
> I *think* we could try a defer it until a bus root is found, and that
> this bus has a topological link to an ITS. probably invasive though,
> as you would need a set of "MSI providers" for each available irqchip
> node.

Yes I see, it is not trivial - I just raised the point while reading the
code to understand how the IRQ domain structures are connected in the DT
bootstrap case, I don't think that's an urgent issue to solve, just
noticed and reported it to make sure you are aware.

Thanks !
Lorenzo
