Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68AC2304B1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgG1Hxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:53:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43110 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgG1Hxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595922809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SpGirkBctXwJWEHbPAg/cQrnslbOJaO9rpYq2tSoDpk=;
        b=h05D77Y0AgvpidD0qaycTgImlbfw+eFQK7V/gaLWmJ9c7X75dEzsRBRjTA3GD85ifQ4KS1
        Ij15UfBmM2cRuyppxbx815hhsNWsdhZOroKs91oSVUIyIyKYfy82GZ2NP3VIsRLCUNGeum
        GZlV9i8JIyqEsYhNhlNGV/Z6qgiDebM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-dZoHkNqJPP6wKPerf9-rfQ-1; Tue, 28 Jul 2020 03:53:27 -0400
X-MC-Unique: dZoHkNqJPP6wKPerf9-rfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1460018C63C0;
        Tue, 28 Jul 2020 07:53:26 +0000 (UTC)
Received: from [10.72.13.242] (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59977619C4;
        Tue, 28 Jul 2020 07:53:13 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <10dd83c0-f68a-ed9e-9860-45c215fc67f6@redhat.com>
Date:   Tue, 28 Jul 2020 15:53:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728042405.17579-5-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/28 下午12:24, Zhu Lingshan wrote:
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
> index df3cf386b0cd..1dccced321f8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -115,6 +115,55 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
>   	return IRQ_HANDLED;
>   }
>   
> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
> +{
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +	const struct vdpa_config_ops *ops = v->vdpa->config;
> +	struct vdpa_device *vdpa = v->vdpa;
> +	int ret, irq;
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq = ops->get_vq_irq(vdpa, qid);
> +	if (!vq->call_ctx.ctx || irq == -EINVAL) {


It's better to check returned irq as "irq < 0" to be more robust. 
Forcing a specific errno value is not good.


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
> +static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, int qid)
> +{
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);
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
> +	int i, nvqs;
>   
>   	if (copy_from_user(&status, statusp, sizeof(status)))
>   		return -EFAULT;
>   
> +	status_old = ops->get_status(vdpa);
> +	nvqs = v->nvqs;
> +
>   	/*
>   	 * Userspace shouldn't remove status bits unless reset the
>   	 * status to 0.
> @@ -167,6 +220,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>   	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
>   		return -EINVAL;
>   
> +	/* vq irq is not expected to be changed once DRIVER_OK is set */


So this basically limit the usage of get_vq_irq() in the context 
vhost_vdpa_set_status() and other vDPA bus drivers' set_status(). If 
this is true, there's even no need to introduce any new config ops but 
just let set_status() to return the irqs used for the device. Or if we 
want this to be more generic, we need vpda's own irq manager (which 
should be similar to irq bypass manager). That is:

- bus driver can register itself as consumer
- vDPA device driver can register itself as producer
- matching via queue index
- deal with registering/unregistering of consumer/producer

So there's no need to care when or where the vDPA device driver to 
allocate the irq, and we don't need to care at which context the vDPA 
bus driver can use the irq. Either side may get notified when the other 
side is gone (though we only care about the gone of producer probably).

Any thought on this?

Thanks


> +	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
> +		for (i = 0; i < nvqs; i++)
> +			vhost_vdpa_setup_vq_irq(v, i);
> +
> +	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		for (i = 0; i < nvqs; i++)
> +			vhost_vdpa_unsetup_vq_irq(v, i);
> +
>   	ops->set_status(vdpa, status);
>   
>   	return 0;
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

