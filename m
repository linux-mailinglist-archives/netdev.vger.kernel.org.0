Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80719360284
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhDOGiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhDOGiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 02:38:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9969561132;
        Thu, 15 Apr 2021 06:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618468681;
        bh=t6GHDj+Y33mMXvg8uABao12Vi4kYehCtFM50zKPWZww=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gmiwLF2kzFXyCyOBjwWSTwzLxP54RY7crMkwZuLe6NAPzoc/5EdtC1M05TUHyZURU
         lFK3RmZ9/X2cHQxFdvgTTw91YR4M/Wnlco8FSTY+8Pe7eJndv8ydEpsrnU5DMk+LF4
         0YN0nURzdOxEC3rxOgwO1dXYaLpBaD+StNeY8wEpKjeomGInLWFDAiT97o6qsLfBg6
         1YpZwY8pFv9x0VgSKDoPyKd3ykv4MMysTzIeiwowBsD9uP/KXSaZCuKJKxp9Y2XuBz
         ogm2K0dWOvTkkyeW1/wtaLt41AHlowyceCsA2C3CpfsW/igb+SpfPUqp4XXWHDTZ1I
         9MsEFcAM9HtJA==
Message-ID: <89cfa28751667cbebf32ec0e0ecb864fe5d570e9.camel@kernel.org>
Subject: Re: [PATCH net-next 6/6] mlx5: implement ethtool::get_fec_stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, leon@kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        ariela@nvidia.com
Date:   Wed, 14 Apr 2021 23:37:59 -0700
In-Reply-To: <20210414034454.1970967-7-kuba@kernel.org>
References: <20210414034454.1970967-1-kuba@kernel.org>
         <20210414034454.1970967-7-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-04-13 at 20:44 -0700, Jakub Kicinski wrote:
> Report corrected bits.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  9 ++++++
>  .../ethernet/mellanox/mlx5/core/en_stats.c    | 28
> +++++++++++++++++--
>  
> -#define MLX5E_READ_CTR64_BE_F(ptr, c)                  \
> +#define MLX5E_READ_CTR64_BE_F(ptr, set, c)             \
>         be64_to_cpu(*(__be64 *)((char *)ptr +           \
>                 MLX5_BYTE_OFF(ppcnt_reg,                \
> -
>                        counter_set.eth_802_3_cntrs_grp_data_layout.c##
> _high)))
> +                             counter_set.set.c##_high)))

squint...... looks fine :) 

>  
>  void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
>                            struct ethtool_pause_stats *pause_stats)
> @@ -791,9 +791,11 @@ void mlx5e_stats_pause_get(struct mlx5e_priv
> *priv,
>  
>         pause_stats->tx_pause_frames =
>                 MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
> +                                    
> eth_802_3_cntrs_grp_data_layout,
>                                      
> a_pause_mac_ctrl_frames_transmitted);
>         pause_stats->rx_pause_frames =
>                 MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
> +                                    
> eth_802_3_cntrs_grp_data_layout,
>                                      
> a_pause_mac_ctrl_frames_received);
>  }
>  
> @@ -1015,6 +1017,28 @@ static
> MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(phy)
>         mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT,
> 0, 0);
>  }
>  
> +void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
> +                        struct ethtool_fec_stats *fec_stats)
> +{
> +       u32 ppcnt_phy_statistical[MLX5_ST_SZ_DW(ppcnt_reg)];
> +       struct mlx5_core_dev *mdev = priv->mdev;
> +       u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {0};
> +       int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
> +
> +       if (!MLX5_CAP_PCAM_FEATURE(mdev, ppcnt_statistical_group))
> +               return;
> +
> +       MLX5_SET(ppcnt_reg, in, local_port, 1);
> +       MLX5_SET(ppcnt_reg, in, grp,
> MLX5_PHYSICAL_LAYER_STATISTICAL_GROUP);
> +       mlx5_core_access_reg(mdev, in, sz, ppcnt_phy_statistical,
> +                            sz, MLX5_REG_PPCNT, 0, 0);
> +

other than that the FW might fail us here, LGTM.

Acked-by: Saeed Mahameed <saeedm@nvidia.com>




