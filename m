Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FDD3925C3
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhE0EC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhE0EC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622088084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YFTuqobSNbOR8Wq6p+a7ao2//KKDypGgE4erIL0zlEM=;
        b=b1s5HhanVptRawpD407ioiyNwHcd5++t0lF8jgqWEmxayipEJjoHhsy36R0HY+/puxVFzd
        c/RUmeVVbvVdCqvqwHpaP+r+KbAs/SoAtwP/ep0CfxsFyqWyKREoMzXzNckyKS7h7PiRVQ
        THosOtz/0IL3wOlMYc+6MpeJvz1XP7E=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-1Ep15G1IMC60vWhtN_h2bw-1; Thu, 27 May 2021 00:01:22 -0400
X-MC-Unique: 1Ep15G1IMC60vWhtN_h2bw-1
Received: by mail-pf1-f198.google.com with SMTP id o16-20020a056a0015d0b02902e11ab01eb7so2032295pfu.14
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 21:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YFTuqobSNbOR8Wq6p+a7ao2//KKDypGgE4erIL0zlEM=;
        b=XURpyg/2+Md8nVUMtd541i10kTwqfSR3i3xqY1dYvTFMWPAZJsIwBjHhDXCTcm88ER
         SkUyND1g3WlS0NVilWh0l+M99hDc2b0ut0snvklWYd9lNPkL2fLN7XUqHmUA5Wt4i/mx
         DrYugsGR9QnEp32rSxdmuRDXj1ZC653teyKDC8k6hFLjS9CZmmsDyKvE7R7oTOFITayQ
         r7rZEX92FGhcXOujfGLVv0ZahbIDsIUmT1Fi09Sw/mUawtbz1AlQeZddmB38aWVrBQ+1
         1SY6J/G3DHFMyK66B32ticEXqN7uvo9blFXVW0d8PCr7UlZXUhKIMUmQeyddZEEiEbKY
         x5dA==
X-Gm-Message-State: AOAM530nJHQnf/1t6uuas7bhBPeUWg7Ps5Qqo1B6SROaLbHaH43gnOmG
        oFbLD6YQyBYOjqx9jBKTk3Y8VL0A2O1m+GgtjCn5RIVkj5PAdah0KzmPYDFHihrfQcXlNmbb6qO
        INfRge9UR3VcvNFcP
X-Received: by 2002:a05:6a00:1705:b029:2e7:60df:7413 with SMTP id h5-20020a056a001705b02902e760df7413mr1764227pfc.48.1622088081688;
        Wed, 26 May 2021 21:01:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT94njfKbzIhMIA4Q1yN5K+12taVUkR5i/koVkhVbs5xSnZwAsySH3w+t2YxLpWBdJTfGJuQ==
X-Received: by 2002:a05:6a00:1705:b029:2e7:60df:7413 with SMTP id h5-20020a056a001705b02902e760df7413mr1764191pfc.48.1622088081275;
        Wed, 26 May 2021 21:01:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p14sm529443pgb.2.2021.05.26.21.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 21:01:20 -0700 (PDT)
Subject: Re: [PATCH v3 3/4] virtio: fix up virtio_disable_cb
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-4-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c5dbc2b4-7b14-ea5a-27cf-ed88810f9b37@redhat.com>
Date:   Thu, 27 May 2021 12:01:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210526082423.47837-4-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/26 ÏÂÎç4:24, Michael S. Tsirkin Ð´µÀ:
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


This seems unnecessary:

1) we check avail_flags_shadow before touching touching the index
2) The nop is not good at least for split, if we choose a suitable event 
index, it can help to reduce the chance of 1/N interrupt, (see below).


> If not the case disable interrupts. Note: with a split ring
> there's no explicit "no interrupts" value. For now we write
> a fixed value so our chance of triggering an interupt
> is 1/ring size.


1/65535 actually? If yes, do we still need this trick?


>   It's probably better to write something
> related to the last used index there to reduce the chance
> even further. For now I'm keeping it simple.
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


used_idx or last_used_idx seems better here.


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


Miss the case of virtqueue_enable_cb()?

Thanks


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

