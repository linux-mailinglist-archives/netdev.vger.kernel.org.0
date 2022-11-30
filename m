Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459F863D14F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbiK3JAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiK3JAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:00:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C5C48431;
        Wed, 30 Nov 2022 01:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFAEC61A88;
        Wed, 30 Nov 2022 09:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA07C433C1;
        Wed, 30 Nov 2022 09:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669798839;
        bh=euzw5UMkJCxepk4K1fzbBzC6XFnGg7eesbYoU8klTe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xq/uUQxMCvgiehXzPXoB8Ihm+svSXb5X9vq99Nst8XRO1T9fk6/b/bXMOM2de6DDG
         8YsJmVTKDrjWgtJ8XwGrOJ51TvtduclORJLficueFg/RWYus70UQc7otlfY7dajxuC
         C6FFbWaQJWUonW6LljERj5UBEUpJjLjfXDIjuwZKQUXa+ZhIQ+FT4NwfidP7ow4GDV
         vWX/yBoKrlwsR9CRL6lm8Oii7mLvhKsIih2x5mSLQmdgkOMbIkSKmyOrYrDmEfO619
         8sc2FnvUfpfiEMjJZ+FPgepo5NW33soXU3/gNpVyUrxIugrQZqsknOJXe1xuAQ4WWa
         HBkucAaykdiJQ==
Date:   Wed, 30 Nov 2022 11:00:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     zhang.songyi@zte.com.cn
Cc:     saeedm@nvidia.com, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, mbloch@nvidia.com,
        maorg@nvidia.com, elic@nvidia.com, jerrliu@nvidia.com,
        cmi@nvidia.com, vladbu@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: remove NULL check before dev_{put,
 hold}
Message-ID: <Y4cbssiTgsGGNHlh@unreal>
References: <202211301541270908055@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211301541270908055@zte.com.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 03:41:27PM +0800, zhang.songyi@zte.com.cn wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold}.
> 
> Fix the following coccicheck warning:
> /drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10:
> WARNING:
> WARNING  NULL check before dev_{put, hold} functions is not needed.
> 
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Please change all places in mlx5 in one patch.

You can find these with the following command
 git grep -B 1 -E "dev_put|dev_hold" drivers/net/ethernet/mellanox/mlx5/

Thanks

> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 32c3e0a649a7..6ab3a6b6dd8d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1448,8 +1448,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
>         } else {
>                 ndev = ldev->pf[MLX5_LAG_P1].netdev;
>         }
> -       if (ndev)
> -               dev_hold(ndev);
> +       dev_hold(ndev);
> 
>  unlock:
>         spin_unlock_irqrestore(&lag_lock, flags);
> --
> 2.25.1
