Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4699142D4E5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhJNIdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:33:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:56688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhJNIdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:33:05 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maw8h-000GiS-Bp; Thu, 14 Oct 2021 10:30:59 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1maw8h-000WxQ-6D; Thu, 14 Oct 2021 10:30:59 +0200
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
To:     James Prestwood <prestwoj@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, dsahern@kernel.org,
        idosch@idosch.org
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d935a56e-39b6-70be-16a8-313282c3e6c4@iogearbox.net>
Date:   Thu, 14 Oct 2021 10:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211013222710.4162634-1-prestwoj@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26321/Wed Oct 13 10:21:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Adding few more to Cc ]

On 10/14/21 12:27 AM, James Prestwood wrote:
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
>      net: Evict neighbor entries on carrier down
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

Wouldn't it make more sense to extend neigh_flush_dev() where we skip eviction
of NUD_PERMANENT (see the skip_perm condition)? Either as a per table setting
(tbl->parms) or as a NTF_EXT_* flag for specific neighbors?

> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>   include/linux/inetdevice.h  | 1 +
>   include/uapi/linux/ip.h     | 1 +
>   include/uapi/linux/sysctl.h | 1 +
>   net/ipv4/arp.c              | 4 +++-
>   net/ipv4/devinet.c          | 4 ++++
>   5 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index 53aa0343bf69..63180170fdbd 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -133,6 +133,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
>   #define IN_DEV_ARP_ANNOUNCE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ANNOUNCE)
>   #define IN_DEV_ARP_IGNORE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_IGNORE)
>   #define IN_DEV_ARP_NOTIFY(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_NOTIFY)
> +#define IN_DEV_ARP_EVICT_NOCARRIER(in_dev) IN_DEV_CONF_GET((in_dev), ARP_EVICT_NOCARRIER)
>   
>   struct in_ifaddr {
>   	struct hlist_node	hash;
> diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
> index e42d13b55cf3..e00bbb9c47bb 100644
> --- a/include/uapi/linux/ip.h
> +++ b/include/uapi/linux/ip.h
> @@ -169,6 +169,7 @@ enum
>   	IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST,
>   	IPV4_DEVCONF_DROP_GRATUITOUS_ARP,
>   	IPV4_DEVCONF_BC_FORWARDING,
> +	IPV4_DEVCONF_ARP_EVICT_NOCARRIER,
>   	__IPV4_DEVCONF_MAX
>   };
>   
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 1e05d3caa712..6a3b194c50fe 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -482,6 +482,7 @@ enum
>   	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
>   	NET_IPV4_CONF_ARP_ACCEPT=21,
>   	NET_IPV4_CONF_ARP_NOTIFY=22,
> +	NET_IPV4_CONF_ARP_EVICT_NOCARRIER=23,
>   };
>   
>   /* /proc/sys/net/ipv4/netfilter */
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 922dd73e5740..50cfe4f37089 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -1247,6 +1247,7 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
>   {
>   	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>   	struct netdev_notifier_change_info *change_info;
> +	struct in_device *in_dev = __in_dev_get_rcu(dev);
>   
>   	switch (event) {
>   	case NETDEV_CHANGEADDR:
> @@ -1257,7 +1258,8 @@ static int arp_netdev_event(struct notifier_block *this, unsigned long event,
>   		change_info = ptr;
>   		if (change_info->flags_changed & IFF_NOARP)
>   			neigh_changeaddr(&arp_tbl, dev);
> -		if (!netif_carrier_ok(dev))
> +		if (IN_DEV_ARP_EVICT_NOCARRIER(in_dev) &&
> +		    !netif_carrier_ok(dev))
>   			neigh_carrier_down(&arp_tbl, dev);
>   		break;
>   	default:
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 1c6429c353a9..4ff4403749e0 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -75,6 +75,7 @@ static struct ipv4_devconf ipv4_devconf = {
>   		[IPV4_DEVCONF_SHARED_MEDIA - 1] = 1,
>   		[IPV4_DEVCONF_IGMPV2_UNSOLICITED_REPORT_INTERVAL - 1] = 10000 /*ms*/,
>   		[IPV4_DEVCONF_IGMPV3_UNSOLICITED_REPORT_INTERVAL - 1] =  1000 /*ms*/,
> +		[IPV4_DEVCONF_ARP_EVICT_NOCARRIER - 1] = 1,
>   	},
>   };
>   
> @@ -87,6 +88,7 @@ static struct ipv4_devconf ipv4_devconf_dflt = {
>   		[IPV4_DEVCONF_ACCEPT_SOURCE_ROUTE - 1] = 1,
>   		[IPV4_DEVCONF_IGMPV2_UNSOLICITED_REPORT_INTERVAL - 1] = 10000 /*ms*/,
>   		[IPV4_DEVCONF_IGMPV3_UNSOLICITED_REPORT_INTERVAL - 1] =  1000 /*ms*/,
> +		[IPV4_DEVCONF_ARP_EVICT_NOCARRIER - 1] = 1,
>   	},
>   };
>   
> @@ -2527,6 +2529,8 @@ static struct devinet_sysctl_table {
>   		DEVINET_SYSCTL_RW_ENTRY(ARP_IGNORE, "arp_ignore"),
>   		DEVINET_SYSCTL_RW_ENTRY(ARP_ACCEPT, "arp_accept"),
>   		DEVINET_SYSCTL_RW_ENTRY(ARP_NOTIFY, "arp_notify"),
> +		DEVINET_SYSCTL_RW_ENTRY(ARP_EVICT_NOCARRIER,
> +					"arp_evict_nocarrier"),
>   		DEVINET_SYSCTL_RW_ENTRY(PROXY_ARP_PVLAN, "proxy_arp_pvlan"),
>   		DEVINET_SYSCTL_RW_ENTRY(FORCE_IGMP_VERSION,
>   					"force_igmp_version"),
> 

