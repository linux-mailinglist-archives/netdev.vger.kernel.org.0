Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46564FCD40
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 05:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344991AbiDLDpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344896AbiDLDpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:45:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 791592E086
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649734964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/OsiNJ9A/eOeLohaa+XnOAzDTM4dK3oraaYOkfTH1I=;
        b=Dew50VFpMTJZvW4Y/77ndZDBMolOMm3zuArHEzmtLF214aWQ8vG9W+TvEs7SqXyh+BFniL
        pYZkmBhtOo7Z4/H6JM1GX/Wgk6k53XHDVjo8QUsNI9MzKK4vB/nj9AIIgNUs1dME8+eFc7
        W4MVmWBjDOqiIPWNSsNxJITbsmCvC9Q=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-mSnEnQcLNr6YJ2m30Q4zWg-1; Mon, 11 Apr 2022 23:42:43 -0400
X-MC-Unique: mSnEnQcLNr6YJ2m30Q4zWg-1
Received: by mail-pj1-f69.google.com with SMTP id n17-20020a17090ac69100b001c77ebd900fso769439pjt.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e/OsiNJ9A/eOeLohaa+XnOAzDTM4dK3oraaYOkfTH1I=;
        b=LEWltq5BLsg3TgsADx0sYIeK/d4JlRXnQbANZUmdwW+RG+INtrP3NdHYWy2w5jX6a9
         zKTKwcoJusKMoYf92jR8PZA0Imm0roE4VDLObC89QA8ITppDJ7eZQLIpr8BpLRkJ3Mt4
         +j9xbBiV9bTQjQyMqEoedgW3u1/fKWLdBjWGupjiRngncdUV6jpb3YunFoKwyUvscOc2
         H7adAdJ/HppQ4N0wiDy77wFQbx85xQ81PGpjN5yPFZppqdXSbUfNIHwgSzj5YigHu1O4
         zM+ay0WxMAFeyM6zWi0NU5bfFxYOgUsp1ExgPPkfIbypuMagGR1+UbtEoHF+W7hBPnmr
         o82Q==
X-Gm-Message-State: AOAM532EM5RitoThfc/rc6KH7W0HmGZp8/OY05RMAEtbLCTn2n8bPP28
        LS23pWSWVefu9aj7ZMiybADC97i31oZxTb605f8UG+X8KSZnFDx+I++XOT2JQ0EExvdUeCS+bWQ
        vNFyYkPzfRDeIkJ2d
X-Received: by 2002:a17:902:d641:b0:158:7b09:a597 with SMTP id y1-20020a170902d64100b001587b09a597mr1464273plh.38.1649734962135;
        Mon, 11 Apr 2022 20:42:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMq3ocoOmI2KUnRkjYaMPOtPHjUJwi0YEpLw+I2/CAUycWFX4s/+dC2J75Q6+K+XriTggTwA==
X-Received: by 2002:a17:902:d641:b0:158:7b09:a597 with SMTP id y1-20020a170902d64100b001587b09a597mr1464238plh.38.1649734961868;
        Mon, 11 Apr 2022 20:42:41 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11-20020a63cd4b000000b00378b9167493sm1090853pgj.52.2022.04.11.20.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 20:42:41 -0700 (PDT)
Message-ID: <f91435e4-6559-c0c9-2b37-92084c88dee2@redhat.com>
Date:   Tue, 12 Apr 2022 11:42:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 09/32] virtio_ring: split: extract the logic of vq init
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-10-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-10-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Separate the logic of initializing vq, and subsequent patches will call
> it separately.
>
> The feature of this part is that it does not depend on the information
> passed by the upper layer and can be called repeatedly.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 68 ++++++++++++++++++++----------------
>   1 file changed, 38 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 083f2992ba0d..874f878087a3 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -916,6 +916,43 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
>   	return NULL;
>   }
>   
> +static void vring_virtqueue_init_split(struct vring_virtqueue *vq,
> +				       struct virtio_device *vdev,
> +				       bool own_ring)
> +{
> +	vq->packed_ring = false;
> +	vq->vq.num_free = vq->split.vring.num;
> +	vq->we_own_ring = own_ring;
> +	vq->broken = false;
> +	vq->last_used_idx = 0;
> +	vq->event_triggered = false;
> +	vq->num_added = 0;
> +	vq->use_dma_api = vring_use_dma_api(vdev);
> +#ifdef DEBUG
> +	vq->in_use = false;
> +	vq->last_add_time_valid = false;
> +#endif
> +
> +	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> +
> +	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> +		vq->weak_barriers = false;
> +
> +	vq->split.avail_flags_shadow = 0;
> +	vq->split.avail_idx_shadow = 0;
> +
> +	/* No callback?  Tell other side not to bother us. */
> +	if (!vq->vq.callback) {
> +		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> +		if (!vq->event)
> +			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
> +					vq->split.avail_flags_shadow);
> +	}
> +
> +	/* Put everything in free lists. */
> +	vq->free_head = 0;


It's not clear what kind of initialization that we want to do here. E.g 
it mixes split specific setups with some general setups which is kind of 
duplication of vring_virtqueue_init_packed().

I wonder if it's better to only do split specific setups here and have a 
common helper to do the setup that is irrelevant to ring layout.

Thanks


> +}
> +
>   static void vring_virtqueue_attach_split(struct vring_virtqueue *vq,
>   					 struct vring vring,
>   					 struct vring_desc_state_split *desc_state,
> @@ -2249,42 +2286,15 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	if (!vq)
>   		return NULL;
>   
> -	vq->packed_ring = false;
>   	vq->vq.callback = callback;
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
> -	vq->vq.num_free = vring.num;
>   	vq->vq.index = index;
> -	vq->we_own_ring = false;
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
> -	vq->broken = false;
> -	vq->last_used_idx = 0;
> -	vq->event_triggered = false;
> -	vq->num_added = 0;
> -	vq->use_dma_api = vring_use_dma_api(vdev);
> -#ifdef DEBUG
> -	vq->in_use = false;
> -	vq->last_add_time_valid = false;
> -#endif
>   
>   	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>   		!context;
> -	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> -
> -	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> -		vq->weak_barriers = false;
> -
> -	vq->split.avail_flags_shadow = 0;
> -	vq->split.avail_idx_shadow = 0;
> -
> -	/* No callback?  Tell other side not to bother us. */
> -	if (!callback) {
> -		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
> -		if (!vq->event)
> -			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
> -					vq->split.avail_flags_shadow);
> -	}
>   
>   	err = vring_alloc_state_extra_split(vring.num, &state, &extra);
>   	if (err) {
> @@ -2293,9 +2303,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	}
>   
>   	vring_virtqueue_attach_split(vq, vring, state, extra);
> -
> -	/* Put everything in free lists. */
> -	vq->free_head = 0;
> +	vring_virtqueue_init_split(vq, vdev, false);
>   
>   	spin_lock(&vdev->vqs_list_lock);
>   	list_add_tail(&vq->vq.list, &vdev->vqs);

