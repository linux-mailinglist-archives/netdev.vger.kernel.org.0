Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BAE3068CE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhA1Ard (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:47:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhA1ArP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:47:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4vSA-002wtK-BL; Thu, 28 Jan 2021 01:46:30 +0100
Date:   Thu, 28 Jan 2021 01:46:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 2/4] net: dsa: automatically bring user ports
 down when master goes down
Message-ID: <YBIJZuy6iXeNQpxm@lunn.ch>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127010028.1619443-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	case NETDEV_GOING_DOWN: {
> +		struct dsa_port *dp, *cpu_dp;
> +		struct dsa_switch_tree *dst;
> +		int err = 0;
> +
> +		if (!netdev_uses_dsa(dev))
> +			return NOTIFY_DONE;
> +
> +		cpu_dp = dev->dsa_ptr;
> +		dst = cpu_dp->ds->dst;
> +
> +		list_for_each_entry(dp, &dst->ports, list) {
> +			if (!dsa_is_user_port(dp->ds, dp->index)) {

!dsa_is_user_port() ??

That ! seems odd. 

> +				struct net_device *slave = dp->slave;
> +
> +				if (!(slave->flags & IFF_UP))
> +					continue;
> +
> +				err = dev_change_flags(slave,
> +						       slave->flags & ~IFF_UP,
> +						       NULL);

  Andrew
