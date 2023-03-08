Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9F6B06FF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjCHMYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjCHMXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:23:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49393BF8F0
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 04:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678278074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FYUSGl+c2i/XrGfwxUOIC1FfAmTL8/NIk2jsBnOFyek=;
        b=dNXslAKaVVzoJaoP6flqaB/MeRyrz4fIAyVMB9vj+Yr96c67tZv4yno51oV8/5wBeKYBcd
        6N+HwcgyvGnWP/oKoUykoRYkeuxg0G67PAAh6soIBTajTqODsuokgzQHtt3hGOn5Y/zdwE
        SyhMH+w52z+tXSv+5BrcSqWmByTevcc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-VsEGj9QJPUimkPCWz4MEZw-1; Wed, 08 Mar 2023 07:21:13 -0500
X-MC-Unique: VsEGj9QJPUimkPCWz4MEZw-1
Received: by mail-ed1-f69.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso23353591edu.17
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 04:21:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678278072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYUSGl+c2i/XrGfwxUOIC1FfAmTL8/NIk2jsBnOFyek=;
        b=hmi0v9QmYZcPNmPE58yNOu/zlP0iV9SM8rqaSbbNzJ+q83cInD/VpajQIharwGXoeG
         OtjdgXaTA0aLGcRfPdW2+ecuBX2LDW/GimWEcca9bFA7NqT1IoENl6Rohafq02EKxUs/
         0czATkrtQan4ZCzX4gjzutdrMLsURRB1vSIw8JAy+QmzzDRQbWh7QOCeCk6jaNw2myou
         wDtItMJeNJiQ/5mBkBQv/ruPyy7vd+GiMT+hQN3jY/kbozmbiO44PwW616UX/52tM/CP
         +8PSYMD/uL0x2ufAN867UJIb7JdnJrDF4Fp7chmf+ER8zDE49h55YIWPVTyyrpnjii8z
         OyIA==
X-Gm-Message-State: AO0yUKXuQNLhSViHxdqSSWj2KpNnguKmnkiGFVghTGqzOhadoLev+wEF
        1VKQNMII7Mw2SzHT17QLdd4basMIRcyeqpRWePjbEK5YoHYqJNo+ydGJMSgNExpyPIrBPxjubuF
        UfgK353KX566eRcBp
X-Received: by 2002:aa7:d856:0:b0:4af:6e95:861b with SMTP id f22-20020aa7d856000000b004af6e95861bmr23390138eds.2.1678278072619;
        Wed, 08 Mar 2023 04:21:12 -0800 (PST)
X-Google-Smtp-Source: AK7set+6tZBfhWzjylNGTyxDwu7Yy+PpamZXGOVNIhYLZOhQ3DZ5QD/rfxx44WLOJiGYe6hsxp2zJQ==
X-Received: by 2002:aa7:d856:0:b0:4af:6e95:861b with SMTP id f22-20020aa7d856000000b004af6e95861bmr23390108eds.2.1678278072292;
        Wed, 08 Mar 2023 04:21:12 -0800 (PST)
Received: from redhat.com ([2.52.138.216])
        by smtp.gmail.com with ESMTPSA id r15-20020a50c00f000000b004bbc90e1fa3sm8087835edb.93.2023.03.08.04.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 04:21:11 -0800 (PST)
Date:   Wed, 8 Mar 2023 07:21:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Yichun Zhang <yichun@openresty.com>,
        Alexander Duyck <alexanderduyck@fb.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net, stable v1 3/3] virtio_net: add checking sq is full
 inside xdp xmit
Message-ID: <20230308071921-mutt-send-email-mst@kernel.org>
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
 <20230308024935.91686-4-xuanzhuo@linux.alibaba.com>
 <7eea924e-5cc3-8584-af95-04587f303f8f@huawei.com>
 <1678259647.118581-1-xuanzhuo@linux.alibaba.com>
 <5a4564dc-af93-4305-49a4-5ca16d737bc3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4564dc-af93-4305-49a4-5ca16d737bc3@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 04:13:12PM +0800, Yunsheng Lin wrote:
> On 2023/3/8 15:14, Xuan Zhuo wrote:
> > On Wed, 8 Mar 2023 14:59:36 +0800, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >> On 2023/3/8 10:49, Xuan Zhuo wrote:
> >>> If the queue of xdp xmit is not an independent queue, then when the xdp
> >>> xmit used all the desc, the xmit from the __dev_queue_xmit() may encounter
> >>> the following error.
> >>>
> >>> net ens4: Unexpected TXQ (0) queue failure: -28
> >>>
> >>> This patch adds a check whether sq is full in xdp xmit.
> >>>
> >>> Fixes: 56434a01b12e ("virtio_net: add XDP_TX support")
> >>> Reported-by: Yichun Zhang <yichun@openresty.com>
> >>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >>> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> >>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> >>> ---
> >>>  drivers/net/virtio_net.c | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index 46bbddaadb0d..1a309cfb4976 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -767,6 +767,9 @@ static int virtnet_xdp_xmit(struct net_device *dev,
> >>>  	}
> >>>  	ret = nxmit;
> >>>
> >>> +	if (!is_xdp_raw_buffer_queue(vi, sq - vi->sq))
> >>> +		check_sq_full_and_disable(vi, dev, sq);
> >>> +
> >>
> >> Sorry if I missed something obvious here.
> >>
> >> As the comment in start_xmit(), the current skb is added to the sq->vq, so
> >> NETDEV_TX_BUSY can not be returned.
> >>
> >> 	/* If running out of space, stop queue to avoid getting packets that we
> >> 	 * are then unable to transmit.
> >> 	 * An alternative would be to force queuing layer to requeue the skb by
> >> 	 * returning NETDEV_TX_BUSY. However, NETDEV_TX_BUSY should not be
> >> 	 * returned in a normal path of operation: it means that driver is not
> >> 	 * maintaining the TX queue stop/start state properly, and causes
> >> 	 * the stack to do a non-trivial amount of useless work.
> >> 	 * Since most packets only take 1 or 2 ring slots, stopping the queue
> >> 	 * early means 16 slots are typically wasted.
> >> 	 */
> >>
> >> It there any reason not to check the sq->vq->num_free at the begin of start_xmit(),
> >> if the space is not enough for the current skb, TX queue is stopped and NETDEV_TX_BUSY
> >> is return to the stack to requeue the current skb.
> >>
> >> It seems it is the pattern that most network driver follow, and it seems we can avoid
> >> calling check_sq_full_and_disable() in this patch and not wasting 16 slots as mentioned
> >> in the comment above.
> >>
> > 
> > 
> > 
> >  * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
> >  *                               struct net_device *dev);
> >  *	Called when a packet needs to be transmitted.
> >  *	Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you should stop
> >  *	the queue before that can happen; it's for obsolete devices and weird
> >  *	corner cases, but the stack really does a non-trivial amount
> >  *	of useless work if you return NETDEV_TX_BUSY.
> >  *	Required; cannot be NULL.
> 
> Thanks for the pointer. It is intersting, it seems most driver is not flollowing
> the suggestion.

Yes - I don't know why.

> I found out why the above comment was added, but I am not sure I understand
> what does "non-trivial amount of useless work" means yet.
> https://lists.linuxfoundation.org/pipermail/virtualization/2015-April/029718.html

dev_requeue_skb 

-- 
MST

