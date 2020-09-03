Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267B125C7D9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgICRNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICRNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:13:23 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2522EC061244;
        Thu,  3 Sep 2020 10:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dRcGf3KYecW+n3OXbdBGO10VnYMf5O+jmdOR39XnP9I=; b=t3PyT3NG5+DMtqGVyykFdrbqrJ
        mSt6MXz7kRozuGQetuEUfvlX27BF9+M4jMIDvm6Z/g/URYJ0KA2mWa0bZay6hWc6RTJes79jDAlel
        HNOSxBVkNHSYNuL3EMbcbZcoVlBVHqoxgK6SLdJzjd2Hei6AuJT64nNZb0fEzQ1fsTG7JRkmblJW5
        zC1EQZF9R8m0W1NpH9ZA4aGCyf8kwEROheE3Np+ZGXb28mHfCidiCijH3fv+DU4x6My3IlLp440Q+
        OtqLUYQq4ChUcOAYvaOcteuU6xN/1zMskk5tS3gAqvW8hTIobEaEBHzo7cRcZ4Ns5aO/6X7hqr4i8
        uA0e8iJg==;
Received: from 188.147.96.44.nat.umts.dynamic.t-mobile.pl ([188.147.96.44] helo=[192.168.8.103])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kDsnY-00D3La-K5; Thu, 03 Sep 2020 19:13:20 +0200
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
 <77088212-ac93-9454-d3a0-c2eb61b5c3e0@arf.net.pl>
 <26a8a508-6108-035a-1416-01cff51a930a@gmail.com>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <a61eacc0-caaf-aee9-c0e6-11280c893d65@arf.net.pl>
Date:   Thu, 3 Sep 2020 19:13:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <26a8a508-6108-035a-1416-01cff51a930a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


W dniu 2020-09-03 o 17:21, Florian Fainelli pisze:
>
>
> On 9/2/2020 11:00 PM, Adam Rudziński wrote:
>>
>> W dniu 2020-09-03 o 04:13, Florian Fainelli pisze:
>>>
>>>
>>> On 9/2/2020 3:20 PM, Andrew Lunn wrote:
>>>>> +    priv->clk = devm_clk_get_optional(&phydev->mdio.dev, "sw_gphy");
>>>>> +    if (IS_ERR(priv->clk))
>>>>> +        return PTR_ERR(priv->clk);
>>>>> +
>>>>> +    /* To get there, the mdiobus registration logic already 
>>>>> enabled our
>>>>> +     * clock otherwise we would not have probed this device since 
>>>>> we would
>>>>> +     * not be able to read its ID. To avoid artificially bumping 
>>>>> up the
>>>>> +     * clock reference count, only do the clock enable from a 
>>>>> phy_remove ->
>>>>> +     * phy_probe path (driver unbind, then rebind).
>>>>> +     */
>>>>> +    if (!__clk_is_enabled(priv->clk))
>>>>> +        ret = clk_prepare_enable(priv->clk);
>>>>
>>>> This i don't get. The clock subsystem does reference counting. So what
>>>> i would expect to happen is that during scanning of the bus, phylib
>>>> enables the clock and keeps it enabled until after probe. To keep
>>>> things balanced, phylib would disable the clock after probe.
>>>
>>> That would be fine, although it assumes that the individual PHY 
>>> drivers have obtained the clocks and called clk_prepare_enable(), 
>>> which is a fair assumption I suppose.
>>>
>>>>
>>>> If the driver wants the clock enabled all the time, it can enable it
>>>> in the probe method. The common clock framework will then have two
>>>> reference counts for the clock, so that when the probe exists, and
>>>> phylib disables the clock, the CCF keeps the clock ticking. The PHY
>>>> driver can then disable the clock in .remove.
>>>
>>> But then the lowest count you will have is 1, which will lead to the 
>>> clock being left on despite having unbound the PHY driver from the 
>>> device (->remove was called). This does not allow saving any power 
>>> unfortunately.
>>>
>>>>
>>>> There are some PHYs which will enumerate with the clock disabled. They
>>>> only need it ticking for packet transfer. Such PHY drivers can enable
>>>> the clock only when needed in order to save some power when the
>>>> interface is administratively down.
>>>
>>> Then the best approach would be for the OF scanning code to enable 
>>> all clocks reference by the Ethernet PHY node (like it does in the 
>>> proposed patch), since there is no knowledge of which clock is 
>>> necessary and all must be assumed to be critical for MDIO bus 
>>> scanning. Right before drv->probe() we drop all resources reference 
>>> counts, and from there on ->probe() is assumed to manage the 
>>> necessary clocks.
>>>
>>> It looks like another solution may be to use the assigned-clocks 
>>> property which will take care of assigning clock references to 
>>> devices and having those applied as soon as the clock provider is 
>>> available.
>>
>> Hi Guys,
>>
>> I've just realized that a PHY may also have a reset signal connected. 
>> The reset signal may be controlled by the dedicated peripheral or by 
>> GPIO.
>
> There is already support for such a thing within 
> drivers/net/phy/mdio_bus.c though it assumes we could bind the PHY 
> device to its driver already.
>
>>
>> In general terms, there might be a set of control signals needed to 
>> enable the PHY. It seems that the clock and the reset would be the 
>> typical useful options.
>>
>> Going further with my imagination of how evil the hardware design 
>> could be, in general the signals for the PHY may have some relations 
>> to other control signals.
>>
>> I think that from the software point of view this comes down to 
>> assumption that the PHY is to be controlled "driver only knows how".
>
> That is all well and good as long as we can actually bind the PHY 
> device which its driver, and right now this means that we either have:
>
> - a compatible string in Device Tree which is of the form 
> ethernet-phy-id%4x.%4x (see of_get_phy_id) which means that we *know* 
> already which PHY we have and we avoid doing reads of MII_PHYSID1 and 
> MII_PHYSID2. This is a Linux implementation detail that should not 
> have to be known to systems designer IMHO
>
> - a successful read of MII_PHYSID1 and MII_PHYSID2 (or an equivalent 
> for the clause 45 PHYs) that allows us to know what PHY device we 
> have, which is something that needs to happen eventually.
>
> The problem is when there are essential resources such as clocks, 
> regulators, reset signals that must be enabled, respectively 
> de-asserted in order for a successful MDIO read of MII_PHYSID1 and 
> MII_PHYSID2 to succeed.
>
> There is no driver involvement at that stage because we have no 
> phy_device to bind it to *yet*. Depending on what we read from 
> MII_PHYSID1/PHY_ID2 we will either successfully bind to the Generic 
> PHY driver (assuming we did not read all Fs) or not and we will return 
> -ENODEV and then it is game over.
>
> This is the chicken and egg problem that this patch series is 
> addressing, for clocks, because we can retrieve clock devices with 
> just a device_node reference.

I have an impression that here the effort goes in the wrong direction. 
If I understand correctly, the goal is to have the kernel find out what 
will the driver need to use the phy. But, the kernel anyway calls a 
probe function of the driver, doesn't it? To me it looks as if you were 
trying to do something that the driver will/would/might do later, and 
possibly "undo" it in the meantime. In this regard, this becomes kind of 
a workaround, not solution of the problem. Also, having taken a glance 
at your previous messages, I can tell that this is all becoming even 
more complex.

I think that the effort should be to allow any node in the device tree 
to take care about its child nodes by itself, and just "report" to the 
kernel, or "install" in the kernel whatever is necessary, but without 
any initiative of the kernel. Let the drivers be as complicated as 
necessary, not the kernel.

Best regards,
Adam

