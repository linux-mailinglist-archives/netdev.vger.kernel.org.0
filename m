Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5250314880
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBIGN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:13:27 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11180 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhBIGNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:13:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602227d70000>; Mon, 08 Feb 2021 22:12:39 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 06:12:38 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 9 Feb 2021 06:12:36 +0000
Date:   Tue, 9 Feb 2021 08:12:32 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Si-Wei Liu <si-wei.liu@oracle.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
Message-ID: <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
 <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612851159; bh=IIEGkb9KfoptflBESAUG25Bwabvj9oLl1u1vLkgyIo8=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=UYIq7PHcUgtN3I2P6yFkqelH7tyYE8SyRoOWOVlxQtVoxUr7c9ERj6UceDzCP7KEX
         ctD46+uoS+J56pEItPohG+0no+1mGQNpDRg6lGeTKQ4upNlGdDD/VnNqhv/XhPZqOs
         xYk37cF50OcqjP4z4wao+xLfOnavoG5N15N8IGT03mDqHZ8FrBan/0QUkIoIBfSr6k
         omz5uKwUiHeCP7iV5/LszfpjTNToM/g8isffgcACIUirudi8PTyJ6ajupiQn3RCIiJ
         iVLcxw1cUrS0Yn07uojUTJXrqi8U762AnjXRCbV8HJSDtTHPI3iM5A1ESW+wzwslcR
         /o4pPXZIFlY7Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 11:20:14AM +0800, Jason Wang wrote:
>=20
> On 2021/2/8 =E4=B8=8B=E5=8D=886:04, Eli Cohen wrote:
> > On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
> > > On 2021/2/8 =E4=B8=8B=E5=8D=882:37, Eli Cohen wrote:
> > > > On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrote:
> > > > > On 2021/2/6 =E4=B8=8A=E5=8D=887:07, Si-Wei Liu wrote:
> > > > > > On 2/3/2021 11:36 PM, Eli Cohen wrote:
> > > > > > > When a change of memory map occurs, the hardware resources ar=
e destroyed
> > > > > > > and then re-created again with the new memory map. In such ca=
se, we need
> > > > > > > to restore the hardware available and used indices. The drive=
r failed to
> > > > > > > restore the used index which is added here.
> > > > > > >=20
> > > > > > > Also, since the driver also fails to reset the available and =
used
> > > > > > > indices upon device reset, fix this here to avoid regression =
caused by
> > > > > > > the fact that used index may not be zero upon device reset.
> > > > > > >=20
> > > > > > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supporte=
d mlx5
> > > > > > > devices")
> > > > > > > Signed-off-by: Eli Cohen<elic@nvidia.com>
> > > > > > > ---
> > > > > > > v0 -> v1:
> > > > > > > Clear indices upon device reset
> > > > > > >=20
> > > > > > >   =C2=A0 drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 +++++++++++++=
+++++
> > > > > > >   =C2=A0 1 file changed, 18 insertions(+)
> > > > > > >=20
> > > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > index 88dde3455bfd..b5fe6d2ad22f 100644
> > > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 device_addr;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 driver_addr;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 avail_index;
> > > > > > > +=C2=A0=C2=A0=C2=A0 u16 used_index;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ready;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vdpa_callback cb;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool restore;
> > > > > > > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 virtq_id;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mlx5_vdpa_net *ndev;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 avail_idx;
> > > > > > > +=C2=A0=C2=A0=C2=A0 u16 used_idx;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int fw_state;
> > > > > > >   =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* keep last in the s=
truct */
> > > > > > > @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_v=
dpa_net
> > > > > > > *ndev, struct mlx5_vdpa_virtque
> > > > > > >   =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 obj_context =3D MLX5_=
ADDR_OF(create_virtio_net_q_in, in,
> > > > > > > obj_context);
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MLX5_SET(virtio_net_q_object=
, obj_context, hw_available_index,
> > > > > > > mvq->avail_idx);
> > > > > > > +=C2=A0=C2=A0=C2=A0 MLX5_SET(virtio_net_q_object, obj_context=
, hw_used_index,
> > > > > > > mvq->used_idx);
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MLX5_SET(virtio_net_q_object=
, obj_context,
> > > > > > > queue_feature_bit_mask_12_3,
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 get_features_12_3(ndev->mvdev.actual_features));
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vq_ctx =3D MLX5_ADDR_OF(virt=
io_net_q_object, obj_context,
> > > > > > > virtio_q_context);
> > > > > > > @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa=
_net
> > > > > > > *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > > >   =C2=A0 struct mlx5_virtq_attr {
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 state;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 available_index;
> > > > > > > +=C2=A0=C2=A0=C2=A0 u16 used_index;
> > > > > > >   =C2=A0 };
> > > > > > >   =C2=A0 =C2=A0 static int query_virtqueue(struct mlx5_vdpa_n=
et *ndev, struct
> > > > > > > mlx5_vdpa_virtqueue *mvq,
> > > > > > > @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct
> > > > > > > mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memset(attr, 0, sizeof(*attr=
));
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 attr->state =3D MLX5_GET(vir=
tio_net_q_object, obj_context, state);
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 attr->available_index =3D ML=
X5_GET(virtio_net_q_object,
> > > > > > > obj_context, hw_available_index);
> > > > > > > +=C2=A0=C2=A0=C2=A0 attr->used_index =3D MLX5_GET(virtio_net_=
q_object, obj_context,
> > > > > > > hw_used_index);
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(out);
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> > > > > > >   =C2=A0 @@ -1535,6 +1540,16 @@ static void teardown_virtqueu=
es(struct
> > > > > > > mlx5_vdpa_net *ndev)
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > > > > >   =C2=A0 }
> > > > > > >   =C2=A0 +static void clear_virtqueues(struct mlx5_vdpa_net *=
ndev)
> > > > > > > +{
> > > > > > > +=C2=A0=C2=A0=C2=A0 int i;
> > > > > > > +
> > > > > > > +=C2=A0=C2=A0=C2=A0 for (i =3D ndev->mvdev.max_vqs - 1; i >=
=3D 0; i--) {
> > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev->vqs[i].avai=
l_idx =3D 0;
> > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ndev->vqs[i].used=
_idx =3D 0;
> > > > > > > +=C2=A0=C2=A0=C2=A0 }
> > > > > > > +}
> > > > > > > +
> > > > > > >   =C2=A0 /* TODO: cross-endian support */
> > > > > > >   =C2=A0 static inline bool mlx5_vdpa_is_little_endian(struct=
 mlx5_vdpa_dev
> > > > > > > *mvdev)
> > > > > > >   =C2=A0 {
> > > > > > > @@ -1610,6 +1625,7 @@ static int save_channel_info(struct
> > > > > > > mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn err;
> > > > > > >   =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->avail_index =3D a=
ttr.available_index;
> > > > > > > +=C2=A0=C2=A0=C2=A0 ri->used_index =3D attr.used_index;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->ready =3D mvq->ready;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->num_ent =3D mvq->num_ent=
;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ri->desc_addr =3D mvq->desc_=
addr;
> > > > > > > @@ -1654,6 +1670,7 @@ static void restore_channels_info(struc=
t
> > > > > > > mlx5_vdpa_net *ndev)
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 continue;
> > > > > > >   =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 mvq->avail_idx =3D ri->avail_index;
> > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mvq->used_idx =3D=
 ri->used_index;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mvq-=
>ready =3D ri->ready;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mvq-=
>num_ent =3D ri->num_ent;
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mvq-=
>desc_addr =3D ri->desc_addr;
> > > > > > > @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct
> > > > > > > vdpa_device *vdev, u8 status)
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!status) {
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mlx5=
_vdpa_info(mvdev, "performing device reset\n");
> > > > > > >   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tear=
down_driver(ndev);
> > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_virtqueues(=
ndev);
> > > > > > The clearing looks fine at the first glance, as it aligns with =
the other
> > > > > > state cleanups floating around at the same place. However, the =
thing is
> > > > > > get_vq_state() is supposed to be called right after to get sync=
'ed with
> > > > > > the latest internal avail_index from device while vq is stopped=
. The
> > > > > > index was saved in the driver software at vq suspension, but be=
fore the
> > > > > > virtq object is destroyed. We shouldn't clear the avail_index t=
oo early.
> > > > > Good point.
> > > > >=20
> > > > > There's a limitation on the virtio spec and vDPA framework that w=
e can not
> > > > > simply differ device suspending from device reset.
> > > > >=20
> > > > Are you talking about live migration where you reset the device but
> > > > still want to know how far it progressed in order to continue from =
the
> > > > same place in the new VM?
> > > Yes. So if we want to support live migration at we need:
> > >=20
> > > in src node:
> > > 1) suspend the device
> > > 2) get last_avail_idx via get_vq_state()
> > >=20
> > > in the dst node:
> > > 3) set last_avail_idx via set_vq_state()
> > > 4) resume the device
> > >=20
> > > So you can see, step 2 requires the device/driver not to forget the
> > > last_avail_idx.
> > >=20
> > Just to be sure, what really matters here is the used index. Becuase th=
e
> > vriqtueue itself is copied from the src VM to the dest VM. The availabl=
e
> > index is alreay there and we know the hardware reads it from there.
>=20
>=20
> So for "last_avail_idx" I meant the hardware internal avail index. It's n=
ot
> stored in the virtqueue so we must migrate it from src to dest and set th=
em
> through set_vq_state(). Then in the destination, the virtqueue can be
> restarted from that index.
>=20

Consider this case: driver posted buffers till avail index becomes the
value 50. Hardware is executing but made it till 20 when virtqueue was
suspended due to live migration - this is indicated by hardware used
index equal 20. Now the vritqueue is copied to the new VM and the
hardware now has to continue execution from index 20. We need to tell
the hardware via configuring the last used_index. So why don't we
restore the used index?

>=20
> >=20
> > So it puzzles me why is set_vq_state() we do not communicate the saved
> > used index.
>=20
>=20
> We don't do that since:
>=20
> 1) if the hardware can sync its internal used index from the virtqueue
> during device, then we don't need it
> 2) if the hardware can not sync its internal used index, the driver (e.g =
as
> you did here) can do that.
>=20
> But there's no way for the hardware to deduce the internal avail index fr=
om
> the virtqueue, that's why avail index is sycned.
>=20
> Thanks
>=20
>=20
> >=20
>=20
