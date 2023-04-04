Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E296D5859
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjDDGBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbjDDGBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE101BCD;
        Mon,  3 Apr 2023 23:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27B1C62E7F;
        Tue,  4 Apr 2023 06:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0BDC433D2;
        Tue,  4 Apr 2023 06:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680588103;
        bh=RK4VZ75qSBBAx7Gsq7WJjDEbHiYI+P1+h52AvLecL3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pgpUjsS2hPt1cZIE1DhG+iwykKcCAhiOmaODfVuaR7bzh5dWvt4eANQbB4b12vn1c
         ML2IH3DnetDH8jUqhAIfGfuesaSrnM792uMiDOA0alHR6C40xcIqL1eXAvJ127keYO
         3SmD8CUSi1SmJmeD/3ZJUUvWgHI4pHHzfOGvAEKPUbWDMR5yLSW/iVVCBovt42Krzv
         56CeZlKOJ6t5jQ0Zc9q/tODlUtxf3oUipeNYNOHthjF4OlCJBVRjiSzuYoxe3SSMXO
         AdSqRTQBYY9agj7Bhhd6kKSJfX8bze/Gof1tARr73vJcenh82IPhLDYIIe3y+EZJDT
         L+ouVFdC5dpyQ==
Date:   Tue, 4 Apr 2023 09:01:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, saeedm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH net-next v2] net/mlx5e: Remove NULL check before
 dev_{put, hold}
Message-ID: <20230404060138.GG4514@unreal>
References: <20230404021102.25122-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230404021102.25122-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 10:11:02AM +0800, Yang Li wrote:
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:35:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:734:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:769:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4667
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v2:
> --According to Simon's suggestion, add the one in mlx5e_set_int_port_tunnel().

Once you are doing such cleanup, please do it in one pass for whole driver.

➜  kernel git:(net-next) git grep -B1 dev_put drivers/net/ethernet/mellanox/mlx5/core/ | grep if -A1
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c-	if (attr->route_dev)
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:		dev_put(attr->route_dev);
--
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c-	if (uplink_upper)
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:		dev_put(uplink_upper);
--
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c-	if (route_dev)
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:		dev_put(route_dev);
--
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c-	if (route_dev)
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:		dev_put(route_dev);
--
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c-	if (route_dev)
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:		dev_put(route_dev);

Thanks

> 
>  .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 20c2d2ecaf93..2cb2ba857155 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -32,9 +32,7 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
>  						&attr->action, out_index);
>  
>  out:
> -	if (route_dev)
> -		dev_put(route_dev);
> -
> +	dev_put(route_dev);
>  	return err;
>  }
>  
> @@ -730,8 +728,7 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
>  	}
>  
>  out:
> -	if (route_dev)
> -		dev_put(route_dev);
> +	dev_put(route_dev);
>  	return err;
>  }
>  
> @@ -765,8 +762,7 @@ static int mlx5e_update_vf_tunnel(struct mlx5_eswitch *esw,
>  	mlx5e_tc_match_to_reg_mod_hdr_change(esw->dev, mod_hdr_acts, VPORT_TO_REG, act_id, data);
>  
>  out:
> -	if (route_dev)
> -		dev_put(route_dev);
> +	dev_put(route_dev);
>  	return err;
>  }
>  
> -- 
> 2.20.1.7.g153144c
> 
