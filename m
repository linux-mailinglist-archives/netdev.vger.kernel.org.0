Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78D8393B69
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhE1CbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhE1CbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 22:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622168975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMuJ8q06mrCYv6hzahz85RH+Fvr8gwcswBsN2UNSWLU=;
        b=I/5XCGrdMWxU3OfxaC58z5cnL8NsC2aXKWqg6P69B4QKUVABaXgXJd25q//Zkw4cNxXqM3
        U0ZR4dLFM97g/R2c0Inw21yMeunivuzkaoVt9SOZobDXYlNpeBPsXVimojKwcclqcyLGyG
        fVsoncAyN0QlTNEf/UKNfHtNaF38kjc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-FVR6ISX3M7ufCxgMZKBLjg-1; Thu, 27 May 2021 22:29:34 -0400
X-MC-Unique: FVR6ISX3M7ufCxgMZKBLjg-1
Received: by mail-pf1-f197.google.com with SMTP id 64-20020a6215430000b02902df2a3e11caso1567761pfv.3
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 19:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CMuJ8q06mrCYv6hzahz85RH+Fvr8gwcswBsN2UNSWLU=;
        b=PnUG8p+/A9IQVhJndqiM5nxCr4JTJd6EhlFr3uSogQYb3Km3pL0OFELmj6lv7xdG6R
         xHfIqPz4j4t94UAXqTozJ+2Cz/K2c6HYEE7SfvdF90QqWfcwxxsS6qUFG3TM3dO6b3BR
         mEw/XMIV4VdGDq+7qc8a6sRnKBF7Ew7eqcMtT/gwXxeEtKrfkla46wg/XfXH+8XZ2jLl
         u40vzu5qkmmMUYOdQydiI3xqyNFuSLeo61q7x/tyJoFv7KQDMJdK5lRkCN+J+SWQmRQ7
         Wv6zadEAqODgMqYTER7NuCjT/sLLqU9kTa6FCsM7tWy9wtoShx+8CkqwsunazJCN3N92
         BkGA==
X-Gm-Message-State: AOAM5337hwMy3cN3ns+KS9WAoUTlpGeC+fAUBR3HMrPp4ZYtIxwv6B+b
        3Yxz3yohchPt+MkH86DGvMihXBao7U9IjB3/Ipp4N9HtiGrbxYBjQpfvEnp/ZjkrbiHNg9rtXZB
        dqayL1J2nK+RTYftw
X-Received: by 2002:a62:3001:0:b029:2e9:39d0:46cd with SMTP id w1-20020a6230010000b02902e939d046cdmr1414648pfw.47.1622168973289;
        Thu, 27 May 2021 19:29:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwG2LjhtAswj+zJgSFglJ8KxPQ4Xu38oPG3FkiTkdAMFUpdSo9/0J5Ld9zwyid4Tj8MMUqy9A==
X-Received: by 2002:a62:3001:0:b029:2e9:39d0:46cd with SMTP id w1-20020a6230010000b02902e939d046cdmr1414629pfw.47.1622168972968;
        Thu, 27 May 2021 19:29:32 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w11sm2907612pfc.79.2021.05.27.19.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 19:29:32 -0700 (PDT)
Subject: Re: [PATCH net-next] ptr_ring: make __ptr_ring_empty() checking more
 reliable
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mst@redhat.com, brouer@redhat.com
References: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
 <d2287691-1ef9-d2c4-13f6-2baf7b80d905@redhat.com>
 <25a6b73d-06ec-fe07-b34c-10fea709e055@huawei.com>
 <51bc1c38-da20-1090-e3ef-1972f28adfee@redhat.com>
 <938bdb23-4335-845d-129e-db8af2484c27@huawei.com>
 <0b64f53d-e120-f90d-bf59-bb89cceea83e@redhat.com>
 <758d89e8-3be1-25ae-9a42-cc8703ac097b@huawei.com>
 <b2eb7c0b-f3e8-bc89-1644-0d9b533af749@redhat.com>
 <a366ee9b-e3d1-0004-1fae-7f44b5708bdc@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <97021854-739a-682c-f2b6-d609dfcfa971@redhat.com>
Date:   Fri, 28 May 2021 10:29:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <a366ee9b-e3d1-0004-1fae-7f44b5708bdc@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/28 上午10:26, Yunsheng Lin 写道:
> On 2021/5/28 9:31, Jason Wang wrote:
>> 在 2021/5/27 下午5:03, Yunsheng Lin 写道:
>>> On 2021/5/27 16:05, Jason Wang wrote:
>>>> 在 2021/5/27 下午3:21, Yunsheng Lin 写道:
>>>>> On 2021/5/27 14:53, Jason Wang wrote:
>>>>>> 在 2021/5/27 下午2:07, Yunsheng Lin 写道:
>>>>>>> On 2021/5/27 12:57, Jason Wang wrote:
>>>>>>>> 在 2021/5/26 下午8:29, Yunsheng Lin 写道:
>>>>>>>>> Currently r->queue[] is cleared after r->consumer_head is moved
>>>>>>>>> forward, which makes the __ptr_ring_empty() checking called in
>>>>>>>>> page_pool_refill_alloc_cache() unreliable if the checking is done
>>>>>>>>> after the r->queue clearing and before the consumer_head moving
>>>>>>>>> forward.
>>>>>>>>>
>>>>>>>>> Move the r->queue[] clearing after consumer_head moving forward
>>>>>>>>> to make __ptr_ring_empty() checking more reliable.
>>>>>>>> If I understand this correctly, this can only happens if you run __ptr_ring_empty() in parallel with ptr_ring_discard_one().
>>>>>>> Yes.
>>>>>>>
>>>>>>>> I think those two needs to be serialized. Or did I miss anything?
>>>>>>> As the below comment in __ptr_ring_discard_one, if the above is true, I
>>>>>>> do not think we need to keep consumer_head valid at all times, right?
>>>>>>>
>>>>>>>
>>>>>>>        /* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>>>>>>>         * to work correctly.
>>>>>>>         */
>>>>>> I'm not sure I understand. But my point is that you need to synchronize the __ptr_ring_discard_one() and __ptr_empty() as explained in the comment above __ptr_ring_empty():
>>>>> I am saying if __ptr_ring_empty() and __ptr_ring_discard_one() is
>>>>> always serialized, then it seems that the below commit is unnecessary?
>>>> Just to make sure we are at the same page. What I really meant is "synchronized" not "serialized". So they can be called at the same time but need synchronization.
>>>>
>>>>
>>>>> 406de7555424 ("ptr_ring: keep consumer_head valid at all times")
>>>> This still needed in this case.
>>>>
>>>>
>>>>>> /*
>>>>>>     * Test ring empty status without taking any locks.
>>>>>>     *
>>>>>>     * NB: This is only safe to call if ring is never resized.
>>>>>>     *
>>>>>>     * However, if some other CPU consumes ring entries at the same time, the value
>>>>>>     * returned is not guaranteed to be correct.
>>>>>>     *
>>>>>>     * In this case - to avoid incorrectly detecting the ring
>>>>>>     * as empty - the CPU consuming the ring entries is responsible
>>>>>>     * for either consuming all ring entries until the ring is empty,
>>>>>>     * or synchronizing with some other CPU and causing it to
>>>>>>     * re-test __ptr_ring_empty and/or consume the ring enteries
>>>>>>     * after the synchronization point.
>>>>> I am not sure I understand "incorrectly detecting the ring as empty"
>>>>> means, is it because of the data race described in the commit log?
>>>> It means "the ring might be empty but __ptr_ring_empty() returns false".
>>> But the ring might be non-empty but __ptr_ring_empty() returns true
>>> for the data race described in the commit log:)
>>
>> Which commit log?
> this commit log.
> If the data race described in this commit log happens, the ring might be
> non-empty, but __ptr_ring_empty() returns true.
>
>
>>
>>>>> Or other data race? I can not think of other data race if consuming
>>>>> and __ptr_ring_empty() is serialized:)
>>>>>
>>>>> I am agreed that __ptr_ring_empty() checking is not totally reliable
>>>>> without taking r->consumer_lock, that is why I use "more reliable"
>>>>> in the title:)
>>>> Is __ptr_ring_empty() synchronized with the consumer in your case? If yes, have you done some benchmark to see the difference?
>>>>
>>>> Have a look at page pool, this only helps when multiple refill request happens in parallel which can make some of the refill return early if the ring has been consumed.
>>>>
>>>> This is the slow-path and I'm not sure we see any difference. If one the request runs faster then the following request will go through the fast path.
>>> Yes, I am agreed there may not be any difference.
>>> But it is better to make it more reliable, right?
>>
>> No, any performance optimization must be benchmark to show obvious difference to be accepted.
>>
>> ptr_ring has been used by various subsystems so we should not risk our self-eves to accept theoretical optimizations.
> As a matter of fact, I am not treating it as a performance optimization for this patch.
> I treated it as improvement for the checking of __ptr_ring_empty().
> But you are right that we need to ensure there is not performance regression when improving
> it.
>
> Any existing and easy-to-setup testcase to benchmark the ptr_ring performance?


You probably can start with a simple test in:

tools/virtio/ringtest/ptr_ring.c

Thanks


>
>>
>>>> If it really helps, can we do it more simpler by:
>>>>
>

