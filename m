Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66340547C20
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiFLVDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbiFLVDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:03:00 -0400
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E254A902
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:02:54 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 0UjSohNuN5ohR0UjSoq4Wr; Sun, 12 Jun 2022 23:02:52 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 12 Jun 2022 23:02:52 +0200
X-ME-IP: 90.11.190.129
Message-ID: <59fdf712-5825-9c0d-ee28-7b6b485d96bd@wanadoo.fr>
Date:   Sun, 12 Jun 2022 23:02:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] p54: Fix an error handling path in p54spi_probe()
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
References: <41d88dff4805800691bf4909b14c6122755f7e28.1655063685.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9CFQn33FsmaSMdVwHd__HW8NXM0MvDzJfNuxTUm6Hh4oQ@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <CAAd0S9CFQn33FsmaSMdVwHd__HW8NXM0MvDzJfNuxTUm6Hh4oQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/06/2022 à 22:45, Christian Lamparter a écrit :
> Hi,
> 
> On Sun, Jun 12, 2022 at 9:55 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> If an error occurs after a successful call to p54spi_request_firmware(), it
>> must be undone by a corresponding release_firmware()
> 
> Yes, good catch. That makes sense.
> 
>> as already done in the error handling path of p54spi_request_firmware() and in
>> the .remove() function.
>>
>> Add the missing call in the error handling path and update some goto
>> label accordingly.
> 
>  From what I know, "release_firmware(some *fw)" includes a check for
> *fw != NULL already.

Correct.

> 
> we could just add a single release_firmware(priv->firmware) to any of the error

Not my favorite style, but if it is preferred this way, NP.

> paths labels (i.e.: err_free_common) and then we remove the extra
> release_firmware(...) in p54spi_request_firmware so that we don't try to free
> it twice.

Sure. I'll add a comment to explain where is is released in case of error.

> 
> (This also skips the need for having "err_release_firmaware" .. which
> unfortunately has a small typo)
> 
> Regards,
> Christian
> 
>> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/wireless/intersil/p54/p54spi.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
>> index f99b7ba69fc3..679ac164c994 100644
>> --- a/drivers/net/wireless/intersil/p54/p54spi.c
>> +++ b/drivers/net/wireless/intersil/p54/p54spi.c
>> @@ -650,14 +650,16 @@ static int p54spi_probe(struct spi_device *spi)
>>
>>          ret = p54spi_request_eeprom(hw);
>>          if (ret)
>> -               goto err_free_common;
>> +               goto err_release_firmaware;
>>
>>          ret = p54_register_common(hw, &priv->spi->dev);
>>          if (ret)
>> -               goto err_free_common;
>> +               goto err_release_firmaware;
>>
>>          return 0;
>>
>> +err_release_firmaware:
>> +       release_firmware(priv->firmware);
>>   err_free_common:
>>          free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
>>   err_free_gpio_irq:
>> --
>> 2.34.1
>>
> 

