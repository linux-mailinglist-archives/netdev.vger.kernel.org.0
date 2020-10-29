Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2690029E504
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbgJ2Huu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:50:50 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12323 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730807AbgJ2Huq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:50:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9a74580001>; Thu, 29 Oct 2020 00:50:48 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 07:50:39 +0000
Date:   Thu, 29 Oct 2020 09:50:35 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, <lingshan.zhu@intel.com>
Subject: Re: [PATCH] vhost: Use mutex to protect vq_irq setup
Message-ID: <20201029075035.GC132479@mtl-vdi-166.wap.labs.mlnx>
References: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
 <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
 <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
 <7b92d057-75cc-8bee-6354-2fbefcd1850a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <7b92d057-75cc-8bee-6354-2fbefcd1850a@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603957848; bh=K/jdixSihBGzu/K5RKJSEGr0k75jDHK7OGG8hzRSd6c=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=FwoQ4xMf/XumLJLed25/+3b5gOiGUYjgdvZzolurFwTiHrv3ZwyA1TXR5NFPvoKbI
         6a+05mCudY6elPRZCJX8ziHU5aBCMP6NGiUwh11QA1k7ZVITzFC830B1pu02Mn7Nwe
         CHaA077BToH0Wir9KvdH8aQ4KsIady5ZebkgBLDuzH6ayYd6C9BEeYyrkChTo+W68C
         +HVVv29eoVnZ2b/x/hoQgF637vZ1Wnp/5wbYkFxt/QgrHjr6os5hmmgguH+HVIaV2f
         6ek1tpCGndsCjuEV+GKQ7ruTLmFKVPQXTrtkV0T0PFaRfKunF5dzQUaZfvvOvt+M4x
         QlEiBfkAJFV4g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 03:39:24PM +0800, Jason Wang wrote:
>=20
> On 2020/10/29 =E4=B8=8B=E5=8D=883:37, Eli Cohen wrote:
> > On Thu, Oct 29, 2020 at 03:03:24PM +0800, Jason Wang wrote:
> > > On 2020/10/28 =E4=B8=8B=E5=8D=8810:20, Eli Cohen wrote:
> > > > Both irq_bypass_register_producer() and irq_bypass_unregister_produ=
cer()
> > > > require process context to run. Change the call context lock from
> > > > spinlock to mutex to protect the setup process to avoid deadlocks.
> > > >=20
> > > > Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
> > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > >=20
> > > Hi Eli:
> > >=20
> > > During review we spot that the spinlock is not necessary. And it was =
already
> > > protected by vq mutex. So it was removed in this commit:
> > >=20
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D86e182fe12ee5869022614457037097c70fe2ed1
> > >=20
> > > Thanks
> > >=20
> > I see, thanks.
> >=20
> > BTW, while testing irq bypassing, I noticed that qemu started crashing
> > and I fail to boot the VM? Is that a known issue. I checked using
> > updated master branch of qemu updated yesterday.
>=20
>=20
> Not known yet.
>=20
>=20
> >=20
> > Any ideas how to check this further?
>=20
>=20
> I would be helpful if you can paste the calltrace here.
>=20

I am not too familiar with qemu. Assuming I am using virsh start to boot
the VM, how can I get the call trace?

>=20
> > Did anyone actually check that irq bypassing works?
>=20
>=20
> Yes, Ling Shan tested it via IFCVF driver.
>=20
> Thanks
>=20
>=20
> >=20
> > > > ---
> > > >    drivers/vhost/vdpa.c  | 10 +++++-----
> > > >    drivers/vhost/vhost.c |  6 +++---
> > > >    drivers/vhost/vhost.h |  3 ++-
> > > >    3 files changed, 10 insertions(+), 9 deletions(-)
> > > >=20
> > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > index be783592fe58..0a744f2b6e76 100644
> > > > --- a/drivers/vhost/vdpa.c
> > > > +++ b/drivers/vhost/vdpa.c
> > > > @@ -98,26 +98,26 @@ static void vhost_vdpa_setup_vq_irq(struct vhos=
t_vdpa *v, u16 qid)
> > > >    		return;
> > > >    	irq =3D ops->get_vq_irq(vdpa, qid);
> > > > -	spin_lock(&vq->call_ctx.ctx_lock);
> > > > +	mutex_lock(&vq->call_ctx.ctx_lock);
> > > >    	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > > >    	if (!vq->call_ctx.ctx || irq < 0) {
> > > > -		spin_unlock(&vq->call_ctx.ctx_lock);
> > > > +		mutex_unlock(&vq->call_ctx.ctx_lock);
> > > >    		return;
> > > >    	}
> > > >    	vq->call_ctx.producer.token =3D vq->call_ctx.ctx;
> > > >    	vq->call_ctx.producer.irq =3D irq;
> > > >    	ret =3D irq_bypass_register_producer(&vq->call_ctx.producer);
> > > > -	spin_unlock(&vq->call_ctx.ctx_lock);
> > > > +	mutex_unlock(&vq->call_ctx.ctx_lock);
> > > >    }
> > > >    static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 =
qid)
> > > >    {
> > > >    	struct vhost_virtqueue *vq =3D &v->vqs[qid];
> > > > -	spin_lock(&vq->call_ctx.ctx_lock);
> > > > +	mutex_lock(&vq->call_ctx.ctx_lock);
> > > >    	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> > > > -	spin_unlock(&vq->call_ctx.ctx_lock);
> > > > +	mutex_unlock(&vq->call_ctx.ctx_lock);
> > > >    }
> > > >    static void vhost_vdpa_reset(struct vhost_vdpa *v)
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 9ad45e1d27f0..938239e11455 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -302,7 +302,7 @@ static void vhost_vring_call_reset(struct vhost=
_vring_call *call_ctx)
> > > >    {
> > > >    	call_ctx->ctx =3D NULL;
> > > >    	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_produ=
cer));
> > > > -	spin_lock_init(&call_ctx->ctx_lock);
> > > > +	mutex_init(&call_ctx->ctx_lock);
> > > >    }
> > > >    static void vhost_vq_reset(struct vhost_dev *dev,
> > > > @@ -1650,9 +1650,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, u=
nsigned int ioctl, void __user *arg
> > > >    			break;
> > > >    		}
> > > > -		spin_lock(&vq->call_ctx.ctx_lock);
> > > > +		mutex_lock(&vq->call_ctx.ctx_lock);
> > > >    		swap(ctx, vq->call_ctx.ctx);
> > > > -		spin_unlock(&vq->call_ctx.ctx_lock);
> > > > +		mutex_unlock(&vq->call_ctx.ctx_lock);
> > > >    		break;
> > > >    	case VHOST_SET_VRING_ERR:
> > > >    		if (copy_from_user(&f, argp, sizeof f)) {
> > > > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > > index 9032d3c2a9f4..e8855ea04205 100644
> > > > --- a/drivers/vhost/vhost.h
> > > > +++ b/drivers/vhost/vhost.h
> > > > @@ -64,7 +64,8 @@ enum vhost_uaddr_type {
> > > >    struct vhost_vring_call {
> > > >    	struct eventfd_ctx *ctx;
> > > >    	struct irq_bypass_producer producer;
> > > > -	spinlock_t ctx_lock;
> > > > +	/* protect vq irq setup */
> > > > +	struct mutex ctx_lock;
> > > >    };
> > > >    /* The virtqueue structure describes a queue attached to a devic=
e. */
>=20
