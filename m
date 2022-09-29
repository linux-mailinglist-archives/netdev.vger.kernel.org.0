Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186A25EEFAA
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbiI2Hto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbiI2Hta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D8C13A05E
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664437765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5qI7b94+taNEfTbBkn8B22CaCzkL3JdPIVHISnwlAM=;
        b=L208wYi82H10CqNSRYw74uwGEA7nCMw45v9APz93lT2IrcCVN3BDhBr+mdJqJoxNORjj2B
        BubTGMEdGBM4qsijX90KMTIs4LNwjsNxgcGpU2yJ8Tum4nT5tFm6aCFTxTzVEAnu83iheH
        9B0YpmUptED8QgsqgkyULydb1czr6pc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-641-q8SIOYIrN1uRCxoZG1GKsw-1; Thu, 29 Sep 2022 03:49:24 -0400
X-MC-Unique: q8SIOYIrN1uRCxoZG1GKsw-1
Received: by mail-wr1-f70.google.com with SMTP id f9-20020adfc989000000b0022b3bbc7a7eso192938wrh.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=B5qI7b94+taNEfTbBkn8B22CaCzkL3JdPIVHISnwlAM=;
        b=Y/oVoSEZmIPQB1vD2z1uRGK2WNDpD2f6nsLilIfQAKaQT6EUmpS345XyEbUpG+NzwW
         tqPKJNqJxu7LDayqCRcLwUetQXLVlVwGpEOxtZgRV0c2EZRxzUvvxh/9cnGg1Iawgbjw
         sh5LTppHpkofBlbE1PySYunh14jzN67V9lC7TbGSy1DvvBCgN3hm/YN+ODLeUVrs+kjt
         2EnZqqiGDtlBpg0Mj9lJk6aFQzpqEqIXdHQA8VHxMrrOCJbTO+su5eMBBcY5vwZA1Dw2
         Wv/Mf0vGCoZw0tfX0WhRKhIcwFpZr9AeNL3Ms0ozyDofPA+vhyx1RP/5mtm4MTCw+eH1
         TtMA==
X-Gm-Message-State: ACrzQf36Y7Fs6GyJsa/sdqeOPRFUyDqU952h/V9ydea3YVDQ2D1c1AtF
        ZjOGQj936pDKLuiy1tABzG65DIUlX1bhWW0iIAqyq83+p2E67LvLeTxQrD4n0ad6jDTJfbVWa1r
        75EGYCjKJh+yVJMEI
X-Received: by 2002:a05:600c:4fd2:b0:3b4:cab9:44f0 with SMTP id o18-20020a05600c4fd200b003b4cab944f0mr9860803wmq.73.1664437762949;
        Thu, 29 Sep 2022 00:49:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4msH8Z/F3t4GcEn/O8enUvxnRZFEtbEHz6nKwdRFvfOH+ZEpp/nXVxoWlaKXFvrX79zD/DFA==
X-Received: by 2002:a05:600c:4fd2:b0:3b4:cab9:44f0 with SMTP id o18-20020a05600c4fd200b003b4cab944f0mr9860792wmq.73.1664437762720;
        Thu, 29 Sep 2022 00:49:22 -0700 (PDT)
Received: from redhat.com ([2.55.17.78])
        by smtp.gmail.com with ESMTPSA id bi16-20020a05600c3d9000b003b4de550e34sm3503540wmb.40.2022.09.29.00.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:49:22 -0700 (PDT)
Date:   Thu, 29 Sep 2022 03:49:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Junichi Uekawa =?utf-8?B?KOS4iuW3nee0lOS4gCk=?= 
        <uekawa@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929034807-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
 <20220929031419-mutt-send-email-mst@kernel.org>
 <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 09:46:06AM +0200, Stefano Garzarella wrote:
> On Thu, Sep 29, 2022 at 03:19:14AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 29, 2022 at 08:14:24AM +0900, Junichi Uekawa (上川純一) wrote:
> > > 2022年9月29日(木) 0:11 Stefano Garzarella <sgarzare@redhat.com>:
> > > >
> > > > On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
> > > > >On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> > > > >> On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> > > > >> > When copying a large file over sftp over vsock, data size is usually 32kB,
> > > > >> > and kmalloc seems to fail to try to allocate 32 32kB regions.
> > > > >> >
> > > > >> > Call Trace:
> > > > >> >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> > > > >> >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> > > > >> >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> > > > >> >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> > > > >> >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> > > > >> >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> > > > >> >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> > > > >> >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> > > > >> >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
> > > > >> >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> > > > >> >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> > > > >> >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> > > > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > > >> >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> > > > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > > >> >
> > > > >> > Work around by doing kvmalloc instead.
> > > > >> >
> > > > >> > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
> > > > >
> > > > >My worry here is that this in more of a work around.
> > > > >It would be better to not allocate memory so aggressively:
> > > > >if we are so short on memory we should probably process
> > > > >packets one at a time. Is that very hard to implement?
> > > >
> > > > Currently the "virtio_vsock_pkt" is allocated in the "handle_kick"
> > > > callback of TX virtqueue. Then the packet is multiplexed on the right
> > > > socket queue, then the user space can de-queue it whenever they want.
> > > >
> > > > So maybe we can stop processing the virtqueue if we are short on memory,
> > > > but when can we restart the TX virtqueue processing?
> > > >
> > > > I think as long as the guest used only 4K buffers we had no problem, but
> > > > now that it can create larger buffers the host may not be able to
> > > > allocate it contiguously. Since there is no need to have them contiguous
> > > > here, I think this patch is okay.
> > > >
> > > > However, if we switch to sk_buff (as Bobby is already doing), maybe we
> > > > don't have this problem because I think there is some kind of
> > > > pre-allocated pool.
> > > >
> > > 
> > > Thank you for the review! I was wondering if this is a reasonable workaround (as
> > > we found that this patch makes a reliably crashing system into a
> > > reliably surviving system.)
> > > 
> > > 
> > > ... Sounds like it is a reasonable patch to use backported to older kernels?
> > 
> > Hmm. Good point about stable. OK.
> 
> Right, so in this case I think is better to add a Fixes tag. Since we used
> kmalloc from the beginning we can use the following:
> 
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> 
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> 
> @Michael are you queueing this, or should it go through net tree?
> 
> Thanks,
> Stefano

net tree would be preferable, my pull for this release is kind of ready ... kuba?

-- 
MST

