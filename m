Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A504D7A9A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 07:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiCNGEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 02:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiCNGEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 02:04:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5628EE0AB
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 23:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647237808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+bVeXSAPAIyLEMvADgvGsIj3wikzII/B9d4vv1jFOjU=;
        b=GvIMzyYfR2BWKuKRWlta4wpiqOx7VkglSjdUzV0dschE37M4812GxhEVTMtG3Mnte08F/x
        rHvP3MnQQwyU7TosVTrgO9f3LNZ9kcVPGCMZuknlc+pKp7hhd+7GHXVuF4AGYOzZvK5/P4
        sm98ZQl5ij7AItbsvBdn4Lbe/DtUE2c=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-neawr7GIMdWjsMVe18JXOw-1; Mon, 14 Mar 2022 02:03:26 -0400
X-MC-Unique: neawr7GIMdWjsMVe18JXOw-1
Received: by mail-pl1-f199.google.com with SMTP id b4-20020a170902e94400b0015309b5c481so5292983pll.6
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 23:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+bVeXSAPAIyLEMvADgvGsIj3wikzII/B9d4vv1jFOjU=;
        b=xCu+7bcxqVpknJt6RX7vazWdJ65WGydaUfuhZhyuQJH04ocKt4IbuNKvhGC9xVqO1t
         stoVurZ6abOuZIhXmkrrKQ7WKRAbP05iWG6fAkf7j6NQok+ANmm5u7Jn72lhTs8Uh69L
         bCabk2+v04mViEPDp8q+9NblRvuHEI+cCikHLDxrZG0ENPggYrmZiSRWD7c6q60ILDQH
         37q7gXfo2Maf6F/g66yqcbg/E7I3shpB2DHJ9nxlFHZtdPGef6MoE3az/M3fjUJ4YFtD
         n6tzU3yrw31gzYh/Ojt9Z1hMX/iuOqK3BDq3dRY5C1G9coVgKH2Ww/pT0Hh9CiJ9VKQY
         BTuw==
X-Gm-Message-State: AOAM532S5DxfK8bSYMxT/SoFCw3Y50VdPxN/7myzaeHeA9XTjRfngg+x
        d0To5qGFWajLMAOTFXAkjbQvo5GFAZrxQa5Fv6U4mXC4xfSVaBuNMnPh6MOU8kFLthsRKRQ7Udh
        e5ars62inN+3zgIDC
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id q13-20020a17090a430d00b001bcf3408096mr23310100pjg.93.1647237805716;
        Sun, 13 Mar 2022 23:03:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHJLlKsy+iGZWFfSSZs5522fWpCLPCuJ5+r/iAxz9GOr2pZgULqn0VLRevvecGY0GD+eDtZQ==
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id q13-20020a17090a430d00b001bcf3408096mr23310068pjg.93.1647237805387;
        Sun, 13 Mar 2022 23:03:25 -0700 (PDT)
Received: from [10.72.13.210] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm19777664pju.15.2022.03.13.23.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 23:03:24 -0700 (PDT)
Message-ID: <dc92c90e-fbb6-dc60-a73b-5415c40cbf5b@redhat.com>
Date:   Mon, 14 Mar 2022 14:03:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v2 1/2] vdpa: support exposing the config size to
 userspace
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com, gdawar@xilinx.com
References: <20220310072051.2175-1-longpeng2@huawei.com>
 <20220310072051.2175-2-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220310072051.2175-2-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/10 下午3:20, Longpeng(Mike) 写道:
> From: Longpeng <longpeng2@huawei.com>
>
> - GET_CONFIG_SIZE: return the size of the virtio config space.
>
> The size contains the fields which are conditional on feature
> bits.
>
> Signed-off-by: Longpeng <longpeng2@huawei.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c       | 17 +++++++++++++++++
>   include/linux/vdpa.h       |  3 ++-
>   include/uapi/linux/vhost.h |  4 ++++
>   3 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec5249e..605c7ae 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -355,6 +355,20 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
>   	return 0;
>   }
>   
> +static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +	u32 size;
> +
> +	size = ops->get_config_size(vdpa);
> +
> +	if (copy_to_user(argp, &size, sizeof(size)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -492,6 +506,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   	case VHOST_VDPA_GET_IOVA_RANGE:
>   		r = vhost_vdpa_get_iova_range(v, argp);
>   		break;
> +	case VHOST_VDPA_GET_CONFIG_SIZE:
> +		r = vhost_vdpa_get_config_size(v, argp);
> +		break;
>   	default:
>   		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>   		if (r == -ENOIOCTLCMD)
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 721089b..a526919 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -207,7 +207,8 @@ struct vdpa_map_file {
>    * @reset:			Reset device
>    *				@vdev: vdpa device
>    *				Returns integer: success (0) or error (< 0)
> - * @get_config_size:		Get the size of the configuration space
> + * @get_config_size:		Get the size of the configuration space includes
> + *				fields that are conditional on feature bits.
>    *				@vdev: vdpa device
>    *				Returns size_t: configuration size
>    * @get_config:			Read from device specific configuration space
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860..bc74e95 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -150,4 +150,8 @@
>   /* Get the valid iova range */
>   #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
>   					     struct vhost_vdpa_iova_range)
> +
> +/* Get the config size */
> +#define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
> +
>   #endif

