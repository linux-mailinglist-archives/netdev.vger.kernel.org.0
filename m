Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5919757C72F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiGUJO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiGUJO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31F32402C4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658394864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppSpnW8bYqIzLlwJTJe7LMpqbChLBLEyuLzj0jwDOCg=;
        b=VEsIW9UG0RAFm0+Cpb6g4Up5yJk2fw5OXClI+Qq38VR8kXTeZtDqWJnab2lnGYSQJl/xMb
        NLXpSHIL3G28Z9+j7GCpjkaAKj0+ZhQ9wZYAQU3xijqLG6mUR48Ya3WQLV3cTwlD/nRjzf
        owSAS0web1ILpP11FEs0eTtH4uZCCpQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-I-KDCnqVMx20meQMsz4bYg-1; Thu, 21 Jul 2022 05:14:22 -0400
X-MC-Unique: I-KDCnqVMx20meQMsz4bYg-1
Received: by mail-pf1-f198.google.com with SMTP id bq15-20020a056a000e0f00b0052af07b6c6bso615752pfb.21
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ppSpnW8bYqIzLlwJTJe7LMpqbChLBLEyuLzj0jwDOCg=;
        b=UNVAFExLafgBb5Dt227s1VZL6JnjN+Qpq+5Rm2vImpAy/PtyXb675MDcdKXb++xh1s
         gXH8CO5q9a3/MQwFYBzzfukaQa/KMzXISZiEnf8HiF89hf95Ea9sJiKR9ihXxVHgZBK0
         LnBKlrnaRg6qoQwPkT9lBpskuZBW2CJByiP9cjagBY7vaX0cLjQPo5lxccugdwsPbh3y
         p4ZZGbN1MCxIazCKXk8/9b2NFqVCWNZqGodGOmbbdw7IjwQa9Bi5P0Xm7UBlIFLt/muf
         C5yOFxARM+EuGnORsysSe//qjSFYx9vEVjRNggt9Vp94j3PQRfVyWzQsZCEmXkS3W9n4
         +SxA==
X-Gm-Message-State: AJIora82WhRCVAVKsCvlFFt2W3gEGNsT99bc/tSwBZa7PqN95Qz+ZV9u
        1TbyLpl4gqHbLLif3xbO0oxnzjLkupx3Yl5jl5FYss+f57F5nrempWsG46Cr/dBqj105bdyiLQt
        ueZ0E8PQP32SQAIDf
X-Received: by 2002:a17:902:ab0e:b0:16d:e87:ce8d with SMTP id ik14-20020a170902ab0e00b0016d0e87ce8dmr12288659plb.53.1658394861560;
        Thu, 21 Jul 2022 02:14:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tdQQvXxoAsILo5kGUhAyFtFd7+hyXAVcy5eO+xsnDpHiLynC44NTrLJew4cMcMMUejlOtfhg==
X-Received: by 2002:a17:902:ab0e:b0:16d:e87:ce8d with SMTP id ik14-20020a170902ab0e00b0016d0e87ce8dmr12288621plb.53.1658394861264;
        Thu, 21 Jul 2022 02:14:21 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l4-20020a170903244400b0016c454598b5sm1116942pls.167.2022.07.21.02.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:14:20 -0700 (PDT)
Message-ID: <da5ddf3b-3db7-7f25-a0f6-63a39e6af2a2@redhat.com>
Date:   Thu, 21 Jul 2022 17:14:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 24/40] virtio: allow to unbreak/break virtqueue
 individually
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
 <20220720030436.79520-25-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-25-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> This patch allows the new introduced
> __virtqueue_break()/__virtqueue_unbreak() to break/unbreak the
> virtqueue.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 24 ++++++++++++++++++++++++
>   include/linux/virtio.h       |  3 +++
>   2 files changed, 27 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index cf4379175163..bf666dad9904 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2730,6 +2730,30 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *_vq)
>   }
>   EXPORT_SYMBOL_GPL(virtqueue_get_vring_size);
>   
> +/*
> + * This function should only be called by the core, not directly by the driver.
> + */
> +void __virtqueue_break(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
> +	WRITE_ONCE(vq->broken, true);
> +}
> +EXPORT_SYMBOL_GPL(__virtqueue_break);
> +
> +/*
> + * This function should only be called by the core, not directly by the driver.
> + */
> +void __virtqueue_unbreak(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
> +	WRITE_ONCE(vq->broken, false);
> +}
> +EXPORT_SYMBOL_GPL(__virtqueue_unbreak);
> +
>   bool virtqueue_is_broken(struct virtqueue *_vq)
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 62e31bca5602..d45ee82a4470 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -138,6 +138,9 @@ bool is_virtio_device(struct device *dev);
>   void virtio_break_device(struct virtio_device *dev);
>   void __virtio_unbreak_device(struct virtio_device *dev);
>   
> +void __virtqueue_break(struct virtqueue *_vq);
> +void __virtqueue_unbreak(struct virtqueue *_vq);
> +
>   void virtio_config_changed(struct virtio_device *dev);
>   #ifdef CONFIG_PM_SLEEP
>   int virtio_device_freeze(struct virtio_device *dev);

