Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B522B25F368
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgIGGsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgIGGsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 02:48:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BB821556;
        Mon,  7 Sep 2020 06:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599461314;
        bh=fiCPeprN/B9FtSoWNITqusMHcKzF3Pep8qUKkDfgZKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZfAhMpGlTqAc15073MSac/ZpgaEijPyc2RzkurfWXbJsnGPFYavUWuYrsminFDwKi
         ia+djXbn91A0x3gYqqtCz7+tvscR0WOE2uwj23rmVD7vWFCeIwnfxgCSXd0RMu7DjP
         QQGucoRfaKWb1fxk+fVjWZBbXJJ/VQG2P6BsVVwU=
Date:   Mon, 7 Sep 2020 09:48:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        yishaih@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200907064830.GK55261@unreal>
References: <20200904200621.2407839-1-kuba@kernel.org>
 <20200906072759.GC55261@unreal>
 <20200906093305.5c901cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907062135.GJ2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907062135.GJ2997@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 08:21:35AM +0200, Jiri Pirko wrote:
> Sun, Sep 06, 2020 at 06:33:05PM CEST, kuba@kernel.org wrote:
> >On Sun, 6 Sep 2020 10:27:59 +0300 Leon Romanovsky wrote:
> >> On Fri, Sep 04, 2020 at 01:06:21PM -0700, Jakub Kicinski wrote:
> >> > Even tho mlx4_core registers the devlink ports, it's mlx4_en
> >> > and mlx4_ib which set their type. In situations where one of
> >> > the two is not built yet the machine has ports of given type
> >> > we see the devlink warning from devlink_port_type_warn() trigger.
> >> >
> >> > Having ports of a type not supported by the kernel may seem
> >> > surprising, but it does occur in practice - when the unsupported
> >> > port is not plugged in to a switch anyway users are more than happy
> >> > not to see it (and potentially allocate any resources to it).
> >> >
> >> > Set the type in mlx4_core if type-specific driver is not built.
> >> >
> >> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> > ---
> >> >  drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++++
> >> >  1 file changed, 11 insertions(+)
> >> >
> >> > diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> >> > index 258c7a96f269..70cf24ba71e4 100644
> >> > --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> >> > +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> >> > @@ -3031,6 +3031,17 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
> >> >  	if (err)
> >> >  		return err;
> >> >
> >> > +	/* Ethernet and IB drivers will normally set the port type,
> >> > +	 * but if they are not built set the type now to prevent
> >> > +	 * devlink_port_type_warn() from firing.
> >> > +	 */
> >> > +	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
> >> > +	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
> >> > +		devlink_port_type_eth_set(&info->devlink_port, NULL);
> >>                                                                ^^^^^
> >>
> >> Won't it crash in devlink_port_type_eth_set()?
> >> The first line there dereferences pointer.
> >>   7612         const struct net_device_ops *ops = netdev->netdev_ops;
> >
> >Damn, good catch. It's not supposed to be required. I'll patch devlink.
>
> When you set the port type to ethernet, you should have the net_device
> instance. Why wouldn't you?

It is how mlx4 is implemented, see mlx4_dev_cap() function:
588         for (i = 1; i <= dev->caps.num_ports; ++i) {
589                 dev->caps.port_type[i] = MLX4_PORT_TYPE_NONE;
....

The port type is being set to IB or ETH without relation to net_device,
fixing it will require very major code rewrite for the stable driver
that in maintenance mode.

>
>
> >
> >> And can we call to devlink_port_type_*_set() without IS_ENABLED() check?
> >
> >It'll generate two netlink notifications - not the end of the world but
> >also doesn't feel super clean.

I would say that such a situation is corner case during the driver init and
not an end of the world to see double netlink message.

Thanks
