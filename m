Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C451E4200
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgE0MYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 08:24:04 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:60570 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgE0MYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 08:24:03 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04RCNutA122607;
        Wed, 27 May 2020 07:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590582236;
        bh=Vpls28zqWFv+m2tzlLEDxZh3MhqxOrWIWFXc0hTbBhU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=GGpgcHcWLWt8PBvTah72vKywx522Jzw48hhG1JEeoQ+fNenGAeln8FLJeKtSd6Gfo
         WBbTppo0OfL9zlyCBy0VdjL7TPki1YJF34drqsG2Rv7D4bSwLN3Bws1geCjUD0nPOj
         mE0nPw7SXb+xk9HPGwYLIjMbecUC2RM6yHP3rNfg=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04RCNuQV039174
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 07:23:56 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 May 2020 07:23:56 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 May 2020 07:23:56 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04RCNueD076213;
        Wed, 27 May 2020 07:23:56 -0500
Subject: Re: [PATCH net-next v3 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200526174716.14116-1-dmurphy@ti.com>
 <20200526174716.14116-5-dmurphy@ti.com> <20200527005224.GF782807@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <c0867d48-6f04-104b-8192-d61d4464a65f@ti.com>
Date:   Wed, 27 May 2020 07:23:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200527005224.GF782807@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/26/20 7:52 PM, Andrew Lunn wrote:
>> @@ -218,6 +224,7 @@ static int dp83869_of_init(struct phy_device *phydev)
>>   		ret = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_STRAP_STS1);
>>   		if (ret < 0)
>>   			return ret;
>> +
>>   		if (ret & DP83869_STRAP_MIRROR_ENABLED)
>>   			dp83869->port_mirroring = DP83869_PORT_MIRRORING_EN;
>>   		else
> This random white space change does not belong in this patch.

OK


>> @@ -232,6 +239,20 @@ static int dp83869_of_init(struct phy_device *phydev)
>>   				 &dp83869->tx_fifo_depth))
>>   		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>>   
>> +	ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
>> +				   &dp83869->rx_id_delay);
>> +	if (ret) {
>> +		dp83869->rx_id_delay = ret;
>> +		ret = 0;
>> +	}
> This looks odd.
>
> If this optional property is not found, -EINVAL will be returned. It
> could also return -ENODATA. You then assign this error value to
> dp83869->rx_id_delay? I would of expected you to assign 2000, the
> default value?

Well the driver cannot assume this is the intended value.

If the dt defines rgmii-rx/tx-id then these values are required not 
optional.  That was the discussion on the binding.

I set these to errno because when config_init is called the driver 
verifies that the values are valid and present and if they

are not then the PHY will fail to init.

If we set the delay to default then the PHY may be programmed with the 
wrong delay.


>> +
>> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>> +				   &dp83869->tx_id_delay);
>> +	if (ret) {
>> +		dp83869->tx_id_delay = ret;
>> +		ret = 0;
>> +	}
>> +
>>   	return ret;
>>   }
>>   #else
>> @@ -367,10 +388,45 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>>   	return ret;
>>   }
>>   
>> +static int dp83869_get_delay(struct phy_device *phydev)
>> +{
>> +	struct dp83869_private *dp83869 = phydev->priv;
>> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
>> +	int tx_delay = 0;
>> +	int rx_delay = 0;
>> +
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
>> +		tx_delay = phy_get_delay_index(phydev,
>> +					       &dp83869_internal_delay[0],
>> +					       delay_size, dp83869->tx_id_delay,
>> +					       false);
>> +		if (tx_delay < 0) {
>> +			phydev_err(phydev, "Tx internal delay is invalid\n");
>> +			return tx_delay;
>> +		}
>> +	}
>> +
>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
>> +		rx_delay = phy_get_delay_index(phydev,
>> +					       &dp83869_internal_delay[0],
>> +					       delay_size, dp83869->rx_id_delay,
>> +					       false);
>> +		if (rx_delay < 0) {
>> +			phydev_err(phydev, "Rx internal delay is invalid\n");
>> +			return rx_delay;
>> +		}
>> +	}
> So any PHY using these properties is going to pretty much reproduce
> this code. Meaning is should all be in a helper.

The issue here is that the phy_mode may only be rgmii-txid so you only 
want to find the tx_delay and return.

Same with the RXID.  How is the helper supposed to know what delay to 
return and look for?

The PHY also only needs to use the helper if the PHY is in certain modes.

And the decision to use the checks is really based on the PHY driver.

Not sure if other PHYs delays require both delays to be set or if the 
delays are independent.

The helper cannot assume this.

Dan


>
>       Andrew
