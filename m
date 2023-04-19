Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D886E7E72
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjDSPhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjDSPhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:37:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393385BB2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681918585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIFkJO8F3gxDTUR0SCeVeDhVp6dxAGrc4eSzBRpzmxM=;
        b=IZRcMOFCLg4Yt0GxKcuGZr4/G5Ixi7fhipqJpDnyttVNPiqg/DIkO6cJA86q43jxEXLGZs
        t5ZpIqHaf3izw7EksPvVHZPovq4M2Es941tsDY7rwjBzdQM1m8fWpFeIxwjHVmSt+/e4A2
        Nam3V3rKesZBdF+SDmAScj2wSkH2Pco=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-PEfRqxdtNG6mX1fl5dcLgg-1; Wed, 19 Apr 2023 11:36:24 -0400
X-MC-Unique: PEfRqxdtNG6mX1fl5dcLgg-1
Received: by mail-ej1-f70.google.com with SMTP id j9-20020a170906278900b0094807746cebso4488995ejc.6
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681918583; x=1684510583;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fIFkJO8F3gxDTUR0SCeVeDhVp6dxAGrc4eSzBRpzmxM=;
        b=i2JgLfXep6cuDv5GDL9hhBrvcL8ZYKkbmPI6Fj2Pvvwhz5P8tojD4/JRzxVh6oCKWM
         fpoo6vWAB5p+lWBKia5u8DnVQ1c02QmW0zAd2LLSyxC57YsHF4GiSwF7JDY/F1+k+oLl
         nPrJ+0ZepAd1JhM5EazPQSr8eGCM+r5SwaypqqcHYcmEpbYlruPgLkpP8u5Uzv61or/Z
         +wui7WlCVd+dPBSLG3l1o2vc51Hg5xgjQQ8sUmuHAKBmlCOPB/4e0nmhpOcLA/pZGM0w
         2UkbwamfGj1FA60t0MM4L3GMBEq8AG0M9qdsJ8vI0rHo9f4jbEs0jj77dbtpI8VqVU9c
         Xj4Q==
X-Gm-Message-State: AAQBX9ejJy3Wex7FeXlLOCn/ixRBCJRhzB70Rq96iowV7OA9zSrjtl0q
        QONYS0tE9W5A7mcJZIKQyHlllOOTLSrz7t87cj2vDen4s0g6RbLTc8m/mCituUpoRUd0NwygaUx
        oLIwSNFEunMW+ehyfRISU0S1l
X-Received: by 2002:a17:907:7205:b0:953:5eb4:fe45 with SMTP id dr5-20020a170907720500b009535eb4fe45mr2427074ejc.23.1681918583222;
        Wed, 19 Apr 2023 08:36:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZBQ5s+OgzrOcqMXLOUyFaCmtlR2FfGKPP5XiTTHHwEPersR2eRqKFD1+tiyU1rwcXv7HSlkQ==
X-Received: by 2002:a17:907:7205:b0:953:5eb4:fe45 with SMTP id dr5-20020a170907720500b009535eb4fe45mr2427045ejc.23.1681918582754;
        Wed, 19 Apr 2023 08:36:22 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id hv14-20020a17090760ce00b0095251a3d66fsm2431837ejc.119.2023.04.19.08.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 08:36:22 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com>
Date:   Wed, 19 Apr 2023 17:36:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: issue with inflight pages from page_pool
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <ZD2NSSYFzNeN68NO@lore-desk> <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk> <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk> <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk>
 <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
 <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
 <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
 <ZD/4/npAIvS1Co6e@lore-desk>
In-Reply-To: <ZD/4/npAIvS1Co6e@lore-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/04/2023 16.21, Lorenzo Bianconi wrote:
>>
>> On 19/04/2023 14.09, Eric Dumazet wrote:
>>> On Wed, Apr 19, 2023 at 1:08 PM Jesper Dangaard Brouer
>>>>
>>>>
>>>> On 18/04/2023 09.36, Lorenzo Bianconi wrote:
>>>>>> On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
>>>>>>>> If it's that then I'm with Eric. There are many ways to keep the pages
>>>>>>>> in use, no point working around one of them and not the rest :(
>>>>>>>
>>>>>>> I was not clear here, my fault. What I mean is I can see the returned
>>>>>>> pages counter increasing from time to time, but during most of tests,
>>>>>>> even after 2h the tcp traffic has stopped, page_pool_release_retry()
>>>>>>> still complains not all the pages are returned to the pool and so the
>>>>>>> pool has not been deallocated yet.
>>>>>>> The chunk of code in my first email is just to demonstrate the issue
>>>>>>> and I am completely fine to get a better solution :)
>>>>>>
>>>>>> Your problem is perhaps made worse by threaded NAPI, you have
>>>>>> defer-free skbs sprayed across all cores and no NAPI there to
>>>>>> flush them :(
>>>>>
>>>>> yes, exactly :)
>>>>>
>>>>>>
>>>>>>> I guess we just need a way to free the pool in a reasonable amount
>>>>>>> of time. Agree?
>>>>>>
>>>>>> Whether we need to guarantee the release is the real question.
>>>>>
>>>>> yes, this is the main goal of my email. The defer-free skbs behaviour seems in
>>>>> contrast with the page_pool pending pages monitor mechanism or at least they
>>>>> do not work well together.
>>>>>
>>>>> @Jesper, Ilias: any input on it?
>>>>>
>>>>>> Maybe it's more of a false-positive warning.
>>>>>>
>>>>>> Flushing the defer list is probably fine as a hack, but it's not
>>>>>> a full fix as Eric explained. False positive can still happen.
>>>>>
>>>>> agree, it was just a way to give an idea of the issue, not a proper solution.
>>>>>
>>>>> Regards,
>>>>> Lorenzo
>>>>>
>>>>>>
>>>>>> I'm ambivalent. My only real request wold be to make the flushing
>>>>>> a helper in net/core/dev.c rather than open coded in page_pool.c.
>>>>
>>>> I agree. We need a central defer_list flushing helper
>>>>
>>>> It is too easy to say this is a false-positive warning.
>>>> IHMO this expose an issue with the sd->defer_list system.
>>>>
>>>> Lorenzo's test is adding+removing veth devices, which creates and runs
>>>> NAPI processing on random CPUs.  After veth netdevices (+NAPI) are
>>>> removed, nothing will naturally invoking net_rx_softirq on this CPU.
>>>> Thus, we have SKBs waiting on CPUs sd->defer_list.  Further more we will
>>>> not create new SKB with this skb->alloc_cpu, to trigger RX softirq IPI
>>>> call (trigger_rx_softirq), even if this CPU process and frees SKBs.
>>>>
>>>> I see two solutions:
>>>>
>>>>     (1) When netdevice/NAPI unregister happens call defer_list flushing
>>>> helper.
>>>>
>>>>     (2) Use napi_watchdog to detect if defer_list is (many jiffies) old,
>>>> and then call defer_list flushing helper.
>>>>
>>>>
>>>>>>
>>>>>> Somewhat related - Eric, do we need to handle defer_list in dev_cpu_dead()?
>>>>
>>>> Looks to me like dev_cpu_dead() also need this flushing helper for
>>>> sd->defer_list, or at least moving the sd->defer_list to an sd that will
>>>> run eventually.
>>>
>>> I think I just considered having a few skbs in per-cpu list would not
>>> be an issue,
>>> especially considering skbs can sit hours in tcp receive queues.
>>>
>>
>> It was the first thing I said to Lorenzo when he first reported the
>> problem to me (over chat): It is likely packets sitting in a TCP queue.
>> Then I instructed him to look at output from netstat to see queues and
>> look for TIME-WAIT, FIN-WAIT etc.
>>
>>
>>> Do we expect hacing some kind of callback/shrinker to instruct TCP or
>>> pipes to release all pages that prevent
>>> a page_pool to be freed ?
>>>
>>
>> This is *not* what I'm asking for.
>>
>> With TCP sockets (pipes etc) we can take care of closing the sockets
>> (and programs etc) to free up the SKBs (and perhaps wait for timeouts)
>> to make sure the page_pool shutdown doesn't hang.
>>
>> The problem arise for all the selftests that uses veth and bpf_test_run
>> (using bpf_test_run_xdp_live / xdp_test_run_setup).  For the selftests
>> we obviously take care of closing sockets and removing veth interfaces
>> again.  Problem: The defer_list corner-case isn't under our control.
>>
>>
>>> Here, we are talking of hundreds of thousands of skbs, compared to at
>>> most 32 skbs per cpu.
>>>
>>
>> It is not a memory usage concern.
>>
>>> Perhaps sets sysctl_skb_defer_max to zero by default, so that admins
>>> can opt-in
>>>
>>
>> I really like the sd->defer_list system and I think is should be enabled
>> by default.  Even if disabled by default, we still need to handle these
>> corner cases, as the selftests shouldn't start to cause-issues when this
>> gets enabled.
>>
>> The simple solution is: (1) When netdevice/NAPI unregister happens call
>> defer_list flushing helper.  And perhaps we also need to call it in
>> xdp_test_run_teardown().  How do you feel about that?
>>
>> --Jesper
>>
> 
> Today I was discussing with Toke about this issue, and we were wondering,
> if we just consider the page_pool use-case, what about moving the real pool
> destroying steps when we return a page to the pool in page_pool_put_full_page()
> if the pool has marked to be destroyed and there are no inflight pages instead
> of assuming we have all the pages in the pool when we run page_pool_destroy()?

It sounds like you want to add a runtime check to the fast-path to
handle these corner cases?

For performance reason we should not call page_pool_inflight() check in 
fast-path, please!

Details: You hopefully mean running/calling page_pool_release(pool) and 
not page_pool_destroy().

I'm not totally against the idea, as long as someone is willing to do
extensive benchmarking that it doesn't affect fast-path performance.
Given we already read pool->p.flags in fast-path, it might be possible
to hide the extra branch (in the CPU pipeline).


> Maybe this means just get rid of the warn in page_pool_release_retry() :)
> 

Sure, we can remove the print statement, but it feels like closing our
eyes and ignoring the problem.  We can remove the print statement, and
still debug the problem, as I have added tracepoints (to debug this).
But users will not report these issue early... on the other hand most of
these reports will likely be false-positives.

This reminds me that Jakub's recent defer patches returning pages
'directly' to the page_pool alloc-cache, will actually result in this
kind of bug.  This is because page_pool_destroy() assumes that pages
cannot be returned to alloc-cache, as driver will have "disconnected" RX
side.  We need to address this bug separately.  Lorenzo you didn't
happen to use a kernel with Jakub's patches included, do you?

--Jesper



