Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606B642CF3B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJMXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJMXjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2171860D42;
        Wed, 13 Oct 2021 23:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634168235;
        bh=tH7OxBaODcZX6FpUHPJtnIb+9dAJvOy5YBRm2R92DOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qmr27fwmjZpf8YfNtVVmjdDy0XE4xQgdbKNbwBfLwjlkibWUL4NyTJGxnRDjAAzrQ
         TcyceDsEzNV1x9Abg7b2KagAFIaUWkfhVlcoEyACyvPDSLoZd2em2OcUW6kReAd349
         RSzhQyNlTp7x/NTaiR/5I06p0OiPjeroi7IfPCEaZp0SO7jKeUWQUolhKKDin4ZY+b
         SIRjnvzYmEBIZ0b2ZqYEItEphyYFEFczFol3qgEi0Sm66UCNmWKHtJ7e6FeHRMcnOL
         jFKXUW0XYcTcJqgZu/ew1NblRkSccbjn2/f/JQDDxSnNVPCqvOjfG8fZeOrdjd7dAH
         8LasPMCAtnLfg==
Date:   Wed, 13 Oct 2021 16:37:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
Message-ID: <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013222710.4162634-1-prestwoj@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 15:27:07 -0700 James Prestwood wrote:
> This change introduces a new sysctl parameter, arp_evict_nocarrier.
> When set (default) the ARP cache will be cleared on a NOCARRIER event.
> This new option has been defaulted to '1' which maintains existing
> behavior.
> 
> Clearing the ARP cache on NOCARRIER is relatively new, introduced by:
> 
> commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> Author: David Ahern <dsahern@gmail.com>
> Date:   Thu Oct 11 20:33:49 2018 -0700
> 
>     net: Evict neighbor entries on carrier down
> 
> The reason for this changes is to prevent the ARP cache from being
> cleared when a wireless device roams. Specifically for wireless roams
> the ARP cache should not be cleared because the underlying network has not
> changed. Clearing the ARP cache in this case can introduce significant
> delays sending out packets after a roam.
> 
> A user reported such a situation here:
> 
> https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/
> 
> After some investigation it was found that the kernel was holding onto
> packets until ARP finished which resulted in this 1 second delay. It
> was also found that the first ARP who-has was never responded to,
> which is actually what caues the delay. This change is more or less
> working around this behavior, but again, there is no reason to clear
> the cache on a roam anyways.
> 
> As for the unanswered who-has, we know the packet made it OTA since
> it was seen while monitoring. Why it never received a response is
> unknown.
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>

Seems sensible at a glance, some quick feedback.

Please make sure you run ./scripts/get_maintainers.pl on the patch
and add appropriate folks to CC.

Please rebase the code on top of this tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index 53aa0343bf69..63180170fdbd 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -133,6 +133,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
>  #define IN_DEV_ARP_ANNOUNCE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ANNOUNCE)
>  #define IN_DEV_ARP_IGNORE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_IGNORE)
>  #define IN_DEV_ARP_NOTIFY(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_NOTIFY)
> +#define IN_DEV_ARP_EVICT_NOCARRIER(in_dev) IN_DEV_CONF_GET((in_dev), ARP_EVICT_NOCARRIER)

IN_DEV_ANDCONF() makes most sense, I'd think.

>  struct in_ifaddr {
>  	struct hlist_node	hash;

> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 922dd73e5740..50cfe4f37089 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -1247,6 +1247,7 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
>  {
>  	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>  	struct netdev_notifier_change_info *change_info;
> +	struct in_device *in_dev = __in_dev_get_rcu(dev);

Don't we need to hold the RCU lock to call this?

>  	switch (event) {
>  	case NETDEV_CHANGEADDR:
> @@ -1257,7 +1258,8 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
>  		change_info = ptr;
>  		if (change_info->flags_changed & IFF_NOARP)
>  			neigh_changeaddr(&arp_tbl, dev);
> -		if (!netif_carrier_ok(dev))
> +		if (IN_DEV_ARP_EVICT_NOCARRIER(in_dev) &&
> +		    !netif_carrier_ok(dev))
>  			neigh_carrier_down(&arp_tbl, dev);
>  		break;
>  	default:
