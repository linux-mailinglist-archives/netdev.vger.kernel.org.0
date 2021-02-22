Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB4A32193B
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 14:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhBVNo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 08:44:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhBVNk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 08:40:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lEBRO-007qCK-2M; Mon, 22 Feb 2021 14:39:58 +0100
Date:   Mon, 22 Feb 2021 14:39:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Danielle Ratson <danieller@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        f.fainelli@gmail.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next v4 3/8] ethtool: Get link mode in use instead of
 speed and duplex parameters
Message-ID: <YDO0LvSf0/sa7dmq@lunn.ch>
References: <20210202180612.325099-1-danieller@nvidia.com>
 <20210202180612.325099-4-danieller@nvidia.com>
 <672f3968-fb26-3af5-de23-219ea9411765@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <672f3968-fb26-3af5-de23-219ea9411765@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Currently, when user space queries the link's parameters, as speed and
> > duplex, each parameter is passed from the driver to ethtool.
> > 
> > Instead, get the link mode bit in use, and derive each of the parameters
> > from it in ethtool.

> > +	err = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> > +	if (err)
> > +		return err;
> 
> If a driver like drivers/net/tun.c does a complete
> 
> memcpy(cmd, &tun->link_ksettings, sizeof(*cmd)); 
> 
> then the link_ksettings->link_mode is overwritten with possible
> garbage data.
> 
> > +
> > +	if (link_ksettings->link_mode != -1) {
> > +		link_info = &link_mode_params[link_ksettings->link_mode];
> > +		link_ksettings->base.speed = link_info->speed;
> > +		link_ksettings->lanes = link_info->lanes;
> > +		link_ksettings->base.duplex = link_info->duplex;
> > +	}

Sorry, i missed the first posting of this.

What about downshift? A 1G PHY detects that it cannot establish a link
using four pairs at 1G. So it downshifts to 100Mbps using 2 pairs. The
PHY will report a speed of SPEED_100, despite the mode being
1000Base-T. This is not part of 802.3 clause 22, but a number of PHYs
have vendor registers which report the actual speed, and drivers are
reading this actual speed and returning it.

I really think you need to only use the link_mode derived speed when
speed is SPEED_UNKNOWN, duplex is DUPLEX_UNKNOWN.

	Andrew
