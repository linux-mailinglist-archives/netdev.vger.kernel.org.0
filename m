Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA16412BCA
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350042AbhIUChp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbhIUCBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:01:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475A5C12CD86
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:10:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v19so12589914pjh.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgqtNmpatBgFR85fXASaK6kxvl1UIOwk0ijHQjy2Eug=;
        b=mc1BOAN/7+iM1YRLwWrRJMGeFucz/c5yNembX6Z8pYYLcV4IzGMVCY9CU1thgAVbxn
         WsAjLV0fyO6TJciesyXa3VsP9Gs78uN4s2GJKQy7pHJ0pGZotP7uaABbUVeAkPGjd9hY
         lOOW92m0dDQxkbru2t7vX7GVzi8HD3iflE0wLiYwHd6qzSmoWIe50NxtNjQuHVf1LfnO
         m+v1ymnK9RFQmEJmHYYYO6PiZuXU1V34TvzHA43vsdphVhKZIOKueCG16dZOSGdh442L
         MIWbe2S0bnHObvKi15Ih0dSFSgs1T3mDNonhBQO8qc+Aa6xM8tRlu7zeQdgZGQVB9VKF
         skUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgqtNmpatBgFR85fXASaK6kxvl1UIOwk0ijHQjy2Eug=;
        b=jwXiNj2pCowyIB6SWjkIbo2u286pTADcGTZ+3wGUzWR6ytT7iuVzVaYsJKEi8sqk0r
         CP4QMw2yBhXWLvNjo9Qpu1fS3pbrlGr/NnbQEI9FpDxDObNKk1ImOiIxloMQXtQHkH5A
         bgUbiUY9ETePizkfqCYSrANUNa0EiFqHQGUCsVuq4IqXySvpa1lONXHcq30N+17ST9A0
         PkSlEbgVZLC/E8m5RxtbmizOr0WFTl7pqP2j7i0A1zBSIuuemrbcjCadKFJWEWqPoszg
         R/QW2l/cHrGmSLii9f/yR1/a0N9CDwxBb7IYdx+o0g3bayVBs6IHMX2OgISBD4Vs671Z
         7Ayg==
X-Gm-Message-State: AOAM53162DXTKLs3Mq6ihsntEDkEFrCnvzpeZoYl8HHBtrSR+MhC1QZz
        Ck2d7wOJ6YNezKb445k2p8o=
X-Google-Smtp-Source: ABdhPJxVHtYD8arD00VSDY3MnDWd8zC0J8U3SlvbSuK19dFg8fMlyRM3rWbyTCSQckDUorYp4gKVnA==
X-Received: by 2002:a17:90b:4d07:: with SMTP id mw7mr365017pjb.66.1632161441674;
        Mon, 20 Sep 2021 11:10:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q15sm15434500pfl.18.2021.09.20.11.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:10:41 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
 <20210920180240.tyi6v3e647rx7dkm@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
Date:   Mon, 20 Sep 2021 11:10:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920180240.tyi6v3e647rx7dkm@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 11:02 AM, Vladimir Oltean wrote:
> On Mon, Sep 20, 2021 at 10:46:31AM -0700, Florian Fainelli wrote:
>> On 9/20/21 10:40 AM, Vladimir Oltean wrote:
>>> On Mon, Sep 20, 2021 at 10:14:48AM -0700, Florian Fainelli wrote:
>>>> The SPROM is a piece of NVRAM that is intended to describe in a set of
>>>> key/value pairs various platform configuration details. There can be up
>>>> to 3 GMACs on the SoC which you can connect in a variety of ways towards
>>>> internal/external PHYs or internal/external Ethernet switches. The SPROM
>>>> is used to describe whether you connect to a regular PHY (not at PHY
>>>> address 30 decimal, so not the Broadcom pseudo-PHY) or an Ethernet
>>>> switch pseudo-PHY via MDIO.
>>>>
>>>> What appears to be missing here is that we should not be executing this
>>>> block of code for phyaddr == BGMAC_PHY_NOREGS because we will not have a
>>>> PHY device proper to begin with and this collides with registering the
>>>> b53_mdio driver.
>>>
>>> Who provisions the SPROM exactly? It still seems pretty broken to me
>>> that one of the GMACs has a bgmac->phyaddr pointing to a switch.
>>
>> The OEMs are typically responsible for that. It is not "broken" per-se,
>> and you will find additional key/value pairs that e.g.: describe the
>> initial switch configuration something like:
>>
>> vlan0ports="0 1 2 3 5t"
>> vlan1ports="4 5t"
>>
>> So this has been used as a dumping ground of "how I want the device to
>> be configured eventually". 0x1e/30 is sort of "universally" within
>> Broadcom's own universe that this designates an Ethernet switch
>> pseudo-PHY MDIO bus address, and we all know that nobody in their right
>> mind would design a Wi-Fi router with a discrete Ethernet switch that is
>> not from Broadcom, right?
>>
> 
> But even so, what's a "pseudo PHY" exactly? I think that's at the bottom
> of this issue. In the Linux device model, a device has a single driver.
> In this case, the same MDIO device either has a switch driver, if you
> accept it's a switch, or a PHY driver, if you accept it's a PHY.
> I said it's "broken" because the expectation seems to be that it's a switch,
> but it looks like it's treated otherwise. Simply put, the same device
> can't be both a switch and a PHY.

A pseudo-PHY is a device that can snoop and respond to MDIO bus
requests. I understand it cannot be both, just explaining to you how the
people at Broadcom have been seeing the world from their perspective.
Anything that is found at MDIO address 0x1e/30 is considered a MDIO
attached switch, that's all.

> 
> The issue is really in bcma_phy_connect. That is what force-binds the
> generic PHY driver. Since the bgmac-bcma driver does not support fixed
> links, it tries to make do the way it can. This will not work with DSA.

Yes, I understand that.

> 
>>> Special-casing the Broadcom switch seems not enough, the same thing
>>> could happen with a Marvell switch or others. How about looking up the
>>> device tree whether the bgmac->mii_bus' OF node has any child with a
>>> "reg" of bgmac->phyaddr, and if it does, whether of_mdiobus_child_is_phy
>>> actually returns true for it?
>>
>> We could do that, however I don't know whether this will break the
>> arch/mips/bcm47xx devices which are still in active use by the OpenWrt
>> community and for which there is no Device Tree (no technical
>> limitation, just no motivation since devices are EOL'd), but maybe out
>> of tree patches can be carried in the OpenWrt tree to revert anything
>> that upstream came up with.
> 
> By OpenWRT do you mean swconfig or actual DSA?

Yes, swconfig in that case with the b53 swconfig driver trying to
register as a PHY device.

> 
> I think Rafal is using device tree, so the check can be conditionally
> made based on the presence of an OF node corresponding to the MDIO bus.
> That would still work, unless the OpenWRT people want to use DSA without
> device tree too...
> 

All I am saying is that there is not really any need to come up with a
Device Tree-based solution since you can inspect the mdio_device and
find out whether it is an Ethernet PHY or a MDIO device proper, and that
ought to cover all cases that I can think of.
-- 
Florian
