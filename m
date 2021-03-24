Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390843484A2
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhCXWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235316AbhCXW3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB24961A1B;
        Wed, 24 Mar 2021 22:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616624994;
        bh=XAPgz67pTTnDTV8GH2L/woOzdZnDbxcZrscqWA3R7PU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DCLek7pPWRxVjSMfBwYYXp4F5GHn92nqsC8jgSQMhGEH2dKMuhBR515IOJHQIltm9
         T/wuM4zKlJnWHjiCMF7SU24Q6f354VXyepamhkQURNwkI5T/A3Pt/jJsT/KYhycC7Y
         bDrrdvbqELdBGC6PXor4UZl2q5gpS8anuCJhEPWLsSoGRii8oRQQuwrADhLDDmhqqo
         pIrXIsWl2lv318wGP/WIDRZTQLv05mtmnTSz03Rio716Bc8rNlmBsIas4oOu0d9Uny
         bLyYWhR7xDki7AWStkMmeomNhf/GNBTLt9fl9yaDukq1NVEKwIfkwI25BzvpwkNM5k
         ngYwuBQtUf+Xw==
Message-ID: <3f8d7d14f8d88f6e7667a489eee8651fda596462.camel@kernel.org>
Subject: Re: [PATCH net] net/mlx5e: Fix ipsec/tls netdev features build
From:   Saeed Mahameed <saeed@kernel.org>
To:     wenxu@ucloud.cn, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Date:   Wed, 24 Mar 2021 15:29:52 -0700
In-Reply-To: <1616559339-1853-1-git-send-email-wenxu@ucloud.cn>
References: <1616559339-1853-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-24 at 12:15 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Ipsec and tls netdev features build should be done after the
> mlx5e_init_ipesc/tls which finishs the init for the ipsec/tls
> in the driver.
> 
> Fixes: 3ef14e463f6e ("net/mlx5e: Separate between netdev objects and
> mlx5e profiles initialization")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 158f947..14c3f1f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5218,8 +5218,6 @@ static void mlx5e_build_nic_netdev(struct
> net_device *netdev)
>         netdev->priv_flags       |= IFF_UNICAST_FLT;
>  
>         mlx5e_set_netdev_dev_addr(netdev);
> -       mlx5e_ipsec_build_netdev(priv);
> -       mlx5e_tls_build_netdev(priv);
>  }
>  
>  void mlx5e_create_q_counters(struct mlx5e_priv *priv)
> @@ -5274,10 +5272,15 @@ static int mlx5e_nic_init(struct
> mlx5_core_dev *mdev,
>         err = mlx5e_ipsec_init(priv);
>         if (err)
>                 mlx5_core_err(mdev, "IPSec initialization failed,
> %d\n", err);
> +       else
> +               mlx5e_ipsec_build_netdev(priv);
> +
>  

Hi Wenxu, thanks for the patch. 
I know that IPSec got broken and i am working on a fix now,

Regarding your patch it is wrong to call ipsec/tls_build_netdev here
since it is too late, the netdev might be registered already and we
shouldn't be updating netdev->features directly. 

My plan is to setup the netdev features regardless of the
mlx5e_ipsec_init() state, and to remove the dependency.


>         err = mlx5e_tls_init(priv);
>         if (err)
>                 mlx5_core_err(mdev, "TLS initialization failed,
> %d\n", err);
> +       else
> +               mlx5e_tls_build_netdev(priv);
>  
>         err = mlx5e_devlink_port_register(priv);
>         if (err)

Did you encounter any issues with TLS ? because currently i don't see
any dependency between mlx5e_tls_build_netdev() and mlx5e_tls_init()
and the code should work as is.. but i might be missing something,
anyway I will provide a similar fix to ipsec.

Thanks For the report again.

Saeed.


