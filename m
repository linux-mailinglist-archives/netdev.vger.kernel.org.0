Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF8E1DFB3E
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 23:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388044AbgEWVkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 17:40:33 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57624 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388001AbgEWVkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 17:40:32 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04NLeNFr113922;
        Sat, 23 May 2020 16:40:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590270023;
        bh=SiMQ2mdVD6XIm9JHgI3bhekP7OEXIT1Wjqo0LdZtwhc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=BbdzPxeaMRIKYjKSwBQCjFxMkoToook77XlC//QL2++YQic5CZi0sElHbSCEtPKon
         pIMtPYIRGAPBKyp6ZRUHgi4cnDiNl0eI/VyETXXISveLIaU2UL1dOU+qABPqTo6oL5
         b+bd54IqhU0pl+6hFamgSYxj4F1qkbFRyVJMRZkE=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04NLeN7M031345;
        Sat, 23 May 2020 16:40:23 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Sat, 23
 May 2020 16:40:22 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Sat, 23 May 2020 16:40:22 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04NLeMeU126916;
        Sat, 23 May 2020 16:40:22 -0500
Subject: Re: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-5-dmurphy@ti.com>
 <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
 <948bfa24-97ad-ba35-f06c-25846432e506@ti.com>
 <20200523150951.GK610998@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <a59412a5-7cc6-dc70-b851-c7d65c1635b7@ti.com>
Date:   Sat, 23 May 2020 16:40:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200523150951.GK610998@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/23/20 10:09 AM, Andrew Lunn wrote:
>>>> +	dp83869->tx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
>>>> +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>>>> +				   &dp83869->tx_id_delay);
>>>> +	if (!ret && dp83869->tx_id_delay > dp83869_internal_delay[delay_size]) {
>>>> +		phydev_err(phydev,
>>>> +			   "tx-internal-delay value of %u out of range\n",
>>>> +			   dp83869->tx_id_delay);
>>>> +		return -EINVAL;
>>>> +	}
>>> This is the kind of validation that I would be expecting from the PHY
>>> library to do, in fact, since you use Device Tree standard property, I
>>> would expect you only need to pass the maximum delay value and some
>>> storage for your array of delays.
>> Actually the PHY library will return either the 0th index if the value is to
>> small or the max index if the value is to large
>>
>> based on the array passed in so maybe this check is unnecessary.
> Hi Dan
>
> I'm not sure the helper is implementing the best behaviour. Rounded to
> the nearest when within the supported range is O.K. But if the request
> is outside the range, i would report an error.

Hope this email does not bounce.

> Any why is your PHY special, in that is does care about out of range
> delays, when others using new the new core helper don't?

We are not rounding to nearest here.  Basically the helper works to find 
the best match

If the delay passed in is less than or equal to the smallest delay then 
return the smallest delay index

If the delay passed in is greater then the largest delay then return the 
max delay index

Not sure what you mean about this PHY being special.  This helper is not 
PHY specific.

After I think about this more I am thinking a helper may be over kill 
here and the delay to setting should be done within the PHY driver itself

Dan

> 	Andrew
