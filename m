Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59217388E69
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353479AbhESM5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232671AbhESM5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 08:57:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0EAA6124C;
        Wed, 19 May 2021 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621428982;
        bh=uHLg5icCC3xpZyJI1+jRahgAtowPa/rbAim0BxR6NR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCNyEIxV9y1+0VGujexB6B/CDIPzVD7OZ2RN9jpzcgqUbSqVs+425K63NnxyeOLiW
         qroY126NCh4zhx0dBonpOioJ4PUpLAtkTx/MuCYzEE/vgSK+FJLumLjCbLsAK3ngtb
         krIDkJgejF5SVLTmDqZGp85NLbINqcabNg4YyxjCS6IA5KodCRWo4m6J2rEOQBvdfy
         COwpEt0BJLSbTDVM2q+BcT5CYUkCnt1q7+H61v5J+0+4RQCLvUX6VapzcjN7y9XWsF
         zBSYjeg+0RX8+U8hfz8qVTrO8CC0BOTlux96NksmCBL5/jBLEhSaWz94k1TLcs+2l6
         gYaUSm3zE1CiA==
Date:   Wed, 19 May 2021 15:56:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YKUK8hBImIUFV35I@unreal>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
 <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
 <YKTJwscaV1WaK98z@unreal>
 <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com>
 <YKT7bLjzucl/QEo2@unreal>
 <CAMdYzYpVYuNuYgZp-sNj4QFbgHH+SoFpffbdCNJST2_KZEhSug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMdYzYpVYuNuYgZp-sNj4QFbgHH+SoFpffbdCNJST2_KZEhSug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 08:45:21AM -0400, Peter Geis wrote:
> On Wed, May 19, 2021 at 7:50 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, May 19, 2021 at 12:37:43PM +0200, Heiner Kallweit wrote:
> > > On 19.05.2021 10:18, Leon Romanovsky wrote:
> > > > On Tue, May 18, 2021 at 08:20:03PM -0400, Peter Geis wrote:
> > > >> On Tue, May 18, 2021 at 4:59 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >>>
> > > >>> On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> > > >>>> Add a driver for the Motorcomm yt8511 phy that will be used in the
> > > >>>> production Pine64 rk3566-quartz64 development board.
> > > >>>> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> > > >>>>
> > > >>>> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> > > >>>> ---
> > > >>>>  MAINTAINERS                 |  6 +++
> > > >>>>  drivers/net/phy/Kconfig     |  6 +++
> > > >>>>  drivers/net/phy/Makefile    |  1 +
> > > >>>>  drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
> > > >>>>  4 files changed, 98 insertions(+)
> > > >>>>  create mode 100644 drivers/net/phy/motorcomm.c
> > > >>>
> > > >>> <...>
> > > >>>
> > > >>>> +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> > > >>>> +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > > >>>> +     { /* sentinal */ }
> > > >>>> +}
> > > >>>
> > > >>> Why is this "__maybe_unused"? This *.c file doesn't have any compilation option
> > > >>> to compile part of it.
> > > >>>
> > > >>> The "__maybe_unused" is not needed in this case.
> > > >>
> > > >> I was simply following convention, for example the realtek.c,
> > > >> micrel.c, and smsc.c drivers all have this as well.
> > > >
> > > > Maybe they have a reason, but this specific driver doesn't have such.
> > > >
> > >
> > > It's used like this:
> > > MODULE_DEVICE_TABLE(mdio, <mdio_device_id_tbl>);
> > >
> > > And MODULE_DEVICE_TABLE is a no-op if MODULE isn't defined:
> > >
> > > #ifdef MODULE
> > > /* Creates an alias so file2alias.c can find device table. */
> > > #define MODULE_DEVICE_TABLE(type, name)                                       \
> > > extern typeof(name) __mod_##type##__##name##_device_table             \
> > >   __attribute__ ((unused, alias(__stringify(name))))
> > > #else  /* !MODULE */
> > > #define MODULE_DEVICE_TABLE(type, name)
> > > #endif
> > >
> > > In this case the table is unused.
> >
> > Do you see compilation warning for such scenario?
> 
> The issue you are describing has been fixed since 2010:
> 
> commit cf93c94581bab447a5634c6d737c1cf38c080261
> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Date:   Sun Oct 3 23:43:32 2010 +0000
> 
>     net/phy: fix many "defined but unused" warnings
> 
>     MODULE_DEVICE_TABLE only expands to something if it's compiled
>     for a module.  So when building-in support for the phys, the
>     mdio_device_id tables are unused.  Marking them with __maybe_unused
>     fixes the following warnings:
> 
> There is a strong push to fix all warnings during build, including W=1 warnings.
> For fun I rebuilt without module support and confirmed that removing
> this does trigger a W=1 warning.

I'm sorry that I continue to ask, but is net/phy/* usable without MODULE?
If not, the better fix is to require it in Kconfig instead of fixing all drivers.

Thanks for your answers.

> 
> >
> > Thanks
> >
> > >
> > > > Thanks
> > > >
> > > >>
> > > >>>
> > > >>> Thanks
> > >
> > >
