Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F69336A525
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 08:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhDYGkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 02:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhDYGkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 02:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C4396113D;
        Sun, 25 Apr 2021 06:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619332772;
        bh=0o3GuEStuPPp6fhAZuQAurJbIkCnuOyJDSAE60E8ZZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k8uVJFmK9TeL94byE618v1RmX2TVpkekCbBNjNrnbNihMHrKtNdZ09yo55BHtpk1N
         2NDYB3bVwp3rILzEifCXzazG0NcriyPBY+6HuhO+IVPjuH4fb2rNKOxEDI0gB771v0
         zS++DL9Dvvi1lbNeOTLFUoaS4eigMIq0XtbKsrLJ5NkGjQBVEgQozJFb7XUPHe5GUE
         qab8QYNWpVa8hFk+i4Be0cfxQhtSQCxszCnZmQkCIbGz2iA9ZtXW2ex3X3KplcdCyU
         O9UIgGx241YCOPb0xcUQK9UJY3YWS1Zj8OCHApTqXhcRKLTN9GIHZAM5yVySKeqCwR
         uPlZTWDlTS08Q==
Date:   Sun, 25 Apr 2021 09:39:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix some error messages
Message-ID: <YIUOoTKRwy3UTRWz@unreal>
References: <YIKywXhusLj4cDFM@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIKywXhusLj4cDFM@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 02:42:57PM +0300, Dan Carpenter wrote:
> This code was using IS_ERR() instead of PTR_ERR() so it prints 1 instead
> of the correct error code.
> 
> Fixes: 25cb31768042 ("net/mlx5: E-Switch, Improve error messages in term table creation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  .../mellanox/mlx5/core/eswitch_offloads_termtbl.c    | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>

It should go through netdev@.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com> 


> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> index a81ece94f599..95f5c1a27718 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> @@ -83,16 +83,16 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
>  	ft_attr.autogroup.max_num_groups = 1;
>  	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
>  	if (IS_ERR(tt->termtbl)) {
> -		esw_warn(dev, "Failed to create termination table (error %d)\n",
> -			 IS_ERR(tt->termtbl));
> +		esw_warn(dev, "Failed to create termination table (error %ld)\n",
> +			 PTR_ERR(tt->termtbl));
>  		return -EOPNOTSUPP;
>  	}
>  
>  	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
>  				       &tt->dest, 1);
>  	if (IS_ERR(tt->rule)) {
> -		esw_warn(dev, "Failed to create termination table rule (error %d)\n",
> -			 IS_ERR(tt->rule));
> +		esw_warn(dev, "Failed to create termination table rule (error %ld)\n",
> +			 PTR_ERR(tt->rule));
>  		goto add_flow_err;
>  	}
>  	return 0;
> @@ -283,8 +283,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
>  		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
>  						     &dest[i], attr);
>  		if (IS_ERR(tt)) {
> -			esw_warn(esw->dev, "Failed to get termination table (error %d)\n",
> -				 IS_ERR(tt));
> +			esw_warn(esw->dev, "Failed to get termination table (error %ld)\n",
> +				 PTR_ERR(tt));
>  			goto revert_changes;
>  		}
>  		attr->dests[num_vport_dests].termtbl = tt;
> -- 
> 2.30.2
> 
