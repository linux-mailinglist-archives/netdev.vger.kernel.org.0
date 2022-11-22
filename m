Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5813633583
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiKVGx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiKVGx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:53:56 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A41FCFE;
        Mon, 21 Nov 2022 22:53:52 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bp15so22167305lfb.13;
        Mon, 21 Nov 2022 22:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2cHp4iYGBhNZ7ols5/nSFoOCIbG4xpN5y56IiBK/Bwk=;
        b=G3jvZMTQo3WJGHVxI3Qt62L+7tVnmL3Y9vYWOj6EgwgakMXR2clqrkqQivpel8rXXR
         h3hajXWP0pIrRy4M0Pd43olk/34OXH8LmajlRA387K3FLZitYqtzgnEoUieWiRJv9zK/
         P5KlK7hUaNKdhCrJgcXTeP9sF69va4i3ZjTgXw2wtY2FBFE0Fqle9FajVve2KRjnFFPW
         3WGr9x7S1gFGX9HwnzeRBcfGAFoaFolma9XZoMUWse5RjPAtv22LbaobyQ5ytKm0MiSA
         XdSQWL5+cibjj+w7FFU1cQZdTHB2UZV5uBRF+ZqJeSCm3rkj0L2E46OLHHWBI1UUwcRH
         QDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cHp4iYGBhNZ7ols5/nSFoOCIbG4xpN5y56IiBK/Bwk=;
        b=nTmZxZeMTVGRvsSGR6CxgIF7Ay/f6nQVM5+/t405DWWoEal/WTArUiV1ExifmKW45b
         239Whjy5Kg6whAUiXXmBv4M1FuiA8YB4x6ehIfxfJ3a+Fzo1OUnoaKyYarvlYl4AnstP
         H7dZg8UwF0fsJJx+gBBm5cEEq3hHP1+O0MlL5AlCJ2KOJojKSlqI09bOEl0IVnBVov2Z
         U8kNJN7qwk8pfBPgf3xANuwqsLxWmV+pXLv7KydGwqdzaYGNv6eYUuWjfdAA6TNu+L0j
         k7y7qazgtU6UbweGYHc/llCQatS6c0s+VhEBgx8f8aq6zq5CaCOr4pceVfcUa22c+ny0
         7RHw==
X-Gm-Message-State: ANoB5pnJ2z9ravEidRjTcziPL9BaSC3MBp5NCQKz1tVzhgtmkkImo6gA
        zbXiGC+PbeWvZMM74HHji7I=
X-Google-Smtp-Source: AA0mqf51AXMYmBrdd40glZeehsmW+sFvS3V4FBkedQwM7q0JIEff7f1vOBh1/Uc1vCatXNBDcJPXmA==
X-Received: by 2002:ac2:4201:0:b0:4b1:7c15:e923 with SMTP id y1-20020ac24201000000b004b17c15e923mr857756lfh.320.1669100030936;
        Mon, 21 Nov 2022 22:53:50 -0800 (PST)
Received: from [172.25.56.57] ([212.22.67.162])
        by smtp.gmail.com with ESMTPSA id j12-20020a05651231cc00b0048a934168c0sm2341905lfe.35.2022.11.21.22.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 22:53:50 -0800 (PST)
Message-ID: <05af120a-6a72-9181-27b8-ca566990dc3a@gmail.com>
Date:   Tue, 22 Nov 2022 09:53:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Content-Language: en-US
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
References: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
 <Y3uGyrxeSbajJqpr@lunn.ch>
 <20221121150314.393682-1-alexandr.lobakin@intel.com>
 <CO1PR11MB5089CE1CCC215FF180724D10D60A9@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
In-Reply-To: <CO1PR11MB5089CE1CCC215FF180724D10D60A9@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, I'll replace cast to macro in patch V2

On 22.11.2022 00:30, Keller, Jacob E wrote:
> 
> 
>> -----Original Message-----
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Sent: Monday, November 21, 2022 7:03 AM
>> To: Andrew Lunn <andrew@lunn.ch>
>> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Maxim Korotkov
>> <korotkov.maxim.s@gmail.com>; David S. Miller <davem@davemloft.net>; Eric
>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
>> Abeni <pabeni@redhat.com>; Guangbin Huang
>> <huangguangbin2@huawei.com>; Tom Rix <trix@redhat.com>; Marco Bonelli
>> <marco@mebeim.net>; Edward Cree <ecree@solarflare.com>;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; lvc-
>> project@linuxtesting.org
>> Subject: Re: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
>>
>> From: Andrew Lunn <andrew@lunn.ch>
>> Date: Mon, 21 Nov 2022 15:10:18 +0100
>>
>>> On Mon, Nov 21, 2022 at 10:56:18AM +0300, Maxim Korotkov wrote:
>>>> The value of an arithmetic expression "n * id.data" is subject
>>>> to possible overflow due to a failure to cast operands to a larger data
>>>> type before performing arithmetic. Added cast of first operand to u64
>>>> for avoiding overflow.
>>>>
>>>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>>>
>>>> Fixes: 2adc6edcaec0 ("ethtool: fix error handling in ethtool_phys_id")
>>>> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
>>>> ---
>>>>   net/ethtool/ioctl.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>>>> index 6a7308de192d..cf87e53c2e74 100644
>>>> --- a/net/ethtool/ioctl.c
>>>> +++ b/net/ethtool/ioctl.c
>>>> @@ -2007,7 +2007,7 @@ static int ethtool_phys_id(struct net_device *dev,
>> void __user *useraddr)
>>>>    } else {
>>>>            /* Driver expects to be called at twice the frequency in rc */
>>>>            int n = rc * 2, interval = HZ / n;
>>>> -         u64 count = n * id.data, i = 0;
>>>> +         u64 count = (u64)n * id.data, i = 0;
>>>
>>>
>>> How about moving the code around a bit, change n to a u64 and drop the
>>> cast? Does this look correct?
>>>
>>>              int interval = HZ / rc / 2;
>>>              u64 n = rc * 2;
>>>              u64 count = n * id.data;
>>>
>>>              i = 0;
>>>
>>> I just don't like casts, they suggest the underlying types are wrong,
>>> so should fix that, not add a cast.
>>
>> This particular one is absolutely fine. When you want to multiply
>> u32 by u32, you always need a cast, otherwise the result will be
>> truncated. mul_u32_u32() does it the very same way[0].
>>
> 
> Why not just use mul_u32_u32 then?
> 
> Thanks,
> Jake
> 
>>>
>>>      Andrew
>>>
>>
>> [0] https://elixir.bootlin.com/linux/v6.1-
>> rc6/source/include/linux/math64.h#L153
>>
>> Thanks,
>> Olek
