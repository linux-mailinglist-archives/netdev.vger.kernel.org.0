Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80299562E2A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiGAI21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbiGAI1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:27:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBC46735A4
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 01:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656664002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mem2CtrGfxmddRRMbJG4npPrqtnwHTpIMWeASXZJ6Uo=;
        b=hzgbPLootc2W5V5pjJcCkk9GHaK9PQQpYo0oSYDXihtnWPZ5iklasORHPLdqNFrpAwQpsm
        qRA8aw9DfBHjSjC306d+EzO7FypKl3zU6L6K2x593RKIyqQmCrjpEWpYvBtKpDFTlgoIQ3
        ToIqG+mpK71CEBSCu4TF7gg9CLlr7DQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-xm08oPMkOvGITf7TsTMPwA-1; Fri, 01 Jul 2022 04:26:40 -0400
X-MC-Unique: xm08oPMkOvGITf7TsTMPwA-1
Received: by mail-pg1-f197.google.com with SMTP id h13-20020a63e14d000000b0040df75eaa2eso969945pgk.21
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 01:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mem2CtrGfxmddRRMbJG4npPrqtnwHTpIMWeASXZJ6Uo=;
        b=P1K1sgAGwTho9XgVholcB7p4ZrwqQsR7IOXzZZpQbYDL1GfH8trBTg307enmO6fiXf
         4jBBdEXpvuItmNCn+5YYYHewDeUTWLjIcwKBi5epEpdU+EKLnl2CD+kl5/QF48S5JuXx
         lb79hagrGPTxlAEfjm6uItsnPjd7POrXjBHgLlxw7h24e//hIGDj5V0v/5IF+JISOdmV
         qKkEIlOBmKf7vqStcpxJDubInOXPTkWvNkyD9N1iPc9dUCvZvUOlz+8Tn0mJqy1eNIMD
         Wl9fpe8l1kq5GP7CnmQ+35vsa0eRMpwAqfVXZ7GgF+NO72oTnMB9E0Wa1PhjuUx9jYK5
         uEzg==
X-Gm-Message-State: AJIora/+qcEUJJUJXNLfocK4kUuv5yXWemeSxEBFZLFKPRB6XmdJKoZm
        okghUPHzasdnJn61qwIWXOhdcbfQaq0gL4snMSpXabbae78Y45OApczJdJtn2Jan5C9MXnV+pIf
        /0Gu9B9qWSBKMeeuM
X-Received: by 2002:a17:902:e749:b0:16a:2839:9e5 with SMTP id p9-20020a170902e74900b0016a283909e5mr19890583plf.48.1656663999674;
        Fri, 01 Jul 2022 01:26:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vueEJCyj9aKVsA6oCsFeYHLH6QjdhbrRxTJq+B9bWaSeLtACSCbAXT8VnogHMY6xhUpS/k6w==
X-Received: by 2002:a17:902:e749:b0:16a:2839:9e5 with SMTP id p9-20020a170902e74900b0016a283909e5mr19890568plf.48.1656663999418;
        Fri, 01 Jul 2022 01:26:39 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id pc3-20020a17090b3b8300b001ef3f85d1aasm2978628pjb.9.2022.07.01.01.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 01:26:38 -0700 (PDT)
Message-ID: <3e36e44f-1f37-ad02-eb89-833a0856ec4e@redhat.com>
Date:   Fri, 1 Jul 2022 16:26:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 08/40] virtio_ring: split: extract the logic of alloc
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
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-9-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/6/29 14:56, Xuan Zhuo 写道:
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
> index 49d61e412dc6..a9ceb9c16c54 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -949,28 +949,19 @@ static void vring_free_split(struct vring_virtqueue_split *vring,
>   	kfree(vring->desc_extra);
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
> +static int vring_alloc_queue_split(struct vring_virtqueue_split *vring,
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
> @@ -981,11 +972,11 @@ static struct virtqueue *vring_create_virtqueue_split(
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
> @@ -993,21 +984,46 @@ static struct virtqueue *vring_create_virtqueue_split(
>   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
>   	}
>   	if (!queue)
> -		return NULL;
> +		return -ENOMEM;
> +
> +	vring_init(&vring->vring, num, queue, vring_align);
>   
> -	queue_size_in_bytes = vring_size(num, vring_align);
> -	vring_init(&vring, num, queue, vring_align);
> +	vring->queue_dma_addr = dma_addr;
> +	vring->queue_size_in_bytes = vring_size(num, vring_align);
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
> +	struct vring_virtqueue_split vring = {};
> +	struct virtqueue *vq;
> +	int err;
> +
> +	err = vring_alloc_queue_split(&vring, vdev, num, vring_align,
> +				      may_reduce_num);
> +	if (err)
> +		return NULL;
>   
> -	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
> -				   notify, callback, name);
> +	vq = __vring_new_virtqueue(index, vring.vring, vdev, weak_barriers,
> +				   context, notify, callback, name);
>   	if (!vq) {
> -		vring_free_queue(vdev, queue_size_in_bytes, queue,
> -				 dma_addr);
> +		vring_free_split(&vring, vdev);
>   		return NULL;
>   	}
>   
> -	to_vvq(vq)->split.queue_dma_addr = dma_addr;
> -	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
> +	to_vvq(vq)->split.queue_dma_addr = vring.queue_dma_addr;


Nit: having two queue_dma_addr seems redundant (so did queue_size_in_bytes).

Thanks


> +	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
>   	to_vvq(vq)->we_own_ring = true;
>   
>   	return vq;

