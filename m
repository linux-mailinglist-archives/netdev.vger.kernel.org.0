Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48668225294
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 17:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGSPkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 11:40:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgGSPkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 11:40:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxBQE-005t79-6e; Sun, 19 Jul 2020 17:40:14 +0200
Date:   Sun, 19 Jul 2020 17:40:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] net: dsa: Add wrappers for overloaded
 ndo_ops
Message-ID: <20200719154014.GJ1383417@lunn.ch>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718030533.171556-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#if IS_ENABLED(CONFIG_NET_DSA)
> +#define dsa_build_ndo_op(name, arg1_type, arg1_name, arg2_type, arg2_name) \
> +static int inline dsa_##name(struct net_device *dev, arg1_type arg1_name, \
> +			     arg2_type arg2_name)	\
> +{							\
> +	const struct dsa_netdevice_ops *ops;		\
> +	int err = -EOPNOTSUPP;				\
> +							\
> +	if (!dev->dsa_ptr)				\
> +		return err;				\
> +							\
> +	ops = dev->dsa_ptr->netdev_ops;			\
> +	if (!ops || !ops->name)				\
> +		return err;				\
> +							\
> +	return ops->name(dev, arg1_name, arg2_name);	\
> +}
> +#else
> +#define dsa_build_ndo_op(name, ...)			\
> +static inline int dsa_##name(struct net_device *dev, ...) \
> +{							\
> +	return -EOPNOTSUPP;				\
> +}
> +#endif
> +
> +dsa_build_ndo_op(ndo_do_ioctl, struct ifreq *, ifr, int, cmd);
> +dsa_build_ndo_op(ndo_get_phys_port_name, char *, name, size_t, len);

Hi Florian

I tend to avoid this sort of macro magic. Tools like
https://elixir.bootlin.com/ and other cross references have trouble
following it. The current macros only handle calls with two
parameters. And i doubt it is actually saving many lines of code, if
there are only two invocations.

      Andrew
