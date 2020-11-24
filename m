Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F5A2C3406
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbgKXW3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388693AbgKXW3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:29:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D646206D4;
        Tue, 24 Nov 2020 22:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606256951;
        bh=s9ufHWKMyaUHsFoaG6W5yELgqEHNOQ7QZZ336B6RmA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RR/QxVcHODkcci/X6kE1p9x8S3hTfgsWOxwqZQnGu9UE+HOxC9mrgBTO0F7pxl8zw
         O0o66g7Ltz/wSy2JJWJnAjjcUHcm0ee06g9rtz4erv+7EmB+kE9jAF0rEFeFkIDY9s
         8CcdjRNIXhU8LscMXm4Y/soQWYomTjtwszV7QpzE=
Date:   Tue, 24 Nov 2020 14:29:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <jiri@nvidia.com>
Subject: Re: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Message-ID: <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201122061257.60425-2-parav@nvidia.com>
References: <20201122061257.60425-1-parav@nvidia.com>
        <20201122061257.60425-2-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 08:12:56 +0200 Parav Pandit wrote:
> A netdevice of a devlink port can be moved to different
> net namespace than its parent devlink instance.
> This scenario occurs when devlink reload is not used for
> maintaining backward compatibility.
> 
> When netdevice is undergoing migration to net namespace,
> its ifindex and name may change.
> 
> In such use case, devlink port query may read stale netdev
> attributes.
> 
> Fix it by reading them under rtnl lock.
> 
> Fixes: bfcd3a466172 ("Introduce devlink infrastructure")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  net/core/devlink.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index acc29d5157f4..6135ef5972ce 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -775,6 +775,23 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
>  	return err;
>  }
>  
> +static int devlink_nl_port_netdev_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
> +{
> +	struct net_device *netdev = devlink_port->type_dev;
> +	int err;
> +
> +	ASSERT_RTNL();
> +	if (!netdev)
> +		return 0;
> +
> +	err = nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX, netdev->ifindex);

The line wrapping was correct, please keep in under 80. Please tell
your colleges at Mellanox.

> +	if (err)
> +		goto done;

	return err;

> +	err = nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME, netdev->name);

	return nla_put_...

> +done:
> +	return err;
> +}
> +
>  static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
>  				struct devlink_port *devlink_port,
>  				enum devlink_command cmd, u32 portid,
> @@ -792,6 +809,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
>  	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
>  		goto nla_put_failure;
>  
> +	/* Hold rtnl lock while accessing port's netdev attributes. */
> +	rtnl_lock();
>  	spin_lock_bh(&devlink_port->type_lock);
>  	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
>  		goto nla_put_failure_type_locked;
> @@ -800,13 +819,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
>  			devlink_port->desired_type))
>  		goto nla_put_failure_type_locked;
>  	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
> -		struct net_device *netdev = devlink_port->type_dev;
> +		int err;

What's the point of this local variable?

> -		if (netdev &&
> -		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
> -				 netdev->ifindex) ||
> -		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
> -				    netdev->name)))
> +		err = devlink_nl_port_netdev_fill(msg, devlink_port);
> +		if (err)

just put the call in the if ()

>  			goto nla_put_failure_type_locked;
>  	}
>  	if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {


Honestly this patch is doing too much for a fix.

All you need is the RTNL lock and then add:

+               struct net *net = devlink_net(devlink_port->devlink);
                struct net_device *netdev = devlink_port->type_dev;
 
                if (netdev &&
+                   net_eq(net, dev_net(netdev)) &&
                    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
                                 netdev->ifindex) ||
                     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,


You can do refactoring later in net-next. Maybe even add a check that
drivers which support reload set namespace local on their netdevs.
