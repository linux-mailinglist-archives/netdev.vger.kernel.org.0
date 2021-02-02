Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DC630BAE0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhBBJYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:24:37 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14958 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhBBJXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:23:41 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601919f40000>; Tue, 02 Feb 2021 01:23:00 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 09:22:57 +0000
Date:   Tue, 2 Feb 2021 11:22:53 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <siwliu.kernel@gmail.com>
CC:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
Message-ID: <20210202092253.GA236663@mtl-vdi-166.wap.labs.mlnx>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
 <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com>
 <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
 <CAPWQSg058RGaxSS7s5s=kpxdGryiy2padRFztUZtXN+ttiDd1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAPWQSg058RGaxSS7s5s=kpxdGryiy2padRFztUZtXN+ttiDd1A@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612257780; bh=HnB0z4VEKwRS3WGY8d836MJgxu5Eln/jbFZlNXVxc08=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=Mn8PWJhizQXbUWwa527Olk5ZocuhHh3M93ypx6RzrP1LzbZSvYeNO6HgPpHxmnjdM
         RvDsuAc0yyQhwi1tKA9VAOjJVeUbWlX1EZYBovr3QZw3hTuFY4ZJgY2roOsXyB1d8i
         q8vV7kSfXx+vPzSRrv4TxwZqS+7+QHcfkUDsggXsFf8Hyi5e2SvP8oxkKGVPFy8vkt
         MdpJ4OjOi0b1zreL+IlTtMSzaJPPXMIExuBGKBFnFTwvIUiqu8vMlRfnGpYXNtAu5y
         rdCf46Ml9jK9a2TvkuSqZQVbc9PNJHORNJ9ZV9Yu7BD8KDDIC6By4TsAyqqOORARWY
         mKrtIe2TH3XGg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 12:38:51AM -0800, Si-Wei Liu wrote:
> Thanks Eli and Jason for clarifications. See inline.
>=20
> On Mon, Feb 1, 2021 at 11:06 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > On Tue, Feb 02, 2021 at 02:02:25PM +0800, Jason Wang wrote:
> > >
> > > On 2021/2/2 =E4=B8=8B=E5=8D=8812:15, Si-Wei Liu wrote:
> > > > On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wro=
te:
> > > > >
> > > > > On 2021/2/2 =E4=B8=8A=E5=8D=883:17, Si-Wei Liu wrote:
> > > > > > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail=
.com> wrote:
> > > > > > > On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> w=
rote:
> > > > > > > > suspend_vq should only suspend the VQ on not save the curre=
nt available
> > > > > > > > index. This is done when a change of map occurs when the dr=
iver calls
> > > > > > > > save_channel_info().
> > > > > > > Hmmm, suspend_vq() is also called by teardown_vq(), the latte=
r of
> > > > > > > which doesn't save the available index as save_channel_info()=
 doesn't
> > > > > > > get called in that path at all. How does it handle the case t=
hat
> > > > > > > aget_vq_state() is called from userspace (e.g. QEMU) while th=
e
> > > > > > > hardware VQ object was torn down, but userspace still wants t=
o access
> > > > > > > the queue index?
> > > > > > >
> > > > > > > Refer to https://lore.kernel.org/netdev/1601583511-15138-1-gi=
t-send-email-si-wei.liu@oracle.com/
> > > > > > >
> > > > > > > vhost VQ 0 ring restore failed: -1: Resource temporarily unav=
ailable (11)
> > > > > > > vhost VQ 1 ring restore failed: -1: Resource temporarily unav=
ailable (11)
> > > > > > >
> > > > > > > QEMU will complain with the above warning while VM is being r=
ebooted
> > > > > > > or shut down.
> > > > > > >
> > > > > > > Looks to me either the kernel driver should cover this requir=
ement, or
> > > > > > > the userspace has to bear the burden in saving the index and =
not call
> > > > > > > into kernel if VQ is destroyed.
> > > > > > Actually, the userspace doesn't have the insights whether virt =
queue
> > > > > > will be destroyed if just changing the device status via set_st=
atus().
> > > > > > Looking at other vdpa driver in tree i.e. ifcvf it doesn't beha=
ve like
> > > > > > so. Hence this still looks to me to be Mellanox specifics and
> > > > > > mlx5_vdpa implementation detail that shouldn't expose to usersp=
ace.
> > > > >
> > > > > So I think we can simply drop this patch?
> > > > Yep, I think so. To be honest I don't know why it has anything to d=
o
> > > > with the memory hotplug issue.
> > >
> > >
> > > Eli may know more, my understanding is that, during memory hotplut, q=
emu
> > > need to propagate new memory mappings via set_map(). For mellanox, it=
 means
> > > it needs to rebuild memory keys, so the virtqueue needs to be suspend=
ed.
> > >
> >
> > I think Siwei was asking why the first patch was related to the hotplug
> > issue.
>=20
> I was thinking how consistency is assured when saving/restoring this
> h/w avail_index against the one in the virtq memory, particularly in
> the region_add/.region_del() context (e.g. the hotplug case). Problem
> is I don't see explicit memory barrier when guest thread updates the
> avail_index, how does the device make sure the h/w avail_index is
> uptodate while guest may race with updating the virtq's avail_index in
> the mean while? Maybe I completely miss something obvious?

If you're asking about syncronization upon hot plug of memory, the
hardware always goes to read the available index from memory when a new
hardware object is associted with a virtqueue. You can argue then that
you don't need to restore the available index and you may be right but
this is the currect inteface to the firmware.


If you're asking on generally how sync is assured when the guest updates
the available index, can you please send a pointer to the code where you
see the update without a memory barrier?

>=20
> Thanks,
> -Siwei
>=20
> >
> > But you're correct. When memory is added, I get a new memory map. This
> > requires me to build a new memory key object which covers the new memor=
y
> > map. Since the virtqueue objects are referencing this memory key, I nee=
d
> > to destroy them and build new ones referncing the new memory key.
> >
> > > Thanks
> > >
> > >
> > > >
> > > > -Siwei
> > > >
> > > > > Thanks
> > > > >
> > > > >
> > > > > > > -Siwei
> > > > > > >
> > > > > > >
> > > > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > > > ---
> > > > > > > >    drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> > > > > > > >    1 file changed, 8 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vd=
pa/mlx5/net/mlx5_vnet.c
> > > > > > > > index 88dde3455bfd..549ded074ff3 100644
> > > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > > @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_=
net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> > > > > > > >
> > > > > > > >    static void suspend_vq(struct mlx5_vdpa_net *ndev, struc=
t mlx5_vdpa_virtqueue *mvq)
> > > > > > > >    {
> > > > > > > > -       struct mlx5_virtq_attr attr;
> > > > > > > > -
> > > > > > > >           if (!mvq->initialized)
> > > > > > > >                   return;
> > > > > > > >
> > > > > > > > @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_v=
dpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > > > >
> > > > > > > >           if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q=
_OBJECT_STATE_SUSPEND))
> > > > > > > >                   mlx5_vdpa_warn(&ndev->mvdev, "modify to s=
uspend failed\n");
> > > > > > > > -
> > > > > > > > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > > > > > > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to que=
ry virtqueue\n");
> > > > > > > > -               return;
> > > > > > > > -       }
> > > > > > > > -       mvq->avail_idx =3D attr.available_index;
> > > > > > > >    }
> > > > > > > >
> > > > > > > >    static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > > > > > > --
> > > > > > > > 2.29.2
> > > > > > > >
> > >
