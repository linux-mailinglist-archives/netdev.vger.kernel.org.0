Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A1D30A225
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 07:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhBAGnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 01:43:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1869 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhBAGjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 01:39:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6017a1f10002>; Sun, 31 Jan 2021 22:38:41 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 1 Feb 2021 06:38:39 +0000
Date:   Mon, 1 Feb 2021 08:38:35 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH 2/2] vdpa/mlx5: Restore the hardware used index after
 change map
Message-ID: <20210201063835.GA185985@mtl-vdi-166.wap.labs.mlnx>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-3-elic@nvidia.com>
 <54239b51-918c-3475-dc88-4da1a4548da8@redhat.com>
 <20210131185536.GA164217@mtl-vdi-166.wap.labs.mlnx>
 <0c99f35c-7644-7201-cd11-7d486389a182@redhat.com>
 <20210201055247.GA184807@mtl-vdi-166.wap.labs.mlnx>
 <c013407d-7a6a-adaa-efd1-24a8a48dc6fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c013407d-7a6a-adaa-efd1-24a8a48dc6fa@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612161521; bh=5/cE2NmOKI53qlVOKIPKA37rkS35FmddvONKG415IPQ=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=l99NB0y0SVYxOlC+pni2ftu93PIPlXt2CQE5uxH0Cmletz5k1TnvyyuabBEz0VTjK
         gB0nXIHkPFt4voGoD7BGRwYgl7DFfEtNjRtAPHXC22Ezq/YZe3Bp+60BjKgKXCPivI
         WSd98xpO+Fj5TduGmt8FVldT7xjhmhwKuLXBj/ZHJ6jTshuUsezCfDe8Lccp8fulWc
         YHYOkVOE0W4mo/MPfQ+NjAoC0S2saLS5FWf8ievzj6OE9TjfJq7cScvr4d7/0DSaYb
         trvL3YLN4Loy4QD8+kBVWpeVDvRhQgpHJo0A/5/2inHAb4vs95kG5ausphwNDORvUl
         0hYMLWFH1aLlg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 02:00:35PM +0800, Jason Wang wrote:
>=20
> On 2021/2/1 =E4=B8=8B=E5=8D=881:52, Eli Cohen wrote:
> > On Mon, Feb 01, 2021 at 11:36:23AM +0800, Jason Wang wrote:
> > > On 2021/2/1 =E4=B8=8A=E5=8D=882:55, Eli Cohen wrote:
> > > > On Fri, Jan 29, 2021 at 11:49:45AM +0800, Jason Wang wrote:
> > > > > On 2021/1/28 =E4=B8=8B=E5=8D=889:41, Eli Cohen wrote:
> > > > > > When a change of memory map occurs, the hardware resources are =
destroyed
> > > > > > and then re-created again with the new memory map. In such case=
, we need
> > > > > > to restore the hardware available and used indices. The driver =
failed to
> > > > > > restore the used index which is added here.
> > > > > >=20
> > > > > > Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported m=
lx5 devices")
> > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > A question. Does this mean after a vq is suspended, the hw used i=
ndex is not
> > > > > equal to vq used index?
> > > > Surely there is just one "Used index" for a VQ. What I was trying t=
o say
> > > > is that after the VQ is suspended, I read the used index by queryin=
g the
> > > > hardware. The read result is the used index that the hardware wrote=
 to
> > > > memory.
> > >=20
> > > Just to make sure I understand here. So it looks to me we had two ind=
ex. The
> > > first is the used index which is stored in the memory/virtqueue, the =
second
> > > is the one that is stored by the device.
> > >=20
> > It is the structures defined in the virtio spec in 2.6.6 for the
> > available ring and 2.6.8 for the used ring. As you know these the
> > available ring is written to by the driver and read by the device. The
> > opposite happens for the used index.
>=20
>=20
> Right, so for used index it was wrote by device. And the device should ha=
ve
> an internal used index value that is used to write to the used ring. And =
the
> code is used to sync the device internal used index if I understand this
> correctly.
>=20
>=20
> > The reason I need to restore the last known indices is for the new
> > hardware objects to sync on the last state and take over from there.
>=20
>=20
> Right, after the vq suspending, the questions are:
>=20
> 1) is hardware internal used index might not be the same with the used in=
dex
> in the virtqueue?
>=20

Generally the answer is no because the hardware is the only one writing
it. New objects start up with the initial value configured to them upon
creation. This value was zero before this change.
You could argue that since the hardware has access to virtqueue memory,
it could just read the value from there but it does not.

> or
>=20
> 2) can we simply sync the virtqueue's used index to the hardware's used
> index?
>=20
Theoretically it could be done but that's not how the hardware works.
One reason is that is not supposed to read from that area. But it is
really hardware implementation detail.
> >=20
> > > >    After the I create the new hardware object, I need to tell it
> > > > what is the used index (and the available index) as a way to sync i=
t
> > > > with the existing VQ.
> > >=20
> > > For avail index I understand that the hardware index is not synced wi=
th the
> > > avail index stored in the memory/virtqueue. The question is used inde=
x, if
> > > the hardware one is not synced with the one in the virtqueue. It mean=
s after
> > > vq is suspended,=C2=A0 some requests is not completed by the hardware=
 (e.g the
> > > buffer were not put to used ring).
> > >=20
> > > This may have implications to live migration, it means those unaccomp=
lished
> > > requests needs to be migrated to the destination and resubmitted to t=
he
> > > device. This looks not easy.
> > >=20
> > > Thanks
> > >=20
> > >=20
> > > > This sync is especially important when a change of map occurs while=
 the
> > > > VQ was already used (hence the indices are likely to be non zero). =
This
> > > > can be triggered by hot adding memory after the VQs have been used.
> > > >=20
> > > > > Thanks
> > > > >=20
> > > > >=20
> > > > > > ---
> > > > > >     drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
> > > > > >     1 file changed, 7 insertions(+)
> > > > > >=20
> > > > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/m=
lx5/net/mlx5_vnet.c
> > > > > > index 549ded074ff3..3fc8588cecae 100644
> > > > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > > > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> > > > > >     	u64 device_addr;
> > > > > >     	u64 driver_addr;
> > > > > >     	u16 avail_index;
> > > > > > +	u16 used_index;
> > > > > >     	bool ready;
> > > > > >     	struct vdpa_callback cb;
> > > > > >     	bool restore;
> > > > > > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> > > > > >     	u32 virtq_id;
> > > > > >     	struct mlx5_vdpa_net *ndev;
> > > > > >     	u16 avail_idx;
> > > > > > +	u16 used_idx;
> > > > > >     	int fw_state;
> > > > > >     	/* keep last in the struct */
> > > > > > @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdp=
a_net *ndev, struct mlx5_vdpa_virtque
> > > > > >     	obj_context =3D MLX5_ADDR_OF(create_virtio_net_q_in, in, o=
bj_context);
> > > > > >     	MLX5_SET(virtio_net_q_object, obj_context, hw_available_in=
dex, mvq->avail_idx);
> > > > > > +	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq=
->used_idx);
> > > > > >     	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_b=
it_mask_12_3,
> > > > > >     		 get_features_12_3(ndev->mvdev.actual_features));
> > > > > >     	vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_object, obj_context, =
virtio_q_context);
> > > > > > @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_n=
et *ndev, struct mlx5_vdpa_virtqueue *m
> > > > > >     struct mlx5_virtq_attr {
> > > > > >     	u8 state;
> > > > > >     	u16 available_index;
> > > > > > +	u16 used_index;
> > > > > >     };
> > > > > >     static int query_virtqueue(struct mlx5_vdpa_net *ndev, stru=
ct mlx5_vdpa_virtqueue *mvq,
> > > > > > @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vd=
pa_net *ndev, struct mlx5_vdpa_virtqueu
> > > > > >     	memset(attr, 0, sizeof(*attr));
> > > > > >     	attr->state =3D MLX5_GET(virtio_net_q_object, obj_context,=
 state);
> > > > > >     	attr->available_index =3D MLX5_GET(virtio_net_q_object, ob=
j_context, hw_available_index);
> > > > > > +	attr->used_index =3D MLX5_GET(virtio_net_q_object, obj_contex=
t, hw_used_index);
> > > > > >     	kfree(out);
> > > > > >     	return 0;
> > > > > > @@ -1602,6 +1607,7 @@ static int save_channel_info(struct mlx5_=
vdpa_net *ndev, struct mlx5_vdpa_virtqu
> > > > > >     		return err;
> > > > > >     	ri->avail_index =3D attr.available_index;
> > > > > > +	ri->used_index =3D attr.used_index;
> > > > > >     	ri->ready =3D mvq->ready;
> > > > > >     	ri->num_ent =3D mvq->num_ent;
> > > > > >     	ri->desc_addr =3D mvq->desc_addr;
> > > > > > @@ -1646,6 +1652,7 @@ static void restore_channels_info(struct =
mlx5_vdpa_net *ndev)
> > > > > >     			continue;
> > > > > >     		mvq->avail_idx =3D ri->avail_index;
> > > > > > +		mvq->used_idx =3D ri->used_index;
> > > > > >     		mvq->ready =3D ri->ready;
> > > > > >     		mvq->num_ent =3D ri->num_ent;
> > > > > >     		mvq->desc_addr =3D ri->desc_addr;
>=20
