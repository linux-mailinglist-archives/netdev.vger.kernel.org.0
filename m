Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439A46C1160
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCTMBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCTMBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:01:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74742529D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 05:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KpzCvxhxmcsVOJz0jmxbLcWRwUGng79XwrPZn5cdpBo=; b=yCZqQ9BUIaYMmt1Wih1B5KNASg
        vuDQVfltHjD0htFGI6Mk/kFn7v+66WVyg5LTRQYtmaPUaH15H91m+mpR6IG8uTZrqvMsLs28QnbWw
        FvFCPdHcTHbOgxESkHrmiwp4yWf/r4sAx8xCYwJ2F67DyUxtyeirUu04gZ+S0UalkO/U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1peEC9-007q7d-UE; Mon, 20 Mar 2023 13:00:57 +0100
Date:   Mon, 20 Mar 2023 13:00:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Buzarra, Arturo" <Arturo.Buzarra@digi.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Message-ID: <74cef958-9513-40d7-8da4-7a566ba47291@lunn.ch>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
 <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
 <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR10MB4926EBB7DAA389E69A4E2FC1FA809@DS7PR10MB4926.namprd10.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:45:38AM +0000, Buzarra, Arturo wrote:
> Hi,
> 
> I will try to answer all your questions:
> 
> - "We need more specifics here, what type of PHY device are you seeing this with?"
> - " So best start with some details about your use case, which MAC, which PHY, etc"
> I'm using a LAN8720A PHY (10/100 on RMII mode) with a ST MAC ( in particular is a stm32mp1 processor).
> We have two PHYs one is a Gigabit PHY (RGMII mode) and the another one is a 10/100 (RMII mode).

Where is the clock coming from? Does each PHY have its own crystal? Is
the clock coming from one of the MACs? Is one PHY a clock source and
the other a clock sync?

> In the boot process, I think that there is a race condition between
> configuring the Ethernet MACs and the two PHYs. At same point the
> RGMII Ethernet MAC is configured and starts the PHY probes.

You have two MACs. Do you have two MDIO busses, with one PHY on each
bus, or do you have just one MDIO bus in use, with two PHYs on it?

Please show us your Device Tree description of the hardware.

> When the 10/100 PHY starts the probe, it tries to read the
> genphy_read_abilities() and always reads 0xFFFF ( I assume that this
> is the default electrical values for that lines before it are
> configured).

There is a pull up on the MDIO data line, so that if nothing drives it
low, it reads 1. This was one of Florian comments. Have you check the
value of that pull up resistor?

> - " Does the device reliably enumerate on the bus, i.e. reading registers 2 and 3 to get its ID?"
> Reading the registers PHYSID1 and PHYSID2 reports also 0xFFFF

Which is odd, because the MDIO bus probe code would assume there is no
PHY there given those two values, and then would not bother trying to
read the abilities. So you are somehow forcing the core to assume
there is a PHY there. Do you have the PHY ID in DT?

> - " If the PHY is broken, by some yet to be determined definition of broken, we try to limit the workaround to as narrow as possible. So it should not be in the core probe code. It should be in the PHY specific driver, and ideally for only its ID, not the whole vendors family of PHYs"
> I have several workarounds/fixed for that, the easy way is set the PHY capabilities in the smsc.c driver " .features	= PHY_BASIC_FEATURES" like in the past and it works fine. Also I have another fix in the same driver adding a custom function for " get_features" where if I read 0xFFFF or 0x0000 return a EPROBE_DEFER. However after review another drivers (net/usb/pegasus.c , net/Ethernet/toshiba/spider_net.c, net/sis/sis190.c, and more...)  that also checks the result of read MII_BMSR against 0x0000 and 0xFFFF , I tried to send a common fix in the PHY core. From my point of view read a 0x0000 or 0xFFFF value is an error in the probe step like if the phy_read() returns an error, so I think that the PHY core should consider return a EPROBE_DEFER to at least provide a second try for that PHY device.

We first want to understand the problem before adding such hacks. It
really sounds like something the PHY needs is missing, a clock, time
after a reset, etc. If we can figure that out, we can avoid such
hacks.

	Andrew
