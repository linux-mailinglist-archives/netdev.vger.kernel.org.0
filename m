Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5432CD49
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 08:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhCDHBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 02:01:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232362AbhCDHBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 02:01:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614841196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GWD3fPcp3FG/R9bDKdREFBmnHOESW2KvfRo/SFt+d/o=;
        b=iAn7SF9gMu1Er8WMsbZ92lj0LsU1WoTgxKDnlcA0xtseiV4ciDukel57ATPTPX2Yv27Mg0
        tPZOQY9UsbFRlwNxJ8nTHEv/baBiZB4BzQ5j39p9ioPXHgjK9r49MzNFUFBsom3O0douxk
        14Wqs0aKRoMvPBavmYsWHKzk1dS8gos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-OYQPMdC5Niqx3OoRkA14Ew-1; Thu, 04 Mar 2021 01:59:55 -0500
X-MC-Unique: OYQPMdC5Niqx3OoRkA14Ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A090657;
        Thu,  4 Mar 2021 06:59:52 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-113.pek2.redhat.com [10.72.12.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F28B16268E;
        Thu,  4 Mar 2021 06:59:40 +0000 (UTC)
Subject: Re: [RFC v4 10/11] vduse: Introduce a workqueue for irq injection
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-11-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com>
Date:   Thu, 4 Mar 2021 14:59:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-11-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> This patch introduces a workqueue to support injecting
> virtqueue's interrupt asynchronously. This is mainly
> for performance considerations which makes sure the push()
> and pop() for used vring can be asynchronous.


Do you have pref numbers for this patch?

Thanks


>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vdpa/vdpa_user/vduse_dev.c | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index 8042d3fa57f1..f5adeb9ee027 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -42,6 +42,7 @@ struct vduse_virtqueue {
>   	spinlock_t irq_lock;
>   	struct eventfd_ctx *kickfd;
>   	struct vdpa_callback cb;
> +	struct work_struct inject;
>   };
>   
>   struct vduse_dev;
> @@ -99,6 +100,7 @@ static DEFINE_IDA(vduse_ida);
>   
>   static dev_t vduse_major;
>   static struct class *vduse_class;
> +static struct workqueue_struct *vduse_irq_wq;
>   
>   static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa)
>   {
> @@ -852,6 +854,17 @@ static int vduse_kickfd_setup(struct vduse_dev *dev,
>   	return 0;
>   }
>   
> +static void vduse_vq_irq_inject(struct work_struct *work)
> +{
> +	struct vduse_virtqueue *vq = container_of(work,
> +					struct vduse_virtqueue, inject);
> +
> +	spin_lock_irq(&vq->irq_lock);
> +	if (vq->ready && vq->cb.callback)
> +		vq->cb.callback(vq->cb.private);
> +	spin_unlock_irq(&vq->irq_lock);
> +}
> +
>   static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>   			unsigned long arg)
>   {
> @@ -917,12 +930,7 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>   			break;
>   
>   		vq = &dev->vqs[arg];
> -		spin_lock_irq(&vq->irq_lock);
> -		if (vq->ready && vq->cb.callback) {
> -			vq->cb.callback(vq->cb.private);
> -			ret = 0;
> -		}
> -		spin_unlock_irq(&vq->irq_lock);
> +		queue_work(vduse_irq_wq, &vq->inject);
>   		break;
>   	}
>   	case VDUSE_INJECT_CONFIG_IRQ:
> @@ -1109,6 +1117,7 @@ static int vduse_create_dev(struct vduse_dev_config *config)
>   
>   	for (i = 0; i < dev->vq_num; i++) {
>   		dev->vqs[i].index = i;
> +		INIT_WORK(&dev->vqs[i].inject, vduse_vq_irq_inject);
>   		spin_lock_init(&dev->vqs[i].kick_lock);
>   		spin_lock_init(&dev->vqs[i].irq_lock);
>   	}
> @@ -1333,6 +1342,11 @@ static int vduse_init(void)
>   	if (ret)
>   		goto err_chardev;
>   
> +	vduse_irq_wq = alloc_workqueue("vduse-irq",
> +				WQ_HIGHPRI | WQ_SYSFS | WQ_UNBOUND, 0);
> +	if (!vduse_irq_wq)
> +		goto err_wq;
> +
>   	ret = vduse_domain_init();
>   	if (ret)
>   		goto err_domain;
> @@ -1344,6 +1358,8 @@ static int vduse_init(void)
>   	return 0;
>   err_mgmtdev:
>   	vduse_domain_exit();
> +err_wq:
> +	destroy_workqueue(vduse_irq_wq);
>   err_domain:
>   	unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
>   err_chardev:
> @@ -1359,6 +1375,7 @@ static void vduse_exit(void)
>   	misc_deregister(&vduse_misc);
>   	class_destroy(vduse_class);
>   	unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
> +	destroy_workqueue(vduse_irq_wq);
>   	vduse_domain_exit();
>   	vduse_mgmtdev_exit();
>   }

