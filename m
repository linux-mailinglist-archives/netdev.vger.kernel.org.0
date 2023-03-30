Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08F96CFBD4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjC3GqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjC3GqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA372A5
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680158693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uOR4AABgXY6rT1UM0saCrM1Os02S42xCRn/OKU3aRlo=;
        b=EUGSwN2WBw3PVVluN96Ial7RYlisMSAQYejsxyW8S0ZR4YZ711+N4xgHUwSSwSOKsjSu3Y
        5jNkGopcNW9JHqtGQP3tOxfNNbtyWbsG7thb/gbpPZaQ5/A49MeQ1OkQ1ajEKJeN6Nd5MJ
        kwIyz6Y/sdSpcIdSxWLffCS0P4AovKk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-VI5wM4lYOkSM0jFKukMEew-1; Thu, 30 Mar 2023 02:44:50 -0400
X-MC-Unique: VI5wM4lYOkSM0jFKukMEew-1
Received: by mail-wm1-f71.google.com with SMTP id bg33-20020a05600c3ca100b003ef6d684105so5617549wmb.1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680158689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOR4AABgXY6rT1UM0saCrM1Os02S42xCRn/OKU3aRlo=;
        b=yAGXM2SRDv2iu+tuTNVlOb7S4XWYA9411vQESLD8ydHvHL0sKelyD4AE1LBWEz9XRj
         a7H0Q88lpK4UaYk9WV5CkCXpQo3BpmtJoS27H8k7+SrigvMfRNnch78UqexlKySS/sMK
         qtzquTKtxSomOhSJo6ru0VIUrfv81CwgCDj2uJ0xneemtU65E1iBB9lAb0rLoKJkmK+I
         1DDuQFnVGZYrFipR5lsXpzFuC+hwJhOrBmg4a2P3b9508wThnaIub5aevoUnA4zSUYXJ
         SnKYHqxB8Bfb0MumeFbMm/S4KkpDl5UKsRCD0hl2SmoX+5j5zJse4X153KJXI/ft8aq/
         IpFA==
X-Gm-Message-State: AAQBX9cTYKjd5zsUOdX3zgrjYD0qVuvhTWRR4KtgpsiGxLp1OINWTlNY
        Bn/ONma3yRvZtoKaBkXWqITWiQgtoaMDGtoNv4G7RYTmHicAtZN7CHVc6/zShRHkFQ0YekGghms
        No01U+XEGK7fmnuLb4wknFpoQ
X-Received: by 2002:a7b:c045:0:b0:3ef:6fee:8057 with SMTP id u5-20020a7bc045000000b003ef6fee8057mr9121724wmc.25.1680158688798;
        Wed, 29 Mar 2023 23:44:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350b9YXLwf8YQAIK1wJbojYDvpMv6wMNdBsep+spzdVpXknozxcuIotMCTlq+T8/9wIqhpHiyXQ==
X-Received: by 2002:a7b:c045:0:b0:3ef:6fee:8057 with SMTP id u5-20020a7bc045000000b003ef6fee8057mr9121710wmc.25.1680158688488;
        Wed, 29 Mar 2023 23:44:48 -0700 (PDT)
Received: from redhat.com ([2.52.159.107])
        by smtp.gmail.com with ESMTPSA id f17-20020a05600c4e9100b003ede3f5c81fsm5062688wmq.41.2023.03.29.23.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 23:44:47 -0700 (PDT)
Date:   Thu, 30 Mar 2023 02:44:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Willem de Bruijn <willemb@google.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] virtio: fix up virtio_disable_cb
Message-ID: <20230330024220-mutt-send-email-mst@kernel.org>
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-4-mst@redhat.com>
 <1680156457.5551112-5-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1680156457.5551112-5-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:07:37PM +0800, Xuan Zhuo wrote:
> On Wed, 26 May 2021 04:24:40 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > virtio_disable_cb is currently a nop for split ring with event index.
> > This is because it used to be always called from a callback when we know
> > device won't trigger more events until we update the index.  However,
> > now that we run with interrupts enabled a lot we also poll without a
> > callback so that is different: disabling callbacks will help reduce the
> > number of spurious interrupts.
> > Further, if using event index with a packed ring, and if being called
> > from a callback, we actually do disable interrupts which is unnecessary.
> >
> > Fix both issues by tracking whenever we get a callback. If that is
> > the case disabling interrupts with event index can be a nop.
> > If not the case disable interrupts. Note: with a split ring
> > there's no explicit "no interrupts" value. For now we write
> > a fixed value so our chance of triggering an interupt
> > is 1/ring size. It's probably better to write something
> > related to the last used index there to reduce the chance
> > even further. For now I'm keeping it simple.
> 
> 
> Don't understand, is this patch necessary? For this patch set, we can do without
> this patch.
> 
> So doest this patch optimize virtqueue_disable_cb() by reducing a modification of
> vring_used_event(&vq-> split.vring)?
> 
> Or I miss something.
> 
> Thanks.

Before this patch virtqueue_disable_cb did nothing at all
for the common case of event index enabled, so
calling it from virtio net would not help matters.

But the patch is from 2021, isn't it a bit too late to argue?
If you have a cleanup or an optimization in mind, please
post a patch.

> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/virtio/virtio_ring.c | 26 +++++++++++++++++++++++++-
> >  1 file changed, 25 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 71e16b53e9c1..88f0b16b11b8 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -113,6 +113,9 @@ struct vring_virtqueue {
> >  	/* Last used index we've seen. */
> >  	u16 last_used_idx;
> >
> > +	/* Hint for event idx: already triggered no need to disable. */
> > +	bool event_triggered;
> > +
> >  	union {
> >  		/* Available for split ring */
> >  		struct {
> > @@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
> >
> >  	if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
> >  		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> > -		if (!vq->event)
> > +		if (vq->event)
> > +			/* TODO: this is a hack. Figure out a cleaner value to write. */
> > +			vring_used_event(&vq->split.vring) = 0x0;
> > +		else
> >  			vq->split.vring.avail->flags =
> >  				cpu_to_virtio16(_vq->vdev,
> >  						vq->split.avail_flags_shadow);
> > @@ -1605,6 +1611,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
> >  	vq->weak_barriers = weak_barriers;
> >  	vq->broken = false;
> >  	vq->last_used_idx = 0;
> > +	vq->event_triggered = false;
> >  	vq->num_added = 0;
> >  	vq->packed_ring = true;
> >  	vq->use_dma_api = vring_use_dma_api(vdev);
> > @@ -1919,6 +1926,12 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
> >  {
> >  	struct vring_virtqueue *vq = to_vvq(_vq);
> >
> > +	/* If device triggered an event already it won't trigger one again:
> > +	 * no need to disable.
> > +	 */
> > +	if (vq->event_triggered)
> > +		return;
> > +
> >  	if (vq->packed_ring)
> >  		virtqueue_disable_cb_packed(_vq);
> >  	else
> > @@ -1942,6 +1955,9 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
> >  {
> >  	struct vring_virtqueue *vq = to_vvq(_vq);
> >
> > +	if (vq->event_triggered)
> > +		vq->event_triggered = false;
> > +
> >  	return vq->packed_ring ? virtqueue_enable_cb_prepare_packed(_vq) :
> >  				 virtqueue_enable_cb_prepare_split(_vq);
> >  }
> > @@ -2005,6 +2021,9 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
> >  {
> >  	struct vring_virtqueue *vq = to_vvq(_vq);
> >
> > +	if (vq->event_triggered)
> > +		vq->event_triggered = false;
> > +
> >  	return vq->packed_ring ? virtqueue_enable_cb_delayed_packed(_vq) :
> >  				 virtqueue_enable_cb_delayed_split(_vq);
> >  }
> > @@ -2044,6 +2063,10 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> >  	if (unlikely(vq->broken))
> >  		return IRQ_HANDLED;
> >
> > +	/* Just a hint for performance: so it's ok that this can be racy! */
> > +	if (vq->event)
> > +		vq->event_triggered = true;
> > +
> >  	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
> >  	if (vq->vq.callback)
> >  		vq->vq.callback(&vq->vq);
> > @@ -2083,6 +2106,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> >  	vq->weak_barriers = weak_barriers;
> >  	vq->broken = false;
> >  	vq->last_used_idx = 0;
> > +	vq->event_triggered = false;
> >  	vq->num_added = 0;
> >  	vq->use_dma_api = vring_use_dma_api(vdev);
> >  #ifdef DEBUG
> > --
> > MST
> >
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization

