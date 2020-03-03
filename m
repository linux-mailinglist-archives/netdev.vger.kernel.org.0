Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE1177677
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgCCM4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:56:02 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60911 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgCCM4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:56:01 -0500
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1j975Z-0007Jo-W8; Tue, 03 Mar 2020 13:55:58 +0100
Subject: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
To:     Christian Herber <christian.herber@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek Vasut <marex@denx.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>
References: <AM0PR04MB70412893CFD2F553107148FC86E40@AM0PR04MB7041.eurprd04.prod.outlook.com>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <2228b5de-89e3-d61a-4af9-8d1a8a5eb311@pengutronix.de>
Date:   Tue, 3 Mar 2020 13:55:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <AM0PR04MB70412893CFD2F553107148FC86E40@AM0PR04MB7041.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03.03.20 13:42, Christian Herber wrote:
>> On 03.03.2020 08:37, Oleksij Rempel wrote:
>>> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
>>> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
>>> configured in device tree by setting compatible =
>>> "ethernet-phy-id0180.dc81".
>>>
>>> PHY 1 has less suported registers and functionality. For current driver
>>> it will affect only the HWMON support.
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> ---
>>> drivers/net/phy/nxp-tja11xx.c | 43 +++++++++++++++++++++++++++++++++++
>>> 1 file changed, 43 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
>>> index b705d0bd798b..52090cfaa54e 100644
>>> --- a/drivers/net/phy/nxp-tja11xx.c
>>> +++ b/drivers/net/phy/nxp-tja11xx.c
>>> @@ -15,6 +15,7 @@
>>> #define PHY_ID_MASK                  0xfffffff0
>>> #define PHY_ID_TJA1100                       0x0180dc40
>>> #define PHY_ID_TJA1101                       0x0180dd00
>>> +#define PHY_ID_TJA1102                       0x0180dc80
>>>
>>> #define MII_ECTRL                    17
>>> #define MII_ECTRL_LINK_CONTROL               BIT(15)
>>> @@ -190,6 +191,7 @@ static int tja11xx_config_init(struct phy_device *phydev)
>>>               return ret;
>>>       break;
>>> case PHY_ID_TJA1101:
>>> +     case PHY_ID_TJA1102:
>>>       ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
>>>       if (ret)
>>>               return ret;
>>> @@ -337,6 +339,31 @@ static int tja11xx_probe(struct phy_device *phydev)
>>> if (!priv)
>>>       return -ENOMEM;
>>>
>>> +     /* Use the phyid to distinguish between port 0 and port 1 of the
>>> +      * TJA1102. Port 0 has a proper phyid, while port 1 reads 0.
>>> +      */
>>> +     if ((phydev->phy_id & PHY_ID_MASK) == PHY_ID_TJA1102) {
>>> +             int ret;
>>> +             u32 id;
>>> +
>>> +             ret = phy_read(phydev, MII_PHYSID1);
>>> +             if (ret < 0)
>>> +                     return ret;
>>> +
>>> +             id = ret;
>>> +             ret = phy_read(phydev, MII_PHYSID2);
>>> +             if (ret < 0)
>>> +                     return ret;
>>> +
>>> +             id |= ret << 16;
>>> +
>>> +             /* TJA1102 Port 1 has phyid 0 and doesn't support temperature
>>> +              * and undervoltage alarms.
>>> +              */
>>> +             if (id == 0)
>>> +                     return 0;
>>
>> I'm not sure I understand what you're doing here. The two ports of the chip
>> are separate PHY's on individual MDIO bus addresses?
>> Reading the PHY ID registers here seems to repeat what phylib did already
>> to populate phydev->phy_id. If port 1 has PHD ID 0 then the driver wouldn't
>> bind and tja11xx_probe() would never be called (see phy_bus_match)
>>
>>> +     }
>>> +
>>> priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
>>> if (!priv->hwmon_name)
>>>       return -ENOMEM;
>>> @@ -385,6 +412,21 @@ static struct phy_driver tja11xx_driver[] = {
>>>       .get_sset_count = tja11xx_get_sset_count,
>>>       .get_strings    = tja11xx_get_strings,
>>>       .get_stats      = tja11xx_get_stats,
>>> +     }, {
>>> +             PHY_ID_MATCH_MODEL(PHY_ID_TJA1102),
>>> +             .name           = "NXP TJA1102",
>>> +             .features       = PHY_BASIC_T1_FEATURES,
>>> +             .probe          = tja11xx_probe,
>>> +             .soft_reset     = tja11xx_soft_reset,
>>> +             .config_init    = tja11xx_config_init,
>>> +             .read_status    = tja11xx_read_status,
>>> +             .suspend        = genphy_suspend,
>>> +             .resume         = genphy_resume,
>>> +             .set_loopback   = genphy_loopback,
>>> +             /* Statistics */
>>> +             .get_sset_count = tja11xx_get_sset_count,
>>> +             .get_strings    = tja11xx_get_strings,
>>> +             .get_stats      = tja11xx_get_stats,
>>> }
>>> };
>>>
>>> @@ -393,6 +435,7 @@ module_phy_driver(tja11xx_driver);
>>> static struct mdio_device_id __maybe_unused tja11xx_tbl[] = {
>>> { PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
>>> { PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
>>> +     { PHY_ID_MATCH_MODEL(PHY_ID_TJA1102) },
>>> { }
>>> };
> 
> Hi Oleksij, Heiner, Marc,
> 
> You could also refer the solution implemented here as part of a TJA110x driver:
> https://source.codeaurora.org/external/autoivnsw/tja110x_linux_phydev/about/

OK, thank you!

Suddenly, the solution in this driver is not mainlainable. It may match on ther PHYs with 
PHYID == 0.

See this part of the code:
#define NXP_PHY_ID_TJA1102P1      (0x00000000U)
...
	, {
	.phy_id = NXP_PHY_ID_TJA1102P1,
	.name = "TJA1102_p1",
	.phy_id_mask = NXP_PHY_ID_MASK,


Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
