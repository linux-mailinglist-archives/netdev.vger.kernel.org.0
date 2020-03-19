Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1418AC9F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 07:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgCSGF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 02:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgCSGF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 02:05:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3695C2072D;
        Thu, 19 Mar 2020 06:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584597927;
        bh=cu6QOsTdFpV1dvcoCLlqx9Ie5kGBcJiZHB87PiL6e7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=daNScO3bGDcgVbOURzHTPbVa3wuzM7JWt82BYMQ6TAAN3WpRMBmn9sEPQYBBmORtU
         /VWHqVxL6dKp752vV7rGbA8IMgeIaDayjwTGI1wWD5ba5YyOYxXGASD0NBsgsk8JfE
         dCWo6bTng0lUmhMqLJVwJq7GcaAFrIEc9WJNhqR8=
Date:   Thu, 19 Mar 2020 08:05:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/6] net/mlx5: Enable SW-defined RoCEv2 UDP
 source port
Message-ID: <20200319060524.GG126814@unreal>
References: <20200318095300.45574-1-leon@kernel.org>
 <20200318095300.45574-2-leon@kernel.org>
 <56a58821295022d4726abcecb879ade05ecf45cd.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56a58821295022d4726abcecb879ade05ecf45cd.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:33:46PM +0000, Saeed Mahameed wrote:
> On Wed, 2020-03-18 at 11:52 +0200, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > When this is enabled, UDP source port for RoCEv2 packets are defined
> > by software instead of firmware.
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 39
> > +++++++++++++++++++
> >  include/linux/mlx5/mlx5_ifc.h                 |  5 ++-
> >  2 files changed, 43 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index 6b38ec72215a..bdc73370297b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -585,6 +585,39 @@ static int handle_hca_cap(struct mlx5_core_dev
> > *dev)
> >  	return err;
> >  }
> >
> > +static int handle_hca_cap_roce(struct mlx5_core_dev *dev)
> > +{
> > +	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> > +	void *set_hca_cap;
> > +	void *set_ctx;
> > +	int err;
> > +
> > +	if (!MLX5_CAP_GEN(dev, roce))
> > +		return 0;
> > +
> > +	err = mlx5_core_get_caps(dev, MLX5_CAP_ROCE);
> > +	if (err)
> > +		return err;
> > +
> > +	if (MLX5_CAP_ROCE(dev, sw_r_roce_src_udp_port) ||
> > +	    !MLX5_CAP_ROCE_MAX(dev, sw_r_roce_src_udp_port))
> > +		return 0;
> > +
> > +	set_ctx = kzalloc(set_sz, GFP_KERNEL);
> > +	if (!set_ctx)
> > +		return -ENOMEM;
> > +
>
> all the sisters of this function allocate this and free it
> consecutively, why not allocate it from outside once, pass it to all
> handle_hca_cap_xyz functions, each one will memset it and reuse it.
> see below.

Agree, I'll do it.

>
> > +	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
> > capability);
> > +	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ROCE],
> > +	       MLX5_ST_SZ_BYTES(roce_cap));
> > +	MLX5_SET(roce_cap, set_hca_cap, sw_r_roce_src_udp_port, 1);
> > +
> > +	err = set_caps(dev, set_ctx, set_sz,
> > MLX5_SET_HCA_CAP_OP_MOD_ROCE);
> > +
>
> Do we really need to fail the whole driver if we just try to set a non
> mandatory cap ?

It is less important what caused to failure, but the fact that basic
mlx5_cmd_exec() failed during initialization flow. I think that it
is bad enough to stop the driver, because its operation is going to
be unreliable.

Please share your end-result decision on that and I'll align to it.

>
> > +	kfree(set_ctx);
> > +	return err;
> > +}
> > +
> >  static int set_hca_cap(struct mlx5_core_dev *dev)
> >  {
> >  	int err;
>
> let's allocate the set_ctx in this parent function and pass it to all
> hca cap handlers;
>
> set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> set_ctx = kzalloc(set_sz, GFP_KERNEL);

I'm doing it now.

Thanks
