Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFB150E4F8
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243070AbiDYQDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiDYQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:03:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC39A2FFC2;
        Mon, 25 Apr 2022 09:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tRaJqis/SWifEwnFIxuNq9dKtN4ay+SViNUuz6JWxmk=; b=ThIeBmQ7cVrq3qfftbtHsbnhFH
        MiYIVhIeiwQ/zC36tF3MmFeJIOhZ44Dqen2123Qt3MHtjiUMCvgzTZMe09t+7P6rXQhYvtNg5n3CZ
        bFJfNCoHoel9E7T0uxFlETsFL7flcOd06A9jeEvnoaiSxTpfA1B9vekbC8viaq2dZQ8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nj17m-00HQ8g-4S; Mon, 25 Apr 2022 17:59:42 +0200
Date:   Mon, 25 Apr 2022 17:59:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel.ziswiler@toradex.com>
Cc:     "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: net: stmmac: dwmac-imx: half duplex crash
Message-ID: <YmbFblFCrGFND+h/@lunn.ch>
References: <36ba455aad3e57c0c1f75cce4ee0f3da69e139a1.camel@toradex.com>
 <YmXIo6q8vVkL6zLp@lunn.ch>
 <5e51e11bbbf6ecd0ee23b4fd2edec98e6e7fbaa8.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e51e11bbbf6ecd0ee23b4fd2edec98e6e7fbaa8.camel@toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Good point. I was blinded by NXP downstream which, while listing all incl. 10baseT/Half and 100baseT/Half as
> supported link modes, also does not work. However, upstream indeed shows only full-duplex modes as supported:
> 
> root@verdin-imx8mp-07106916:~# ethtool eth1
> Settings for eth1:
>         Supported ports: [ TP MII ]
>         Supported link modes:   10baseT/Full 
>                                 100baseT/Full 
>                                 1000baseT/Full 

So maybe we actually want ethtool to report -EINVAL when asked to do
something which is not supported! Humm:

https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy.c#L783


	/* We make sure that we don't pass unsupported values in to the PHY */
	linkmode_and(advertising, advertising, phydev->supported);

So maybe the unsupported mode got removed, and the PHY was asked to
advertise nothing!

Anyway, this is roughly there the check should go.

> ...
> 
> Once I remove them queues being setup via device tree it shows all modes as supported again:
> 
> root@verdin-imx8mp-07106916:~# ethtool eth1
> Settings for eth1:
>         Supported ports: [ TP MII ]
>         Supported link modes:   10baseT/Half 10baseT/Full 
>                                 100baseT/Half 100baseT/Full 
>                                 1000baseT/Full 
> ...
> 
> However, 10baseT/Half, while no longer just crashing, still does not seem to work right. Looking at wireshark
> traces it does send packets but seems not to ever get neither ARP nor DHCP answers (as well as any other packet
> for that matter).

So the answers are on the wire, just not received? 

> Looks like the same actually applies to 10baseT/Full as well. While 100baseT/Half and
> 100baseT/Full work fine now.
> 
> Any idea what else could still be going wrong with them 10baseT modes?

I would use mii-tool to check the status of the PHY. Make sure it
really has negotiated 10/Half mode. After that, it is very likely to
be a MAC problem, and i don't think i can help you.

> On a side note, besides modifying the device tree for such single-queue setup being half-duplex capable, is
> there any easier way? Much nicer would, of course, be if it justworkedTM (e.g. advertise all modes but once a
> half-duplex mode is chosen revert to such single-queue operation). Then, on the other hand, who still uses
> half-duplex communication in this day and age (;-p).

You seem to need it for some reason!

Anyway, it is just code. You have all the needed information in the
adjust_link callback, so you could implement it.

	    Andrew
