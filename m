Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113AA564C40
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 05:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiGDD7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 23:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiGDD7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 23:59:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 374396343
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 20:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656907159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p95fHLs7IXJ+3ymkILJufL2vVjxBw7J8XWFPcIqmw9I=;
        b=Xy3G0e+2hBhN4G3IS3AkdWaAA+wf+E8IOG7sIfArhsd0qba5CeMGb26G2SlOzVUGXD+GZ0
        Kuk0veM//9BI/tW1MInCF+IXLfx56u5t8QoI7LVKw7/ULhrFgwDuvAex6Dt+mOMKpJLW/B
        +lam0kbEyJ4SMODDb7V2WAlKp0rPHhc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-mZcFPrlSMWOprpFnsHF5mg-1; Sun, 03 Jul 2022 23:59:18 -0400
X-MC-Unique: mZcFPrlSMWOprpFnsHF5mg-1
Received: by mail-pj1-f71.google.com with SMTP id gq11-20020a17090b104b00b001ed2625f43eso3976360pjb.0
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 20:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p95fHLs7IXJ+3ymkILJufL2vVjxBw7J8XWFPcIqmw9I=;
        b=hMBBCoW/itfRVQu44+HjawBFonLtTDUWzthzV90Oz/N017PeuWTMUSKbfsI7cqy+fv
         X/T7nOcAUbEGh54QjZCq7LbrNtL2VEDkbTFgAIG+DrVpz5Qz+HRti/1Z7i1z5m6FPbK4
         euRwh/e5EHTRiYwGui4Ohbvu3f8rj2ZvLFGO9gyrOTJ89aJDULEExF9upY9Ldqdi/tOt
         cGBwnO8i7hBMQ1PKvoly0WdslvDNTKZKGEcULqkrbCcrNO/GRQBIEAoiHdYi057XlIMO
         EMGq/pZzM23YWls7Sj3ZMUo8GLaZb0Uj4BtsV9KdwjnJSGNeqrUt8Df2DNDg9xjLMw1u
         OBFQ==
X-Gm-Message-State: AJIora/jU9dzh3ikLCWvExHd13KJxHn8TQuFE/lr3IkzcM0KJBJGEbcj
        zYnke5uGwFTBnhPgbJ3cu/GmdYMKQyFjY2NTGpwY4gWHxjKS7f8eA6XkOIB96EbWF6Eky/euuSf
        KkXaJsQN6NoT9wQ7o
X-Received: by 2002:a05:6a00:16ca:b0:525:a5d5:d16f with SMTP id l10-20020a056a0016ca00b00525a5d5d16fmr34632588pfc.9.1656907156992;
        Sun, 03 Jul 2022 20:59:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sWi4hsGm0Pp4sg0fpR82xMi1IIpeySfzr0ygsh6naHJBfI17iJdT2wRICqdgS0m98H2IZYQw==
X-Received: by 2002:a05:6a00:16ca:b0:525:a5d5:d16f with SMTP id l10-20020a056a0016ca00b00525a5d5d16fmr34632565pfc.9.1656907156707;
        Sun, 03 Jul 2022 20:59:16 -0700 (PDT)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c9-20020a170903234900b0016be834d54asm212167plh.306.2022.07.03.20.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 20:59:16 -0700 (PDT)
Message-ID: <6daca7fd-ae2a-cd0c-2030-3c6e503a3200@redhat.com>
Date:   Mon, 4 Jul 2022 11:59:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 08/40] virtio_ring: split: extract the logic of alloc
 queue
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        kangjie.xu@linux.alibaba.com,
        virtualization@lists.linux-foundation.org
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-9-xuanzhuo@linux.alibaba.com>
 <3e36e44f-1f37-ad02-eb89-833a0856ec4e@redhat.com>
 <1656665158.0036178-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1656665158.0036178-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/1 16:45, Xuan Zhuo 写道:
> On Fri, 1 Jul 2022 16:26:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2022/6/29 14:56, Xuan Zhuo 写道:
>>> Separate the logic of split to create vring queue.
>>>
>>> This feature is required for subsequent virtuqueue reset vring.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>    drivers/virtio/virtio_ring.c | 68 ++++++++++++++++++++++--------------
>>>    1 file changed, 42 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>>> index 49d61e412dc6..a9ceb9c16c54 100644
>>> --- a/drivers/virtio/virtio_ring.c
>>> +++ b/drivers/virtio/virtio_ring.c
>>> @@ -949,28 +949,19 @@ static void vring_free_split(struct vring_virtqueue_split *vring,
>>>    	kfree(vring->desc_extra);
>>>    }
>>>
>>> -static struct virtqueue *vring_create_virtqueue_split(
>>> -	unsigned int index,
>>> -	unsigned int num,
>>> -	unsigned int vring_align,
>>> -	struct virtio_device *vdev,
>>> -	bool weak_barriers,
>>> -	bool may_reduce_num,
>>> -	bool context,
>>> -	bool (*notify)(struct virtqueue *),
>>> -	void (*callback)(struct virtqueue *),
>>> -	const char *name)
>>> +static int vring_alloc_queue_split(struct vring_virtqueue_split *vring,
>>> +				   struct virtio_device *vdev,
>>> +				   u32 num,
>>> +				   unsigned int vring_align,
>>> +				   bool may_reduce_num)
>>>    {
>>> -	struct virtqueue *vq;
>>>    	void *queue = NULL;
>>>    	dma_addr_t dma_addr;
>>> -	size_t queue_size_in_bytes;
>>> -	struct vring vring;
>>>
>>>    	/* We assume num is a power of 2. */
>>>    	if (num & (num - 1)) {
>>>    		dev_warn(&vdev->dev, "Bad virtqueue length %u\n", num);
>>> -		return NULL;
>>> +		return -EINVAL;
>>>    	}
>>>
>>>    	/* TODO: allocate each queue chunk individually */
>>> @@ -981,11 +972,11 @@ static struct virtqueue *vring_create_virtqueue_split(
>>>    		if (queue)
>>>    			break;
>>>    		if (!may_reduce_num)
>>> -			return NULL;
>>> +			return -ENOMEM;
>>>    	}
>>>
>>>    	if (!num)
>>> -		return NULL;
>>> +		return -ENOMEM;
>>>
>>>    	if (!queue) {
>>>    		/* Try to get a single page. You are my only hope! */
>>> @@ -993,21 +984,46 @@ static struct virtqueue *vring_create_virtqueue_split(
>>>    					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
>>>    	}
>>>    	if (!queue)
>>> -		return NULL;
>>> +		return -ENOMEM;
>>> +
>>> +	vring_init(&vring->vring, num, queue, vring_align);
>>>
>>> -	queue_size_in_bytes = vring_size(num, vring_align);
>>> -	vring_init(&vring, num, queue, vring_align);
>>> +	vring->queue_dma_addr = dma_addr;
>>> +	vring->queue_size_in_bytes = vring_size(num, vring_align);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static struct virtqueue *vring_create_virtqueue_split(
>>> +	unsigned int index,
>>> +	unsigned int num,
>>> +	unsigned int vring_align,
>>> +	struct virtio_device *vdev,
>>> +	bool weak_barriers,
>>> +	bool may_reduce_num,
>>> +	bool context,
>>> +	bool (*notify)(struct virtqueue *),
>>> +	void (*callback)(struct virtqueue *),
>>> +	const char *name)
>>> +{
>>> +	struct vring_virtqueue_split vring = {};
>>> +	struct virtqueue *vq;
>>> +	int err;
>>> +
>>> +	err = vring_alloc_queue_split(&vring, vdev, num, vring_align,
>>> +				      may_reduce_num);
>>> +	if (err)
>>> +		return NULL;
>>>
>>> -	vq = __vring_new_virtqueue(index, vring, vdev, weak_barriers, context,
>>> -				   notify, callback, name);
>>> +	vq = __vring_new_virtqueue(index, vring.vring, vdev, weak_barriers,
>>> +				   context, notify, callback, name);
>>>    	if (!vq) {
>>> -		vring_free_queue(vdev, queue_size_in_bytes, queue,
>>> -				 dma_addr);
>>> +		vring_free_split(&vring, vdev);
>>>    		return NULL;
>>>    	}
>>>
>>> -	to_vvq(vq)->split.queue_dma_addr = dma_addr;
>>> -	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
>>> +	to_vvq(vq)->split.queue_dma_addr = vring.queue_dma_addr;
>>
>> Nit: having two queue_dma_addr seems redundant (so did queue_size_in_bytes).
> two?
>
> Where is the problem I don't understand?
>
> Thanks.


I meant we had:

         vring.vring = _vring;

in __vring_new_virtqueue().

This means we'd better initialize vring fully before that?

E.g

vring.queue_dma_addr = dma_addr;

...

__vring_new_virtqueue()

Thanks


>
>> Thanks
>>
>>
>>> +	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
>>>    	to_vvq(vq)->we_own_ring = true;
>>>
>>>    	return vq;

