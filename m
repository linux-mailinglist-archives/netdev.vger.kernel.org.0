Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363535ED905
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbiI1Jc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbiI1JcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:32:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C0F5720C
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664357526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RKWhiaA5Wv0V2eMraFNdl4jrLjbjCkjEq9//t8SsrB0=;
        b=MaqAMnuJ8BfdaGqo8ndBWNxw78+hQCQsiFgmXxAwYLNRzWcOb98N3WmgvpkE2Qme3jPDO0
        giPzci2pXqJUzJHL2Hrm1Cd7vuN03XxS7lzDoQ0+925+ZJtfqjSMMVb3aDcuids1gTrI77
        vX2lb0r2fdkyy6l//LBoa8/JB49EdAA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-4sEEHllhNT2Bq1ScPq9lXA-1; Wed, 28 Sep 2022 05:32:05 -0400
X-MC-Unique: 4sEEHllhNT2Bq1ScPq9lXA-1
Received: by mail-wr1-f70.google.com with SMTP id s16-20020adf9790000000b0022cc14c6114so1141715wrb.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=RKWhiaA5Wv0V2eMraFNdl4jrLjbjCkjEq9//t8SsrB0=;
        b=rrg/6DYtHSuUBel3xeZTHaFLWhuO4eEp/pReAZt37Er2/NozZa1cSnlRAp6Yo06rXI
         I6j8pZ8Lq0YD9czM2r+FjF1ncIRMfwcBNkn6IphnPdDiPNfCn0GvBhLYsVkQ9RUwOKIJ
         V87QYoNuRxvhnxiEqmn0e7iCKaq2ZN/com2cq+0qAfk1hjNA/MZpNUrEr7QBax6+k06k
         AqRdF6dcTYzES4SUbalzg/oyJbmkwa6a81AcWwNNXtgX9oyBMxWQwCn9pT1x7Oeil84C
         5CV4VyGnl455owVyNNpRSfIQ1dtV/ez8rHa2oHOULWwqSdoc0Y5UxPOZ5IcBA6ZDBz9W
         A9Ig==
X-Gm-Message-State: ACrzQf0FGpEHNGTHFraDLExgTxWxCHvg9pM7uLqaLQMl9CSPk29us0vC
        j13180ycJJJJaOlHh8XV/x6hmva96JnBFZkHPOptgakSN3sIvtlof1nGhrZQY3nQh2o5mPh9hcu
        CFwdhxUAUaNGUrNwV
X-Received: by 2002:adf:ec09:0:b0:22c:c81b:b76a with SMTP id x9-20020adfec09000000b0022cc81bb76amr1504085wrn.302.1664357522969;
        Wed, 28 Sep 2022 02:32:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7kxutijrNlyBi7mEzPyu48cri6KyE/47cghTsg07CI6Bc2dECrlSlgkIO63V29kUYGSktS1g==
X-Received: by 2002:adf:ec09:0:b0:22c:c81b:b76a with SMTP id x9-20020adfec09000000b0022cc81bb76amr1504062wrn.302.1664357522722;
        Wed, 28 Sep 2022 02:32:02 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id l13-20020a5d410d000000b0022cbcfa8447sm3829691wrp.87.2022.09.28.02.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 02:32:02 -0700 (PDT)
Date:   Wed, 28 Sep 2022 05:31:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Junichi Uekawa <uekawa@chromium.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220928052738-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> > When copying a large file over sftp over vsock, data size is usually 32kB,
> > and kmalloc seems to fail to try to allocate 32 32kB regions.
> > 
> > Call Trace:
> >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
> >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > 
> > Work around by doing kvmalloc instead.
> > 
> > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>

My worry here is that this in more of a work around.
It would be better to not allocate memory so aggressively:
if we are so short on memory we should probably process
packets one at a time. Is that very hard to implement?



> > ---
> > 
> > drivers/vhost/vsock.c                   | 2 +-
> > net/vmw_vsock/virtio_transport_common.c | 2 +-
> > 2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index 368330417bde..5703775af129 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> > 		return NULL;
> > 	}
> > 
> > -	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
> > +	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
> > 	if (!pkt->buf) {
> > 		kfree(pkt);
> > 		return NULL;
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index ec2c2afbf0d0..3a12aee33e92 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
> > 
> > void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> > {
> > -	kfree(pkt->buf);
> > +	kvfree(pkt->buf);
> 
> virtio_transport_free_pkt() is used also in virtio_transport.c and
> vsock_loopback.c where pkt->buf is allocated with kmalloc(), but IIUC
> kvfree() can be used with that memory, so this should be fine.
> 
> > 	kfree(pkt);
> > }
> > EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
> > -- 
> > 2.37.3.998.g577e59143f-goog
> > 
> 
> This issue should go away with the Bobby's work about introducing sk_buff
> [1], but we can queue this for now.
> 
> I'm not sure if we should do the same also in the virtio-vsock driver
> (virtio_transport.c). Here in vhost-vsock the buf allocated is only used in
> the host, while in the virtio-vsock driver the buffer is exposed to the
> device emulated in the host, so it should be physically contiguous (if not,
> maybe we need to adjust virtio_vsock_rx_fill()).

More importantly it needs to support DMA API which IIUC kvmalloc
memory does not.

> So for now I think is fine to use kvmalloc only on vhost-vsock (eventually
> we can use it also in vsock_loopback), since the Bobby's patch should rework
> this code:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [1] https://lore.kernel.org/lkml/65d117ddc530d12a6d47fcc45b38891465a90d9f.1660362668.git.bobby.eshleman@bytedance.com/
> 
> Thanks,
> Stefano

