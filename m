Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04722DA923
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 09:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgLOI0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 03:26:10 -0500
Received: from ns2.baikalelectronics.com ([94.125.187.42]:50062 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726217AbgLOI0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 03:26:10 -0500
Date:   Tue, 15 Dec 2020 11:25:27 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] net: stmmac: Problem with adding the native GPIOs support
Message-ID: <20201215082527.lqipjzastdlhzkqv@mobilestation>
References: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
 <20201214153143.GB2841266@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201214153143.GB2841266@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Mon, Dec 14, 2020 at 04:31:43PM +0100, Andrew Lunn wrote:
> On Mon, Dec 14, 2020 at 12:25:16PM +0300, Serge Semin wrote:
> > Hello folks,
> > 
> > I've got a problem, which has been blowing by head up for more than three
> > weeks now, and I'm desperately need your help in that matter. See our
> > Baikal-T1 SoC is created with two DW GMAC v3.73a IP-cores. Each core
> > has been synthesized with two GPIOs: one as GPI and another as GPO. There
> > are multiple Baikal-T1-based devices have been created so far with active
> > GMAC interface usage and each of them has been designed like this:
> > 
> >  +------------------------+
> >  | Baikal-T1 +------------+       +------------+
> >  |   SoC     | DW GMAC    |       |   Some PHY |
> >  |           |      Rx-clk+<------+Rx-clk      |
> >  |           |            |       |            |
> >  |           |         GPI+<------+#IRQ        |
> >  |           |            |       |            |
> >  |           |       RGMII+<----->+RGMII       |
> >  |           |        MDIO+<----->+MDIO        |
> >  |           |            |       |            |
> >  |           |         GPO+------>+#RST        |
> >  |           |            |       |            |
> >  |           |      Tx-clk+------>+Tx-clk      |
> >  |           |            |       |            |
> >  |           +------------+       +------------+
> >  +------------------------+
> > 
> > Each of such devices has got en external RGMII-PHY attached configured via the
> > MDIO bus with Rx-clock supplied by the PHY and Tx-clock consumed by it. The
> > main peculiarity of such configuration is that the DW GMAC GPIOs have been used
> > to catch the PHY IRQs and to reset the PHY. Seeing the GPIOs support hasn't
> > been added to the STMMAC driver it's the very first setup for now, which has
> > been using them.
> 

> It sounds like you need to cleanly implement a GPIO controller within
> the stmmac driver. But you probably want to make it conditional on a
> DT property. For example, look to see if there is the
> 'gpio-controller;'

Yeap, that's what I have already done. The problem is that the
GPOs state is getting reset together with the MAC reset. So we don't
have a full control over the GPOs state when the MAC gets reset.

> 
> > Anyway the hardware setup depicted above doesn't seem
> > problematic at the first glance, but in fact it is. See, the DW *MAC driver
> > (STMMAC ethernet driver) is doing the MAC reset each time it performs the
> > device open or resume by means of the call-chain:
> > 
> >   stmmac_open()---+
> >                   +->stmmac_hw_setup()->stmmac_init_dma_engine()->stmmac_reset().
> >   stmmac_resume()-+
> > 
> > Such reset causes the whole interface reset: MAC, DMA and, what is more
> > important, GPIOs as being exposed as part of the MAC registers. That
> > in our case automatically causes the external PHY reset, what neither
> > the STTMAC driver nor the PHY subsystem expect at all.
> 

> Is the reset of the GPIO sub block under software control? When you
> have a GPIO controller implemented, you would want to disable this.

Not sure I've fully understood your question. The GPIO sub-block of
the MAC is getting reset together with the MAC. So when we reset the
MAC, the GPOs state will get reset too. Seeing the STMMAC driver
performs the reset on open() and resume() callbacks the GPIOs gets to
reset synchronously there too. That's the main problem. We can't
somehow change the MAC reset behavior. So it's either to get rid of
the reset or somehow take the results of the reset into account in
software (like reinitialize the PHY too after it).

> 
> Once you have a GPIO controller, you can make use of the standard PHY
> DT properties to allow the PHY driver to make use of the interrupt,
> and to control the reset of the PHY.

Yeah, that's what I initially intended to implement. If only the
GPIO-control register wasn't reset on the MAC reset, I wouldn't even
asked the question.

-Sergey

> 
>      Andrew
