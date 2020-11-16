Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A095E2B51EC
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731520AbgKPUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731488AbgKPUFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 15:05:08 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEEB520A8B;
        Mon, 16 Nov 2020 20:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605557108;
        bh=KH69V18rMUxKg+oWCxZehuAaYIXnsuXmjaKO7YMqvcI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PvrRQ1yBXAirL0IMeeXHa2cGqSeEveHnEH1TXaKntTE6BE5sK8pdET2ERcFgU1Fad
         771Ub9QQq29adfwtVA4IvwW/N857ThRWJjK2RkGynwsyKGbbK2q9I6VRaD3gK87qkD
         reujwiBblMcxfx9pRDK1oN5IwHVfk8BwxZLV/uzE=
Message-ID: <32a6628214621766d884308fd9f29abad9e149b9.camel@kernel.org>
Subject: Re: [PATCH net] net/mlx5: fix error return code in
 mlx5e_tc_nic_init()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, lariel@mellanox.com,
        roid@mellanox.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 Nov 2020 12:05:06 -0800
In-Reply-To: <20201114115223.39505-1-wanghai38@huawei.com>
References: <20201114115223.39505-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-14 at 19:52 +0800, Wang Hai wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: aedd133d17bc ("net/mlx5e: Support CT offload for tc nic
> flows")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index e3a968e9e2a0..c7ad5db84f78 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -5227,8 +5227,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
>  
>  	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv-
> >fs.tc.mod_hdr,
>  				 MLX5_FLOW_NAMESPACE_KERNEL);
> -	if (IS_ERR(tc->ct))
> +	if (IS_ERR(tc->ct)) {
> +		err = PTR_ERR(tc->ct);
>  		goto err_ct;
> +	}
>  
>  	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
>  	err = register_netdevice_notifier_dev_net(priv->netdev,

Applied to net-mlx5 
Thanks !


