Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A6262B45
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIIJFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:05:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726005AbgIIJFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599642298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hF5FRl4+JcryV02oF186NMbYpd31+bm49DOKtjwi4hY=;
        b=cBJMIE+k+INH7ExziNhm1ocLK1jqLEiTpXz58pLKNRBSSxk3aqXFy+bDXJIIR9I38vqp7h
        Ld0fR5/Z37od8V6jVnZP0WFIDzt9m8R6Z/nF1Ts3EvXo1p2H0Bi+q/3ixnHAFJ8YBAQpMB
        r/oemdDQZlM2pbYLsg34A6d4z6kmXGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-S9pHHcnKP2GaTHqVUgeIEg-1; Wed, 09 Sep 2020 05:04:56 -0400
X-MC-Unique: S9pHHcnKP2GaTHqVUgeIEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD4A21DDFF;
        Wed,  9 Sep 2020 09:04:55 +0000 (UTC)
Received: from [10.72.12.24] (ovpn-12-24.pek2.redhat.com [10.72.12.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE09946;
        Wed,  9 Sep 2020 09:04:47 +0000 (UTC)
Subject: Re: [PATCH] vhost_vdpa: remove unnecessary spin_lock in
 vhost_vring_call
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200909065234.3313-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a7035d50-04e4-714a-e4aa-03872b939827@redhat.com>
Date:   Wed, 9 Sep 2020 17:04:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909065234.3313-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/9 下午2:52, Zhu Lingshan wrote:
> This commit removed unnecessary spin_locks in vhost_vring_call
> and related operations. Because we manipulate irq offloading
> contents in vhost_vdpa ioctl code path which is already
> protected by dev mutex and vq mutex.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c  | 8 +-------
>   drivers/vhost/vhost.c | 3 ---
>   drivers/vhost/vhost.h | 1 -
>   3 files changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..bc679d0b7b87 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -97,26 +97,20 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>   		return;
>   
>   	irq = ops->get_vq_irq(vdpa, qid);
> -	spin_lock(&vq->call_ctx.ctx_lock);
>   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> -	if (!vq->call_ctx.ctx || irq < 0) {
> -		spin_unlock(&vq->call_ctx.ctx_lock);
> +	if (!vq->call_ctx.ctx || irq < 0)
>   		return;
> -	}
>   
>   	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>   	vq->call_ctx.producer.irq = irq;
>   	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> -	spin_unlock(&vq->call_ctx.ctx_lock);
>   }
>   
>   static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>   {
>   	struct vhost_virtqueue *vq = &v->vqs[qid];
>   
> -	spin_lock(&vq->call_ctx.ctx_lock);
>   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> -	spin_unlock(&vq->call_ctx.ctx_lock);
>   }
>   
>   static void vhost_vdpa_reset(struct vhost_vdpa *v)
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..99f27ce982da 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -302,7 +302,6 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>   {
>   	call_ctx->ctx = NULL;
>   	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
> -	spin_lock_init(&call_ctx->ctx_lock);
>   }
>   
>   static void vhost_vq_reset(struct vhost_dev *dev,
> @@ -1637,9 +1636,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>   			break;
>   		}
>   
> -		spin_lock(&vq->call_ctx.ctx_lock);
>   		swap(ctx, vq->call_ctx.ctx);
> -		spin_unlock(&vq->call_ctx.ctx_lock);
>   		break;
>   	case VHOST_SET_VRING_ERR:
>   		if (copy_from_user(&f, argp, sizeof f)) {
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 9032d3c2a9f4..486dcf371e06 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -64,7 +64,6 @@ enum vhost_uaddr_type {
>   struct vhost_vring_call {
>   	struct eventfd_ctx *ctx;
>   	struct irq_bypass_producer producer;
> -	spinlock_t ctx_lock;
>   };
>   
>   /* The virtqueue structure describes a queue attached to a device. */

