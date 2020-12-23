Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727232E1A15
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgLWIic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:38:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728143AbgLWIib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:38:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608712625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3qFyz9h7VZheiEP40gklGEtshCv6pLXIEhugrg/rlew=;
        b=GQJssyank7yX/7ltj6rJImq1YeeBCJLip6Df9NzQyrTtmhsPPoRxlxXBurh0JKweax9vE+
        Tp8M+79M8xmnlAVMhq1I7rj8/YGw1pMwTIOTdJeMMlowPzg+makapkJxIv5dPmZGWOS21j
        kfFk+GV5D+Y7pBKLy/INUApFD/BTgdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-Pbr5_DBoMqGoFC2SlLc90Q-1; Wed, 23 Dec 2020 03:37:02 -0500
X-MC-Unique: Pbr5_DBoMqGoFC2SlLc90Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 893CD180A096;
        Wed, 23 Dec 2020 08:37:00 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCDED60C6A;
        Wed, 23 Dec 2020 08:36:48 +0000 (UTC)
Subject: Re: [RFC v2 08/13] vdpa: Introduce process_iotlb_msg() in
 vdpa_config_ops
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        akpm@linux-foundation.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-9-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5b36bc51-1e19-2b59-6287-66aed435c8ed@redhat.com>
Date:   Wed, 23 Dec 2020 16:36:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201222145221.711-9-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/22 下午10:52, Xie Yongji wrote:
> This patch introduces a new method in the vdpa_config_ops to
> support processing the raw vhost memory mapping message in the
> vDPA device driver.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vhost/vdpa.c | 5 ++++-
>   include/linux/vdpa.h | 7 +++++++
>   2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 448be7875b6d..ccbb391e38be 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -728,6 +728,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   	if (r)
>   		return r;
>   
> +	if (ops->process_iotlb_msg)
> +		return ops->process_iotlb_msg(vdpa, msg);
> +
>   	switch (msg->type) {
>   	case VHOST_IOTLB_UPDATE:
>   		r = vhost_vdpa_process_iotlb_update(v, msg);
> @@ -770,7 +773,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>   	int ret;
>   
>   	/* Device want to do DMA by itself */
> -	if (ops->set_map || ops->dma_map)
> +	if (ops->set_map || ops->dma_map || ops->process_iotlb_msg)
>   		return 0;
>   
>   	bus = dma_dev->bus;
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 656fe264234e..7bccedf22f4b 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -5,6 +5,7 @@
>   #include <linux/kernel.h>
>   #include <linux/device.h>
>   #include <linux/interrupt.h>
> +#include <linux/vhost_types.h>
>   #include <linux/vhost_iotlb.h>
>   #include <net/genetlink.h>
>   
> @@ -172,6 +173,10 @@ struct vdpa_iova_range {
>    *				@vdev: vdpa device
>    *				Returns the iova range supported by
>    *				the device.
> + * @process_iotlb_msg:		Process vhost memory mapping message (optional)
> + *				Only used for VDUSE device now
> + *				@vdev: vdpa device
> + *				@msg: vhost memory mapping message
>    * @set_map:			Set device memory mapping (optional)
>    *				Needed for device that using device
>    *				specific DMA translation (on-chip IOMMU)
> @@ -240,6 +245,8 @@ struct vdpa_config_ops {
>   	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>   
>   	/* DMA ops */
> +	int (*process_iotlb_msg)(struct vdpa_device *vdev,
> +				 struct vhost_iotlb_msg *msg);
>   	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
>   	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
>   		       u64 pa, u32 perm);


Is there any reason that it can't be done via dma_map/dma_unmap or set_map?

Thanks


