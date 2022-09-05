Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C395ACE02
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbiIEIgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiIEIgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4BC13D36
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662366873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SGf0boq9ogkl73KjPD+WRhg7NzegvIYLMpx6ZLGwAI4=;
        b=Te2vAsyFpyfaMdVfuW9yX2NXsUZMg0BRN8jUhGVf/q257XUVE9kW8Ud6GNUL1duFk9jtnI
        nNxFTHW636CYJ6vUs9eYV+Ddiqk67wWZvglasNSTMzcAXtTsYu8vaSrUzvWaBMZJON2Imz
        ZnLbX38wX85KJus0it7nw4ZaH5BPJaY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-jwUu_bT1Or-G33g_lYACTA-1; Mon, 05 Sep 2022 04:34:32 -0400
X-MC-Unique: jwUu_bT1Or-G33g_lYACTA-1
Received: by mail-pl1-f199.google.com with SMTP id l16-20020a170902f69000b00175138bcd25so5706375plg.2
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 01:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SGf0boq9ogkl73KjPD+WRhg7NzegvIYLMpx6ZLGwAI4=;
        b=gEl/d+QT8Dwhd8dBi4UMtbVMoKp0oZACNk1UHzTNqHr7TETr9+sHckISnZaBX0I+51
         uRBq4hLWyIkuTuLrvtiaoLJdSs+PO8uc08UaYBOb5oZiq0awpoum/Yx00Ipdj4UKd80l
         BgHLuwZukg4qaXek6F1NPZJDCK4SPQuH8T/FJa+Rexxx3j1yYmczGanybbrVz5MJ7FL7
         e112pyFgvZaPCVS/TuKOEXX8+dsZMRqGPViO75dtlHdWnPuU3ZTAMdgsN7Uza3vterwk
         FbYrHG1coNqNv7czry1JLoZ+oOIPzAB979zRIcM4IU+eqAk8nqEGgDiKpOWr4aBrZUyY
         1usA==
X-Gm-Message-State: ACgBeo2u+4eGVzpT0jYEytuJUfLcKjRZBU4BhxHkm58DppizIxFb/Xca
        cgUJQF2I57EPNdP/ICPg7jwRZAr+Oez75m3QhqFk5kKjfwziQUM47Sk75IOFKOwBPcQA5GYzXEC
        hVq1lUoCwplIKAXpW
X-Received: by 2002:a63:2c43:0:b0:41c:66a6:4125 with SMTP id s64-20020a632c43000000b0041c66a64125mr41825329pgs.598.1662366870966;
        Mon, 05 Sep 2022 01:34:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7zWUs5WPIMt2WfASgKDey01sfXk2bK3RQOgfvc4viEMCIwYigfVAp1koWIYzRHl/tB8Rrg0A==
X-Received: by 2002:a63:2c43:0:b0:41c:66a6:4125 with SMTP id s64-20020a632c43000000b0041c66a64125mr41825315pgs.598.1662366870682;
        Mon, 05 Sep 2022 01:34:30 -0700 (PDT)
Received: from [10.72.13.239] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i69-20020a628748000000b0052e987c64efsm7308169pfe.174.2022.09.05.01.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 01:34:30 -0700 (PDT)
Message-ID: <04710aa1-5014-ff05-e961-a690490643bf@redhat.com>
Date:   Mon, 5 Sep 2022 16:34:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC 1/4] vDPA/ifcvf: add get/set_vq_endian support for vDPA
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220901101601.61420-1-lingshan.zhu@intel.com>
 <20220901101601.61420-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901101601.61420-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/1 18:15, Zhu Lingshan 写道:
> This commit introuduces new config operatoions for vDPA:
> vdpa_config_ops.get_vq_endian: set vq endian-ness
> vdpa_config_ops.set_vq_endian: get vq endian-ness
>
> Because the endian-ness is a device wide attribute,
> so seting a vq's endian-ness will result in changing
> the device endian-ness, including all vqs and the config space.
>
> These two operations are implemented in ifcvf in this commit.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c | 15 +++++++++++++++
>   include/linux/vdpa.h            | 13 +++++++++++++
>   3 files changed, 29 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index f5563f665cc6..640238b95033 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -19,6 +19,7 @@
>   #include <uapi/linux/virtio_blk.h>
>   #include <uapi/linux/virtio_config.h>
>   #include <uapi/linux/virtio_pci.h>
> +#include <uapi/linux/vhost.h>
>   
>   #define N3000_DEVICE_ID		0x1041
>   #define N3000_SUBSYS_DEVICE_ID	0x001A
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index f9c0044c6442..270637d0f3a5 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -684,6 +684,19 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
>   	return area;
>   }
>   
> +static u8 ifcvf_vdpa_get_vq_endian(struct vdpa_device *vdpa_dev, u16 idx)
> +{
> +	return VHOST_VRING_LITTLE_ENDIAN;
> +}
> +
> +static int ifcvf_vdpa_set_vq_endian(struct vdpa_device *vdpa_dev, u16 idx, u8 endian)
> +{
> +	if (endian != VHOST_VRING_LITTLE_ENDIAN)
> +		return -EFAULT;


I'm worrying that this basically make the proposed API not much useful.

For example, what would userspace do if it meet this failure?

Thanks


> +
> +	return 0;
> +}
> +
>   /*
>    * IFCVF currently doesn't have on-chip IOMMU, so not
>    * implemented set_map()/dma_map()/dma_unmap()
> @@ -715,6 +728,8 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.set_config	= ifcvf_vdpa_set_config,
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
>   	.get_vq_notification = ifcvf_get_vq_notification,
> +	.get_vq_endian	= ifcvf_vdpa_get_vq_endian,
> +	.set_vq_endian	= ifcvf_vdpa_set_vq_endian,
>   };
>   
>   static struct virtio_device_id id_table_net[] = {
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index d282f464d2f1..5eb83453ba86 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -174,6 +174,17 @@ struct vdpa_map_file {
>    *				@idx: virtqueue index
>    *				Returns int: irq number of a virtqueue,
>    *				negative number if no irq assigned.
> + * @set_vq_endian:		set endian-ness for a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				@endian: the endian-ness to set,
> + *				can be VHOST_VRING_LITTLE_ENDIAN or VHOST_VRING_BIG_ENDIAN
> + *				Returns integer: success (0) or error (< 0)
> + * @get_vq_endian:		get the endian-ness of a virtqueue
> + *				@vdev: vdpa device
> + *				@idx: virtqueue index
> + *				Returns u8, the endian-ness of the virtqueue,
> + *				can be VHOST_VRING_LITTLE_ENDIAN or VHOST_VRING_BIG_ENDIAN
>    * @get_vq_align:		Get the virtqueue align requirement
>    *				for the device
>    *				@vdev: vdpa device
> @@ -306,6 +317,8 @@ struct vdpa_config_ops {
>   	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
>   	/* vq irq is not expected to be changed once DRIVER_OK is set */
>   	int (*get_vq_irq)(struct vdpa_device *vdev, u16 idx);
> +	int (*set_vq_endian)(struct vdpa_device *vdev, u16 idx, u8 endian);
> +	u8 (*get_vq_endian)(struct vdpa_device *vdev, u16 idx);
>   
>   	/* Device ops */
>   	u32 (*get_vq_align)(struct vdpa_device *vdev);

