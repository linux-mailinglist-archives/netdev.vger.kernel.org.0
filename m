Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847FA4DBF99
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiCQGps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiCQGpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:45:47 -0400
X-Greylist: delayed 168953 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Mar 2022 23:44:31 PDT
Received: from mout-u-204.mailbox.org (mout-u-204.mailbox.org [IPv6:2001:67c:2050:1::465:204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BDEDE927
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:44:30 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 4KJyL269Cfz9sT1;
        Thu, 17 Mar 2022 07:44:26 +0100 (CET)
Message-ID: <96f69525-53e1-f77e-e0f4-3146c2310551@denx.de>
Date:   Thu, 17 Mar 2022 07:43:52 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] net: phy: marvell: Add errata section 5.1 for Alaska PHY
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20220315074827.1439941-1-sr@denx.de>
 <20220315170929.5f509600@dellmb>
From:   Stefan Roese <sr@denx.de>
In-Reply-To: <20220315170929.5f509600@dellmb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 17:09, Marek Behún wrote:
> On Tue, 15 Mar 2022 08:48:27 +0100
> Stefan Roese <sr@denx.de> wrote:
> 
>> From: Leszek Polak <lpolak@arri.de>
>>
>> As per Errata Section 5.1, if EEE is intended to be used, some register
>> writes must be done once after every hardware reset. This patch now adds
>> the necessary register writes as listed in the Marvell errata.
>>
>> Without this fix we experience ethernet problems on some of our boards
>> equipped with a new version of this ethernet PHY (different supplier).
>>
>> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
>> Rev. A0.
>>
>> Signed-off-by: Leszek Polak <lpolak@arri.de>
>> Signed-off-by: Stefan Roese <sr@denx.de>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: David S. Miller <davem@davemloft.net>
>> ---
>>   drivers/net/phy/marvell.c | 42 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
>> index 2429db614b59..0f4a3ab4a415 100644
>> --- a/drivers/net/phy/marvell.c
>> +++ b/drivers/net/phy/marvell.c
>> @@ -1179,6 +1179,48 @@ static int m88e1510_config_init(struct phy_device *phydev)
>>   {
>>   	int err;
>>   
>> +	/* As per Marvell Release Notes - Alaska 88E1510/88E1518/88E1512/
>> +	 * 88E1514 Rev A0, Errata Section 5.1:
>> +	 * If EEE is intended to be used, the following register writes
>> +	 * must be done once after every hardware reset.
>> +	 */
>> +	err = marvell_set_page(phydev, 0x00FF);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 17, 0x214B);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 16, 0x2144);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 17, 0x0C28);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 16, 0x2146);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 17, 0xB233);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 16, 0x214D);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 17, 0xCC0C);
>> +	if (err < 0)
>> +		return err;
>> +	err = phy_write(phydev, 16, 0x2159);
>> +	if (err < 0)
>> +		return err;
> 
> Can you please create a static const struct and then do this in a for
> cycle? Somethign like this
> 
> static const struct { u16 reg17, reg16; } errata_vals = {
>    { 0x214B, 0x2144 }, ...
> };
> 
> for (i = 0; i < ARRAY_SIZE(errata_vals); ++i) {
>    err = phy_write(phydev, 17, errata_vals[i].reg17);
>    if (err)
>      return err;
>    err = phy_write(phydev, 16, errata_vals[i].reg16);
>    if (err)
>      return err;
> }

I could do this, sure. But frankly I'm not so sure, if this really
improves the code much. This list will most likely never be extended.
And in this current version, it's easier to compare the values written
with the one described in the errata.

But again, I have no hard feeling here. If it's the general option to
move to the "loop version", then I'll gladly send an updated patch
version.

Thanks,
Stefan
