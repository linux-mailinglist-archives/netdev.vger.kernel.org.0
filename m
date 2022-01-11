Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC21248A89B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348563AbiAKHos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 02:44:48 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:52298 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbiAKHos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 02:44:48 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1n7Bpn-000Ch2-Ai
        for netdev@vger.kernel.org; Tue, 11 Jan 2022 08:44:47 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1n7Bpm-000GY2-V5
        for netdev@vger.kernel.org; Tue, 11 Jan 2022 08:44:46 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id B5A2C24004B
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:44:46 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 77943240049;
        Tue, 11 Jan 2022 08:44:46 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id F0FF9206D4;
        Tue, 11 Jan 2022 08:44:45 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 11 Jan 2022 08:44:45 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
Message-ID: <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1641887087-00000DA7-3C3544AD/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-11 00:12, Tim Harvey wrote:
> On Mon, Jul 19, 2021 at 2:07 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> This adds the possibility to configure the RGMII RX/TX clock skew via
>> devicetree.
>> 
>> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and 
>> add
>> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
>> devicetree.
>> 
>> Furthermore, a warning is now issued if the phy mode is configured to
>> "rgmii" and an internal delay is set in the phy (e.g. by 
>> pin-strapping),
>> as in the dp83867 driver.
>> 
>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
>> ---
>> 
>> Changes to v5:
>> o remove #if IS_ENABLED(CONFIG_OF_MDIO) check
>> o rename new function to xway_gphy_rgmii_init()
>> 
>> Changes to v4:
>> o Fix Alignment to match open parenthesis
>> 
>> Changes to v3:
>> o Fix typo in commit message
>> o use FIELD_PREP() and FIELD_GET() macros
>> o further code cleanups
>> o always mask rxskew AND txskew value in the register value
>> 
>> Changes to v2:
>> o Fix missing whitespace in warning.
>> 
>> Changes to v1:
>> o code cleanup and use phy_modify().
>> o use default of 2.0ns if delay property is absent instead of 
>> returning
>>   an error.
>> 
>> ---
>>  drivers/net/phy/intel-xway.c | 78 
>> ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 78 insertions(+)
>> 
>> diff --git a/drivers/net/phy/intel-xway.c 
>> b/drivers/net/phy/intel-xway.c
>> index d453ec016168..fd7da2eeb963 100644
>> --- a/drivers/net/phy/intel-xway.c
>> +++ b/drivers/net/phy/intel-xway.c
>> @@ -8,11 +8,16 @@
>>  #include <linux/module.h>
>>  #include <linux/phy.h>
>>  #include <linux/of.h>
>> +#include <linux/bitfield.h>
>> 
>> +#define XWAY_MDIO_MIICTRL              0x17    /* mii control */
>>  #define XWAY_MDIO_IMASK                        0x19    /* interrupt 
>> mask */
>>  #define XWAY_MDIO_ISTAT                        0x1A    /* interrupt 
>> status */
>>  #define XWAY_MDIO_LED                  0x1B    /* led control */
>> 
>> +#define XWAY_MDIO_MIICTRL_RXSKEW_MASK  GENMASK(14, 12)
>> +#define XWAY_MDIO_MIICTRL_TXSKEW_MASK  GENMASK(10, 8)
>> +
>>  /* bit 15:12 are reserved */
>>  #define XWAY_MDIO_LED_LED3_EN          BIT(11) /* Enable the 
>> integrated function of LED3 */
>>  #define XWAY_MDIO_LED_LED2_EN          BIT(10) /* Enable the 
>> integrated function of LED2 */
>> @@ -157,6 +162,75 @@
>>  #define PHY_ID_PHY11G_VR9_1_2          0xD565A409
>>  #define PHY_ID_PHY22F_VR9_1_2          0xD565A419
>> 
>> +static const int xway_internal_delay[] = {0, 500, 1000, 1500, 2000, 
>> 2500,
>> +                                        3000, 3500};
>> +
>> +static int xway_gphy_rgmii_init(struct phy_device *phydev)
>> +{
>> +       struct device *dev = &phydev->mdio.dev;
>> +       unsigned int delay_size = ARRAY_SIZE(xway_internal_delay);
>> +       s32 int_delay;
>> +       int val = 0;
>> +
>> +       if (!phy_interface_is_rgmii(phydev))
>> +               return 0;
>> +
>> +       /* Existing behavior was to use default pin strapping delay in 
>> rgmii
>> +        * mode, but rgmii should have meant no delay.  Warn existing 
>> users,
>> +        * but do not change anything at the moment.
>> +        */
>> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
>> +               u16 txskew, rxskew;
>> +
>> +               val = phy_read(phydev, XWAY_MDIO_MIICTRL);
>> +               if (val < 0)
>> +                       return val;
>> +
>> +               txskew = FIELD_GET(XWAY_MDIO_MIICTRL_TXSKEW_MASK, 
>> val);
>> +               rxskew = FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK, 
>> val);
>> +
>> +               if (txskew > 0 || rxskew > 0)
>> +                       phydev_warn(phydev,
>> +                                   "PHY has delays (e.g. via pin 
>> strapping), but phy-mode = 'rgmii'\n"
>> +                                   "Should be 'rgmii-id' to use 
>> internal delays txskew:%d ps rxskew:%d ps\n",
>> +                                   xway_internal_delay[txskew],
>> +                                   xway_internal_delay[rxskew]);
>> +               return 0;
>> +       }
>> +
>> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
>> +               int_delay = phy_get_internal_delay(phydev, dev,
>> +                                                  
>> xway_internal_delay,
>> +                                                  delay_size, true);
>> +
>> +               if (int_delay < 0) {
>> +                       phydev_warn(phydev, "rx-internal-delay-ps is 
>> missing, use default of 2.0 ns\n");
>> +                       int_delay = 4; /* 2000 ps */
>> +               }
>> +
>> +               val |= FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK, 
>> int_delay);
>> +       }
>> +
>> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
>> +               int_delay = phy_get_internal_delay(phydev, dev,
>> +                                                  
>> xway_internal_delay,
>> +                                                  delay_size, false);
>> +
>> +               if (int_delay < 0) {
>> +                       phydev_warn(phydev, "tx-internal-delay-ps is 
>> missing, use default of 2.0 ns\n");
>> +                       int_delay = 4; /* 2000 ps */
>> +               }
>> +
>> +               val |= FIELD_PREP(XWAY_MDIO_MIICTRL_TXSKEW_MASK, 
>> int_delay);
>> +       }
>> +
>> +       return phy_modify(phydev, XWAY_MDIO_MIICTRL,
>> +                         XWAY_MDIO_MIICTRL_RXSKEW_MASK |
>> +                         XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
>> +}
>> +
>>  static int xway_gphy_config_init(struct phy_device *phydev)
>>  {
>>         int err;
>> @@ -204,6 +278,10 @@ static int xway_gphy_config_init(struct 
>> phy_device *phydev)
>>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2H, ledxh);
>>         phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LED2L, ledxl);
>> 
>> +       err = xway_gphy_rgmii_init(phydev);
>> +       if (err)
>> +               return err;
>> +
>>         return 0;
>>  }
>> 
>> --
>> 2.20.1
>> 
> 
> Martin,
> 
> I've got some boards with the GPY111 phy on them and I'm finding that
> modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
> do a soft reset (BCMR_RESET) first. I don't see anything in the
> datasheet which specifies this to be the case so I'm interested it
> what you have found. Are you sure adjusting the skews like this
> without a soft (or hard pin based) reset actually works?
> 
> Best regards,
> 
> Tim

Hello Tim,

yes, you are right. It is not applied immediately. The link needs to be
toggled to get this settings active. But my experience shows that this
would be done in the further boot process anyway e.g. by restarting the
autonegotiation etc.

Regards,
Martin
