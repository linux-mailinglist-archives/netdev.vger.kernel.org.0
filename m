Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1D35EEEC1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbiI2HTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbiI2HTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:19:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204DCFA0C4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664435961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pahe0Oi4C4m9h6JwmtN0So34FXt/ImLGT/jbwYjYeWk=;
        b=gWuOMJ/1zKrLQlGC2UnlEQeaQJo83D5cJTdqogmN+Wjzbjdd2F+RLvINFb3CG75vOZnGEu
        KGRWqpj6oiTAuGSH/y73A3azFvWHX1Xb7Kkq7ES8IEYksvEFDRoFLChJYCllS9KHFX5tZD
        e0dIh9wDllFDxz8CEvXmyd0hjwDHdC8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-392-CjhnwDiaMyGF6fdnUkQZDQ-1; Thu, 29 Sep 2022 03:19:19 -0400
X-MC-Unique: CjhnwDiaMyGF6fdnUkQZDQ-1
Received: by mail-wr1-f70.google.com with SMTP id g27-20020adfa49b000000b0022cd5476cc7so160981wrb.17
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Pahe0Oi4C4m9h6JwmtN0So34FXt/ImLGT/jbwYjYeWk=;
        b=EoT9ekydueAYdcA3EY9k3jV4LHJjYYO6kYlm2X02ywLUDcIg5Gno/cV2b7C5i9jpjg
         VCBdmRlE+yab5R6j5JmfLGmdpbqgVtBDj/s1ramJYuTwDk2iJ5bs43KKAKyFWDgkV+0T
         yO2/cYlNRJtymCfJLLSuTgDPJ10QtbYOHwN268Czd0Yrf2uvUOCwUWL4HSFWjB3NHflV
         SbPDwcgjpXT59nPttYXnjU4kjq7bcB9ymC3JQj65P1hfvsAhlVIGq+TeheaXi3wLGyCz
         kDWOV+MDpPaWjSlvqL7pWSqeMkSnJaEPNmDZStAtT48r//a5lKv1AjRvN7sfalmDAHyE
         T14Q==
X-Gm-Message-State: ACrzQf0z8IPfZvKNZzsO5Z1a43DajxY0WtAWMehcvcy87VQAl5jcpOCa
        CMYJJ+Ih0dzKeBuzx2YLESZpbMRzR6jke0DBymej58iGbymEelqBLw3YYpaJbJhICD5dGxjjnY3
        oHPAYsYoT6JsQUf1u
X-Received: by 2002:a05:600c:4841:b0:3b4:76f0:99f with SMTP id j1-20020a05600c484100b003b476f0099fmr1218124wmo.85.1664435958808;
        Thu, 29 Sep 2022 00:19:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6fAAMQAEw10LqeyomvQ2r46WQeZdX8Xh4sSb3tkzAaqxsTNtqXiZNJ+nRawX6R9Z621MuZlw==
X-Received: by 2002:a05:600c:4841:b0:3b4:76f0:99f with SMTP id j1-20020a05600c484100b003b476f0099fmr1218099wmo.85.1664435958545;
        Thu, 29 Sep 2022 00:19:18 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id p16-20020adfe610000000b00225239d9265sm6149634wrm.74.2022.09.29.00.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:19:17 -0700 (PDT)
Date:   Thu, 29 Sep 2022 03:19:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Junichi Uekawa =?utf-8?B?KOS4iuW3nee0lOS4gCk=?= 
        <uekawa@google.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929031419-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 08:14:24AM +0900, Junichi Uekawa (上川純一) wrote:
> 2022年9月29日(木) 0:11 Stefano Garzarella <sgarzare@redhat.com>:
> >
> > On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
> > >On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> > >> On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> > >> > When copying a large file over sftp over vsock, data size is usually 32kB,
> > >> > and kmalloc seems to fail to try to allocate 32 32kB regions.
> > >> >
> > >> > Call Trace:
> > >> >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> > >> >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> > >> >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> > >> >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> > >> >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> > >> >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> > >> >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> > >> >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> > >> >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
> > >> >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> > >> >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> > >> >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > >> >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > >> >
> > >> > Work around by doing kvmalloc instead.
> > >> >
> > >> > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
> > >
> > >My worry here is that this in more of a work around.
> > >It would be better to not allocate memory so aggressively:
> > >if we are so short on memory we should probably process
> > >packets one at a time. Is that very hard to implement?
> >
> > Currently the "virtio_vsock_pkt" is allocated in the "handle_kick"
> > callback of TX virtqueue. Then the packet is multiplexed on the right
> > socket queue, then the user space can de-queue it whenever they want.
> >
> > So maybe we can stop processing the virtqueue if we are short on memory,
> > but when can we restart the TX virtqueue processing?
> >
> > I think as long as the guest used only 4K buffers we had no problem, but
> > now that it can create larger buffers the host may not be able to
> > allocate it contiguously. Since there is no need to have them contiguous
> > here, I think this patch is okay.
> >
> > However, if we switch to sk_buff (as Bobby is already doing), maybe we
> > don't have this problem because I think there is some kind of
> > pre-allocated pool.
> >
> 
> Thank you for the review! I was wondering if this is a reasonable workaround (as
> we found that this patch makes a reliably crashing system into a
> reliably surviving system.)
> 
> 
> ... Sounds like it is a reasonable patch to use backported to older kernels?

Hmm. Good point about stable. OK.

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> > >
> > >
> > >
> > >> > ---
> > >> >
> > >> > drivers/vhost/vsock.c                   | 2 +-
> > >> > net/vmw_vsock/virtio_transport_common.c | 2 +-
> > >> > 2 files changed, 2 insertions(+), 2 deletions(-)
> > >> >
> > >> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > >> > index 368330417bde..5703775af129 100644
> > >> > --- a/drivers/vhost/vsock.c
> > >> > +++ b/drivers/vhost/vsock.c
> > >> > @@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> > >> >            return NULL;
> > >> >    }
> > >> >
> > >> > -  pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
> > >> > +  pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
> > >> >    if (!pkt->buf) {
> > >> >            kfree(pkt);
> > >> >            return NULL;
> > >> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > >> > index ec2c2afbf0d0..3a12aee33e92 100644
> > >> > --- a/net/vmw_vsock/virtio_transport_common.c
> > >> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > >> > @@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
> > >> >
> > >> > void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> > >> > {
> > >> > -  kfree(pkt->buf);
> > >> > +  kvfree(pkt->buf);
> > >>
> > >> virtio_transport_free_pkt() is used also in virtio_transport.c and
> > >> vsock_loopback.c where pkt->buf is allocated with kmalloc(), but IIUC
> > >> kvfree() can be used with that memory, so this should be fine.
> > >>
> > >> >    kfree(pkt);
> > >> > }
> > >> > EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
> > >> > --
> > >> > 2.37.3.998.g577e59143f-goog
> > >> >
> > >>
> > >> This issue should go away with the Bobby's work about introducing sk_buff
> > >> [1], but we can queue this for now.
> > >>
> > >> I'm not sure if we should do the same also in the virtio-vsock driver
> > >> (virtio_transport.c). Here in vhost-vsock the buf allocated is only used in
> > >> the host, while in the virtio-vsock driver the buffer is exposed to the
> > >> device emulated in the host, so it should be physically contiguous (if not,
> > >> maybe we need to adjust virtio_vsock_rx_fill()).
> > >
> > >More importantly it needs to support DMA API which IIUC kvmalloc
> > >memory does not.
> > >
> >
> > Right, good point!
> >
> > Thanks,
> > Stefano
> >
> 
> 
> -- 
> Junichi Uekawa
> Google

