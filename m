Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B154D28DE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiCIGRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiCIGRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:17:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AE191617C6
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646806606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cCQcksPUdMm6JmcA9ctdwilmGIj2X4aiFpqmKR/hAfU=;
        b=ETln0zVBXIjxYvehxEE9IV9JAqYyfWRHla2t8lDIwBSGY/ZRU+3vhka2/1lVVMV0oOV/U4
        +3uaZV8FFXR9ZOxnYm/y16D5sT2eJu8zx6C3oW5iSR9QQ70E6hhAEFREN01fhRwTiSuL60
        Zylpe3hBGt342H1WN/szDXCLd9JPoG4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-JgBHNyEpPvibBzS1pk37Gw-1; Wed, 09 Mar 2022 01:16:45 -0500
X-MC-Unique: JgBHNyEpPvibBzS1pk37Gw-1
Received: by mail-pl1-f198.google.com with SMTP id e13-20020a17090301cd00b00150145346f9so627612plh.23
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 22:16:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cCQcksPUdMm6JmcA9ctdwilmGIj2X4aiFpqmKR/hAfU=;
        b=sm76KvprSDSHlH/emLkSLAMOkWtWzrE+xbI3Js6SF5Q4451LjZul+tN7Gm6H3EVFyG
         xBInD0GVaWJIvfpDyPx8JgxMmL1vqKkcIuK/idm984KFCFFVORIkH6mtYW92wFeW/Ziy
         CmLFI0rKO4uFsvdA0otIgkUfbAmqzG4FcKzwR4uzvpSx8u5MC3fS4S1tGWRBmRsmNIXT
         XnFBohsNd/zI635n2390Zj7f/Yoot7TfqqarnSBlkextQEC0SofLjpMKUqEpYeokKbxm
         7xrp2Pzt4QhFse+xk3vQuAD/+ZnTJgIRqFz5Qve9S45FEcGJbimnsmvEaFiPxm41qvoD
         idQA==
X-Gm-Message-State: AOAM530wFTDeuqMkptSSqZBzv2wqn0FraVNwFzQxiYybtpXJW/PoD64C
        2mkJX5P2WJLpK+uxXf0MGRfJHZ6SFtB8McfjJn/JN0XTBeAp4HqtJfPzSQ1qMCs+THLuUUUed08
        p21pZ/z4Hd7TIT/Jm
X-Received: by 2002:a17:902:e886:b0:151:ed65:fd87 with SMTP id w6-20020a170902e88600b00151ed65fd87mr13425789plg.161.1646806604226;
        Tue, 08 Mar 2022 22:16:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxc7JR6EeBP4D90Qf0GHA8SP34qXakttaCcRONqPxoLgaicEsxymwyeChsATy9iRlCgcuMRYA==
X-Received: by 2002:a17:902:e886:b0:151:ed65:fd87 with SMTP id w6-20020a170902e88600b00151ed65fd87mr13425762plg.161.1646806603957;
        Tue, 08 Mar 2022 22:16:43 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z2-20020aa79902000000b004f75842c97csm994252pff.209.2022.03.08.22.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 22:16:43 -0800 (PST)
Message-ID: <10c67feb-fe4a-9370-23a6-efc90532700d@redhat.com>
Date:   Wed, 9 Mar 2022 14:16:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 03/26] virtio: add helper
 virtqueue_get_vring_max_size()
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
 <20220308123518.33800-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-4-xuanzhuo@linux.alibaba.com>
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
> Record the maximum queue num supported by the device.
>
> virtio-net can display the maximum (supported by hardware) ring size in
> ethtool -g eth0.
>
> When the subsequent patch implements vring reset, it can judge whether
> the ring size passed by the driver is legal based on this.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_mmio.c       |  2 ++
>   drivers/virtio/virtio_pci_legacy.c |  2 ++
>   drivers/virtio/virtio_pci_modern.c |  2 ++
>   drivers/virtio/virtio_ring.c       | 14 ++++++++++++++
>   include/linux/virtio.h             |  2 ++
>   5 files changed, 22 insertions(+)
>
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 56128b9c46eb..a41abc8051b9 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -390,6 +390,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
>   		goto error_new_virtqueue;
>   	}
>   
> +	vq->num_max = num;
> +
>   	/* Activate the queue */
>   	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
>   	if (vm_dev->version == 1) {
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 34141b9abe27..b68934fe6b5d 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -135,6 +135,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   	if (!vq)
>   		return ERR_PTR(-ENOMEM);
>   
> +	vq->num_max = num;
> +
>   	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
>   	if (q_pfn >> 32) {
>   		dev_err(&vp_dev->pci_dev->dev,
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 5455bc041fb6..86d301f272b8 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -218,6 +218,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   	if (!vq)
>   		return ERR_PTR(-ENOMEM);
>   
> +	vq->num_max = num;
> +
>   	/* activate the queue */
>   	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
>   	vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 962f1477b1fa..b87130c8f312 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2371,6 +2371,20 @@ void vring_transport_features(struct virtio_device *vdev)
>   }
>   EXPORT_SYMBOL_GPL(vring_transport_features);
>   
> +/**
> + * virtqueue_get_vring_max_size - return the max size of the virtqueue's vring
> + * @_vq: the struct virtqueue containing the vring of interest.
> + *
> + * Returns the max size of the vring.
> + *
> + * Unlike other operations, this need not be serialized.
> + */
> +unsigned int virtqueue_get_vring_max_size(struct virtqueue *_vq)
> +{
> +	return _vq->num_max;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_get_vring_max_size);
> +
>   /**
>    * virtqueue_get_vring_size - return the size of the virtqueue's vring
>    * @_vq: the struct virtqueue containing the vring of interest.
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 72292a62cd90..d59adc4be068 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -31,6 +31,7 @@ struct virtqueue {
>   	struct virtio_device *vdev;
>   	unsigned int index;
>   	unsigned int num_free;
> +	unsigned int num_max;
>   	void *priv;
>   };
>   
> @@ -80,6 +81,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
>   
>   void *virtqueue_detach_unused_buf(struct virtqueue *vq);
>   
> +unsigned int virtqueue_get_vring_max_size(struct virtqueue *vq);
>   unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
>   
>   bool virtqueue_is_broken(struct virtqueue *vq);

