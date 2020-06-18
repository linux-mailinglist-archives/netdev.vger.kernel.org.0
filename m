Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA41FF35D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgFRNlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:41:22 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:51426 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgFRNlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:41:18 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05IDfBcT103253;
        Thu, 18 Jun 2020 08:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592487671;
        bh=ERMtClxbRNNwU0KyzUuGCxjmkXA6DigVdcnAOu6beUQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=yXxZCazHpogUs2wcqqEIg9WWNozXLJWaGVqhn7hxmVsZhTsIv7AkM+eL1EVMKtdLJ
         erNc+c1LJ+7YIJm7yoQchUr9DKxePaNMxZQsFY8BEBOkk2vVBzqrzWQpbGmEc0e0iH
         QXVC1NfgKLqjadRVPApTSMOUGoQp+W2hOGg+aEFY=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05IDfBKZ122464
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 08:41:11 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 08:41:11 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 08:41:11 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05IDfAQS120824;
        Thu, 18 Jun 2020 08:41:10 -0500
Subject: Re: [PATCH net-next v7 2/6] net: phy: Add a helper to return the
 index for of the internal delay
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-3-dmurphy@ti.com> <20200618015147.GH249144@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <a4ec4680-096f-2efa-0475-acf4b96e1017@ti.com>
Date:   Thu, 18 Jun 2020 08:41:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618015147.GH249144@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 6/17/20 8:51 PM, Andrew Lunn wrote:
> On Wed, Jun 17, 2020 at 01:20:15PM -0500, Dan Murphy wrote:
>> Add a helper function that will return the index in the array for the
>> passed in internal delay value.  The helper requires the array, size and
>> delay value.
>>
>> The helper will then return the index for the exact match or return the
>> index for the index to the closest smaller value.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/phy_device.c | 68 ++++++++++++++++++++++++++++++++++++
>>   include/linux/phy.h          |  4 +++
>>   2 files changed, 72 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 04946de74fa0..611d4e68e3c6 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -31,6 +31,7 @@
>>   #include <linux/mdio.h>
>>   #include <linux/io.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/property.h>
>>   
>>   MODULE_DESCRIPTION("PHY library");
>>   MODULE_AUTHOR("Andy Fleming");
>> @@ -2657,6 +2658,73 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
>>   }
>>   EXPORT_SYMBOL(phy_get_pause);
>>   
>> +/**
>> + * phy_get_delay_index - returns the index of the internal delay
>> + * @phydev: phy_device struct
>> + * @dev: pointer to the devices device struct
>> + * @delay_values: array of delays the PHY supports
>> + * @size: the size of the delay array
>> + * @is_rx: boolean to indicate to get the rx internal delay
>> + *
>> + * Returns the index within the array of internal delay passed in.
>> + * Or if size == 0 then the delay read from the firmware is returned.
>> + * The array must be in ascending order.
>> + * Return errno if the delay is invalid or cannot be found.
>> + */
>> +s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
>> +			   const int *delay_values, int size, bool is_rx)
>> +{
>> +	int ret;
>> +	int i;
>> +	s32 delay;
>> +
>> +	if (is_rx)
>> +		ret = device_property_read_u32(dev, "rx-internal-delay-ps",
>> +					       &delay);
>> +	else
>> +		ret = device_property_read_u32(dev, "tx-internal-delay-ps",
>> +					       &delay);
>> +	if (ret) {
>> +		phydev_err(phydev, "internal delay not defined\n");
> This is an optional property. So printing an error message seems heavy
> handed.

I will change this to phydev_info


> Maybe it would be better to default to 0 if the property is not found,
> and continue with the lookup in the table to find what value should be
> written for a 0ps delay?

If the property is not found what would we look up?  The property 
missing to me indicates that the phy is not adding the delay for that path.

If these properties are not present then the delay should not be set by 
the device driver.

This is why I return -EINVAL.  Maybe I should return -ENODATA instead.

Dan

>
> 	Andrew
