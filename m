Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DCC2EB4EF
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbhAEVjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:39:32 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:34318 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbhAEVjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 16:39:32 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D9Qpk2Hdbz1rs00;
        Tue,  5 Jan 2021 22:38:19 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D9Qpg1j2Dz1sFWW;
        Tue,  5 Jan 2021 22:38:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 8X9r4GPMdp6d; Tue,  5 Jan 2021 22:38:17 +0100 (CET)
X-Auth-Info: pccrso3so87LMFpKnJSz8LETnzvl5Y2+EcsGDLK/klM=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  5 Jan 2021 22:38:17 +0100 (CET)
Subject: Re: [PATCH] [RFC] net: phy: smsc: Add magnetics VIO regulator support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20210105161533.250865-1-marex@denx.de> <X/SkAOV6s9vbSYh1@lunn.ch>
 <75b9c711-54af-8d21-f7aa-dc4662ed2234@denx.de> <X/S4D5wWcON1UMzQ@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <97b729e7-6467-c072-4de7-c8a78bdab9f1@denx.de>
Date:   Tue, 5 Jan 2021 22:38:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/S4D5wWcON1UMzQ@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 8:03 PM, Andrew Lunn wrote:
> On Tue, Jan 05, 2021 at 06:53:48PM +0100, Marek Vasut wrote:
>> On 1/5/21 6:38 PM, Andrew Lunn wrote:
>>>> +static void smsc_link_change_notify(struct phy_device *phydev)
>>>> +{
>>>> +	struct smsc_phy_priv *priv = phydev->priv;
>>>> +
>>>> +	if (!priv->vddio)
>>>> +		return;
>>>> +
>>>> +	if (phydev->state == PHY_HALTED)
>>>> +		regulator_disable(priv->vddio);
>>>> +
>>>> +	if (phydev->state == PHY_NOLINK)
>>>> +		regulator_enable(priv->vddio);
>>>
>>> NOLINK is an interesting choice. Could you explain that please.
>>
>> It's the first state after interface is up.
> 
> No, not really. phy_start() actually sets it to PHY_UP. When the state
> machine runs, it kicks off auto-neg and immediately reads the link
> state. If the link is down, it transitions to PHY_NOLINK, at which
> point this code will enable the regulator.
> 
>>> I fear this is not going to be very robust to state machine
>>> changes. And since it is hidden away in a driver, it is going to be
>>> forgotten about. You might want to think about making it more robust.
>>
>> I marked the patch as RFC because I would like input on how to implement
>> this properly. Note that since the regulator supplies the magnetics, which
>> might be shared between multiple ports with different PHYs, I don't think
>> this code should even be in the PHY driver, but somewhere else -- but I
>> don't know where.
> 
> Being shared should not be a problem. The regulator API does reference
> counting. Any one driver turning the regulator on will enable it. But
> it will not be turned off until all the drivers disable it after
> enabling it. But that also means you need to balance the calls to
> regulator_enable() and regulator_disable().
> 
> If for whatever reason this function is called for PHY_HALTED more
> times than for PHY_NOLINK, the counter can go negative, and bad things
> would happen. So i would actually had a bool to smsc_phy_priv
> indicating if the regulator has been enabled. And for each
> phydev->state, decide if the regulator should be enabled, check if it
> is enabled according to the bool, and enable it is not. Same with
> states which indicate it should be disabled. The code is then not
> dependent on specific transitions, but on actual states. That should
> be more robust to changes.
> 
> You also need to think about this regulator being shared. Say some
> other PHY has enabled the regulator. phy_start() might be able to skip
> PHY_NOLINK state and so this PHY never calls regulator_enable(). If
> that other PHY is then configured down, it will disable the regulator,
> and this PHY looses link. That probably is enough for this PHY to
> re-enable the regulator, but it is not ideal.

I think you are completely missing the point, the regulator is just an 
implementation detail. I am more interested in the implementation 
itself, which I suspect should not even be in the PHY driver, but rather 
somewhere closer to the core (where?), because the supply to magnetics 
is not part of the PHY, any PHY can be used with magnetics which need a 
regulator.
