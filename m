Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079E14FCF7F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 08:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348838AbiDLGbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 02:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbiDLGbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 02:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9871335861
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 23:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649744923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=96mvZW2N60Bc/yiEAvufsCeVXhKGkkUOXQ1a79/ykgI=;
        b=RGhzfReoqB/wQyNd03K1DtA6aXWtbe6IR44LY9uB8UWrYJh74JmJAdbveIsWA8D05sArKR
        4Id3Dow0ogAmLLXD7+LYq+hSxVfEGASEfR7Pk8kNueE2B8JBBgymlaIOdruH08vM13Xn5k
        Dk+JtTciTTK4cX+5cuLXC0fRStM+BSs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-pUyCqtbjN9a7d9OcGgIbVg-1; Tue, 12 Apr 2022 02:28:42 -0400
X-MC-Unique: pUyCqtbjN9a7d9OcGgIbVg-1
Received: by mail-pl1-f197.google.com with SMTP id u8-20020a170903124800b0015195a5826cso7354731plh.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 23:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=96mvZW2N60Bc/yiEAvufsCeVXhKGkkUOXQ1a79/ykgI=;
        b=PrtCTFyJVEI7kFktap+ExYm2r93pqgkzrGJ0fHX7CYzXrfWu4Q+u08a4pIvXE8wRNF
         ed6WDnT6nNNV5fBOVVV76ujr1UkSZpnbPiv78HSYt40FZLsFJ6WDOfYI1poax144vE1/
         h/hBx20LBxKVcYomjLVIGXMMhJCUjxZ/TQKJ5K4Iz0DGEsXEns217JjPvL+0LtPhNfdT
         9qOr+xZ+xA/wXPKRuaPPXnupWRPn8fH5c9B4nrQj895xPEebrzlnUc4ENsoy420hFFBf
         chJ9BmOfIrSWBasMgt8ZvlAr1Z+PkW/Td3dJEOOfTum0GNsyAt4aE2N9NhRLaZzI7c05
         tcBw==
X-Gm-Message-State: AOAM5301KBbKpT8yuwUHuja6byfD/9My2J7d0yBP1osXhadiC1ik+4xo
        aQttBRBBm581ULC53NCeIfJd2ntBoKiM6BffA5z1R5ZQw4jsXqvHmWKmaSUE4DuU8EHzZdnM1qv
        asLMq49BtM9YYq9oe
X-Received: by 2002:a17:90a:600b:b0:1cb:8ba5:d3bc with SMTP id y11-20020a17090a600b00b001cb8ba5d3bcmr3322132pji.42.1649744921371;
        Mon, 11 Apr 2022 23:28:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsTZb815vqxK0EhXJcoHB9RSXY3UmD7WoV1CP0Y3EhajIsat86IZWa2d15JEEcfRFMnydtCQ==
X-Received: by 2002:a17:90a:600b:b0:1cb:8ba5:d3bc with SMTP id y11-20020a17090a600b00b001cb8ba5d3bcmr3322121pji.42.1649744921156;
        Mon, 11 Apr 2022 23:28:41 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id md4-20020a17090b23c400b001cb66e3e1f8sm1483400pjb.0.2022.04.11.23.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 23:28:40 -0700 (PDT)
Message-ID: <4da7b8dc-74ca-fc1b-fbdb-21f9943e8d45@redhat.com>
Date:   Tue, 12 Apr 2022 14:28:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 12/32] virtio_ring: packed: extract the logic of alloc
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
 <20220406034346.74409-13-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-13-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Separate the logic of packed to create vring queue.
>
> For the convenience of passing parameters, add a structure
> vring_packed.
>
> This feature is required for subsequent virtuqueue reset vring.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 70 ++++++++++++++++++++++++++++--------
>   1 file changed, 56 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 33864134a744..ea451ae2aaef 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1817,19 +1817,17 @@ static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num)
>   	return desc_extra;
>   }
>   
> -static struct virtqueue *vring_create_virtqueue_packed(
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
> +static int vring_alloc_queue_packed(struct virtio_device *vdev,
> +				    u32 num,
> +				    struct vring_packed_desc **_ring,
> +				    struct vring_packed_desc_event **_driver,
> +				    struct vring_packed_desc_event **_device,
> +				    dma_addr_t *_ring_dma_addr,
> +				    dma_addr_t *_driver_event_dma_addr,
> +				    dma_addr_t *_device_event_dma_addr,
> +				    size_t *_ring_size_in_bytes,
> +				    size_t *_event_size_in_bytes)
>   {
> -	struct vring_virtqueue *vq;
>   	struct vring_packed_desc *ring;
>   	struct vring_packed_desc_event *driver, *device;
>   	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
> @@ -1857,6 +1855,52 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	if (!device)
>   		goto err_device;
>   
> +	*_ring                   = ring;
> +	*_driver                 = driver;
> +	*_device                 = device;
> +	*_ring_dma_addr          = ring_dma_addr;
> +	*_driver_event_dma_addr  = driver_event_dma_addr;
> +	*_device_event_dma_addr  = device_event_dma_addr;
> +	*_ring_size_in_bytes     = ring_size_in_bytes;
> +	*_event_size_in_bytes    = event_size_in_bytes;


I wonder if we can simply factor out split and packed from struct 
vring_virtqueue:

struct vring_virtqueue {
     union {
         struct {} split;
         struct {} packed;
     };
};

to

struct vring_virtqueue_split {};
struct vring_virtqueue_packed {};

Then we can do things like:

vring_create_virtqueue_packed(struct virtio_device *vdev, u32 num, 
struct vring_virtqueue_packed *packed);

and

vring_vritqueue_attach_packed(struct vring_virtqueue *vq, struct 
vring_virtqueue_packed packed);

Thanks


> +
> +	return 0;
> +
> +err_device:
> +	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
> +
> +err_driver:
> +	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
> +
> +err_ring:
> +	return -ENOMEM;
> +}
> +
> +static struct virtqueue *vring_create_virtqueue_packed(
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
> +	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
> +	struct vring_packed_desc_event *driver, *device;
> +	size_t ring_size_in_bytes, event_size_in_bytes;
> +	struct vring_packed_desc *ring;
> +	struct vring_virtqueue *vq;
> +
> +	if (vring_alloc_queue_packed(vdev, num, &ring, &driver, &device,
> +				     &ring_dma_addr, &driver_event_dma_addr,
> +				     &device_event_dma_addr,
> +				     &ring_size_in_bytes,
> +				     &event_size_in_bytes))
> +		goto err_ring;
> +
>   	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
>   	if (!vq)
>   		goto err_vq;
> @@ -1939,9 +1983,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	kfree(vq);
>   err_vq:
>   	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
> -err_device:
>   	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dma_addr);
> -err_driver:
>   	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
>   err_ring:
>   	return NULL;

