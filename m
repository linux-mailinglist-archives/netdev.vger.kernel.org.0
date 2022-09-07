Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027955AFB0D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 06:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiIGEV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 00:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIGEVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 00:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4283B895D6
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 21:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662524481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+P+z8TSJ/Zyfj7d1c5azECG0cOYl08GFb3K30xN3HE=;
        b=Lpu79Qs4LxRlTr9nFiLQt8z3VqN1+EVqRtq9cv6L9TIFgnCJ8GNHQdijAMYVh+YHPMxLPp
        hYWm22hAlZdg7toFaJlgGO9zSV+x+/SnrjCTGC7O6CF0kQ8ogZFHtkLbHCb7na8mWB2dEO
        9OL8y22bLnAr5j8riMYXsQJtvtxGYHU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-EABEQ3e0PD2qOaWUUvvo5A-1; Wed, 07 Sep 2022 00:21:20 -0400
X-MC-Unique: EABEQ3e0PD2qOaWUUvvo5A-1
Received: by mail-pf1-f198.google.com with SMTP id cg5-20020a056a00290500b0053511889856so6864435pfb.18
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 21:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=S+P+z8TSJ/Zyfj7d1c5azECG0cOYl08GFb3K30xN3HE=;
        b=0TyBqlk7QtYYCpvo8dqoFlbvUv0c+EbQlojJCCvfjEtQ3S1JPzSvsIp7ZM4ULIG202
         RKdJ+EE6rqt2k47QTJlik79VTDx6GUWBLqT72roUGrgUnsmmB6Xdmk4ZvKNsmyEp1v6R
         z8fiCP5g+mB3jkbM6B8FAjMPCF0O3ac6/DdjNW+PGRvvOm29ETj0s7ntxC06vNUzCZcp
         Q5vhvG45Cnizzb2q803/OaAznYyCDPsxy3YFt4UNFJ4gPiC5JDVQ17HnTWyvuaTktcEw
         2hf25cWxej+LF/a90scnKKMQNx6zX9UdyoYjoTR53VBto9Fc2UHu1LgDsSdHDCqIk733
         3SsA==
X-Gm-Message-State: ACgBeo0zZQfbFxV6xdJJm+/BNp4ubNXuK0AflLi3ehHaxSiqi/OTEu8k
        0oAcTV9nl7SmbkPZ4FyJ46VosMP4quP1s+Z9GfU3xeOYpC+02FWfaEZTc5AjB6L6FEEbkO9mbVV
        gNajf45II7XEsPLmy
X-Received: by 2002:a05:6a00:22c7:b0:53a:bea5:9abd with SMTP id f7-20020a056a0022c700b0053abea59abdmr1770318pfj.3.1662524479098;
        Tue, 06 Sep 2022 21:21:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7FdPkXihchbJtJv8Jd83bDgPxk3tYbsa2yRZ4rh/+Tyemh4rXUJmUXF5h6WyCU3XNVQ3nufA==
X-Received: by 2002:a05:6a00:22c7:b0:53a:bea5:9abd with SMTP id f7-20020a056a0022c700b0053abea59abdmr1770291pfj.3.1662524478842;
        Tue, 06 Sep 2022 21:21:18 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b28-20020aa78edc000000b0053ae6a3c51asm11172533pfr.186.2022.09.06.21.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 21:21:18 -0700 (PDT)
Message-ID: <dcf40392-26a7-b4f1-ad2c-44fac99fb330@redhat.com>
Date:   Wed, 7 Sep 2022 12:21:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v3 1/7] vhost: expose used buffers
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
 <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/1 13:54, Guo Zhi 写道:
> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
> of descriptors.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vhost.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..26862c8bf751 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   	vring_used_elem_t __user *used;
>   	u16 old, new;
>   	int start;
> +	int copy_n = count;
>   
> +	/**
> +	 * If in order feature negotiated, devices can notify the use of a batch of buffers to
> +	 * the driver by only writing out a single used ring entry with the id corresponding
> +	 * to the head entry of the descriptor chain describing the last buffer in the batch.
> +	 */
> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +		copy_n = 1;
> +		heads = &heads[count - 1];
> +	}


Would it better to have a dedicated helper like 
vhost_add_used_in_order() here?


>   	start = vq->last_used_idx & (vq->num - 1);
>   	used = vq->used->ring + start;
> -	if (vhost_put_used(vq, heads, start, count)) {
> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>   		vq_err(vq, "Failed to write used");
>   		return -EFAULT;
>   	}
> @@ -2388,7 +2398,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   		smp_wmb();
>   		/* Log used ring entry write. */
>   		log_used(vq, ((void __user *)used - (void __user *)vq->used),
> -			 count * sizeof *used);
> +			 copy_n * sizeof(*used));
>   	}
>   	old = vq->last_used_idx;
>   	new = (vq->last_used_idx += count);
> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>   
>   	start = vq->last_used_idx & (vq->num - 1);
>   	n = vq->num - start;
> -	if (n < count) {
> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {


This seems strange, any reason for this? (Actually if we support 
in-order we only need one used slot which fit for the case here)

Thanks


>   		r = __vhost_add_used_n(vq, heads, n);
>   		if (r < 0)
>   			return r;

