Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C3629F720
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgJ2Vpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:45:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgJ2Vpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 17:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604007951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rDydjHDEyxtDlbM9LiwatapQXLGWoCtD+jcyW+2/ETQ=;
        b=QUFubY5nNLBg+q2jV5zMTNp9YwSn9ZKQYK+2PMZPB1QgM3WtO2PLzZkzUmDYRssje7817d
        jTircTTrflok+fL2vaIl+kllTd//kEr8N24lCnHhO006+rBTaTzbpxh5YV/nf60SuCl1iU
        Sy2JC97kE792irLE4uOzmXrPbqRUdZw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-GLuPuPK5Npysk5CcnDJ0Qw-1; Thu, 29 Oct 2020 17:45:49 -0400
X-MC-Unique: GLuPuPK5Npysk5CcnDJ0Qw-1
Received: by mail-wr1-f69.google.com with SMTP id 2so1818776wrd.14
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 14:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rDydjHDEyxtDlbM9LiwatapQXLGWoCtD+jcyW+2/ETQ=;
        b=DEE9VCjF2YRnzzztGgC+RGpcCFdyXRyXre144gmKs/g0LbZv6cU/hJPhy0MjD6FmNm
         BjfNuU9ua/vCWIDvRnr2tDSkubX1rmK3ReT9YOxzEs7stu1oUPXu2k3LjRemJY6Dc7U4
         jNSUG+RdOU96zxV12BkT34YkekTHAApG+f4+Jya94tgMmyL5n0MiYj2hxwF4b0/Ldsoo
         Bwz5R8npIDentJK59uqT58ivJA/bj77XpOnkNnvvl9DVssOmwRjXS5Xe6qr4V3tn/lM4
         s3MePbWDyZolQ+yvYKDf9COjg/CAfzN6tKcMDW8QalwtPwaNzYwYF1JbzEPnvh5RaXch
         QAlw==
X-Gm-Message-State: AOAM53372aodOD+F45N54EkEp/PRBvV/6EGV1sIKvPo6Git4FAiSF6Wq
        DBfjiS5vffXk6rFsTfbY3XI9bXNR2pXWbOL0SyueMrqsWa0RO0VgBSnKX8Wv6MsZWykUL+5IPq4
        7Y6WOBDeZfLV7iVat
X-Received: by 2002:a1c:4957:: with SMTP id w84mr999521wma.84.1604007946561;
        Thu, 29 Oct 2020 14:45:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh522PLwbN3esfFYn02U54tG+HesahEou8DnEXFCh0nHrbm8lXdGF/MvzTNL4JtymMRQrDTA==
X-Received: by 2002:a1c:4957:: with SMTP id w84mr999496wma.84.1604007946223;
        Thu, 29 Oct 2020 14:45:46 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id y185sm1793936wmb.29.2020.10.29.14.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 14:45:45 -0700 (PDT)
Date:   Thu, 29 Oct 2020 17:45:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>, lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: Use mutex to protect vq_irq setup
Message-ID: <20201029174526-mutt-send-email-mst@kernel.org>
References: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
 <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
 <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 09:37:17AM +0200, Eli Cohen wrote:
> On Thu, Oct 29, 2020 at 03:03:24PM +0800, Jason Wang wrote:
> > 
> > On 2020/10/28 下午10:20, Eli Cohen wrote:
> > > Both irq_bypass_register_producer() and irq_bypass_unregister_producer()
> > > require process context to run. Change the call context lock from
> > > spinlock to mutex to protect the setup process to avoid deadlocks.
> > > 
> > > Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > 
> > 
> > Hi Eli:
> > 
> > During review we spot that the spinlock is not necessary. And it was already
> > protected by vq mutex. So it was removed in this commit:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=86e182fe12ee5869022614457037097c70fe2ed1
> > 
> > Thanks
> > 
> 
> I see, thanks.
> 
> BTW, while testing irq bypassing, I noticed that qemu started crashing
> and I fail to boot the VM? Is that a known issue. I checked using
> updated master branch of qemu updated yesterday.
> 
> Any ideas how to check this further?
> Did anyone actually check that irq bypassing works?

Confused. Is the crash related to this patch somehow?

> > 
> > > ---
> > >   drivers/vhost/vdpa.c  | 10 +++++-----
> > >   drivers/vhost/vhost.c |  6 +++---
> > >   drivers/vhost/vhost.h |  3 ++-
> > >   3 files changed, 10 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index be783592fe58..0a744f2b6e76 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -98,26 +98,26 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
> > >   		return;
> > >   	irq = ops->get_vq_irq(vdpa, qid);
> > > -	spin_lock(&vq->call_ctx.ctx_lock);
> > > +	mutex_lock(&vq->call_ctx.ctx_lock);
> > >   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > >   	if (!vq->call_ctx.ctx || irq < 0) {
> > > -		spin_unlock(&vq->call_ctx.ctx_lock);
> > > +		mutex_unlock(&vq->call_ctx.ctx_lock);
> > >   		return;
> > >   	}
> > >   	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> > >   	vq->call_ctx.producer.irq = irq;
> > >   	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> > > -	spin_unlock(&vq->call_ctx.ctx_lock);
> > > +	mutex_unlock(&vq->call_ctx.ctx_lock);
> > >   }
> > >   static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
> > >   {
> > >   	struct vhost_virtqueue *vq = &v->vqs[qid];
> > > -	spin_lock(&vq->call_ctx.ctx_lock);
> > > +	mutex_lock(&vq->call_ctx.ctx_lock);
> > >   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > > -	spin_unlock(&vq->call_ctx.ctx_lock);
> > > +	mutex_unlock(&vq->call_ctx.ctx_lock);
> > >   }
> > >   static void vhost_vdpa_reset(struct vhost_vdpa *v)
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 9ad45e1d27f0..938239e11455 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -302,7 +302,7 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
> > >   {
> > >   	call_ctx->ctx = NULL;
> > >   	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
> > > -	spin_lock_init(&call_ctx->ctx_lock);
> > > +	mutex_init(&call_ctx->ctx_lock);
> > >   }
> > >   static void vhost_vq_reset(struct vhost_dev *dev,
> > > @@ -1650,9 +1650,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
> > >   			break;
> > >   		}
> > > -		spin_lock(&vq->call_ctx.ctx_lock);
> > > +		mutex_lock(&vq->call_ctx.ctx_lock);
> > >   		swap(ctx, vq->call_ctx.ctx);
> > > -		spin_unlock(&vq->call_ctx.ctx_lock);
> > > +		mutex_unlock(&vq->call_ctx.ctx_lock);
> > >   		break;
> > >   	case VHOST_SET_VRING_ERR:
> > >   		if (copy_from_user(&f, argp, sizeof f)) {
> > > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > index 9032d3c2a9f4..e8855ea04205 100644
> > > --- a/drivers/vhost/vhost.h
> > > +++ b/drivers/vhost/vhost.h
> > > @@ -64,7 +64,8 @@ enum vhost_uaddr_type {
> > >   struct vhost_vring_call {
> > >   	struct eventfd_ctx *ctx;
> > >   	struct irq_bypass_producer producer;
> > > -	spinlock_t ctx_lock;
> > > +	/* protect vq irq setup */
> > > +	struct mutex ctx_lock;
> > >   };
> > >   /* The virtqueue structure describes a queue attached to a device. */
> > 

