Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EC4388D39
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbhESLv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhESLv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 07:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489F561004;
        Wed, 19 May 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621425008;
        bh=IyFH+MsqCrUEp11ph7Ebo4LU9kmoq7dPm/W7a9IJJrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ex5r+6vnzQswyzkWIQOOuU0coY0sHuhTwdvB8liV75Xf3Y4uVBNwCXbcu2TKJOk3v
         65QFdjAd3ylMiP597Nbubbxqn074d4ZyhGXg6oRj97XbyciTmZRmQFhfZdKBmfVeLi
         u6OPqikXBlZ5bXnQaEy6O0Fu9F1Wlk1CMid+rgBVPJv2FNVmXE1Q+G8HzsQ597CuJE
         Ologg02G9671v1mJoIw2bTUEdCoT2hSkOd9JOgZqzXyuSxnfdLrBXBd1A/wftCZwy3
         ptje/t5UCIesDwBxQaMB16JPYTAxF7HjoRaEi/njmU3PeYcy7zPDmZ9hCvvzdTi8Io
         Isg52/a3ThXhg==
Date:   Wed, 19 May 2021 14:50:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YKT7bLjzucl/QEo2@unreal>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
 <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
 <YKTJwscaV1WaK98z@unreal>
 <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 12:37:43PM +0200, Heiner Kallweit wrote:
> On 19.05.2021 10:18, Leon Romanovsky wrote:
> > On Tue, May 18, 2021 at 08:20:03PM -0400, Peter Geis wrote:
> >> On Tue, May 18, 2021 at 4:59 AM Leon Romanovsky <leon@kernel.org> wrote:
> >>>
> >>> On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> >>>> Add a driver for the Motorcomm yt8511 phy that will be used in the
> >>>> production Pine64 rk3566-quartz64 development board.
> >>>> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> >>>>
> >>>> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> >>>> ---
> >>>>  MAINTAINERS                 |  6 +++
> >>>>  drivers/net/phy/Kconfig     |  6 +++
> >>>>  drivers/net/phy/Makefile    |  1 +
> >>>>  drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
> >>>>  4 files changed, 98 insertions(+)
> >>>>  create mode 100644 drivers/net/phy/motorcomm.c
> >>>
> >>> <...>
> >>>
> >>>> +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> >>>> +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> >>>> +     { /* sentinal */ }
> >>>> +}
> >>>
> >>> Why is this "__maybe_unused"? This *.c file doesn't have any compilation option
> >>> to compile part of it.
> >>>
> >>> The "__maybe_unused" is not needed in this case.
> >>
> >> I was simply following convention, for example the realtek.c,
> >> micrel.c, and smsc.c drivers all have this as well.
> > 
> > Maybe they have a reason, but this specific driver doesn't have such.
> > 
> 
> It's used like this:
> MODULE_DEVICE_TABLE(mdio, <mdio_device_id_tbl>);
> 
> And MODULE_DEVICE_TABLE is a no-op if MODULE isn't defined:
> 
> #ifdef MODULE
> /* Creates an alias so file2alias.c can find device table. */
> #define MODULE_DEVICE_TABLE(type, name)					\
> extern typeof(name) __mod_##type##__##name##_device_table		\
>   __attribute__ ((unused, alias(__stringify(name))))
> #else  /* !MODULE */
> #define MODULE_DEVICE_TABLE(type, name)
> #endif
> 
> In this case the table is unused.

Do you see compilation warning for such scenario?

Thanks

> 
> > Thanks
> > 
> >>
> >>>
> >>> Thanks
> 
> 
