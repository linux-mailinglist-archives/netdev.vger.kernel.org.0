Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1C1E41B6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgE0MNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 08:13:41 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40240 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgE0MNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 08:13:40 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04RCDYOh076396;
        Wed, 27 May 2020 07:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590581614;
        bh=EVFnoxGA258/+n6npjncrYyKhF4lRgHR8Yo8mu8Xt4U=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lH7sDt/pF5/sxR2pGFMoTUAXRkXk4gyj4aogpyuWrqn8GEYeh+1sJ13m5B6ncnxKi
         GBw3RWNe7riRzOlUZghc96uKd4z/B5l7UHneONp+AzJhT94q81MjGCtFLUEjL8TCtJ
         3Y8VbUlHTdEZY1cqW4hlDAv67oBToMKMrpWbOAFY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04RCDYUU114149
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 07:13:34 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 May 2020 07:13:33 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 May 2020 07:13:33 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04RCDXqB082658;
        Wed, 27 May 2020 07:13:33 -0500
Subject: Re: [PATCH net-next v3 2/4] net: phy: Add a helper to return the
 index for of the internal delay
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200526174716.14116-1-dmurphy@ti.com>
 <20200526174716.14116-3-dmurphy@ti.com> <20200527004220.GE782807@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <629b3145-719b-08a6-b6f4-ece4d26fdbdb@ti.com>
Date:   Wed, 27 May 2020 07:13:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200527004220.GE782807@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/26/20 7:42 PM, Andrew Lunn wrote:
>> +/**
>> + * phy_get_delay_index - returns the index of the internal delay
>> + * @phydev: phy_device struct
>> + * @delay_values: array of delays the PHY supports
>> + * @size: the size of the delay array
>> + * @int_delay: the internal delay to be looked up
>> + * @descending: if the delay array is in descending order
>> + *
>> + * Returns the index within the array of internal delay passed in.
>> + * Return errno if the delay is invalid or cannot be found.
>> + */
>> +s32 phy_get_delay_index(struct phy_device *phydev, int *delay_values, int size,
>> +			int int_delay, bool descending)
>> +{
>> +	if (int_delay < 0)
>> +		return -EINVAL;
>> +
>> +	if (size <= 0)
>> +		return -EINVAL;
>> +
>> +	if (descending)
>> +		return phy_find_descending_delay(phydev, delay_values, size,
>> +						 int_delay);
>> +
>> +	return phy_find_ascending_delay(phydev, delay_values, size, int_delay);
>> +}
>> +EXPORT_SYMBOL(phy_get_delay_index);
> Do we really need this ascending vs descending? This array is not
> coming from device tree of anything, it is a static list in the PHY
> driver. I would just define it needs to be ascending and be done.

I was thinking about the constraints of having just an ascending array 
helper.

If there is a PHY out there that has a descending delay array then this 
function is not a helper.

Then the PHY driver now has to implement a descending search or extend 
out this helper to do the same.

I can just keep it ascending for now but this helper may need to be 
updated in the future to accommodate any PHYs with descending delay arrays.

Dan


> 	Andrew
