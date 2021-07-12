Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B993C441B
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 08:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhGLGQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 02:16:54 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:42757 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhGLGQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 02:16:54 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m2pCR-000P9f-Dr; Mon, 12 Jul 2021 08:13:51 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1m2pCQ-000GZR-9g; Mon, 12 Jul 2021 08:13:50 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id D9BFD240041;
        Mon, 12 Jul 2021 08:13:49 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 376CF240040;
        Mon, 12 Jul 2021 08:13:49 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 62B242029C;
        Mon, 12 Jul 2021 08:13:48 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 12 Jul 2021 08:13:48 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <CAFBinCCw9+oCV==1DrNFU6Lu02h3OyZu9wM=78RKGMCZU6ObEA@mail.gmail.com>
References: <20210709164216.18561-1-ms@dev.tdt.de>
 <CAFBinCCw9+oCV==1DrNFU6Lu02h3OyZu9wM=78RKGMCZU6ObEA@mail.gmail.com>
Message-ID: <fcb3203ea82d1180a6e471f22e39e817@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1626070431-000012BD-2E8A553B/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-09 20:31, Martin Blumenstingl wrote:
> Hi Martin,
> 
> overall this is looking good.
> A few comments below - I think none of them is a "must change" in my 
> opinion.
> 
> On Fri, Jul 9, 2021 at 6:42 PM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> This adds the posibility to configure the RGMII RX/TX clock skew via
> typo: posibility -> possibility
> 

Thanks. I'll fix that.

> [...]
>> +#define XWAY_MDIO_MIICTRL_RXSKEW_MASK  GENMASK(14, 12)
>> +#define XWAY_MDIO_MIICTRL_RXSKEW_SHIFT 12
> if you use
> - FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK, rxskew); (as for example 
> [0] does)
> - and FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK, val);
> below then you can drop the _SHIFT #define
> this is purely cosmetic though, so nothing which blocks this from being 
> merged
> 
>> +#define XWAY_MDIO_MIICTRL_TXSKEW_MASK  GENMASK(10, 8)
>> +#define XWAY_MDIO_MIICTRL_TXSKEW_SHIFT 8
> same as above
> 

Thanks for the hint. I'll switch to the FIELD_... macros.

> [...]
>> +#if IS_ENABLED(CONFIG_OF_MDIO)
> is there any particular reason why we need to guard this with 
> CONFIG_OF_MDIO?
> The dp83822 driver does not use this #if either (as far as I
> understand at least)
> 

It makes no sense to retrieve properties from the device tree if we are
compiling for a target that does not support a device tree.
At least that is my understanding of this condition.

> [...]
>> +static int xway_gphy_of_reg_init(struct phy_device *phydev)
>> +{
>> +       struct device *dev = &phydev->mdio.dev;
>> +       int delay_size = ARRAY_SIZE(xway_internal_delay);
> Some people in the kernel community are working on automatically
> detecting and fixing signedness issues.
> I am not sure if they would find this at some point suggesting that it
> can be an "unsigned int".
> 

OK, I'll change that.

>> +       s32 rx_int_delay;
>> +       s32 tx_int_delay;
> xway_gphy14_config_aneg() below defines two variables in one line, so
> to be consistent this would be:
>     s32 rx_int_delay, tx_int_delay;
> another option is to just re-use one "int_delay" variable (as it seems
> that they're both used in different code-paths).
> 

I'll switch to use one "int_delay".

>> +       u16 mask = 0;
> I think this should be dropped and the phy_modify() call below should 
> read:
>     return phy_modify(phydev, XWAY_MDIO_MIICTRL,
>                                   XWAY_MDIO_MIICTRL_RXSKEW_MASK |
>                                   XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
> For rgmii-txid the RX delay might be provided by the MAC or PCB trace
> length so the PHY should not add any RX delay.
> Similarly for rgmii-rxid the TX delay might be provided by the MAC or
> PCB trace length so the PHY should not add any TX delay.
> That means we always need to mask the RX and TX skew bits, regardless
> of what we're setting later on (as phy_modify is only called for one
> of: rgmii-id, rgmii-txid, rgmii-rxid).
> 

Yes, you are right. I'll change that as suggested.

> [...]
>> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
>> +               rx_int_delay = phy_get_internal_delay(phydev, dev,
>> +                                                     
>> &xway_internal_delay[0],
> I think above line can be simplified as:
>     xway_internal_delay,

I've copied that from dp83869.c, but yes, I can change it.


> 
> [...]
>> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
>> +               tx_int_delay = phy_get_internal_delay(phydev, dev,
>> +                                                     
>> &xway_internal_delay[0],
> same as above
> 

dito.

> 
> Best regards,
> Martin
> 
> 
> [0] 
> https://elixir.bootlin.com/linux/v5.13/source/drivers/net/phy/dp83867.c#L438
