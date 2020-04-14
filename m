Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605FD1A749E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 09:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406575AbgDNHYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 03:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406564AbgDNHX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 03:23:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF58820767;
        Tue, 14 Apr 2020 07:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586849038;
        bh=D07m4fpqEjO/Iudug981COMVjGEt/A3C9JrJLbpVNNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1aVZFdsL502lTOSuVV0rwZAoKoN5q82FHswQqC5wHSN5XlCBg/VPXF7mpxDwgVIw
         w46BYpUzEYwPZpMrODyJbppdZRlbT2su/MANjQb0d2IybDZ9eDSL6kWRIlCyzRimbg
         2WEWUkQHGxTbvbb7rmxF9I4oZ6F3qX62gA69RloY=
Date:   Tue, 14 Apr 2020 10:23:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v2 1/6] net/mlx5: Refactor HCA capability set
 flow
Message-ID: <20200414072355.GV334007@unreal>
References: <20200413133703.932731-1-leon@kernel.org>
 <20200413133703.932731-2-leon@kernel.org>
 <d71ef1d027b8d0cfec345d68788351b15b0e782f.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d71ef1d027b8d0cfec345d68788351b15b0e782f.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 08:47:39PM +0000, Saeed Mahameed wrote:
> On Mon, 2020-04-13 at 16:36 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Reduce the amount of kzalloc/kfree cycles by allocating
> > command structure in the parent function and leverage the
> > knowledge that set_caps() is called for HCA capabilities
> > only with specific HW structure as parameter to calculate
> > mailbox size.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 66 +++++++--------
> > ----
> >  1 file changed, 24 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index 7af4210c1b96..8b9182add689 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -407,20 +407,19 @@ int mlx5_core_get_caps(struct mlx5_core_dev
> > *dev, enum mlx5_cap_type cap_type)
> >  	return mlx5_core_get_caps_mode(dev, cap_type,
> > HCA_CAP_OPMOD_GET_MAX);
> >  }
> >
> > -static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz,
> > int opmod)
> > +static int set_caps(struct mlx5_core_dev *dev, void *in, int opmod)
> >  {
> > -	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)] = {0};
> > +	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)] = {};
> >
> >  	MLX5_SET(set_hca_cap_in, in, opcode, MLX5_CMD_OP_SET_HCA_CAP);
> >  	MLX5_SET(set_hca_cap_in, in, op_mod, opmod << 1);
> > -	return mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
> > +	return mlx5_cmd_exec(dev, in, MLX5_ST_SZ_BYTES(set_hca_cap_in),
> > out,
> > +			     sizeof(out));
> >  }
> >
> > -static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
> > +static int handle_hca_cap_atomic(struct mlx5_core_dev *dev, void
> > *set_ctx)
> >  {
> > -	void *set_ctx;
> >  	void *set_hca_cap;
> > -	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> >  	int req_endianness;
> >  	int err;
> >
> > @@ -439,27 +438,19 @@ static int handle_hca_cap_atomic(struct
> > mlx5_core_dev *dev)
> >  	if (req_endianness != MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS)
> >  		return 0;
> >
> > -	set_ctx = kzalloc(set_sz, GFP_KERNEL);
> > -	if (!set_ctx)
> > -		return -ENOMEM;
> > -
> >  	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
> > capability);
> >
> >  	/* Set requestor to host endianness */
> >  	MLX5_SET(atomic_caps, set_hca_cap,
> > atomic_req_8B_endianness_mode,
> >  		 MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS);
> >
> > -	err = set_caps(dev, set_ctx, set_sz,
> > MLX5_SET_HCA_CAP_OP_MOD_ATOMIC);
> > -
> > -	kfree(set_ctx);
> > +	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ATOMIC);
> >  	return err;
> >  }
> >
> > -static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
> > +static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void
> > *set_ctx)
> >  {
> >  	void *set_hca_cap;
> > -	void *set_ctx;
> > -	int set_sz;
> >  	bool do_set = false;
> >  	int err;
> >
> > @@ -471,11 +462,6 @@ static int handle_hca_cap_odp(struct
> > mlx5_core_dev *dev)
> >  	if (err)
> >  		return err;
> >
> > -	set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> > -	set_ctx = kzalloc(set_sz, GFP_KERNEL);
> > -	if (!set_ctx)
> > -		return -ENOMEM;
> > -
> >  	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
> > capability);
> >  	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ODP],
> >  	       MLX5_ST_SZ_BYTES(odp_cap));
> > @@ -505,29 +491,20 @@ static int handle_hca_cap_odp(struct
> > mlx5_core_dev *dev)
> >  	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
> >
> >  	if (do_set)
>
> assigning to err is now redundant in all of the functions and the next
> patch.
>
> you can do early exits when required and then just "return set_caps();"
>
>
> in this example:
>
>        if (!do_set)
>            return 0;
>
>        return set_caps(...);
>
>
> > -		err = set_caps(dev, set_ctx, set_sz,
> > -			       MLX5_SET_HCA_CAP_OP_MOD_ODP);
> > -
> > -	kfree(set_ctx);
> > +		err = set_caps(dev, set_ctx,
> > MLX5_SET_HCA_CAP_OP_MOD_ODP);
> >
> >  	return err;
> >  }
> >
> > -static int handle_hca_cap(struct mlx5_core_dev *dev)
> > +static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
> >  {
> > -	void *set_ctx = NULL;
> >  	struct mlx5_profile *prof = dev->profile;
> > -	int err = -ENOMEM;
> > -	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> >  	void *set_hca_cap;
> > -
> > -	set_ctx = kzalloc(set_sz, GFP_KERNEL);
> > -	if (!set_ctx)
> > -		goto query_ex;
> > +	int err;
> >
> >  	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
> >  	if (err)
> > -		goto query_ex;
> > +		return err;
> >
> >  	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
> >  				   capability);
> > @@ -578,37 +555,42 @@ static int handle_hca_cap(struct mlx5_core_dev
> > *dev)
> >  			 num_vhca_ports,
> >  			 MLX5_CAP_GEN_MAX(dev, num_vhca_ports));
> >
> > -	err = set_caps(dev, set_ctx, set_sz,
> > -		       MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
> > -
> > -query_ex:
> > -	kfree(set_ctx);
> > +	err = set_caps(dev, set_ctx,
> > MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
> >  	return err;
>
> just return set_caps();
>
> other than this the series is ok,
>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>

Thanks, I'll fix while will take to mlx5-next.
