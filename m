Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C5B2C8A28
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgK3Q6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:58:40 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40350 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgK3Q6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:58:39 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AUGvfe1047924;
        Mon, 30 Nov 2020 10:57:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606755461;
        bh=gNrJH9LatK/TB9QXpNOyePdcdm5KvLQAOw2GWVuZR7k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vMzBA7E7D8WiTNE2j9XJD8Qnw+Nl0PpmalzczB8uss8R4HzHbCw0QwYyO0877j59M
         R++stf+HjFugyp9GrtNkt8xsN19V9oyxYSwP8hi7EkPT2a4anwVM89dR79QIwrnJx6
         iZM0dSi6ZOQUzW6BoRIY2j5IOxBQr1DyopcmEUBY=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AUGvggS046975
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 10:57:42 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 10:57:41 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 10:57:41 -0600
Received: from [10.250.40.192] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AUGvf1a004085;
        Mon, 30 Nov 2020 10:57:41 -0600
Subject: Re: [PATCH net-next v4 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <ciorneiioana@gmail.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-5-dmurphy@ti.com> <20201120014919.GB1804098@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f1b24f86-7445-9d54-873c-192ddb0dfeb7@ti.com>
Date:   Mon, 30 Nov 2020 10:57:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120014919.GB1804098@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 11/19/20 7:49 PM, Andrew Lunn wrote:
>> +static int dp83td510_config_init(struct phy_device *phydev)
>> +{
>> +	struct dp83td510_private *dp83td510 = phydev->priv;
>> +	int ret = 0;
>> +
>> +	if (phy_interface_is_rgmii(phydev)) {
>> +		if (dp83td510->rgmii_delay) {
>> +			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
>> +					       DP83TD510_MAC_CFG_1,
>> +					       dp83td510->rgmii_delay);
> Just to be safe, you should always write rgmii_delay, even if it is
> zero. We have had too many bugs with RGMII delays which cause bad
> backwards compatibility problems, so i would prefer to do a write
> which might be unneeded, that find a bug here in a few years time.

OK.


>
>> +			if (ret)
>> +				return ret;
>> +		}
>> +	}
>> +
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RMII) {
>> +		ret = phy_modify(phydev, DP83TD510_GEN_CFG,
>> +				 DP83TD510_FIFO_DEPTH_MASK,
>> +				 dp83td510->tx_fifo_depth);
> So there is no need to set the FIFO depth for the other three RGMII
> modes? Or should this also be phy_interface_is_rgmii(phydev)?

According to the data sheet the FIFO depth is for RMII.

"Fifo depth for RMII Tx fifo"

But I will ask the HW team for clarification.


>
>> +#if IS_ENABLED(CONFIG_OF_MDIO)
>> +static int dp83td510_of_init(struct phy_device *phydev)
>> +{
>> +	struct dp83td510_private *dp83td510 = phydev->priv;
>> +	struct device *dev = &phydev->mdio.dev;
>> +	struct device_node *of_node = dev->of_node;
> You need to move this assignment to later in order to keep with
> reverse christmas tree.
Well this is only used once so I will just remove the of_node declaration
>
>> +#else
>> +static int dp83869_of_init(struct phy_device *phydev)
>> +{
>> +	dp83td510->hi_diff_output = DP83TD510_2_4V_P2P
>> +	dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB
> You don't have DT, so there is no fine control, but you still need to
> do the basic 2ns delay as indicated by the phydev->interface value. So
> i think you still need to set dp83td510->rgmii_delay depending on
> which RGMII mode is requested.

The RGMII delay is fixed in the PHY.  The user can either turn it on or 
off. The default is 'off' which is 0.

I can explicitly set the rgmii_delay to 0 in non-OF cases.

Dan

