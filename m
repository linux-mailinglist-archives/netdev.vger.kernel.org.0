Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2622E3192B
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFADEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:04:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfFADEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Eqa2M6pZQ4QcObAUfSEwZYQVm3xf1r4dljtXwNT9io0=; b=hTiHc9xa+KeSTb9Ucg0RoiGTdz
        8lNY7LyAnigPmrzfnBEIR8lAwSeyTX+hAnz+UE74NczQ3Go4TtHHzMJmC5beEdqql0DG8yKqAMwt2
        0Ye7PeFDEge3kOX6+lC6rAvtkPQG7sBliHV+Sx7rNYF1K4WR7q6ygo4P2ACWlaa+jhKI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWuJM-000377-G2; Sat, 01 Jun 2019 05:04:00 +0200
Date:   Sat, 1 Jun 2019 05:04:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next 01/13] net: axienet: Fixed 64-bit compile,
 enable build on X86 and ARM
Message-ID: <20190601030400.GH18608@lunn.ch>
References: <1559326545-28825-1-git-send-email-hancock@sedsystems.ca>
 <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
 <20190531211043.GD3154@lunn.ch>
 <94beef09-4ec9-194b-b8ed-47032c586b50@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94beef09-4ec9-194b-b8ed-47032c586b50@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 05:28:45PM -0600, Robert Hancock wrote:
> On 2019-05-31 3:10 p.m., Andrew Lunn wrote:
> >>  static inline u32 axienet_ior(struct axienet_local *lp, off_t offset)
> >>  {
> >> -	return in_be32(lp->regs + offset);
> >> +#ifdef CONFIG_MICROBLAZE
> >> +	return __raw_readl(lp->regs + offset);
> >> +#else
> >> +	return ioread32(lp->regs + offset);
> >> +#endif
> >>  }
> > 
> > Please dig deeper into the available accessor functions. There should
> > be a set which works without this #defery. 
> 
> This driver previously only compiled on MicroBlaze, and on that
> platform, in_be32 is mapped to __raw_readl which reads with no byte
> swapping. The confusing this is that MicroBlaze can apparently be set up
> as either LE or BE, so I'm guessing that the hardware setup just
> arranges that the reads are natively in the right byte order depending
> on the mode. If I were to just use ioread32, there would be no change on
> LE Microblaze, but BE Microblaze would start byte-swapping, which I
> assume would break things.
> 
> The Xilinx version of this driver also supports Zynq (arm) and ZynqMP
> (aarch64) platforms, and for those platforms it defines in_be32 to
> __raw_readl as well. Since those are little-endian that ends up being
> the same byte order as ioread32.
> 
> Finally, the setup we're using this hardware with on ARM over a PCIe to
> AXI bridge exposes the device with the same byte order as any other PCIe
> device, so the regular ioread32 accessors are correct.
> 
> I'm not quite sure what to make of that.. most platforms either would
> need or work fine with the "regular" accessors, but I'm not sure that
> wouldn't break big-endian MicroBlaze. It would be useful if one of the
> Xilinx people could confirm that..

What matter here is the endianness of the devices register. Once you
know that, there should be macros which work independent of the
endianness of the CPU and compile to the right thing.  Assuming the
endianness of the device is fixed and not a synthesis option? If it is
synthesis option, i would hope there is a register you can read to
determine its endianennes.

	Andrew
