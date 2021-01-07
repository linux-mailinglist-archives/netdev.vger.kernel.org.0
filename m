Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E188D2ECA54
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 07:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbhAGGH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 01:07:57 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3452 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAGGH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 01:07:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff6a5140000>; Wed, 06 Jan 2021 22:07:16 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Thu, 7 Jan 2021 06:07:14 +0000
Date:   Thu, 7 Jan 2021 08:07:10 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH] vdpa/mlx5: Fix memory key MTT population
Message-ID: <20210107060710.GA222154@mtl-vdi-166.wap.labs.mlnx>
References: <20210106090557.GA170338@mtl-vdi-166.wap.labs.mlnx>
 <2d16b2af-f25a-d786-7d24-da45c0dcefaa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2d16b2af-f25a-d786-7d24-da45c0dcefaa@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609999636; bh=AfzezDcZPx0F0UhbBHRyh/t71tgrlkqywFR9ZTgRWVs=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=ZgRR/RGq/RkPMsPHhoMvClKshFDaCiABiu9YJ7g4VU7+3qeyMAyrUA1N+kGj81lYw
         A+5I9AuXcZhibVhbfkdDSnKVGhvKEPjZqMLDDgyj6RfD1J79eNtq4XxA678PxUoViq
         7hG8EPa+2D2z0WX8QSrjRJrHp99GoJS5DWBOAaAicAFa+9leDXiXbFsyzy3hPmTbt4
         Tk7zAuo3Dh0/HGGMevlI9ouD/bid5+zFw/f25c7WSw7/GW1bdXiEsZMMGds6TyXSW8
         BTl3JpRWWattQBMggEE3cCdvSOgOsan3jsMfN5Wq5Fg/bEDkLsI0zL/mlFhGYdE3q2
         LVnS4MVB969KQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 12:15:53PM +0800, Jason Wang wrote:
>=20
> On 2021/1/6 =E4=B8=8B=E5=8D=885:05, Eli Cohen wrote:
> > map_direct_mr() assumed that the number of scatter/gather entries
> > returned by dma_map_sg_attrs() was equal to the number of segments in
> > the sgl list. This led to wrong population of the mkey object. Fix this
> > by properly referring to the returned value.
> >=20
> > In addition, get rid of fill_sg() whjich effect is overwritten bu
> > populate_mtts().
>=20
>=20
> Typo.
>=20
Will fix, thanks.
>=20
> >=20
> > Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
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
>=20
>=20
> It looks to me the mtt entry is also limited by log_size. It's better to
> explain this a little bit in the commit log.

Actually, each MTT entry covers (1 << mr->log_size) contiguous memory.
I will add an explanation.

>=20
> Thanks
>=20
>=20
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
