Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC42568BE
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 17:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgH2Phd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgH2Phc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 11:37:32 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47C1C061236
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 08:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K/4tXzmdhZbCmrip3BADI1zN08cg9haoPt59LPERGN8=; b=Ndjn/SdSPimoydJAUc0qO3pDb3
        gfWPJNcf/vTuAPx0xF8Kx3fqsiX+FMuHr3D/rewmOBCX3BukKbry7BOBU19ZNYoLYU0G5Fr8EmHby
        rVaLZj2MDhmRSFi51yBXo7GmW5ElXl3hxSO5veg2+yYf54LTqMv9Ye5x/sQi7S79rLENf5rz33W7M
        4RDPMPTdrc9PRqVeWE+0kOZfQeq2WCV+Rx/7MMNX399YjEbhCBvrgOzZsfjSwU59m1QjHgrcSNHE6
        5im6mkWa/odSB2CoYTH0qFXaCfcXG4jURr1Yu4p92XXrVlEb+HcOgjff8/RAxYq6mo8b/mK2gEzfs
        D35vQBVA==;
Received: from [205.201.55.81] (helo=[172.20.10.2])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kC2v0-008c25-GW; Sat, 29 Aug 2020 17:37:26 +0200
Subject: Re: drivers/of/of_mdio.c needs a small modification
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
 <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
 <113503c8-a871-1dc0-daea-48631e1a436d@arf.net.pl>
 <20200829151553.GB2912863@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <76f88763-54b0-eb03-3bc8-3e5022173163@arf.net.pl>
Date:   Sat, 29 Aug 2020 17:37:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829151553.GB2912863@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2020-08-29 o 17:15, Andrew Lunn pisze:
>> The driver would be able to add the new PHYs to the shared MDIO bus by
>> calling of_mdiobus_register_children. Then the device tree looks like this,
>> which is more reasonable in my opinion:
>>
>> &fec2 {
>> (...)
>>      mdio {
>>          (phy for fec2 here)
>>      };
>> (...)
>> };
>>
>> &fec1 {
>> (...)
>>      mdio {
>>          (phy for fec1 here)
>>      };
>> (...)
>> };
> DT describes hardware, and the topology of the hardware. The hardware really is:
>
> ethernet1@83fec000 {
> 	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
> 	reg = <0x83fec000 0x4000>;
> 	interrupts = <87>;
> 	phy-mode = "mii";
> 	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
> 	local-mac-address = [00 04 9F 01 1B B9];
> 	phy-supply = <&reg_fec_supply>;
> 	phy-handle = <&ethphy1>;
> 	mdio {
> 	        clock-frequency = <5000000>;
> 		ethphy1: ethernet-phy@1 {
> 			compatible = "ethernet-phy-ieee802.3-c22";
> 			reg = <1>;
> 			max-speed = <100>;
> 		};
> 		ethphy2: ethernet-phy@2 {
> 			compatible = "ethernet-phy-ieee802.3-c22";
> 			reg = <2>;
> 			max-speed = <100>;
> 		};
> 	};
> };
>
> ethernet2@84fec000 {
> 	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
> 	reg = <0x83fec000 0x4000>;
> 	interrupts = <87>;
> 	phy-mode = "mii";
> 	phy-reset-gpios = <&gpio2 15 GPIO_ACTIVE_LOW>; /* GPIO2_15 */
> 	local-mac-address = [00 04 9F 01 1B BA];
> 	phy-supply = <&reg_fec_supply>;
> 	phy-handle = <&ethphy2>;
> };

This is true assuming that the PHYs are always and forever connected to 
one specific MDIO bus. This is probably reasonable. Although, in i.MX 
the MDIO bus of FEC1 and FEC2 shares the pins. So with this "split" 
description one can just comment out FEC2 and still enjoy operational 
ethernet (FEC1 + its PHY). This may be simpler for hardware guys, like 
me, who don't have that much experience with device trees. But yes, that 
doesn't necessarily mean it's the good way to go.

> Also look at drivers/net/phy/micrel.c. It has code to look up a FEC
> clock and use it. But that code assumes the PHY responds to MDIO reads
> when the clock is not ticking. It sounds like your PHY does not?
> Please double check that. If it does not, you need to add clock code
> to the PHY core. Florians patchset will help with that.
>
I'm sure of that - LAN8720A needs to have the clock from FEC or external 
generator to be able to talk over MDIO.

I can see that one way or another, it's still some modification of the 
source code. You know the ropes, you decide if and which one makes sense.

Best regards,
Adam

