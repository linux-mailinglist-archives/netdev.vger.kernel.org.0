Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F682444D2
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403813AbfFMQjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:39:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392609AbfFMQjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 12:39:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EACE0ADD9;
        Thu, 13 Jun 2019 16:39:41 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4D0E1E00E3; Thu, 13 Jun 2019 18:39:41 +0200 (CEST)
Date:   Thu, 13 Jun 2019 18:39:41 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     davem@davemloft.net, dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] ipoib: show VF broadcast address
Message-ID: <20190613163941.GK31797@unicorn.suse.cz>
References: <20190613142003.129391-1-dkirjanov@suse.com>
 <20190613142003.129391-4-dkirjanov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613142003.129391-4-dkirjanov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 04:20:03PM +0200, Denis Kirjanov wrote:
> in IPoIB case we can't see a VF broadcast address for but
> can see for PF
> 
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
> trust off, query_rss off
> ...
> 
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  include/uapi/linux/if_link.h | 5 +++++
>  net/core/rtnetlink.c         | 6 ++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 5b225ff63b48..1f36dd3a45d6 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -681,6 +681,7 @@ enum {
>  enum {
>  	IFLA_VF_UNSPEC,
>  	IFLA_VF_MAC,		/* Hardware queue specific attributes */
> +	IFLA_VF_BROADCAST,
>  	IFLA_VF_VLAN,		/* VLAN ID and QoS */
>  	IFLA_VF_TX_RATE,	/* Max TX Bandwidth Allocation */
>  	IFLA_VF_SPOOFCHK,	/* Spoof Checking on/off switch */

Oops, I forgot to mention one important point when reviewing v1: the new
attribute type must be added at the end (just before __IFLA_VF_MAX) so
that you do not change value of existing IFLA_VF_* constants (this would
break compatibility).

> @@ -704,6 +705,10 @@ struct ifla_vf_mac {
>  	__u8 mac[32]; /* MAX_ADDR_LEN */
>  };
>  
> +struct ifla_vf_broadcast {
> +	__u8 broadcast[32];
> +};
> +
>  struct ifla_vf_vlan {
>  	__u32 vf;
>  	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */

My first idea was that to question the need of a wrapping structure as
we couldn't modify that structure in the future anyway so that there
does not seem to be any gain against simply passing the address as a
binary with attribute length equal to address length (like we do with
IFLA_ADDRESS and IFLA_BROADCAST).

But then I checked other IFLA_VF_* attributes and I'm confused. The
structure seems to be

    IFLA_VF_INFO_LIST
        IFLA_VF_INFO
            IFLA_VF_MAC
            IFLA_VF_VLAN
            ...
        IFLA_VF_INFO
            IFLA_VF_MAC
            IFLA_VF_VLAN
            ...
        ...

Each IFLA_VF_INFO corresponds to one virtual function but its number is
not determined by an attribute within this nest. Instead, each of the
neste IFLA_VF_* attributes is a structure containing "__u32 vf" and it's
only matter of convention that within one IFLA_VF_INFO nest, all data
belongs to the same VF, neither do_setlink() nor do_setvfinfo() check
it.

I guess you should either follow this weird pattern or introduce proper
IFLA_VF_ID to be used for IFLA_VF_BROADCAST and all future IFLA_VF_*
attributes. However, each new attribute makes IFLA_VF_INFO bigger and
lowers the number of VFs that can be stored in an IFLA_VF_INFO_LIST nest
without exceeding the hard limit of 65535 bytes so that we cannot afford
to add too many.

> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index cec60583931f..88304212f127 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
...
> @@ -1753,6 +1758,7 @@ static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
>  
>  static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
>  	[IFLA_VF_MAC]		= { .len = sizeof(struct ifla_vf_mac) },
> +	[IFLA_VF_BROADCAST]	= {. len = sizeof(struct ifla_vf_broadcast) },
>  	[IFLA_VF_VLAN]		= { .len = sizeof(struct ifla_vf_vlan) },
>  	[IFLA_VF_VLAN_LIST]     = { .type = NLA_NESTED },
>  	[IFLA_VF_TX_RATE]	= { .len = sizeof(struct ifla_vf_tx_rate) },

As you do not implement setting the broadcast address (is that possible
at all?), NLA_REJECT would be more appropriate so that the request isn't
silently ignored.

Michal
