Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE367558A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjATNTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjATNSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:18:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F74BC41FE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:15:37 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pIrEo-0003Ao-A6; Fri, 20 Jan 2023 14:15:22 +0100
Message-ID: <f3f3c6da-bc14-01c8-0964-52eab322f7b4@pengutronix.de>
Date:   Fri, 20 Jan 2023 14:15:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arun.Ramadoss@microchip.com, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, f.fainelli@gmail.com,
        kuba@kernel.org, Woojung.Huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, pabeni@redhat.com, ore@pengutronix.de,
        edumazet@google.com
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
 <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
 <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
 <Y8qSQDU36opcXuBE@lunn.ch>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <Y8qSQDU36opcXuBE@lunn.ch>
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

Hello Andrew,

On 20.01.23 14:08, Andrew Lunn wrote:
> On Fri, Jan 20, 2023 at 08:57:03AM +0100, Ahmad Fatoum wrote:
>> Hello Arun,
>>
>> On 20.01.23 08:01, Arun.Ramadoss@microchip.com wrote:
>>> Hi Ahmad,
>>> On Thu, 2023-01-19 at 14:10 +0100, Ahmad Fatoum wrote:
>>>> [You don't often get email from a.fatoum@pengutronix.de. Learn why
>>>> this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>>>
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>>>> know the content is safe
>>>>
>>>> Starting with commit eee16b147121 ("net: dsa: microchip: perform the
>>>> compatibility check for dev probed"), the KSZ switch driver now bails
>>>> out if it thinks the DT compatible doesn't match the actual chip:
>>>>
>>>>   ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
>>>>   KSZ8563, please fix it!
>>>>
>>>> Problem is that the "microchip,ksz8563" compatible is associated
>>>> with ksz_switch_chips[KSZ9893]. Same issue also affected the SPI
>>>> driver
>>>> for the same switch chip and was fixed in commit b44908095612
>>>> ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563
>>>> chip").
>>>>
>>>> Reuse ksz_switch_chips[KSZ8563] introduced in aforementioned commit
>>>> to get I2C-connected KSZ8563 probing again.
>>>>
>>>> Fixes: eee16b147121 ("net: dsa: microchip: perform the compatibility
>>>> check for dev probed")
>>>
>>> In this commit, there is no KSZ8563 member in struct ksz_switch_chips.
>>> Whether the fixes should be to this commit "net: dsa: microchip: add
>>> separate struct ksz_chip_data for KSZ8563" where the member is
>>> introduced.
>>
>> I disagree. eee16b147121 introduced the check that made my device
>> not probe anymore, so that's what's referenced in Fixes:. Commit
>> b44908095612 should have had a Fixes: pointing at eee16b147121
>> as well, so users don't miss it. But if they miss it, they
>> will notice this at build-time anyway.
> 
> So it sounds like two different fixes are needed? For recent kernels
> this fix alone is sufficient. But for older kernels additional changes
> are needed. Is it sufficient to backport existing patches, or are new
> patches needed?
> 
> Please start fixing the current kernel. Once that is merged you can
> post a fix for older kernels, referencing the merged fix.

I misunderstood the issue. It's indeed a single commit that broke
it. I just sent a v2 with a revised commit message and the correct
Fixes:. The fix can be cherry-picked on its own to any kernel
that contains the offending commit without any prerequisite
patches.

Cheers,
Ahmad

> 
>      Andrew
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

