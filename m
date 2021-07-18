Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DED3CC857
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhGRJg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 05:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhGRJgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 05:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAFB0611AC;
        Sun, 18 Jul 2021 09:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626600837;
        bh=C9vs+jm4iqSIHTHVlZgj2Q7epuO0aeP6olaAwjSBvhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dJ1X5RBlw4eqiXH2P1aAqFLMWuHkwaj4M9MuyYMDs6vXzKp39r1zb7InpGrpOX0U1
         Aa/fII51i417UZdBSf3cqgpWnkYJe1ZdtqtHQxwSJcSxpNYH5PwjzPmzpYmoIvTbWs
         nS6jsTUqzvehurN2BJHF2UWSlUIrsAD/Xc2vVGcEhd8ApQkDyeuy0Xq6kSx2bE1N1w
         CtbgZd/6Y4FnpcU8eWC7ubJu8xhoflPWAlQr9UYWk1U1fP1bKNuBRj25Hi3M7RCIuw
         rgk1b3Xf9FwZ77IocmY9p2Vew4dynzKmgvp5IayMhprK3xK4pB+oa7xdKMdzrxBHZW
         FAd5a+ePkKDPw==
Date:   Sun, 18 Jul 2021 12:33:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     saeedm@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Fix missing error code in
 mlx5_devlink_eswitch_inline_mode_set()
Message-ID: <YPP1glxuO+qJKx9v@unreal>
References: <1626432728-118051-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626432728-118051-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 06:52:08PM +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> vers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
> mlx5_devlink_eswitch_inline_mode_set() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 7579f34..b38b6c1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3079,8 +3079,10 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
>  
>  	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
>  	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
> -		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
> +		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE) {
> +			err = -EINVAL;

This change is wrong, it should be err = 0;
and please add Fixes line.
Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")

>  			goto out;
> +		}
>  		fallthrough;
>  	case MLX5_CAP_INLINE_MODE_L2:
>  		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
> -- 
> 1.8.3.1
> 
