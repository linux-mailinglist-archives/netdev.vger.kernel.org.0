Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861BE56306A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiGAJjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbiGAJjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:39:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A885C42ED6
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656668390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1d79Stpus0q2yxaNU7MJkY6xfoyQBkCSEyRGquJaFl4=;
        b=Jjs7+iDfQTV9H9OOI6ArA2W59gJHqcpJNxNrK/Wn+58RDSrSaYho2TfU1w0V3iOlQT8X1j
        GeJbu114UDr4Dno2lmwrxyEuYDceOUn8O56S0IlDsa5PWJ6i+HZv6/fI/Zp3eQ24LCrUjA
        g+I6UMRkXzYstwz30XseA4eQuVa8an8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-zWI5VgzhOp6zCWBjv5aRgA-1; Fri, 01 Jul 2022 05:39:50 -0400
X-MC-Unique: zWI5VgzhOp6zCWBjv5aRgA-1
Received: by mail-pl1-f198.google.com with SMTP id l6-20020a170902f68600b0016a36fb2c9aso1219801plg.2
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1d79Stpus0q2yxaNU7MJkY6xfoyQBkCSEyRGquJaFl4=;
        b=0qqEVAP7uG/QKiS9A/AP0xS9meHNkt7IGEkx7h3qYTKH/ztUpt2SPjru3dFzRDu5G0
         H3PTk/SvoPcL4YQiJR+qKuM789UzOasZlcB/q0xLj/XGJOeYIrBM5HGeznD9K3fWKXqv
         zuLXlOnbQDZV66faDFPyYCVIIjEIKIY8I4PvY8MMD+PHXeCQzawCGEYLF6+DQO8DfYw3
         8qNJwTyMLmDahmTkuXVsrako1sxmSez1RfsLHGc5PPPopMsFDtUCYDpkRe8AWSw6Zejm
         5KSIMqk+cFroCXFwpY4eA/SRoyDuHIdD3IeF1ONqF3JN3LUx6tqMOZ2/mwFykUiMWBiu
         TT9Q==
X-Gm-Message-State: AJIora9J2rOKU42+DCXhparbif1puZhSGGBYa5HlzGgiPLqbStvGVGG4
        taS6x3bZjFF5u6CyI9AHJfODHkn3aoy06XXd+fFOVvl6bFqmMPBoqVPEe7hVsWuL3ngc4XTDXt8
        G6nF4BlsU17Mhhovn
X-Received: by 2002:a63:454a:0:b0:411:bbff:b079 with SMTP id u10-20020a63454a000000b00411bbffb079mr4669480pgk.507.1656668387171;
        Fri, 01 Jul 2022 02:39:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uQXl0Mg32c6PANnbBYsi+TCYur6T2X1Z6vqtoZHDXDxtmKbFKHms2mPc6lxJgdRzWP3sExWg==
X-Received: by 2002:a63:454a:0:b0:411:bbff:b079 with SMTP id u10-20020a63454a000000b00411bbffb079mr4669428pgk.507.1656668386921;
        Fri, 01 Jul 2022 02:39:46 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jy18-20020a17090b325200b001e31803540fsm6079692pjb.6.2022.07.01.02.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:39:46 -0700 (PDT)
Message-ID: <494bcf3f-d42c-f05b-cbdb-d4ba834bd118@redhat.com>
Date:   Fri, 1 Jul 2022 17:39:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 28/40] virtio_pci: introduce helper to get/set queue
 reset
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
 <20220629065656.54420-29-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-29-xuanzhuo@linux.alibaba.com>
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
> Introduce new helpers to implement queue reset and get queue reset
> status.
>
>   https://github.com/oasis-tcs/virtio-spec/issues/124
>   https://github.com/oasis-tcs/virtio-spec/issues/139
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_pci_modern_dev.c | 35 ++++++++++++++++++++++++++
>   include/linux/virtio_pci_modern.h      |  2 ++
>   2 files changed, 37 insertions(+)
>
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index fa2a9445bb18..07415654247c 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -3,6 +3,7 @@
>   #include <linux/virtio_pci_modern.h>
>   #include <linux/module.h>
>   #include <linux/pci.h>
> +#include <linux/delay.h>
>   
>   /*
>    * vp_modern_map_capability - map a part of virtio pci capability
> @@ -474,6 +475,40 @@ void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
>   }
>   EXPORT_SYMBOL_GPL(vp_modern_set_status);
>   
> +/*
> + * vp_modern_get_queue_reset - get the queue reset status
> + * @mdev: the modern virtio-pci device
> + * @index: queue index
> + */
> +int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
> +
> +	vp_iowrite16(index, &cfg->queue_select);
> +	return vp_ioread16(&cfg->queue_reset);
> +}
> +EXPORT_SYMBOL_GPL(vp_modern_get_queue_reset);
> +
> +/*
> + * vp_modern_set_queue_reset - reset the queue
> + * @mdev: the modern virtio-pci device
> + * @index: queue index
> + */
> +void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
> +
> +	vp_iowrite16(index, &cfg->queue_select);
> +	vp_iowrite16(1, &cfg->queue_reset);
> +
> +	while (vp_ioread16(&cfg->queue_reset))
> +		msleep(1);
> +
> +	while (vp_ioread16(&cfg->queue_enable))
> +		msleep(1);
> +}
> +EXPORT_SYMBOL_GPL(vp_modern_set_queue_reset);
> +
>   /*
>    * vp_modern_queue_vector - set the MSIX vector for a specific virtqueue
>    * @mdev: the modern virtio-pci device
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index beebc7a4a31d..ded01157f864 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -134,4 +134,6 @@ void __iomem * vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
>   				       u16 index, resource_size_t *pa);
>   int vp_modern_probe(struct virtio_pci_modern_device *mdev);
>   void vp_modern_remove(struct virtio_pci_modern_device *mdev);
> +int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
> +void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
>   #endif

