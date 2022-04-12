Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8524FD678
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiDLH6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 03:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355771AbiDLH3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 03:29:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70DEA4EF62
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649747296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rO0UiIR0RaZp+eJrqPEuwbF/F4u5EFxiYFSQC2lhpMQ=;
        b=TCpArwnnE6y8HPgC1eawpP9OICfLInKYgdeTDUwdNKp+BztGZPCjfkk+rOq950jupTjB2N
        ugVB/dvkwYeqEObflNDM+Gxd+FZENT5hbTxuyodht0WC4kKC1qfaUdFkepz1i7FxGgI7ib
        w99ZP5lT4b2PZRzeiOiHh3+lIJO78Rk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-4CNAsyxRNDGxmNncICvdww-1; Tue, 12 Apr 2022 03:08:14 -0400
X-MC-Unique: 4CNAsyxRNDGxmNncICvdww-1
Received: by mail-pf1-f199.google.com with SMTP id i184-20020a62c1c1000000b0050603f28eadso143845pfg.19
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rO0UiIR0RaZp+eJrqPEuwbF/F4u5EFxiYFSQC2lhpMQ=;
        b=i/MRGSZU6AAEokczdtpYdnrEwVGZEwKR1tYAaYdb6TySKV4YU2tVMwR924P2yPNcxo
         TchuYevVoUEUAKSW6FIvMB5j1XzPAz7kh8fQhe56I/sbTldxkmb8Uu9YXcYJ4zkYWcA4
         8UR2Ja/4CUJU60mQiH0ZKqTgiaQOZoCgeYyLMUABruhxAuakD+Q6f5UNeYo+V1pCiWb5
         CEQGE5JouGmJTej4mTC6uZiWRqMD8IMYN7uIT31DFo10BbcARx9Yx4xlvW3sxsdo003y
         zgo34SopWPG26CDzigve+xy/PcxtVjtxcoC+cPKViSfSVssBrTWraQCXYL8I9h4tz6cm
         TTuQ==
X-Gm-Message-State: AOAM531Ak0e/vG4Px0s1AKmRhgvtblLbnabc60n3PvvY6c3vpDpdO/ky
        tfsdj+JJjrfYlgM2Qc+RpcW2hv3ei/80E8utujTbwR/NllWa3Zs1p3XXd5PqrONA07MRtjD5Ahe
        DrKM76vIh0T/o6lgg
X-Received: by 2002:a17:902:d4c1:b0:154:1273:6ec9 with SMTP id o1-20020a170902d4c100b0015412736ec9mr36389018plg.148.1649747293393;
        Tue, 12 Apr 2022 00:08:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmBYQVhBgkM83IAVsIXuW8wi4G3nuNupPsrp7sYEa8TLNXxILPfIRwjGxeuvOgRL1kO9utqQ==
X-Received: by 2002:a17:902:d4c1:b0:154:1273:6ec9 with SMTP id o1-20020a170902d4c100b0015412736ec9mr36388997plg.148.1649747293111;
        Tue, 12 Apr 2022 00:08:13 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090add4300b001ca56ea162bsm1611301pjv.33.2022.04.12.00.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 00:08:12 -0700 (PDT)
Message-ID: <d040a3fe-765e-93d6-cef9-603f23a0fd1e@redhat.com>
Date:   Tue, 12 Apr 2022 15:07:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 23/32] virtio_pci: queue_reset: support
 VIRTIO_F_RING_RESET
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
 <20220406034346.74409-24-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-24-xuanzhuo@linux.alibaba.com>
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
> This patch implements virtio pci support for QUEUE RESET.
>
> Performing reset on a queue is divided into these steps:
>
>   1. notify the device to reset the queue
>   2. recycle the buffer submitted
>   3. reset the vring (may re-alloc)
>   4. mmap vring to device, and enable the queue
>
> This patch implements virtio_reset_vq(), virtio_enable_resetq() in the
> pci scenario.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_pci_common.c |  8 +--
>   drivers/virtio/virtio_pci_modern.c | 84 ++++++++++++++++++++++++++++++
>   drivers/virtio/virtio_ring.c       |  2 +
>   include/linux/virtio.h             |  1 +
>   4 files changed, 92 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index fdbde1db5ec5..863d3a8a0956 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -248,9 +248,11 @@ static void vp_del_vq(struct virtqueue *vq)
>   	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
>   	unsigned long flags;
>   
> -	spin_lock_irqsave(&vp_dev->lock, flags);
> -	list_del(&info->node);
> -	spin_unlock_irqrestore(&vp_dev->lock, flags);
> +	if (!vq->reset) {


On which condition that we may hit this path?


> +		spin_lock_irqsave(&vp_dev->lock, flags);
> +		list_del(&info->node);
> +		spin_unlock_irqrestore(&vp_dev->lock, flags);
> +	}
>   
>   	vp_dev->del_vq(info);
>   	kfree(info);
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 49a4493732cf..cb5d38f1c9c8 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>   	if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>   			pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
>   		__virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> +
> +	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> +		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>   }
>   
>   /* virtio config->finalize_features() implementation */
> @@ -199,6 +202,83 @@ static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
>   	return 0;
>   }
>   
> +static int vp_modern_reset_vq(struct virtqueue *vq)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	struct virtio_pci_vq_info *info;
> +	unsigned long flags;
> +
> +	if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> +		return -ENOENT;
> +
> +	vp_modern_set_queue_reset(mdev, vq->index);
> +
> +	info = vp_dev->vqs[vq->index];
> +
> +	/* delete vq from irq handler */
> +	spin_lock_irqsave(&vp_dev->lock, flags);
> +	list_del(&info->node);
> +	spin_unlock_irqrestore(&vp_dev->lock, flags);
> +
> +	INIT_LIST_HEAD(&info->node);
> +
> +	/* For the case where vq has an exclusive irq, to prevent the irq from
> +	 * being received again and the pending irq, call disable_irq().
> +	 *
> +	 * In the scenario based on shared interrupts, vq will be searched from
> +	 * the queue virtqueues. Since the previous list_del() has been deleted
> +	 * from the queue, it is impossible for vq to be called in this case.
> +	 * There is no need to close the corresponding interrupt.
> +	 */
> +	if (vp_dev->per_vq_vectors && info->msix_vector != VIRTIO_MSI_NO_VECTOR)
> +		disable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));


See the previous discussion and the revert of the first try to harden 
the interrupt. We probably can't use disable_irq() since it conflicts 
with the affinity managed IRQ that is used by some drivers.

We need to use synchonize_irq() and per virtqueue flag instead. As 
mentioned in previous patches, this could be done on top of my rework on 
the IRQ hardening .


> +
> +	vq->reset = true;
> +
> +	return 0;
> +}
> +
> +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	struct virtio_pci_vq_info *info;
> +	unsigned long flags, index;
> +	int err;
> +
> +	if (!vq->reset)
> +		return -EBUSY;
> +
> +	index = vq->index;
> +	info = vp_dev->vqs[index];
> +
> +	/* check queue reset status */
> +	if (vp_modern_get_queue_reset(mdev, index) != 1)
> +		return -EBUSY;
> +
> +	err = vp_active_vq(vq, info->msix_vector);
> +	if (err)
> +		return err;
> +
> +	if (vq->callback) {
> +		spin_lock_irqsave(&vp_dev->lock, flags);
> +		list_add(&info->node, &vp_dev->virtqueues);
> +		spin_unlock_irqrestore(&vp_dev->lock, flags);
> +	} else {
> +		INIT_LIST_HEAD(&info->node);
> +	}
> +
> +	vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
> +
> +	if (vp_dev->per_vq_vectors && info->msix_vector != VIRTIO_MSI_NO_VECTOR)
> +		enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));


We had the same issue as disable_irq().

Thanks


> +
> +	vq->reset = false;
> +
> +	return 0;
> +}
> +
>   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>   {
>   	return vp_modern_config_vector(&vp_dev->mdev, vector);
> @@ -407,6 +487,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>   	.set_vq_affinity = vp_set_vq_affinity,
>   	.get_vq_affinity = vp_get_vq_affinity,
>   	.get_shm_region  = vp_get_shm_region,
> +	.reset_vq	 = vp_modern_reset_vq,
> +	.enable_reset_vq = vp_modern_enable_reset_vq,
>   };
>   
>   static const struct virtio_config_ops virtio_pci_config_ops = {
> @@ -425,6 +507,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>   	.set_vq_affinity = vp_set_vq_affinity,
>   	.get_vq_affinity = vp_get_vq_affinity,
>   	.get_shm_region  = vp_get_shm_region,
> +	.reset_vq	 = vp_modern_reset_vq,
> +	.enable_reset_vq = vp_modern_enable_reset_vq,
>   };
>   
>   /* the PCI probing function */
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 6250e19fc5bf..91937e21edca 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2028,6 +2028,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
>   	vq->vq.index = index;
> +	vq->vq.reset = false;
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
>   
> @@ -2508,6 +2509,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->vq.vdev = vdev;
>   	vq->vq.name = name;
>   	vq->vq.index = index;
> +	vq->vq.reset = false;
>   	vq->notify = notify;
>   	vq->weak_barriers = weak_barriers;
>   
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index c86ff02e0ca0..33ab003c5100 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -33,6 +33,7 @@ struct virtqueue {
>   	unsigned int num_free;
>   	unsigned int num_max;
>   	void *priv;
> +	bool reset;
>   };
>   
>   int virtqueue_add_outbuf(struct virtqueue *vq,

