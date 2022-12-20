Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1E651F25
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 11:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiLTKoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 05:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiLTKoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 05:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FC5DEAB
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671533002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=54Q/AOcDCXt2WoQ+wVvIhTTtHPQ1SiD8DKjFK54h2ww=;
        b=VGNRrvPDROMo7S+iD4NLFUoMc8Hs5+dfuMVp7mSfiLM4Vt9sVGG5aQOuL0HoBV3lzTDWGg
        ZfA8AlH/OB0kWknYAsy7aTk2l6/bzhXES3YU161KLoUvb/S/BMQlLz9ZB2TtLFRGgiteP0
        OT8NaqF9kMpMlcX3Wa680219UwSEMlk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-PiU3gRMdO_-mDZyDfuVHWQ-1; Tue, 20 Dec 2022 05:43:20 -0500
X-MC-Unique: PiU3gRMdO_-mDZyDfuVHWQ-1
Received: by mail-wm1-f72.google.com with SMTP id q6-20020a05600c2e4600b003d211775a99so306440wmf.1
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:43:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=54Q/AOcDCXt2WoQ+wVvIhTTtHPQ1SiD8DKjFK54h2ww=;
        b=yVObJYWvAhR52X9wz8vzZfoNDOVeAr0fwZDASOoh9XuQHvwHBVBeplBb9pOt85KLBb
         ybzbLZCnJ4UI83qsZ6gFWMNgOjlwOtCXxY+1jqcnkvkWNkTFI4LcEszcTC+zeUscfkfV
         ns1bmpGFB5Lxk0F0/6QZj1pfRETSprjUEd2cpeX48u08CU0j/HPGiYFjhp7hFUgTYVSn
         6QoQVPPlWCaO5e6GLajpo+6drJGDzbFbSl6UGS5lfXW5ufRWJw1zqNcx9UD1snrIWzCX
         vNF13Rp64vpLplDVTwtVdg98KszB79zgtE8d1OJ588OV2+D4UsnO7COrnAe/FhKoRgx4
         HdmA==
X-Gm-Message-State: ANoB5pnDXjAyGTtDms7n95lVznGYsr3mjiGC/8K/yXnCVqRADQiZRnAC
        MB6aGDrV1FLCnfn3Wz7N1cMY09xcH57c/vk44e6Brk4KhK7YJx3o0mGR5sLjw8BR8QU9zq6Nr7t
        fm132fdPLWqifUzvT
X-Received: by 2002:adf:f54b:0:b0:24d:cac0:96bb with SMTP id j11-20020adff54b000000b0024dcac096bbmr25182757wrp.67.1671532999521;
        Tue, 20 Dec 2022 02:43:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5pgx3uCD9jue3Oj7nRI0x/hmaTvFuwAA61WD4OHNFKM6UQY27q4Mc9WDLqzqUBHxHaNQLKKw==
X-Received: by 2002:adf:f54b:0:b0:24d:cac0:96bb with SMTP id j11-20020adff54b000000b0024dcac096bbmr25182747wrp.67.1671532999208;
        Tue, 20 Dec 2022 02:43:19 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id k6-20020a5d66c6000000b00242271fd2besm12375033wrw.89.2022.12.20.02.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 02:43:18 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:43:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 0/2] virtio/vsock: fix mutual rx/tx hungup
Message-ID: <20221220104312.5efhzu5ildj5smnn@sgarzare-redhat>
References: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
 <CAGxU2F4ca5pxW3RX4wzsTx3KRBtxLK_rO9KxPgUtqcaSNsqXCA@mail.gmail.com>
 <2bc5a0c0-5fb7-9d0e-bd45-879e42c1ea50@sberdevices.ru>
 <20221220083313.mj2fd4tvfoifayaq@sgarzare-redhat>
 <741d7969-0c39-1e09-7297-84edbc8fddc7@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <741d7969-0c39-1e09-7297-84edbc8fddc7@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 09:23:17AM +0000, Arseniy Krasnov wrote:
>On 20.12.2022 11:33, Stefano Garzarella wrote:
>> On Tue, Dec 20, 2022 at 07:14:27AM +0000, Arseniy Krasnov wrote:
>>> On 19.12.2022 18:41, Stefano Garzarella wrote:
>>>
>>> Hello!
>>>
>>>> Hi Arseniy,
>>>>
>>>> On Sat, Dec 17, 2022 at 8:42 PM Arseniy Krasnov <AVKrasnov@sberdevices.ru> wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> seems I found strange thing(may be a bug) where sender('tx' later) and
>>>>> receiver('rx' later) could stuck forever. Potential fix is in the first
>>>>> patch, second patch contains reproducer, based on vsock test suite.
>>>>> Reproducer is simple: tx just sends data to rx by 'write() syscall, rx
>>>>> dequeues it using 'read()' syscall and uses 'poll()' for waiting. I run
>>>>> server in host and client in guest.
>>>>>
>>>>> rx side params:
>>>>> 1) SO_VM_SOCKETS_BUFFER_SIZE is 256Kb(e.g. default).
>>>>> 2) SO_RCVLOWAT is 128Kb.
>>>>>
>>>>> What happens in the reproducer step by step:
>>>>>
>>>>
>>>> I put the values of the variables involved to facilitate understanding:
>>>>
>>>> RX: buf_alloc = 256 KB; fwd_cnt = 0; last_fwd_cnt = 0;
>>>>     free_space = buf_alloc - (fwd_cnt - last_fwd_cnt) = 256 KB
>>>>
>>>> The credit update is sent if
>>>> free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE [64 KB]
>>>>
>>>>> 1) tx tries to send 256Kb + 1 byte (in a single 'write()')
>>>>> 2) tx sends 256Kb, data reaches rx (rx_bytes == 256Kb)
>>>>> 3) tx waits for space in 'write()' to send last 1 byte
>>>>> 4) rx does poll(), (rx_bytes >= rcvlowat) 256Kb >= 128Kb, POLLIN is set
>>>>> 5) rx reads 64Kb, credit update is not sent due to *
>>>>
>>>> RX: buf_alloc = 256 KB; fwd_cnt = 64 KB; last_fwd_cnt = 0;
>>>>     free_space = 192 KB
>>>>
>>>>> 6) rx does poll(), (rx_bytes >= rcvlowat) 192Kb >= 128Kb, POLLIN is set
>>>>> 7) rx reads 64Kb, credit update is not sent due to *
>>>>
>>>> RX: buf_alloc = 256 KB; fwd_cnt = 128 KB; last_fwd_cnt = 0;
>>>>     free_space = 128 KB
>>>>
>>>>> 8) rx does poll(), (rx_bytes >= rcvlowat) 128Kb >= 128Kb, POLLIN is set
>>>>> 9) rx reads 64Kb, credit update is not sent due to *
>>>>
>>>> Right, (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) is still false.
>>>>
>>>> RX: buf_alloc = 256 KB; fwd_cnt = 196 KB; last_fwd_cnt = 0;
>>>>     free_space = 64 KB
>>>>
>>>>> 10) rx does poll(), (rx_bytes < rcvlowat) 64Kb < 128Kb, rx waits in poll()
>>>>
>>>> I agree that the TX is stuck because we are not sending the credit
>>>> update, but also if RX sends the credit update at step 9, RX won't be
>>>> woken up at step 10, right?
>>>
>>> Yes, RX will sleep, but TX will wake up and as we inform TX how much
>>> free space we have, now there are two cases for TX:
>>> 1) send "small" rest of data(e.g. without blocking again), leave 'write()'
>>>   and continue execution. RX still waits in 'poll()'. Later TX will
>>>   send enough data to wake up RX.
>>> 2) send "big" rest of data - if rest is too big to leave 'write()' and TX
>>>   will wait again for the free space - it will be able to send enough data
>>>   to wake up RX as we compared 'rx_bytes' with rcvlowat value in RX.
>>
>> Right, so I'd update the test to behave like this.
>Sorry, You mean vsock_test? To cover TX waiting for free space at RX, thus checking
>this kernel patch logic?

Yep, I mean the test that you added in this series.

>> And I'd explain better the problem we are going to fix in the commit message.
>Ok
>>
>>>>
>>>>>
>>>>> * is optimization in 'virtio_transport_stream_do_dequeue()' which
>>>>>   sends OP_CREDIT_UPDATE only when we have not too much space -
>>>>>   less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
>>>>>
>>>>> Now tx side waits for space inside write() and rx waits in poll() for
>>>>> 'rx_bytes' to reach SO_RCVLOWAT value. Both sides will wait forever. I
>>>>> think, possible fix is to send credit update not only when we have too
>>>>> small space, but also when number of bytes in receive queue is smaller
>>>>> than SO_RCVLOWAT thus not enough to wake up sleeping reader. I'm not
>>>>> sure about correctness of this idea, but anyway - I think that problem
>>>>> above exists. What do You think?
>>>>
>>>> I'm not sure, I have to think more about it, but if RX reads less than
>>>> SO_RCVLOWAT, I expect it's normal to get to a case of stuck.
>>>>
>>>> In this case we are only unstucking TX, but even if it sends that single
>>>> byte, RX is still stuck and not consuming it, so it was useless to wake
>>>> up TX if RX won't consume it anyway, right?
>>>
>>> 1) I think it is not useless, because we inform(not just wake up) TX that
>>> there is free space at RX side - as i mentioned above.
>>> 2) Anyway i think that this situation is a little bit strange: TX thinks that
>>> there is no free space at RX and waits for it, but there is free space at RX!
>>> At the same time, RX waits in poll() forever - it is ready to get new portion
>>> of data to return POLLIN, but TX "thinks" exactly opposite thing - RX is full
>>> of data. Of course, if there will be just stalls in TX data handling - it will
>>> be ok - just performance degradation, but TX stucks forever.
>>
>> We did it to avoid a lot of credit update messages.
>Yes, i see
>> Anyway I think here the main point is why RX is setting SO_RCVLOWAT to 128 KB and then reads only half of it?
>>
>> So I think if the users set SO_RCVLOWAT to a value and then RX reads less then it, is expected to get stuck.
>That a really interesting question, I've found nothing about this case in Google(not sure for 100%) or POSIX. But,
>i can modify reproducer: it sets SO_RCVLOWAT to 128Kb BEFORE entering its last poll where it will stuck. In this
>case behaviour looks more legal: it uses default SO_RCVLOWAT of 1, read 64Kb each time. Finally it sets SO_RCVLOWAT
>to 128Kb(and imagine that it prepares 128Kb 'read()' buffer) and enters poll() - we will get same effect: TX will wait
>for space, RX waits in 'poll()'.

Good point!

>>
>> Anyway, since the change will not impact the default behaviour (SO_RCVLOWAT = 1) we can merge this patch, but IMHO we need to explain the case better and improve the test.
>I see, of course I'm not sure about this change, just want to ask 
>someone who knows this code better

Yes, it's an RFC, so you did well! :-)

>>
>>>
>>>>
>>>> If RX woke up (e.g. SO_RCVLOWAT = 64KB) and read the remaining 64KB,
>>>> then it would still send the credit update even without this patch and
>>>> TX will send the 1 byte.
>>>
>>> But how RX will wake up in this case? E.g. it calls poll() without timeout,
>>> connection is established, RX ignores signal
>>
>> RX will wake up because SO_RCVLOWAT is 64KB and there are 64 KB in the buffer. Then RX will read it and send the credit update to TX because
>> free_space is 0.
>IIUC, i'm talking about 10 steps above, e.g. RX will never wake up, 
>because TX is waiting for space.

Yep, but if RX uses SO_RCVLOWAT = 64 KB instead of 128 KB (I mean if RX 
reads all the bytes that it's waiting as it specified in SO_RCVLOWAT), 
then RX will send the credit message.

But there is the case that you mentioned, when SO_RCVLOWAT is chagend 
while executing.

Thanks,
Stefano

