Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976FE2B2A80
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKNBms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNBms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 20:42:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC6F82225D;
        Sat, 14 Nov 2020 01:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318167;
        bh=IB4mWQp1asevj/XF1O4v3O6eLR/wQDEZh7gq6SH4B18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hn6OJbMJLQbXg/PU2Q+uJY8Oea7Mh9LfwPhS2FhlogiGpllCEwa3Bk8iCHU7gctl1
         5PnMVEMyg8oncnLGc2jn8mNDK2c99oUyF++b/yRxcNOM1bClXsKKubNMMS+e/CE3l2
         quL0YpGEDdFI29iQldBxmXZO5QIqXYm+gMmlzCgw=
Date:   Fri, 13 Nov 2020 17:42:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 3/9] net: resolve forwarding path from
 virtual netdevice and HW destination address
Message-ID: <20201113174246.300997fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111193737.1793-4-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
        <20201111193737.1793-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 20:37:31 +0100 Pablo Neira Ayuso wrote:
> +int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> +			  struct net_device_path_stack *stack)
> +{
> +	const struct net_device *last_dev;
> +	struct net_device_path_ctx ctx;
> +	struct net_device_path *path;
> +	int ret = 0;
> +
> +	memset(&ctx, 0, sizeof(ctx));
> +	ctx.dev = dev;
> +	ctx.daddr = daddr;
> +
> +	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
> +		last_dev = ctx.dev;
> +
> +		path = &stack->path[stack->num_paths++];

I don't see you checking that this stack doesn't overflow.

What am I missing?

> +		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
> +		if (ret < 0)
> +			return -1;
> +
> +		if (WARN_ON_ONCE(last_dev == ctx.dev))
> +			return -1;
> +	}
> +	path = &stack->path[stack->num_paths++];
> +	path->type = DEV_PATH_ETHERNET;
> +	path->dev = ctx.dev;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dev_fill_forward_path);

