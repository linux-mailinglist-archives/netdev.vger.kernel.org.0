Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89193657348
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiL1Gf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 01:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiL1GfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:35:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5717BDFD6
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672209272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKQnx3lqI8J/ywBQvDRlys+9FKkDR0+iinXdJ3yuVUY=;
        b=i8M9VTTnjFhudW2CW1Z3AZsyfjA4WtPphnmCgfkwInF3Wm8CokhfnHxxanA7xt61Daq+1q
        GsZoSk0ECfatnj+q92v7Itict6ACT7gMLeaYChcQfw8w4bmEj6m4ts5ZDuF7WPq2WRBkyo
        rg1hHz+lAVSLUlGvTfUCcaUSS509KXQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-2PkWBrAOMw2Z8nu49Kc8Pw-1; Wed, 28 Dec 2022 01:34:26 -0500
X-MC-Unique: 2PkWBrAOMw2Z8nu49Kc8Pw-1
Received: by mail-pf1-f198.google.com with SMTP id z16-20020a056a001d9000b0057d4ebe9513so7971994pfw.22
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BKQnx3lqI8J/ywBQvDRlys+9FKkDR0+iinXdJ3yuVUY=;
        b=hiJS6ol4HHtRExjiHZZmAjEvMWut2/rQ8beDYFOviskIpHc/Fzs7we9Ac0KVg3k3AE
         QDrtTtfErfsCHi/IcYug9dJtcL4FQSFqOMdxBeJ2vfiYAkfciNJdV8ew7Jwuq1Ck4WOK
         TN5ilGBEZG9Pk76cDHKvJZh2bwcENfTPuKIHpNEf/bptX/0UzCuursbMx7Uu989QD5zv
         NnLDoSTmaqPqDNVqeqUpbjuJKludkHKxwKqjPlMPrburb4Euh/n5SN6G6f9AGUpRTKV3
         FECDq7YK0ez1CHrnAtVEoE3qPLV0pnpvauEjUoGzx/txZWbhzbL+ZJiGtZeNq7x7bP28
         KkDQ==
X-Gm-Message-State: AFqh2krC6VwnXg4c1wkYvIAuO4Aef9zRHKXLN6Q230zSto6cJtekx8M0
        iXyQw4oBlMZeWol0vNsCbB1/ytCO98XvXxwYGOATp9Mfp//7cA5qMn2JyTPkjhIEy1kyD5l4Gj1
        4F0f0Ykklgcck9f3O
X-Received: by 2002:a17:903:228a:b0:191:217f:b2ea with SMTP id b10-20020a170903228a00b00191217fb2eamr37690875plh.40.1672209265601;
        Tue, 27 Dec 2022 22:34:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXud3fpQFNYTs/QJAXg2Ef0tfxpHJccTR+K7iu3P9xFUBgkpDkbiPqbWq2R61zV9fAgaEZqMNg==
X-Received: by 2002:a17:903:228a:b0:191:217f:b2ea with SMTP id b10-20020a170903228a00b00191217fb2eamr37690862plh.40.1672209265370;
        Tue, 27 Dec 2022 22:34:25 -0800 (PST)
Received: from [10.72.13.7] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b00188a7bce192sm10157311plg.264.2022.12.27.22.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 22:34:25 -0800 (PST)
Message-ID: <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
Date:   Wed, 28 Dec 2022 14:34:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183705-mutt-send-email-mst@kernel.org>
 <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
 <20221227022255-mutt-send-email-mst@kernel.org>
 <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221227043148-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/27 17:38, Michael S. Tsirkin 写道:
> On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
>> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
>>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
>>>>> But device is still going and will later use the buffers.
>>>>>
>>>>> Same for timeout really.
>>>> Avoiding infinite wait/poll is one of the goals, another is to sleep.
>>>> If we think the timeout is hard, we can start from the wait.
>>>>
>>>> Thanks
>>> If the goal is to avoid disrupting traffic while CVQ is in use,
>>> that sounds more reasonable. E.g. someone is turning on promisc,
>>> a spike in CPU usage might be unwelcome.
>>
>> Yes, this would be more obvious is UP is used.
>>
>>
>>> things we should be careful to address then:
>>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
>>>      in a loop for a while, and we also get a backtrace.
>>>      E.g. with this - how do we know who has the RTNL?
>>>      We need to integrate with kernel/watchdog.c for good results
>>>      and to make sure policy is consistent.
>>
>> That's fine, will consider this.
>>
>>
>>> 2- overhead. In a very common scenario when device is in hypervisor,
>>>      programming timers etc has a very high overhead, at bootup
>>>      lots of CVQ commands are run and slowing boot down is not nice.
>>>      let's poll for a bit before waiting?
>>
>> Then we go back to the question of choosing a good timeout for poll. And
>> poll seems problematic in the case of UP, scheduler might not have the
>> chance to run.
> Poll just a bit :) Seriously I don't know, but at least check once
> after kick.


I think it is what the current code did where the condition will be 
check before trying to sleep in the wait_event().


>
>>> 3- suprise removal. need to wake up thread in some way. what about
>>>      other cases of device breakage - is there a chance this
>>>      introduces new bugs around that? at least enumerate them please.
>>
>> The current code did:
>>
>> 1) check for vq->broken
>> 2) wakeup during BAD_RING()
>>
>> So we won't end up with a never woke up process which should be fine.
>>
>> Thanks
>
> BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> idea - can cause crashes if kernel panics on error.


Yes, it's better to use __virtqueue_break() instead.

But consider we will start from a wait first, I will limit the changes 
in virtio-net without bothering virtio core.

Thanks


>
>>>

