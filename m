Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CCC1E466D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389361AbgE0OwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:52:08 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56424 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgE0OwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:52:08 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04REq0wB049154;
        Wed, 27 May 2020 09:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590591120;
        bh=W9cUVgUiVlKpasnouxZe/jr55TOUx7dt8VfCWyPWOHU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=aP+vMyRDyKm9P2Sjpt7nL7wSiynvQE/OEyts1J6pxlgOCR5o47Do4Ebj10NYbNVU/
         ggZ0dJaWn4ONiiuqVKkvgBAU7KAfamGpKvNcrvlVBDbzZ/kr75gYTnKU6yYj6uaykC
         4odm5C5sFsiNEUHBBAASLICXvNfpQvZfKhodOAmk=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04REq0FV077131
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 09:52:00 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 May 2020 09:52:00 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 May 2020 09:52:00 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04REpvqM115260;
        Wed, 27 May 2020 09:51:58 -0500
Subject: Re: [PATCH net-next v3 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200526174716.14116-1-dmurphy@ti.com>
 <20200526174716.14116-5-dmurphy@ti.com> <20200527005224.GF782807@lunn.ch>
 <c0867d48-6f04-104b-8192-d61d4464a65f@ti.com>
 <20200527131204.GB793752@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <bbbf2c2e-2238-3e53-08eb-9d7ad3fc785b@ti.com>
Date:   Wed, 27 May 2020 09:51:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200527131204.GB793752@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/27/20 8:12 AM, Andrew Lunn wrote:
>> If the dt defines rgmii-rx/tx-id then these values are required not
>> optional.  That was the discussion on the binding.
> How many times do i need to say it. They are optional. If not
> specified, default to 2ns.

OK.  I guess then the DP83867 driver is wrong because it specifically 
states in bold

     /* RX delay *must* be specified if internal delay of RX is used. */

It was signed off in commit fafc5db28a2ff


>>>> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>>>> +				   &dp83869->tx_id_delay);
>>>> +	if (ret) {
>>>> +		dp83869->tx_id_delay = ret;
>>>> +		ret = 0;
>>>> +	}
>>>> +
>>>>    	return ret;
>>>>    }
>>>>    #else
>>>> @@ -367,10 +388,45 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>>>>    	return ret;
>>>>    }
>>>> +static int dp83869_get_delay(struct phy_device *phydev)
>>>> +{
>>>> +	struct dp83869_private *dp83869 = phydev->priv;
>>>> +	int delay_size = ARRAY_SIZE(dp83869_internal_delay);
>>>> +	int tx_delay = 0;
>>>> +	int rx_delay = 0;
>>>> +
>>>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
>>>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
>>>> +		tx_delay = phy_get_delay_index(phydev,
>>>> +					       &dp83869_internal_delay[0],
>>>> +					       delay_size, dp83869->tx_id_delay,
>>>> +					       false);
>>>> +		if (tx_delay < 0) {
>>>> +			phydev_err(phydev, "Tx internal delay is invalid\n");
>>>> +			return tx_delay;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
>>>> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
>>>> +		rx_delay = phy_get_delay_index(phydev,
>>>> +					       &dp83869_internal_delay[0],
>>>> +					       delay_size, dp83869->rx_id_delay,
>>>> +					       false);
>>>> +		if (rx_delay < 0) {
>>>> +			phydev_err(phydev, "Rx internal delay is invalid\n");
>>>> +			return rx_delay;
>>>> +		}
>>>> +	}
>>> So any PHY using these properties is going to pretty much reproduce
>>> this code. Meaning is should all be in a helper.
>> The issue here is that the phy_mode may only be rgmii-txid so you only want
>> to find the tx_delay and return.
>>
>> Same with the RXID.  How is the helper supposed to know what delay to return
>> and look for?
> How does this code do it? It looks at the value of interface.

Actually I will be removing this check with setting the delays to default.

Dan


>      Andrew
