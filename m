Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FD31E96BB
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 11:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgEaJ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 05:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgEaJ6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 05:58:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F7B2074A;
        Sun, 31 May 2020 09:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590919093;
        bh=WKlTbhhBd7wKH27CXuH8GVYuTDCmhWm1qtCyl1lamfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vv+oB/fXbPfSzEEQVURPCVzVHcxc1PYRWoZETsB5wgM0XzVldROeYs1KdDJMN/eXa
         6CsBT3zzWvSoNE2VqDmiFoj664xqo2Mpm6EFGh1wG2dhbae5ICXbG46d3G8LqQ5MpA
         QTfBzN+SYag9OWxaUx44RKbVlb5VbYKMXmmh6Cdc=
Date:   Sun, 31 May 2020 12:58:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] mlx5: Restore err assignment in mlx5_mdev_init
Message-ID: <20200531095810.GF66309@unreal>
References: <20200530055447.1028004-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530055447.1028004-1-natechancellor@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 10:54:48PM -0700, Nathan Chancellor wrote:
> Clang warns:
>
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
> 'err' is used uninitialized whenever 'if' condition is true
> [-Wsometimes-uninitialized]
>         if (!priv->dbg_root) {
>             ^~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
> uninitialized use occurs here
>         return err;
>                ^~~
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
> 'if' if its condition is always false
>         if (!priv->dbg_root) {
>         ^~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
> the variable 'err' to silence this warning
>         int err;
>                ^
>                 = 0
> 1 warning generated.
>
> This path previously returned -ENOMEM, restore that error code so that
> it is not uninitialized.
>
> Fixes: 810cbb25549b ("net/mlx5: Add missing mutex destroy")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1042
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index df46b1fce3a7..ac68445fde2d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1277,6 +1277,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
>  					    mlx5_debugfs_root);
>  	if (!priv->dbg_root) {
>  		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
> +		err = -ENOMEM;
>  		goto err_dbg_root;
                ^^^^^^^^^^^^^^^^^^ this is wrong.
Failure to create debugfs should never fail the driver.

>  	}
>
>
> base-commit: c0cc73b79123e67b212bd537a7af88e52c9fbeac
> --
> 2.27.0.rc0
>
