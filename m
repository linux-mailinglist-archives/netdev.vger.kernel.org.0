Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790DC581E95
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 06:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbiG0EXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 00:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiG0EXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 00:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB93D3B948
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658895818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdTyBXQ12zt36fi5CylDMDbBOh0jOOAI9MK/TOtCnDo=;
        b=clAt6ZQlfO6k5BBPjFBr6dhCEzvXxQ8Ir9UNp/mr+DFPERty9ete6vvC/JQcEm5tuhX2zc
        obIOZzlqkRhXxk5IUprFdKPPkPeDkEMBIY6twXcFVvXrn+uLeAPV+H0P9cpgJQoTrporPc
        C3S/CHs1yZn8vM6G1U7eQ1Bg1acxU7I=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-oBD-9mneO2mxEccrktIpew-1; Wed, 27 Jul 2022 00:23:37 -0400
X-MC-Unique: oBD-9mneO2mxEccrktIpew-1
Received: by mail-pg1-f198.google.com with SMTP id f128-20020a636a86000000b0041a4b07b039so7210888pgc.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OdTyBXQ12zt36fi5CylDMDbBOh0jOOAI9MK/TOtCnDo=;
        b=7DGQ1vnMLKZTJEeV0s32PhJ7W4l4MkjqRUzR3Ip/rbfFVHuenOa1dfmFBWOfcoYHqK
         vviDAsfh7cSgHRneFF7O6XlVh4Z/VMooJ5qBuy897yZc7c8p5Rc4zkSfJ1v34lAbyQmD
         Vw+22GB9JCltl0M/aK6PF8eX6hPGJk7M0khZsbRYml/2wMiD/CwbIcWRdH90+GLHj08L
         R930ilxzIPi/CAKPD8ZbgCsxr3lUDQRTXJUU2vN02SA4wu6ZtLAJlNBRncbvLju4hN+N
         fXqa3a5/oMz/NcD/yu993+qGHr9X0I72wolxghm59GV+heqwzfwO2inWClWPabWwBQNu
         KL3A==
X-Gm-Message-State: AJIora/qyrahRdQ5SN4ODnWvPwclppomFrDpCYMX4qkUhBrFWIRCeBx9
        IyK0bvxzfDmQWKmslkNJSEgTVmPGABqeSyRrvVXZsWgxT7fQ6dkIg9bqZdLewomrw7LaymDSqSy
        EjXycStJ8K4Tshf9v
X-Received: by 2002:a17:903:24e:b0:16b:9fa2:41e5 with SMTP id j14-20020a170903024e00b0016b9fa241e5mr20227878plh.127.1658895816030;
        Tue, 26 Jul 2022 21:23:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tFVrN7XGfUjMTUPwELy3bIdBt3XT5BzzLiiLmTtkRh2koWjrFFsrQ3JLmbIc4/6H4P5/I5Jg==
X-Received: by 2002:a17:903:24e:b0:16b:9fa2:41e5 with SMTP id j14-20020a170903024e00b0016b9fa241e5mr20227852plh.127.1658895815745;
        Tue, 26 Jul 2022 21:23:35 -0700 (PDT)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l28-20020a635b5c000000b0041a411823d4sm10950578pgm.22.2022.07.26.21.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 21:23:34 -0700 (PDT)
Message-ID: <1a5fa20c-c8f2-2537-2b3b-675a40e113ac@redhat.com>
Date:   Wed, 27 Jul 2022 12:23:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v13 11/42] virtio_ring: split: extract the logic of alloc
 state and extra
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
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-12-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220726072225.19884-12-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/26 15:21, Xuan Zhuo 写道:
> Separate the logic of creating desc_state, desc_extra, and subsequent
> patches will call it independently.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 51 +++++++++++++++++++++++++-----------
>   1 file changed, 35 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 3817520371ee..6c24b33ea186 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -212,6 +212,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   					       bool (*notify)(struct virtqueue *),
>   					       void (*callback)(struct virtqueue *),
>   					       const char *name);
> +static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
>   
>   /*
>    * Helpers.
> @@ -947,6 +948,32 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
>   	return NULL;
>   }
>   
> +static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring_split)
> +{
> +	struct vring_desc_state_split *state;
> +	struct vring_desc_extra *extra;
> +	u32 num = vring_split->vring.num;
> +
> +	state = kmalloc_array(num, sizeof(struct vring_desc_state_split), GFP_KERNEL);
> +	if (!state)
> +		goto err_state;
> +
> +	extra = vring_alloc_desc_extra(num);
> +	if (!extra)
> +		goto err_extra;
> +
> +	memset(state, 0, num * sizeof(struct vring_desc_state_split));
> +
> +	vring_split->desc_state = state;
> +	vring_split->desc_extra = extra;
> +	return 0;
> +
> +err_extra:
> +	kfree(state);
> +err_state:
> +	return -ENOMEM;
> +}
> +
>   static void vring_free_split(struct vring_virtqueue_split *vring_split,
>   			     struct virtio_device *vdev)
>   {
> @@ -2242,6 +2269,7 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   					       const char *name)
>   {
>   	struct vring_virtqueue *vq;
> +	int err;
>   
>   	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
>   		return NULL;
> @@ -2282,17 +2310,14 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   					vq->split.avail_flags_shadow);
>   	}
>   
> -	vq->split.desc_state = kmalloc_array(vring_split->vring.num,
> -			sizeof(struct vring_desc_state_split), GFP_KERNEL);
> -	if (!vq->split.desc_state)
> -		goto err_state;
> -
> -	vq->split.desc_extra = vring_alloc_desc_extra(vring_split->vring.num);
> -	if (!vq->split.desc_extra)
> -		goto err_extra;
> +	err = vring_alloc_state_extra_split(vring_split);
> +	if (err) {
> +		kfree(vq);
> +		return NULL;
> +	}
>   
> -	memset(vq->split.desc_state, 0, vring_split->vring.num *
> -			sizeof(struct vring_desc_state_split));
> +	vq->split.desc_state = vring_split->desc_state;
> +	vq->split.desc_extra = vring_split->desc_extra;
>   
>   	virtqueue_init(vq, vring_split->vring.num);
>   
> @@ -2300,12 +2325,6 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	list_add_tail(&vq->vq.list, &vdev->vqs);
>   	spin_unlock(&vdev->vqs_list_lock);
>   	return &vq->vq;
> -
> -err_extra:
> -	kfree(vq->split.desc_state);
> -err_state:
> -	kfree(vq);
> -	return NULL;
>   }
>   
>   struct virtqueue *vring_create_virtqueue(

