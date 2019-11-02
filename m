Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B749ECCC0
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfKBBSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:18:30 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:50439 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKBBSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:18:30 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9CF5322EE3;
        Sat,  2 Nov 2019 02:18:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572657507;
        bh=+XXMSsxYm2vMYefd9H3iikK2rf+B2sGxbUw0sNsyyIc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g2fuM9Y8yxXFcdkuLrmvGfO4q1qyj3O1jY2PZ4vYLIXevDEz+yS2JWLC2F3TuMxQf
         6nah9fOoYOovMwNWoqkNvvVKK8q4vtSMx3bkhIKG135A9UBqa3Kui1tCGPe1W1GzoR
         sXO5uOYpWyCyOsHakrSVBjpgcmQO2sRQ/VLPe7BE=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 02 Nov 2019 02:18:27 +0100
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
In-Reply-To: <64c0dda8-d428-643e-5edf-ac5108c7ec5c@gmail.com>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-4-michael@walle.cc>
 <754a493b-a557-c369-96e1-6701ba5d5a30@gmail.com>
 <B3B13FB8-42D9-42F9-8106-536F574FA35B@walle.cc>
 <e867d1a9a1e4b878aa0dafe413e9a6f7@walle.cc>
 <64c0dda8-d428-643e-5edf-ac5108c7ec5c@gmail.com>
Message-ID: <9de3e32f081c9b2d1227514b4e9f166e@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2019-10-31 18:35, schrieb Florian Fainelli:
> On 10/31/19 10:22 AM, Michael Walle wrote:
>> Am 2019-10-31 00:59, schrieb Michael Walle:
>>>>> +
>>>>> +    if (of_property_read_bool(node, "atheros,keep-pll-enabled"))
>>>>> +        priv->flags |= AT803X_KEEP_PLL_ENABLED;
>>>> 
>>>> This should probably be a PHY tunable rather than a Device Tree
>>>> property
>>>> as this delves more into the policy than the pure hardware 
>>>> description.
>>> 
>>> To be frank. I'll first need to look into PHY tunables before
>>> answering ;)
>>> But keep in mind that this clock output might be used anywhere on the
>>> board. It must not have something to do with networking. The PHY has 
>>> a
>>> crystal and it can generate these couple of frequencies regardless of
>>> its network operation.
>> 
>> Although it could be used to provide any clock on the board, I don't 
>> know
>> if that is possible at the moment, because the PHY is configured in
>> config_init() which is only called when someone brings the interface 
>> up,
>> correct?
>> 
>> Anyway, I don't know if that is worth the hassle because in almost all
>> cases the use case is to provide a fixed clock to the MAC for an RGMII
>> interface. I don't know if that really fits a PHY tunable, because in
>> the worst case the link won't work at all if the SoC expects an
>> always-on clock.
> 
> Well, that was my question really, is the clock output being controlled
> the actual RXC that will feed back to the MAC or is this is another
> clock output pin (sorry if you indicated that before and I missed it)?

No it is not the RX clock. The PHY has three clock pins, RX clock, TX
clock and a general purpose CLK_25M pin.

> If this is the PHY's RXC, then does the configuration (DSP, PLL, XTAL)
> matter at all on the generated output frequency, or is this just a
> choice for the board designer, and whether the PHY is configured for
> MII/RGMII, it outputs the appropriate clock at 25/125Mhz?

The RXC changes the frequency according to the speed.

-- 
-michael
