Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4934257C4F9
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiGUHHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGUHHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:07:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE6D07AC0A
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658387249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2P/fakD309VXAoVD6j5x51+KtbA6fMKZfHVhcOwNC8=;
        b=P15KCgyox0GdbaBVU9+C6DkaFpE3/c+/pTVlMTrMoK/gjoCtQFBxtZCfr05dPuibQoynCG
        rQYMICz7r77Fb0+h/Ph2Z3ur1nPUBNeY5Jo+i4A/7v2SfIrvvEQSlv1KkA5GRA8kZbiM3x
        xQ+pdTBnUfoK9DXlJ9RHuVeGam6OGMc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-MDPk6-1nMkiIg7OfPKbjyQ-1; Thu, 21 Jul 2022 03:07:28 -0400
X-MC-Unique: MDPk6-1nMkiIg7OfPKbjyQ-1
Received: by mail-pf1-f199.google.com with SMTP id r7-20020aa79627000000b00528beaf82c3so474627pfg.8
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p2P/fakD309VXAoVD6j5x51+KtbA6fMKZfHVhcOwNC8=;
        b=TaOjTblQIx7WPRy3V67ZgVOAs3i2OM6cE04V5wOIztSeMdO8Koqh04suh0Juog13we
         7pZIyffgt2hoz7JyZgTe9IIwwwv0eWs0AQKfW8e7il5zw5EBVG6kn9EV6NUQoM79Rltx
         HLd+luQiWnGcRqwgNBWeNsQ7KqZcM5bb3IAmtoGd5rKRHN2esD9ZXmjouPwXmNS2vbJA
         9k/gXz/X+tmjQFKHOSbZ1+bPcFV8y5D2TRMDhAP0/hTkC64bRCaa7h5P/YVeMQIrDXPq
         f6qRgPUEQuYl+smjnDwUeavgZqsw3I2Zp/6KZTtf+3zhBjWDmUVsgf0awkFhaUS6/bqn
         kSWg==
X-Gm-Message-State: AJIora9GQxou3ve1M9OGm58ej0bFuMtaOrPGW7fArgAeTLdmYY11NIsz
        l94ljS4Likmppzi4ZJqUCGgdRD7Oge8JdwtRHikCB0MYSRVSkoM8qbXB4P/cbsilSAfqIEpvExo
        1J0ry+k5GM54EacNc
X-Received: by 2002:a05:6a00:1a:b0:52a:dec1:308c with SMTP id h26-20020a056a00001a00b0052adec1308cmr43027997pfk.52.1658387247181;
        Thu, 21 Jul 2022 00:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tK0/eD/GljWYSBQ/IjcruuC00jeXyMoir/L48eboBrwPVAnyIj6/ptwUKz85QkGsmF8udXGg==
X-Received: by 2002:a05:6a00:1a:b0:52a:dec1:308c with SMTP id h26-20020a056a00001a00b0052adec1308cmr43027959pfk.52.1658387246593;
        Thu, 21 Jul 2022 00:07:26 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n9-20020a170903110900b0016cf3f124e5sm826885plh.131.2022.07.21.00.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 00:07:25 -0700 (PDT)
Message-ID: <7753fdae-839c-dbdf-7d24-2db2627c27aa@redhat.com>
Date:   Thu, 21 Jul 2022 15:07:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 06/40] virtio_ring: introduce virtqueue_init()
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
 <20220720030436.79520-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-7-xuanzhuo@linux.alibaba.com>
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
> Separate the logic of virtqueue initialization. This logic is irrelevant
> to ring layout.
>
> This logic can be called independently when implementing resize/reset
> later.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 61 ++++++++++++++++++------------------
>   1 file changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 1bc5794e9739..87ce17562b29 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -368,6 +368,34 @@ static int vring_mapping_error(const struct vring_virtqueue *vq,
>   	return dma_mapping_error(vring_dma_dev(vq), addr);
>   }
>   
> +static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
> +{
> +	struct virtio_device *vdev;
> +
> +	vdev = vq->vq.vdev;
> +
> +	vq->vq.num_free = num;
> +	if (vq->packed_ring)
> +		vq->last_used_idx = 0 | (1 << VRING_PACKED_EVENT_F_WRAP_CTR);
> +	else
> +		vq->last_used_idx = 0;
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
> +	/* Put everything in free lists. */
> +	vq->free_head = 0;
> +}
> +
>   
>   /*
>    * Split ring specific functions - *_split().
> @@ -1706,7 +1734,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->vq.callback = callback;
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
> -	vq->vq.num_free = num;
>   	vq->vq.index = index;
>   	vq->we_own_ring = true;
>   	vq->notify = notify;
> @@ -1716,22 +1743,10 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   #else
>   	vq->broken = false;
>   #endif
> -	vq->last_used_idx = 0 | (1 << VRING_PACKED_EVENT_F_WRAP_CTR);
> -	vq->event_triggered = false;
> -	vq->num_added = 0;
>   	vq->packed_ring = true;
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
>   
>   	vq->packed.ring_dma_addr = ring_dma_addr;
>   	vq->packed.driver_event_dma_addr = driver_event_dma_addr;
> @@ -1759,8 +1774,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	memset(vq->packed.desc_state, 0,
>   		num * sizeof(struct vring_desc_state_packed));
>   
> -	/* Put everything in free lists. */
> -	vq->free_head = 0;
> +	virtqueue_init(vq, num);
>   
>   	vq->packed.desc_extra = vring_alloc_desc_extra(num);
>   	if (!vq->packed.desc_extra)
> @@ -2205,7 +2219,6 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->vq.callback = callback;
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
> -	vq->vq.num_free = vring.num;
>   	vq->vq.index = index;
>   	vq->we_own_ring = false;
>   	vq->notify = notify;
> @@ -2215,21 +2228,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   #else
>   	vq->broken = false;
>   #endif
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
>   
>   	vq->split.queue_dma_addr = 0;
>   	vq->split.queue_size_in_bytes = 0;
> @@ -2255,11 +2256,11 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	if (!vq->split.desc_extra)
>   		goto err_extra;
>   
> -	/* Put everything in free lists. */
> -	vq->free_head = 0;
>   	memset(vq->split.desc_state, 0, vring.num *
>   			sizeof(struct vring_desc_state_split));
>   
> +	virtqueue_init(vq, vq->split.vring.num);
> +
>   	spin_lock(&vdev->vqs_list_lock);
>   	list_add_tail(&vq->vq.list, &vdev->vqs);
>   	spin_unlock(&vdev->vqs_list_lock);

