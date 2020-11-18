Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004532B8857
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgKRXXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgKRXXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:23:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FEFC0613D4;
        Wed, 18 Nov 2020 15:23:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfWmx-0006WW-AE; Thu, 19 Nov 2020 00:23:00 +0100
Date:   Thu, 19 Nov 2020 00:22:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, razor@blackwall.org,
        tobias@waldekranz.com, jeremy@azazel.net
Subject: Re: [PATCH net-next,v4 3/9] net: resolve forwarding path from
 virtual netdevice and HW destination address
Message-ID: <20201118232259.GC15137@breakpoint.cc>
References: <20201118223011.3216-1-pablo@netfilter.org>
 <20201118223011.3216-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118223011.3216-4-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +#define NET_DEVICE_PATH_STACK_MAX	5
> +
> +struct net_device_path_stack {
> +	int			num_paths;
> +	struct net_device_path	path[NET_DEVICE_PATH_STACK_MAX];
> +};

[..]

> +int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> +			  struct net_device_path_stack *stack)
> +{
> +	const struct net_device *last_dev;
> +	struct net_device_path_ctx ctx = {
> +		.dev	= dev,
> +		.daddr	= daddr,
> +	};
> +	struct net_device_path *path;
> +	int ret = 0, k;
> +
> +	stack->num_paths = 0;
> +	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
> +		last_dev = ctx.dev;
> +		k = stack->num_paths++;
> +		if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
> +			return -1;

This guarantees k < NET_DEVICE_PATH_STACK_MAX, so we can fill
entire path[].

> +		path = &stack->path[k];
> +		memset(path, 0, sizeof(struct net_device_path));
> +
> +		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
> +		if (ret < 0)
> +			return -1;
> +
> +		if (WARN_ON_ONCE(last_dev == ctx.dev))
> +			return -1;
> +	}

... but this means that stack->num_paths == NET_DEVICE_PATH_STACK_MAX
is possible, with k being last element.

> +	path = &stack->path[stack->num_paths++];

... so this may result in a off by one?
