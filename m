Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6054D2994
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiCIHiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiCIHiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:38:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85675163075
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646811440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sMEcmKvWTfkwOGTY0mg2j6/A06z9bpywHvH//xyyNqc=;
        b=KC3H7rwp/indfmUVuixrbAFF+azYx5j4H/aruguJzyZrHjej8Phikvs/vKRXBOhW/1QgHG
        /2F1U5Kd2t28JFe+bQIqBrubV0X1D6lylMWM8FYESKlfH6Kjn4rWfB759E5zh0jB8DxvXV
        eQaZVWBqGZR4bS1GdEb6+AD5IRAuRco=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-DYdQrvL8MZK2k_2caVP8CA-1; Wed, 09 Mar 2022 02:37:19 -0500
X-MC-Unique: DYdQrvL8MZK2k_2caVP8CA-1
Received: by mail-pl1-f197.google.com with SMTP id i7-20020a170902cf0700b0015163eb319eso726441plg.18
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:37:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sMEcmKvWTfkwOGTY0mg2j6/A06z9bpywHvH//xyyNqc=;
        b=HH0sbKvBpuak5GN4reQQ5v1EgKMzdzoIteYiCZ1xttpAVVshgXxjY/0GNOwaTPUFLB
         UVDh4rte47pWk0EJ+8SRgkGCSSfe33d1doDkbxVoawg5ZwOkU/wBcpqr+WRhM30eQrT9
         nNE1WCeE3s6kqE/lGpbw5QxiNW1lUqFZFoCUww9iL7SU2NKOhM/esriozMbC03vUXsxu
         CmFJFx8w2zPkgItTBrPcRAfVWCfRGoD59V6wuHkpF5lp0reqgPxO9iKLiPKMMPv7UFni
         9XqS/RTr88PDGf0b/KmA0vzmPLlx4wxWQFHZ7NpaRYQPaiFGzEtUQJIwYPWJEjmVuK/H
         Wc/Q==
X-Gm-Message-State: AOAM533HqLNetlc7scWKMcD20yTEOJJZlDSZbnwKvaEmtcKyn5ExG5ua
        LNNGinT2GGRB6xALzLyDuxtUOu7TnI44zQc9S2W+ARDfy0oAPCSGuS0hLZ6cP1sx/JBOEmugGkD
        Gcwgc0zcf8kwcn5JH
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr22031545pfu.59.1646811438353;
        Tue, 08 Mar 2022 23:37:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeSQCV1x95spvXZKCf44swYuLOm7pVeGy+nzLvzOes3JlsRDFZ7LGk7k7ZLhK2Jc/KIlUJGw==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr22031523pfu.59.1646811437956;
        Tue, 08 Mar 2022 23:37:17 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s30-20020a056a001c5e00b004f73f27aa40sm1631425pfw.161.2022.03.08.23.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 23:37:17 -0800 (PST)
Message-ID: <85dde6ed-cdf1-61e4-6f05-d3e2477b9e35@redhat.com>
Date:   Wed, 9 Mar 2022 15:36:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 05/26] virtio_ring: split: extract the logic of init vq
 and attach vring
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
 <20220308123518.33800-6-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-6-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午8:34, Xuan Zhuo 写道:
> Split the logic of split assignment vq into three parts.
>
> 1. The assignment passed from the function parameter
> 2. The part that attaches vring to vq. -- __vring_virtqueue_attach_split()
> 3. The part that initializes vq to a fixed value --
>     __vring_virtqueue_init_split()
>
> This feature is required for subsequent virtuqueue reset vring
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 111 +++++++++++++++++++++--------------
>   1 file changed, 67 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index d32793615451..dc6313b79305 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2196,34 +2196,40 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>   }
>   EXPORT_SYMBOL_GPL(vring_interrupt);
>   
> -/* Only available for split ring */
> -struct virtqueue *__vring_new_virtqueue(unsigned int index,
> -					struct vring vring,
> -					struct virtio_device *vdev,
> -					bool weak_barriers,
> -					bool context,
> -					bool (*notify)(struct virtqueue *),
> -					void (*callback)(struct virtqueue *),
> -					const char *name)
> +static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> +					  struct virtio_device *vdev,
> +					  struct vring vring)
>   {
> -	struct vring_virtqueue *vq;
> +	vq->vq.num_free = vring.num;
>   
> -	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> -		return NULL;
> +	vq->split.vring = vring;
> +	vq->split.queue_dma_addr = 0;
> +	vq->split.queue_size_in_bytes = 0;
>   
> -	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
> -	if (!vq)
> -		return NULL;
> +	vq->split.desc_state = kmalloc_array(vring.num,
> +					     sizeof(struct vring_desc_state_split), GFP_KERNEL);
> +	if (!vq->split.desc_state)
> +		goto err_state;
>   
> +	vq->split.desc_extra = vring_alloc_desc_extra(vq, vring.num);
> +	if (!vq->split.desc_extra)
> +		goto err_extra;


So this contains stuffs more than just attach. I wonder if it's better 
to split the allocation out to an dedicated helper (we have dedicated 
helper to allocate vring).

Thanks


> +
> +	memset(vq->split.desc_state, 0, vring.num *
> +	       sizeof(struct vring_desc_state_split));
> +	return 0;
> +
> +err_extra:
> +	kfree(vq->split.desc_state);
> +err_state:
> +	return -ENOMEM;
> +}
> +
> +static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> +					 struct virtio_device *vdev)
> +{
>   	vq->packed_ring = false;
> -	vq->vq.callback = callback;
> -	vq->vq.vdev = vdev;
> -	vq->vq.name = name;
> -	vq->vq.num_free = vring.num;
> -	vq->vq.index = index;
>   	vq->we_own_ring = false;
> -	vq->notify = notify;
> -	vq->weak_barriers = weak_barriers;
>   	vq->broken = false;
>   	vq->last_used_idx = 0;
>   	vq->event_triggered = false;
> @@ -2234,50 +2240,67 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->last_add_time_valid = false;
>   #endif
>   
> -	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
> -		!context;
>   	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
>   
>   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>   		vq->weak_barriers = false;
>   
> -	vq->split.queue_dma_addr = 0;
> -	vq->split.queue_size_in_bytes = 0;
> -
> -	vq->split.vring = vring;
>   	vq->split.avail_flags_shadow = 0;
>   	vq->split.avail_idx_shadow = 0;
>   
>   	/* No callback?  Tell other side not to bother us. */
> -	if (!callback) {
> +	if (!vq->vq.callback) {
>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
>   		if (!vq->event)
>   			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
>   					vq->split.avail_flags_shadow);
>   	}
>   
> -	vq->split.desc_state = kmalloc_array(vring.num,
> -			sizeof(struct vring_desc_state_split), GFP_KERNEL);
> -	if (!vq->split.desc_state)
> -		goto err_state;
> -
> -	vq->split.desc_extra = vring_alloc_desc_extra(vq, vring.num);
> -	if (!vq->split.desc_extra)
> -		goto err_extra;
> -
>   	/* Put everything in free lists. */
>   	vq->free_head = 0;
> -	memset(vq->split.desc_state, 0, vring.num *
> -			sizeof(struct vring_desc_state_split));
> +}
> +
> +/* Only available for split ring */
> +struct virtqueue *__vring_new_virtqueue(unsigned int index,
> +					struct vring vring,
> +					struct virtio_device *vdev,
> +					bool weak_barriers,
> +					bool context,
> +					bool (*notify)(struct virtqueue *),
> +					void (*callback)(struct virtqueue *),
> +					const char *name)
> +{
> +	struct vring_virtqueue *vq;
> +	int err;
> +
> +	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> +		return NULL;
> +
> +	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
> +	if (!vq)
> +		return NULL;
> +
> +	vq->vq.callback = callback;
> +	vq->vq.vdev = vdev;
> +	vq->vq.name = name;
> +	vq->vq.index = index;
> +	vq->notify = notify;
> +	vq->weak_barriers = weak_barriers;
> +	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
> +		!context;
> +
> +	err = __vring_virtqueue_attach_split(vq, vdev, vring);
> +	if (err)
> +		goto err;
> +
> +	__vring_virtqueue_init_split(vq, vdev);
>   
>   	spin_lock(&vdev->vqs_list_lock);
>   	list_add_tail(&vq->vq.list, &vdev->vqs);
>   	spin_unlock(&vdev->vqs_list_lock);
> -	return &vq->vq;
>   
> -err_extra:
> -	kfree(vq->split.desc_state);
> -err_state:
> +	return &vq->vq;
> +err:
>   	kfree(vq);
>   	return NULL;
>   }

