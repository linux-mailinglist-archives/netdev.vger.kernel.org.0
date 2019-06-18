Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B440E4A5FD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfFRP5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:57:33 -0400
Received: from mail.us.es ([193.147.175.20]:57340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfFRP5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 11:57:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1BAB81A0D
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 17:57:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1FE3DA71F
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 17:57:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BF153DA718; Tue, 18 Jun 2019 17:57:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70901DA701;
        Tue, 18 Jun 2019 17:57:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 17:57:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 22F294265A2F;
        Tue, 18 Jun 2019 17:57:25 +0200 (CEST)
Date:   Tue, 18 Jun 2019 17:57:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, Mingfangsen <mingfangsen@huawei.com>
Subject: Re: [PATCH v3] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Message-ID: <20190618155723.m4l5mkpo4ecmcajt@salvia>
References: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 09:43:53PM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
> ipv4/ipv6 packets will be dropped because in device is
> vrf but out device is an enslaved device. So failed with
> the check of the rpfilter.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/ipv4/netfilter/ipt_rpfilter.c  |  1 +
>  net/ipv6/netfilter/ip6t_rpfilter.c | 10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
> index 0b10d8812828..6e07cd0ecbec 100644
> --- a/net/ipv4/netfilter/ipt_rpfilter.c
> +++ b/net/ipv4/netfilter/ipt_rpfilter.c
> @@ -81,6 +81,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
>  	flow.flowi4_tos = RT_TOS(iph->tos);
>  	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
> +	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
> 
>  	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
>  }
> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index c3c6b09acdc4..a28c81322148 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -58,7 +58,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  	if (rpfilter_addr_linklocal(&iph->saddr)) {
>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>  		fl6.flowi6_oif = dev->ifindex;
> -	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
> +	} else if (((flags & XT_RPFILTER_LOOSE) == 0) ||
> +		   (netif_is_l3_master(dev)) ||
> +		   (netif_is_l3_slave(dev)))
>  		fl6.flowi6_oif = dev->ifindex;
> 
>  	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
> @@ -73,6 +75,12 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  		goto out;
>  	}
> 
> +	if (netif_is_l3_master(dev)) {
> +		dev = dev_get_by_index_rcu(dev_net(dev), IP6CB(skb)->iif);
> +		if (!dev)
> +			goto out;
> +	}

So, for the l3 device cases this makes:

#1 ip6_route_lookup() to fetch the route, using the device in xt_in()
   (the _LOOSE flag is ignored for the l3 device case).

#2 If this is a l3dev master, then you make a global lookup for the
   device using IP6CB(skb)->iif.

#3 You check if route matches with the device, using the new device
   from the lookup:

   if (rt->rt6i_idev->dev == dev ...

If there is no other way to fix this, OK, that's fair enough.

Still this fix looks a bit tricky to me.

And this assymmetric between the IPv4 and IPv6 codebase looks rare.

Probably someone can explain me this in more detail? I'd appreciate.

Thanks!
