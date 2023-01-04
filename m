Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7766065CD57
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 07:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjADGs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 01:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbjADGre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 01:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E449A186F8
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 22:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672814776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZlFWtxiRkDtk+thRF9nVuLB+b4oL2TYgzK5e9wk6bs=;
        b=SOOS8aI83cGhGdG2ckdETkO+AvAKw6/I1mzXh0cWm2ObnR3Oc0hTOR6dvkiwyxLtu+/KY0
        McwH5kTcpX/O1e8umacApWemFGXdRoSTCzhogLjB9kgQ6N07DCtDesJ4tqaFQNCcxYXS91
        RQCE/C7oLa5zLszqrNRdjFIItVgsKoo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-zobgy0YdN12E8epQ5PYeNg-1; Wed, 04 Jan 2023 01:46:14 -0500
X-MC-Unique: zobgy0YdN12E8epQ5PYeNg-1
Received: by mail-wm1-f71.google.com with SMTP id r15-20020a05600c35cf00b003d9a14517b2so8230607wmq.2
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 22:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dZlFWtxiRkDtk+thRF9nVuLB+b4oL2TYgzK5e9wk6bs=;
        b=BF16GiDHv05hwy0SWhmtlodiujBmbmNDh+BzTWC9IvGFU2nHxKp1Yp0nziu7tuKz+N
         YYz6vIcVOEhFj0O0dfpPm2NvrBomKHeWILKP9RrSmCTIh180TjjDDCQOU2n7vysn7nYJ
         TNm4FiMX/pyNaq8dNyY4bYRwVsgkVDVezqktkUzMBv1sfM0xgZRIU8GbdfxlcYQQxzOA
         mRV+wfgZk9fkefUWId4VbGOv6Vy4OAFZDHaZyca2/5S/9Sk+JlkMqCl/PUzDOYW1fTd0
         iSlx1tAhb6+DRGOU6SgncV9PP4H4pulK2Sx5bCbA+0vufY129eJw5RKF3fmIFTxAmYLm
         74qA==
X-Gm-Message-State: AFqh2kpqZkaZOmCH+UZ9Pb4ooKV/5LimW32UXWSaXO6F8XeM0zu/e77h
        AzDS0IMbe4XMk88UxXxoA3/oFXoQCvdU99VyPD/6sMOOQpFKgmUYLDnod+GdpW1erD2TU+CpMaO
        efsdgHTiXziCkpEdC
X-Received: by 2002:a05:600c:3ba7:b0:3d3:4dac:aa69 with SMTP id n39-20020a05600c3ba700b003d34dacaa69mr32523075wms.36.1672814773590;
        Tue, 03 Jan 2023 22:46:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtsmKlEtrhGwFJV/isqLZ83QMfqezcC6GQt8r/1BBQD+my1HQhflP0L+uExmpASFxDlO1tKIg==
X-Received: by 2002:a05:600c:3ba7:b0:3d3:4dac:aa69 with SMTP id n39-20020a05600c3ba700b003d34dacaa69mr32523066wms.36.1672814773307;
        Tue, 03 Jan 2023 22:46:13 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id x7-20020a05600c188700b003d9aa76dc6asm17424241wmp.0.2023.01.03.22.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 22:46:12 -0800 (PST)
Date:   Wed, 4 Jan 2023 01:46:09 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net V2] virtio-net: correctly enable callback during
 start_xmit
Message-ID: <20230104014256-mutt-send-email-mst@kernel.org>
References: <20221215032719.72294-1-jasowang@redhat.com>
 <20221215034740-mutt-send-email-mst@kernel.org>
 <CACGkMEsLeCRDqyuyGzWw+kjYrTVDjUjOw6+xHESPT2D1p03=sQ@mail.gmail.com>
 <20221215042918-mutt-send-email-mst@kernel.org>
 <CACGkMEsbvTQrEp5dmQRHp58Mu=E7f433Xrvsbs4nZMA5R3B6mQ@mail.gmail.com>
 <CACGkMEsu_OFFs15d2dzNbfSjzAZfYXLn9CNcO3ELPbDqZsndzg@mail.gmail.com>
 <50eb0df0-89fe-a5df-f89f-07bf69bd00ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50eb0df0-89fe-a5df-f89f-07bf69bd00ae@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 12:23:07PM +0800, Jason Wang wrote:
> 
> 在 2022/12/23 14:29, Jason Wang 写道:
> > On Fri, Dec 16, 2022 at 11:43 AM Jason Wang <jasowang@redhat.com> wrote:
> > > On Thu, Dec 15, 2022 at 5:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > On Thu, Dec 15, 2022 at 05:15:43PM +0800, Jason Wang wrote:
> > > > > On Thu, Dec 15, 2022 at 5:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > On Thu, Dec 15, 2022 at 11:27:19AM +0800, Jason Wang wrote:
> > > > > > > Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> > > > > > > virtqueue callback via the following statement:
> > > > > > > 
> > > > > > >          do {
> > > > > > >             ......
> > > > > > >        } while (use_napi && kick &&
> > > > > > >                 unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> > > > > > > 
> > > > > > > When NAPI is used and kick is false, the callback won't be enabled
> > > > > > > here. And when the virtqueue is about to be full, the tx will be
> > > > > > > disabled, but we still don't enable tx interrupt which will cause a TX
> > > > > > > hang. This could be observed when using pktgen with burst enabled.
> > > > > > > 
> > > > > > > Fixing this by trying to enable tx interrupt after we disable TX when
> > > > > > > we're not using napi or kick is false.
> > > > > > > 
> > > > > > > Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > ---
> > > > > > > The patch is needed for -stable.
> > > > > > > Changes since V1:
> > > > > > > - enable tx interrupt after we disable tx
> > > > > > > ---
> > > > > > >   drivers/net/virtio_net.c | 2 +-
> > > > > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > > index 86e52454b5b5..dcf3a536d78a 100644
> > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > @@ -1873,7 +1873,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > > > > >         */
> > > > > > >        if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> > > > > > >                netif_stop_subqueue(dev, qnum);
> > > > > > > -             if (!use_napi &&
> > > > > > > +             if ((!use_napi || !kick) &&
> > > > > > >                    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
> > > > > > >                        /* More just got used, free them then recheck. */
> > > > > > >                        free_old_xmit_skbs(sq, false);
> > > > > > This will work but the following lines are:
> > > > > > 
> > > > > >                         if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
> > > > > >                                  netif_start_subqueue(dev, qnum);
> > > > > >                                  virtqueue_disable_cb(sq->vq);
> > > > > >                          }
> > > > > > 
> > > > > > 
> > > > > > and I thought we are supposed to keep callbacks enabled with napi?
> > > > > This seems to be the opposite logic of commit a7766ef18b33 that
> > > > > disables callbacks for NAPI.
> > > > > 
> > > > > It said:
> > > > > 
> > > > >      There are currently two cases where we poll TX vq not in response to a
> > > > >      callback: start xmit and rx napi.  We currently do this with callbacks
> > > > >      enabled which can cause extra interrupts from the card.  Used not to be
> > > > >      a big issue as we run with interrupts disabled but that is no longer the
> > > > >      case, and in some cases the rate of spurious interrupts is so high
> > > > >      linux detects this and actually kills the interrupt.
> > > > > 
> > > > > My undersatnding is that it tries to disable callbacks on TX.
> > > > I think we want to disable callbacks while polling, yes. here we are not
> > > > polling, and I think we want a callback because otherwise nothing will
> > > > orphan skbs and a socket can be blocked, not transmitting anything - a
> > > > deadlock.
> > > I'm not sure how I got here, did you mean a partial revert of
> > > a7766ef18b33 (the part that disables TX callbacks on start_xmit)?
> > Michael, any idea on this?
> > 
> > Thanks
> 
> 
> Michael, any comment?
> 
> Thanks

Sorry I don't understand the question. What does "how I got here" mean?
To repeat my suggestion:

	I think it is easier to just do a separate branch here. Along the
	lines of:

			if (use_napi) {
				if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
					virtqueue_napi_schedule(napi, vq);
			} else {
				... old code ...
			}

we can also backport this minimal safe fix, any refactorings can be done on
top.


-- 
MST

