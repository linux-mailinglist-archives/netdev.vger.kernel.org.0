Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2806E82C34
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbfHFHC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731557AbfHFHC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 03:02:28 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6097E20880;
        Tue,  6 Aug 2019 07:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565074947;
        bh=mXyXoPCvPht8EDRuwRdDh++mwnf1UvHf+4AK7SCVCUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F7yot5v+/UiW1YxPfYJ8tgj/AO/+N6Hp6eAzSfapfonZ6AeKRWv7ei3RTxqiKjWmS
         8/FzJ6wj2xpDopOCs3vZZfO1jH6rRh5ShaD09SyYdhHtUN/0eUhRdOVmI+zFOaA5e9
         Je55KNIDhjQtYEehycet2CNR+4Nm93zEp2YFJN6k=
Date:   Tue, 6 Aug 2019 10:02:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v1 1/3] IB/mlx5: Query ODP capabilities for DC
Message-ID: <20190806070223.GR4832@mtr-leonro.mtl.com>
References: <20190804100048.32671-1-leon@kernel.org>
 <20190804100048.32671-2-leon@kernel.org>
 <d3b21502d398fc3bf2cf38231ca84c1bb0386b17.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3b21502d398fc3bf2cf38231ca84c1bb0386b17.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 06:23:04PM +0000, Saeed Mahameed wrote:
> On Sun, 2019-08-04 at 13:00 +0300, Leon Romanovsky wrote:
> > From: Michael Guralnik <michaelgur@mellanox.com>
> >
> > Set current capabilities of ODP for DC to max capabilities and cache
> > them in mlx5_ib.
> >
> > Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> > Reviewed-by: Moni Shoua <monis@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h           |  1 +
> >  drivers/infiniband/hw/mlx5/odp.c               | 18
> > ++++++++++++++++++
> >  drivers/net/ethernet/mellanox/mlx5/core/main.c |  6 ++++++
> >  include/linux/mlx5/mlx5_ifc.h                  |  4 +++-
>
> Please avoid cross tree changes when you can..
> Here you do can avoid it, so please separate to two stage patches,
> mlx5_ifc and core, then mlx5_ib.
>
>
> >  4 files changed, 28 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > index cb41a7e6255a..f99c71b3c876 100644
> > --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > @@ -967,6 +967,7 @@ struct mlx5_ib_dev {
> >  	struct mutex			slow_path_mutex;
> >  	int				fill_delay;
> >  	struct ib_odp_caps	odp_caps;
> > +	uint32_t		dc_odp_caps;
> >  	u64			odp_max_size;
> >  	struct mlx5_ib_pf_eq	odp_pf_eq;
> >
> > diff --git a/drivers/infiniband/hw/mlx5/odp.c
> > b/drivers/infiniband/hw/mlx5/odp.c
> > index b0c5de39d186..5e87a5e25574 100644
> > --- a/drivers/infiniband/hw/mlx5/odp.c
> > +++ b/drivers/infiniband/hw/mlx5/odp.c
> > @@ -353,6 +353,24 @@ void mlx5_ib_internal_fill_odp_caps(struct
> > mlx5_ib_dev *dev)
> >  	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.srq_receive))
> >  		caps->per_transport_caps.xrc_odp_caps |=
> > IB_ODP_SUPPORT_SRQ_RECV;
> >
> > +	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.send))
> > +		dev->dc_odp_caps |= IB_ODP_SUPPORT_SEND;
> > +
> > +	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.receive))
> > +		dev->dc_odp_caps |= IB_ODP_SUPPORT_RECV;
> > +
> > +	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.write))
> > +		dev->dc_odp_caps |= IB_ODP_SUPPORT_WRITE;
> > +
> > +	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.read))
> > +		dev->dc_odp_caps |= IB_ODP_SUPPORT_READ;
> > +
> > +	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.atomic))
> > +		dev->dc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
> > +
> > +	if (MLX5_CAP_ODP(dev->mdev, dc_odp_caps.srq_receive))
> > +		dev->dc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
> > +
> >  	if (MLX5_CAP_GEN(dev->mdev, fixed_buffer_size) &&
> >  	    MLX5_CAP_GEN(dev->mdev, null_mkey) &&
> >  	    MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index b15b27a497fc..3995fc6d4d34 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -495,6 +495,12 @@ static int handle_hca_cap_odp(struct
> > mlx5_core_dev *dev)
> >  	ODP_CAP_SET_MAX(dev, xrc_odp_caps.write);
> >  	ODP_CAP_SET_MAX(dev, xrc_odp_caps.read);
> >  	ODP_CAP_SET_MAX(dev, xrc_odp_caps.atomic);
> > +	ODP_CAP_SET_MAX(dev, dc_odp_caps.srq_receive);
> > +	ODP_CAP_SET_MAX(dev, dc_odp_caps.send);
> > +	ODP_CAP_SET_MAX(dev, dc_odp_caps.receive);
> > +	ODP_CAP_SET_MAX(dev, dc_odp_caps.write);
> > +	ODP_CAP_SET_MAX(dev, dc_odp_caps.read);
> > +	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
> >
> >  	if (do_set)
> >  		err = set_caps(dev, set_ctx, set_sz,
> > diff --git a/include/linux/mlx5/mlx5_ifc.h
> > b/include/linux/mlx5/mlx5_ifc.h
> > index ec571fd7fcf8..5eae8d734435 100644
> > --- a/include/linux/mlx5/mlx5_ifc.h
> > +++ b/include/linux/mlx5/mlx5_ifc.h
> > @@ -944,7 +944,9 @@ struct mlx5_ifc_odp_cap_bits {
> >
> >  	struct mlx5_ifc_odp_per_transport_service_cap_bits
> > xrc_odp_caps;
> >
> > -	u8         reserved_at_100[0x700];
> > +	struct mlx5_ifc_odp_per_transport_service_cap_bits dc_odp_caps;
> > +
> > +	u8         reserved_at_100[0x6E0];
>
> reserved_at_100 should move 20 bit forward. i.e reserved_at_120

Thanks for pointing it, I'm sending new version now.

>
>
