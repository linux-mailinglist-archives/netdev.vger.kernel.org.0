Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39349581E08
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240245AbiG0DPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiG0DPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 243C39D
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658891705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAKBMltJyGT+XDVzCIxs8bNeAmqSdQfBVMzuB9SWIpM=;
        b=ENXVBMTqrDiWz8UHE8gn6wA0SHc31fIcYxiBteg02M4UNFDQIGzLXmdrIa9KcYKGpM8Esf
        tuUsOYvqv8A183tZg7muvGGpX/Bne8uxZeZrnHf4XIkOU9IcAdHmPsru8a/DGMsHqWt8rI
        T6GFhhX0hvd/d2Zbp7iDOqyoVOZ77ig=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-smhj_PWONiqcgKw76vEi2g-1; Tue, 26 Jul 2022 23:15:03 -0400
X-MC-Unique: smhj_PWONiqcgKw76vEi2g-1
Received: by mail-pj1-f70.google.com with SMTP id u12-20020a17090a5e4c00b001f22d74c3f1so458595pji.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yAKBMltJyGT+XDVzCIxs8bNeAmqSdQfBVMzuB9SWIpM=;
        b=SzuDCQI2b8ZdhTLqn6NNWfsATosBo7d+RW9WwuWB7v4184qOyZKsWwlx0owXinnXfa
         DzrVI5ha6gnzqvGU90lct0toIfizvkl7z7IV6YelKK3m6/iCHro0HpaIyA8Zyr9tdyB0
         lUBBgLHVjMOBxjHsOKjyqBbu9QavzBfrKgXOCYR+P688mrBffh01V/EdvlGKLhynfnHQ
         oN2O0ceOFyjiXdiNfwngTs8GtIzN4o41GhzWhkdDopoGTSN/raom0GPCvcbCj/DcXQdl
         EzjNcsRNQOI7SQhEwshUgCYuPkRYp5XwihqMFKdF/tRq7M5Cdki78DU7dr75uZ0n/VhQ
         IuTw==
X-Gm-Message-State: AJIora/xivABEiSNLvbRKEPq/r1xzo8NgYcCNmBZkLlaF/3vTKJ8lfpN
        WPfWAe7/Ed+ronLEKg/LXQ3Z8eCHOFy8NFjL/6c1sG8ZI4XrguwjZwks7YKkBRxiAWUT1mMMBf3
        iMUNSBwBp/Bs9k5ET
X-Received: by 2002:a17:90a:7ac4:b0:1ef:a606:4974 with SMTP id b4-20020a17090a7ac400b001efa6064974mr2213613pjl.51.1658891702483;
        Tue, 26 Jul 2022 20:15:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tidh/QksEFcBpkv4BftDUD29CxNpBLdCVexTNH/t5AotOLArf7ctQ7cPh2UR9oOEGuuBXIcw==
X-Received: by 2002:a17:90a:7ac4:b0:1ef:a606:4974 with SMTP id b4-20020a17090a7ac400b001efa6064974mr2213573pjl.51.1658891702151;
        Tue, 26 Jul 2022 20:15:02 -0700 (PDT)
Received: from [10.72.13.38] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 2-20020a621902000000b005251fc16ff8sm12401220pfz.220.2022.07.26.20.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 20:15:01 -0700 (PDT)
Message-ID: <b4dde067-35b9-d2c2-a344-310020e6ba19@redhat.com>
Date:   Wed, 27 Jul 2022 11:14:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v13 10/42] virtio_ring: split: extract the logic of alloc
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
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-11-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220726072225.19884-11-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/26 15:21, Xuan Zhuo 写道:
> Separate the logic of split to create vring queue.
>
> This feature is required for subsequent virtuqueue reset vring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 65 ++++++++++++++++++++++--------------
>   1 file changed, 40 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index ba7cc560d823..3817520371ee 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -958,29 +958,19 @@ static void vring_free_split(struct vring_virtqueue_split *vring_split,
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
> -	struct vring_virtqueue_split vring_split = {};
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
> @@ -991,11 +981,11 @@ static struct virtqueue *vring_create_virtqueue_split(
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
> @@ -1003,21 +993,46 @@ static struct virtqueue *vring_create_virtqueue_split(
>   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
>   	}
>   	if (!queue)
> -		return NULL;
> +		return -ENOMEM;
> +
> +	vring_init(&vring_split->vring, num, queue, vring_align);
>   
> -	queue_size_in_bytes = vring_size(num, vring_align);
> -	vring_init(&vring_split.vring, num, queue, vring_align);
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
>   	vq = __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
>   				   context, notify, callback, name);
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
>   	to_vvq(vq)->we_own_ring = true;
>   
>   	return vq;

