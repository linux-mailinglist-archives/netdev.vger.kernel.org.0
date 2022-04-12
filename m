Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66BF4FCD02
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 05:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244302AbiDLDZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbiDLDZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:25:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC83532EF0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649733771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ii42iiWj0aR10COD6FOozUEgdafmCDFIdui5B2E6yYA=;
        b=RB+wQBUo/8AMqSxTxHPdMQtaAfau/pOKHyMvTRNlV06adbNhEdhYa8g96YXUBOK67LtTx6
        O4iMIGbsgamEeU37dzn/f13wbPgKggAKQMzLKBgxp68lUk+09WPFm8KC+NCb2jryI15gvI
        U9kFN4OcZnxm8iCaqlHzprNJXR9xdN4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-iLzPbfC4OP6Dy9QImNDjHg-1; Mon, 11 Apr 2022 23:22:49 -0400
X-MC-Unique: iLzPbfC4OP6Dy9QImNDjHg-1
Received: by mail-pj1-f69.google.com with SMTP id q10-20020a17090a2dca00b001cb87691fbaso2780225pjm.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ii42iiWj0aR10COD6FOozUEgdafmCDFIdui5B2E6yYA=;
        b=mfCsLj1/bwSVnth/sBQO8rmpL1Vw9HXRrPmk1tNSABidcWK07bMMp8itEIlXsGnAD3
         b1AHhqJ4EqdBK55VCvZ0a9gystYVd+7l1ChBXg/X3lvJdPw6hr155O1RGidZQFP9SFmN
         lABy2nCabHpdPnlKBjGFW9r7pshjDnfckR2iyerqduliUWU7CEnI/aebpMSU3+E0Wh3j
         noWjNjXSbg5LMpZPWWgyepS1XGxeccQ/ffd8kbShLe4TeMkAGs9xlBA7gu+nPEZup5Fl
         8B2TZx7RNdKBkC4P4V8Qhmol27SJG/YZ/qRjXtq/2637MXp3XQhLfHq10rOmUistYBoV
         anZA==
X-Gm-Message-State: AOAM531fSxA/cueYuLJIuWuiaxoNAmFiQz6ZdlCYcEqnXMGDNQEwUL7Y
        2m1WnIFzpJbUFx95e26Sx9gElmk4kNMHI5rHvEUCqgx2foqUEZtijIGPku8epAl3ZKUjmzX6/Bk
        vovI+3R8xEoLc2Qcz
X-Received: by 2002:a05:6a00:2286:b0:505:d881:d71 with SMTP id f6-20020a056a00228600b00505d8810d71mr4497649pfe.16.1649733768755;
        Mon, 11 Apr 2022 20:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1snN7U3V3KsQoNYi1CdXRBDYgI2RR0ieFCnowUK1U29yxtigZtWYXVv0HXiJRKmxp91rKBw==
X-Received: by 2002:a05:6a00:2286:b0:505:d881:d71 with SMTP id f6-20020a056a00228600b00505d8810d71mr4497609pfe.16.1649733768442;
        Mon, 11 Apr 2022 20:22:48 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x2-20020a63aa42000000b0038265eb2495sm995405pgo.88.2022.04.11.20.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 20:22:47 -0700 (PDT)
Message-ID: <b435b86d-26af-2e39-8859-6746830769d5@redhat.com>
Date:   Tue, 12 Apr 2022 11:22:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 06/32] virtio_ring: split: extract the logic of alloc
 queue
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
 <20220406034346.74409-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-7-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Separate the logic of split to create vring queue.
>
> This feature is required for subsequent virtuqueue reset vring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++------------
>   1 file changed, 36 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 33fddfb907a6..72d5ae063fa0 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -915,23 +915,15 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
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
> +static void *vring_alloc_queue_split(struct virtio_device *vdev,
> +				     dma_addr_t *dma_addr,
> +				     u32 *n,
> +				     unsigned int vring_align,
> +				     bool weak_barriers,


This is not used in this function.

Thanks


> +				     bool may_reduce_num)
>   {
> -	struct virtqueue *vq;
>   	void *queue = NULL;
> -	dma_addr_t dma_addr;
> -	size_t queue_size_in_bytes;
> -	struct vring vring;
> +	u32 num = *n;
>   
>   	/* We assume num is a power of 2. */
>   	if (num & (num - 1)) {
> @@ -942,7 +934,7 @@ static struct virtqueue *vring_create_virtqueue_split(
>   	/* TODO: allocate each queue chunk individually */
>   	for (; num && vring_size(num, vring_align) > PAGE_SIZE; num /= 2) {
>   		queue = vring_alloc_queue(vdev, vring_size(num, vring_align),
> -					  &dma_addr,
> +					  dma_addr,
>   					  GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
>   		if (queue)
>   			break;
> @@ -956,11 +948,38 @@ static struct virtqueue *vring_create_virtqueue_split(
>   	if (!queue) {
>   		/* Try to get a single page. You are my only hope! */
>   		queue = vring_alloc_queue(vdev, vring_size(num, vring_align),
> -					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
> +					  dma_addr, GFP_KERNEL|__GFP_ZERO);
>   	}
>   	if (!queue)
>   		return NULL;
>   
> +	*n = num;
> +	return queue;
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
> +	size_t queue_size_in_bytes;
> +	struct virtqueue *vq;
> +	dma_addr_t dma_addr;
> +	struct vring vring;
> +	void *queue;
> +
> +	queue = vring_alloc_queue_split(vdev, &dma_addr, &num, vring_align,
> +					weak_barriers, may_reduce_num);
> +	if (!queue)
> +		return NULL;
> +
>   	queue_size_in_bytes = vring_size(num, vring_align);
>   	vring_init(&vring, num, queue, vring_align);
>   

