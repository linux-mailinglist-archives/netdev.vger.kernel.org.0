Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA840264BFB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIJR4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:56:14 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:34026 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgIJRyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:54:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AHsbT9018071;
        Thu, 10 Sep 2020 12:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599760477;
        bh=8VF0Oh1yZo2QlXy6xBN4Gt3CcNyVN/I/9Gy0UvsoIXU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=UgYZ5CSL624P7uM0B+sWwneSViI7gMKHxrCkFCnOwxcSz52zz8TEh+LaomP82bCC2
         hpelQPhIYMPWrXsEuHBr/949V/0o++fCTww3UbIDKZR94+TgOSIUO3ODcoxNVXmJrH
         BgGXL4pP8yugGAdDgGzYoLrBV6iXyDNNT6BZuKXw=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AHsbb9087262
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 12:54:37 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 12:54:37 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 12:54:37 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AHsaNs000740;
        Thu, 10 Sep 2020 12:54:36 -0500
Subject: Re: [PATCH net-next v3 1/3] net: dp83869: Add ability to advertise
 Fiber connection
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-2-dmurphy@ti.com>
 <20200905111755.4bd874b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907142911.GT3112546@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <aea8db25-88a9-d8d2-1a26-ecb81dbeb2b5@ti.com>
Date:   Thu, 10 Sep 2020 12:54:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907142911.GT3112546@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 9/7/20 9:29 AM, Andrew Lunn wrote:
> On Sat, Sep 05, 2020 at 11:17:55AM -0700, Jakub Kicinski wrote:
>> On Thu, 3 Sep 2020 06:42:57 -0500 Dan Murphy wrote:
>>> Add the ability to advertise the Fiber connection if the strap or the
>>> op-mode is configured for 100Base-FX.
>>>
>>> Auto negotiation is not supported on this PHY when in fiber mode.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> Some comments, I'm not very phy-knowledgeable so bear with me
>> (hopefully PHY maintainers can correct me, too).
>>
>>> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
>>> index 58103152c601..48a68474f89c 100644
>>> --- a/drivers/net/phy/dp83869.c
>>> +++ b/drivers/net/phy/dp83869.c
>>> @@ -52,6 +52,11 @@
>>>   					 BMCR_FULLDPLX | \
>>>   					 BMCR_SPEED1000)
>>>   
>>> +#define MII_DP83869_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
>>> +					ADVERTISED_FIBRE | ADVERTISED_BNC |  \
>> I'm not actually sure myself what the semantics of port type advertise
>> bits are, but if this is fiber why advertise TP and do you really have
>> BNC connectors? :S
> Hi Jakub
>
> Normally, we start with a base of ETHTOOL_LINK_MODE_TP_BIT,
> ETHTOOL_LINK_MODE_MII_BIT and then use genphy_read_abilities() to read
> the standard registers in the PHY to determine what the PHY
> supports. The PHY driver has the ability of provide its own function
> to get the supported features, which is happening here. As far as i
> remember, there is no standard way to indicate a PHY is doing Fibre,
> not copper.
>
> I agree that TP and BMC make no sense here, since my understanding is
> that the device only supports Fibre when strapped for Fibre. It cannot
> swap to TP, and it has been at least 20 years since i last had a BNC
> cable in my hands.
>
> In this context, i've no idea what MII means.

I will remove the TP and BNC.


>
>>> +					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
>>> +					ADVERTISED_100baseT_Full)
>> You say 100Base-FX, yet you advertise 100Base-T?
> 100Base-FX does not actually exist in ADVERTISED_X form. I guess this
> is historical. It was not widely supported, the broadcom PHYs appear
> to support it, but not much else. We were also running out of bits to
> represent these ADVERTISED_X values. Now that we have changed to linux
> bitmaps and have unlimited number of bits, it makes sense to add it.

The note in the ethtool.h says

     /* Last allowed bit for __ETHTOOL_LINK_MODE_LEGACY_MASK is bit
      * 31. Please do NOT define any SUPPORTED_* or ADVERTISED_*
      * macro for bits > 31. The only way to use indices > 31 is to
      * use the new ETHTOOL_GLINKSETTINGS/ETHTOOL_SLINKSETTINGS API.
      */

Which was added by Heiner

I guess I would prefer to add this in a separate patchset once I figure 
out how the ETHTOOL_GLINKSETTINGS/ETHTOOL_SLINKSETTINGS API works

>
>>> @@ -383,7 +389,37 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>>>   
>>>   		break;
>>>   	case DP83869_RGMII_1000_BASE:
>>> +		break;
>>>   	case DP83869_RGMII_100_BASE:
>>> +		/* Only allow advertising what this PHY supports */
>>> +		linkmode_and(phydev->advertising, phydev->advertising,
>>> +			     phydev->supported);
>>> +
>>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>>> +				 phydev->supported);
>>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
>>> +				 phydev->advertising);
>>> +
>>> +		/* Auto neg is not supported in fiber mode */
>>> +		bmcr = phy_read(phydev, MII_BMCR);
>>> +		if (bmcr < 0)
>>> +			return bmcr;
>>> +
>>> +		phydev->autoneg = AUTONEG_DISABLE;
>>> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
>>> +				   phydev->supported);
>>> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
>>> +				   phydev->advertising);
>>> +
>>> +		if (bmcr & BMCR_ANENABLE) {
>>> +			ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
>>> +			if (ret < 0)
>>> +				return ret;
>>> +		}
>>> +
>>> +		phy_modify_changed(phydev, MII_ADVERTISE,
>>> +				   MII_DP83869_FIBER_ADVERTISE,
>>> +				   MII_DP83869_FIBER_ADVERTISE);
>> This only accesses standard registers, should it perhaps be a helper in
>> the kernel's phy code?
> I suspect the PHY is not following the standard when strapped to
> fibre.

No its a bit wonky in that respect.

Dan

