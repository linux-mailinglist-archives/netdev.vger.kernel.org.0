Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4139B6A568B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjB1KYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjB1KYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:24:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796461CF4F
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677579816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OvKhGeO2umMXGqYN12idGLqKCRqabz3Yc1oP/HPSiS4=;
        b=aqIh78Y4CB9xklWzAElSd2Q2qUwxsz9gWDznY846oNnV/sOHHF2MdAWbbIfR2FyeiIwEG8
        dgUcBgV9+8QxySY/zIXClhwebk/ms8bEUE/F+zQ1AQtKDmhKWx4eOudoNYeDsHlX2oDifv
        ZjxlAA2bzT+DB88ZZVwyEqzfHUcZ85Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-223-u1n3F9_RNlqfhOlmDlLrYg-1; Tue, 28 Feb 2023 05:23:34 -0500
X-MC-Unique: u1n3F9_RNlqfhOlmDlLrYg-1
Received: by mail-wm1-f71.google.com with SMTP id m31-20020a05600c3b1f00b003e9de8c95easo3452869wms.2
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:23:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvKhGeO2umMXGqYN12idGLqKCRqabz3Yc1oP/HPSiS4=;
        b=aOXWCDCYhMn/4R8whUHcnHv4kgZDz1QDZm5MlLVBKGoXNmkerkGMQH0KJK7Nk7V9J+
         76Ph5nuF6B/JP3gGxK5Paup1uw6YpLMJTUm8ZiV8dcyj5iqdzR7QXmvXrozWpWK921Ye
         +NCeYI/tNAHZQZXPinJHfP1Ra2iY2KscpT9teFY2KsLLdfQBslCZQT63vm7S/5uYJNtO
         P7/Cz0tndh1Q6BTEHXY1FKHbo+yJAWBzWXhfME1Xzo0m1db/nvedoR9gjokkt2WJLrpQ
         btmkCK/JD807m1T3JyshWNE7QO5wsnAQInpxSkf3LhHjZmmLtqpwxcFjAM+7Anrdsa3+
         Nuuw==
X-Gm-Message-State: AO0yUKUvBJVgYp/b7t8toW0Yqt50WLmXtNeSvWAOgr/TkwPlSDwGIVAF
        aErqGGKu4u2nR4pGAUpZAJ8b92iczUkrBdeDQ+qSZn8HEQ6hwVsKaI4Vp3VYqyUUlIx/DhmwbpA
        oAzYCoKp0pPKcvRQT
X-Received: by 2002:adf:d0cb:0:b0:2c5:76bd:c0f3 with SMTP id z11-20020adfd0cb000000b002c576bdc0f3mr1687641wrh.6.1677579813242;
        Tue, 28 Feb 2023 02:23:33 -0800 (PST)
X-Google-Smtp-Source: AK7set/QLRsohYSI63gc/ez/L0rUkUtRkTXGbabSm3HO5lIrYqM1UsYTFdGo7UldUJyZ7WQ2iw9+vw==
X-Received: by 2002:adf:d0cb:0:b0:2c5:76bd:c0f3 with SMTP id z11-20020adfd0cb000000b002c576bdc0f3mr1687611wrh.6.1677579812804;
        Tue, 28 Feb 2023 02:23:32 -0800 (PST)
Received: from sgarzare-redhat ([212.43.115.213])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600012cf00b002be505ab59asm9508192wrx.97.2023.02.28.02.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 02:23:32 -0800 (PST)
Date:   Tue, 28 Feb 2023 11:23:23 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy <AVKrasnov@sberdevices.ru>, bobbyeshleman@gmail.com
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 00/12] vsock: MSG_ZEROCOPY flag support
Message-ID: <20230228102323.7nhlr47vtfongt3b@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <20230216133350.nmutrel7s5fjpkwm@sgarzare-redhat>
 <c5f75607-1dca-39f8-5320-f734203aa8a5@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5f75607-1dca-39f8-5320-f734203aa8a5@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 08:59:32AM +0000, Krasnov Arseniy wrote:
>On 16.02.2023 16:33, Stefano Garzarella wrote:
>> Hi Arseniy,
>> sorry for the delay, but I was offline.
>
>Hello! Sure no problem!, i was also offline a little bit so i'm replying
>just now
>
>>
>> On Mon, Feb 06, 2023 at 06:51:55AM +0000, Arseniy Krasnov wrote:
>>> Hello,
>>>
>>>                           DESCRIPTION
>>>
>>> this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
>>> current implementation for TCP as much as possible:
>>>
>>> 1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>>>   flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>>>   flag will be ignored (e.g. without completion).
>>>
>>> 2) Kernel uses completions from socket's error queue. Single completion
>>>   for single tx syscall (or it can merge several completions to single
>>>   one). I used already implemented logic for MSG_ZEROCOPY support:
>>>   'msg_zerocopy_realloc()' etc.
>>
>> I will review for the vsock point of view. Hope some net maintainers can
>> comment about SO_ZEROCOPY.
>>
>> Anyway I think is a good idea to keep it as close as possible to the TCP
>> implementation.
>>
>>>
>>> Difference with copy way is not significant. During packet allocation,
>>> non-linear skb is created, then I call 'get_user_pages()' for each page
>>> from user's iov iterator (I think i don't need 'pin_user_pages()' as
>>
>> Are these pages exposed to the host via virtqueues? If so, I think we
>> should pin them. What happens if the host accesses them but these pages
>> have been unmapped?
>
>Yes, user pages with data will be used by the virtio device.
>'pin' - You mean use 'pin_user_pages()'? Unmapped - You mean guest
> will unmap it, while host must access it to copy packet? Such pages
> have incremented refcount by 'get_user_pages()', so page is locked
> and memory and will be locked until host finishes copying data.

Yep, I got it while reviewing patch 7 ;-)

> I think it is better to discuss things related to 'get/pin_user_pages()'
> in one place, for example in 07/12 where this function is called.

Agree!

>
>>
>>> there is no backing storage for these pages) and add each returned page
>>> to the skb as fragment. There are also some updates for vhost and guest
>>> parts of transport - in both cases i've added handling of non-linear skb
>>> for virtio part. vhost copies data from such skb to the guest's rx virtio
>>> buffers. In the guest, virtio transport fills virtio queue with pages
>>> from skb.
>>>
>>> I think doc in Documentation/networking/msg_zerocopy.rst could be also
>>> updated in next versions.
>>
>> Yep, good idea.
>
>Ack, i'll do it in v2.
>
>>
>>>
>>> This version has several limits/problems:
>>>
>>> 1) As this feature totally depends on transport, there is no way (or it
>>>   is difficult) to check whether transport is able to handle it or not
>>>   during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>>>   setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>>>   leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>>>   are not considered to be called from each other. So in current version
>>>   SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>>>   AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>>>   tx routine will fail with EOPNOTSUPP.
>>
>> I'll take a look, but if we have no alternative, I think it's okay to
>> make tx fail.>
>
>Thanks
>
>>>
>>> 2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>>>   one completion. In each completion there is flag which shows how tx
>>>   was performed: zerocopy or copy. This leads that whole message must
>>>   be send in zerocopy or copy way - we can't send part of message with
>>>   copying and rest of message with zerocopy mode (or vice versa). Now,
>>>   we need to account vsock credit logic, e.g. we can't send whole data
>>>   once - only allowed number of bytes could sent at any moment. In case
>>>   of copying way there is no problem as in worst case we can send single
>>>   bytes, but zerocopy is more complex because smallest transmission
>>>   unit is single page. So if there is not enough space at peer's side
>>>   to send integer number of pages (at least one) - we will wait, thus
>>>   stalling tx side. To overcome this problem i've added simple rule -
>>>   zerocopy is possible only when there is enough space at another side
>>>   for whole message (to check, that current 'msghdr' was already used
>>>   in previous tx iterations i use 'iov_offset' field of it's iov iter).
>>
>> I see the problem and I think your approach is the right one.
>>
>>>
>>> 3) loopback transport is not supported, because it requires to implement
>>>   non-linear skb handling in dequeue logic (as we "send" fragged skb
>>>   and "receive" it from the same queue). I'm going to implement it in
>>>   next versions.
>>
>> loopback is useful for testing and debugging, so it would be great to
>> have the support, but if it's too complicated, we can do it later.
>>
>
>Ok, i'll implement it in v2.
>
>>>
>>> 4) Current implementation sets max length of packet to 64KB. IIUC this
>>>   is due to 'kmalloc()' allocated data buffers. I think, in case of
>>
>> Yep, I think so.
>> When I started touching this code, the limit was already there.
>> As you said, I think it was introduced to have a limit on (host/device
>> side?) allocation, but buf_alloc might be enough, so maybe we could
>> also remove it for copy mode.
>> The only problem I see is compatibility with old devices/drivers, so
>> maybe we need a feature in the spec to say the limit is gone, or have a
>> field in the virtio config space where the device specifies its limit
>> (for the driver, the limit is implicitly that of the buffer allocated
>> and put in the virtqueue).
>>
>> This reminded me that Laura had proposed something similar before,
>> maybe we should take it up again:
>> https://markmail.org/message/3el4ckeakfilg5wo
>>
>>>   MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>>>   not touched for data - user space pages are used as buffers. Also
>>>   this limit trims every message which is > 64KB, thus such messages
>>>   will be send in copy mode due to 'iov_offset' check in 2).
>>
>> The host still needs to allocate and copy, so maybe the limitation
>> could be to avoid large allocations in the host, but actually the host
>> can use vmalloc because it doesn't need them to be contiguous.
>>
>
>Hmmm, I think it is possible to solve this situation in the following
>way - i can keep limitation for 64KB for copy mode, and remove it for
>zero copy, but I'll limit each packet size to 64KB(of course technically
>it is not exactly 64KB, it is min(max packet size, MAX_SKB_FRAGS * PAGE_SIZE)
>where max packet size is 64Kb, but for simplicity  let's call this limit 64Kb:) ).
>E.g. when zerocopy transmission needs to send for example 129Kb(of course
>peer's free space is big enough and this check is passed), I'll won't trim
>129Kb to 64Kb + 64Kb + 1Kb in the current manner - by returning to af_vsock.c
>after sending every skb. I'll alloc several skbs, (3 in this case - 64Kb + 64Kb + 1Kb)
>in single call to the transport. Completion arg will be attached
>only to the last one skb, and send these 3 skbs. Host still processes
>64Kb(let it be 64Kb for simplicity again :) ) packets - no big allocations.

Make sense to me!

>Moreover, i think that this logic could be a little optimization for
>copy mode - why we allocate single skb and always return to af_vsock.c?

@Bobby, can you help us here?

>May be we can iterate needed number of skbs in the loop and send them.

Yep, I think is doable.

>
>Also about vmalloc(), IIUC there is already this idea which replaces 'kmalloc()'
>to 'kvmalloc()'.

Yep, I think it is already merged:
0e3f72931fc4 ("vhost/vsock: Use kvmalloc/kvfree for larger packets.")

But this is in the vhost transport (device emulation running in the 
host), where we don't need that the pages are pinned.

>
>>>
>>>                            PERFORMANCE
>>>
>>> Performance: it is a little bit tricky to compare performance between
>>> copy and zerocopy transmissions. In zerocopy way we need to wait when
>>> user buffers will be released by kernel, so it something like synchronous
>>> path (wait until device driver will process it), while in copy way we
>>> can feed data to kernel as many as we want, don't care about device
>>> driver. So I compared only time which we spend in 'sendmsg()' syscall.
>>> Also there is limit from 4) above so max buffer size is 64KB. I've
>>> tested this patchset in the nested VM, but i think for V1 it is not a
>>> big deal.
>>>
>>> Sender:
>>> ./vsock_perf --sender <CID> --buf-size <buf size> --bytes 60M [--zc]
>>>
>>> Receiver:
>>> ./vsock_perf --vsk-size 256M
>>>
>>> Number in cell is seconds which senders spends inside tx syscall.
>>>
>>> Guest to host transmission:
>>>
>>> *-------------------------------*
>>> |          |         |          |
>>> | buf size |   copy  | zerocopy |
>>> |          |         |          |
>>> *-------------------------------*
>>> |   4KB    |  0.26   |   0.042  |
>>> *-------------------------------*
>>> |   16KB   |  0.11   |   0.014  |
>>> *-------------------------------*
>>> |   32KB   |  0.05   |   0.009  |
>>> *-------------------------------*
>>> |   64KB   |  0.04   |   0.005  |
>>> *-------------------------------*
>>>
>>> Host to guest transmission:
>>>
>>> *--------------------------------*
>>> |          |          |          |
>>> | buf size |   copy   | zerocopy |
>>> |          |          |          |
>>> *--------------------------------*
>>> |   4KB    |   0.049  |   0.034  |
>>> *--------------------------------*
>>> |   16KB   |   0.03   |   0.024  |
>>> *--------------------------------*
>>> |   32KB   |   0.025  |   0.01   |
>>> *--------------------------------*
>>> |   64KB   |   0.028  |   0.01   |
>>> *--------------------------------*
>>>
>>> If host fails to send data with "Cannot allocate memory", check value
>>> /proc/sys/net/core/optmem_max - it is accounted during completion skb
>>> allocation.
>>>
>>> Zerocopy is faster than classic copy mode, but of course it requires
>>> specific architecture of application due to user pages pinning, buffer
>>> size and alignment. In next versions i'm going to fix 64KB barrier to
>>> perform tests with bigger buffer sizes.
>>
>> Yep, I see.
>> Adjusting vsock_perf to compare also Gbps (can io_uring helps in this
>> case to have more requests in-flight?) would be great.
>>
>
>Yes, i'll add Gbps. Also I thought about adding io_uring test to
>the current test suite because io_uring also have MSG_ZEROCOPY
>type of request, and interesting thing is that io_uring uses it's
>own already allocated uarg.

Cool!

>
>>>
>>>                            TESTING
>>>
>>> This patchset includes set of tests for MSG_ZEROCOPY feature. I tried to
>>> cover new code as much as possible so there are different cases for
>>> MSG_ZEROCOPY transmissions: with disabled SO_ZEROCOPY and several io
>>> vector types (different sizes, alignments, with unmapped pages).
>>
>> Great! Thanks for adding the tests!
>>
>> I'll go through the patches between today and Monday.
>> Sorry again for taking so long!
>
>Sure, Thanks for review! I think we are not hurry :)

Yep, thank you for this work!

Stefano

