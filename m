Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6331DEF7B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgEVSu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:50:26 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48244 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730849AbgEVSuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:50:25 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04MIoIds016862;
        Fri, 22 May 2020 13:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590173418;
        bh=aYPvxAe4QCajYkLXOBIjCSPbHKlCTfuP5XdxHUSW9sk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mtbeLiBqCtgk/pHdokybvHBzlsvroGzYwwU4w3vgtUxAdcnkASwmb+DuHfMiGAtKY
         qY0147vvG53YiUWuPwCRE7qQIRWKMjUCcLUNv/hTz9X9grr9q694rWc3BcWdctLcQO
         9/8QOEDcePQyU7z157lRvV0uEiaPG+udyPVACbdI=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MIoITl115743;
        Fri, 22 May 2020 13:50:18 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 May 2020 13:50:18 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 May 2020 13:50:18 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MIoIPH046270;
        Fri, 22 May 2020 13:50:18 -0500
Subject: Re: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-5-dmurphy@ti.com>
 <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <948bfa24-97ad-ba35-f06c-25846432e506@ti.com>
Date:   Fri, 22 May 2020 13:50:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 5/22/20 11:13 AM, Florian Fainelli wrote:
>
> On 5/22/2020 5:25 AM, Dan Murphy wrote:
>> Add RGMII internal delay configuration for Rx and Tx.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/dp83869.c | 101 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 101 insertions(+)
>>
>> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
>> index cfb22a21a2e6..a9008d32e2b6 100644
>> --- a/drivers/net/phy/dp83869.c
>> +++ b/drivers/net/phy/dp83869.c
>> @@ -99,6 +99,14 @@
>>   #define DP83869_OP_MODE_MII			BIT(5)
>>   #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
>>   
>> +/* RGMIIDCTL bits */
>> +#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
>> +#define DP83869_RGMII_CLK_DELAY_INV		0
>> +
>> +static int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500, 1750,
>> +				       2000, 2250, 2500, 2750, 3000, 3250,
>> +				       3500, 3750, 4000};
>> +
>>   enum {
>>   	DP83869_PORT_MIRRORING_KEEP,
>>   	DP83869_PORT_MIRRORING_EN,
>> @@ -108,6 +116,8 @@ enum {
>>   struct dp83869_private {
>>   	int tx_fifo_depth;
>>   	int rx_fifo_depth;
>> +	u32 rx_id_delay;
>> +	u32 tx_id_delay;
>>   	int io_impedance;
>>   	int port_mirroring;
>>   	bool rxctrl_strap_quirk;
>> @@ -182,6 +192,7 @@ static int dp83869_of_init(struct phy_device *phydev)
>>   	struct dp83869_private *dp83869 = phydev->priv;
>>   	struct device *dev = &phydev->mdio.dev;
>>   	struct device_node *of_node = dev->of_node;
>> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
>>   	int ret;
>>   
>>   	if (!of_node)
>> @@ -232,6 +243,26 @@ static int dp83869_of_init(struct phy_device *phydev)
>>   				 &dp83869->tx_fifo_depth))
>>   		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>>   
>> +	dp83869->rx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
>> +	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
>> +				   &dp83869->rx_id_delay);
>> +	if (!ret && dp83869->rx_id_delay > dp83869_internal_delay[delay_size]) {
>> +		phydev_err(phydev,
>> +			   "rx-internal-delay value of %u out of range\n",
>> +			   dp83869->rx_id_delay);
>> +		return -EINVAL;
>> +	}
>> +
>> +	dp83869->tx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
>> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>> +				   &dp83869->tx_id_delay);
>> +	if (!ret && dp83869->tx_id_delay > dp83869_internal_delay[delay_size]) {
>> +		phydev_err(phydev,
>> +			   "tx-internal-delay value of %u out of range\n",
>> +			   dp83869->tx_id_delay);
>> +		return -EINVAL;
>> +	}
> This is the kind of validation that I would be expecting from the PHY
> library to do, in fact, since you use Device Tree standard property, I
> would expect you only need to pass the maximum delay value and some
> storage for your array of delays.

Actually the PHY library will return either the 0th index if the value 
is to small or the max index if the value is to large

based on the array passed in so maybe this check is unnecessary.


>> +
>>   	return ret;
>>   }
>>   #else
>> @@ -270,6 +301,29 @@ static int dp83869_configure_rgmii(struct phy_device *phydev,
>>   	return ret;
>>   }
>>   
>> +static int dp83869_verify_rgmii_cfg(struct phy_device *phydev)
>> +{
>> +	struct dp83869_private *dp83869 = phydev->priv;
>> +
>> +	/* RX delay *must* be specified if internal delay of RX is used. */
>> +	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	     phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) &&
>> +	     dp83869->rx_id_delay == DP83869_RGMII_CLK_DELAY_INV) {
>> +		phydev_err(phydev, "ti,rx-internal-delay must be specified\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* TX delay *must* be specified if internal delay of TX is used. */
>> +	if ((phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	     phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) &&
>> +	     dp83869->tx_id_delay == DP83869_RGMII_CLK_DELAY_INV) {
>> +		phydev_err(phydev, "ti,tx-internal-delay must be specified\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int dp83869_configure_mode(struct phy_device *phydev,
>>   				  struct dp83869_private *dp83869)
>>   {
>> @@ -371,6 +425,12 @@ static int dp83869_config_init(struct phy_device *phydev)
>>   {
>>   	struct dp83869_private *dp83869 = phydev->priv;
>>   	int ret, val;
>> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
>> +	int delay = 0;
>> +
>> +	ret = dp83869_verify_rgmii_cfg(phydev);
>> +	if (ret)
>> +		return ret;
>>   
>>   	ret = dp83869_configure_mode(phydev, dp83869);
>>   	if (ret)
>> @@ -394,6 +454,47 @@ static int dp83869_config_init(struct phy_device *phydev)
>>   				     dp83869->clk_output_sel <<
>>   				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
>>   
>> +	if (phy_interface_is_rgmii(phydev)) {
>> +		val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL);
>> +
>> +		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN | DP83869_RGMII_RX_CLK_DELAY_EN);
>> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
>> +			val |= (DP83869_RGMII_TX_CLK_DELAY_EN | DP83869_RGMII_RX_CLK_DELAY_EN);
>> +
>> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
>> +			val |= DP83869_RGMII_TX_CLK_DELAY_EN;
>> +
>> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
>> +			val |= DP83869_RGMII_RX_CLK_DELAY_EN;
>> +
>> +		phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL, val);
>> +
>> +		if (dp83869->rx_id_delay) {
>> +			val = phy_get_delay_index(phydev,
>> +						  &dp83869_internal_delay[0],
>> +						  delay_size,
>> +						  dp83869->rx_id_delay);
>> +			if (val < 0)
>> +				return val;
>> +
>> +			delay |= val;
> Don't you need to do a bitwise AND with the maximum delay value
> supported by the range since you do a Read/Modify/Write operation here?
There is not RMW here.  This is a write to the RGMIIDCTL register.
>
>> +		}
>> +
>> +		if (dp83869->tx_id_delay) {
>> +			val = phy_get_delay_index(phydev,
>> +						  &dp83869_internal_delay[0],
>> +						  delay_size,
>> +						  dp83869->tx_id_delay);
>> +			if (val < 0)
>> +				return val;
>> +
>> +			delay |= val << DP83869_RGMII_TX_CLK_DELAY_SHIFT;
> Likewise.

Same as above

Dan

