Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4746625EF26
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIFQdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 12:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFQdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 12:33:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23C520709;
        Sun,  6 Sep 2020 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599409987;
        bh=JufQVAIIPQnj/VnYRwkF5YTXrluEZWFgHXv3wmmLd2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g6lRDB2vUEQWwY79IzN2cVcWlre/UQU/Rmm/eas2WpU45a2dz4aAtnTio29vBgxCR
         SfCWnIgkFVPGdkxZb3KF/P43qdxbD12GxYm6+0f1s/9bljYKpLdzxYc4lvbmDDlnRI
         1aeO2w7h3HCN9WJ78DfVGZv/ZKd7VajZe/y03NHk=
Date:   Sun, 6 Sep 2020 09:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        tariqt@mellanox.com, yishaih@mellanox.com,
        linux-rdma@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200906093305.5c901cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906072759.GC55261@unreal>
References: <20200904200621.2407839-1-kuba@kernel.org>
        <20200906072759.GC55261@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 10:27:59 +0300 Leon Romanovsky wrote:
> On Fri, Sep 04, 2020 at 01:06:21PM -0700, Jakub Kicinski wrote:
> > Even tho mlx4_core registers the devlink ports, it's mlx4_en
> > and mlx4_ib which set their type. In situations where one of
> > the two is not built yet the machine has ports of given type
> > we see the devlink warning from devlink_port_type_warn() trigger.
> >
> > Having ports of a type not supported by the kernel may seem
> > surprising, but it does occur in practice - when the unsupported
> > port is not plugged in to a switch anyway users are more than happy
> > not to see it (and potentially allocate any resources to it).
> >
> > Set the type in mlx4_core if type-specific driver is not built.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> > index 258c7a96f269..70cf24ba71e4 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> > @@ -3031,6 +3031,17 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
> >  	if (err)
> >  		return err;
> >
> > +	/* Ethernet and IB drivers will normally set the port type,
> > +	 * but if they are not built set the type now to prevent
> > +	 * devlink_port_type_warn() from firing.
> > +	 */
> > +	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
> > +	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
> > +		devlink_port_type_eth_set(&info->devlink_port, NULL);  
>                                                                ^^^^^
> 
> Won't it crash in devlink_port_type_eth_set()?
> The first line there dereferences pointer.
>   7612         const struct net_device_ops *ops = netdev->netdev_ops;

Damn, good catch. It's not supposed to be required. I'll patch devlink.
 
> And can we call to devlink_port_type_*_set() without IS_ENABLED() check?

It'll generate two netlink notifications - not the end of the world but
also doesn't feel super clean.
