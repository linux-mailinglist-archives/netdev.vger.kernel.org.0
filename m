Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D1157C727
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiGUJON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiGUJOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B70AE3A4A5
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658394849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=evkly4mzwl0OWnSDguyVCSXP+iuc3cHesZCTCuELO9c=;
        b=bi/1RWaUSvioDjb7hiQP3rC6fip0ynqgPiUuocQACvPjrjDN9PPeuHbw02dN6L0YVJuhmz
        obWbtgk3R5vBxaIRjeK9sqI5662gLpx2sJwAv4kO2/2Uj2ALUmNiPa848br24AOgKBZYF9
        68tgK1UKhFNYnCILlVSI5V4XT9I5Xh4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-JwAADmbKMOKcg8ix9OjDEw-1; Thu, 21 Jul 2022 05:14:03 -0400
X-MC-Unique: JwAADmbKMOKcg8ix9OjDEw-1
Received: by mail-pj1-f71.google.com with SMTP id o13-20020a17090ab88d00b001f1ef2109aaso2564221pjr.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=evkly4mzwl0OWnSDguyVCSXP+iuc3cHesZCTCuELO9c=;
        b=8J2fvoKo91k8gB3Gc88p8YE59tga709MUaABqn0lLngcIcQH6sGYpEKcXu1CIpDbqF
         cU+jTvZvrA8atopjvnJG4VwcN7s3+8RbdbENOaRyHICNVTTifusDhG7XXGi6ksIZU5yq
         jCviketAfTQYWd1yvRZYQzo6xSd1s2bfEZ9WJdj+BuFKEW6/5pRH1BUOH3DROfUsoozI
         TJFgg8E5oKqRrsjVOYo+UYkgNH1pMWVe2tj4eqgobu22gzGb5JJgca5ipAgWTpIXYCue
         7yuVFXwcq7iDQD08Jhu07q4IBqnA1ktwo3mS/xzyVLFLCZW3ATJ/mm6b7d75qYLy/kAT
         ntww==
X-Gm-Message-State: AJIora9WGj4muC/R9Jop3Xxocwx1NrApy1pOTbT0RyesdwbjBEtAdaM2
        xXjWCpokfZ84G9PdHF4akmiJc6hUwecCpt+mQXoBDs2Z6FLFL0P0ojx597srwjkuUDsn80savxm
        hBhk1wAPgEtj2/XXr
X-Received: by 2002:a17:90b:681:b0:1f2:147a:5e55 with SMTP id m1-20020a17090b068100b001f2147a5e55mr10137463pjz.159.1658394841816;
        Thu, 21 Jul 2022 02:14:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vZd1H6ktLLHxg0oQu5yg8T5pv3EpQ1CpRpfXswCqn2eqimIJKu3rbioASMftx5YraJgvSUnw==
X-Received: by 2002:a17:90b:681:b0:1f2:147a:5e55 with SMTP id m1-20020a17090b068100b001f2147a5e55mr10137436pjz.159.1658394841532;
        Thu, 21 Jul 2022 02:14:01 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z28-20020aa7949c000000b0052516db7123sm1181543pfk.35.2022.07.21.02.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:14:00 -0700 (PDT)
Message-ID: <0b3c985d-d479-a554-4fe2-bfe94fc74070@redhat.com>
Date:   Thu, 21 Jul 2022 17:13:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 08/40] virtio_ring: split: extract the logic of alloc
 queue
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-9-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> Separate the logic of split to create vring queue.
>
> This feature is required for subsequent virtuqueue reset vring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 68 ++++++++++++++++++++++--------------
>   1 file changed, 42 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index c94c5461e702..c7971438bb2c 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -950,28 +950,19 @@ static void vring_free_split(struct vring_virtqueue_split *vring_split,
>   	kfree(vring_split->desc_extra);
>   }
>   
> -static struct virtqueue *vring_create_virtqueue_split(
> -	unsigned int index,
> -	unsigned int num,
> -	unsigned int vring_align,
> -	struct virtio_device *vdev,
> -	bool weak_barriers,
> -	bool may_reduce_num,
> -	bool context,
> -	bool (*notify)(struct virtqueue *),
> -	void (*callback)(struct virtqueue *),
> -	const char *name)
> +static int vring_alloc_queue_split(struct vring_virtqueue_split *vring_split,
> +				   struct virtio_device *vdev,
> +				   u32 num,
> +				   unsigned int vring_align,
> +				   bool may_reduce_num)
>   {
> -	struct virtqueue *vq;
>   	void *queue = NULL;
>   	dma_addr_t dma_addr;
> -	size_t queue_size_in_bytes;
> -	struct vring vring;
>   
>   	/* We assume num is a power of 2. */
>   	if (num & (num - 1)) {
>   		dev_warn(&vdev->dev, "Bad virtqueue length %u\n", num);
> -		return NULL;
> +		return -EINVAL;
>   	}
>   
>   	/* TODO: allocate each queue chunk individually */
> @@ -982,11 +973,11 @@ static struct virtqueue *vring_create_virtqueue_split(
>   		if (queue)
>   			break;
>   		if (!may_reduce_num)
> -			return NULL;
> +			return -ENOMEM;
>   	}
>   
>   	if (!num)
> -		return NULL;
> +		return -ENOMEM;
>   
>   	if (!queue) {
>   		/* Try to get a single page. You are my only hope! */
> @@ -994,21 +985,46 @@ static struct virtqueue *vring_create_virtqueue_split(
>   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
>   	}
>   	if (!queue)
> -		return NULL;
> +		return -ENOMEM;
> +
> +	vring_init(&vring_split->vring, num, queue, vring_align);
>   
> -	queue_size_in_bytes = vring_size(num, vring_align);
> -	vring_init(&vring, num, queue, vring_align);
> +	vring_split->queue_dma_addr = dma_addr;
> +	vring_split->queue_size_in_bytes = vring_size(num, vring_align);
> +
> +	return 0;
> +}
> +
> +static struct virtqueue *vring_create_virtqueue_split(
> +	unsigned int index,
> +	unsigned int num,
> +	unsigned int vring_align,
> +	struct virtio_device *vdev,
> +	bool weak_barriers,
> +	bool may_reduce_num,
> +	bool context,
> +	bool (*notify)(struct virtqueue *),
> +	void (*callback)(struct virtqueue *),
> +	const char *name)
> +{
> +	struct vring_virtqueue_split vring_split = {};
> +	struct virtqueue *vq;
> +	int err;
> +
> +	err = vring_alloc_queue_split(&vring_split, vdev, num, vring_align,
> +				      may_reduce_num);
> +	if (err)
> +		return NULL;
>   
> -	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
> -				   notify, callback, name);
> +	vq = __vring_new_virtqueue(index, vring_split.vring, vdev, weak_barriers,
> +				   context, notify, callback, name);
>   	if (!vq) {
> -		vring_free_queue(vdev, queue_size_in_bytes, queue,
> -				 dma_addr);
> +		vring_free_split(&vring_split, vdev);
>   		return NULL;
>   	}
>   
> -	to_vvq(vq)->split.queue_dma_addr = dma_addr;
> -	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
> +	to_vvq(vq)->split.queue_dma_addr = vring_split.queue_dma_addr;
> +	to_vvq(vq)->split.queue_size_in_bytes = vring_split.queue_size_in_bytes;


This still seems a little bit redundant since the current logic is a 
little bit complicated since the vq->split is not initialized in a 
single place.

I wonder if it's better to:

vring_alloc_queue_split()
vring_alloc_desc_extra() (reorder to make patch 9 come first)

then we can simply assign vring_split to vq->split in 
__vring_new_virtqueue() since it has:

     vq->split.queue_dma_addr = 0;
     vq->split.queue_size_in_bytes = 0;

     vq->split.vring = vring;
     vq->split.avail_flags_shadow = 0;
     vq->split.avail_idx_shadow = 0;

This seems to simplify the logic and task of e.g 
virtqueue_vring_attach_split() to a simple:

vq->split= vring_split;

And if this makes sense, we can do something similar to packed ring.

Thanks


>   	to_vvq(vq)->we_own_ring = true;
>   
>   	return vq;

