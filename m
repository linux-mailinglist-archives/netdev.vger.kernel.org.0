Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3B29E507
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgJ2Hus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730094AbgJ2Hji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603957175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSXtkgaVTp0TVhMVC3oRaL4cKku7QCQcFRCq6q/d8Wk=;
        b=JYNQ5cjRrqlRLkEpAgBTTvjxrYJQfOEc8hGnDxMeUamSkosVbR/61XLwR7es6PSmmdqotq
        aSBAypdByTDHQiajcDRvF6tkOeOQRlUcOotHWS+nqeO3Ad8XRx9nmo0q7oHUfZTfn+z0Wc
        onjI2bfG3M8TtSb3VmvJYmUwdlgUSCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-KZqfB9rXNRCslrUL2DKyTw-1; Thu, 29 Oct 2020 03:39:33 -0400
X-MC-Unique: KZqfB9rXNRCslrUL2DKyTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF79487311B;
        Thu, 29 Oct 2020 07:39:31 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 586045D9EF;
        Thu, 29 Oct 2020 07:39:26 +0000 (UTC)
Subject: Re: [PATCH] vhost: Use mutex to protect vq_irq setup
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>, lingshan.zhu@intel.com
References: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
 <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
 <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7b92d057-75cc-8bee-6354-2fbefcd1850a@redhat.com>
Date:   Thu, 29 Oct 2020 15:39:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/29 下午3:37, Eli Cohen wrote:
> On Thu, Oct 29, 2020 at 03:03:24PM +0800, Jason Wang wrote:
>> On 2020/10/28 下午10:20, Eli Cohen wrote:
>>> Both irq_bypass_register_producer() and irq_bypass_unregister_producer()
>>> require process context to run. Change the call context lock from
>>> spinlock to mutex to protect the setup process to avoid deadlocks.
>>>
>>> Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>
>> Hi Eli:
>>
>> During review we spot that the spinlock is not necessary. And it was already
>> protected by vq mutex. So it was removed in this commit:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=86e182fe12ee5869022614457037097c70fe2ed1
>>
>> Thanks
>>
> I see, thanks.
>
> BTW, while testing irq bypassing, I noticed that qemu started crashing
> and I fail to boot the VM? Is that a known issue. I checked using
> updated master branch of qemu updated yesterday.


Not known yet.


>
> Any ideas how to check this further?


I would be helpful if you can paste the calltrace here.


> Did anyone actually check that irq bypassing works?


Yes, Ling Shan tested it via IFCVF driver.

Thanks


>
>>> ---
>>>    drivers/vhost/vdpa.c  | 10 +++++-----
>>>    drivers/vhost/vhost.c |  6 +++---
>>>    drivers/vhost/vhost.h |  3 ++-
>>>    3 files changed, 10 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index be783592fe58..0a744f2b6e76 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -98,26 +98,26 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>    		return;
>>>    	irq = ops->get_vq_irq(vdpa, qid);
>>> -	spin_lock(&vq->call_ctx.ctx_lock);
>>> +	mutex_lock(&vq->call_ctx.ctx_lock);
>>>    	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>    	if (!vq->call_ctx.ctx || irq < 0) {
>>> -		spin_unlock(&vq->call_ctx.ctx_lock);
>>> +		mutex_unlock(&vq->call_ctx.ctx_lock);
>>>    		return;
>>>    	}
>>>    	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>    	vq->call_ctx.producer.irq = irq;
>>>    	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>>> -	spin_unlock(&vq->call_ctx.ctx_lock);
>>> +	mutex_unlock(&vq->call_ctx.ctx_lock);
>>>    }
>>>    static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>    {
>>>    	struct vhost_virtqueue *vq = &v->vqs[qid];
>>> -	spin_lock(&vq->call_ctx.ctx_lock);
>>> +	mutex_lock(&vq->call_ctx.ctx_lock);
>>>    	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>> -	spin_unlock(&vq->call_ctx.ctx_lock);
>>> +	mutex_unlock(&vq->call_ctx.ctx_lock);
>>>    }
>>>    static void vhost_vdpa_reset(struct vhost_vdpa *v)
>>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>>> index 9ad45e1d27f0..938239e11455 100644
>>> --- a/drivers/vhost/vhost.c
>>> +++ b/drivers/vhost/vhost.c
>>> @@ -302,7 +302,7 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>>>    {
>>>    	call_ctx->ctx = NULL;
>>>    	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
>>> -	spin_lock_init(&call_ctx->ctx_lock);
>>> +	mutex_init(&call_ctx->ctx_lock);
>>>    }
>>>    static void vhost_vq_reset(struct vhost_dev *dev,
>>> @@ -1650,9 +1650,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
>>>    			break;
>>>    		}
>>> -		spin_lock(&vq->call_ctx.ctx_lock);
>>> +		mutex_lock(&vq->call_ctx.ctx_lock);
>>>    		swap(ctx, vq->call_ctx.ctx);
>>> -		spin_unlock(&vq->call_ctx.ctx_lock);
>>> +		mutex_unlock(&vq->call_ctx.ctx_lock);
>>>    		break;
>>>    	case VHOST_SET_VRING_ERR:
>>>    		if (copy_from_user(&f, argp, sizeof f)) {
>>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>>> index 9032d3c2a9f4..e8855ea04205 100644
>>> --- a/drivers/vhost/vhost.h
>>> +++ b/drivers/vhost/vhost.h
>>> @@ -64,7 +64,8 @@ enum vhost_uaddr_type {
>>>    struct vhost_vring_call {
>>>    	struct eventfd_ctx *ctx;
>>>    	struct irq_bypass_producer producer;
>>> -	spinlock_t ctx_lock;
>>> +	/* protect vq irq setup */
>>> +	struct mutex ctx_lock;
>>>    };
>>>    /* The virtqueue structure describes a queue attached to a device. */

