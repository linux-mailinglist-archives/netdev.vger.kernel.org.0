Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C523398B5
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhCLUyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235009AbhCLUyU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 15:54:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8173E64F5E;
        Fri, 12 Mar 2021 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615582459;
        bh=yjKJdNdRft9OgnwDRtxlJOfjzk4zNml7LX2v9XbBtnw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KxsLZUAAPUz8b4CLyIW6m8ATAuytP0G38KSX8r7mpkkLeACd86Ars5veR6jTp6pyI
         bbPrNcs4D10hbmuGcUEWmM/y9lLev9KskrCIUbB2yVoz8FtI2YThZtNPc5Wu0tqZyt
         B8O76BaIpU1afnNm5RQG4luNMxekPXU4OTgL3SuZ1UVy36oqSNKVIPWYbIPTxmJIXZ
         z1xMfLkSzfNALuGsbVqiAvKe3cDzdEiefSzZbmZsDLttPwkYxlXG5aX6M/8KKICNcO
         zeQ4TtIMXaWFjJgFyRtNvK2QOfOq5NyvzoTQLRmMP6f5AgO3mhkzg8FwUw6vQeT/P2
         ggYii05uicGDQ==
Message-ID: <c6a4224370e57d31b1f28e27e7a7d4e1ab237ec2.camel@kernel.org>
Subject: Re: [PATCH net-next v3 15/16] net/mlx5e: take the rtnl lock when
 calling netif_set_xps_queue
From:   Saeed Mahameed <saeed@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, alexander.duyck@gmail.com,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mykytianskyi <maximmi@nvidia.com>
Cc:     netdev@vger.kernel.org
Date:   Fri, 12 Mar 2021 12:54:18 -0800
In-Reply-To: <20210312150444.355207-16-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
         <20210312150444.355207-16-atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-03-12 at 16:04 +0100, Antoine Tenart wrote:
> netif_set_xps_queue must be called with the rtnl lock taken, and this
> is
> now enforced using ASSERT_RTNL(). mlx5e_attach_netdev was taking the
> lock conditionally, fix this by taking the rtnl lock all the time.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index ec2fcb2a2977..96cba86b9f0d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5557,7 +5557,6 @@ static void mlx5e_update_features(struct
> net_device *netdev)
>  
>  int mlx5e_attach_netdev(struct mlx5e_priv *priv)
>  {
> -       const bool take_rtnl = priv->netdev->reg_state ==
> NETREG_REGISTERED;
>         const struct mlx5e_profile *profile = priv->profile;
>         int max_nch;
>         int err;
> @@ -5578,15 +5577,11 @@ int mlx5e_attach_netdev(struct mlx5e_priv
> *priv)
>          * 2. Set our default XPS cpumask.
>          * 3. Build the RQT.
>          *
> -        * rtnl_lock is required by netif_set_real_num_*_queues in case
> the
> -        * netdev has been registered by this point (if this function
> was called
> -        * in the reload or resume flow).
> +        * rtnl_lock is required by netif_set_xps_queue.
>          */

There is a reason why it is conditional:
we had a bug in the past of double locking here:

[ 4255.283960] echo/644 is trying to acquire lock:

 [ 4255.285092] ffffffff85101f90 (rtnl_mutex){+..}, at:
mlx5e_attach_netdev0xd4/0×3d0 [mlx5_core]

 [ 4255.287264] 

 [ 4255.287264] but task is already holding lock:

 [ 4255.288971] ffffffff85101f90 (rtnl_mutex){+..}, at:
ipoib_vlan_add0×7c/0×2d0 [ib_ipoib]

ipoib_vlan_add is called under rtnl and will eventually call 
mlx5e_attach_netdev, we don't have much control over this in mlx5
driver since the rdma stack provides a per-prepared netdev to attach to
our hw. maybe it is time we had a nested rtnl lock .. 

> -       if (take_rtnl)
> -               rtnl_lock();
> +       rtnl_lock();
>         err = mlx5e_num_channels_changed(priv);
> -       if (take_rtnl)
> -               rtnl_unlock();
> +       rtnl_unlock();
>         if (err)
>                 goto out;
>  


