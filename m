Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8D64D8AC
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLOJf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiLOJfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:35:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A1C31DD1
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671096902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=81Hq6t0bBAAS+O4HOr41urE88Cd72754O7sYgGyx03s=;
        b=ZBFdU0cSqAKx+WcH9lKRVumA9mSHZkBgC8fUSETzvB9j4QpBkv2L05kZUVNfuUnTesoB/K
        FVXnFGt34/AMcoP7nJLevoFfuCiwhnYoL9Ye2d6v/8+pg3b9d8RDZPLI96vW1fu9DLf9rR
        GA8eShjx8GtcXQKxxCkzZ2EDK4IEY3U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-153-NYtVF4giOT2VE5Rvu_zmoA-1; Thu, 15 Dec 2022 04:35:01 -0500
X-MC-Unique: NYtVF4giOT2VE5Rvu_zmoA-1
Received: by mail-wm1-f69.google.com with SMTP id bi19-20020a05600c3d9300b003cf9d6c4016so903197wmb.8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81Hq6t0bBAAS+O4HOr41urE88Cd72754O7sYgGyx03s=;
        b=v0jbCHlAryl4HIN+lZsOMVPsMwBVaq7pG5viz81G6OCjfalYyEbXQWsZNWq4QQybWK
         smoifOCRxv+1B9dIcNMmiK2FLWopRQUqUGbOS3ERuaGzkJ7AaYdwcC7eeBnCA2CxYIak
         y+CE7D+bO9WjCv6brUptm1FS+II6OC0kxvvCo7plKewFYJsKlF2+BvgIVkxsYKH5pHW2
         pri9n0mpZDD40Toig0j4aYE2sgXdkDLPMCSPuRNvpaklRmPN/XjXaMyQCqvfmlkuOgKG
         SkzTBQ96jJCBkzIsFwAWWsF0bvKKv7ZZEUXatH1Rn+7Cl24ncLxMql5VAr5vsnN1/2Ix
         EJwA==
X-Gm-Message-State: ANoB5pkMAk5ZKbANnjwu0oQpH+5+bqtfyVx4DJs7h5+85w2qjpUREoad
        CqactW86kKNIgpETt/sSz3Aksq3N5ts9X/2hUDAC1HRWZPAefJrVkbype2G+tyHnAhjCWpvfiLP
        iNGfdxl9JRKuhMSJd
X-Received: by 2002:a05:600c:4f48:b0:3cf:76c3:b2e2 with SMTP id m8-20020a05600c4f4800b003cf76c3b2e2mr21438988wmq.35.1671096899531;
        Thu, 15 Dec 2022 01:34:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4CHoxsEL13wD3BHfSaLfTzzWcogwYUTAak9uDbxIO6dJ63q+Xxv2aZVTQVgg131D6MsPYvDg==
X-Received: by 2002:a05:600c:4f48:b0:3cf:76c3:b2e2 with SMTP id m8-20020a05600c4f4800b003cf76c3b2e2mr21438976wmq.35.1671096899307;
        Thu, 15 Dec 2022 01:34:59 -0800 (PST)
Received: from redhat.com ([2a02:14f:179:247f:e426:6c6e:c44d:93b])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003cf78aafdd7sm6804213wms.39.2022.12.15.01.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 01:34:58 -0800 (PST)
Date:   Thu, 15 Dec 2022 04:34:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net V2] virtio-net: correctly enable callback during
 start_xmit
Message-ID: <20221215042918-mutt-send-email-mst@kernel.org>
References: <20221215032719.72294-1-jasowang@redhat.com>
 <20221215034740-mutt-send-email-mst@kernel.org>
 <CACGkMEsLeCRDqyuyGzWw+kjYrTVDjUjOw6+xHESPT2D1p03=sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsLeCRDqyuyGzWw+kjYrTVDjUjOw6+xHESPT2D1p03=sQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 05:15:43PM +0800, Jason Wang wrote:
> On Thu, Dec 15, 2022 at 5:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Dec 15, 2022 at 11:27:19AM +0800, Jason Wang wrote:
> > > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > > virtqueue callback via the following statement:
> > >
> > >         do {
> > >            ......
> > >       } while (use_napi && kick &&
> > >                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > >
> > > When NAPI is used and kick is false, the callback won't be enabled
> > > here. And when the virtqueue is about to be full, the tx will be
> > > disabled, but we still don't enable tx interrupt which will cause a TX
> > > hang. This could be observed when using pktgen with burst enabled.
> > >
> > > Fixing this by trying to enable tx interrupt after we disable TX when
> > > we're not using napi or kick is false.
> > >
> > > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > The patch is needed for -stable.
> > > Changes since V1:
> > > - enable tx interrupt after we disable tx
> > > ---
> > >  drivers/net/virtio_net.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 86e52454b5b5..dcf3a536d78a 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1873,7 +1873,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >        */
> > >       if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> > >               netif_stop_subqueue(dev, qnum);
> > > -             if (!use_napi &&
> > > +             if ((!use_napi || !kick) &&
> > >                   unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
> > >                       /* More just got used, free them then recheck. */
> > >                       free_old_xmit_skbs(sq, false);
> >
> > This will work but the following lines are:
> >
> >                        if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
> >                                 netif_start_subqueue(dev, qnum);
> >                                 virtqueue_disable_cb(sq->vq);
> >                         }
> >
> >
> > and I thought we are supposed to keep callbacks enabled with napi?
> 
> This seems to be the opposite logic of commit a7766ef18b33 that
> disables callbacks for NAPI.
> 
> It said:
> 
>     There are currently two cases where we poll TX vq not in response to a
>     callback: start xmit and rx napi.  We currently do this with callbacks
>     enabled which can cause extra interrupts from the card.  Used not to be
>     a big issue as we run with interrupts disabled but that is no longer the
>     case, and in some cases the rate of spurious interrupts is so high
>     linux detects this and actually kills the interrupt.
> 
> My undersatnding is that it tries to disable callbacks on TX.

I think we want to disable callbacks while polling, yes. here we are not
polling, and I think we want a callback because otherwise nothing will
orphan skbs and a socket can be blocked, not transmitting anything - a
deadlock.

> > One of the ideas of napi is to free on napi callback, not here
> > immediately.
> >
> > I think it is easier to just do a separate branch here. Along the
> > lines of:
> >
> >                 if (use_napi) {
> >                         if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
> >                                 virtqueue_napi_schedule(napi, vq);
> 
> This seems to be a new logic and it causes some delay in processing TX
> (unnecessary NAPI).

That's good, we overloaded the queue so we are already going
too fast, deferring tx so queue has chance to drain
will allow better batching in the qdisc.

> >                 } else {
> >                         ... old code ...
> >                 }
> >
> > also reduces chances of regressions on !napi (which is not well tested)
> > and keeps callbacks off while we free skbs.
> 
> I think my patch doesn't change the logic of !napi? (It checks !napi || kick).
> 
> Thanks

I agree it doesn't seem to as written.

> >
> > No?
> >
> >
> > > --
> > > 2.25.1
> >

