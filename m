Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F42347EEF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhCXRKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237489AbhCXRJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:09:57 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6521DC0613BD
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 10:07:30 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id u10so22014288ilb.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 10:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6DN4TKzVMHLbsDci9dBkcAM0aIpThQJXNnWpGIAbGlM=;
        b=BixSbChJOh7tqog1NiBEy4XpTXU6z9qabBOn5XKDd7Czp9PiUljcH1qXqlqbpKf+JF
         XZIRk9ivLe/yUNcr6LVZm8lXXEH/EpJrozLd31E/6vlRmOZ5ZDTNNPkMUv25vJHz2jSv
         3x0DowRa9c95sAvOKHrqNK6822AJ7Tv95nou0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6DN4TKzVMHLbsDci9dBkcAM0aIpThQJXNnWpGIAbGlM=;
        b=CpBKJmzvsufLo7PMR5680JcwVGiwSwNgQcYUTjMmi4UcQcjxguVI8fjrbiid2fPSms
         VnTboS79x3j/3S/Vad287jPxXazawdK1lI+PlqfB5m+FYcreYDf02VPITZFeVIap1rBW
         36cYt/98P6KnipJLQmQ1tMhUwdhMWLnL62GIfhkdEYasoxzePWajrLwZy5NLaWavt+HW
         Guj9CVmUUHoYWYO9RtFVDCUOngQOHDqWRfnMDp+B5EMgNjDUMYNsspThx6sCSdYnE0ft
         4ZqTq5yzXMnB5xDQE7MJJcmjaZzh4iezlJCC9bXU/I1tXJvjfjmlWximsqROHqWH+gUE
         nY0g==
X-Gm-Message-State: AOAM532a8PzmTH/eW2CMdXe9Yu9a3502sWsHqhZlL7jgbnvzmRBk/vEj
        6ddV6hMbJsM3FLRe4BIOCUAs+YyCn3kPOWme
X-Google-Smtp-Source: ABdhPJzDRxca/4uFW98J12ak5RJBZNSQHUArVAUJUITgtcSHarjY3f9d+lWcBAL4Lnw9XFwMWbOVxQ==
X-Received: by 2002:a05:6e02:4b2:: with SMTP id e18mr2777811ils.42.1616605649783;
        Wed, 24 Mar 2021 10:07:29 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b15sm1390660ilm.25.2021.03.24.10.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 10:07:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipa: avoid 64-bit modulus
To:     David Laight <David.Laight@ACULAB.COM>,
        'Alex Elder' <elder@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210323010505.2149882-1-elder@linaro.org>
 <f77f12f117934e9d9e3b284ed37e87a7@AcuMS.aculab.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <fea8c425-2af0-0526-4ad7-73c523253e08@ieee.org>
Date:   Wed, 24 Mar 2021 12:07:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f77f12f117934e9d9e3b284ed37e87a7@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 11:27 AM, David Laight wrote:
> From: Alex Elder
>> Sent: 23 March 2021 01:05
>> It is possible for a 32 bit x86 build to use a 64 bit DMA address.
>>
>> There are two remaining spots where the IPA driver does a modulo
>> operation to check alignment of a DMA address, and under certain
>> conditions this can lead to a build error on i386 (at least).
>>
>> The alignment checks we're doing are for power-of-2 values, and this
>> means the lower 32 bits of the DMA address can be used.  This ensures
>> both operands to the modulo operator are 32 bits wide.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/gsi.c       | 11 +++++++----
>>   drivers/net/ipa/ipa_table.c |  9 ++++++---
>>   2 files changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
>> index 7f3e338ca7a72..b6355827bf900 100644
>> --- a/drivers/net/ipa/gsi.c
>> +++ b/drivers/net/ipa/gsi.c
>> @@ -1436,15 +1436,18 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
>>   /* Initialize a ring, including allocating DMA memory for its entries */
>>   static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
>>   {
>> -	size_t size = count * GSI_RING_ELEMENT_SIZE;
>> +	u32 size = count * GSI_RING_ELEMENT_SIZE;
>>   	struct device *dev = gsi->dev;
>>   	dma_addr_t addr;
>>
>> -	/* Hardware requires a 2^n ring size, with alignment equal to size */
>> +	/* Hardware requires a 2^n ring size, with alignment equal to size.
>> +	 * The size is a power of 2, so we can check alignment using just
>> +	 * the bottom 32 bits for a DMA address of any size.
>> +	 */
>>   	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
> 
> Doesn't dma_alloc_coherent() guarantee that alignment?
> I doubt anywhere else checks?

I normally wouldn't check something like this if it
weren't guaranteed.  I'm not sure why I did it here.

I see it's "guaranteed to be aligned to the smallest
PAGE_SIZE order which is greater than or equal to
the requested size."  So I think the answer to your
question is "yes, it does guarantee that."

I'll make a note to remove this check in a future
patch, and will credit you with the suggestion.

Thanks.

					-Alex

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

