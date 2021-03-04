Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4C32CDA0
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 08:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhCDHcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 02:32:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhCDHcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 02:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614843053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c7/0tXgFX+Nemc6SQyJg+VG+4lWEi4mRvofkLtSVT7s=;
        b=DfsYhflaMIiMPIdZej1m0z0cym/KduvjTiRtSjrn/FNLd9xbjVWRom2NCL55KZfGxhtFig
        Yc1M8wRmIsFeFOOaeG17vSNgDZMS/+oHwrtjtrujxTMhIOONVrIDRycA1Odp/JePj/WrZw
        ZqqBeqJKiqfyq9BxYGfXfKrgH7A91fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-5Fli40RVOiqTeqVxlv819A-1; Thu, 04 Mar 2021 02:30:51 -0500
X-MC-Unique: 5Fli40RVOiqTeqVxlv819A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15EB7107ACE6;
        Thu,  4 Mar 2021 07:30:49 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB85960CCD;
        Thu,  4 Mar 2021 07:30:35 +0000 (UTC)
Subject: Re: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-12-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com>
Date:   Thu, 4 Mar 2021 15:30:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-12-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
> injecting virtqueue's interrupt to the specified cpu.


How userspace know which CPU is this irq for? It looks to me we need to 
do it at different level.

E.g introduce some API in sys to allow admin to tune for that.

But I think we can do that in antoher patch on top of this series.

Thanks


>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vdpa/vdpa_user/vduse_dev.c | 22 +++++++++++++++++-----
>   include/uapi/linux/vduse.h         |  7 ++++++-
>   2 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index f5adeb9ee027..df3d467fff40 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -923,14 +923,27 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>   		break;
>   	}
>   	case VDUSE_INJECT_VQ_IRQ: {
> +		struct vduse_vq_irq irq;
>   		struct vduse_virtqueue *vq;
>   
> +		ret = -EFAULT;
> +		if (copy_from_user(&irq, argp, sizeof(irq)))
> +			break;
> +
>   		ret = -EINVAL;
> -		if (arg >= dev->vq_num)
> +		if (irq.index >= dev->vq_num)
> +			break;
> +
> +		if (irq.cpu != -1 && (irq.cpu >= nr_cpu_ids ||
> +		    !cpu_online(irq.cpu)))
>   			break;
>   
> -		vq = &dev->vqs[arg];
> -		queue_work(vduse_irq_wq, &vq->inject);
> +		ret = 0;
> +		vq = &dev->vqs[irq.index];
> +		if (irq.cpu == -1)
> +			queue_work(vduse_irq_wq, &vq->inject);
> +		else
> +			queue_work_on(irq.cpu, vduse_irq_wq, &vq->inject);
>   		break;
>   	}
>   	case VDUSE_INJECT_CONFIG_IRQ:
> @@ -1342,8 +1355,7 @@ static int vduse_init(void)
>   	if (ret)
>   		goto err_chardev;
>   
> -	vduse_irq_wq = alloc_workqueue("vduse-irq",
> -				WQ_HIGHPRI | WQ_SYSFS | WQ_UNBOUND, 0);
> +	vduse_irq_wq = alloc_workqueue("vduse-irq", WQ_HIGHPRI, 0);
>   	if (!vduse_irq_wq)
>   		goto err_wq;
>   
> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> index 9070cd512cb4..9c70fd842ce5 100644
> --- a/include/uapi/linux/vduse.h
> +++ b/include/uapi/linux/vduse.h
> @@ -116,6 +116,11 @@ struct vduse_vq_eventfd {
>   	int fd; /* eventfd, -1 means de-assigning the eventfd */
>   };
>   
> +struct vduse_vq_irq {
> +	__u32 index; /* virtqueue index */
> +	int cpu; /* bind irq to the specified cpu, -1 means running on the current cpu */
> +};
> +
>   #define VDUSE_BASE	0x81
>   
>   /* Create a vduse device which is represented by a char device (/dev/vduse/<name>) */
> @@ -131,7 +136,7 @@ struct vduse_vq_eventfd {
>   #define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x04, struct vduse_vq_eventfd)
>   
>   /* Inject an interrupt for specific virtqueue */
> -#define VDUSE_INJECT_VQ_IRQ	_IO(VDUSE_BASE, 0x05)
> +#define VDUSE_INJECT_VQ_IRQ	_IOW(VDUSE_BASE, 0x05, struct vduse_vq_irq)
>   
>   /* Inject a config interrupt */
>   #define VDUSE_INJECT_CONFIG_IRQ	_IO(VDUSE_BASE, 0x06)

