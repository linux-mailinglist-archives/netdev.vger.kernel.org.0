Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC4639912A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFBRMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhFBRMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 13:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D0161028;
        Wed,  2 Jun 2021 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622653834;
        bh=u+W+i+heGBo0X2/7Y5sUYkYNAmcg7PCzOMtS61Lgui4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WDBaxHIH+dgbVWsbw/zV7rEAZMUMeVP3f9sBPlit/Sy95rlnIgoJQ50vhl0pIgfrM
         VXclJnBEQQAMhIklE+uYV0YlB4Vgz8rtEgDs31rJcf5AWdGixNSueNEhXIdHK5zJ1b
         b/tL3B0cVr96PHXqT3E/DUXWHi06057dwUs/dMWXdsUOvJTHBS1jj3aQw9LYjLOw4b
         iXk0aZo20Su9QSRZNazvZGyVMDgVMFzwHQrZRHMDXVHuIzMx/psWz60/8T8oQPX391
         e1dNsXR9WZU+0FdoEbZconPB4MObTXfZRhxoPKVA7W7FtUOWj7be/dXv2xxJkAidH9
         DxBLzEUx3JrzQ==
Date:   Wed, 2 Jun 2021 10:10:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 1/8] net/mlx5e: Fix incompatible casting
Message-ID: <20210602101033.71216ba6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210602013723.1142650-2-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
        <20210602013723.1142650-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Jun 2021 18:37:16 -0700 Saeed Mahameed wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Device supports setting of a single fec mode at a time, enforce this
> by bitmap_weight == 1. Input from fec command is in u32, avoid cast to
> unsigned long and use bitmap_from_arr32 to populate bitmap safely.
> 
> Fixes: 4bd9d5070b92 ("net/mlx5e: Enforce setting of a single FEC mode")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 8360289813f0..c4724742eef1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -1624,12 +1624,13 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
>  {
>  	struct mlx5e_priv *priv = netdev_priv(netdev);
>  	struct mlx5_core_dev *mdev = priv->mdev;
> +	unsigned long fec_bitmap;
>  	u16 fec_policy = 0;
>  	int mode;
>  	int err;
>  
> -	if (bitmap_weight((unsigned long *)&fecparam->fec,
> -			  ETHTOOL_FEC_LLRS_BIT + 1) > 1)
> +	bitmap_from_arr32(&fec_bitmap, &fecparam->fec, sizeof(fecparam->fec) * BITS_PER_BYTE);
> +	if (bitmap_weight(&fec_bitmap, ETHTOOL_FEC_LLRS_BIT + 1) > 1)
>  		return -EOPNOTSUPP;
>  
>  	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {

hweight32()? Not that'd be worth a respin
