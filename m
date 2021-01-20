Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0165B2FCAC7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 06:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbhATFhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 00:37:41 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16331 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbhATFhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 00:37:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007c1590000>; Tue, 19 Jan 2021 21:36:25 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 20 Jan 2021 05:36:23 +0000
Date:   Wed, 20 Jan 2021 07:36:19 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH v1] vdpa/mlx5: Fix memory key MTT population
Message-ID: <20210120053619.GA126435@mtl-vdi-166.wap.labs.mlnx>
References: <20210107071845.GA224876@mtl-vdi-166.wap.labs.mlnx>
 <07d336a3-7fc2-5e4a-667a-495b5bb755da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <07d336a3-7fc2-5e4a-667a-495b5bb755da@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611120985; bh=az/GvfNGCDzf8VgYLksXW/TwCFI4flvkd4SNhWpdtJA=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=ZxxebaZGkizFVUDKbndYJmRBniNv5kJCwckcfSwpzBh0yplDzhlgWuOqLDJ2HXZAV
         3NctYnmLwXb1DjBIiVN+ZFDUVg7b/wVkopRqHaqZW2IrlsLOJexOvFbld6LA18mQxX
         88Pfdcs1jpkhcBxDzr8ITlJjfhuyJMV/Twl9E2JqmyG4FdWpxD4xbCXGOQTA2v1W3n
         ofSEztha3OkfwA8GFf6ljN4IFNKDcVm/wekW2OAMBDJiaDXDIlqKoffVdtxPUxi3Jz
         HhLxt65+dhzlUmHfdpKcw240FDnAQPNDQvyUph9fmaGVT+H+DQpROUYVbxzdJap29I
         GnBc9xkXywMGg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 04:38:55PM +0800, Jason Wang wrote:

Hi Michael,
this patch is a fix. Are you going to merge it?

>=20
> On 2021/1/7 =E4=B8=8B=E5=8D=883:18, Eli Cohen wrote:
> > map_direct_mr() assumed that the number of scatter/gather entries
> > returned by dma_map_sg_attrs() was equal to the number of segments in
> > the sgl list. This led to wrong population of the mkey object. Fix this
> > by properly referring to the returned value.
> >=20
> > The hardware expects each MTT entry to contain the DMA address of a
> > contiguous block of memory of size (1 << mr->log_size) bytes.
> > dma_map_sg_attrs() can coalesce several sg entries into a single
> > scatter/gather entry of contiguous DMA range so we need to scan the lis=
t
> > and refer to the size of each s/g entry.
> >=20
> > In addition, get rid of fill_sg() which effect is overwritten by
> > populate_mtts().
> >=20
> > Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> > V0->V1:
> > 1. Fix typos
> > 2. Improve changelog
>=20
>=20
> Acked-by: Jason Wang <jasowang@redhat.com>
>=20
>=20
> >=20
> >   drivers/vdpa/mlx5/core/mlx5_vdpa.h |  1 +
> >   drivers/vdpa/mlx5/core/mr.c        | 28 ++++++++++++----------------
> >   2 files changed, 13 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/cor=
e/mlx5_vdpa.h
> > index 5c92a576edae..08f742fd2409 100644
> > --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > @@ -15,6 +15,7 @@ struct mlx5_vdpa_direct_mr {
> >   	struct sg_table sg_head;
> >   	int log_size;
> >   	int nsg;
> > +	int nent;
> >   	struct list_head list;
> >   	u64 offset;
> >   };
> > diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> > index 4b6195666c58..d300f799efcd 100644
> > --- a/drivers/vdpa/mlx5/core/mr.c
> > +++ b/drivers/vdpa/mlx5/core/mr.c
> > @@ -25,17 +25,6 @@ static int get_octo_len(u64 len, int page_shift)
> >   	return (npages + 1) / 2;
> >   }
> > -static void fill_sg(struct mlx5_vdpa_direct_mr *mr, void *in)
> > -{
> > -	struct scatterlist *sg;
> > -	__be64 *pas;
> > -	int i;
> > -
> > -	pas =3D MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
> > -	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
> > -		(*pas) =3D cpu_to_be64(sg_dma_address(sg));
> > -}
> > -
> >   static void mlx5_set_access_mode(void *mkc, int mode)
> >   {
> >   	MLX5_SET(mkc, mkc, access_mode_1_0, mode & 0x3);
> > @@ -45,10 +34,18 @@ static void mlx5_set_access_mode(void *mkc, int mod=
e)
> >   static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt=
)
> >   {
> >   	struct scatterlist *sg;
> > +	int nsg =3D mr->nsg;
> > +	u64 dma_addr;
> > +	u64 dma_len;
> > +	int j =3D 0;
> >   	int i;
> > -	for_each_sg(mr->sg_head.sgl, sg, mr->nsg, i)
> > -		mtt[i] =3D cpu_to_be64(sg_dma_address(sg));
> > +	for_each_sg(mr->sg_head.sgl, sg, mr->nent, i) {
> > +		for (dma_addr =3D sg_dma_address(sg), dma_len =3D sg_dma_len(sg);
> > +		     nsg && dma_len;
> > +		     nsg--, dma_addr +=3D BIT(mr->log_size), dma_len -=3D BIT(mr->lo=
g_size))
> > +			mtt[j++] =3D cpu_to_be64(dma_addr);
> > +	}
> >   }
> >   static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_=
vdpa_direct_mr *mr)
> > @@ -64,7 +61,6 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvd=
ev, struct mlx5_vdpa_direct
> >   		return -ENOMEM;
> >   	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
> > -	fill_sg(mr, in);
> >   	mkc =3D MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
> >   	MLX5_SET(mkc, mkc, lw, !!(mr->perm & VHOST_MAP_WO));
> >   	MLX5_SET(mkc, mkc, lr, !!(mr->perm & VHOST_MAP_RO));
> > @@ -276,8 +272,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvde=
v, struct mlx5_vdpa_direct_mr
> >   done:
> >   	mr->log_size =3D log_entity_size;
> >   	mr->nsg =3D nsg;
> > -	err =3D dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTI=
ONAL, 0);
> > -	if (!err)
> > +	mr->nent =3D dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDI=
RECTIONAL, 0);
> > +	if (!mr->nent)
> >   		goto err_map;
> >   	err =3D create_direct_mr(mvdev, mr);
>=20
