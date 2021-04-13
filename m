Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5A835DA5D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbhDMIvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:51:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243589AbhDMIvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618303881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jCposirTbsc74EjO13nDclHit9p5R2qmCz4hXiIKwZg=;
        b=eiZSHu4DbdnLnSkFziOK1Ar9+MS0vTZSzfAnOSVTNblufMS5fnpCA+ytUyq5bRKXc5D5zH
        5DS4QgGTZrU9HJiWdw+1ym/gTguo9tkY8VappT+MdEaqdco4JGVWzJL4bftpBxhB+zqoJl
        Vesej0T7R+pOzRX9Dh56fWueJheA3sY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-VUhAiWeYM1WfVsiK56hWtg-1; Tue, 13 Apr 2021 04:51:17 -0400
X-MC-Unique: VUhAiWeYM1WfVsiK56hWtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAA2C83DD27;
        Tue, 13 Apr 2021 08:51:15 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-128.pek2.redhat.com [10.72.13.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8ACD959456;
        Tue, 13 Apr 2021 08:51:07 +0000 (UTC)
Subject: Re: [PATCH RFC v2 1/4] virtio: fix up virtio_disable_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-2-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6d0666bb-7f0d-c442-13cc-9e5b715290e6@redhat.com>
Date:   Tue, 13 Apr 2021 16:51:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413054733.36363-2-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/13 ÏÂÎç1:47, Michael S. Tsirkin Ð´µÀ:
> virtio_disable_cb is currently a nop for split ring with event index.
> This is because it used to be always called from a callback when we know
> device won't trigger more events until we update the index.  However,
> now that we run with interrupts enabled a lot we also poll without a
> callback so that is different: disabling callbacks will help reduce the
> number of spurious interrupts.
> Further, if using event index with a packed ring, and if being called
> from a callback, we actually do disable interrupts which is unnecessary.
>
> Fix both issues by tracking whenever we get a callback. If that is
> the case disabling interrupts with event index can be a nop.
> If not the case disable interrupts. Note: with a split ring
> there's no explicit "no interrupts" value. For now we write
> a fixed value so our chance of triggering an interupt
> is 1/ring size. It's probably better to write something
> related to the last used index there to reduce the chance
> even further. For now I'm keeping it simple.


So I wonder whether last_used_idx is better, it looks to me the device 
will never move used index "across" that:

https://lore.kernel.org/patchwork/patch/946475/

And it looks to me it's better to move the optimization 
(event_triggered) into a separated patch.


>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/virtio/virtio_ring.c | 26 +++++++++++++++++++++++++-
>   1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 71e16b53e9c1..88f0b16b11b8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -113,6 +113,9 @@ struct vring_virtqueue {
>   	/* Last used index we've seen. */
>   	u16 last_used_idx;
>   
> +	/* Hint for event idx: already triggered no need to disable. */
> +	bool event_triggered;
> +
>   	union {
>   		/* Available for split ring */
>   		struct {
> @@ -739,7 +742,10 @@ static void virtqueue_disable_cb_split(struct virtqueue *_vq)
>   
>   	if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> -		if (!vq->event)
> +		if (vq->event)
> +			/* TODO: this is a hack. Figure out a cleaner value to write. */
> +			vring_used_event(&vq->split.vring) = 0x0;
> +		else
>   			vq->split.vring.avail->flags =
>   				cpu_to_virtio16(_vq->vdev,
>   						vq->split.avail_flags_shadow);
> @@ -1605,6 +1611,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->weak_barriers = weak_barriers;
>   	vq->broken = false;
>   	vq->last_used_idx = 0;
> +	vq->event_triggered = false;
>   	vq->num_added = 0;
>   	vq->packed_ring = true;
>   	vq->use_dma_api = vring_use_dma_api(vdev);
> @@ -1919,6 +1926,12 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   
> +	/* If device triggered an event already it won't trigger one again:
> +	 * no need to disable.
> +	 */
> +	if (vq->event_triggered)
> +		return;


I guess we nee to check vq->event as well.

Thanks


> +
>   	if (vq->packed_ring)
>   		virtqueue_disable_cb_packed(_vq);
>   	else
> @@ -1942,6 +1955,9 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   
> +	if (vq->event_triggered)
> +		vq->event_triggered = false;
> +
>   	return vq->packed_ring ? virtqueue_enable_cb_prepare_packed(_vq) :
>   				 virtqueue_enable_cb_prepare_split(_vq);
>   }
> @@ -2005,6 +2021,9 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   
> +	if (vq->event_triggered)
> +		vq->event_triggered = false;
> +
>   	return vq->packed_ring ? virtqueue_enable_cb_delayed_packed(_vq) :
>   				 virtqueue_enable_cb_delayed_split(_vq);
>   }
> @@ -2044,6 +2063,10 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>   	if (unlikely(vq->broken))
>   		return IRQ_HANDLED;
>   
> +	/* Just a hint for performance: so it's ok that this can be racy! */
> +	if (vq->event)
> +		vq->event_triggered = true;
> +
>   	pr_debug("virtqueue callback for %p (%p)\n", vq, vq->vq.callback);
>   	if (vq->vq.callback)
>   		vq->vq.callback(&vq->vq);
> @@ -2083,6 +2106,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->weak_barriers = weak_barriers;
>   	vq->broken = false;
>   	vq->last_used_idx = 0;
> +	vq->event_triggered = false;
>   	vq->num_added = 0;
>   	vq->use_dma_api = vring_use_dma_api(vdev);
>   #ifdef DEBUG

