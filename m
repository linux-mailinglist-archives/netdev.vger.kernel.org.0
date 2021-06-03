Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9255839A1EE
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhFCNO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhFCNO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 09:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA5A8613B8;
        Thu,  3 Jun 2021 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622725962;
        bh=8tSih8TQEldph7biZCjMKrsNnNHCD8lD50ZmP4OjqOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HWwdxsnwDy6prcdmSIEV0nkPPHl0DOXqnkHYngVt2dP5gOZQkB1VMnauT1l7QEqVi
         OHWau7iPqbFoypBecWrowAI9aasPD93DcvTwb7u20P+OR1tlGqAaYbkTxIPpz88dwX
         lsYNHZ0s1s6HFFD2D8bte4/vw69Cw12XBt/ZHpwP45T0JUUZVyNZokfzn3cP8BBl7U
         LqwNsXUuchCx1Yr/LSwbMR5BuD9TOaak6OJ9qn3W3lyUR/yV1YxvTXSk2qidEeK6Zs
         pGDT2Q0Pe/rlnvx3UoZAgwAO12miNIJHSV8nKSVTaLl0WrdQBxOdGblvQET3z3s0D1
         L37RcVYdiFl5A==
Date:   Thu, 3 Jun 2021 16:12:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: check for allocation failure in
 mlx5_ft_pool_init()
Message-ID: <YLjVRjAyP3UpzgVr@unreal>
References: <YLjNfHuTQ817oUtX@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLjNfHuTQ817oUtX@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 03:39:24PM +0300, Dan Carpenter wrote:
> Add a check for if the kzalloc() fails.
> 
> Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> index 526fbb669142..c14590acc772 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> @@ -27,6 +27,8 @@ int mlx5_ft_pool_init(struct mlx5_core_dev *dev)
>  	int i;
>  
>  	ft_pool = kzalloc(sizeof(*ft_pool), GFP_KERNEL);
> +	if (!ft_pool)
> +		return -ENOMEM;
>  
>  	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
>  		ft_pool->ft_left[i] = FT_SIZE / FT_POOLS[i];


Dan thanks for your patch.

When reviewed your patch, I spotted another error in the patch from the Fixes line.

  2955         err = mlx5_ft_pool_init(dev);
  2956         if (err)
  2957                 return err;
  2958
  2959         steering = kzalloc(sizeof(*steering), GFP_KERNEL);
  2960         if (!steering)
  2961                 goto err;
                       ^^^^^^^^ it will return success, while should return ENOMEM.

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
