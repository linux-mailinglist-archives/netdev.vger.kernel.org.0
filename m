Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A3E1370BA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgAJPIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:08:44 -0500
Received: from foss.arm.com ([217.140.110.172]:46356 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgAJPIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:08:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15CEA30E;
        Fri, 10 Jan 2020 07:08:43 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF6973F6C4;
        Fri, 10 Jan 2020 07:08:41 -0800 (PST)
Date:   Fri, 10 Jan 2020 15:08:36 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Message-ID: <20200110150836.1f92a0a8@donnerap.cambridge.arm.com>
In-Reply-To: <20200110142250.GH19739@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
        <20200110115415.75683-13-andre.przywara@arm.com>
        <20200110140852.GF19739@lunn.ch>
        <20200110141303.2e5863ab@donnerap.cambridge.arm.com>
        <20200110142250.GH19739@lunn.ch>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 15:22:50 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

Hi,

> On Fri, Jan 10, 2020 at 02:13:03PM +0000, Andre Przywara wrote:
> > On Fri, 10 Jan 2020 15:08:52 +0100
> > Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > Hi Andrew,
> > 
> > thanks for having a look!
> >   
> > > > To autodetect this configuration, at probe time we write all 1's to such
> > > > an MSB register, and see if any bits stick.    
> > > 
> > > So there is no register you can read containing the IP version?  
> > 
> > There is, and I actually read this before doing this check. But the 64-bit DMA capability is optional even in this revision. It depends on what you give it as the address width. If you say 32, the IP config tool disables the 64-bit capability completely, so it stays compatible with older revisions.
> > Anything beyond 32 will enable the MSB register and will also require you to write to them.  
> 
> So you are saying there is no way to enumerate the synthesised
> configuration of the IP. Great :-(

Apparently not.

> Do Xilinx at least document you can discover the DMA size by writing
> into these upper bits? Does Xilinx own 'vendor crap' driver do this?

So far I couldn't be bothered to put my asbestos trousers on and go into BSP land ;-)
Now quickly browsing the linux-xlnx github repo suggests they make this MSB register access dependent on CONFIG_PHYS_ADDR_T_64BIT. Which would mean:
- A 32-bit kernel on a device configured for >32 bit DMA would not work.
- They always write to the MSB registers on 64-bit and (L)PAE kernels.

The DMA mask is set to the value of the xlnx,addrwidth, in a similar way I did it in the next patch. Minus the safety check for the 64-bit DMA capability.

I got this idea of probing when I saw that those registers are marked as "Reserved" in earlier revisions of the documentation. I couldn't find an exact definition of "Reserved" in that manual, though.
Then I confirmed that behaviour by testing this on an image configured for only a 32 bit wide address bus, where those registers are apparently hardwired to zero.

So if you were hoping for an official blessing, I have to disappoint you ;-)

We could rely completely on the addrwidth property, at the price of it not working when the IP is configured for >32 bits, but the addrwidth property is missing or erroneously set to 32. But I think their:
struct xxx { ....
	phys_addr_t next;	/* Physical address of next buffer descriptor */
#ifndef CONFIG_PHYS_ADDR_T_64BIT
	u32 reserved1;
#endif

construct is broken, and we should not copy this. Also they do writeq to this register, not sure that's the right thing to do.

Cheers,
Andre.
