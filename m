Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4352A4AF6F1
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbiBIQkN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Feb 2022 11:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiBIQkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:40:12 -0500
X-Greylist: delayed 357 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 08:40:14 PST
Received: from unicorn.mansr.com (unicorn.mansr.com [81.2.72.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6745C0612BE;
        Wed,  9 Feb 2022 08:40:14 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [81.2.72.235])
        by unicorn.mansr.com (Postfix) with ESMTPS id 2948D15360;
        Wed,  9 Feb 2022 16:34:15 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 1F5CD21588D; Wed,  9 Feb 2022 16:34:15 +0000 (GMT)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
References: <20220209145454.19749-1-mans@mansr.com> <YgPlVGclJOkvLZ1i@lunn.ch>
Date:   Wed, 09 Feb 2022 16:34:15 +0000
In-Reply-To: <YgPlVGclJOkvLZ1i@lunn.ch> (Andrew Lunn's message of "Wed, 9 Feb
        2022 17:01:24 +0100")
Message-ID: <yw1x1r0c5794.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

> On Wed, Feb 09, 2022 at 02:54:54PM +0000, Mans Rullgard wrote:
>> The reset input to the LAN9303 chip is active low, and devicetree
>> gpio handles reflect this.  Therefore, the gpio should be requested
>> with an initial state of high in order for the reset signal to be
>> asserted.  Other uses of the gpio already use the correct polarity.
>> 
>> Signed-off-by: Mans Rullgard <mans@mansr.com>
>> ---
>>  drivers/net/dsa/lan9303-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
>> index aa1142d6a9f5..2de67708bbd2 100644
>> --- a/drivers/net/dsa/lan9303-core.c
>> +++ b/drivers/net/dsa/lan9303-core.c
>> @@ -1301,7 +1301,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
>>  				     struct device_node *np)
>>  {
>>  	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
>> -						   GPIOD_OUT_LOW);
>> +						   GPIOD_OUT_HIGH);
>>  	if (IS_ERR(chip->reset_gpio))
>>  		return PTR_ERR(chip->reset_gpio);
>
> lan9303_handle_reset() does a sleep and then releases the reset. I
> don't see anywhere in the driver which asserts the reset first. So is
> it actually asserted as part of this getting the GPIO? And if so, does
> not this change actually break the reset?

The GPIOD_OUT_xxx flags to gpiod_get() request that the pin be
configured as output and set to high/low initially.  The GPIOD_OUT_LOW
currently used by the lan9303 driver together with GPIO_ACTIVE_LOW in
the devicetrees results in the actual voltage being set high.  The
driver then sleeps for a bit before setting the gpio value to zero,
again translated to a high output voltage.  That is, the value set after
the sleep is the same as it was initially.  This is obviously not the
intent.

With the patch applied, I can measure the reset signal pulse low for the
configured duration when the device is probed.  Without the patch, the
reset signal remains high and no reset of the device occurs.

-- 
Måns Rullgård
