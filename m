Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2264733B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiLHPg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiLHPgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:36:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C623784B69
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670513589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=veFa/Wi52YvjG2I5lacfp9qTDhL6U2v2sBr7NJtbIyE=;
        b=b9YZiQCUFwh4hw0OAAlUZ5f3e/SERghtfuUQ5Ktki6KI3IeZB/bUA8BJ+9kojEZP0wKlAV
        +uVtzUYIePVSczDa+Hgu6Mkh/WfgmIAKVS2IvWkI6WuWUV+WHdBMcSe81RIhdcqsHHkWyl
        KisBg/bXmraIO3lhEqU+4nMUUE9IZvg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-TlhYUdE_PTa79MKV0p_sQA-1; Thu, 08 Dec 2022 10:33:05 -0500
X-MC-Unique: TlhYUdE_PTa79MKV0p_sQA-1
Received: by mail-ed1-f71.google.com with SMTP id t4-20020a056402524400b004620845ba7bso1121753edd.4
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 07:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=veFa/Wi52YvjG2I5lacfp9qTDhL6U2v2sBr7NJtbIyE=;
        b=8R/avDB+Ogoyjs9kPjqTzHq7OkAFcFOj3GnyTHf4TSBClBBkS7U1PXlkt4eimR0wCz
         v0KWYx3h5Z/woJHsObpYGiJokYIXKd0rm0hetemL9kFCjW1GviWiGFvyIprHJXHhAoMb
         zfk2lK7F1dU4lOgSJexWbRsnvsHLzXhW3eEBMC4VI9iqXlI9cvYm8mO2dt4X5TvlO/2+
         CytcSmBkgJQqz7SiJF7Due7KgCEPPeZ8hG23PnAjKGzS0Hom390/9sgeYsu/uIbuwj1e
         Bm+pXNVCxyq7DAragO16qyCeViu5m0DocztCS1icSly3Q5DZQl+bwtx4ZIuMXXl+Qmzo
         aJcg==
X-Gm-Message-State: ANoB5pmFUoh/K+OdEUxBVBIOqLUFZwVxULJX/53z8oLMCTBxqfioXFoD
        83wArs3T14Fl3Fo0aLEXG8jv1ybK7bYwZuO2ozBKv8NKwAUVlNDKYGxa+pdvsxP0A+BOoZUArez
        BQYm8T/bhOOw0elvq
X-Received: by 2002:a05:6402:3224:b0:46c:d2a3:76b3 with SMTP id g36-20020a056402322400b0046cd2a376b3mr3178638eda.14.1670513584660;
        Thu, 08 Dec 2022 07:33:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7q+zecuU1okPpu/XXxrQMV+ikyMSinHIewJwmedRM/A8FTYptz3/OWz8lyC3iQV3SffydjhA==
X-Received: by 2002:a05:6402:3224:b0:46c:d2a3:76b3 with SMTP id g36-20020a056402322400b0046cd2a376b3mr3178617eda.14.1670513584409;
        Thu, 08 Dec 2022 07:33:04 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id f8-20020a056402150800b0046146c730easm3491739edw.75.2022.12.08.07.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 07:33:03 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <9e9af4ec-9bd2-8b10-c95a-4272442cb926@redhat.com>
Date:   Thu, 8 Dec 2022 16:33:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/24] Split page pools from struct page
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20221130220803.3657490-1-willy@infradead.org>
 <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
 <Y44c1KKE797U3kCM@casper.infradead.org>
 <7cfbcde0-9d17-0a89-49ae-942a80c63feb@redhat.com>
 <Y49o8e6F5SP4h+wF@casper.infradead.org>
In-Reply-To: <Y49o8e6F5SP4h+wF@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/12/2022 17.08, Matthew Wilcox wrote:
> On Tue, Dec 06, 2022 at 10:43:05AM +0100, Jesper Dangaard Brouer wrote:
>>
>> On 05/12/2022 17.31, Matthew Wilcox wrote:
>>> On Mon, Dec 05, 2022 at 04:34:10PM +0100, Jesper Dangaard Brouer wrote:
>>>> I have a micro-benchmark [1][2], that I want to run on this patchset.
>>>> Reducing the asm code 'text' size is less likely to improve a
>>>> microbenchmark. The 100Gbit mlx5 driver uses page_pool, so perhaps I can
>>>> run a packet benchmark that can show the (expected) performance improvement.
>>>>
>>>> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
>>>> [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
>>>
>>> Appreciate it!  I'm not expecting any performance change outside noise,
>>> but things do surprise me.  I'd appreciate it if you'd test with a
>>> "distro" config, ie enabling CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
>>> we show the most expensive case.

I've tested with [1] and [2] and the performance numbers are the same.

Microbench [1] is easiest to compare, and numbers below were basically
same for both with+without patchset.

  Type:tasklet_page_pool01_fast_path Per elem: 16 cycles(tsc) 4.484 ns
  Type:tasklet_page_pool02_ptr_ring Per elem: 47 cycles(tsc) 13.147 ns
  Type:tasklet_page_pool03_slow Per elem: 173 cycles(tsc) 48.278 ns

The last line (with 173 cycles) is then pages are not recycled, but 
instead returned back into systems page allocator.  To related this to 
something, allocating order-0 pages via normal page allocator API costs 
approx 282 cycles(tsc) 78.385 ns on this system (with .config).  I 
believe page_pool is faster, because we leverage the bulk page allocator.

--Jesper

