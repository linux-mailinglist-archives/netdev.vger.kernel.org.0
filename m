Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155072DAF79
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgLOOxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:53:50 -0500
Received: from ns2.baikalelectronics.com ([94.125.187.42]:50896 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729776AbgLOOxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:53:42 -0500
Date:   Tue, 15 Dec 2020 17:52:53 +0300
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
Message-ID: <20201215145253.sc6cmqetjktxn4xb@mobilestation>
References: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
 <20201214153143.GB2841266@lunn.ch>
 <20201215082527.lqipjzastdlhzkqv@mobilestation>
 <20201215135837.GB2822543@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201215135837.GB2822543@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 02:58:37PM +0100, Andrew Lunn wrote:
> > > > Anyway the hardware setup depicted above doesn't seem
> > > > problematic at the first glance, but in fact it is. See, the DW *MAC driver
> > > > (STMMAC ethernet driver) is doing the MAC reset each time it performs the
> > > > device open or resume by means of the call-chain:
> > > > 
> > > >   stmmac_open()---+
> > > >                   +->stmmac_hw_setup()->stmmac_init_dma_engine()->stmmac_reset().
> > > >   stmmac_resume()-+
> > > > 
> > > > Such reset causes the whole interface reset: MAC, DMA and, what is more
> > > > important, GPIOs as being exposed as part of the MAC registers. That
> > > > in our case automatically causes the external PHY reset, what neither
> > > > the STTMAC driver nor the PHY subsystem expect at all.
> > > 
> > 
> > > Is the reset of the GPIO sub block under software control? When you
> > > have a GPIO controller implemented, you would want to disable this.
> > 
> > Not sure I've fully understood your question. The GPIO sub-block of
> > the MAC is getting reset together with the MAC.
> 

> And my question is, is that under software control, or is the hardware
> synthesised so that the GPIO controller is reset as part of the MAC
> reset?

Alas the SoC has already been synthesized and multiple devices have
already been produced as I described in the initial message. So we can't
change the way the MAC reset works.

> 
> From what you are saying, it sounds like from software you cannot
> independently control the GPIO controller reset?

No. The hardware implements the default MAC reset behavior. So the
GPIO controller gets reset synchronously with the MAC reset and that
can't be changed.

> 
> This is something i would be asking the hardware people. Look at the
> VHDL, etc.

Alas it's too late. I have to fix it in software somehow. As I see it
the only possible ways to bypass the problem are either to re-init the
PHY each time the reset happens or somehow to get rid of the MAC
reset. That's why I have sent this RFC to ask the driver maintainers
whether my suggestions are correct or of a better idea to work around
the problem.

-Sergey

> 
>       Andrew
