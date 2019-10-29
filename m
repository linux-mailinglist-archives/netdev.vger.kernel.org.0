Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CAAE911A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfJ2UzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:55:01 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:58365 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfJ2UzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 16:55:00 -0400
Received: from [100.68.212.125] (ip-109-40-129-141.web.vodafone.de [109.40.129.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D39A922E07;
        Tue, 29 Oct 2019 21:54:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572382496;
        bh=3aiIfyWXY1iPXO+4Ob07dVw4rPtBd4EDLCI8JulktDs=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=aXoVegOLM+oArB/yjNaGjvBEgwLi/VPUsPvYGNT3IyhfGbhKnd3q3U6HMSpEeUic8
         0f/ArgltNnU572xY57tcbA5F8A3/pPclA4t57/D/iTsqIx2pLCHAKwDYbxYHrUlJub
         LxNDK6prYzHW4s/96e+HrVB4UvkZjD0g9M2L9gho=
Date:   Tue, 29 Oct 2019 21:54:53 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <519d52d2-cd83-b544-591b-ca9d9bb16dfa@gmail.com>
References: <20191029174819.3502-1-michael@walle.cc> <519d52d2-cd83-b544-591b-ca9d9bb16dfa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/3] net: phy: initialize PHYs via device tree properties
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
From:   Michael Walle <michael@walle.cc>
Message-ID: <4B4A80A7-05C8-441A-B224-7CC01E3D8C30@walle.cc>
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 29=2E Oktober 2019 18:59:07 MEZ schrieb Florian Fainelli <f=2Efainelli@g=
mail=2Ecom>:
>On 10/29/19 10:48 AM, Michael Walle wrote:
>> I was trying to configure the Atheros PHY for my board=2E There are
>fixups
>> all over the place, for example to enable the 125MHz clock output in
>almost
>> any i=2EMX architecture=2E Instead of adding another fixup in
>architecture
>> specific code, try to provide a generic way to init the PHY
>registers=2E
>>=20
>> This patch series tries to pick up the "broadcom,reg-init" and
>> "marvell,reg-init" device tree properties idea and make it a more
>generic
>> "reg-init" which is handled by phy_device instead of a particular phy
>> driver=2E
>
>These two examples are actually quite bad and were symptomatic of a few
>things at the time:
>
>- rush to get a specific feature/device supported without thinking
>about
>the big picture
>- lack of appropriate review on the Device Tree bindings
>
>Fortunately, the last item is now not happening anymore=2E
>
>The problem with letting that approach go through is that the Device
>Tree can now hold a configuration policy which is passed through as-is
>from DT to the PHY device, this is bad on so many different levels,
>starting with abstraction=2E

I see=2E

>If all you need is to enable a particular clock, introduce device
>specific properties that describe the hardware, and make the necessary
>change to the local driver that needs to act on those=2E You can always
>define a more generic scope property if you see a recurring pattern=2E

Could you have a quick look at the following patch I made for u-boot, whic=
h adds a binding for the Atheros PHY=2E If that is the right direction=2E Y=
eah, I should have made it first to Linux to get some feedback on the bindi=
ng :p

https://patchwork=2Eozlabs=2Eorg/patch/1184516/

I'd then prepare another patch for Linux based on your suggestions=2E=20

-michael=20

>
>So just to be clear on the current approach: NACK=2E
>
>>=20
>> Michael Walle (3):
>>   dt-bindings: net: phy: Add reg-init property
>>   net: phy: export __phy_{read|write}_page
>>   net: phy: Use device tree properties to initialize any PHYs
>>=20
>>  =2E=2E=2E/devicetree/bindings/net/ethernet-phy=2Eyaml | 31 ++++++
>>  MAINTAINERS                                   |  1 +
>>  drivers/net/phy/phy-core=2Ec                    | 24 ++++-
>>  drivers/net/phy/phy_device=2Ec                  | 97
>++++++++++++++++++-
>>  include/dt-bindings/net/phy=2Eh                 | 18 ++++
>>  include/linux/phy=2Eh                           |  2 +
>>  6 files changed, 170 insertions(+), 3 deletions(-)
>>  create mode 100644 include/dt-bindings/net/phy=2Eh
>>=20
>> Cc: Andrew Lunn <andrew@lunn=2Ech>
>> Cc: Florian Fainelli <f=2Efainelli@gmail=2Ecom>
>> Cc: Heiner Kallweit <hkallweit1@gmail=2Ecom>
>> Cc: "David S=2E Miller" <davem@davemloft=2Enet>
>> Cc: Rob Herring <robh+dt@kernel=2Eorg>
>> Cc: Mark Rutland <mark=2Erutland@arm=2Ecom>
>>=20

Hi Florian, 
