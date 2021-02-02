Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9676E30B835
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhBBG7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:59:07 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13215 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhBBG5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:57:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018f7c70000>; Mon, 01 Feb 2021 22:57:11 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 06:57:09 +0000
Date:   Tue, 2 Feb 2021 08:57:05 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Si-Wei Liu <siwliu.kernel@gmail.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
Message-ID: <20210202065705.GA232587@mtl-vdi-166.wap.labs.mlnx>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612249031; bh=QLhWKEGKgMKk+GS5l4zd0izvmgX0aProgpn8vewZ8JM=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=fln5zs7B6b0/K0bvd4exy8x5us8EDErORDsV23diUpkamWLpzVbMM6z6P7j+lit1o
         kwxpkq3KKvRrd+zG/Y9m4pxxbz4IvnJTVA1Mj/s6mXE61wyF6iD7I9yi90nydP1R8R
         hM/AKs955cqnY9kWG+FYAGSjgfnyZNNQKK6rOYO+H5FiSwGr1lvtDcFXXQyaLzw2EL
         5VGghtTKmrj1k7B2Ln+f4YV8qFFog5F+z1cjFMO+1NirJM4L3Ix2vwT4YeJlQJAP/D
         419D9B+EGy/GnaPumI2yFfE9NKr1DNzBhdO85qaPBDnGzKtZ9DcbZVn7pWFZXtyr9Y
         p21/EidrmR8mQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 11:12:51AM +0800, Jason Wang wrote:
>=20
> On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com> wr=
ote:
> > > On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
> > > > suspend_vq should only suspend the VQ on not save the current avail=
able
> > > > index. This is done when a change of map occurs when the driver cal=
ls
> > > > save_channel_info().
> > > Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
> > > which doesn't save the available index as save_channel_info() doesn't
> > > get called in that path at all. How does it handle the case that
> > > aget_vq_state() is called from userspace (e.g. QEMU) while the
> > > hardware VQ object was torn down, but userspace still wants to access
> > > the queue index?
> > >=20
> > > Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-e=
mail-si-wei.liu@oracle.com/
> > >=20
> > > vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable =
(11)
> > > vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable =
(11)
> > >=20
> > > QEMU will complain with the above warning while VM is being rebooted
> > > or shut down.
> > >=20
> > > Looks to me either the kernel driver should cover this requirement, o=
r
> > > the userspace has to bear the burden in saving the index and not call
> > > into kernel if VQ is destroyed.
> > Actually, the userspace doesn't have the insights whether virt queue
> > will be destroyed if just changing the device status via set_status().
> > Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave like
> > so. Hence this still looks to me to be Mellanox specifics and
> > mlx5_vdpa implementation detail that shouldn't expose to userspace.
>=20
>=20
> So I think we can simply drop this patch?
>=20

Yes, I agree. Let's just avoid it.

> Thanks
>=20
>=20
> > > -Siwei
> > >=20
> > >=20
> > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > ---
> > > >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> > > >   1 file changed, 8 deletions(-)
> > > >=20
> > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/=
net/mlx5_vnet.c
> > > > index 88dde3455bfd..549ded074ff3 100644
> > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *nde=
v, struct mlx5_vdpa_virtqueue *mvq)
> > > >=20
> > > >   static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vd=
pa_virtqueue *mvq)
> > > >   {
> > > > -       struct mlx5_virtq_attr attr;
> > > > -
> > > >          if (!mvq->initialized)
> > > >                  return;
> > > >=20
> > > > @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net =
*ndev, struct mlx5_vdpa_virtqueue *m
> > > >=20
> > > >          if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_S=
TATE_SUSPEND))
> > > >                  mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend fa=
iled\n");
> > > > -
> > > > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtq=
ueue\n");
> > > > -               return;
> > > > -       }
> > > > -       mvq->avail_idx =3D attr.available_index;
> > > >   }
> > > >=20
> > > >   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > > --
> > > > 2.29.2
> > > >=20
>=20
