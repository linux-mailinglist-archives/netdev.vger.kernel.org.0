Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD27D589BFC
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 14:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiHDM47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 08:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiHDM46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 08:56:58 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71160DAA;
        Thu,  4 Aug 2022 05:56:57 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5394222247;
        Thu,  4 Aug 2022 14:56:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1659617815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaEDWcu+4coERTQ4F5Dn8hy3E8UM6SKbLO+tkYltEpE=;
        b=cFh7tAFpSF9d8F79yKAJsB4ToWAtUEvxL/XqU0lN3iG/XxXe+D0x1+7TwJlag/AQnXPN/w
        WnJnApeKb8WYxWlVcXbAL93wY9D8Qu9IOddsETnV4tCrQeGqMrMF0ftmHJrozstf3p5c8W
        IZjcGe2Nk9UHl4R5/ZJgsQwXsMJBGBQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 04 Aug 2022 14:56:55 +0200
From:   Michael Walle <michael@walle.cc>
To:     Ajay.Kathat@microchip.com
Cc:     David.Laight@aculab.com, Claudiu.Beznea@microchip.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mwalle@kernel.org
Subject: Re: [PATCH] wilc1000: fix DMA on stack objects
In-Reply-To: <6ccf4fd8-f456-8757-288d-e8bd057eaae8@microchip.com>
References: <20220728152037.386543-1-michael@walle.cc>
 <0ed9ec85a55941fd93773825fe9d374c@AcuMS.aculab.com>
 <612ECEE6-1C05-4325-92A3-21E17EC177A9@walle.cc>
 <a7bcf24b-1343-b437-4e2e-1e707b5e3bd5@microchip.com>
 <b40636e354df866d044c07241483ff81@walle.cc>
 <6ccf4fd8-f456-8757-288d-e8bd057eaae8@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8800236c103839e7996a2d976aeada97@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-04 14:43, schrieb Ajay.Kathat@microchip.com:
> On 04/08/22 12:52, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>> the content is safe
>> 
>> Am 2022-07-29 17:39, schrieb Ajay.Kathat@microchip.com:
>>> On 29/07/22 20:28, Michael Walle wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you 
>>>> know
>>>> the content is safe
>>>> 
>>>> Am 29. Juli 2022 11:51:12 MESZ schrieb David Laight
>>>> <David.Laight@ACULAB.COM>:
>>>>> From: Michael Walle
>>>>>> Sent: 28 July 2022 16:21
>>>>>> 
>>>>>> From: Michael Walle <mwalle@kernel.org>
>>>>>> 
>>>>>> Sometimes wilc_sdio_cmd53() is called with addresses pointing to 
>>>>>> an
>>>>>> object on the stack. E.g. wilc_sdio_write_reg() will call it with 
>>>>>> an
>>>>>> address pointing to one of its arguments. Detect whether the 
>>>>>> buffer
>>>>>> address is not DMA-able in which case a bounce buffer is used. The
>>>>>> bounce
>>>>>> buffer itself is protected from parallel accesses by
>>>>>> sdio_claim_host().
>>>>>> 
>>>>>> Fixes: 5625f965d764 ("wilc1000: move wilc driver out of staging")
>>>>>> Signed-off-by: Michael Walle <mwalle@kernel.org>
>>>>>> ---
>>>>>> The bug itself probably goes back way more, but I don't know if it
>>>>>> makes
>>>>>> any sense to use an older commit for the Fixes tag. If so, please
>>>>>> suggest
>>>>>> one.
>>>>>> 
>>>>>> The bug leads to an actual error on an imx8mn SoC with 1GiB of 
>>>>>> RAM.
>>>>>> But the
>>>>>> error will also be catched by CONFIG_DEBUG_VIRTUAL:
>>>>>> [    9.817512] virt_to_phys used for non-linear address:
>>>>>> (____ptrval____) (0xffff80000a94bc9c)
>>>>>> 
>>>>>>   .../net/wireless/microchip/wilc1000/sdio.c    | 28
>>>>>> ++++++++++++++++---
>>>>>>   1 file changed, 24 insertions(+), 4 deletions(-)
>>>>>> 
>>>>>> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c
>>>>>> b/drivers/net/wireless/microchip/wilc1000/sdio.c
>>>>>> index 7962c11cfe84..e988bede880c 100644
>>>>>> --- a/drivers/net/wireless/microchip/wilc1000/sdio.c
>>>>>> +++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
>>>>>> @@ -27,6 +27,7 @@ struct wilc_sdio {
>>>>>>       bool irq_gpio;
>>>>>>       u32 block_size;
>>>>>>       int has_thrpt_enh3;
>>>>>> +    u8 *dma_buffer;
>>>>>>   };
>>>>>> 
>>>>>>   struct sdio_cmd52 {
>>>>>> @@ -89,6 +90,9 @@ static int wilc_sdio_cmd52(struct wilc *wilc,
>>>>>> struct sdio_cmd52 *cmd)
>>>>>>   static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53
>>>>>> *cmd)
>>>>>>   {
>>>>>>       struct sdio_func *func = container_of(wilc->dev, struct
>>>>>> sdio_func, dev);
>>>>>> +    struct wilc_sdio *sdio_priv = wilc->bus_data;
>>>>>> +    bool need_bounce_buf = false;
>>>>>> +    u8 *buf = cmd->buffer;
>>>>>>       int size, ret;
>>>>>> 
>>>>>>       sdio_claim_host(func);
>>>>>> @@ -100,12 +104,20 @@ static int wilc_sdio_cmd53(struct wilc 
>>>>>> *wilc,
>>>>>> struct sdio_cmd53 *cmd)
>>>>>>       else
>>>>>>               size = cmd->count;
>>>>>> 
>>>>>> +    if ((!virt_addr_valid(buf) || object_is_on_stack(buf)) &&
>>>>> How cheap are the above tests?
>>>>> It might just be worth always doing the 'bounce'?
>>>> I'm not sure how cheap they are, but I don't think it costs more 
>>>> than
>>>> copying the bulk data around. That's up to the maintainer to decide.
>>> 
>>> 
>>> I think, the above checks for each CMD53 might add up to the 
>>> processing
>>> time of this function. These checks can be avoided, if we add new
>>> function similar to 'wilc_sdio_cmd53' which can be called when the
>>> local
>>> variables are used. Though we have to perform the memcpy operation
>>> which
>>> is anyway required to handle this scenario for small size data.
>>> 
>>> Mostly, either the static global data or dynamically allocated buffer
>>> is
>>> used with cmd53 except wilc_sdio_write_reg, wilc_sdio_read_reg
>>> wilc_wlan_handle_txq functions.
>>> 
>>> I have created a patch using the above approach which can fix this
>>> issue
>>> and will have no or minimal impact on existing functionality. The 
>>> same
>>> is copied below:
>>> 
>>> 
>>> ---
>>>   .../net/wireless/microchip/wilc1000/netdev.h  |  1 +
>>>   .../net/wireless/microchip/wilc1000/sdio.c    | 46
>>> +++++++++++++++++--
>>>   .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
>>>   3 files changed, 45 insertions(+), 4 deletions(-)
>>> 
>>> diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h
>>> b/drivers/net/wireless/microchip/wilc1000/netdev.h
>>> index 43c085c74b7a..2137ef294953 100644
>>> --- a/drivers/net/wireless/microchip/wilc1000/netdev.h
>>> +++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
>>> @@ -245,6 +245,7 @@ struct wilc {
>>>       u8 *rx_buffer;
>>>       u32 rx_buffer_offset;
>>>       u8 *tx_buffer;
>>> +    u32 vmm_table[WILC_VMM_TBL_SIZE];
>>> 
>>>       struct txq_handle txq[NQUEUES];
>>>       int txq_entries;
>>> diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> b/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> index 600cc57e9da2..19d4350ecc22 100644
>>> --- a/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> +++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
>>> @@ -28,6 +28,7 @@ struct wilc_sdio {
>>>       u32 block_size;
>>>       bool isinit;
>>>       int has_thrpt_enh3;
>>> +    u8 *dma_buffer;
>>>   };
>>> 
>>>   struct sdio_cmd52 {
>>> @@ -117,6 +118,36 @@ static int wilc_sdio_cmd53(struct wilc *wilc,
>>> struct sdio_cmd53 *cmd)
>>>       return ret;
>>>   }
>>> 
>>> +static int wilc_sdio_cmd53_extend(struct wilc *wilc, struct 
>>> sdio_cmd53
>>> *cmd)
>> 
>> If you handle all the stack cases anyway, the caller can just use
>> a bounce buffer and you don't need to duplicate the function.
> 
> 
> Thanks. Indeed, the duplicate function can be avoided. I will update 
> the
> patch and send modified patch for the review.
> Btw, I was trying to reproduce the warning message by enabling
> CONFIG_DEBUG_VIRTUAL config but no luck. It seems enabling the config 
> is
> not enough to test on my host or may be I am missing something.

Did you bring the interface up?

> I would
> need the help to test and confirm if the modified patch do solve the
> issue with imx8mn.

sure, just put me on cc and i can test it on my board.

-michael
