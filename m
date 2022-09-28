Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D205EE663
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiI1UDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiI1UC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190B79352D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664395340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d3cN46yR7NWOicCiy/yGPpGpvzjMsqsVRHSBsY1m+T4=;
        b=YdXkMvwKKyn0P8+3yz/R9XV49RTrpvUSKcN+LDiI8+ZXs92Qp2LDuCeH8PVnB3dZo5R7K9
        pboUbkdEmB/4PUtGB+x9d28n/GZGASDhXDUNkKAYipAoaKn0e33GgSNzDUAjAdmD/PnAsk
        ax1AxSzFiUedMZCPz9JfsCtdCCbFShw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-o53SBNhbNKSzy_ya24-YJA-1; Wed, 28 Sep 2022 16:02:18 -0400
X-MC-Unique: o53SBNhbNKSzy_ya24-YJA-1
Received: by mail-wm1-f70.google.com with SMTP id 84-20020a1c0257000000b003b4be28d7e3so1811278wmc.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=d3cN46yR7NWOicCiy/yGPpGpvzjMsqsVRHSBsY1m+T4=;
        b=RjDNsNEYOWEZquTrbM2+W2kOKh75YJIxGxU3ZDZRf3RvkffVJUZJJmihrlSXWytOsU
         G2KYstOb9VYh2tQeE1Yh1F9ql6gBzN9djkICURHwzOM9ogqdTdwlblhjY8mKzAWImEjn
         Bsy7aRHIQqEHB/IPsYDEEEaQmgEzSTZoDbDEHouaummSoDtJry0875tK+8JVr6e3/hQS
         7VIWVnffMXZDH9DYYvgFBF9Xex95zZhfNL25VpE3Gev8U/a5lxO7xUz+VQiqyH7mz9l2
         OTcsgIH2+UakiIavgUMRvF7dmCmLfBjHHZibhgE69wGrCYU6qkRnElA1AfnraIcaexBJ
         n47Q==
X-Gm-Message-State: ACrzQf1s7ujKtnNM3g8IJ2Zi/qGptEhHZJ5xw+MV5nx/h+FidcgPTLyS
        a92DA66SxUqkOwwEAElhFrkCmdw6zNr8HuDa8n8FUq4OEs+QzPDblw/2mcip7pznErxgDXmyFkb
        ruF4TLWhOeJnLW7KS
X-Received: by 2002:a5d:4903:0:b0:22c:c960:dd23 with SMTP id x3-20020a5d4903000000b0022cc960dd23mr3052896wrq.475.1664395337467;
        Wed, 28 Sep 2022 13:02:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6rEH2X/vqm2gUOiwMyg5FCm2mYadAC0QuRkERmGHmC+5pWEVfjq4D2qb3iApkApTXtLPurEQ==
X-Received: by 2002:a5d:4903:0:b0:22c:c960:dd23 with SMTP id x3-20020a5d4903000000b0022cc960dd23mr3052879wrq.475.1664395337220;
        Wed, 28 Sep 2022 13:02:17 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id l7-20020a05600c4f0700b003b4c979e6bcsm2621685wmq.10.2022.09.28.13.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 13:02:16 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:02:12 -0400
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
Message-ID: <20220928160116-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 05:11:35PM +0200, Stefano Garzarella wrote:
> On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> > > On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> > > > When copying a large file over sftp over vsock, data size is usually 32kB,
> > > > and kmalloc seems to fail to try to allocate 32 32kB regions.
> > > >
> > > > Call Trace:
> > > >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> > > >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> > > >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> > > >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> > > >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> > > >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> > > >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> > > >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> > > >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
> > > >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> > > >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> > > >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> > > >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> > > >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > >
> > > > Work around by doing kvmalloc instead.
> > > >
> > > > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
> > 
> > My worry here is that this in more of a work around.
> > It would be better to not allocate memory so aggressively:
> > if we are so short on memory we should probably process
> > packets one at a time. Is that very hard to implement?
> 
> Currently the "virtio_vsock_pkt" is allocated in the "handle_kick" callback
> of TX virtqueue. Then the packet is multiplexed on the right socket queue,
> then the user space can de-queue it whenever they want.
> 
> So maybe we can stop processing the virtqueue if we are short on memory, but
> when can we restart the TX virtqueue processing?

Assuming you added at least one buffer, the time to restart would be
after that buffer has been used.


> I think as long as the guest used only 4K buffers we had no problem, but now
> that it can create larger buffers the host may not be able to allocate it
> contiguously. Since there is no need to have them contiguous here, I think
> this patch is okay.
> 
> However, if we switch to sk_buff (as Bobby is already doing), maybe we don't
> have this problem because I think there is some kind of pre-allocated pool.
> 
> > 
> > 
> > 
> > > > ---
> > > >
> > > > drivers/vhost/vsock.c                   | 2 +-
> > > > net/vmw_vsock/virtio_transport_common.c | 2 +-
> > > > 2 files changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index 368330417bde..5703775af129 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> > > > 		return NULL;
> > > > 	}
> > > >
> > > > -	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
> > > > +	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
> > > > 	if (!pkt->buf) {
> > > > 		kfree(pkt);
> > > > 		return NULL;
> > > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > > index ec2c2afbf0d0..3a12aee33e92 100644
> > > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > > @@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
> > > >
> > > > void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> > > > {
> > > > -	kfree(pkt->buf);
> > > > +	kvfree(pkt->buf);
> > > 
> > > virtio_transport_free_pkt() is used also in virtio_transport.c and
> > > vsock_loopback.c where pkt->buf is allocated with kmalloc(), but IIUC
> > > kvfree() can be used with that memory, so this should be fine.
> > > 
> > > > 	kfree(pkt);
> > > > }
> > > > EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
> > > > --
> > > > 2.37.3.998.g577e59143f-goog
> > > >
> > > 
> > > This issue should go away with the Bobby's work about introducing sk_buff
> > > [1], but we can queue this for now.
> > > 
> > > I'm not sure if we should do the same also in the virtio-vsock driver
> > > (virtio_transport.c). Here in vhost-vsock the buf allocated is only used in
> > > the host, while in the virtio-vsock driver the buffer is exposed to the
> > > device emulated in the host, so it should be physically contiguous (if not,
> > > maybe we need to adjust virtio_vsock_rx_fill()).
> > 
> > More importantly it needs to support DMA API which IIUC kvmalloc
> > memory does not.
> > 
> 
> Right, good point!
> 
> Thanks,
> Stefano

