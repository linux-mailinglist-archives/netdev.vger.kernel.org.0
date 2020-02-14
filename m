Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA29E15F55B
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbgBNSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:33:00 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:51194 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730148AbgBNSdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:33:00 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01EIWiig111634;
        Fri, 14 Feb 2020 12:32:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581705164;
        bh=5i9D45FhrVPtE9Ly2aEutG8880Cy8/ap8IBe5jOglaA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=SxmKrcg9oZz/rBsExmfw6kX6UUglI0U8tmuVHuQNikrx0K7YDobqD0kdhxnCLUCly
         d5owR18bdbZTYBf7DAmOWA892zj3VRqQKZ5d+cozR2nkG9geRNc7qSEO3B5pQvzDbs
         vK7dSOLYoCUtykNgPh22zTfNK3nQhexu51TY3fBE=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01EIWicU034341
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Feb 2020 12:32:44 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 14
 Feb 2020 12:32:43 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 14 Feb 2020 12:32:43 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01EIWfkw001556;
        Fri, 14 Feb 2020 12:32:42 -0600
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
 <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
Date:   Fri, 14 Feb 2020 20:32:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/02/2020 00:01, Dan Murphy wrote:
> Florian
> 
> On 2/5/20 4:00 PM, Florian Fainelli wrote:
>> On 2/5/20 1:51 PM, Dan Murphy wrote:
>>> Heiner
>>>
>>> On 2/5/20 3:16 PM, Heiner Kallweit wrote:
>>>> On 04.02.2020 19:13, Dan Murphy wrote:
>>>>> Set the speed optimization bit on the DP83867 PHY.
>>>>> This feature can also be strapped on the 64 pin PHY devices
>>>>> but the 48 pin devices do not have the strap pin available to enable
>>>>> this feature in the hardware.  PHY team suggests to have this bit set.
>>>>>
>>>>> With this bit set the PHY will auto negotiate and report the link
>>>>> parameters in the PHYSTS register.  This register provides a single
>>>>> location within the register set for quick access to commonly accessed
>>>>> information.
>>>>>
>>>>> In this case when auto negotiation is on the PHY core reads the bits
>>>>> that have been configured or if auto negotiation is off the PHY core
>>>>> reads the BMCR register and sets the phydev parameters accordingly.
>>>>>
>>>>> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to
>>>>> accomodate a
>>>>> 4-wire cable.  If this should occur the PHYSTS register contains the
>>>>> current negotiated speed and duplex mode.
>>>>>
>>>>> In overriding the genphy_read_status the dp83867_read_status will do a
>>>>> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
>>>>> register is read and the phydev speed and duplex mode settings are
>>>>> updated.
>>>>>
>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>> ---
>>>>> v2 - Updated read status to call genphy_read_status first, added
>>>>> link_change
>>>>> callback to notify of speed change and use phy_set_bits -
>>>>> https://lore.kernel.org/patchwork/patch/1188348/
>>>>>
>>>> As stated in the first review, it would be appreciated if you implement
>>>> also the downshift tunable. This could be a separate patch in this
>>>> series.
>>>> Most of the implementation would be boilerplate code.
>>> I just don't have a requirement from our customer to make it adjustable
>>> so I did not want to add something extra.
>>>
>>> I can add in for v3.
>>>
>>>> And I have to admit that I'm not too happy with the term "speed
>>>> optimization".
>>>> This sounds like the PHY has some magic to establish a 1.2Gbps link.
>>>> Even though the vendor may call it this way in the datasheet, the
>>>> standard
>>>> term is "downshift". I'm fine with using "speed optimization" in
>>>> constants
>>>> to be in line with the datasheet. Just a comment in the code would be
>>>> helpful
>>>> that speed optimization is the vendor's term for downshift.
>>> Ack.  The data sheet actually says "Speed optimization, also known as
>>> link downshift"
>>>
>>> So I probably will just rename everything down shift.
>>>
>>>>>    drivers/net/phy/dp83867.c | 55 +++++++++++++++++++++++++++++++++++++++
>>>>>    1 file changed, 55 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>>>>> index 967f57ed0b65..6f86ca1ebb51 100644
>>>>> --- a/drivers/net/phy/dp83867.c
>>>>> +++ b/drivers/net/phy/dp83867.c
>>>>> @@ -21,6 +21,7 @@
>>>>>    #define DP83867_DEVADDR        0x1f
>>>>>      #define MII_DP83867_PHYCTRL    0x10
>>>>> +#define MII_DP83867_PHYSTS    0x11
>>>>>    #define MII_DP83867_MICR    0x12
>>>>>    #define MII_DP83867_ISR        0x13
>>>>>    #define DP83867_CFG2        0x14
>>>>> @@ -118,6 +119,15 @@
>>>>>    #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK    (0x1f << 8)
>>>>>    #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT    8
>>>>>    +/* PHY STS bits */
>>>>> +#define DP83867_PHYSTS_1000            BIT(15)
>>>>> +#define DP83867_PHYSTS_100            BIT(14)
>>>>> +#define DP83867_PHYSTS_DUPLEX            BIT(13)
>>>>> +#define DP83867_PHYSTS_LINK            BIT(10)
>>>>> +
>>>>> +/* CFG2 bits */
>>>>> +#define DP83867_SPEED_OPTIMIZED_EN        (BIT(8) | BIT(9))
>>>>> +
>>>>>    /* CFG3 bits */
>>>>>    #define DP83867_CFG3_INT_OE            BIT(7)
>>>>>    #define DP83867_CFG3_ROBUST_AUTO_MDIX        BIT(9)
>>>>> @@ -287,6 +297,43 @@ static int dp83867_config_intr(struct phy_device
>>>>> *phydev)
>>>>>        return phy_write(phydev, MII_DP83867_MICR, micr_status);
>>>>>    }
>>>>>    +static void dp83867_link_change_notify(struct phy_device *phydev)
>>>>> +{
>>>>> +    if (phydev->state != PHY_RUNNING)
>>>>> +        return;
>>>>> +
>>>>> +    if (phydev->speed == SPEED_100 || phydev->speed == SPEED_10)
>>>>> +        phydev_warn(phydev, "Downshift detected connection is
>>>>> %iMbps\n",
>>>>> +                phydev->speed);
>>>> The link partner may simply not advertise 1Gbps. How do you know that
>>>> a link speed of e.g. 100Mbps is caused by a downshift?
>>>> Some PHY's I've seen with this feature have a flag somewhere indicating
>>>> that downshift occurred. How about the PHY here?
>>> I don't see a register that gives us that status
>>>
>>> I will ask the hardware team if there is one.
>>>
>>> This is a 1Gbps PHY by default so if a slower connection is established
>>> due to faulty cabling or LP advertisement then this would be a down
>>> shift IMO.
>> With your current link_change_notify function it would not be possible
>> to know whether the PHY was connected to a link partner that advertised
>> only 10/100 and so 100 ended up being the link speed, or the link
>> partner was capable of 10/100/1000 and downshift reduced the link speed.
>>
>> If you cannot tell the difference from a register, it might be better to
>> simply omit that function then.
> 
> Yeah I thought it was a bit redundant and wonky to see in the log that the link established to xG/Mbps and then see another message saying the downshift occurred.

I think it's good idea to have this message as just wrong cable might be used.

But this notifier make no sense in it current form - it will produce noise in case of forced 100m/10M.

FYI. PHY sequence to update link:
phy_state_machine()
|-phy_check_link_status()
   |-phy_link_down/up()
     |- .phy_link_change()->phy_link_change()
	|-adjust_link() ----> netdev callback
|-phydev->drv->link_change_notify(phydev);

So, log output has to be done or in .read_status() or
some info has to be saved in .read_status() and then re-used in
.link_change_notify().

-- 
Best regards,
grygorii
