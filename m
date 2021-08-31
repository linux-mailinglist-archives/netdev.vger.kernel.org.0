Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CA93FC942
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhHaOCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:02:52 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:14780 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhHaOCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 10:02:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630418513; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=3OysEvySwOHgGDBoSVKkQ1YfbUEeF306JYqAcHEYipQ=; b=G1d8uYB4n7itN3GRGBcx0O8aNewi1JnX9cB454OIvHtbM1r+pBB+O060VmGNRZpT8aMIeD0N
 IZiz/Yw4K3llj55+5iydo2t+KeeaoMALibL0M8j0IEwC93TID9T2pBRetWuAEarTVCXRYeki
 9o1ij0FMD3VygRF1BQsnAwdSCHw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 612e3624cd680e8969f1fd0c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 31 Aug 2021 14:01:08
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 16F5AC43460; Tue, 31 Aug 2021 14:01:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.10.117] (unknown [183.192.232.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E7735C4338F;
        Tue, 31 Aug 2021 14:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E7735C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH v1 1/3] net: phy: improve the wol feature of at803x
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20210830110733.8964-1-luoj@codeaurora.org>
 <20210830110733.8964-2-luoj@codeaurora.org> <YSzd/BCy7JHoWKZV@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <8f078517-f537-f462-2e8a-5735c12d4c45@codeaurora.org>
Date:   Tue, 31 Aug 2021 22:01:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSzd/BCy7JHoWKZV@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/30/2021 9:32 PM, Andrew Lunn wrote:
> On Mon, Aug 30, 2021 at 07:07:31PM +0800, Luo Jie wrote:
>> wol is controlled by bit 5 of reg 3.8012, which should be
>> configured by set_wol of phy_driver.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/at803x.c | 50 +++++++++++++++++++++++-----------------
>>   1 file changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
>> index 5d62b85a4024..ecae26f11aa4 100644
>> --- a/drivers/net/phy/at803x.c
>> +++ b/drivers/net/phy/at803x.c
>> @@ -70,10 +70,14 @@
>>   #define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
>>   #define AT803X_LED_CONTROL			0x18
>>   
>> -#define AT803X_DEVICE_ADDR			0x03
>> +/* WOL control */
>> +#define AT803X_PHY_MMD3_WOL_CTRL		0x8012
>> +#define AT803X_WOL_EN				BIT(5)
>> +
>>   #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
>>   #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
>>   #define AT803X_LOC_MAC_ADDR_32_47_OFFSET	0x804A
>> +
>>   #define AT803X_REG_CHIP_CONFIG			0x1f
>>   #define AT803X_BT_BX_REG_SEL			0x8000
>>   
>> @@ -328,12 +332,6 @@ static int at803x_set_wol(struct phy_device *phydev,
>>   	struct net_device *ndev = phydev->attached_dev;
>>   	const u8 *mac;
>>   	int ret;
>> -	u32 value;
>> -	unsigned int i, offsets[] = {
>> -		AT803X_LOC_MAC_ADDR_32_47_OFFSET,
>> -		AT803X_LOC_MAC_ADDR_16_31_OFFSET,
>> -		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
>> -	};
>>   
>>   	if (!ndev)
>>   		return -ENODEV;
>> @@ -344,23 +342,30 @@ static int at803x_set_wol(struct phy_device *phydev,
>>   		if (!is_valid_ether_addr(mac))
>>   			return -EINVAL;
>>   
>> -		for (i = 0; i < 3; i++)
>> -			phy_write_mmd(phydev, AT803X_DEVICE_ADDR, offsets[i],
>> -				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
>> +		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_32_47_OFFSET,
>> +				mac[1] | (mac[0] << 8));
>> +		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_16_31_OFFSET,
>> +				mac[3] | (mac[2] << 8));
>> +		phy_write_mmd(phydev, MDIO_MMD_PCS, AT803X_LOC_MAC_ADDR_0_15_OFFSET,
>> +				mac[5] | (mac[4] << 8));
> Please try to keep your changes minimal. It looks like all you really
> need is to replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS. Everything
> else is O.K. Maybe make offset a const?
>
> Making the change more complex than it needs to be makes it harder to
> review.
thanks Andrew for the comments, will keep this changes minimal in the 
next patch series.
>
>>   
>> -		value = phy_read(phydev, AT803X_INTR_ENABLE);
>> -		value |= AT803X_INTR_ENABLE_WOL;
>> -		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
> So that it be replaced with a phy_modify().
yes, it's replaced with phy_modify().
>
>
>> +		/* clear the pending interrupt */
>> +		phy_read(phydev, AT803X_INTR_STATUS);
> But where did this come from?
this code is not new added, which is existed code for at803x phy driver.
>
>> +
>> +		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
>>   		if (ret)
>>   			return ret;
>> -		value = phy_read(phydev, AT803X_INTR_STATUS);
>> +
>> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
>> +				0, AT803X_WOL_EN);
>> +
>>   	} else {
>> -		value = phy_read(phydev, AT803X_INTR_ENABLE);
>> -		value &= (~AT803X_INTR_ENABLE_WOL);
>> -		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
>> +		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
> This makes sense
>
>>   		if (ret)
>>   			return ret;
>> -		value = phy_read(phydev, AT803X_INTR_STATUS);
>> +
>> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
>> +				AT803X_WOL_EN, 0);
> But where did this come from?
For wol_set, i add the AT803X_WOL_EN configuration, which is necessary 
for the wol feature.
>
> I could be wrong, but i get the feeling you just replaced the code
> with what you have in your new driver, rather than step by step
> improve this code.
>
> Please break this patch up into a number of patches:
>
> AT803X_DEVICE_ADDR with MDIO_MMD_PCS
> read/write to modify.
>
> Other patches for the remaining changes, if actually required, with a
> good explanation of why they are needed.
>
>      Andrew

Hi Andrew, thanks for the suggestions. Will break the changes into 
minimal patches, and check the at803x phy driver in detail to

improve the driver in the next patch series.

