Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AC5162EB
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 10:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245612AbiEAIpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 04:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244504AbiEAIpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 04:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A84F4C42F
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 01:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82BD5B80CF0
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 08:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2899C385AE;
        Sun,  1 May 2022 08:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651394536;
        bh=DQDwVUUuu9g69QrS76fAJBvxfZ8jsyo4ZFYN9fZIw5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eFgh9mpXUVfwGf00r+1P65qMvUJ0fl70ExN7alQLxQ9LVrEaJROZk47UTm38YXygV
         xsuED11Qy7n5g9KBtCtjEm0X1SwRA0axRCAtI7MYrXobhCWXXdEaTAsA4nAbl5EdxH
         hicVDtCccHh6PX7bbLxc5FvG1JkBzV8RWuPP5bZm+T58ejTgTTv2YFuIObqoyNEiwa
         YzayzyXyMIAdagwTdSUJrQKsbNn1QvuWDZ87MY/klqLn3yGCKSOX/fnFjRwCYBf1rp
         +2mgdTLfffQokv4n7p97FYNBIcMfl+fX3Mw2Cmi8C9OzJoYcdYhdWavszSLFjQh56x
         xYK+iLm11EjNQ==
Date:   Sun, 1 May 2022 11:42:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 13/17] net/mlx5: Simplify IPsec capabilities
 logic
Message-ID: <Ym5H42U94xSxf1QG@unreal>
References: <cover.1650363043.git.leonro@nvidia.com>
 <f47d197be948ce44772baf3276a1a855ad2f210a.1650363043.git.leonro@nvidia.com>
 <20220422224257.pa7p2uuo4qau5ezi@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422224257.pa7p2uuo4qau5ezi@sx1>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:42:57PM -0700, Saeed Mahameed wrote:
> On 19 Apr 13:13, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Reduce number of hard-coded IPsec capabilities by making sure
> > that mlx5_ipsec_device_caps() sets only supported bits.
> > 
> > As part of this change, remove _accel_ notations from the names
> > and prepare the code to IPsec full offload mode.
> > 
> 
> Can you explain why remove __accel__ notation ?
> __accel__ notation and decoupling from other common netdev features is done
> for modularity purpose, en_accel directories are separated so we can
> implement complex/stateful accelerations while avoid contaminating/affecting
> common data-path performance sensitives flows.
> 
> I think keeping __accel__ notations is a must here for the above reasons,
> unless you have a more strong reason to remove it..

Acceleration and hardware offloads are the same in their end result, but
different in meaning and in their implementations.

Accelerators are usually represented by specialized hardware that
designed to perform specific tasks. In our case, CX devices provide
hardware offload capabilities that extends general purpose NIC and
not accelerations.

__accel__ is a wrong word here.

Thanks

> 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../mellanox/mlx5/core/en_accel/ipsec.c       | 16 ++------------
> > .../mellanox/mlx5/core/en_accel/ipsec.h       |  9 +++-----
> > .../mlx5/core/en_accel/ipsec_offload.c        | 22 +++++++++----------
> > 3 files changed, 16 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index Clean IPsec FS add/delete rules28729b1cc6e6..be7650d2cfd3 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -215,7 +215,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
> > 		return -EINVAL;
> > 	}
> > 	if (x->props.flags & XFRM_STATE_ESN &&
> > -	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_ESN)) {
> > +	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_ESN)) {
> > 		netdev_info(netdev, "Cannot offload ESN xfrm states\n");
> > 		return -EINVAL;
> > 	}
> > @@ -262,11 +262,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
> > 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
> > 		return -EINVAL;
> > 	}
> > -	if (x->props.family == AF_INET6 &&
> > -	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_IPV6)) {
> > -		netdev_info(netdev, "IPv6 xfrm state offload is not supported by this device\n");
> > -		return -EINVAL;
> > -	}
> > 	return 0;
> > }
> > 
> > @@ -457,12 +452,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
> > 	if (!mlx5_ipsec_device_caps(mdev))
> > 		return;
> > 
> > -	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
> > -	    !MLX5_CAP_ETH(mdev, swp)) {
> > -		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
> > -		return;
> > -	}
> > -
> > 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
> > 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
> > 	netdev->features |= NETIF_F_HW_ESP;
> > @@ -476,8 +465,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
> > 	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
> > 	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
> > 
> > -	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
> > -	    !MLX5_CAP_ETH(mdev, swp_lso)) {
> > +	if (!MLX5_CAP_ETH(mdev, swp_lso)) {
> > 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
> > 		return;
> > 	}
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > index af1467cbb7c7..97c55620089d 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > @@ -102,12 +102,9 @@ struct mlx5_accel_esp_xfrm_attrs {
> > 	u8 is_ipv6;
> > };
> > 
> > -enum mlx5_accel_ipsec_cap {
> > -	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
> > -	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
> > -	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
> > -	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
> > -	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
> > +enum mlx5_ipsec_cap {
> > +	MLX5_IPSEC_CAP_CRYPTO		= 1 << 0,
> > +	MLX5_IPSEC_CAP_ESN		= 1 << 1,
> > };
> > 
> > struct mlx5e_priv;
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
> > index 817747d5229e..b44bce3f4ef1 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
> > @@ -7,7 +7,7 @@
> > 
> > u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
> > {
> > -	u32 caps;
> > +	u32 caps = 0;
> > 
> > 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
> > 		return 0;
> > @@ -19,23 +19,23 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
> > 	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
> > 		return 0;
> > 
> > -	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) ||
> > -	    !MLX5_CAP_ETH(mdev, insert_trailer))
> > -		return 0;
> > -
> > 	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ipsec_encrypt) ||
> > 	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ipsec_decrypt))
> > 		return 0;
> > 
> > -	caps = MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 |
> > -	       MLX5_ACCEL_IPSEC_CAP_LSO;
> > +	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) ||
> > +	    !MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
> > +		return 0;
> > 
> > -	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
> > -	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
> > -		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
> > +	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
> > +	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
> > +		caps |= MLX5_IPSEC_CAP_CRYPTO;
> > +
> > +	if (!caps)
> > +		return 0;
> > 
> > 	if (MLX5_CAP_IPSEC(mdev, ipsec_esn))
> > -		caps |= MLX5_ACCEL_IPSEC_CAP_ESN;
> > +		caps |= MLX5_IPSEC_CAP_ESN;
> > 
> > 	/* We can accommodate up to 2^24 different IPsec objects
> > 	 * because we use up to 24 bit in flow table metadata
> > -- 
> > 2.35.1
> > 
