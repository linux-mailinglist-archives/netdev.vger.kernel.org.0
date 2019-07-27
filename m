Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A9877C09
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfG0V0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:26:55 -0400
Received: from mx.0dd.nl ([5.2.79.48]:34662 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfG0V0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 17:26:55 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id E77FC5FCC5;
        Sat, 27 Jul 2019 23:26:51 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="jsFd+ABS";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id A197B1D2D645;
        Sat, 27 Jul 2019 23:26:51 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com A197B1D2D645
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564262811;
        bh=SFR3bUVvIq6pX0wkGHe6MZLI5+Iv395Kikc+l/TDe6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jsFd+ABSum56iaZQcEk9e1dqBnhKVibiNGz4Chwm09e9/lBqqn/e8SugXWaRRJo6U
         pozgPieVCYa55VZHuVF91iMGi8v8gAg8ALChLkx1jHwqQDu9cPBEpbZxGa9atCM9R3
         Ss1R5D/uKHZXqeVNMrLYTP0TtpQpcrD7G6W3ZdlFqp1KdAki5SUXqJJSWs2lHr81tY
         2BJ7CN6SFjvJdL9PSvnOyzx+PhAaNDP9gkETOmV4ujz1WGQp26lenmBByahoO9FAXS
         WoIPHmghIaX7QejI4r0qSkUNmX58WP7+dicye1VXj/2qFdYqm6Nmf8m1nYjH/HT84l
         FhK11V2npDkeg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 27 Jul 2019 21:26:51 +0000
Date:   Sat, 27 Jul 2019 21:26:51 +0000
Message-ID: <20190727212651.Horde.WrWPsZ4JpBQzJT2cFdGafCP@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        john@phrozen.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mt7530: Add support for port 5
References: <20190724192549.24615-1-opensource@vdorst.com>
 <20190724192549.24615-4-opensource@vdorst.com>
 <20190727185315.GU1330@shell.armlinux.org.uk>
In-Reply-To: <20190727185315.GU1330@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> On Wed, Jul 24, 2019 at 09:25:49PM +0200, René van Dorst wrote:
>> Adding support for port 5.
>>
>> Port 5 can muxed/interface to:
>> - internal 5th GMAC of the switch; can be used as 2nd CPU port or as
>>   extra port with an external phy for a 6th ethernet port.
>> - internal PHY of port 0 or 4; Used in most applications so that port 0
>>   or 4 is the WAN port and interfaces with the 2nd GMAC of the SOC.
>
> ...
>
>> @@ -1381,15 +1506,19 @@ static void mt7530_phylink_validate(struct  
>> dsa_switch *ds, int port,
>>  	phylink_set_port_modes(mask);
>>  	phylink_set(mask, Autoneg);
>>
>> -	if (state->interface != PHY_INTERFACE_MODE_TRGMII) {
>> +	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
>> +		phylink_set(mask, 1000baseT_Full);
>> +	} else {
>>  		phylink_set(mask, 10baseT_Half);
>>  		phylink_set(mask, 10baseT_Full);
>>  		phylink_set(mask, 100baseT_Half);
>>  		phylink_set(mask, 100baseT_Full);
>> -		phylink_set(mask, 1000baseT_Half);
>> -	}
>>
>> -	phylink_set(mask, 1000baseT_Full);
>> +		if (state->interface != PHY_INTERFACE_MODE_MII) {
>> +			phylink_set(mask, 1000baseT_Half);
>> +			phylink_set(mask, 1000baseT_Full);
>> +		}
>> +	}
>

Hi Russell,

Thanks for your review and many useful comments and explanations.

> As port 5 could use an external PHY, and it supports gigabit speeds,
> consider that the PHY may provide not only copper but also fiber
> connectivity, so port 5 should probably also have 1000baseX modes
> too, which would allow such a PHY to bridge the switch to fiber.

I shall add the 1000baseX modes.

My device, Ubiquiti EdgeRouter X SFP, has this setup.
Port 5 is connected to a at8033 phy which acts as a RGMII-SerDes converter for
the SFP cage. According to the datasheet it only support 100BASE-FX and
1000BASE-X. With bootstrap resistors the PHY is put in RGMII-SerDes 1000BASE-X
mode.

The problem I had is that the current mainline driver doesn't support  
this mode
so I had to hack it in myself [0][1]. I probably doing the wrong thing with my
phy driver. Driver works for me, it detects a link and sets-up a 1gbit link.
So I can test port 5. But the driver may report all the wrong values to
PHYLIB/PHYLINK. But now that I learned more about it I can revise the driver.


By reading your previous emails, my setup could official not support the
FiberStore SFP-GB-GE-T module, because it requests a SGMII interface.
But my PHY only supports 1000BaseX and my code currently doesn't error out.

dmesg output of this module:
[    3.382637] sfp sfp_lan5: module FiberStore       SFP-GB-GE-T       
rev B    sn <snip>      dc 19-12-17
[    3.402048] sfp sfp_lan5:   unknown/unspecified connector, encoding  
8b10b, nominal bitrate 1.3Gbps +0% -0%
[    3.421268] sfp sfp_lan5:   1000BaseSX- 1000BaseLX- 1000BaseCX-  
1000BaseT+ 100BaseLX- 100BaseFX- BaseBX10- BasePX-
[    3.441867] sfp sfp_lan5:   10GBaseSR- 10GBaseLR- 10GBaseLRM- 10GBaseER-
[    3.455208] sfp sfp_lan5:   Copper length: 100m
[    3.464225] sfp sfp_lan5:   Options: txdisable
[    3.473066] sfp sfp_lan5:   Diagnostics:
[    3.481034] sfp sfp_lan5: Unknown/unsupported extended compliance  
code: 0x01
[    3.495069] Atheros 8031 ethernet mdio-bus:07: SFP interface sgmii

What is the best way to do it in case of SGMII interface request?
Return that we don't support SGMII or report that we only support 1  
mode and no
auto-negotiation?

Greats,

René

>

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up


[0]:  
https://github.com/vDorst/linux-1/commit/dad5d6ec65cfa99c204e9756b3fc234071709292
[1]:  
https://github.com/vDorst/linux-1/commit/a3aa74e84796604ab8619cfaf1c299c115a8736f


