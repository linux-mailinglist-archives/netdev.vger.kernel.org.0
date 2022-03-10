Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335A44D4177
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbiCJHCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239955AbiCJHB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:01:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E9FD12F425
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 23:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646895648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkMQorCMU7xc93uPK5gJZgn4oA7Bb7VUOpIFgodhLkk=;
        b=Y5HfUX+g8XcOPc95Yl+vYg3fQC4JDRx5uYuLS0evCwbO9Ln8j8CTEYwEBcxp0bLqiJkUr7
        bsGN7wj3SL7IAxRYGnRcISouPBBH471SnuNUA2+3tw0TvkPD+7CfCDfcTRwDd52bSl3Jbk
        /gGQjVyfv/8EUAkxzbOcSEVOapS3by0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-zncVG3_oMNeHtzUgNKGKLQ-1; Thu, 10 Mar 2022 02:00:47 -0500
X-MC-Unique: zncVG3_oMNeHtzUgNKGKLQ-1
Received: by mail-wm1-f72.google.com with SMTP id h131-20020a1c2189000000b003898de01de4so1738128wmh.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 23:00:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LkMQorCMU7xc93uPK5gJZgn4oA7Bb7VUOpIFgodhLkk=;
        b=JI+0oK21sesbNt572zb83slcL0J+FbJv4NvifIwvKTf2GKD954OaCDRRAdJjii3O20
         7pB71cVVAlF+Y+LS4cLCPMAKykv0kGM/OsltFOqkg+3G0UST8xyl5BYwBuarVdWxOCio
         RGMQlk0PK9PyFFDYSp0zXqnIcDRfNVY6Pvhgo/JrgtvlfluhGQFQPhKFdwqiQ9+DGKgF
         nSUSsmuDfb9eOaYCFXlARR/TNCyAv76WQT0WkDQWntwuV0LesYZo5JjZRZEPedta+nGF
         v9nlIYwmybqBlkzH2XdynyBdnVMi5qaKg1DO95ungl31CkOR3y3QIkR8hNVKBYuA+PFx
         AIbg==
X-Gm-Message-State: AOAM5302Z4/xs3/FrFyv8p0Abs0GFvih1tfyEG0CflIEc+ISLc+3/SzB
        unZRaRYxZPISf8s7ZlWWr0QokyNLDBwaUSUKywJV8FB3ZazXcLHip4RKuR4NiiMB/p71uFKBvpg
        Cw0Yqfm9N/j13atwt
X-Received: by 2002:a05:6000:1104:b0:1f9:7df6:c864 with SMTP id z4-20020a056000110400b001f97df6c864mr2313847wrw.63.1646895645809;
        Wed, 09 Mar 2022 23:00:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsDaUfg1Dzks5kcvSZTIGN65fjx4oj0qZwLxHiAr1eXZpgoIX0Ngv/xjK7eBdLbtD4hrdZUQ==
X-Received: by 2002:a05:6000:1104:b0:1f9:7df6:c864 with SMTP id z4-20020a056000110400b001f97df6c864mr2313828wrw.63.1646895645533;
        Wed, 09 Mar 2022 23:00:45 -0800 (PST)
Received: from redhat.com ([2.55.24.184])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d6707000000b001f067c7b47fsm5312811wru.27.2022.03.09.23.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 23:00:44 -0800 (PST)
Date:   Thu, 10 Mar 2022 02:00:39 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
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
Subject: Re: [PATCH v7 09/26] virtio_ring: split: implement
 virtqueue_reset_vring_split()
Message-ID: <20220310015418-mutt-send-email-mst@kernel.org>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-10-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308123518.33800-10-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 08:35:01PM +0800, Xuan Zhuo wrote:
> virtio ring supports reset.
> 
> Queue reset is divided into several stages.
> 
> 1. notify device queue reset
> 2. vring release
> 3. attach new vring
> 4. notify device queue re-enable
> 
> After the first step is completed, the vring reset operation can be
> performed. If the newly set vring num does not change, then just reset
> the vq related value.
> 
> Otherwise, the vring will be released and the vring will be reallocated.
> And the vring will be attached to the vq. If this process fails, the
> function will exit, and the state of the vq will be the vring release
> state. You can call this function again to reallocate the vring.
> 
> In addition, vring_align, may_reduce_num are necessary for reallocating
> vring, so they are retained when creating vq.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index e0422c04c903..148fb1fd3d5a 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -158,6 +158,12 @@ struct vring_virtqueue {
>  			/* DMA address and size information */
>  			dma_addr_t queue_dma_addr;
>  			size_t queue_size_in_bytes;
> +
> +			/* The parameters for creating vrings are reserved for
> +			 * creating new vrings when enabling reset queue.
> +			 */
> +			u32 vring_align;
> +			bool may_reduce_num;
>  		} split;
>  
>  		/* Available for packed ring */
> @@ -217,6 +223,12 @@ struct vring_virtqueue {
>  #endif
>  };
>  
> +static void vring_free(struct virtqueue *vq);
> +static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> +					 struct virtio_device *vdev);
> +static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> +					  struct virtio_device *vdev,
> +					  struct vring vring);
>  
>  /*
>   * Helpers.
> @@ -1012,6 +1024,8 @@ static struct virtqueue *vring_create_virtqueue_split(
>  		return NULL;
>  	}
>  
> +	to_vvq(vq)->split.vring_align = vring_align;
> +	to_vvq(vq)->split.may_reduce_num = may_reduce_num;
>  	to_vvq(vq)->split.queue_dma_addr = vring.dma_addr;
>  	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
>  	to_vvq(vq)->we_own_ring = true;
> @@ -1019,6 +1033,59 @@ static struct virtqueue *vring_create_virtqueue_split(
>  	return vq;
>  }
>  
> +static int virtqueue_reset_vring_split(struct virtqueue *_vq, u32 num)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	struct virtio_device *vdev = _vq->vdev;
> +	struct vring_split vring;
> +	int err;
> +
> +	if (num > _vq->num_max)
> +		return -E2BIG;
> +
> +	switch (vq->vq.reset) {
> +	case VIRTIO_VQ_RESET_STEP_NONE:
> +		return -ENOENT;
> +
> +	case VIRTIO_VQ_RESET_STEP_VRING_ATTACH:
> +	case VIRTIO_VQ_RESET_STEP_DEVICE:
> +		if (vq->split.vring.num == num || !num)
> +			break;
> +
> +		vring_free(_vq);
> +
> +		fallthrough;
> +
> +	case VIRTIO_VQ_RESET_STEP_VRING_RELEASE:
> +		if (!num)
> +			num = vq->split.vring.num;
> +
> +		err = vring_create_vring_split(&vring, vdev,
> +					       vq->split.vring_align,
> +					       vq->weak_barriers,
> +					       vq->split.may_reduce_num, num);
> +		if (err)
> +			return -ENOMEM;
> +
> +		err = __vring_virtqueue_attach_split(vq, vdev, vring.vring);
> +		if (err) {
> +			vring_free_queue(vdev, vring.queue_size_in_bytes,
> +					 vring.queue,
> +					 vring.dma_addr);
> +			return -ENOMEM;
> +		}
> +
> +		vq->split.queue_dma_addr = vring.dma_addr;
> +		vq->split.queue_size_in_bytes = vring.queue_size_in_bytes;
> +	}
> +
> +	__vring_virtqueue_init_split(vq, vdev);
> +	vq->we_own_ring = true;
> +	vq->vq.reset = VIRTIO_VQ_RESET_STEP_VRING_ATTACH;
> +
> +	return 0;
> +}
> +

I kind of dislike this state machine.

Hacks like special-casing num = 0 to mean "reset" are especially
confusing.

And as Jason points out, when we want a resize then yes this currently
implies reset but that is an implementation detail.

There should be a way to just make these cases separate functions
and then use them to compose consistent external APIs.

If we additionally want to track state for debugging then bool flags
seem more appropriate for this, though from experience that is
not always worth the extra code.



>  /*
>   * Packed ring specific functions - *_packed().
> @@ -2317,6 +2384,8 @@ static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
>  static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
>  					 struct virtio_device *vdev)
>  {
> +	vq->vq.reset = VIRTIO_VQ_RESET_STEP_NONE;
> +
>  	vq->packed_ring = false;
>  	vq->we_own_ring = false;
>  	vq->broken = false;
> -- 
> 2.31.0

