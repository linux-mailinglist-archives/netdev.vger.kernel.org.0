Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D6154A11F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 23:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352057AbiFMVQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 17:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352075AbiFMVPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 17:15:51 -0400
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67043EEA
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 13:57:29 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 0r7no7OkDEMbD0r7nog3Oj; Mon, 13 Jun 2022 22:57:28 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 13 Jun 2022 22:57:28 +0200
X-ME-IP: 90.11.190.129
Message-ID: <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
Date:   Mon, 13 Jun 2022 22:57:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Content-Language: en-US
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/06/2022 à 22:02, Christian Lamparter a écrit :
> On Sun, Jun 12, 2022 at 11:12 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> If an error occurs after a successful call to p54spi_request_firmware(), it
>> must be undone by a corresponding release_firmware() as already done in
>> the error handling path of p54spi_request_firmware() and in the .remove()
>> function.
>>
>> Add the missing call in the error handling path and remove it from
>> p54spi_request_firmware() now that it is the responsibility of the caller
>> to release the firmawre
> 
> that last word hast a typo:  firmware. (maybe Kalle can fix this in post).

More or less the same typo twice in a row... _Embarrassed_

> 
>> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> (Though, v1 was fine too.)
>> ---
>> v2: reduce diffstat and take advantage on the fact that release_firmware()
>> checks for NULL
> 
> Heh, ok ;) . Now that I see it,  the "ret = p54_parse_firmware(...); ... "
> could have been replaced with "return p54_parse_firmware(dev, priv->firmware);"
> so the p54spi.c could shrink another 5-6 lines.
> 
> I think leaving p54spi_request_firmware() callee to deal with
> releasing the firmware
> in the error case as well is nicer because it gets rid of a "but in
> this case" complexity.


Take the one you consider being the best one.

If it deserves a v3 to axe some lines of code, I can do it but, as said 
previously, v1 is for me the cleaner and more future proof.

CJ

> 
> (I still have hope for the devres-firmware to hit some day).
> 
> Cheers
> Christian
> 
>> ---
>>   drivers/net/wireless/intersil/p54/p54spi.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
>> index f99b7ba69fc3..19152fd449ba 100644
>> --- a/drivers/net/wireless/intersil/p54/p54spi.c
>> +++ b/drivers/net/wireless/intersil/p54/p54spi.c
>> @@ -164,7 +164,7 @@ static int p54spi_request_firmware(struct ieee80211_hw *dev)
>>
>>          ret = p54_parse_firmware(dev, priv->firmware);
>>          if (ret) {
>> -               release_firmware(priv->firmware);
>> +               /* the firmware is released by the caller */
>>                  return ret;
>>          }
>>
>> @@ -659,6 +659,7 @@ static int p54spi_probe(struct spi_device *spi)
>>          return 0;
>>
>>   err_free_common:
>> +       release_firmware(priv->firmware);
>>          free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
>>   err_free_gpio_irq:
>>          gpio_free(p54spi_gpio_irq);
>> --
>> 2.34.1
>>
> 

