Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19BB645310
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLGEeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLGEeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:34:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC7513D20
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:34:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1CC0619EE
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5548C433D7;
        Wed,  7 Dec 2022 04:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670387656;
        bh=hwGS2waw2RsM79eveCSo56zVHfEUoiek5nr7TNN2XCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JoECqtTO90ieXsxZPCw1W1dsi3w+/h8JVFRaPzYuBwfT6lHD9Bug8GJHUYHnR/8zO
         eM9SHICp1wGVEV33O1ruSArOC6Wcln5F95QBBYmg3DBCK5Oz8LbgTFSZTZ6BEIAqKw
         UCCaPoEhpz9/iddvNtbm8OnOm0dvEbI+39HoFTKUvleBtUCx8vxtukt/wIuCjOylza
         h9YiZzLIlt45kDikVbRz+qudpYxu3+TKsT1uWaqCkfSo5glt8fKo8LsasS7yXDPjxJ
         giIvuRk/bBS6He0ZLF/04MU5BmVba/ysF72/10hyaN8HHTg25xwavLR8YgEVbWIj3F
         BNRGflIKB+Owg==
Date:   Tue, 6 Dec 2022 20:34:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <20221206203414.1eaf417b@kernel.org>
In-Reply-To: <20221203221337.29267-15-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
        <20221203221337.29267-15-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  3 Dec 2022 14:13:36 -0800 Saeed Mahameed wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 8d36e2de53a9..7911edefc622 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4440,11 +4440,8 @@ static int mlx5e_set_vf_vlan(struct net_device *dev, int vf, u16 vlan, u8 qos,
>  	struct mlx5e_priv *priv = netdev_priv(dev);
>  	struct mlx5_core_dev *mdev = priv->mdev;
>  
> -	if (vlan_proto != htons(ETH_P_8021Q))
> -		return -EPROTONOSUPPORT;

I can't take this with clear conscience :( I started nacking any new use
of the legacy VF NDOs. You already have bridging offload implemented,
why can bridging be used?

>  	return mlx5_eswitch_set_vport_vlan(mdev->priv.eswitch, vf + 1,
> -					   vlan, qos);
> +					   vlan, qos, ntohs(vlan_proto));
>  }
>  
