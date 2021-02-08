Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B53F313BF7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhBHR7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:59:31 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:58176 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbhBHR4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:56:37 -0500
Date:   Mon, 8 Feb 2021 20:44:41 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210208174441.z4nnugkaadhmgnum@mobilestation>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <YCFYaFYgFikj/Gqz@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YCFYaFYgFikj/Gqz@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 04:27:36PM +0100, Andrew Lunn wrote:
> On Mon, Feb 08, 2021 at 05:03:22PM +0300, Serge Semin wrote:
> > It has been noticed that RTL8211E PHY stops detecting and reporting events
> > when EEE is successfully advertised and RXC stopping in LPI is enabled.
> > The freeze happens right after 3.0.10 bit (PC1R "Clock Stop Enable"
> > register) is set. At the same time LED2 stops blinking as if EEE mode has
> > been disabled. Notably the network traffic still flows through the PHY
> > with no obvious problem. Anyway if any MDIO read procedure is performed
> > after the "RXC stop in LPI" mode is enabled PHY gets to be unfrozen, LED2
> > starts blinking and PHY interrupts happens again. The problem has been
> > noticed on RTL8211E PHY working together with DW GMAC 3.73a MAC and
> > reporting its event via a dedicated IRQ signal. (Obviously the problem has
> > been unnoticed in the polling mode, since it gets naturally fixed by the
> > periodic MDIO read procedure from the PHY status register - BMSR.)
> > 
> > In order to fix that problem we suggest to locally re-implement the MMD
> > write method for RTL8211E PHY and perform a dummy read right after the
> > PC1R register is accessed to enable the RXC stopping in LPI mode.
> 
> Hi Serge
> 
> Is this listed in an Errata from Realtek?

Hi Andrew,

I honestly tried to find any doc with a glimpse of errata for RTL8211E
PHY, but with no luck. Official datasheet didn't have any info regarding
possible hw bugs too. Thus I had no choice but to find a fix of the
problem myself.

It took me some time to figure out why the events weren't reported after
the very first link setup (turned out only a full HW reset clears the
PC1R.10 bit state). I thought it could have been connected with some
sleep/idle/power-safe mode. So I disabled the EEE initialization in the
STMMAC driver. It worked. Then I left the EEE mode enabled, but called the
phy_init_eee(phy, 0) method with "clk_stop_enable==0", so PHY wouldn't
stop RXC in LPI mode. And it wonderfully worked. Then I started to dig in
from another side. I left "RXC disable in LPI" mode enabled and tried to
figure out what was going on with the PHY when it stopped reporting events
just by reading from its CSR using phytool utility. It was curious to
discover that any attempt to read from any PHY register caused the problem
disappearance (LED2 started blinking, events got to be reported). Since I
did nothing but a mere reading from a random even EEE-unrelated register I
inferred that the problem must be in some HW/PHY bug. That's how I've got
to the patch introduced here. If you have any better idea what could be a
reason of that weird behavior I'd be glad to test it out on my device.

-Sergey

> 
>    Andrew
