Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA51D672813
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 20:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjARTVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 14:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjARTVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 14:21:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2303E5CFD7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 11:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674069599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hlCAYaT2G72BeXkyVVMdalNyyuVXDZUChmwcqT9+Go=;
        b=UBg58M1tl0kSR72dBvpOCE4jW/+WKSH+JZBIyqMZJE8K1qwhJdEE7jmQy1MKdzOde6Ocno
        EJEWwhp5XxAcAI+BjC0oL7LQYSyU/Rm2lzSFiPP6aC6MH4HWZwpYlQeRDLGXfDeDp97LNq
        BFZKzq6by8JOAuB8UxNZSkuB21780H8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-68-cUyb_lWdOT6AXGjwz2YTQw-1; Wed, 18 Jan 2023 14:19:58 -0500
X-MC-Unique: cUyb_lWdOT6AXGjwz2YTQw-1
Received: by mail-ej1-f70.google.com with SMTP id hr22-20020a1709073f9600b0086ffb73ac1cso7310551ejc.23
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 11:19:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hlCAYaT2G72BeXkyVVMdalNyyuVXDZUChmwcqT9+Go=;
        b=3H9eEibMmMuQO6uQkdLkAjCFsjo2yTU4JXj4Qv52rux7gccsPO+TmLOxlYlQPuYj7F
         WR6d1qvYwYgqCMOSkUbzuWxJtVR+6ZUE+aO76i+0jVenPvy/K4h6BgNubYKEiIKrvDEL
         f9CfMyYeIRKU0nLRmY1m6zfcoAXPF0mFTe3jXjf94M64/WbSm62tVySO6wn9JWc2Pwun
         Mf4Xm4MPTESpP/+LjVnYCBaJyqYxZqM97ur+ND7BH63iafa3xT3yUUBkG7HPMWWUhMKn
         6jVqUNH4mUWm8KTDetonurr5RoudAudoDHgh7ac0bjUzh/05SIfdy5xN0t4q23IgCy7S
         lztQ==
X-Gm-Message-State: AFqh2kqbi2pLIqBe2rgNVOVDep0zVYFw4Wv+Y0BvFsLU0Sth1IPSHP6Z
        ehaY4denkIncOf5geXTMG2UVK87moLhByAeJa8/MtPtyLJibrYZpNIdn2SvoZtziaOqTLLT71Ex
        /ax/Y+jydecbh85u5
X-Received: by 2002:a17:907:2119:b0:86e:d375:1f09 with SMTP id qn25-20020a170907211900b0086ed3751f09mr7874750ejb.67.1674069596677;
        Wed, 18 Jan 2023 11:19:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvysIf+E7hMzE6PvBn5d2KsrBDxaQCHSg5OwRlpQWslPhDx2GVSRVVGrHxgRStIKlniUDR2VQ==
X-Received: by 2002:a17:907:2119:b0:86e:d375:1f09 with SMTP id qn25-20020a170907211900b0086ed3751f09mr7874735ejb.67.1674069596520;
        Wed, 18 Jan 2023 11:19:56 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id a17-20020a170906369100b007c0f2c4cdffsm14990732ejc.44.2023.01.18.11.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 11:19:55 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <92a29ac2-d1c6-1d16-cf29-00c705870d96@redhat.com>
Date:   Wed, 18 Jan 2023 20:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: avoid irqsave in skb_defer_free_flush
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
References: <167395854720.539380.12918805302179692095.stgit@firesoul>
 <937ba89a-42e1-813c-9d1e-975b8dc9616a@intel.com>
In-Reply-To: <937ba89a-42e1-813c-9d1e-975b8dc9616a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/01/2023 20.29, Jacob Keller wrote:
> 
> On 1/17/2023 4:29 AM, Jesper Dangaard Brouer wrote:
>> The spin_lock irqsave/restore API variant in skb_defer_free_flush can
>> be replaced with the faster spin_lock irq variant, which doesn't need
>> to read and restore the CPU flags.
>>
>> Using the unconditional irq "disable/enable" API variant is safe,
>> because the skb_defer_free_flush() function is only called during
>> NAPI-RX processing in net_rx_action(), where it is known the IRQs
>> are enabled.
>>
> 
> Did you mean disabled here? If IRQs are enabled that would mean the
> interrupt could be triggered and we would need to irqsave, no?

I do mean 'enabled' in the text here.

As you can see in net_rx_action() we are allowed to perform code like:

	local_irq_disable();
	list_splice_init(&sd->poll_list, &list);
	local_irq_enable();

Disabling local IRQ without saving 'flags' and unconditionally enabling
local IRQs again.  Thus, in skb_defer_free_flush() we can do the same,
without saving 'flags'.  Hope it makes it more clear.


>> Expected gain is 14 cycles from avoiding reading and restoring CPU
>> flags in a spin_lock_irqsave/restore operation, measured via a
>> microbencmark kernel module[1] on CPU E5-1650 v4 @ 3.60GHz.
>>
>> Microbenchmark overhead of spin_lock+unlock:
>>   - spin_lock_unlock_irq     cost: 34 cycles(tsc)  9.486 ns
>>   - spin_lock_unlock_irqsave cost: 48 cycles(tsc) 13.567 ns
>>
> 
> Fairly minor change in perf, and..
> 
>> We don't expect to see a measurable packet performance gain, as
>> skb_defer_free_flush() is called infrequently once per NIC device NAPI
>> bulk cycle and conditionally only if SKBs have been deferred by other
>> CPUs via skb_attempt_defer_free().
>>
> 
> Not really measurable as its not called enough, but..
> 
>> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   net/core/dev.c |    5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index cf78f35bc0b9..9c60190fe352 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6616,17 +6616,16 @@ static int napi_threaded_poll(void *data)
>>   static void skb_defer_free_flush(struct softnet_data *sd)
>>   {
>>   	struct sk_buff *skb, *next;
>> -	unsigned long flags;
>>   
>>   	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
>>   	if (!READ_ONCE(sd->defer_list))
>>   		return;
>>   
>> -	spin_lock_irqsave(&sd->defer_lock, flags);
>> +	spin_lock_irq(&sd->defer_lock);
>>   	skb = sd->defer_list;
>>   	sd->defer_list = NULL;
>>   	sd->defer_count = 0;
>> -	spin_unlock_irqrestore(&sd->defer_lock, flags);
>> +	spin_unlock_irq(&sd->defer_lock);
>>   
> 
> It's also less code and makes it more clear what dependency this section
> has.
> 
> Seems ok to me, with the minor nit I think in the commit message:
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks for the review.
--Jesper

