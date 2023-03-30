Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1073E6CFC1D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjC3G7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjC3G7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:59:46 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883B16A40;
        Wed, 29 Mar 2023 23:59:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VezVY5m_1680159573;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VezVY5m_1680159573)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 14:59:34 +0800
Message-ID: <1680159261.1588428-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v3 3/4] virtio: fix up virtio_disable_cb
Date:   Thu, 30 Mar 2023 14:54:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemb@google.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-4-mst@redhat.com>
 <1680156457.5551112-5-xuanzhuo@linux.alibaba.com>
 <20230330024220-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230330024220-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 02:44:44 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Mar 30, 2023 at 02:07:37PM +0800, Xuan Zhuo wrote:
> > On Wed, 26 May 2021 04:24:40 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > virtio_disable_cb is currently a nop for split ring with event index.
> > > This is because it used to be always called from a callback when we know
> > > device won't trigger more events until we update the index.  However,
> > > now that we run with interrupts enabled a lot we also poll without a
> > > callback so that is different: disabling callbacks will help reduce the
> > > number of spurious interrupts.
> > > Further, if using event index with a packed ring, and if being called
> > > from a callback, we actually do disable interrupts which is unnecessary.
> > >
> > > Fix both issues by tracking whenever we get a callback. If that is
> > > the case disabling interrupts with event index can be a nop.
> > > If not the case disable interrupts. Note: with a split ring
> > > there's no explicit "no interrupts" value. For now we write
> > > a fixed value so our chance of triggering an interupt
> > > is 1/ring size. It's probably better to write something
> > > related to the last used index there to reduce the chance
> > > even further. For now I'm keeping it simple.
> >
> >
> > Don't understand, is this patch necessary? For this patch set, we can do without
> > this patch.
> >
> > So doest this patch optimize virtqueue_disable_cb() by reducing a modification of
> > vring_used_event(&vq-> split.vring)?
> >
> > Or I miss something.
> >
> > Thanks.
>
> Before this patch virtqueue_disable_cb did nothing at all
> for the common case of event index enabled, so
> calling it from virtio net would not help matters.

I agree with these codes:

-		if (!vq->event)
+		if (vq->event)
+			/* TODO: this is a hack. Figure out a cleaner value to write. */
+			vring_used_event(&vq->split.vring) = 0x0;
+		else


I just don't understand event_triggered.

>
> But the patch is from 2021, isn't it a bit too late to argue?
> If you have a cleanup or an optimization in mind, please
> post a patch.

Sorry, I just have some problems, I don't oppose it. At least it can reduce the
modification of vring_used_event(&vq->split.vring). I think it is also beneficial.

Thanks very much.


>
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/virtio/virtio_ring.c | 26 +++++++++++++++++++++++++-
> > >  1 file changed, 25 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index 71e16b53e9c1..88f0b16b11b8 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -113,6 +113,9 @@ struct vring_virtqueue {
> > >  	/* Last used index we've seen. */
> > >  	u16 last_used_idx;
> > >
> > > +	/* Hint for event idx: already triggered no need to disable. */
> > > +	bool event_triggered;
> > > +
> > >  	union {
> > >  		/* Available for split ring */
> > >  		struct {
> > > @@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
> > >
> > >  	if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
> > >  		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> > > -		if (!vq->event)
> > > +		if (vq->event)
> > > +			/* TODO: this is a hack. Figure out a cleaner value to write. */
> > > +			vring_used_event(&vq->split.vring) = 0x0;
> > > +		else
> > >  			vq->split.vring.avail->flags =
> > >  				cpu_to_virtio16(_vq->vdev,
> > >  						vq->split.avail_flags_shadow);
> > > @@ -1605,6 +1611,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
> > >  	vq->weak_barriers = weak_barriers;
> > >  	vq->broken = false;
> > >  	vq->last_used_idx = 0;
> > > +	vq->event_triggered = false;
> > >  	vq->num_added = 0;
> > >  	vq->packed_ring = true;
> > >  	vq->use_dma_api = vring_use_dma_api(vdev);
> > > @@ -1919,6 +1926,12 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
> > >  {
> > >  	struct vring_virtqueue *vq = to_vvq(_vq);
> > >
> > > +	/* If device triggered an event already it won't trigger one again:
> > > +	 * no need to disable.
> > > +	 */
> > > +	if (vq->event_triggered)
> > > +		return;
> > > +
> > >  	if (vq->packed_ring)
> > >  		virtqueue_disable_cb_packed(_vq);
> > >  	else
> > > @@ -1942,6 +1955,9 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
> > >  {
> > >  	struct vring_virtqueue *vq = to_vvq(_vq);
> > >
> > > +	if (vq->event_triggered)
> > > +		vq->event_triggered = false;
> > > +
> > >  	return vq->packed_ring ? virtqueue_enable_cb_prepare_packed(_vq) :
> > >  				 virtqueue_enable_cb_prepare_split(_vq);
> > >  }
> > > @@ -2005,6 +2021,9 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
> > >  {
> > >  	struct vring_virtqueue *vq = to_vvq(_vq);
> > >
> > > +	if (vq->event_triggered)
> > > +		vq->event_triggered = false;
> > > +
> > >  	return vq->packed_ring ? virtqueue_enable_cb_delayed_packed(_vq) :
> > >  				 virtqueue_enable_cb_delayed_split(_vq);
> > >  }
> > > @@ -2044,6 +2063,10 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> > >  	if (unlikely(vq->broken))
> > >  		return IRQ_HANDLED;
> > >
> > > +	/* Just a hint for performance: so it's ok that this can be racy! */
> > > +	if (vq->event)
> > > +		vq->event_triggered = true;
> > > +
> > >  	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
> > >  	if (vq->vq.callback)
> > >  		vq->vq.callback(&vq->vq);
> > > @@ -2083,6 +2106,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > >  	vq->weak_barriers = weak_barriers;
> > >  	vq->broken = false;
> > >  	vq->last_used_idx = 0;
> > > +	vq->event_triggered = false;
> > >  	vq->num_added = 0;
> > >  	vq->use_dma_api = vring_use_dma_api(vdev);
> > >  #ifdef DEBUG
> > > --
> > > MST
> > >
> > > _______________________________________________
> > > Virtualization mailing list
> > > Virtualization@lists.linux-foundation.org
> > > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>
