Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84F23B712
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 10:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgHDIwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 04:52:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41314 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729936AbgHDIwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 04:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596531132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqjEJLolPmGHNe5yaOt/yfSsQ1bGdkSL/AwXQ/PFIg4=;
        b=FKGndC5zDHxI1Vgu8IADbk9pJWHdyQ+hHHBTUCMQAdp6GCNeyiwpwxjT6f/0RqQZzEoysS
        FjlUdB97t76kd/JJKgL9MpEN2AYCArDUl4JsHKYe8lXCwy9p6xB8V6lZwUWHyiMhXCIJ6M
        PQIyx/KvOA4Ml21RZt7tCjvGubZoJQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-OEkxtpFKOnqa8QMMyG6L9w-1; Tue, 04 Aug 2020 04:52:10 -0400
X-MC-Unique: OEkxtpFKOnqa8QMMyG6L9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEA7E8014D7;
        Tue,  4 Aug 2020 08:52:08 +0000 (UTC)
Received: from [10.72.13.197] (ovpn-13-197.pek2.redhat.com [10.72.13.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 966FF5C5B7;
        Tue,  4 Aug 2020 08:51:45 +0000 (UTC)
Subject: Re: [PATCH V5 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5212669d-6e7b-21cb-6e25-1837d70624b2@redhat.com>
Date:   Tue, 4 Aug 2020 16:51:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731065533.4144-5-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/31 下午2:55, Zhu Lingshan wrote:
> This patch introduce a set of functions for setup/unsetup
> and update irq offloading respectively by register/unregister
> and re-register the irq_bypass_producer.
>
> With these functions, this commit can setup/unsetup
> irq offloading through setting DRIVER_OK/!DRIVER_OK, and
> update irq offloading through SET_VRING_CALL.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/Kconfig |  1 +
>   drivers/vhost/vdpa.c  | 79 ++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 79 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index d3688c6afb87..587fbae06182 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -65,6 +65,7 @@ config VHOST_VDPA
>   	tristate "Vhost driver for vDPA-based backend"
>   	depends on EVENTFD
>   	select VHOST
> +	select IRQ_BYPASS_MANAGER
>   	depends on VDPA
>   	help
>   	  This kernel module can be loaded in host kernel to accelerate
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index df3cf386b0cd..278ea2f00172 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -115,6 +115,55 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
>   	return IRQ_HANDLED;
>   }
>   
> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
> +{
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +	const struct vdpa_config_ops *ops = v->vdpa->config;
> +	struct vdpa_device *vdpa = v->vdpa;
> +	int ret, irq;
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq = ops->get_vq_irq(vdpa, qid);
> +	if (!vq->call_ctx.ctx || irq < 0) {
> +		spin_unlock(&vq->call_ctx.ctx_lock);
> +		return;
> +	}
> +
> +	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +	vq->call_ctx.producer.irq = irq;
> +	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> +	spin_unlock(&vq->call_ctx.ctx_lock);
> +}
> +
> +static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
> +{
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);


Any reason for not checking vq->call_ctx.producer.irq as below here?


> +	spin_unlock(&vq->call_ctx.ctx_lock);
> +}
> +
> +static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
> +{
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	/*
> +	 * if it has a non-zero irq, means there is a
> +	 * previsouly registered irq_bypass_producer,
> +	 * we should update it when ctx (its token)
> +	 * changes.
> +	 */
> +	if (!vq->call_ctx.producer.irq) {
> +		spin_unlock(&vq->call_ctx.ctx_lock);
> +		return;
> +	}
> +
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +	irq_bypass_register_producer(&vq->call_ctx.producer);
> +	spin_unlock(&vq->call_ctx.ctx_lock);
> +}


I think setup_irq() and update_irq() could be unified with the following 
logic:

irq_bypass_unregister_producer(&vq->call_ctx.producer);
irq = ops->get_vq_irq(vdpa, qid);
     if (!vq->call_ctx.ctx || irq < 0) {
         spin_unlock(&vq->call_ctx.ctx_lock);
         return;
     }

vq->call_ctx.producer.token = vq->call_ctx.ctx;
vq->call_ctx.producer.irq = irq;
ret = irq_bypass_register_producer(&vq->call_ctx.producer);

> +
>   static void vhost_vdpa_reset(struct vhost_vdpa *v)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
> @@ -155,11 +204,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
>   	const struct vdpa_config_ops *ops = vdpa->config;
> -	u8 status;
> +	u8 status, status_old;
> +	int nvqs = v->nvqs;
> +	u16 i;
>   
>   	if (copy_from_user(&status, statusp, sizeof(status)))
>   		return -EFAULT;
>   
> +	status_old = ops->get_status(vdpa);
> +
>   	/*
>   	 * Userspace shouldn't remove status bits unless reset the
>   	 * status to 0.
> @@ -169,6 +222,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   
>   	ops->set_status(vdpa, status);
>   
> +	/* vq irq is not expected to be changed once DRIVER_OK is set */


Let's move this comment to the get_vq_irq bus operation.


> +	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
> +		for (i = 0; i < nvqs; i++)
> +			vhost_vdpa_setup_vq_irq(v, i);
> +
> +	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		for (i = 0; i < nvqs; i++)
> +			vhost_vdpa_unsetup_vq_irq(v, i);
> +
>   	return 0;
>   }
>   
> @@ -332,6 +394,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
>   
>   	return 0;
>   }
> +
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -390,6 +453,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   			cb.private = NULL;
>   		}
>   		ops->set_vq_cb(vdpa, idx, &cb);
> +		vhost_vdpa_update_vq_irq(vq);
>   		break;
>   
>   	case VHOST_SET_VRING_NUM:
> @@ -765,6 +829,18 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>   	return r;
>   }
>   
> +static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
> +{
> +	struct vhost_virtqueue *vq;
> +	int i;
> +
> +	for (i = 0; i < v->nvqs; i++) {
> +		vq = &v->vqs[i];
> +		if (vq->call_ctx.producer.irq)
> +			irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +	}
> +}


Why not using vhost_vdpa_unsetup_vq_irq()?

Thanks


> +
>   static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>   {
>   	struct vhost_vdpa *v = filep->private_data;
> @@ -777,6 +853,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>   	vhost_vdpa_iotlb_free(v);
>   	vhost_vdpa_free_domain(v);
>   	vhost_vdpa_config_put(v);
> +	vhost_vdpa_clean_irq(v);
>   	vhost_dev_cleanup(&v->vdev);
>   	kfree(v->vdev.vqs);
>   	mutex_unlock(&d->mutex);

