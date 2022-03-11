Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068424D5A3D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 06:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbiCKFHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 00:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbiCKFHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 00:07:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FC371AC2B4
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646975166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fv0x+1VoYiMUKdKtNJKiJ1SoB5j1+sfzfwwiDTV8v0U=;
        b=ENGYYm78omW3SbE2QqgHqaYK9i1zycMCL+xiqZtSXQ1EOYCGbc5m2+0Ih6z284taD1YQkV
        jT3pt3yMZDM/9vdtAXG3WP2siUQG1KXDHVUzxkJaJCcy3ntTGDc4VLlqjxl3vEUdNeOCOB
        3UKtCLQV+mwQY28tVMGXVOQps+w9YjE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-r71aI_bQPXKXz16-KidX6A-1; Fri, 11 Mar 2022 00:06:03 -0500
X-MC-Unique: r71aI_bQPXKXz16-KidX6A-1
Received: by mail-pf1-f199.google.com with SMTP id f18-20020a623812000000b004f6a259bbf4so4572703pfa.7
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:06:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fv0x+1VoYiMUKdKtNJKiJ1SoB5j1+sfzfwwiDTV8v0U=;
        b=fTjuoHaokDO5ECq+3DFp7+Sv/H0k2q5yScU9Z88CVa57Vyfbw9GA+r8ccpE6Aj0L5q
         MIMicv0Yco8H9QHtIUIM7mvGR6F/pd67SUHjKNs5BJ26+/Oj2cHEOLGuzyFt44ltHT/6
         UXqdCk9QotYM6+C/w3VbQZh51Q6ne5sslRTYh1iV55lACcm/+SVO0fxqvzT7jvNKdNpG
         L8ZXBmuv6vsb+2rw2x+0sZtrugcscZAySO1v1SPNht+k81QwpM7oyY3vQfht3FVvtdVm
         K0biZpzAsismGF1XXF0qsmCCKcuAu/PX2fGaUwFSICawZXZf1z9D4QWReou/aLz0tX3Z
         kFeQ==
X-Gm-Message-State: AOAM532gZE67tGwbOg7t0r9cSdUD+phvSBfqk2muh3EVuPjvmxwST+wk
        0ukAS8uDT52OQ8BxiVg68LXTBMqFgYfLkamr3VRfeHloKEGx3C+cObD3onPz7sPf2K1Md19hnCi
        L9yhTCT+E6mhqYiGH
X-Received: by 2002:a65:6943:0:b0:376:333b:1025 with SMTP id w3-20020a656943000000b00376333b1025mr6951034pgq.164.1646975162471;
        Thu, 10 Mar 2022 21:06:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxD3Bx61otH/mEyxC9XMtKu0q2dVWdhVfXlDv+iqZjtIoCxQvw239yb0wy+o8Y5dbByJp1/ng==
X-Received: by 2002:a65:6943:0:b0:376:333b:1025 with SMTP id w3-20020a656943000000b00376333b1025mr6951009pgq.164.1646975162136;
        Thu, 10 Mar 2022 21:06:02 -0800 (PST)
Received: from [10.72.13.226] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm9537352pfc.111.2022.03.10.21.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 21:06:01 -0800 (PST)
Message-ID: <55348e9d-2b8f-4e32-682f-2218c2fb517a@redhat.com>
Date:   Fri, 11 Mar 2022 13:05:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 17/26] virtio_pci: queue_reset: support
 VIRTIO_F_RING_RESET
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-18-xuanzhuo@linux.alibaba.com>
 <8b9d337d-71c2-07b4-8e65-6f83cf09bf7a@redhat.com>
 <1646818328.2590482-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1646818328.2590482-9-xuanzhuo@linux.alibaba.com>
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


在 2022/3/9 下午5:32, Xuan Zhuo 写道:
> On Wed, 9 Mar 2022 16:54:10 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2022/3/8 下午8:35, Xuan Zhuo 写道:
>>> This patch implements virtio pci support for QUEUE RESET.
>>>
>>> Performing reset on a queue is divided into these steps:
>>>
>>>    1. virtio_reset_vq()              - notify the device to reset the queue
>>>    2. virtqueue_detach_unused_buf()  - recycle the buffer submitted
>>>    3. virtqueue_reset_vring()        - reset the vring (may re-alloc)
>>>    4. virtio_enable_resetq()         - mmap vring to device, and enable the queue
>>>
>>> This patch implements virtio_reset_vq(), virtio_enable_resetq() in the
>>> pci scenario.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>    drivers/virtio/virtio_pci_common.c |  8 +--
>>>    drivers/virtio/virtio_pci_modern.c | 83 ++++++++++++++++++++++++++++++
>>>    2 files changed, 88 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>>> index fdbde1db5ec5..863d3a8a0956 100644
>>> --- a/drivers/virtio/virtio_pci_common.c
>>> +++ b/drivers/virtio/virtio_pci_common.c
>>> @@ -248,9 +248,11 @@ static void vp_del_vq(struct virtqueue *vq)
>>>    	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
>>>    	unsigned long flags;
>>>
>>> -	spin_lock_irqsave(&vp_dev->lock, flags);
>>> -	list_del(&info->node);
>>> -	spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +	if (!vq->reset) {
>>> +		spin_lock_irqsave(&vp_dev->lock, flags);
>>> +		list_del(&info->node);
>>> +		spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +	}
>>>
>>>    	vp_dev->del_vq(info);
>>>    	kfree(info);
>>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>>> index 49a4493732cf..3c67d3607802 100644
>>> --- a/drivers/virtio/virtio_pci_modern.c
>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>> @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>>>    	if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>>>    			pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
>>>    		__virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
>>> +
>>> +	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
>>> +		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>>>    }
>>>
>>>    /* virtio config->finalize_features() implementation */
>>> @@ -199,6 +202,82 @@ static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
>>>    	return 0;
>>>    }
>>>
>>> +static int vp_modern_reset_vq(struct virtqueue *vq)
>>> +{
>>> +	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>>> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>> +	struct virtio_pci_vq_info *info;
>>> +	unsigned long flags;
>>> +	unsigned int irq;
>>> +
>>> +	if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
>>> +		return -ENOENT;
>>> +
>>> +	vp_modern_set_queue_reset(mdev, vq->index);
>>> +
>>> +	info = vp_dev->vqs[vq->index];
>>> +
>>> +	/* delete vq from irq handler */
>>> +	spin_lock_irqsave(&vp_dev->lock, flags);
>>> +	list_del(&info->node);
>>> +	spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +
>>> +	INIT_LIST_HEAD(&info->node);
>>> +
>>> +	vq->reset = VIRTIO_VQ_RESET_STEP_DEVICE;
>>> +
>>> +	/* sync irq callback. */
>>> +	if (vp_dev->intx_enabled) {
>>> +		irq = vp_dev->pci_dev->irq;
>>> +
>>> +	} else {
>>> +		if (info->msix_vector == VIRTIO_MSI_NO_VECTOR)
>>> +			return 0;
>>> +
>>> +		irq = pci_irq_vector(vp_dev->pci_dev, info->msix_vector);
>>> +	}
>>> +
>>> +	synchronize_irq(irq);
>>
>> Synchronize_irq() is not sufficient here since it breaks the effort of
>> the interrupt hardening which is done by commits:
>>
>> 080cd7c3ac87 virtio-pci: harden INTX interrupts
>> 9e35276a5344 virtio_pci: harden MSI-X interrupts
>>
>> Unfortunately  080cd7c3ac87 introduces an issue that disable_irq() were
>> used for the affinity managed irq but we're discussing a fix.
> I need to understand it first.
>
>>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
>>> +{
>>> +	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>>> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>> +	struct virtio_pci_vq_info *info;
>>> +	unsigned long flags, index;
>>> +	int err;
>>> +
>>> +	if (vq->reset != VIRTIO_VQ_RESET_STEP_VRING_ATTACH)
>>> +		return -EBUSY;
>>> +
>>> +	index = vq->index;
>>> +	info = vp_dev->vqs[index];
>>> +
>>> +	/* check queue reset status */
>>> +	if (vp_modern_get_queue_reset(mdev, index) != 1)
>>> +		return -EBUSY;
>>> +
>>> +	err = vp_active_vq(vq, info->msix_vector);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	if (vq->callback) {
>>> +		spin_lock_irqsave(&vp_dev->lock, flags);
>>> +		list_add(&info->node, &vp_dev->virtqueues);
>>> +		spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +	} else {
>>> +		INIT_LIST_HEAD(&info->node);
>>> +	}
>>> +
>>> +	vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
>>
>> Any reason we need to check queue_enable() here?
> The purpose of this function is to enable a reset vq, so call queue_enable() to
> activate it.


Ok, this is what spec mandate.

Thanks


>
> Thanks.
>
>> Thanks
>>
>>
>>> +	vq->reset = VIRTIO_VQ_RESET_STEP_NONE;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>    static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>>>    {
>>>    	return vp_modern_config_vector(&vp_dev->mdev, vector);
>>> @@ -407,6 +486,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>>>    	.set_vq_affinity = vp_set_vq_affinity,
>>>    	.get_vq_affinity = vp_get_vq_affinity,
>>>    	.get_shm_region  = vp_get_shm_region,
>>> +	.reset_vq	 = vp_modern_reset_vq,
>>> +	.enable_reset_vq = vp_modern_enable_reset_vq,
>>>    };
>>>
>>>    static const struct virtio_config_ops virtio_pci_config_ops = {
>>> @@ -425,6 +506,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>>>    	.set_vq_affinity = vp_set_vq_affinity,
>>>    	.get_vq_affinity = vp_get_vq_affinity,
>>>    	.get_shm_region  = vp_get_shm_region,
>>> +	.reset_vq	 = vp_modern_reset_vq,
>>> +	.enable_reset_vq = vp_modern_enable_reset_vq,
>>>    };
>>>
>>>    /* the PCI probing function */

