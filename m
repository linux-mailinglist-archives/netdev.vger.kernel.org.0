Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAECB29E44E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgJ2Hha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:37:30 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11904 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729534AbgJ2Hh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:37:27 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9a713b0000>; Thu, 29 Oct 2020 00:37:31 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 07:37:21 +0000
Date:   Thu, 29 Oct 2020 09:37:17 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, <lingshan.zhu@intel.com>
Subject: Re: [PATCH] vhost: Use mutex to protect vq_irq setup
Message-ID: <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
References: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
 <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603957051; bh=Tcj9O0VPZE/ESYM5ejP06jm/s+1LtZxjCrRu/mJzr3E=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=fydvi00nX56uHl/r42wLF7F1+IZRDFgHSp0iSVdo4nNDmZQq5UXjA2G7NkGAaWFBM
         zHYmep0kxZ/7YGJmXUhUDDFQUF7scQg6B64SvqGET+qD1EMFLn0ZNSi/FiW4eY4wyo
         ww3HJIUBNGmjKM8/faEPXuULT6O74MmMVyffXMBFA613vkUTO8Earrpe86w+fzMaWj
         puUELsawLCVhXyXm1da16WIOvAIHXfGaTlzFA98HPNa76ftZozGR8a5QqhJFKseAvf
         rUoXTmhfsvvOXQ4RZ+9vb1FwBmp61isq62MVT0leCWZgBB0EdeOHex3uC09fe4TyN+
         AbRmffdaG/oRQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 03:03:24PM +0800, Jason Wang wrote:
>=20
> On 2020/10/28 =E4=B8=8B=E5=8D=8810:20, Eli Cohen wrote:
> > Both irq_bypass_register_producer() and irq_bypass_unregister_producer(=
)
> > require process context to run. Change the call context lock from
> > spinlock to mutex to protect the setup process to avoid deadlocks.
> >=20
> > Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
>=20
>=20
> Hi Eli:
>=20
> During review we spot that the spinlock is not necessary. And it was alre=
ady
> protected by vq mutex. So it was removed in this commit:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D86e182fe12ee5869022614457037097c70fe2ed1
>=20
> Thanks
>=20

I see, thanks.

BTW, while testing irq bypassing, I noticed that qemu started crashing
and I fail to boot the VM? Is that a known issue. I checked using
updated master branch of qemu updated yesterday.

Any ideas how to check this further?
Did anyone actually check that irq bypassing works?

>=20
> > ---
> >   drivers/vhost/vdpa.c  | 10 +++++-----
> >   drivers/vhost/vhost.c |  6 +++---
> >   drivers/vhost/vhost.h |  3 ++-
> >   3 files changed, 10 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index be783592fe58..0a744f2b6e76 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -98,26 +98,26 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vd=
pa *v, u16 qid)
> >   		return;
> >   	irq =3D ops->get_vq_irq(vdpa, qid);
> > -	spin_lock(&vq->call_ctx.ctx_lock);
> > +	mutex_lock(&vq->call_ctx.ctx_lock);
> >   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> >   	if (!vq->call_ctx.ctx || irq < 0) {
> > -		spin_unlock(&vq->call_ctx.ctx_lock);
> > +		mutex_unlock(&vq->call_ctx.ctx_lock);
> >   		return;
> >   	}
> >   	vq->call_ctx.producer.token =3D vq->call_ctx.ctx;
> >   	vq->call_ctx.producer.irq =3D irq;
> >   	ret =3D irq_bypass_register_producer(&vq->call_ctx.producer);
> > -	spin_unlock(&vq->call_ctx.ctx_lock);
> > +	mutex_unlock(&vq->call_ctx.ctx_lock);
> >   }
> >   static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
> >   {
> >   	struct vhost_virtqueue *vq =3D &v->vqs[qid];
> > -	spin_lock(&vq->call_ctx.ctx_lock);
> > +	mutex_lock(&vq->call_ctx.ctx_lock);
> >   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > -	spin_unlock(&vq->call_ctx.ctx_lock);
> > +	mutex_unlock(&vq->call_ctx.ctx_lock);
> >   }
> >   static void vhost_vdpa_reset(struct vhost_vdpa *v)
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 9ad45e1d27f0..938239e11455 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -302,7 +302,7 @@ static void vhost_vring_call_reset(struct vhost_vri=
ng_call *call_ctx)
> >   {
> >   	call_ctx->ctx =3D NULL;
> >   	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer))=
;
> > -	spin_lock_init(&call_ctx->ctx_lock);
> > +	mutex_init(&call_ctx->ctx_lock);
> >   }
> >   static void vhost_vq_reset(struct vhost_dev *dev,
> > @@ -1650,9 +1650,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsig=
ned int ioctl, void __user *arg
> >   			break;
> >   		}
> > -		spin_lock(&vq->call_ctx.ctx_lock);
> > +		mutex_lock(&vq->call_ctx.ctx_lock);
> >   		swap(ctx, vq->call_ctx.ctx);
> > -		spin_unlock(&vq->call_ctx.ctx_lock);
> > +		mutex_unlock(&vq->call_ctx.ctx_lock);
> >   		break;
> >   	case VHOST_SET_VRING_ERR:
> >   		if (copy_from_user(&f, argp, sizeof f)) {
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 9032d3c2a9f4..e8855ea04205 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -64,7 +64,8 @@ enum vhost_uaddr_type {
> >   struct vhost_vring_call {
> >   	struct eventfd_ctx *ctx;
> >   	struct irq_bypass_producer producer;
> > -	spinlock_t ctx_lock;
> > +	/* protect vq irq setup */
> > +	struct mutex ctx_lock;
> >   };
> >   /* The virtqueue structure describes a queue attached to a device. */
>=20
