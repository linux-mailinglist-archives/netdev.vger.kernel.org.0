Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641F30B85F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhBBHHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:07:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13859 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhBBHHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 02:07:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018f9fd0004>; Mon, 01 Feb 2021 23:06:37 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 07:06:34 +0000
Date:   Tue, 2 Feb 2021 09:06:31 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Si-Wei Liu <siwliu.kernel@gmail.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
Message-ID: <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
 <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612249597; bh=oQ6Ri294/3mOiXs/oCOWdeD09SEKwcXEGPnVFpELei4=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=ds0u2m10ILFU0jMgmReLqHd6imLwiwGYwUQ39xzlAtIlkaS6iCO+AB23PfotnNN4S
         IFigvALYs9KoBXrqk8f2cD+nmJqCu1co/ZsfgCnE9qNI/rGa03VFnvLQ6XRGSjzuNr
         XqPMGxLi/ZaM1TykXi+ExlmyrXTaQwRfkQyPiHKuN22dnE2lbodrFyMRmchAuw0yrg
         pXHhBYdsPLDJQ+wFrCAfOeUh9PY8mFIFq5/Ox8+ddCbtLzKcqLD/hI50fsH277dlDr
         b/SffbKeo8EVstYEW4f3P61kfk5aIYcjvo2MlrqZe64VpJfoY4vVSjDZuctdvu9AoN
         xSBQKeZtjzQbQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 02:02:25PM +0800, Jason Wang wrote:
>=20
> On 2021/2/2 =E4=B8=8B=E5=8D=8812:15, Si-Wei Liu wrote:
> > On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wrote:
> > >=20
> > > On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> > > > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com=
> wrote:
> > > > > On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote=
:
> > > > > > suspend_vq should only suspend the VQ on not save the current a=
vailable
> > > > > > index. This is done when a change of map occurs when the driver=
 calls
> > > > > > save_channel_info().
> > > > > Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
> > > > > which doesn't save the available index as save_channel_info() doe=
sn't
> > > > > get called in that path at all. How does it handle the case that
> > > > > aget_vq_state() is called from userspace (e.g. QEMU) while the
> > > > > hardware VQ object was torn down, but userspace still wants to ac=
cess
> > > > > the queue index?
> > > > >=20
> > > > > Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-se=
nd-email-si-wei.liu@oracle.com/
> > > > >=20
> > > > > vhost VQ 0 ring restore failed: -1: Resource temporarily unavaila=
ble (11)
> > > > > vhost VQ 1 ring restore failed: -1: Resource temporarily unavaila=
ble (11)
> > > > >=20
> > > > > QEMU will complain with the above warning while VM is being reboo=
ted
> > > > > or shut down.
> > > > >=20
> > > > > Looks to me either the kernel driver should cover this requiremen=
t, or
> > > > > the userspace has to bear the burden in saving the index and not =
call
> > > > > into kernel if VQ is destroyed.
> > > > Actually, the userspace doesn't have the insights whether virt queu=
e
> > > > will be destroyed if just changing the device status via set_status=
().
> > > > Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave l=
ike
> > > > so. Hence this still looks to me to be Mellanox specifics and
> > > > mlx5_vdpa implementation detail that shouldn't expose to userspace.
> > >=20
> > > So I think we can simply drop this patch?
> > Yep, I think so. To be honest I don't know why it has anything to do
> > with the memory hotplug issue.
>=20
>=20
> Eli may know more, my understanding is that, during memory hotplut, qemu
> need to propagate new memory mappings via set_map(). For mellanox, it mea=
ns
> it needs to rebuild memory keys, so the virtqueue needs to be suspended.
>=20

I think Siwei was asking why the first patch was related to the hotplug
issue.

But you're correct. When memory is added, I get a new memory map. This
requires me to build a new memory key object which covers the new memory
map. Since the virtqueue objects are referencing this memory key, I need
to destroy them and build new ones referncing the new memory key.

> Thanks
>=20
>=20
> >=20
> > -Siwei
> >=20
> > > Thanks
> > >=20
> > >=20
> > > > > -Siwei
> > > > >=20
> > > > >=20
> > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > ---
> > > > > >    drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> > > > > >    1 file changed, 8 deletions(-)
> > > > > >=20
> > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/m=
lx5/net/mlx5_vnet.c
> > > > > > index 88dde3455bfd..549ded074ff3 100644
> > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net =
*ndev, struct mlx5_vdpa_virtqueue *mvq)
> > > > > >=20
> > > > > >    static void suspend_vq(struct mlx5_vdpa_net *ndev, struct ml=
x5_vdpa_virtqueue *mvq)
> > > > > >    {
> > > > > > -       struct mlx5_virtq_attr attr;
> > > > > > -
> > > > > >           if (!mvq->initialized)
> > > > > >                   return;
> > > > > >=20
> > > > > > @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_=
net *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > >=20
> > > > > >           if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJ=
ECT_STATE_SUSPEND))
> > > > > >                   mlx5_vdpa_warn(&ndev->mvdev, "modify to suspe=
nd failed\n");
> > > > > > -
> > > > > > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > > > > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query v=
irtqueue\n");
> > > > > > -               return;
> > > > > > -       }
> > > > > > -       mvq->avail_idx =3D attr.available_index;
> > > > > >    }
> > > > > >=20
> > > > > >    static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > > > > --
> > > > > > 2.29.2
> > > > > >=20
>=20
