Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC434340DB
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 23:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhJSV4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 17:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhJSV4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 17:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 458B96128B;
        Tue, 19 Oct 2021 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634680440;
        bh=Qhl8Hka+eyDgZZhWZ1Nnmsfq1C1KyDSUpyC998vkusI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=omXxundUKqxEld6w8mibR32IfA9dQSnM83VRuTAwK785aOIXx83LabYsNK1mS+UXd
         S6G9bzDzlp01Lu/RtvHV/5Rd9KPEVFyhloYugrNyK46cZocAuJS33TyEI7+caApMAi
         Soz1hFbL9+R/BrTvqlWDxcKPSRhOARPpTnIZQWQS4BGk6Ce/BzwusJcnZmhoiyaGZh
         ZLWI4ABdmpzvhLTBLWm6Ofq45bDGh+WD70yrZhG6cR2jx8m9UakKx3H3mlKWZJYznR
         dBQ1hmojDHuofAYUHYGj2cUtBAr8lPj5qiHLTkLGUWfXU258eVoIdfUTfju9QHjNGI
         W4ZlXMQ5sd2CA==
Date:   Tue, 19 Oct 2021 14:53:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: Re: [PATCH v4] net: neighbour: introduce EVICT_NOCARRIER table
 option
Message-ID: <20211019145359.30465322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211018192657.481274-1-prestwoj@gmail.com>
References: <20211018192657.481274-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 12:26:57 -0700 James Prestwood wrote:
> This adds an option to ARP/NDISC tables that clears the table on
> NOCARRIER events. The default option (1) maintains existing
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
> The reason for this change is to allow userspace to control when
> the ARP/NDISC cache is cleared. In most cases the cache should be
> cleared on NOCARRIER, but in the context of a wireless roams the
> cache should not be cleared since the underlying network has not
> changed. Clearing the cache on a wireless roam can introduce delays
> in sending out packets (waiting for ARP/neighbor discovery) and
> this has been reported by a user here:
> 
> https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/
> 
> After some investigation it was found that the kernel was holding onto
> packets until ARP finished which resulted in this 1 second delay. It
> was also found that the first ARP who-has was never responded to,
> which is actually what causes the delay. This change is more or less
> working around this behavior, but again, there is no reason to clear
> the cache on a roam anyways.
> 
> As for the unanswered who-has, we know the packet made it OTA since
> it was seen while monitoring. Why it never received a response is
> unknown. In any case, since this is a problem on the AP side of things
> all that can be done is to work around it until it is solved.
> 
> Some background on testing/reproducing the packet delay:
> 
> Hardware:
>  - 2 access points configured for Fast BSS Transition (Though I don't
>    see why regular reassociation wouldn't have the same behavior)
>  - Wireless station running IWD as supplicant
>  - A device on network able to respond to pings (I used one of the APs)
> 
> Procedure:
>  - Connect to first AP
>  - Ping once to establish an ARP entry
>  - Start a tcpdump
>  - Roam to second AP
>  - Wait for operstate UP event, and note the timestamp
>  - Start pinging
> 
> Results:
> 
> Below is the tcpdump after UP. It was recorded the interface went UP at
> 10:42:01.432875.
> 
> 10:42:01.461871 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
> 10:42:02.497976 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
> 10:42:02.507162 ARP, Reply 192.168.254.1 is-at ac:86:74:55:b0:20, length 46
> 10:42:02.507185 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 1, length 64
> 10:42:02.507205 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 2, length 64
> 10:42:02.507212 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 3, length 64
> 10:42:02.507219 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 4, length 64
> 10:42:02.507225 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 5, length 64
> 10:42:02.507232 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 6, length 64
> 10:42:02.515373 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 1, length 64
> 10:42:02.521399 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 2, length 64
> 10:42:02.521612 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 3, length 64
> 10:42:02.521941 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 4, length 64
> 10:42:02.522419 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 5, length 64
> 10:42:02.523085 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 6, length 64
> 
> You can see the first ARP who-has went out very quickly after UP, but
> was never responded to. Nearly a second later the kernel retries and
> gets a response. Only then do the ping packets go out. If an ARP entry
> is manually added prior to UP (after the cache is cleared) it is seen
> that the first ping is never responded to, so its not only an issue with
> ARP but with data packets in general.
> 
> As mentioned prior, the wireless interface was also monitored to verify
> the ping/ARP packet made it OTA which was observed to be true.
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>

>  static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
> -			    bool skip_perm)
> +			    bool nocarrier)

If I'm reading this right nocarrier being false means this 
is a interface configuration even (ifconfig down). This reads
strange. Can we invert the logic and call the parameter ifdown 
or carrier_only?

>  {
>  	int i;
>  	struct neigh_hash_table *nht;
> @@ -336,7 +336,8 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
>  				np = &n->next;
>  				continue;
>  			}
> -			if (skip_perm && n->nud_state & NUD_PERMANENT) {
> +			if (nocarrier && ((n->nud_state & NUD_PERMANENT) ||
> +			    !NEIGH_VAR(n->parms, EVICT_NOCARRIER))) {

This is misaligned, please align the continuation line under the
innermost bracket it belongs to.

>  				np = &n->next;
>  				continue;
>  			}

> @@ -2249,6 +2252,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
>  	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
>  	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
>  	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
> +	[NDTPA_EVICT_NOCARRIER]		= { .type = NLA_U8 },

Input needs to be validated, right? NLA_POLICY_MAX(NLA_U8, 1) ?

>  };

> @@ -3679,6 +3686,7 @@ static struct neigh_sysctl_table {
>  		NEIGH_SYSCTL_UNRES_QLEN_REUSED_ENTRY(QUEUE_LEN, QUEUE_LEN_BYTES, "unres_qlen"),
>  		NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(RETRANS_TIME_MS, RETRANS_TIME, "retrans_time_ms"),
>  		NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(BASE_REACHABLE_TIME_MS, BASE_REACHABLE_TIME, "base_reachable_time_ms"),
> +		NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(EVICT_NOCARRIER, "evict_nocarrier"),

Same here, we need to accept only the meaningful values (0 and 1).

>  		[NEIGH_VAR_GC_INTERVAL] = {
>  			.procname	= "gc_interval",
>  			.maxlen		= sizeof(int),
