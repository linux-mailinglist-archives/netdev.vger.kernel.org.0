Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CE625ED2D
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 09:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIFH2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 03:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgIFH2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 03:28:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA6920759;
        Sun,  6 Sep 2020 07:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599377284;
        bh=JrVJMtZcdq+987pFwB6tTOE0p/AgWQHYp+H0uqhxXDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gogbtmjosUBTjuyj4iHSGQ18Mmw/AvkWT1iRki9lhTe2SNu0UaP9oWyhehS+0OoJv
         snzttz5I50urqTnUM/NZtNAIurRI68vnvAXO4bEfWcSoGZM9CFML1Pg2LI1HTcuNL5
         MVdG6jCQSqB76/l4ywp8fWsLOq7xB3RbFPd/zJsw=
Date:   Sun, 6 Sep 2020 10:27:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        tariqt@mellanox.com, yishaih@mellanox.com,
        linux-rdma@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200906072759.GC55261@unreal>
References: <20200904200621.2407839-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904200621.2407839-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 01:06:21PM -0700, Jakub Kicinski wrote:
> Even tho mlx4_core registers the devlink ports, it's mlx4_en
> and mlx4_ib which set their type. In situations where one of
> the two is not built yet the machine has ports of given type
> we see the devlink warning from devlink_port_type_warn() trigger.
>
> Having ports of a type not supported by the kernel may seem
> surprising, but it does occur in practice - when the unsupported
> port is not plugged in to a switch anyway users are more than happy
> not to see it (and potentially allocate any resources to it).
>
> Set the type in mlx4_core if type-specific driver is not built.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 258c7a96f269..70cf24ba71e4 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3031,6 +3031,17 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>  	if (err)
>  		return err;
>
> +	/* Ethernet and IB drivers will normally set the port type,
> +	 * but if they are not built set the type now to prevent
> +	 * devlink_port_type_warn() from firing.
> +	 */
> +	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
> +	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
> +		devlink_port_type_eth_set(&info->devlink_port, NULL);
                                                               ^^^^^

Won't it crash in devlink_port_type_eth_set()?
The first line there dereferences pointer.
  7612         const struct net_device_ops *ops = netdev->netdev_ops;

And can we call to devlink_port_type_*_set() without IS_ENABLED() check?

Thanks


> +	else if (!IS_ENABLED(CONFIG_MLX4_INFINIBAND) &&
> +		 dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
> +		devlink_port_type_ib_set(&info->devlink_port, NULL);
> +
>  	info->dev = dev;
>  	info->port = port;
>  	if (!mlx4_is_slave(dev)) {
> --
> 2.26.2
>
