Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BBF6E7B76
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjDSODh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDSODg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8A0269D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681912972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFDw37pMwdEVptX7gUa8oxr5PahPZNxO0OFZFSpe1yY=;
        b=Yvzwv9dfs++dQ+1+WuT9MYzYnEEKtmKgPEzjSXsiAPShQCP1sviUxQLMMtqlejF9uvz5Xk
        SoiRD+ime8Khp/fxepq+dqSREEUh+V0YktdFFo+vGbJ9KZynP5+L/Qej42O10n9tEcLVeg
        snKuId5I/mhuiwK+U2DF5ktj4Vk/wD8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-KIZ0HSUWOlO06FWLQCjjkw-1; Wed, 19 Apr 2023 10:02:48 -0400
X-MC-Unique: KIZ0HSUWOlO06FWLQCjjkw-1
Received: by mail-ed1-f72.google.com with SMTP id q19-20020a50c353000000b0050683052191so8277060edb.19
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912963; x=1684504963;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFDw37pMwdEVptX7gUa8oxr5PahPZNxO0OFZFSpe1yY=;
        b=DIPYZYZ2gO4UgQU8ZpN7uIwe9HetadCdBSYzHQaXEqqiLJTA53mH9W3081d6trUWKb
         tNOdXMg8v3glVBO1Wi27ZYanLvo8vAIBfmh/AyyQ+TL7lx961Z/8PB9zX6euYYvHI0fx
         8rtPopgQX9gIedr30Tq7FwKk4/VJh2Xd7KNwqGw9YbR8EzSI3kXgEFZ0XupWd3Gauu/3
         +yufkjeQuDVewWd67mhfC1k+GZ+zjao5C7gGxWH/lfj9eNoYywKM61ldT1PYyYw5cUtC
         4gPzG3huW6GmXUPJTQOiZCDncVpm2VoR+sMJSmQX8vycWPcL8/EjCfbFKxxhK8e/9Ntf
         Re3A==
X-Gm-Message-State: AAQBX9c2gZv0B4Zvtac7kxnXH/yk6SXQH13RWcVenMz6+UtQHsYKFo2S
        P02nlVUb5HCpAIjvPFaIK8oIGH8VDV9SSU2JNKn28aZsFA4Cm0fOW8j+RFJdmlbzrKDJq0OM/oA
        QpFbc9mKxa9DXX2He
X-Received: by 2002:a17:906:6bcd:b0:94a:bd17:fc40 with SMTP id t13-20020a1709066bcd00b0094abd17fc40mr15072998ejs.25.1681912963577;
        Wed, 19 Apr 2023 07:02:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y57ZSH+O6KfQO9ncuqKKK2rj3WB193cJr9NUlWLvKbb2xUg8/Rpc1tsNgyQ0wuDzkJB9UyoQ==
X-Received: by 2002:a17:906:6bcd:b0:94a:bd17:fc40 with SMTP id t13-20020a1709066bcd00b0094abd17fc40mr15072964ejs.25.1681912963208;
        Wed, 19 Apr 2023 07:02:43 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id m7-20020a17090679c700b0094a8aa6338dsm9600103ejo.14.2023.04.19.07.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 07:02:42 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
Date:   Wed, 19 Apr 2023 16:02:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: issue with inflight pages from page_pool
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk> <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk> <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk> <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk>
 <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
 <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
In-Reply-To: <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/04/2023 14.09, Eric Dumazet wrote:
> On Wed, Apr 19, 2023 at 1:08 PM Jesper Dangaard Brouer
>>
>>
>> On 18/04/2023 09.36, Lorenzo Bianconi wrote:
>>>> On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
>>>>>> If it's that then I'm with Eric. There are many ways to keep the pages
>>>>>> in use, no point working around one of them and not the rest :(
>>>>>
>>>>> I was not clear here, my fault. What I mean is I can see the returned
>>>>> pages counter increasing from time to time, but during most of tests,
>>>>> even after 2h the tcp traffic has stopped, page_pool_release_retry()
>>>>> still complains not all the pages are returned to the pool and so the
>>>>> pool has not been deallocated yet.
>>>>> The chunk of code in my first email is just to demonstrate the issue
>>>>> and I am completely fine to get a better solution :)
>>>>
>>>> Your problem is perhaps made worse by threaded NAPI, you have
>>>> defer-free skbs sprayed across all cores and no NAPI there to
>>>> flush them :(
>>>
>>> yes, exactly :)
>>>
>>>>
>>>>> I guess we just need a way to free the pool in a reasonable amount
>>>>> of time. Agree?
>>>>
>>>> Whether we need to guarantee the release is the real question.
>>>
>>> yes, this is the main goal of my email. The defer-free skbs behaviour seems in
>>> contrast with the page_pool pending pages monitor mechanism or at least they
>>> do not work well together.
>>>
>>> @Jesper, Ilias: any input on it?
>>>
>>>> Maybe it's more of a false-positive warning.
>>>>
>>>> Flushing the defer list is probably fine as a hack, but it's not
>>>> a full fix as Eric explained. False positive can still happen.
>>>
>>> agree, it was just a way to give an idea of the issue, not a proper solution.
>>>
>>> Regards,
>>> Lorenzo
>>>
>>>>
>>>> I'm ambivalent. My only real request wold be to make the flushing
>>>> a helper in net/core/dev.c rather than open coded in page_pool.c.
>>
>> I agree. We need a central defer_list flushing helper
>>
>> It is too easy to say this is a false-positive warning.
>> IHMO this expose an issue with the sd->defer_list system.
>>
>> Lorenzo's test is adding+removing veth devices, which creates and runs
>> NAPI processing on random CPUs.  After veth netdevices (+NAPI) are
>> removed, nothing will naturally invoking net_rx_softirq on this CPU.
>> Thus, we have SKBs waiting on CPUs sd->defer_list.  Further more we will
>> not create new SKB with this skb->alloc_cpu, to trigger RX softirq IPI
>> call (trigger_rx_softirq), even if this CPU process and frees SKBs.
>>
>> I see two solutions:
>>
>>    (1) When netdevice/NAPI unregister happens call defer_list flushing
>> helper.
>>
>>    (2) Use napi_watchdog to detect if defer_list is (many jiffies) old,
>> and then call defer_list flushing helper.
>>
>>
>>>>
>>>> Somewhat related - Eric, do we need to handle defer_list in dev_cpu_dead()?
>>
>> Looks to me like dev_cpu_dead() also need this flushing helper for
>> sd->defer_list, or at least moving the sd->defer_list to an sd that will
>> run eventually.
> 
> I think I just considered having a few skbs in per-cpu list would not
> be an issue,
> especially considering skbs can sit hours in tcp receive queues.
>

It was the first thing I said to Lorenzo when he first reported the
problem to me (over chat): It is likely packets sitting in a TCP queue.
Then I instructed him to look at output from netstat to see queues and
look for TIME-WAIT, FIN-WAIT etc.


> Do we expect hacing some kind of callback/shrinker to instruct TCP or
> pipes to release all pages that prevent
> a page_pool to be freed ?
> 

This is *not* what I'm asking for.

With TCP sockets (pipes etc) we can take care of closing the sockets
(and programs etc) to free up the SKBs (and perhaps wait for timeouts)
to make sure the page_pool shutdown doesn't hang.

The problem arise for all the selftests that uses veth and bpf_test_run
(using bpf_test_run_xdp_live / xdp_test_run_setup).  For the selftests
we obviously take care of closing sockets and removing veth interfaces
again.  Problem: The defer_list corner-case isn't under our control.


> Here, we are talking of hundreds of thousands of skbs, compared to at
> most 32 skbs per cpu.
> 

It is not a memory usage concern.

> Perhaps sets sysctl_skb_defer_max to zero by default, so that admins
> can opt-in
> 

I really like the sd->defer_list system and I think is should be enabled
by default.  Even if disabled by default, we still need to handle these
corner cases, as the selftests shouldn't start to cause-issues when this
gets enabled.

The simple solution is: (1) When netdevice/NAPI unregister happens call
defer_list flushing helper.  And perhaps we also need to call it in
xdp_test_run_teardown().  How do you feel about that?

--Jesper

