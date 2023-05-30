Return-Path: <netdev+bounces-6208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8E8715302
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B498280EEE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B358A51;
	Tue, 30 May 2023 01:41:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2443A80D
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2659DC433D2;
	Tue, 30 May 2023 01:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685410880;
	bh=YmLS8XHJhN7TiIXbCwAAk6rvkMAI25tx7VRPVlsGPCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=epHDp6R77pwIH1tVOWDex0ZbQ4m0lmmVg76NLbW+1dbW004AYUvhm2Gme7VMKmNa+
	 m5lm236yEUpk6zfPBqwLJIXGbVv7u7HhU23+FOS4tRR+KFAC42RMyO+ZpfaNGcYJ7+
	 sqr6doooBxJNWVtMVTiLI8es4mqHL0/DjpXo4spe4hcs1DfVCRIwTWm8RFiwHW+6S1
	 s8GTuz/gK5lolSy1j4bkbcCY/NhHHY2Mf5mXUlUkWsQEcDRvILFSrBj7BT+oo+auQk
	 JCt5R6EZBfFk3F4rI5l7zAxlapcggRA3EnbolYH3eZ7OtyNi4f73jkzBxg0E/xUsI+
	 lzyZjM9Gzl/kA==
Date: Mon, 29 May 2023 18:41:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <20230529184119.414d62f3@kernel.org>
In-Reply-To: <ZHRi0qZD/Hsjn0Fq@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
	<20230526102841.2226553-15-jiri@resnulli.us>
	<20230526211008.7b06ac3e@kernel.org>
	<ZHG0dSuA7s0ggN0o@nanopsycho>
	<20230528233334.77dc191d@kernel.org>
	<ZHRi0qZD/Hsjn0Fq@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 May 2023 10:31:14 +0200 Jiri Pirko wrote:
> >One could argue logically removing a port is also an operation of 
> >the parent (i.e. the devlink instance). The fact that the port gets
> >destroyed in the process is secondary. Ergo maybe we should skip 
> >this patch?  
> 
> Well, the port_del() could differ for different port flavours. The
> embedding structure of struct devlink_port is also different.
> 
> Makes sense to me to skip the flavour switch and have one port_del() for
> each port.

The asymmetry bothers me. It's hard to comment on what the best
approach is given this series shows no benefit of moving port_del().
Maybe even a loss, as mlx5 now has an ifdef in two places:

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index e39fd85ea2f9..63635cc44479 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -320,7 +320,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
>  #endif
>  #ifdef CONFIG_MLX5_SF_MANAGER
>  	.port_new = mlx5_devlink_sf_port_new,
> -	.port_del = mlx5_devlink_sf_port_del,
>  #endif
>  	.flash_update = mlx5_devlink_flash_update,
>  	.info_get = mlx5_devlink_info_get,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> index 76c5d6e9d47f..f370f67d9e33 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> @@ -145,6 +145,9 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
>  }
>  
>  static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
> +#ifdef CONFIG_MLX5_SF_MANAGER
> +	.port_del = mlx5_devlink_sf_port_del,
> +#endif
>  	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>  	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>  	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,

Is it okay if we deferred the port_del() patch until there's some
clear benefit?

