Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D5A5A09AB
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiHYHLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237865AbiHYHL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:11:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF907393D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661411475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8hstYML2crFW9jfle1ivYRn1yE7n1hXLc4hnxMa+ms8=;
        b=XjLkglLfHZ5x8nYFwbWBstCfcMCtaMrjvI1exvLqQW1u8sUTKHnnSsxF88BznNp13mIjHZ
        zS6IgIVrdWx2tyfeQWudmNnrO+uX4Irj40OUM0ZDJJLeS25qNseh+Rfo/8CFGo/SYX/UCe
        Xpa8DzlUd/dxB8xis4qBVITWwOrfbiM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-270-2meiecJKMRWJfa-kZevgCA-1; Thu, 25 Aug 2022 03:11:14 -0400
X-MC-Unique: 2meiecJKMRWJfa-kZevgCA-1
Received: by mail-pl1-f197.google.com with SMTP id s8-20020a170902ea0800b00172e456031eso7364594plg.3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=8hstYML2crFW9jfle1ivYRn1yE7n1hXLc4hnxMa+ms8=;
        b=QcDMK80/IENtGLKVORNaxWXsmXwdPIArl+YMYHX0bA0aZeNyJIkfOzAuNsVX9/xzq6
         XUn3LhUfSxwXhdxtGBQqCnzUo/7CZ+eVO3lz/6GZnHQPjCmPk0QwfCWRLIY5c7FwbOA7
         sGLK8sxeC748WE8udKj5qUZ3DR8wRj/Wpi6QeUTkCUCCDL2becyJffr/crbayrq2WXLc
         ZDZfZveyjZSNx+QdWis2sUanxet5xIu0HMKe543+F0zs2JmsknCW3f/Y+3qpALxjDLcp
         7V9eUJkWwCU4H/KbSeEj0KrgA5R0/qv+/rstBjIsbZIZe0lL4GXRXj1P+zmAqCWwiZc7
         ubYw==
X-Gm-Message-State: ACgBeo1wzVZ/hOBAQ6qBrtKA51ESRs1z0Wz0krpKQMVENTyW2ZlSWzF1
        810A0pdnT3efs3hlKkylZcccZEbwiwo9NvC6+QfGI4429Q9h749HCST9znlykyR4aejTBYZjLI2
        V9CZ/y9Gtx+dbuoZh
X-Received: by 2002:a17:90b:388a:b0:1fb:7dea:c31e with SMTP id mu10-20020a17090b388a00b001fb7deac31emr3196540pjb.162.1661411473477;
        Thu, 25 Aug 2022 00:11:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5CeHBniCJJchbK95vuG0eHIrILIUeqOvLvVnn+uoxSbeGyNwzgMkrqzzDmQjcA7tg+85ezFw==
X-Received: by 2002:a17:90b:388a:b0:1fb:7dea:c31e with SMTP id mu10-20020a17090b388a00b001fb7deac31emr3196513pjb.162.1661411473242;
        Thu, 25 Aug 2022 00:11:13 -0700 (PDT)
Received: from [10.72.12.107] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h20-20020aa796d4000000b0053671a241a5sm9059808pfq.191.2022.08.25.00.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 00:11:12 -0700 (PDT)
Message-ID: <ac746502-e786-0290-821c-f576c6125efa@redhat.com>
Date:   Thu, 25 Aug 2022 15:11:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v2 5/7] virtio: unmask F_NEXT flag in desc_extra
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-6-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817135718.2553-6-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/17 21:57, Guo Zhi 写道:
> We didn't unmask F_NEXT flag in desc_extra in the end of a chain,
> unmask it so that we can access desc_extra to get next information.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>


I post a similar patch in the past.

Please share the perf numbers (e.g pps via pktgen).

Thanks


> ---
>   drivers/virtio/virtio_ring.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index a5ec724c01d8..1c1b3fa376a2 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -567,7 +567,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>   	}
>   	/* Last one doesn't continue. */
>   	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
> -	if (!indirect && vq->use_dma_api)
> +	if (!indirect)
>   		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
>   			~VRING_DESC_F_NEXT;
>   
> @@ -584,6 +584,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>   					 total_sg * sizeof(struct vring_desc),
>   					 VRING_DESC_F_INDIRECT,
>   					 false);
> +		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
> +			~VRING_DESC_F_NEXT;
>   	}
>   
>   	/* We're using some buffers from the free list. */
> @@ -693,7 +695,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>   	/* Put back on free list: unmap first-level descriptors and find end */
>   	i = head;
>   
> -	while (vq->split.vring.desc[i].flags & nextflag) {
> +	while (vq->split.desc_extra[i].flags & nextflag) {
>   		vring_unmap_one_split(vq, i);
>   		i = vq->split.desc_extra[i].next;
>   		vq->vq.num_free++;

