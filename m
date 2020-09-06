Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A529925F088
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 22:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgIFU4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 16:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIFU4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 16:56:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 652B920C09;
        Sun,  6 Sep 2020 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599425766;
        bh=YThGDUg5nFUL/+bjdVbPqJVWfsFNLrETXsYiWQzi5OY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fO6J4lmEt5iR8ZPfMlUXpIDsp+0Jl6zGRs+kynqyq2vIRj2CcXOrCVPLct1WUq0+3
         unNwwaTqrm7UesoZ+Xld0RlC88nisPq70+IMtppn1Z/AXym1N19He1UkRyCTui41i9
         BXcr03y7QyxNPVM74tQgDRXJIUFejBYyXCL+Go24=
Date:   Sun, 6 Sep 2020 13:56:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH net-next v3 05/15] net: bridge: mcast: factor out port
 group del
Message-ID: <20200906135604.4d47b7a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905082410.2230253-6-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
        <20200905082410.2230253-6-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 11:24:00 +0300 Nikolay Aleksandrov wrote:
> @@ -843,24 +843,11 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
>  		if (!p->port || p->port->dev->ifindex != entry->ifindex)
>  			continue;
>  
> -		if (!hlist_empty(&p->src_list)) {
> -			err = -EINVAL;
> -			goto unlock;
> -		}
> -
>  		if (p->port->state == BR_STATE_DISABLED)
>  			goto unlock;
>  
> -		__mdb_entry_fill_flags(entry, p->flags);

Just from staring at the code it's unclear why the list_empty() check
and this __mdb_entry_fill_flags() are removed as well.

> -		rcu_assign_pointer(*pp, p->next);
> -		hlist_del_init(&p->mglist);
> -		del_timer(&p->timer);
> -		kfree_rcu(p, rcu);
> +		br_multicast_del_pg(mp, p, pp);
>  		err = 0;
> -
> -		if (!mp->ports && !mp->host_joined &&
> -		    netif_running(br->dev))
> -			mod_timer(&mp->timer, jiffies);
>  		break;


> +void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
> +			 struct net_bridge_port_group *pg,
> +			 struct net_bridge_port_group __rcu **pp)
> +{
> +	struct net_bridge *br = pg->port->br;
> +	struct net_bridge_group_src *ent;
> +	struct hlist_node *tmp;
> +
> +	rcu_assign_pointer(*pp, pg->next);
> +	hlist_del_init(&pg->mglist);
> +	del_timer(&pg->timer);
> +	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
> +		br_multicast_del_group_src(ent);
> +	br_mdb_notify(br->dev, pg->port, &pg->addr, RTM_DELMDB, pg->flags);
> +	kfree_rcu(pg, rcu);
> +
> +	if (!mp->ports && !mp->host_joined && netif_running(br->dev))
> +		mod_timer(&mp->timer, jiffies);
> +}

> @@ -1641,16 +1647,7 @@ br_multicast_leave_group(struct net_bridge *br,
>  			if (p->flags & MDB_PG_FLAGS_PERMANENT)
>  				break;
>  
> -			rcu_assign_pointer(*pp, p->next);
> -			hlist_del_init(&p->mglist);
> -			del_timer(&p->timer);
> -			kfree_rcu(p, rcu);
> -			br_mdb_notify(br->dev, port, group, RTM_DELMDB,
> -				      p->flags | MDB_PG_FLAGS_FAST_LEAVE);

And here we'll loose MDB_PG_FLAGS_FAST_LEAVE potentially?

> -			if (!mp->ports && !mp->host_joined &&
> -			    netif_running(br->dev))
> -				mod_timer(&mp->timer, jiffies);
> +			br_multicast_del_pg(mp, p, pp);
