Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FEB1CA61
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfENO3W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 May 2019 10:29:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:59182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfENO3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 10:29:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F709AD12;
        Tue, 14 May 2019 14:29:19 +0000 (UTC)
Date:   Tue, 14 May 2019 16:29:18 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mfd: ioc3: Add driver for SGI IOC3 chip
Message-Id: <20190514162918.a481ac682f36eb6f05aed984@suse.de>
In-Reply-To: <20190510071419.GB7321@dell>
References: <20190409154610.6735-1-tbogendoerfer@suse.de>
        <20190409154610.6735-3-tbogendoerfer@suse.de>
        <20190508102313.GG3995@dell>
        <20190509160220.bb5382df931e5bd0972276df@suse.de>
        <20190510071419.GB7321@dell>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 May 2019 08:14:19 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> On Thu, 09 May 2019, Thomas Bogendoerfer wrote:
> > > > +	}
> > > > +	pr_err("ioc3: CRC error in NIC address\n");
> > > > +}
> > > 
> > > This all looks like networking code.  If this is the case, it should
> > > be moved to drivers/networking or similar.
> > 
> > no it's not. nic stands for number in a can produced by Dallas Semi also
> > known under the name 1-Wire (https://en.wikipedia.org/wiki/1-Wire).
> > SGI used them to provide partnumber, serialnumber and mac addresses.
> > By placing the code to read the NiCs inside ioc3 driver there is no need
> > for locking and adding library code for accessing these informations.
> 
> Great.  So it looks like you should be using this, no?
> 
>   drivers/base/regmap/regmap-w1.c

not sure about regmap-w1, but drivers/w1 contains usefull stuff
like w1_crc8. The only drawback I see right now is, that I need
information about part numbers at ioc3 probe time, but for using
w1 framework I need to create a platform device, which will give
me this information not synchronous. I'll see how I could solve that.

> > > > +static struct resource ioc3_uarta_resources[] = {
> > > > +	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uarta),
> > > 
> > > You are the first user of offsetof() in MFD.  Could you tell me why
> > > it's required please?
> > 
> > to get the offsets of different chip functions out of a struct.
> 
> I can see what it does on a coding level.
> 
> What are you using it for in practical/real terms?

ioc3 has one PCI bar, where all different functions are accessible.
The current ioc3 register map has all these functions set up in one
struct. The base address of these registers comes out of the PCI
framework and to use the MFD framework I need offsets for the different
functions. And because there was already struct ioc3 I'm using
offsetof on this struct.

> Why wouldn't any other MFD driver require this, but you do?

the other PCI MFD drivers I've looked at, have a PCI BAR per function,
which makes live easier and no need for offsetof. Other MFD drivers
#define the offsets and don't have a big struct, which contains all
function registers. If you really insist on using #defines I need
to go through a few parts of the kernel where struct ioc3 is still used.

> > > > +	if (ipd->info->funcs & IOC3_SER) {
> > > > +		writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL,
> > > > +			&ipd->regs->gpcr_s);
> > > > +		writel(0, &ipd->regs->gppr[6]);
> > > > +		writel(0, &ipd->regs->gppr[7]);
> > > > +		udelay(100);
> > > > +		writel(readl(&ipd->regs->port_a.sscr) & ~SSCR_DMA_EN,
> > > > +		       &ipd->regs->port_a.sscr);
> > > > +		writel(readl(&ipd->regs->port_b.sscr) & ~SSCR_DMA_EN,
> > > > +		       &ipd->regs->port_b.sscr);
> > > > +		udelay(1000);
> > > 
> > > No idea what any of this does.
> > > 
> > > It looks like it belongs in the serial driver (and needs comments).
> > 
> > it configures the IOC3 chip for serial usage. This is not part of
> > the serial register set, so it IMHO belongs in the MFD driver.
> 
> So it does serial things, but doesn't belong in the serial driver?

It sets up IOC3 GPIOs and IOC3 serial mode in way the 8250 driver
can work with the connected superio.

> Could you please go into a bit more detail as to why you think that?
> 
> Why is it better here?

access to gpio and serial mode is outside of the 8250 register space.
So either I need to export with some additional resources/new special
platform data or just set it where it is done.

> It's also totally unreadable by the way!

sure, I'll add comments.

> > > > +	}
> > > > +#if defined(CONFIG_SGI_IP27)
> > > 
> > > What is this?  Can't you obtain this dynamically by probing the H/W?
> > 
> > that's the machine type and the #ifdef CONFIG_xxx are just for saving space,
> > when compiled for other machines and it's easy to remove.
> 
> Please find other ways to save the space.  #ifery can get very messy,
> very quickly and is almost always avoidable.

space isn't a problem at all, so removing #ifdef CONFIG is easy.

> 
> > > > +	if (ipd->info->irq_offset) {
> > > 
> > > What does this really signify?
> > 
> > IOC3 ASICs are most of the time connected to a SGI bridge chip. IOC3 can
> > provide two interrupt lines, which are wired to the bridge chip. The first
> > interrupt is assigned via the PCI core, but since IOC3 is not a PCI multi
> > function device the second interrupt must be treated here. And the used
> > interrupt line on the bridge chip differs between boards.
> 
> Please provide a MACRO, function or something else which results in
> more readable code.  Whatever you choose to use, please add this text
> above, it will be helpful for future readers.

will do.

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
