Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F8A25EA5E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIEUWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgIEUWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 16:22:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12BA2074D;
        Sat,  5 Sep 2020 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599337356;
        bh=Oaj49bQBs+Y/I15Bc/0eNy8UGF4bF2kQ57cD0Jehdrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WkDKyoVT3fYxXm2VHBZ/5zSdr9+IK49QT0LAR7myTsQIQ3AHBLSRodm08C1dild3Z
         oh4q+N4cLgzu5IgvgcWtoAdgNGzfFesFPVZeXnLAC1lb3O6sfjv+u66n8J7ykGK9LS
         aal6rERRRqorD6EBsW35VnTE55Edxu9wwW6FD5pI=
Date:   Sat, 5 Sep 2020 13:22:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3 v4 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200905132234.4d68afed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905174411.GA6862@mx-linux-amd>
References: <20200905174411.GA6862@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 19:44:11 +0200 Armin Wolf wrote:
> Replace version string with MODULE_* macros.
> 
> Include necessary libraries.
> 
> Fix two minor coding-style issues.

These 3 may be better as separate commits.

> diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/8390.c
> index 0e0aa4016858..a7937c75d85f 100644
> --- a/drivers/net/ethernet/8390/8390.c
> +++ b/drivers/net/ethernet/8390/8390.c
> @@ -1,11 +1,23 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/* 8390 core for usual drivers */
> 
> -static const char version[] =
> -    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\n";
> +#define DRV_NAME "8390"
> +#define DRV_DESCRIPTION "8390 core for usual drivers"
> +#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"
> +#define DRV_RELDATE "9/23/1994"

I don't quite get why you define DRV_NAME and DRV_RELDATE.

If you want to preserve the version information you can add it as a
comment, but honestly I'm not really sure if it's worth preserving.

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/export.h>
> +

No need for the empty line here IMHO.

> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>

Sort the includes alphabetically.

>  #include "lib8390.c"
> 
> +MODULE_AUTHOR(DRV_AUTHOR);
> +MODULE_DESCRIPTION(DRV_DESCRIPTION);
> +
>  int ei_open(struct net_device *dev)
>  {
>  	return __ei_open(dev);
> @@ -64,7 +76,7 @@ const struct net_device_ops ei_netdev_ops = {
>  	.ndo_get_stats		= ei_get_stats,
>  	.ndo_set_rx_mode	= ei_set_multicast_list,
>  	.ndo_validate_addr	= eth_validate_addr,
> -	.ndo_set_mac_address 	= eth_mac_addr,
> +	.ndo_set_mac_address	= eth_mac_addr,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller	= ei_poll,
>  #endif
> @@ -74,6 +86,7 @@ EXPORT_SYMBOL(ei_netdev_ops);
>  struct net_device *__alloc_ei_netdev(int size)
>  {
>  	struct net_device *dev = ____alloc_ei_netdev(size);
> +
>  	if (dev)
>  		dev->netdev_ops = &ei_netdev_ops;
>  	return dev;
> --
> 2.20.1
> 

