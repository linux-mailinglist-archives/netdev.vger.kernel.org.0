Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DBF191336
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgCXO3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:29:31 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:40527 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgCXO3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:29:31 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id AE77830001EC4;
        Tue, 24 Mar 2020 15:29:29 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 85D3A1B36FD; Tue, 24 Mar 2020 15:29:29 +0100 (CET)
Date:   Tue, 24 Mar 2020 15:29:29 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 11/14] net: ks8851: Implement register and FIFO accessor
 callbacks
Message-ID: <20200324142929.dfs2cdmj3na27oo5@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-12-marex@denx.de>
 <20200324134555.wgtvj4owmkw3jup4@wunner.de>
 <a071d1a4-c627-f2e2-d689-4663671d97d9@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a071d1a4-c627-f2e2-d689-4663671d97d9@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 03:10:59PM +0100, Marek Vasut wrote:
> On 3/24/20 2:45 PM, Lukas Wunner wrote:
> > On Tue, Mar 24, 2020 at 12:43:00AM +0100, Marek Vasut wrote:
> >> The register and FIFO accessors are bus specific. Implement callbacks so
> >> that each variant of the KS8851 can implement matching accessors and use
> >> the rest of the common code.
> > [...]
> >> +	unsigned int		(*rdreg16)(struct ks8851_net *ks,
> >> +					   unsigned int reg);
> >> +	void			(*wrreg16)(struct ks8851_net *ks,
> >> +					   unsigned int reg, unsigned int val);
> >> +	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
> >> +					  unsigned int len);
> >> +	void			(*wrfifo)(struct ks8851_net *ks,
> >> +					  struct sk_buff *txp, bool irq);
> > 
> > Using callbacks entails a dereference for each invocation.
> 
> Yes indeed, the SPI stack which you use to talk to the KS8851 SPI is
> also full of those.

Apples and oranges.  Low-level SPI drivers provide callbacks to the
SPI core because it would be too expensive (space-wise) to link the
SPI core into every low-level driver.  Whereas in this case, you're
generating two separate modules anyway, so there's no need at all
to use callbacks.


> > A cheaper approach is to just declare the function signatures
> > in ks8851.h and provide non-static implementations in
> > ks8851_spi.c and ks8851_mll.c, so I'd strongly prefer that.
> > 
> > Even better, since this only concerns the register accessors
> > (which are inlined anyway by the compiler), it would be best
> > to have them in header files (e.g. ks8851_spi.h / ks8851_par.h)
> > which are included by the common ks8851.c based on the target
> > which is being compiled.  That involves a bit of kbuild magic
> > though to generate two different .o from the same .c file,
> > each with specific "-include ..." CFLAGS.
> 
> Before we go down the complex and ugly path, can you check whether this
> actually has performance impact ? I would expect that since this is an
> SPI-connected device, this here shouldn't have that much impact. But I
> might be wrong, I don't have the hardware.

I can test it, but the devices are in the office, I won't return there
before Thursday.  That said, I don't think it's a proper approach to
make the code more expensive even though it's perfectly possible to
avoid any performance impact, and shrug off concerns with the argument
that the impact should be measured first.


> Also note that having this dereference in place, it permits me to easily
> implement accessors for both LE and BE variant of the parallel bus device.

My understanding is that you're supposed to configure the chip to use
the native endianness of your architecture on ->probe() such that
conversions become unnecessary and the same accessor can be used for
LE and BE.  So why do you need two accessors?

Thanks,

Lukas
