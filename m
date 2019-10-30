Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E230DEA7F2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfJ3X7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:59:54 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:46707 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfJ3X7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:59:54 -0400
Received: from [IPv6:2a02:810c:c200:2e91:e1c6:7ce1:572b:20f1] (unknown [IPv6:2a02:810c:c200:2e91:e1c6:7ce1:572b:20f1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2F79322178;
        Thu, 31 Oct 2019 00:59:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572479991;
        bh=nyCgt3JAYCTAmuaDgWRZlSISFODs2SBRwtJP3qM2AS4=;
        h=Date:In-Reply-To:References:Subject:To:From:From;
        b=m0131NIxrKYoPZTT3CTzXx9dNy4/fry36PrcvnKwSVg5c57K1BgW+HJ/MwuaoarqT
         ANH562mEYphmzK8vLsTSKsr4m/1LLy37RXggFGFfWB69+AXsd5aYVzHbWcr6swnJOl
         dsZZmfuv2v6GO5VMuRQFOdI9JlbjgozugUIBTMJE=
Date:   Thu, 31 Oct 2019 00:59:49 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <754a493b-a557-c369-96e1-6701ba5d5a30@gmail.com>
References: <20191030224251.21578-1-michael@walle.cc> <20191030224251.21578-4-michael@walle.cc> <754a493b-a557-c369-96e1-6701ba5d5a30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
From:   Michael Walle <michael@walle.cc>
Message-ID: <B3B13FB8-42D9-42F9-8106-536F574FA35B@walle.cc>
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 31=2E Oktober 2019 00:28:02 MEZ schrieb Florian Fainelli <f=2Efainelli@g=
mail=2Ecom>:
>On 10/30/19 3:42 PM, Michael Walle wrote:
>> Add support for configuring the CLK_25M pin as well as the RGMII I/O
>> voltage by the device tree=2E
>>=20
>> Signed-off-by: Michael Walle <michael@walle=2Ecc>
>> ---
>>  drivers/net/phy/at803x=2Ec | 156
>++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 154 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/net/phy/at803x=2Ec b/drivers/net/phy/at803x=2Ec
>> index 1eb5d4fb8925=2E=2E32be4c72cf4b 100644
>> --- a/drivers/net/phy/at803x=2Ec
>> +++ b/drivers/net/phy/at803x=2Ec
>> @@ -13,7 +13,9 @@
>>  #include <linux/netdevice=2Eh>
>>  #include <linux/etherdevice=2Eh>
>>  #include <linux/of_gpio=2Eh>
>> +#include <linux/bitfield=2Eh>
>>  #include <linux/gpio/consumer=2Eh>
>> +#include <dt-bindings/net/atheros-at803x=2Eh>
>> =20
>>  #define AT803X_SPECIFIC_STATUS			0x11
>>  #define AT803X_SS_SPEED_MASK			(3 << 14)
>> @@ -62,6 +64,37 @@
>>  #define AT803X_DEBUG_REG_5			0x05
>>  #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
>> =20
>> +#define AT803X_DEBUG_REG_1F			0x1F
>> +#define AT803X_DEBUG_PLL_ON			BIT(2)
>> +#define AT803X_DEBUG_RGMII_1V8			BIT(3)
>> +
>> +/* AT803x supports either the XTAL input pad, an internal PLL or the
>> + * DSP as clock reference for the clock output pad=2E The XTAL
>reference
>> + * is only used for 25 MHz output, all other frequencies need the
>PLL=2E
>> + * The DSP as a clock reference is used in synchronous ethernet
>> + * applications=2E
>
>How does that tie in the mode in which the PHY is configured? In
>reverse
>MII mode, the PHY provides the TX clock which can be either 25Mhz or
>50Mhz AFAIR, in RGMII mode, the TXC provided by the MAC is internally
>resynchronized and then fed back to the MAC as a 125Mhz clock=2E
>
>Do you possibly need to cross check the clock output selection with the
>PHY interface?

what do you mean by mode? the "clock output pad" (maybe the term is wrong)=
 is just an additional clock output=2E And I've ignored syncE mode for now=
=2E I don't think there is a real use case for now=2E because in almost all=
 cases the clock out is used to generate 125MHz required by an RGMII core i=
n the SoC=2E=20


>
>[snip]
>> +static int at803x_parse_dt(struct phy_device *phydev)
>> +{
>> +	struct device_node *node =3D phydev->mdio=2Edev=2Eof_node;
>> +	struct at803x_priv *priv =3D phydev->priv;
>> +	u32 freq, strength;
>> +	unsigned int sel;
>> +	int ret;
>> +
>> +	if (!IS_ENABLED(CONFIG_OF_MDIO))
>> +		return 0;
>> +
>> +	if (!node)
>> +		return 0;
>
>I don't think you need either of those two things, every of_* function
>would check whether the node reference is non-NULL=2E

The first is needed because otherwise the of_* return -ENOSYS IIRC=2E I gu=
ess it would make no difference here though=2E Although I don't know how cl=
ever the compiler is as it could optimize the whole function away if CONFIG=
_OF_MDIO is not enabled=2E=20

>> +
>> +	if (of_property_read_bool(node, "atheros,keep-pll-enabled"))
>> +		priv->flags |=3D AT803X_KEEP_PLL_ENABLED;
>
>This should probably be a PHY tunable rather than a Device Tree
>property
>as this delves more into the policy than the pure hardware description=2E

To be frank=2E I'll first need to look into PHY tunables before answering =
;)=20
But keep in mind that this clock output might be used anywhere on the boar=
d=2E It must not have something to do with networking=2E The PHY has a crys=
tal and it can generate these couple of frequencies regardless of its netwo=
rk operation=2E=20

>> +
>> +	if (of_property_read_bool(node, "atheros,rgmii-io-1v8"))
>> +		priv->flags |=3D AT803X_RGMII_1V8;> +
>> +	ret =3D of_property_read_u32(node, "atheros,clk-out-frequency",
>&freq);
>> +	if (!ret) {
>> +		switch (freq) {
>> +		case 25000000:
>> +			sel =3D AT803X_CLK_OUT_25MHZ_XTAL;
>> +			break;
>> +		case 50000000:
>> +			sel =3D AT803X_CLK_OUT_50MHZ_PLL;
>> +			break;
>> +		case 62500000:
>> +			sel =3D AT803X_CLK_OUT_62_5MHZ_PLL;
>> +			break;
>> +		case 125000000:
>> +			sel =3D AT803X_CLK_OUT_125MHZ_PLL;
>> +			break;
>> +		default:
>> +			phydev_err(phydev,
>> +				   "invalid atheros,clk-out-frequency\n");
>> +			return -EINVAL;
>> +		}
>
>Maybe the PHY should be a clock provider of some sort, this might be
>especially important if the PHY supplies the Ethernet MAC's RXC (which
>would be the case in a RGMII configuration)=2E

Could be the case, I don't know=2E I'm developing this on a NXP layerscape=
 LS1028A and this SoC needs a fixed 125MHz clock for its RGMII interface (r=
egardless if its 10/100 or 100 Mbit/s)=2E I guess the same is true for the =
i=2EMX series=2E=20

-michael=20

