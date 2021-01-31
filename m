Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF089309EE1
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhAaUYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 15:24:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2430 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhAaTbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 14:31:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6016fd2e0000>; Sun, 31 Jan 2021 10:55:42 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Sun, 31 Jan 2021 18:55:40 +0000
Date:   Sun, 31 Jan 2021 20:55:36 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH 2/2] vdpa/mlx5: Restore the hardware used index after
 change map
Message-ID: <20210131185536.GA164217@mtl-vdi-166.wap.labs.mlnx>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-3-elic@nvidia.com>
 <54239b51-918c-3475-dc88-4da1a4548da8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <54239b51-918c-3475-dc88-4da1a4548da8@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612119342; bh=20jyDUxM3u6To5ZNhKPEZ3YUoNNoC+gbiffimVvanx4=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=AlSbCP5A1I0Kpd2HcPUrt4tbc8oXxZ3oBAHBUcIRE7EnB6KsgVRxGLJ52Qyf2kPiz
         Hz/aTPetreiL7pt6RfXkmpfYZUaRMUhcFBfWT7+RuXL3oM+Oebq8ow158TE2Fga/G2
         7KAZNOOytNfPA97Yn4ejgwMquzwYveN0byMIlE+bmq9JrnYhEuSyMUfHdaZuyAuVWU
         iotc6LnFG9EFghPWIqmZSkdyRAMd4ZzEmtMPHxa9BpfMjnf7lWgv5w4ZRXjoeZZSIG
         f3ETdPTvjFwsOMilF1OPOaZEZZ2VTAD8TvoEGDAjT8cEeG/FEe85hwgYR6JbG9AkV6
         LZGCEuYdEcsIw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 11:49:45AM +0800, Jason Wang wrote:
>=20
> On 2021/1/28 =E4=B8=8B=E5=8D=889:41, Eli Cohen wrote:
> > When a change of memory map occurs, the hardware resources are destroye=
d
> > and then re-created again with the new memory map. In such case, we nee=
d
> > to restore the hardware available and used indices. The driver failed t=
o
> > restore the used index which is added here.
> >=20
> > Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devi=
ces")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
>=20
>=20
> A question. Does this mean after a vq is suspended, the hw used index is =
not
> equal to vq used index?

Surely there is just one "Used index" for a VQ. What I was trying to say
is that after the VQ is suspended, I read the used index by querying the
hardware. The read result is the used index that the hardware wrote to
memory. After the I create the new hardware object, I need to tell it
what is the used index (and the available index) as a way to sync it
with the existing VQ.

This sync is especially important when a change of map occurs while the
VQ was already used (hence the indices are likely to be non zero). This
can be triggered by hot adding memory after the VQs have been used.=20

>=20
> Thanks
>=20
>=20
> > ---
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >=20
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 549ded074ff3..3fc8588cecae 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> >   	u64 device_addr;
> >   	u64 driver_addr;
> >   	u16 avail_index;
> > +	u16 used_index;
> >   	bool ready;
> >   	struct vdpa_callback cb;
> >   	bool restore;
> > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> >   	u32 virtq_id;
> >   	struct mlx5_vdpa_net *ndev;
> >   	u16 avail_idx;
> > +	u16 used_idx;
> >   	int fw_state;
> >   	/* keep last in the struct */
> > @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *n=
dev, struct mlx5_vdpa_virtque
> >   	obj_context =3D MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context=
);
> >   	MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->=
avail_idx);
> > +	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_i=
dx);
> >   	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12=
_3,
> >   		 get_features_12_3(ndev->mvdev.actual_features));
> >   	vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_c=
ontext);
> > @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev=
, struct mlx5_vdpa_virtqueue *m
> >   struct mlx5_virtq_attr {
> >   	u8 state;
> >   	u16 available_index;
> > +	u16 used_index;
> >   };
> >   static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vd=
pa_virtqueue *mvq,
> > @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *=
ndev, struct mlx5_vdpa_virtqueu
> >   	memset(attr, 0, sizeof(*attr));
> >   	attr->state =3D MLX5_GET(virtio_net_q_object, obj_context, state);
> >   	attr->available_index =3D MLX5_GET(virtio_net_q_object, obj_context,=
 hw_available_index);
> > +	attr->used_index =3D MLX5_GET(virtio_net_q_object, obj_context, hw_us=
ed_index);
> >   	kfree(out);
> >   	return 0;
> > @@ -1602,6 +1607,7 @@ static int save_channel_info(struct mlx5_vdpa_net=
 *ndev, struct mlx5_vdpa_virtqu
> >   		return err;
> >   	ri->avail_index =3D attr.available_index;
> > +	ri->used_index =3D attr.used_index;
> >   	ri->ready =3D mvq->ready;
> >   	ri->num_ent =3D mvq->num_ent;
> >   	ri->desc_addr =3D mvq->desc_addr;
> > @@ -1646,6 +1652,7 @@ static void restore_channels_info(struct mlx5_vdp=
a_net *ndev)
> >   			continue;
> >   		mvq->avail_idx =3D ri->avail_index;
> > +		mvq->used_idx =3D ri->used_index;
> >   		mvq->ready =3D ri->ready;
> >   		mvq->num_ent =3D ri->num_ent;
> >   		mvq->desc_addr =3D ri->desc_addr;
>=20
