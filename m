Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A663316F52B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgBZBlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbgBZBlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:41:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1827E2082F;
        Wed, 26 Feb 2020 01:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582681295;
        bh=VTHpAmOwi6PxNdMCnznkox/kLCoNu1pxt3MJCNPFvEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rlf7gY9KHMzE2g0sCVJQv6LvcWifLhn3R7MA73/pKKAiEyYAW0Zbe4pkEWFqbjQp4
         5Z0QJQjd/La/Exj+kJzad3LjRnBToNb25ZrAYpzwJxQF1UPxpFvVpYVFXMR08gNwr9
         94y4n+cIe1IEwszZhfvK9GGlE6KzIgFIzBSBwFu8=
Date:   Tue, 25 Feb 2020 17:41:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 03/16] net/mlx5e: Encapsulate updating netdev queues
 into a function
Message-ID: <20200225174133.05c4a1d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200226011246.70129-4-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
        <20200226011246.70129-4-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 17:12:33 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> As a preparation for one of the following commits, create a function to
> encapsulate the code that notifies the kernel about the new amount of
> RX and TX queues. The code will be called multiple times in the next
> commit.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index a4d3e1b6ab20..85a86ff72aac 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -2869,6 +2869,17 @@ static void mlx5e_netdev_set_tcs(struct net_device *netdev)
>  		netdev_set_tc_queue(netdev, tc, nch, 0);
>  }
>  
> +static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
> +{
> +	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
> +	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
> +	struct net_device *netdev = priv->netdev;
> +
> +	mlx5e_netdev_set_tcs(netdev);
> +	netif_set_real_num_tx_queues(netdev, num_txqs);
> +	netif_set_real_num_rx_queues(netdev, num_rxqs);
> +}
> +
>  static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
>  {
>  	int i, ch;
> @@ -2890,13 +2901,7 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
>  
>  void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
>  {
> -	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
> -	int num_rxqs = priv->channels.num * priv->profile->rq_groups;
> -	struct net_device *netdev = priv->netdev;
> -
> -	mlx5e_netdev_set_tcs(netdev);
> -	netif_set_real_num_tx_queues(netdev, num_txqs);
> -	netif_set_real_num_rx_queues(netdev, num_rxqs);
> +	mlx5e_update_netdev_queues(priv);

Not sure where we stand on just moving bad code, but set_real_num_
_queues can fail, Dave just pointed this out to someone recently in
review.

>  
>  	mlx5e_build_txq_maps(priv);
>  	mlx5e_activate_channels(&priv->channels);

