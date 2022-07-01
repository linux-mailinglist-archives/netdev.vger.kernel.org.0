Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958CA562F6C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbiGAJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbiGAJDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:03:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BF72275FB
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656666215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D1b6P6ndaF684cAO7Vh4K15FYuoIpDfb/buQv2cS9+s=;
        b=cwAib/SVcSnosIT6Qru3ZdypKl2x87gVyu/iczePVPCHgqMoqU17FnPOXu9CJ40N7DfNeE
        UG08uHrs8JotRxb2XgSyKIGWcsU8kOt1cNjaoscMrNurejgtME0JK4BK2hNfH4uAsCSUlw
        V5ihda7IAKjpJcVkC1z3fvyQrVKyZGk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-wORqHBUoM5qCnJYXE_wOYw-1; Fri, 01 Jul 2022 05:03:34 -0400
X-MC-Unique: wORqHBUoM5qCnJYXE_wOYw-1
Received: by mail-pg1-f199.google.com with SMTP id 15-20020a63040f000000b0040c9f7f2978so1019380pge.12
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D1b6P6ndaF684cAO7Vh4K15FYuoIpDfb/buQv2cS9+s=;
        b=KUCTbTpt6v9DVBoDqiMzOPgIcx0EvKX0yDjT21kziV2oCGhBAHsNQhSFtQWD2Bw27+
         jULsSHO902wZWsqwsuEMQj1fOz79dpL6lkl5oYW0NqMeD9SxB2vdQA6j9SEXRTEJDFg5
         0c5TTj974H4DGQuaW005eAKCzjNXIQrrWi460+EPcSqh+DvERLFCP1ePWXTrnzap44rP
         zcsNeTa97EMQ/VynyC0McTMrMtZEi35zvJapAj4saKkxY9Dtqsl+j2rKh1iPGGoPIH4a
         1jIOb/UqWYEGcSpWZ+KIYTQIJckn+w2xQACkOMLX2FCvRd1be7pc5BD6hPAq/MlbmR3/
         XVhQ==
X-Gm-Message-State: AJIora+j3+SHQDKgoisbmT8AKqJpXPIyL6gnPnkSGi7Y0f35iPf2ACpA
        R5iqnw8qxfCU2PKr2x+1YmtJWL8fhcQ5z8hZXAIqqGMLRjj2FNZr7kVwhu4JrwjXE+RmDqBj0nA
        h3sF4BFtwQ1mdvHoc
X-Received: by 2002:a17:903:18c:b0:16b:8f8a:335f with SMTP id z12-20020a170903018c00b0016b8f8a335fmr18699024plg.133.1656666212878;
        Fri, 01 Jul 2022 02:03:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1umuzlHjb+AVT8pHf+MDYjA/xytvg2Ww3qrvKeBf7drySw0yZL85wg1m0wVfhF0UW2aCpNd7Q==
X-Received: by 2002:a17:903:18c:b0:16b:8f8a:335f with SMTP id z12-20020a170903018c00b0016b8f8a335fmr18699008plg.133.1656666212635;
        Fri, 01 Jul 2022 02:03:32 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090aba1600b001ec71be4145sm6020700pjr.2.2022.07.01.02.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:03:32 -0700 (PDT)
Message-ID: <e27e4f98-5f3f-6ad5-b612-163cb967fa8a@redhat.com>
Date:   Fri, 1 Jul 2022 17:03:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 13/40] virtio_ring: split: reserve vring_align,
 may_reduce_num
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
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-14-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-14-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/6/29 14:56, Xuan Zhuo 写道:
> In vring_create_virtqueue_split() save vring_align, may_reduce_num to
> structure vring_virtqueue_split. Used to create a new vring when
> implementing resize .
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 4c8972da5423..9c83c5e6d5a9 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -105,6 +105,13 @@ struct vring_virtqueue_split {
>   	/* DMA address and size information */
>   	dma_addr_t queue_dma_addr;
>   	size_t queue_size_in_bytes;
> +
> +	/*
> +	 * The parameters for creating vrings are reserved for creating new
> +	 * vring.
> +	 */
> +	u32 vring_align;
> +	bool may_reduce_num;
>   };
>   
>   struct vring_virtqueue_packed {
> @@ -1098,6 +1105,8 @@ static struct virtqueue *vring_create_virtqueue_split(
>   		return NULL;
>   	}
>   
> +	to_vvq(vq)->split.vring_align = vring_align;
> +	to_vvq(vq)->split.may_reduce_num = may_reduce_num;
>   	to_vvq(vq)->split.queue_dma_addr = vring.queue_dma_addr;
>   	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
>   	to_vvq(vq)->we_own_ring = true;

