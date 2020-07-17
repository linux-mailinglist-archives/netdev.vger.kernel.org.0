Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB562232EE
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 07:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgGQFab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 01:30:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725909AbgGQFaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 01:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594963829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D+wLk/ePgaJoi2FnNGkrLAcPurLKVDi5tXa+03Q0aj4=;
        b=RN7gvvQ93RBjUvJo5+te7d/Ve1r3nDabLC/HWXmvoye8a2fEm8cnbuppohNdZ+r4BCaSsI
        vGJxVaT8h/oJXH6T6UXYdfIAbuAKysS0G76TSGq4rzK0CCIjvHUEdb+YbfRlN/fWEUiY0f
        uKCiMLzdt0SQSwPKiucLV0xYrcYhQ7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-XCp00DzjMKeWww0JR7yhyw-1; Fri, 17 Jul 2020 01:30:25 -0400
X-MC-Unique: XCp00DzjMKeWww0JR7yhyw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC611800D42;
        Fri, 17 Jul 2020 05:30:22 +0000 (UTC)
Received: from [10.72.12.157] (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF7B378A54;
        Fri, 17 Jul 2020 05:30:02 +0000 (UTC)
Subject: Re: [PATCH V2 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-5-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <96df4d83-2297-5f30-b6a3-75a0cdf23a0b@redhat.com>
Date:   Fri, 17 Jul 2020 13:29:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594898629-18790-5-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/16 下午7:23, Zhu Lingshan wrote:
> This patch introduce a set of functions for setup/unsetup
> and update irq offloading respectively by register/unregister
> and re-register the irq_bypass_producer.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/Kconfig |  1 +
>   drivers/vhost/vdpa.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 49 insertions(+)
>
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index d3688c6..587fbae 100644
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
> index 2fcc422..b9078d4 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -115,6 +115,43 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
>   	return IRQ_HANDLED;
>   }
>   
> +static void vhost_vdpa_setup_vq_irq(struct vdpa_device *dev, int qid, int irq)
> +{
> +	struct vhost_vdpa *v = vdpa_get_drvdata(dev);
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +	int ret;
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	if (!vq->call_ctx.ctx) {
> +		spin_unlock(&vq->call_ctx.ctx_lock);
> +		return;
> +	}


I think we can simply remove this check as what is done in 
vhost_vdpq_update_vq_irq().


> +
> +	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +	vq->call_ctx.producer.irq = irq;
> +	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> +	spin_unlock(&vq->call_ctx.ctx_lock);
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
> +}
> +
> +static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
> +{
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +	irq_bypass_register_producer(&vq->call_ctx.producer);
> +	spin_unlock(&vq->call_ctx.ctx_lock);
> +}
> +
>   static void vhost_vdpa_reset(struct vhost_vdpa *v)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
> @@ -332,6 +369,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
>   
>   	return 0;
>   }
> +


If you really want to fix coding style issue, it's better to have 
another patch.


>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   				   void __user *argp)
>   {
> @@ -390,6 +428,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>   			cb.private = NULL;
>   		}
>   		ops->set_vq_cb(vdpa, idx, &cb);
> +		/*
> +		 * if it has a non-zero irq, means there is a
> +		 * previsouly registered irq_bypass_producer,
> +		 * we should update it when ctx (its token)
> +		 * changes.
> +		 */
> +		if (vq->call_ctx.producer.irq)
> +			vhost_vdpa_update_vq_irq(vq);


Is this safe to check producer.irq outside spinlock?

Thanks


>   		break;
>   
>   	case VHOST_SET_VRING_NUM:
> @@ -951,6 +997,8 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
>   	},
>   	.probe	= vhost_vdpa_probe,
>   	.remove	= vhost_vdpa_remove,
> +	.setup_vq_irq = vhost_vdpa_setup_vq_irq,
> +	.unsetup_vq_irq = vhost_vdpa_unsetup_vq_irq,
>   };
>   
>   static int __init vhost_vdpa_init(void)

