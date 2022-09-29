Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414005EEF86
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiI2HqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiI2HqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:46:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297281332F3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664437579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CTeJi7UgmzQ/b6hrAHhKny7zyVKlQu4YxKFzX8ABb+c=;
        b=E1kiuWCAIQa9aSBqeFFbQGE77jMl/4uLvm2cotf+xOpcaivfFPOS21sAFPE7Tcu9gMJJ8b
        Jj9TJ2s+e2w+Pm8iqMr0UqJ/c35Cqp+isPlNa1OWN0gf4vgcBWWZXfg9kYa+qdopjIwur8
        U2ihRM0CAMuRI5kAkxUfSNbqqe4ny7I=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-318-m5wSq9dDOgeZ1Kwg-Zg1NA-1; Thu, 29 Sep 2022 03:46:17 -0400
X-MC-Unique: m5wSq9dDOgeZ1Kwg-Zg1NA-1
Received: by mail-qt1-f198.google.com with SMTP id e22-20020ac84b56000000b0035bb64ad562so386932qts.17
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CTeJi7UgmzQ/b6hrAHhKny7zyVKlQu4YxKFzX8ABb+c=;
        b=HyaHjB5cUDbLsqL0CinsARR4mzqjeJGrSp1GSbqIWdzJxQLBWXA/UE9zlMZLkDB9JF
         OzF8MUu6r8vKFnV7gTFw7qwj+Qnw0wrVDQlUu0Z9UO7Tkpbzq1POs5Mp3q4W1WQOeL8C
         tf/oxnXMjrMqQvkm24SQyv1AXPBD1pTRFAb5qqAAXjFwOCYTdVr0FiVT9MugstgnavfX
         PnjL62ODBFmdTsq75I0IcUM1CsULm9xYYzqfUPkVoDFw8GxHi5qQAckJaDk9srR6Zv5o
         o8pTOpjppAH66huo/g3crNqoVmj8iz+aNXBUplE3CZ6kVYYJAIF9iYKU0vXCNNDurjEi
         KdXA==
X-Gm-Message-State: ACrzQf3AUEhf4ocEHtaHu1+jmp/1GIU64QNstGWOYHgR+zIrngrtcJDE
        hCWS6OaVS/LxEQU77EdTPeUA/lh1YYyRPQu8l8MdyOCpMXV1l+cAkzdLVA8ZFeew8j+FwQoOmDe
        KkeGpzRBRAUDHUYIU
X-Received: by 2002:a05:622a:130a:b0:35b:b454:8644 with SMTP id v10-20020a05622a130a00b0035bb4548644mr1290441qtk.624.1664437577106;
        Thu, 29 Sep 2022 00:46:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7dDCrWsLDOvnsEf6oCJ6887s3Ijw/iX2+31X38ns8+Iv+1dFbn5hFI6/D3we8A3D89rQC8bw==
X-Received: by 2002:a05:622a:130a:b0:35b:b454:8644 with SMTP id v10-20020a05622a130a00b0035bb4548644mr1290431qtk.624.1664437576804;
        Thu, 29 Sep 2022 00:46:16 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-222.retail.telecomitalia.it. [79.46.200.222])
        by smtp.gmail.com with ESMTPSA id w12-20020ac843cc000000b0035bb6c3811asm4780775qtn.53.2022.09.29.00.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:46:16 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:46:06 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Junichi Uekawa =?utf-8?B?KOS4iuW3nee0lOS4gCk=?= 
        <uekawa@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
 <20220929031419-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220929031419-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 03:19:14AM -0400, Michael S. Tsirkin wrote:
>On Thu, Sep 29, 2022 at 08:14:24AM +0900, Junichi Uekawa (上川純一) wrote:
>> 2022年9月29日(木) 0:11 Stefano Garzarella <sgarzare@redhat.com>:
>> >
>> > On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
>> > >On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
>> > >> On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
>> > >> > When copying a large file over sftp over vsock, data size is usually 32kB,
>> > >> > and kmalloc seems to fail to try to allocate 32 32kB regions.
>> > >> >
>> > >> > Call Trace:
>> > >> >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
>> > >> >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
>> > >> >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
>> > >> >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
>> > >> >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
>> > >> >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
>> > >> >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
>> > >> >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
>> > >> >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
>> > >> >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
>> > >> >  [<ffffffffb683ddce>] kthread+0xfd/0x105
>> > >> >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
>> > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
>> > >> >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
>> > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
>> > >> >
>> > >> > Work around by doing kvmalloc instead.
>> > >> >
>> > >> > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
>> > >
>> > >My worry here is that this in more of a work around.
>> > >It would be better to not allocate memory so aggressively:
>> > >if we are so short on memory we should probably process
>> > >packets one at a time. Is that very hard to implement?
>> >
>> > Currently the "virtio_vsock_pkt" is allocated in the "handle_kick"
>> > callback of TX virtqueue. Then the packet is multiplexed on the right
>> > socket queue, then the user space can de-queue it whenever they want.
>> >
>> > So maybe we can stop processing the virtqueue if we are short on memory,
>> > but when can we restart the TX virtqueue processing?
>> >
>> > I think as long as the guest used only 4K buffers we had no problem, but
>> > now that it can create larger buffers the host may not be able to
>> > allocate it contiguously. Since there is no need to have them contiguous
>> > here, I think this patch is okay.
>> >
>> > However, if we switch to sk_buff (as Bobby is already doing), maybe we
>> > don't have this problem because I think there is some kind of
>> > pre-allocated pool.
>> >
>>
>> Thank you for the review! I was wondering if this is a reasonable workaround (as
>> we found that this patch makes a reliably crashing system into a
>> reliably surviving system.)
>>
>>
>> ... Sounds like it is a reasonable patch to use backported to older kernels?
>
>Hmm. Good point about stable. OK.

Right, so in this case I think is better to add a Fixes tag. Since we 
used kmalloc from the beginning we can use the following:

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")

>
>Acked-by: Michael S. Tsirkin <mst@redhat.com>
>

@Michael are you queueing this, or should it go through net tree?

Thanks,
Stefano

