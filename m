Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5DF4D291D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiCIGrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiCIGrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:47:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BEA0148653
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646808380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRVRzg4ndvIzPu33NbzHcBz6mikHjCXmzmHbidN+vIU=;
        b=gG4Ou3ZDeEnzRhqGUSkpbAyxYkw1Kgf1RMgnIAxeGkKoFqc5Bt1NDHgE0ZoLT+vEJ3IT3M
        RkYwRAIb3zY+pJ66aweie/v4GvYxD7WjYMRSqD4zPVG4oAgTGtqphzCI9t8gxEDTXVYQeu
        o6/0lYMabgHp7MEOftiandMx0TJUa0M=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-MZzinYVRPu67YSPTMg2RTA-1; Wed, 09 Mar 2022 01:46:19 -0500
X-MC-Unique: MZzinYVRPu67YSPTMg2RTA-1
Received: by mail-pj1-f69.google.com with SMTP id lt6-20020a17090b354600b001bf5a121802so1032856pjb.1
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 22:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZRVRzg4ndvIzPu33NbzHcBz6mikHjCXmzmHbidN+vIU=;
        b=XfRZ1mc67h7KZp76V0zk6KxC7tClA1VAcQYWBiYOwHdDN13FF6AEd/qXmqC0AG+Iuk
         6Pi9M/Bj91AGGcMKsVjugdCZAuGwtll3FYKWwoAdM6e8iBWEs3c/idw1g9NKC3WS831b
         qWhRGthHZWu+n6u2yvd3fkp4b5dj+540hk7M5TAq6gx6ZUYpOHbZbj55Lpp2jt9jYoY7
         cbmNY+fknsQjeSEKVCg+trUKTb2vfHi6OdUEdnpqnYpOiGF2OXQgpRdQBP5fGOeaGEvb
         N/DSOMxv5hElZRmuXuaFpO4Yxb4xkJW3dSfF/pYOXYXM9dQnF7QiqnFuXGNS7GxoLxq0
         gkwg==
X-Gm-Message-State: AOAM533Ko6NCT/EtzKBJzOtFT988yQuH4oxr0OyMoYoVoJuise/lrcSr
        lr23Q9DNsTpdefwGiQcDEpdQrtxdE63+JWgfRgkIND1IjPgSNJod49F725/ncO5YcxUUv/f21mt
        ekaNJJ8LqZgoPzeig
X-Received: by 2002:a17:90a:c252:b0:1bc:52a8:cac8 with SMTP id d18-20020a17090ac25200b001bc52a8cac8mr8770706pjx.61.1646808378330;
        Tue, 08 Mar 2022 22:46:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCn5oXYtQPYpNPdMU9Bvo1WQfVx7qdQtm4/+iiiL6XGVmBAI7JHTUBwTId/vpyk0ZnEZggTw==
X-Received: by 2002:a17:90a:c252:b0:1bc:52a8:cac8 with SMTP id d18-20020a17090ac25200b001bc52a8cac8mr8770665pjx.61.1646808378008;
        Tue, 08 Mar 2022 22:46:18 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c3-20020a056a00248300b004f6f729e485sm1396753pfv.127.2022.03.08.22.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 22:46:17 -0800 (PST)
Message-ID: <4b32d0b4-b794-cc1c-25f7-50b5ea6ac25e@redhat.com>
Date:   Wed, 9 Mar 2022 14:46:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 04/26] virtio_ring: split: extract the logic of
 creating vring
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
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
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-5-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-5-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午8:34, Xuan Zhuo 写道:
> Separate the logic of split to create vring queue.
>
> For the convenience of passing parameters, add a structure
> vring_split.
>
> This feature is required for subsequent virtuqueue reset vring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 74 +++++++++++++++++++++++++-----------
>   1 file changed, 51 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index b87130c8f312..d32793615451 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -85,6 +85,13 @@ struct vring_desc_extra {
>   	u16 next;			/* The next desc state in a list. */
>   };
>   
> +struct vring_split {
> +	void *queue;
> +	dma_addr_t dma_addr;
> +	size_t queue_size_in_bytes;
> +	struct vring vring;
> +};


So this structure will be only used in vring_create_vring_split() which 
seems not that useful.

More see below.


> +
>   struct vring_virtqueue {
>   	struct virtqueue vq;
>   
> @@ -915,28 +922,21 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
>   	return NULL;
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
> +static int vring_create_vring_split(struct vring_split *vring,
> +				    struct virtio_device *vdev,
> +				    unsigned int vring_align,
> +				    bool weak_barriers,
> +				    bool may_reduce_num,
> +				    u32 num)


I'd rename this as vring_alloc_queue_split() and let it simply return 
the address of queue like vring_alloc_queue().

And let it simple accept dma_addr_t *dma_adder instead of vring_split.


>   {
> -	struct virtqueue *vq;
>   	void *queue = NULL;
>   	dma_addr_t dma_addr;
>   	size_t queue_size_in_bytes;
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
> @@ -947,11 +947,11 @@ static struct virtqueue *vring_create_virtqueue_split(
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
> @@ -959,21 +959,49 @@ static struct virtqueue *vring_create_virtqueue_split(
>   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
>   	}
>   	if (!queue)
> -		return NULL;
> +		return -ENOMEM;
>   
>   	queue_size_in_bytes = vring_size(num, vring_align);
> -	vring_init(&vring, num, queue, vring_align);
> +	vring_init(&vring->vring, num, queue, vring_align);


It's better to move this to its caller (vring_create_virtqueue_split), 
so we have rather simple logic below:



> +
> +	vring->dma_addr = dma_addr;
> +	vring->queue = queue;
> +	vring->queue_size_in_bytes = queue_size_in_bytes;
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
> +	struct vring_split vring;
> +	struct virtqueue *vq;
> +	int err;
> +
> +	err = vring_create_vring_split(&vring, vdev, vring_align, weak_barriers,
> +				       may_reduce_num, num);
> +	if (err)
> +		return NULL;


queue = vring_alloc_queue_split(vdev, &dma_addr, ...);

if (!queue)

     return -ENOMEM;

vring_init();

...

Thanks


>   
> -	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
> +	vq = __vring_new_virtqueue(index, vring.vring, vdev, weak_barriers, context,
>   				   notify, callback, name);
>   	if (!vq) {
> -		vring_free_queue(vdev, queue_size_in_bytes, queue,
> -				 dma_addr);
> +		vring_free_queue(vdev, vring.queue_size_in_bytes, vring.queue,
> +				 vring.dma_addr);
>   		return NULL;
>   	}
>   
> -	to_vvq(vq)->split.queue_dma_addr = dma_addr;
> -	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
> +	to_vvq(vq)->split.queue_dma_addr = vring.dma_addr;
> +	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
>   	to_vvq(vq)->we_own_ring = true;
>   
>   	return vq;

