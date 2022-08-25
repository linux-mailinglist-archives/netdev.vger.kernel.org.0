Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE705A096B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiHYHBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbiHYHBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868CEA1A40
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661410900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7Q/XXN1Xt6SZJFciYXpFS6HHcnYgr65n/puG7GgfQY=;
        b=Oo7FmtoPw8Cnm3lmDdaM2xF+wAoMJsVOqwspXH6KAmZUwqVUDOAIr37WZs8eJn77yvPoxG
        9mn2hjQ0ke74YXEwLGEaJbcq1kJrkvwsoLnurzjza6rIdVB7pNvSBPIVo0xQulNmjZ5bGB
        bmhFw4iwABQ/WT3yHeXQcb+EYTLvJiM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-dzCH_b7FPRODFkRciTFUiA-1; Thu, 25 Aug 2022 03:01:39 -0400
X-MC-Unique: dzCH_b7FPRODFkRciTFUiA-1
Received: by mail-pj1-f72.google.com with SMTP id m24-20020a17090b069800b001fac361aec2so8582596pjz.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:01:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+7Q/XXN1Xt6SZJFciYXpFS6HHcnYgr65n/puG7GgfQY=;
        b=nLQj0OXwy0QGZ3QWTtAQcr2epDXCLYJfSeKjVXNZyGwB7KJI9o9/T9H03pZzYa5lKp
         XcXKXzJy7KktNLx3xZ+bnt3IQZNza5ebY+/sPP0Ilw4LgU/cr+FNhPrmke3YIw4HL98D
         SzW2/PFb0+OShxVRsMHRWHFyVxZAyIIZg5OuG6B84JxmOcOQerM2p3J7OGaLPs96YQcc
         8Z4kUA2qVctbnA6nJWp21HIesM3JSsrpnok2GCCxIe8LWDFWRrMUM3NO8b/V4nQmMhYx
         5Bbl6xKZOd2GZGIQKsIuehlJFvHo7FjEdIwLTamX6N9azrM3z5dTZTOECTnNEEcOfprt
         G1Qg==
X-Gm-Message-State: ACgBeo0ER4v/pZwMzRkDjvpYV1Yy2HGPqfzj5cDX9GBCTmJwxODDLLFl
        zv9Y7/IzGVH/Q7C/9ixCJky7K8aYqPlvwPyaL//iTw5i6qcKKq3coGBf7+9ZenzVodfh7qnDJLR
        hZUz34KKuBmHSAtyW
X-Received: by 2002:a17:90a:1b69:b0:1fa:f9de:fbcf with SMTP id q96-20020a17090a1b6900b001faf9defbcfmr11990631pjq.201.1661410898296;
        Thu, 25 Aug 2022 00:01:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4fQhngR98Oeq2+dGcVYZV3kfTv/ZlLWB36qK/slHkYNTgX2VUISGCAUCdxzL/7nf+paX9Aow==
X-Received: by 2002:a17:90a:1b69:b0:1fa:f9de:fbcf with SMTP id q96-20020a17090a1b6900b001faf9defbcfmr11990595pjq.201.1661410897994;
        Thu, 25 Aug 2022 00:01:37 -0700 (PDT)
Received: from [10.72.12.107] ([119.254.120.70])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a034c00b001fb438fb772sm2609158pjf.56.2022.08.25.00.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 00:01:37 -0700 (PDT)
Message-ID: <3a184162-afdc-9103-e786-66d796389e3a@redhat.com>
Date:   Thu, 25 Aug 2022 15:01:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v2 1/7] vhost: expose used buffers
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/17 21:57, Guo Zhi 写道:
> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
> of descriptors.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vhost.c | 14 ++++++++++++--
>   drivers/vhost/vhost.h |  1 +
>   2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..7b20fa5a46c3 100644
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


Do we need to check whether or not the buffer is fully used before doing 
this?


> +	}
>   	start = vq->last_used_idx & (vq->num - 1);
>   	used = vq->used->ring + start;
> -	if (vhost_put_used(vq, heads, start, count)) {
> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>   		vq_err(vq, "Failed to write used");
>   		return -EFAULT;
>   	}
> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>   
>   	start = vq->last_used_idx & (vq->num - 1);
>   	n = vq->num - start;
> -	if (n < count) {
> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>   		r = __vhost_add_used_n(vq, heads, n);
>   		if (r < 0)
>   			return r;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107af08..0d5c49a30421 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -236,6 +236,7 @@ enum {
>   	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>   			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
>   			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> +			 (1ULL << VIRTIO_F_IN_ORDER) |
>   			 (1ULL << VHOST_F_LOG_ALL) |


Are we sure all vhost devices can support in-order (especially the SCSI)?

It looks better to start from a device specific one.

Thanks


>   			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
>   			 (1ULL << VIRTIO_F_VERSION_1)

