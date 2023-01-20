Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26B4674EC7
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjATH5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjATH5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:57:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB4B5D7E4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 23:57:17 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pImGn-0006NI-Ol; Fri, 20 Jan 2023 08:57:05 +0100
Message-ID: <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
Date:   Fri, 20 Jan 2023 08:57:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Content-Language: en-US
To:     Arun.Ramadoss@microchip.com, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, Woojung.Huh@microchip.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, pabeni@redhat.com, ore@pengutronix.de,
        edumazet@google.com
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
 <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arun,

On 20.01.23 08:01, Arun.Ramadoss@microchip.com wrote:
> Hi Ahmad,
> On Thu, 2023-01-19 at 14:10 +0100, Ahmad Fatoum wrote:
>> [You don't often get email from a.fatoum@pengutronix.de. Learn why
>> this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> Starting with commit eee16b147121 ("net: dsa: microchip: perform the
>> compatibility check for dev probed"), the KSZ switch driver now bails
>> out if it thinks the DT compatible doesn't match the actual chip:
>>
>>   ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
>>   KSZ8563, please fix it!
>>
>> Problem is that the "microchip,ksz8563" compatible is associated
>> with ksz_switch_chips[KSZ9893]. Same issue also affected the SPI
>> driver
>> for the same switch chip and was fixed in commit b44908095612
>> ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563
>> chip").
>>
>> Reuse ksz_switch_chips[KSZ8563] introduced in aforementioned commit
>> to get I2C-connected KSZ8563 probing again.
>>
>> Fixes: eee16b147121 ("net: dsa: microchip: perform the compatibility
>> check for dev probed")
> 
> In this commit, there is no KSZ8563 member in struct ksz_switch_chips.
> Whether the fixes should be to this commit "net: dsa: microchip: add
> separate struct ksz_chip_data for KSZ8563" where the member is
> introduced.

I disagree. eee16b147121 introduced the check that made my device
not probe anymore, so that's what's referenced in Fixes:. Commit
b44908095612 should have had a Fixes: pointing at eee16b147121
as well, so users don't miss it. But if they miss it, they
will notice this at build-time anyway.

Cheers,
Ahmad

> 
>> chip
>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> ---
>>  drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c
>> b/drivers/net/dsa/microchip/ksz9477_i2c.c
>> index c1a633ca1e6d..e315f669ec06 100644
>> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
>> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
>> @@ -104,7 +104,7 @@ static const struct of_device_id ksz9477_dt_ids[]
>> = {
>>         },
>>         {
>>                 .compatible = "microchip,ksz8563",
>> -               .data = &ksz_switch_chips[KSZ9893]
>> +               .data = &ksz_switch_chips[KSZ8563]
>>         },
>>         {
>>                 .compatible = "microchip,ksz9567",
>> --
>> 2.30.2
>>

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

