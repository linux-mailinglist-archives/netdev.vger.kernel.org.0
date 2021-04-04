Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4393538DC
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhDDQct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 12:32:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhDDQcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 12:32:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lT5g0-00EnLU-Lg; Sun, 04 Apr 2021 18:32:40 +0200
Date:   Sun, 4 Apr 2021 18:32:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        eric.dumazet@gmail.com, mkubecek@suse.cz, f.fainelli@gmail.com,
        acardace@redhat.com, irusskikh@marvell.com, gustavo@embeddedor.com,
        magnus.karlsson@intel.com, ecree@solarflare.com, idosch@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Message-ID: <YGnqKFddCJGikOo8@lunn.ch>
References: <20210404081433.1260889-1-danieller@nvidia.com>
 <20210404081433.1260889-2-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404081433.1260889-2-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -436,12 +436,16 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
>  
>  	memset(link_ksettings, 0, sizeof(*link_ksettings));
>  
> -	link_ksettings->link_mode = -1;
>  	err = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
>  	if (err)
>  		return err;
>  
> -	if (link_ksettings->link_mode != -1) {
> +	if (dev->ethtool_ops->cap_link_mode_supported &&
> +	    link_ksettings->link_mode != -1) {

Is this -1 behaviour documented anywhere? It seems like you just
changed its meaning. It used to mean, this field has not been set,
ignore it. Adding the cap_link_mode_supported it now means, we have
field has been set, but we have no idea what link mode is being used.
So you should probably add something to the documentation of struct
ethtool_link_ksettings.

I wonder if we should actually add ETHTOOL_LINK_MODE_UNKNOWN to enum
ethtool_link_mode_bit_indices?

> +		if (WARN_ON_ONCE(link_ksettings->link_mode >=
> +				 __ETHTOOL_LINK_MODE_MASK_NBITS))
> +			return -EINVAL;
> +
>  		link_info = &link_mode_params[link_ksettings->link_mode];
>  		link_ksettings->base.speed = link_info->speed;
>  		link_ksettings->lanes = link_info->lanes;

If dev->ethtool_ops->cap_link_mode_supported &&
link_ksettings->link_mode == -1 should you be setting speed to
SPEED_UNKNOWN, and lanes to LANE_UNKNOWN? Or is that already the
default?

But over all, this API between the core and the driver seems
messy. Why not just add a helper in common.c which translates link
mode to speed/duplex/lanes and call it in the driver. Then you don't
need this capability flags, which i doubt any other driver will ever
use. And you don't need to worry about drivers returning random
values. As far as i can see, the link_mode returned by the driver is
not used for anything other than for this translation. So i don't see
a need for it outside of the driver. Or maybe i'm missing something?

	Andrew
