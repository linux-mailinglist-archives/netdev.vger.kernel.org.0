Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D388C3FC96A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhHaOMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:12:06 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:37905 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHaOME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 10:12:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630419068; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=7S0kRQ1abQwwZF4U3vdKpHJgesRzC60yL/nDP3TMnX0=; b=jg2kRGO9hZK+RsW6mMHyEPN9jk2Ns4eDwUb7SLrfDDIbCooyztHhVwzjGhiGD4HoHdDZLUIP
 ThvPb4XR3UzhvNthIc+5dTCSyyYCtRd4LNWNwRuniOnBvUj6nkUEoS1skHOgFDF6qJ+Lcl+Q
 tUJ/KYqur5xitpTjiCuspd0vkJ0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 612e38684cd9015037a70268 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 31 Aug 2021 14:10:48
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9694BC43619; Tue, 31 Aug 2021 14:10:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.10.117] (unknown [183.192.232.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5B8E6C4338F;
        Tue, 31 Aug 2021 14:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5B8E6C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH v1 2/3] net: phy: add qca8081 ethernet phy driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20210830110733.8964-1-luoj@codeaurora.org>
 <20210830110733.8964-3-luoj@codeaurora.org> <YSzhtF8g42Ccv2h0@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <af224018-1190-ac78-2035-c9763c1d46ae@codeaurora.org>
Date:   Tue, 31 Aug 2021 22:10:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSzhtF8g42Ccv2h0@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/30/2021 9:48 PM, Andrew Lunn wrote:
> On Mon, Aug 30, 2021 at 07:07:32PM +0800, Luo Jie wrote:
>> qca8081 is a single port ethernet phy chip that supports
>> 10/100/1000/2500 Mbps mode.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/at803x.c | 389 ++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 338 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
>> index ecae26f11aa4..2b3563ae152f 100644
>> --- a/drivers/net/phy/at803x.c
>> +++ b/drivers/net/phy/at803x.c
>> @@ -33,10 +33,10 @@
>>   #define AT803X_SFC_DISABLE_JABBER		BIT(0)
>>   
>>   #define AT803X_SPECIFIC_STATUS			0x11
>> -#define AT803X_SS_SPEED_MASK			(3 << 14)
>> -#define AT803X_SS_SPEED_1000			(2 << 14)
>> -#define AT803X_SS_SPEED_100			(1 << 14)
>> -#define AT803X_SS_SPEED_10			(0 << 14)
>> +#define AT803X_SS_SPEED_MASK			GENMASK(15, 14)
>> +#define AT803X_SS_SPEED_1000			2
>> +#define AT803X_SS_SPEED_100			1
>> +#define AT803X_SS_SPEED_10			0
> This looks like an improvement, and nothing to do with qca8081. Please
> make it an separate patch.
will make it an separate patch in the next patch series.
>>   #define AT803X_SS_DUPLEX			BIT(13)
>>   #define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
>>   #define AT803X_SS_MDIX				BIT(6)
>> @@ -158,6 +158,8 @@
>>   #define QCA8337_PHY_ID				0x004dd036
>>   #define QCA8K_PHY_ID_MASK			0xffffffff
>>   
>> +#define QCA8081_PHY_ID				0x004dd101
>> +
> Maybe keep all the PHY_ID together?
will move it to make PHY_ID together in the next patch series.
>
>>   #define QCA8K_DEVFLAGS_REVISION_MASK		GENMASK(2, 0)
>>   
>>   #define AT803X_PAGE_FIBER			0
>> @@ -167,7 +169,73 @@
>>   #define AT803X_KEEP_PLL_ENABLED			BIT(0)
>>   #define AT803X_DISABLE_SMARTEEE			BIT(1)
>>   
>> @@ -711,11 +779,18 @@ static void at803x_remove(struct phy_device *phydev)
>>   
>>   static int at803x_get_features(struct phy_device *phydev)
>>   {
>> -	int err;
>> +	int val;
> Why? The driver pretty consistently uses err for return values which
> are errors.
will keep err unchanged in the next patch set.
>
>>   
>> -	err = genphy_read_abilities(phydev);
>> -	if (err)
>> -		return err;
>> +	val = genphy_read_abilities(phydev);
>> +	if (val)
>> +		return val;
>> +
>> +	if (at803x_match_phy_id(phydev, QCA8081_PHY_ID)) {
>> +		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> You don't check if val indicates if there was an error.
thanks Andrew for the comment, will add the check here.
>
>> +
>> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
>> +				val & MDIO_PMA_NG_EXTABLE_2_5GBT);
>> +	}
>>   
>>   	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
>>   		return 0;
>> @@ -935,44 +1010,44 @@ static void at803x_link_change_notify(struct phy_device *phydev)
>>   	}
>>   }
>>   
>> -static int at803x_read_status(struct phy_device *phydev)
>> +static int at803x_read_specific_status(struct phy_device *phydev)
>>   {
>> -	int ss, err, old_link = phydev->link;
>> -
>> -	/* Update the link, but return if there was an error */
>> -	err = genphy_update_link(phydev);
>> -	if (err)
>> -		return err;
>> -
>> -	/* why bother the PHY if nothing can have changed */
>> -	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
>> -		return 0;
>> +	int val;
>>   
>> -	phydev->speed = SPEED_UNKNOWN;
>> -	phydev->duplex = DUPLEX_UNKNOWN;
>> -	phydev->pause = 0;
>> -	phydev->asym_pause = 0;
>> +	val = phy_read(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL);
>> +	if (val < 0)
>> +		return val;
>>   
>> -	err = genphy_read_lpa(phydev);
>> -	if (err < 0)
>> -		return err;
>> +	switch (FIELD_GET(AT803X_SFC_MDI_CROSSOVER_MODE_M, val)) {
>> +	case AT803X_SFC_MANUAL_MDI:
>> +		phydev->mdix_ctrl = ETH_TP_MDI;
>> +		break;
>> +	case AT803X_SFC_MANUAL_MDIX:
>> +		phydev->mdix_ctrl = ETH_TP_MDI_X;
>> +		break;
>> +	case AT803X_SFC_AUTOMATIC_CROSSOVER:
>> +		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
>> +		break;
>> +	}
>>   
>>   	/* Read the AT8035 PHY-Specific Status register, which indicates the
>>   	 * speed and duplex that the PHY is actually using, irrespective of
>>   	 * whether we are in autoneg mode or not.
>>   	 */
>> -	ss = phy_read(phydev, AT803X_SPECIFIC_STATUS);
>> -	if (ss < 0)
>> -		return ss;
>> +	val = phy_read(phydev, AT803X_SPECIFIC_STATUS);
>> +	if (val < 0)
>> +		return val;
> What was actually wrong with ss?
>
> Is this another case of just copying code from your other driver,
> rather than cleanly extending the existing driver?
>
> There are two many changes here all at once. Please break this patch
> up. You are aiming for lots of small patches which are obviously
> correct. Part of being obviously correct is having a good commit
> message, and that gets much easier when a patch is small.
>
> 	 Andrew

Hi Andrew,

i separate the phy specific status into a new function 
at803x_read_specific_status, since this function

need to be used for both at803x phy driver and qca8081 phy driver.

i will break the patch into the minimal changes and provide the commit 
message in detail in the next

patch series.

thanks for your helpful comments.


