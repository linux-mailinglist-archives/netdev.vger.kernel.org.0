Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6963025BAB9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 08:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgICGBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 02:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgICGBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 02:01:16 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68D5C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 23:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rp4ty/SErBOyZ1HZAUPWFuRqlNEUexFqPy4aYRBOPiI=; b=bWJh0/UkolNhardo3R7qOqOZ05
        4dzV13GcuedwmFDwPcBoO4jC/dNgE+lT5y5IZMv1bxCGvLg4Uch7fdl5/6zEe1ScFNpWkOAbukj8e
        NjunvZcqfdKGV9gs3KtkyGN0mwpr+w6KDzOSAXosVkolvgkVzopjNB1H9DonZb25ZsxzR7UWI2NPo
        poRel4kC1wou8GbOLlg854qTA9gmK9Z5x9LeJaNtNnOyEjF8JzBsrLaZJeeSLemfUlcFt+PeVVhyO
        3f8qDBWoakcsphkx8hHBmDZXyVwDUO0YF9z7tTOMjDWAbybALxLyqI9rts27/wZ7eH8Zs1vXeH86R
        UdYa1naA==;
Received: from 188.147.96.44.nat.umts.dynamic.t-mobile.pl ([188.147.96.44] helo=[192.168.8.103])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kDiJ7-001Wcs-3L; Thu, 03 Sep 2020 08:01:13 +0200
Subject: Re: [RFC net-next 2/2] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
 <20200902213347.3177881-3-f.fainelli@gmail.com>
 <20200902222030.GJ3050651@lunn.ch>
 <7696bf30-9d7b-ecc9-041d-7d899dd07915@gmail.com>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <77088212-ac93-9454-d3a0-c2eb61b5c3e0@arf.net.pl>
Date:   Thu, 3 Sep 2020 08:00:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7696bf30-9d7b-ecc9-041d-7d899dd07915@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


W dniu 2020-09-03 o 04:13, Florian Fainelli pisze:
>
>
> On 9/2/2020 3:20 PM, Andrew Lunn wrote:
>>> +    priv->clk = devm_clk_get_optional(&phydev->mdio.dev, "sw_gphy");
>>> +    if (IS_ERR(priv->clk))
>>> +        return PTR_ERR(priv->clk);
>>> +
>>> +    /* To get there, the mdiobus registration logic already enabled 
>>> our
>>> +     * clock otherwise we would not have probed this device since 
>>> we would
>>> +     * not be able to read its ID. To avoid artificially bumping up 
>>> the
>>> +     * clock reference count, only do the clock enable from a 
>>> phy_remove ->
>>> +     * phy_probe path (driver unbind, then rebind).
>>> +     */
>>> +    if (!__clk_is_enabled(priv->clk))
>>> +        ret = clk_prepare_enable(priv->clk);
>>
>> This i don't get. The clock subsystem does reference counting. So what
>> i would expect to happen is that during scanning of the bus, phylib
>> enables the clock and keeps it enabled until after probe. To keep
>> things balanced, phylib would disable the clock after probe.
>
> That would be fine, although it assumes that the individual PHY 
> drivers have obtained the clocks and called clk_prepare_enable(), 
> which is a fair assumption I suppose.
>
>>
>> If the driver wants the clock enabled all the time, it can enable it
>> in the probe method. The common clock framework will then have two
>> reference counts for the clock, so that when the probe exists, and
>> phylib disables the clock, the CCF keeps the clock ticking. The PHY
>> driver can then disable the clock in .remove.
>
> But then the lowest count you will have is 1, which will lead to the 
> clock being left on despite having unbound the PHY driver from the 
> device (->remove was called). This does not allow saving any power 
> unfortunately.
>
>>
>> There are some PHYs which will enumerate with the clock disabled. They
>> only need it ticking for packet transfer. Such PHY drivers can enable
>> the clock only when needed in order to save some power when the
>> interface is administratively down.
>
> Then the best approach would be for the OF scanning code to enable all 
> clocks reference by the Ethernet PHY node (like it does in the 
> proposed patch), since there is no knowledge of which clock is 
> necessary and all must be assumed to be critical for MDIO bus 
> scanning. Right before drv->probe() we drop all resources reference 
> counts, and from there on ->probe() is assumed to manage the necessary 
> clocks.
>
> It looks like another solution may be to use the assigned-clocks 
> property which will take care of assigning clock references to devices 
> and having those applied as soon as the clock provider is available.

Hi Guys,

I've just realized that a PHY may also have a reset signal connected. 
The reset signal may be controlled by the dedicated peripheral or by GPIO.

In general terms, there might be a set of control signals needed to 
enable the PHY. It seems that the clock and the reset would be the 
typical useful options.

Going further with my imagination of how evil the hardware design could 
be, in general the signals for the PHY may have some relations to other 
control signals.

I think that from the software point of view this comes down to 
assumption that the PHY is to be controlled "driver only knows how".

Best regards,
Adam

