Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF74D18E0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346261AbiCHNO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiCHNOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:14:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C901F31227
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646745206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFIIsV6xf+S0UEWrtwaMoEgM3YQfdJSczMHcKL/I9IM=;
        b=Rs0qd956hsvjYA6qc11ZMAfvLqmPhkIgBY8d1WtDuMaGYxQ47EFqO0IANznl82dReKmIFN
        a5CV/LcaKBJkcNo2SlyQOwFl4eRYszsXaBNHNFY6w4LDqCwF3x5fmEbUoSunknh61aU6I5
        07+sXLdNllvBgHFXAZoG+k/xGxQiyhg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-BIP6hszKMWGXi8XM4FbRrg-1; Tue, 08 Mar 2022 08:13:25 -0500
X-MC-Unique: BIP6hszKMWGXi8XM4FbRrg-1
Received: by mail-ed1-f70.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so10580161edb.2
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:13:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TFIIsV6xf+S0UEWrtwaMoEgM3YQfdJSczMHcKL/I9IM=;
        b=tfvzIU+4agcP6xMiMlnVMYhXQdblnXAsr3tCt3OUfwMTBEV2nKbJj/3US6g9Df3V1P
         lhotwdxpcFnM4qloRoDRtU3LURnGKkqjrJfsWKwSv67WYRTo4lsf+0gbqzGBYLR9PW2c
         zVq9+LfLg5gj6FfX3gPefIpgc3cyYaz2j7c3Hog2ODUvhD2w4gK8bpnYqN29Tg/w7sr5
         QCJxm2Bxn/Lx+SH2ju9LfpspFNXLTnvm2qYpWbgyxafrq/XV/X4F6WFk/38zi37N3LxI
         v3EcOQYL5TLYKSk8D7FF0eltdHy12dR1VAhNbBUFhBy4U0ZhxGH1lTJ5y6HukZ+j7FEZ
         Sbiw==
X-Gm-Message-State: AOAM531kHkMvlajQG7vWlxgQiMoUR6ImOarJjmRr7gQZnKt003Dnuygs
        aX4XZR9zREYFN0KcqCwuT6+AqMhET5+NjkVUulT16Wz8CYs2QI4OnBNzJ4odbubd3YShC14SVDa
        K/zbniTXd/b5pBzAR
X-Received: by 2002:a50:fd8e:0:b0:415:fe34:f03 with SMTP id o14-20020a50fd8e000000b00415fe340f03mr16011190edt.310.1646745204337;
        Tue, 08 Mar 2022 05:13:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSKnu6K/NfFAzTqzK33mk/s1Pj3nnEXeXgvcjdorQuXqCcPMBlODVSeHgfeXrL76lGr2ehtQ==
X-Received: by 2002:a50:fd8e:0:b0:415:fe34:f03 with SMTP id o14-20020a50fd8e000000b00415fe340f03mr16011160edt.310.1646745204085;
        Tue, 08 Mar 2022 05:13:24 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id z23-20020a170906435700b006b0e62bee84sm5807047ejm.115.2022.03.08.05.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:13:23 -0800 (PST)
Message-ID: <c5da5e77-2ea8-6721-365b-bf2248951dce@redhat.com>
Date:   Tue, 8 Mar 2022 14:13:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v7 18/26] virtio: find_vqs() add arg sizes
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
 <20220308123518.33800-19-xuanzhuo@linux.alibaba.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220308123518.33800-19-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

Hi,

On 3/8/22 13:35, Xuan Zhuo wrote:
> find_vqs() adds a new parameter sizes to specify the size of each vq
> vring.
> 
> 0 means use the maximum size supported by the backend.
> 
> In the split scenario, the meaning of size is the largest size, because
> it may be limited by memory, the virtio core will try a smaller size.
> And the size is power of 2.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  arch/um/drivers/virtio_uml.c             |  2 +-
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  3 ++-
>  drivers/remoteproc/remoteproc_virtio.c   |  2 +-
>  drivers/s390/virtio/virtio_ccw.c         |  2 +-
>  drivers/virtio/virtio_mmio.c             |  2 +-
>  drivers/virtio/virtio_pci_common.c       |  2 +-
>  drivers/virtio/virtio_pci_common.h       |  2 +-
>  drivers/virtio/virtio_pci_modern.c       |  5 +++--
>  drivers/virtio/virtio_vdpa.c             |  2 +-
>  include/linux/virtio_config.h            | 11 +++++++----
>  10 files changed, 19 insertions(+), 14 deletions(-)

I assume this will be merged through the virtio tree, here
is my ack for merging the drivers/platform/mellanox/ part
through the virtio tree:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> 
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index ba562d68dc04..055b91ccbe8a 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -998,7 +998,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
>  static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  		       const char * const names[], const bool *ctx,
> -		       struct irq_affinity *desc)
> +		       struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>  	int i, queue_idx = 0, rc;
> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
> index 38800e86ed8a..aea7aa218b22 100644
> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> @@ -929,7 +929,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
>  					vq_callback_t *callbacks[],
>  					const char * const names[],
>  					const bool *ctx,
> -					struct irq_affinity *desc)
> +					struct irq_affinity *desc,
> +					u32 sizes[])
>  {
>  	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
>  	struct mlxbf_tmfifo_vring *vring;
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> index 70ab496d0431..3a167bec5b09 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -157,7 +157,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  				 vq_callback_t *callbacks[],
>  				 const char * const names[],
>  				 const bool * ctx,
> -				 struct irq_affinity *desc)
> +				 struct irq_affinity *desc, u32 sizes[])
>  {
>  	int i, ret, queue_idx = 0;
>  
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index d35e7a3f7067..b74e08c71534 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -632,7 +632,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			       vq_callback_t *callbacks[],
>  			       const char * const names[],
>  			       const bool *ctx,
> -			       struct irq_affinity *desc)
> +			       struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	unsigned long *indicatorp = NULL;
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index a41abc8051b9..55d575f6ef2d 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -462,7 +462,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		       vq_callback_t *callbacks[],
>  		       const char * const names[],
>  		       const bool *ctx,
> -		       struct irq_affinity *desc)
> +		       struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>  	int irq = platform_get_irq(vm_dev->pdev, 0);
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 863d3a8a0956..8e8fa7e5ad80 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -428,7 +428,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
>  int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  		const char * const names[], const bool *ctx,
> -		struct irq_affinity *desc)
> +		struct irq_affinity *desc, u32 sizes[])
>  {
>  	int err;
>  
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 23f6c5c678d5..9dbf1d555dff 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -114,7 +114,7 @@ void vp_del_vqs(struct virtio_device *vdev);
>  int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  		const char * const names[], const bool *ctx,
> -		struct irq_affinity *desc);
> +		struct irq_affinity *desc, u32 sizes[]);
>  const char *vp_bus_name(struct virtio_device *vdev);
>  
>  /* Setup the affinity for a virtqueue:
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 3c67d3607802..342795175c29 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -343,11 +343,12 @@ static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			      struct virtqueue *vqs[],
>  			      vq_callback_t *callbacks[],
>  			      const char * const names[], const bool *ctx,
> -			      struct irq_affinity *desc)
> +			      struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>  	struct virtqueue *vq;
> -	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
> +	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc,
> +			     sizes);
>  
>  	if (rc)
>  		return rc;
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 7767a7f0119b..ee08d01ee8b1 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -268,7 +268,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  				vq_callback_t *callbacks[],
>  				const char * const names[],
>  				const bool *ctx,
> -				struct irq_affinity *desc)
> +				struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
>  	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 0b81fbe17c85..5157524d8036 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -57,6 +57,7 @@ struct virtio_shm_region {
>   *		include a NULL entry for vqs that do not need a callback
>   *	names: array of virtqueue names (mainly for debugging)
>   *		include a NULL entry for vqs unused by driver
> + *	sizes: array of virtqueue sizes
>   *	Returns 0 on success or error status
>   * @del_vqs: free virtqueues found by find_vqs().
>   * @get_features: get the array of feature bits for this device.
> @@ -98,7 +99,8 @@ struct virtio_config_ops {
>  	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>  			struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  			const char * const names[], const bool *ctx,
> -			struct irq_affinity *desc);
> +			struct irq_affinity *desc,
> +			u32 sizes[]);
>  	void (*del_vqs)(struct virtio_device *);
>  	u64 (*get_features)(struct virtio_device *vdev);
>  	int (*finalize_features)(struct virtio_device *vdev);
> @@ -205,7 +207,7 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
>  	const char *names[] = { n };
>  	struct virtqueue *vq;
>  	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NULL,
> -					 NULL);
> +					 NULL, NULL);
>  	if (err < 0)
>  		return ERR_PTR(err);
>  	return vq;
> @@ -217,7 +219,8 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			const char * const names[],
>  			struct irq_affinity *desc)
>  {
> -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
> +				      desc, NULL);
>  }
>  
>  static inline
> @@ -227,7 +230,7 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
>  			struct irq_affinity *desc)
>  {
>  	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> -				      desc);
> +				      desc, NULL);
>  }
>  
>  /**

