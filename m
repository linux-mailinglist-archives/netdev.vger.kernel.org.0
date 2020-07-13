Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133EF21D199
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgGMIWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:22:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32714 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbgGMIWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 04:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594628567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/+ZSrW+kUPY6oOBgBRDnn14Dz1y/Pxezt0ZYfjJHCg=;
        b=OaqF2iYcNnX6LjUQlImYs+s2wJcJca3XkKhORPYc1nIJ7GmbnJizEuUbNb0pURiS8HYQe2
        hYHWB/C+bPQ4NRLqhV8zhj/di1HqAcf14g+Mt2GW+ZNNxJUmH0ANBENRy6mdrT+h8wWpmZ
        guS7oAdiR0bGmY2mQwzVzQvbAKCTzeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-BFefOaafNHGv-gih_CJ7pw-1; Mon, 13 Jul 2020 04:22:46 -0400
X-MC-Unique: BFefOaafNHGv-gih_CJ7pw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96DBE107ACCA;
        Mon, 13 Jul 2020 08:22:44 +0000 (UTC)
Received: from [10.72.13.177] (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BB4C60C84;
        Mon, 13 Jul 2020 08:22:35 +0000 (UTC)
Subject: Re: [PATCH 3/7] vhost_vdpa: implement IRQ offloading functions in
 vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-3-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3fb9ecfc-a325-69b5-f5b7-476a5683a324@redhat.com>
Date:   Mon, 13 Jul 2020 16:22:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594565366-3195-3-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/12 下午10:49, Zhu Lingshan wrote:
> This patch introduce a set of functions for setup/unsetup
> and update irq offloading respectively by register/unregister
> and re-register the irq_bypass_producer.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vhost/vdpa.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 69 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 2fcc422..92683e4 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -115,6 +115,63 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
>   	return IRQ_HANDLED;
>   }
>   
> +static void vhost_vdpa_setup_vq_irq(struct vdpa_device *dev, int qid, int irq)
> +{
> +	struct vhost_vdpa *v = vdpa_get_drvdata(dev);
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +	int ret;
> +
> +	vq_err(vq, "setup irq bypass for vq %d with irq = %d\n", qid, irq);
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	if (!vq->call_ctx.ctx)
> +		return;
> +
> +	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +	vq->call_ctx.producer.irq = irq;
> +	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> +	spin_unlock(&vq->call_ctx.ctx_lock);
> +
> +	if (unlikely(ret))
> +		vq_err(vq,
> +		"irq bypass producer (token %p registration fails: %d\n",
> +		vq->call_ctx.producer.token, ret);


Not sure this deserves a vq_err(), irq will be relayed through eventfd 
if irq bypass manager can't work.


> +}
> +
> +static void vhost_vdpa_unsetup_vq_irq(struct vdpa_device *dev, int qid)
> +{
> +	struct vhost_vdpa *v = vdpa_get_drvdata(dev);
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +	spin_unlock(&vq->call_ctx.ctx_lock);
> +
> +	vq_err(vq, "unsetup irq bypass for vq %d\n", qid);


Why call vq_err() here?


> +}
> +
> +static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
> +{
> +	struct eventfd_ctx *ctx;
> +	void *token;
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	ctx = vq->call_ctx.ctx;
> +	token = vq->call_ctx.producer.token;
> +	if (ctx == token)
> +		return;


Need do unlock here.


> +
> +	if (!ctx && token)
> +		irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +
> +	if (ctx && ctx != token) {
> +		irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +		vq->call_ctx.producer.token = ctx;
> +		irq_bypass_register_producer(&vq->call_ctx.producer);
> +	}
> +
> +	spin_unlock(&vq->call_ctx.ctx_lock);


This should be rare so I'd use simple codes just do unregister and register.


> +}
> +
>   static void vhost_vdpa_reset(struct vhost_vdpa *v)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
> @@ -332,6 +389,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
>   
>   	return 0;
>   }
> +


Unnecessary change.


>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -390,6 +448,16 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   			cb.private = NULL;
>   		}
>   		ops->set_vq_cb(vdpa, idx, &cb);
> +#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> +		/*
> +		 * if it has a non-zero irq, means there is a
> +		 * previsouly registered irq_bypass_producer,
> +		 * we should update it when ctx (its token)
> +		 * changes.
> +		 */
> +		if (vq->call_ctx.producer.irq)
> +			vhost_vdpa_update_vq_irq(vq);
> +#endif
>   		break;
>   
>   	case VHOST_SET_VRING_NUM:
> @@ -741,6 +809,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>   		vqs[i] = &v->vqs[i];
>   		vqs[i]->handle_kick = handle_vq_kick;
>   	}
> +


Unnecessary change.

Thanks


>   	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>   		       vhost_vdpa_process_iotlb_msg);
>   

