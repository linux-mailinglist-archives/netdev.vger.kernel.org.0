Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3738D64B830
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 16:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbiLMPQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 10:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiLMPQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 10:16:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9762183C
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 07:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670944559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lbIEUOJRndagsIzbonwHHIU2DwYDRVtl3eIrtsPjZPY=;
        b=GwANtzz8KT+9GNg+InszRY9Cd7hir4e+Fnxza4V2QTm95kJFklS2P4gxqVhpvbSp7NQXgp
        P36cImgL4RTUhWfq3yWymC2XoE59yo0avdBpZNaeuJU/pjwEd99czaccv0aQaf+HUo/Y3r
        M0tUfhw0kr87ZVlcAfSKNT43SW5lw5g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-0U4q16yAO0Ks_4RXFb9_5A-1; Tue, 13 Dec 2022 10:15:57 -0500
X-MC-Unique: 0U4q16yAO0Ks_4RXFb9_5A-1
Received: by mail-wm1-f69.google.com with SMTP id h81-20020a1c2154000000b003d1c8e519fbso5782781wmh.2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 07:15:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbIEUOJRndagsIzbonwHHIU2DwYDRVtl3eIrtsPjZPY=;
        b=TgSlVvQs+92TQ3td561l0zF5l6xWWk2gQRr06BeRnKN2Sy6mNCZ5lLXxz65I9SNrHm
         pb22KVErTBX8mO24S6IV3fysg4guUlZ6cGQqjpZCVHmmXdhlWi8Jmmb+ZWHFYvg2+Spv
         1GFFcNtwJyB1mhqXlB/7YkOcU0FZXXDEyXhYZn1xLpYdb0/99kxAqnYBwVZADwbLPn4C
         w1CxQWRjNQDkPIALRiBmZCC6o3DfWTX0hoOLpVA4DdzkvgqHqOgBI//fMYIya5wAzG3w
         tbzPzwLPFwAxTgzDvJcOzZ0xbXHtGcwWUD668KkAp8bSkTMXncC+FCdU5RiM4q4LzvqJ
         d0kw==
X-Gm-Message-State: ANoB5pnQtj9cOzshAeMg/HBYzx6TxOuXl67joy14NbC33eyAFl9sYgc8
        zq+zlsnmJYyf1VA7TG2obnqIDFGcMZRk+kIzMC08CtLyIpDV+DYNI8K4RwpzdcUCLRFPz6BZ9r/
        ECGGIY1DkkruOyAok
X-Received: by 2002:a05:600c:3483:b0:3cf:67ad:6284 with SMTP id a3-20020a05600c348300b003cf67ad6284mr15434366wmq.4.1670944556659;
        Tue, 13 Dec 2022 07:15:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5/4uv+DoAXL906JZYpQZXcgVQ0peFwD4X+zA8ZABwsdTnKHC0INZm4AdCdMnQv41hdJWFMMQ==
X-Received: by 2002:a05:600c:3483:b0:3cf:67ad:6284 with SMTP id a3-20020a05600c348300b003cf67ad6284mr15434352wmq.4.1670944556447;
        Tue, 13 Dec 2022 07:15:56 -0800 (PST)
Received: from redhat.com ([2.52.138.183])
        by smtp.gmail.com with ESMTPSA id ay13-20020a05600c1e0d00b003c6bd91caa5sm13651091wmb.17.2022.12.13.07.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 07:15:55 -0800 (PST)
Date:   Tue, 13 Dec 2022 10:15:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [PATCH net] virtio-net: correctly enable callback during
 start_xmit
Message-ID: <20221213100901-mutt-send-email-mst@kernel.org>
References: <20221212091029.54390-1-jasowang@redhat.com>
 <20221212042144-mutt-send-email-mst@kernel.org>
 <1670902391.9610498-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEu=1CcoNvvV9M+QrG5sLUBoPYkZ3DvUe+pLc1fSvgLuHA@mail.gmail.com>
 <20221213013231-mutt-send-email-mst@kernel.org>
 <CACGkMEukRrOWghcBXiqPrOtNbdjdDJUW7-cg9PsdtsVs1SuCyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEukRrOWghcBXiqPrOtNbdjdDJUW7-cg9PsdtsVs1SuCyQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 02:57:54PM +0800, Jason Wang wrote:
> On Tue, Dec 13, 2022 at 2:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Dec 13, 2022 at 11:43:36AM +0800, Jason Wang wrote:
> > > On Tue, Dec 13, 2022 at 11:38 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > >
> > > > On Mon, 12 Dec 2022 04:25:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > On Mon, Dec 12, 2022 at 05:10:29PM +0800, Jason Wang wrote:
> > > > > > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > > > > > virtqueue callback via the following statement:
> > > > > >
> > > > > >         do {
> > > > > >            ......
> > > > > >     } while (use_napi && kick &&
> > > > > >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > > >
> > > > > > This will cause a missing call to virtqueue_enable_cb_delayed() when
> > > > > > kick is false. Fixing this by removing the checking of the kick from
> > > > > > the condition to make sure callback is enabled correctly.
> > > > > >
> > > > > > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > ---
> > > > > > The patch is needed for -stable.
> > > > >
> > > > > stable rules don't allow for theoretical fixes. Was a problem observed?
> > >
> > > Yes, running a pktgen sample script can lead to a tx timeout.
> >
> > Since April 2021 and we only noticed now? Are you sure it's the
> > right Fixes tag?
> 
> Well, reverting a7766ef18b33 makes pktgen work again.
> 
> The reason we doesn't notice is probably because:
> 
> 1) We don't support BQL, so no bulk dequeuing (skb list) in normal traffic
> 2) When burst is enabled for pktgen, it can do bulk xmit via skb list by its own
> 
> >
> > > > >
> > > > > > ---
> > > > > >  drivers/net/virtio_net.c | 4 ++--
> > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 86e52454b5b5..44d7daf0267b 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > > > >
> > > > > >             free_old_xmit_skbs(sq, false);
> > > > > >
> > > > > > -   } while (use_napi && kick &&
> > > > > > -          unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > > > +   } while (use_napi &&
> > > > > > +            unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > > >
> > > > >
> > > > > A bit more explanation pls.  kick simply means !netdev_xmit_more -
> > > > > if it's false we know there will be another packet, then transmissing
> > > > > that packet will invoke virtqueue_enable_cb_delayed. No?
> > > >
> > > > It's just that there may be a next packet, but in fact there may not be.
> > > > For example, the vq is full, and the driver stops the queue.
> > >
> > > Exactly, when the queue is about to be full we disable tx and wait for
> > > the next tx interrupt to re-enable tx.
> > >
> > > Thanks
> >
> > OK, it's a good idea to document that.
> 
> Will do.
> 
> > And we should enable callbacks at that point, not here on data path.
> 
> I'm not sure I understand here. Are you suggesting removing the
> !user_napi check here?
> 
>                 if (!use_napi &&
>                     unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>                         /* More just got used, free them then recheck. */
>                         free_old_xmit_skbs(sq, false);
>                         if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
>                                 netif_start_subqueue(dev, qnum);
>                                 virtqueue_disable_cb(sq->vq);
>                         }
>                 }


At least, I suggest calling virtqueue_enable_cb_delayed around
this area of code. I have not really thought all this path through
and how all the corner cases interact.



> Btw, it doesn't differ too much as kick is always true without pktgen
> and that may even need more comments or make the code even harder to
> read. We need a patch for -stable at least so I prefer to let this
> patch go first and do optimization on top.
> 
> Thanks

There's a chance of perf regression here too.  Let's write the full
patch first of all. If you want to make it a 2 patch series that is fine
but it is here since 2021 I don't see why we should rush a fix. Worry
about backporting later.

> >
> >
> > > >
> > > > Thanks.
> > > >
> > > > >
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > >     /* timestamp packet in software */
> > > > > >     skb_tx_timestamp(skb);
> > > > > > --
> > > > > > 2.25.1
> > > > >
> > > > > _______________________________________________
> > > > > Virtualization mailing list
> > > > > Virtualization@lists.linux-foundation.org
> > > > > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> > > >
> >

