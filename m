Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E60A2F22B4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390183AbhAKWZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:25:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389320AbhAKWZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 17:25:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B66922D0B;
        Mon, 11 Jan 2021 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610403894;
        bh=/mBulmBYWYLmzUDnOrABFLE0aRMTrHDtmWt3NavFSI4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aSIB6m8VU5UB9RmVATFeVp+cRPeEr8MDW8ZGXGmM5tNNeQKnpfctjiqYgVPFisO0s
         iquPTfNqgnVac1ip7q7dlYyXreJ7J953cP3ccITuDv5Jj0P/8zwsk174ria8ewQDuA
         a/w3cjaojZH/Xy0ukuc5NdnuJilcwopG8b8I0cYoShUgYA3hfAD/CkYm+y2fZf++EY
         1ECFi4c9d8lWIJloF/tvGsVon9tPRJl9HzfxYfxMkFgGYVrPYSOBqSOXVp8ANYN0CA
         snjVM86TSlSSbN/id5kM/XpZE6JpGiC/wxveJowGB2Ichclt40yxNT2ag+2M8Ort+w
         Il2fzU2OtbJng==
Message-ID: <3e065920586e87e58a365eac94b69aabb3b244cb.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 08/15] net: allow ndo_get_stats64 to return
 an int error code
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Mon, 11 Jan 2021 14:24:52 -0800
In-Reply-To: <20210109172624.2028156-9-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-9-olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some drivers need to do special tricks to comply with the new policy
> of
> ndo_get_stats64 being sleepable. For example, the bonding driver,
> which
> derives its stats from its lower interfaces, must recurse with
> dev_get_stats into its lowers with no locks held. But for that to
> work,
> it needs to dynamically allocate some memory for a refcounted copy of
> its array of slave interfaces (because recursing unlocked means that
> the
> original one is subject to disappearing). And since memory allocation
> can fail under pressure, we should not let it go unnoticed, but
> instead
> propagate the error code.
> 
> This patch converts all implementations of .ndo_get_stats64 to return
> int, and propagates that to the dev_get_stats calling site. Error
> checking will be done in further patches.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v6:
> Remove the unused "int err" from __bond_release_one and add it in the
> patch it belongs to.
> 
> Changes in v5:
> None.
> 
> Changes in v4:
> Patch is new (Eric's suggestion).
> 

Just Give Eric the proper credit and add:

Suggested-by: Eric .. 


[...]

> @@ -354,4 +356,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port
> *port,
>  	}
>  
>  	return 0;
> -}
> \ No newline at end of file
> +}

Not related? 

[...]
> 
> -void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64
> *storage)
> +int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64
> *storage)
>  {
>  	const struct net_device_ops *ops = dev->netdev_ops;
> +	int err = 0;
>  
>  	if (ops->ndo_get_stats64) {
>  		memset(storage, 0, sizeof(*storage));
> -		ops->ndo_get_stats64(dev, storage);
> +		err = ops->ndo_get_stats64(dev, storage);
>  	} else if (ops->ndo_get_stats) {
>  		netdev_stats_to_stats64(storage, ops-
> >ndo_get_stats(dev));
>  	} else {
> @@ -10418,6 +10419,8 @@ void dev_get_stats(struct net_device *dev,
> struct rtnl_link_stats64 *storage)
>  	storage->rx_dropped += (unsigned long)atomic_long_read(&dev-
> >rx_dropped);
>  	storage->tx_dropped += (unsigned long)atomic_long_read(&dev-
> >tx_dropped);
>  	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev-
> >rx_nohandler);

Must be consistent here, if there was an error you should abort without
touching the caller provided storage, even if you can for some stats.

> +
> +	return err;
>  }
>  EXPORT_SYMBOL(dev_get_stats);
>  

