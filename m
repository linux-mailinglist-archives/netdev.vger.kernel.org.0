Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9C1313E76
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhBHTGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:06:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56082 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhBHTEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:04:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9Bou-004vFh-KW; Mon, 08 Feb 2021 20:03:36 +0100
Date:   Mon, 8 Feb 2021 20:03:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
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
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <YCGLCK+1RB7pzytU@lunn.ch>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <YCFYaFYgFikj/Gqz@lunn.ch>
 <20210208174441.z4nnugkaadhmgnum@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208174441.z4nnugkaadhmgnum@mobilestation>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> I honestly tried to find any doc with a glimpse of errata for RTL8211E
> PHY, but with no luck. Official datasheet didn't have any info regarding
> possible hw bugs too. Thus I had no choice but to find a fix of the
> problem myself.
> 
> It took me some time to figure out why the events weren't reported after
> the very first link setup (turned out only a full HW reset clears the
> PC1R.10 bit state). I thought it could have been connected with some
> sleep/idle/power-safe mode. So I disabled the EEE initialization in the
> STMMAC driver. It worked. Then I left the EEE mode enabled, but called the
> phy_init_eee(phy, 0) method with "clk_stop_enable==0", so PHY wouldn't
> stop RXC in LPI mode. And it wonderfully worked. Then I started to dig in
> from another side. I left "RXC disable in LPI" mode enabled and tried to
> figure out what was going on with the PHY when it stopped reporting events
> just by reading from its CSR using phytool utility. It was curious to
> discover that any attempt to read from any PHY register caused the problem
> disappearance (LED2 started blinking, events got to be reported). Since I
> did nothing but a mere reading from a random even EEE-unrelated register I
> inferred that the problem must be in some HW/PHY bug. That's how I've got
> to the patch introduced here. If you have any better idea what could be a
> reason of that weird behavior I'd be glad to test it out on my device.

It is a reasonable explanation, and a read should not do any harm.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
   
