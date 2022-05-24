Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C01532423
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiEXHdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbiEXHdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:33:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFD5363BE8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653377588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nc0quxO4J16P5xk58WIaztMrbbSvqm8aAXmU1D9eYJ4=;
        b=hhCIHAxBdu+3qC1+IGdmfA8uz0rZKDVUEGgXxuzTEfTHicTVoVKhoYPA7Fv4YgFroLDRKE
        bTTN2Ak/1A4R05pTZ+fLuRZRTK+2PvL28zRKe5mm8VYPOrXbGV6eZzRxpiClun0lsXQcFA
        TLU54+6BYMzASVxH99fx3/JiaqHwWsw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-zHh-bXh1N-CdeeleKiT3JQ-1; Tue, 24 May 2022 03:33:06 -0400
X-MC-Unique: zHh-bXh1N-CdeeleKiT3JQ-1
Received: by mail-qk1-f197.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso12979382qkl.7
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nc0quxO4J16P5xk58WIaztMrbbSvqm8aAXmU1D9eYJ4=;
        b=O66VDYAdldlcjcF+YjU9Lw7PzyBa0RHFP6J9QY234Rft5JUJf5RQJLQGRfcgYQIjV6
         20zKqnpweav9f48YqnmtVnk7Cdeaa1Ej4LmmXUGO29+8Z5iPUKQBLN5KLD72+bMDnl7y
         8ti9I1ZB4itSarMs9KLwVZ81464FcMEbjlSYIPqxvokXclefoND24TvvZdSVGitI8yJN
         g/PiUXlTnETRdt0qqoBWivIW5XXMsNWe8VXJIkvpRq5CWeJAEF2kg4/+c00iIvU5ABvJ
         QKPLvWBaudTu5XWzuo57i6tn9oGf7Wnr/5IXgmMxe+GlQOrqnPJANk3y4Klb7aiijwH2
         asNA==
X-Gm-Message-State: AOAM531gQcd8XgcYUj5qAJTmcBsmQkasrqNAL9THU3nBWbFlyWuIBQ4i
        geHKPrLxeC+KMfgwerwWbyjIJSiFYgFyOWyeViuTiDzC8WQSYRX9z5u0ZFEwXKmbo7zkQUXPxOp
        tgJkBIvmsv0rL0i8u
X-Received: by 2002:a05:6214:29ed:b0:462:12c7:e525 with SMTP id jv13-20020a05621429ed00b0046212c7e525mr14337034qvb.103.1653377585604;
        Tue, 24 May 2022 00:33:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpE9SJiGYXMMYBtv5GJ5wp83RMZiYPAjWM+XCwHFqeq/+El/4WVAF+CheI3qT9ZUG1nbeKrQ==
X-Received: by 2002:a05:6214:29ed:b0:462:12c7:e525 with SMTP id jv13-20020a05621429ed00b0046212c7e525mr14337012qvb.103.1653377585290;
        Tue, 24 May 2022 00:33:05 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id m24-20020ae9e018000000b006a37710ef89sm4011426qkk.115.2022.05.24.00.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:33:04 -0700 (PDT)
Date:   Tue, 24 May 2022 09:32:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 0/8] virtio/vsock: experimental zerocopy receive
Message-ID: <20220524073256.fpaknbcm7w5trata@sgarzare-redhat>
References: <7cdcb1e1-7c97-c054-19cf-5caeacae981d@sberdevices.ru>
 <20220517151404.vqse5tampdsaaeji@sgarzare-redhat>
 <413d821f-3893-befa-7009-2f87ef51af7a@sberdevices.ru>
 <20220519074208.q2bmytl2dphtjgse@sgarzare-redhat>
 <27f906a8-181f-e6d8-f5a1-035604a2decb@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27f906a8-181f-e6d8-f5a1-035604a2decb@sberdevices.ru>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 11:09:11AM +0000, Arseniy Krasnov wrote:
>Hello Stefano,
>
>On 19.05.2022 10:42, Stefano Garzarella wrote:
>> On Wed, May 18, 2022 at 11:04:30AM +0000, Arseniy Krasnov wrote:
>>> Hello Stefano,
>>>
>>> On 17.05.2022 18:14, Stefano Garzarella wrote:
>>>> Hi Arseniy,
>>>>
>>>> On Thu, May 12, 2022 at 05:04:11AM +0000, Arseniy Krasnov wrote:
>>>>>                              INTRODUCTION
>>>>>
>>>>>     Hello, this is experimental implementation of virtio vsock zerocopy
>>>>> receive. It was inspired by TCP zerocopy receive by Eric Dumazet. This API uses
>>>>> same idea: call 'mmap()' on socket's descriptor, then every 'getsockopt()' will
>>>>> fill provided vma area with pages of virtio RX buffers. After received data was
>>>>> processed by user, pages must be freed by 'madvise()'  call with MADV_DONTNEED
>>>>> flag set(if user won't call 'madvise()', next 'getsockopt()' will fail).
>>>>
>>>> Sounds cool, but maybe we would need some socket/net experts here for review.
>>>
>>> Yes, that would be great
>>>
>>>>
>>>> Could we do something similar for the sending path as well?
>>>
>>> Here are thoughts about zerocopy transmission:
>>>
>>> I tried to implement this feature in the following way: user creates
>>> some page aligned buffer, then during tx packet allocation instead of
>>> creating data buffer with 'kmalloc()', i tried to add user's buffer
>>> to virtio queue. But found problem: as kernel virtio API uses virtual
>>> addresses to add new buffers, in the deep of virtio subsystem
>>> 'virt_to_phys()' is called to get physical address of buffer, so user's
>>> virtual address won't be translated correctly to physical address(in
>>> theory, i can perform page walk for such user's va, get physical address
>>> and pass some "fake" virtual address to virtio API in order to make
>>> 'virt_to_phys()' return valid physical address(but i think this is ugly).
>>
>> And maybe we should also pin the pages to prevent them from being replaced.
>>
>> I think we should do something similar to what we do in vhost-vdpa.
>> Take a look at vhost_vdpa_pa_map() in drivers/vhost/vdpa.c
>
>Hm, ok. I'll read about vdpa...
>
>>
>>>
>>>
>>> If we are talking about 'mmap()' way, i think we can do the following:
>>> user calls 'mmap()' on socket, kernel fills newly created mapping with
>>> allocated pages(all pages have rw permissions). Now user can use pages
>>> of this mapping(e.g. fill it with data). Finally, to start transmission,
>>> user calls 'getsockopt()' or some 'ioctl()' and kernel processes data of
>>> this mapping. Also as this call will return immediately(e.g. it is
>>> asynchronous), some completion logic must be implemented. For example
>>> use same way as MSG_ZEROCOPY uses - poll error queue of socket to get
>>> message that pages could be reused, or don't allow user to work with
>>> these pages: unmap it, perform transmission and finally free pages.
>>> To start new transmission user need to call 'mmap()' again.
>>>
>>>                            OR
>>>
>>> I think there is another unusual way for zerocopy tx: let's use 'vmsplice()'
>>> /'splice()'. In this approach to transmit something, user does the following
>>> steps:
>>> 1) Creates pipe.
>>> 2) Calls 'vmsplice(SPLICE_F_GIFT)' on this pipe, insert data pages to it.
>>>   SPLICE_F_GIFT allows user to forget about allocated pages - kernel will
>>>   free it.
>>> 3) Calls 'splice(SPLICE_F_MOVE)' from pipe to socket. SPLICE_F_MOVE will
>>>   move pages from pipe to socket(e.g. in special socket callback we got
>>>   set of pipe's pages as input argument and all pages will be inserted
>>>   to virtio queue).
>>>
>>> But as SPLICE_F_MOVE support is disabled, it must be repaired first.
>>
>> Splice seems interesting, but it would be nice If we do something similar to TCP. IIUC they use a flag for send(2):
>>
>>     send(fd, buf, sizeof(buf), MSG_ZEROCOPY);
>>
>
>Yes, but in this way i think:
>1) What is 'buf'? It can't be user's address, since this buffer must be inserted to tx queue.
>   E.g. it must be allocated by kernel and then returned to user for tx purposes. In TCP
>   case, 'buf' is user's address(of course page aligned) because TCP logic uses sk_buff which
>   allows to use such memory as data buffer.

IIUC we can pin that buffer like we do in vhost-vdpa, and use it in the 
VQ.

>2) To wait tx process is done(e.g. pages can be used again), such 
>API(send + MSG_ZEROCOPY),
>   uses socket's error queue - poll events that tx is finished. So same 
>   way must be
>   implemented for virtio vsock.

Yeah, I think so.

>
>>  
>>>
>>>>
>>>>>
>>>>>                                 DETAILS
>>>>>
>>>>>     Here is how mapping with mapped pages looks exactly: first page mapping
>>>>> contains array of trimmed virtio vsock packet headers (in contains only length
>>>>> of data on the corresponding page and 'flags' field):
>>>>>
>>>>>     struct virtio_vsock_usr_hdr {
>>>>>         uint32_t length;
>>>>>         uint32_t flags;
>>>>>     };
>>>>>
>>>>> Field  'length' allows user to know exact size of payload within each sequence
>>>>> of pages and 'flags' allows user to handle SOCK_SEQPACKET flags(such as message
>>>>> bounds or record bounds). All other pages are data pages from RX queue.
>>>>>
>>>>>             Page 0      Page 1      Page N
>>>>>
>>>>>     [ hdr1 .. hdrN ][ data ] .. [ data ]
>>>>>           |        |       ^           ^
>>>>>           |        |       |           |
>>>>>           |        *-------------------*
>>>>>           |                |
>>>>>           |                |
>>>>>           *----------------*
>>>>>
>>>>>     Of course, single header could represent array of pages (when packet's
>>>>> buffer is bigger than one page).So here is example of detailed mapping layout
>>>>> for some set of packages. Lets consider that we have the following sequence  of
>>>>> packages: 56 bytes, 4096 bytes and 8200 bytes. All pages: 0,1,2,3,4 and 5 will
>>>>> be inserted to user's vma(vma is large enough).
>>>>>
>>>>>     Page 0: [[ hdr0 ][ hdr 1 ][ hdr 2 ][ hdr 3 ] ... ]
>>>>>     Page 1: [ 56 ]
>>>>>     Page 2: [ 4096 ]
>>>>>     Page 3: [ 4096 ]
>>>>>     Page 4: [ 4096 ]
>>>>>     Page 5: [ 8 ]
>>>>>
>>>>>     Page 0 contains only array of headers:
>>>>>     'hdr0' has 56 in length field.
>>>>>     'hdr1' has 4096 in length field.
>>>>>     'hdr2' has 8200 in length field.
>>>>>     'hdr3' has 0 in length field(this is end of data marker).
>>>>>
>>>>>     Page 1 corresponds to 'hdr0' and has only 56 bytes of data.
>>>>>     Page 2 corresponds to 'hdr1' and filled with data.
>>>>>     Page 3 corresponds to 'hdr2' and filled with data.
>>>>>     Page 4 corresponds to 'hdr2' and filled with data.
>>>>>     Page 5 corresponds to 'hdr2' and has only 8 bytes of data.
>>>>>
>>>>>     This patchset also changes packets allocation way: today implementation
>>>>> uses only 'kmalloc()' to create data buffer. Problem happens when we try to map
>>>>> such buffers to user's vma - kernel forbids to map slab pages to user's vma(as
>>>>> pages of "not large" 'kmalloc()' allocations are marked with PageSlab flag and
>>>>> "not large" could be bigger than one page). So to avoid this, data buffers now
>>>>> allocated using 'alloc_pages()' call.
>>>>>
>>>>>                                   TESTS
>>>>>
>>>>>     This patchset updates 'vsock_test' utility: two tests for new feature
>>>>> were added. First test covers invalid cases. Second checks valid transmission
>>>>> case.
>>>>
>>>> Thanks for adding the test!
>>>>
>>>>>
>>>>>                                BENCHMARKING
>>>>>
>>>>>     For benchmakring I've added small utility 'rx_zerocopy'. It works in
>>>>> client/server mode. When client connects to server, server starts sending exact
>>>>> amount of data to client(amount is set as input argument).Client reads data and
>>>>> waits for next portion of it. Client works in two modes: copy and zero-copy. In
>>>>> copy mode client uses 'read()' call while in zerocopy mode sequence of 'mmap()'
>>>>> /'getsockopt()'/'madvise()' are used. Smaller amount of time for transmission
>>>>> is better. For server, we can set size of tx buffer and for client we can set
>>>>> size of rx buffer or rx mapping size(in zerocopy mode). Usage of this utility
>>>>> is quiet simple:
>>>>>
>>>>> For client mode:
>>>>>
>>>>> ./rx_zerocopy --mode client [--zerocopy] [--rx]
>>>>>
>>>>> For server mode:
>>>>>
>>>>> ./rx_zerocopy --mode server [--mb] [--tx]
>>>>>
>>>>> [--mb] sets number of megabytes to transfer.
>>>>> [--rx] sets size of receive buffer/mapping in pages.
>>>>> [--tx] sets size of transmit buffer in pages.
>>>>>
>>>>> I checked for transmission of 4000mb of data. Here are some results:
>>>>>
>>>>>                           size of rx/tx buffers in pages
>>>>>               *---------------------------------------------------*
>>>>>               |    8   |    32    |    64   |   256    |   512    |
>>>>> *--------------*--------*----------*---------*----------*----------*
>>>>> |   zerocopy   |   24   |   10.6   |  12.2   |   23.6   |    21    | secs to
>>>>> *--------------*---------------------------------------------------- process
>>>>> | non-zerocopy |   13   |   16.4   |  24.7   |   27.2   |   23.9   | 4000 mb
>>>>> *--------------*----------------------------------------------------
>>>>>
>>>>> I think, that results are not so impressive, but at least it is not worse than
>>>>> copy mode and there is no need to allocate memory for processing date.
>>>>
>>>> Why is it twice as slow in the first column?
>>>
>>> May be this is because memory copying for small buffers is very fast... i'll
>>> analyze it deeply.
>>
>> Maybe I misunderstood, by small buffers here what do you mean?
>>
>> I thought 8 was the number of pages, so 32KB buffers.
>
>Yes, 8 is size in pages. Anyway, i need to check it more deeply.

Okay, thanks!

Stefano

