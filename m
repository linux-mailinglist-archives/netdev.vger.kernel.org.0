Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7078657C2CF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiGUDgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiGUDgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDBA578232
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 20:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658374597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZs2MTtPJCgrF13MTLP6HwaK4P20s9o4BWWN0llGmLc=;
        b=cCOXgnOO8xmvw+LZvOOhfD76/BS0ADF+QjtgZYBEk8Eyh6cDt/NnNyz2jv4kZCu3pnbKpT
        eXKngVDK+Gj0hgYTtJiNCyFxq6oOqR7tNJFB+8FB5fAxvuvdtBwPi2q0BEhCjNZtlGNMG5
        R+X9K2RsWhf5vPk7ynjvP82NHxs4RvY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-rZtUw9XrOjeG9cCcS37sBg-1; Wed, 20 Jul 2022 23:36:36 -0400
X-MC-Unique: rZtUw9XrOjeG9cCcS37sBg-1
Received: by mail-pg1-f200.google.com with SMTP id h185-20020a636cc2000000b00419b8e7df69so274986pgc.18
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 20:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XZs2MTtPJCgrF13MTLP6HwaK4P20s9o4BWWN0llGmLc=;
        b=mBewHENm5XYDzxKvZOT3TcXAPgOfCQTJg9emYyWYYZxWKvPx/E3UjyOdU+xgqkaIv0
         ZDobG31IDXxgegWLcv7b4KE8I0wgnb8u6kcmaVFfz5kXXzLYcbnbR4GiYULJ08+N5JqK
         7HqUlF5IPPsoQg6VrY0DuSvRjfm98BPLErCB8uFT3bxMG6AUSjbtqT1wi08Yw4xkqzgE
         N2QBKrcK1jUzREMGrDyvMYRq1tbHYZGFxhJzT0kfEVzXROT5/nCFSiUAzKvPniZLrWCB
         YxI1QaAA3Iu5Ttm+e9RcQGvS9znDsVyiintX4VF6jn8rFiPJu8wKn4mD3FaRrTuVSCu3
         GphA==
X-Gm-Message-State: AJIora85cjhcBwzB9VvZMg9c94n1Nt2r+qJgMtbdTNM16GSv7UnfiDK5
        9zLit7RsWC5xuISXIJdOTCogYfjsQ/fIQxNClt1p0CjxKVTMPWblPsOqae5t19ffXFfG0JHdCET
        I6ymQ383Cx2G9sAGK
X-Received: by 2002:a17:903:230c:b0:16c:4c65:18be with SMTP id d12-20020a170903230c00b0016c4c6518bemr41221938plh.138.1658374595119;
        Wed, 20 Jul 2022 20:36:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tr2BE9d26jAFZ7UzmaXmDCEYEs27OTIGhFU26HuMl2rkNob1MeYihMEZsIvqYHGU+JOzJneA==
X-Received: by 2002:a17:903:230c:b0:16c:4c65:18be with SMTP id d12-20020a170903230c00b0016c4c6518bemr41221903plh.138.1658374594755;
        Wed, 20 Jul 2022 20:36:34 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22-20020aa79416000000b005289fad1bbesm424278pfo.94.2022.07.20.20.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 20:36:34 -0700 (PDT)
Message-ID: <ba2ae3e4-a950-6b7f-8748-c45a685bb6b0@redhat.com>
Date:   Thu, 21 Jul 2022 11:36:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 01/40] virtio: record the maximum queue num supported
 by the device.
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
 <20220720030436.79520-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-2-xuanzhuo@linux.alibaba.com>
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


在 2022/7/20 11:03, Xuan Zhuo 写道:
> virtio-net can display the maximum (supported by hardware) ring size in
> ethtool -g eth0.
>
> When the subsequent patch implements vring reset, it can judge whether
> the ring size passed by the driver is legal based on this.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   arch/um/drivers/virtio_uml.c             | 1 +
>   drivers/platform/mellanox/mlxbf-tmfifo.c | 2 ++
>   drivers/remoteproc/remoteproc_virtio.c   | 2 ++
>   drivers/s390/virtio/virtio_ccw.c         | 3 +++
>   drivers/virtio/virtio_mmio.c             | 2 ++
>   drivers/virtio/virtio_pci_legacy.c       | 2 ++
>   drivers/virtio/virtio_pci_modern.c       | 2 ++
>   drivers/virtio/virtio_vdpa.c             | 2 ++
>   include/linux/virtio.h                   | 2 ++
>   9 files changed, 18 insertions(+)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 82ff3785bf69..e719af8bdf56 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -958,6 +958,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
>   		goto error_create;
>   	}
>   	vq->priv = info;
> +	vq->num_max = num;
>   	num = virtqueue_get_vring_size(vq);
>   
>   	if (vu_dev->protocol_features &
> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
> index 38800e86ed8a..1ae3c56b66b0 100644
> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> @@ -959,6 +959,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
>   			goto error;
>   		}
>   
> +		vq->num_max = vring->num;
> +
>   		vqs[i] = vq;
>   		vring->vq = vq;
>   		vq->priv = vring;
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> index d43d74733f0a..0f7706e23eb9 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -125,6 +125,8 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
>   		return ERR_PTR(-ENOMEM);
>   	}
>   
> +	vq->num_max = num;
> +
>   	rvring->vq = vq;
>   	vq->priv = rvring;
>   
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 161d3b141f0d..6b86d0280d6b 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -530,6 +530,9 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
>   		err = -ENOMEM;
>   		goto out_err;
>   	}
> +
> +	vq->num_max = info->num;
> +
>   	/* it may have been reduced */
>   	info->num = virtqueue_get_vring_size(vq);
>   
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 083ff1eb743d..a20d5a6b5819 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -403,6 +403,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
>   		goto error_new_virtqueue;
>   	}
>   
> +	vq->num_max = num;
> +
>   	/* Activate the queue */
>   	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
>   	if (vm_dev->version == 1) {
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index a5e5721145c7..2257f1b3d8ae 100644
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
> index 623906b4996c..e7e0b8c850f6 100644
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
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index c40f7deb6b5a..9670cc79371d 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -183,6 +183,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
>   		goto error_new_virtqueue;
>   	}
>   
> +	vq->num_max = max_num;
> +
>   	/* Setup virtqueue callback */
>   	cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
>   	cb.private = info;
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index d8fdf170637c..129bde7521e3 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -19,6 +19,7 @@
>    * @priv: a pointer for the virtqueue implementation to use.
>    * @index: the zero-based ordinal number for this queue.
>    * @num_free: number of elements we expect to be able to fit.
> + * @num_max: the maximum number of elements supported by the device.
>    *
>    * A note on @num_free: with indirect buffers, each buffer needs one
>    * element in the queue, otherwise a buffer will need one element per
> @@ -31,6 +32,7 @@ struct virtqueue {
>   	struct virtio_device *vdev;
>   	unsigned int index;
>   	unsigned int num_free;
> +	unsigned int num_max;
>   	void *priv;
>   };
>   

