Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115F1AC927
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442446AbgDPPT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504391AbgDPPTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 11:19:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F3DC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 08:19:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g6so1771609pgs.9
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U7K24gXeIPWS1w0vDNTjBMrSJLP+Y/VYjZWfEiiiLh4=;
        b=d+VYsx3u9qmo82wp9jsqbBN3zox3PlUodFbo8y910ffdaL6hOwIK6+9N08Bi0bhIly
         WfPqOrcqyBZNQ5S93p9p68BEnzccXxJh60UneFRrmpOtXTx7or7YEXr1hZEEdTvpykxz
         Pwp/sydOoBVeUESqSac4aInr2afz9sN/CeuI+p+Q40Y7KTMKWUzyD80BssRjf0ozgVbu
         SAqZOrWXjbPnqyXEadUyr5ehxXW+tLbLqw4PQXfBCC0jW47r8c2hLo296zpcg+wWBBQ9
         xgVB1t3dHnJ/CRlkBW9mVOCTu6INHrt9MIuAzlblIx6QFJB3UKO3uH7m6SWwTU6sPNT8
         qZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U7K24gXeIPWS1w0vDNTjBMrSJLP+Y/VYjZWfEiiiLh4=;
        b=PEqKRzll+MbHMweKH6ZRxKZLTIeeJhuQEJWS1wY6ahRw9XDEl5XQdqOUP1qjxR2etY
         qgRMbVTQZaMe5yBRV3mKCgmkFCCLUWxDDPYC3HXDyclccUbGIjEi2Gfn0SNY3UOLqsok
         k4BeSBrYfe3Kudhf7eyym68RSRQiERScHqD7v2nvYOcA4mCZ1HIDdzriKZfZeuvEcx5D
         McD/Z0y8bBeU3m+EhfBuXRaRR7A4+p23kSlIOOnV20hgHUiGy5VJ/mPurWeRofubqCl7
         RXAJmoyKrtEbiK6EPl62Oyosc65NerzIY4xFuVraxyooOsjxcxYoBXXFpFcuSFNtEPIb
         +WoA==
X-Gm-Message-State: AGi0PuYsKiBJ1toZHc3yUSFg6kVvng5DkRLh9KNSSXtvoDOnyUqxwH5+
        A45KA4YeIEFAHpwLWrfr0Nk=
X-Google-Smtp-Source: APiQypIiaRHUeX13464zP/HTH/jwtKraet2JCWi8whGJUS3t0pm6sq3sKOav3zVyU6lAiEaH6BD74g==
X-Received: by 2002:a62:1584:: with SMTP id 126mr26936155pfv.185.1587050362123;
        Thu, 16 Apr 2020 08:19:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id ml24sm2659204pjb.48.2020.04.16.08.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 08:19:21 -0700 (PDT)
Subject: Re: [PATCH net 1/2] amd-xgbe: Use __napi_schedule() in BH context
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-2-bigeasy@linutronix.de>
 <9c632f8c-96a5-bb01-bac5-6aa0be58166a@amd.com>
 <20200416135202.txc5kwibczh5vl4c@linutronix.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <788f3b66-de61-bc11-a06f-3084c1937cf1@gmail.com>
Date:   Thu, 16 Apr 2020 08:19:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416135202.txc5kwibczh5vl4c@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/20 6:52 AM, Sebastian Andrzej Siewior wrote:
> On 2019-12-02 11:19:00 [-0600], Tom Lendacky wrote:
>> On 11/26/19 4:20 PM, Sebastian Andrzej Siewior wrote:
>>> The driver uses __napi_schedule_irqoff() which is fine as long as it is
>>> invoked with disabled interrupts by everybody. Since the commit
>>> mentioned below the driver may invoke xgbe_isr_task() in tasklet/softirq
>>> context. This may lead to list corruption if another driver uses
>>> __napi_schedule_irqoff() in IRQ context.
>>>
>>> Use __napi_schedule() which safe to use from IRQ and softirq context.
>>>
>>> Fixes: 85b85c853401d ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>
>> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> *ping*
> This still applies and is independent of the conversation in 2/2.

Then resend this patch alone, including the Acked-by you collected so far.

Thanks.

> 
>>> ---
>>>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
>>> index 98f8f20331544..3bd20f7651207 100644
>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
>>> @@ -514,7 +514,7 @@ static void xgbe_isr_task(unsigned long data)
>>>  				xgbe_disable_rx_tx_ints(pdata);
>>>  
>>>  				/* Turn on polling */
>>> -				__napi_schedule_irqoff(&pdata->napi);
>>> +				__napi_schedule(&pdata->napi);
>>>  			}
>>>  		} else {
>>>  			/* Don't clear Rx/Tx status if doing per channel DMA
>>>
> 
> Sebastian
> 
