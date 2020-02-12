Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AE915B33F
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgBLV6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:58:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:33838 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgBLV6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:58:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2575DAF41;
        Wed, 12 Feb 2020 21:58:50 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C65A3E03B3; Wed, 12 Feb 2020 22:58:49 +0100 (CET)
Date:   Wed, 12 Feb 2020 22:58:49 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net 2/2] ipv6: Fix nlmsg_flags when splitting a multipath
 route
Message-ID: <20200212215849.GC21997@unicorn.suse.cz>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
 <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:41:07AM +0900, Benjamin Poirier wrote:
> When splitting an RTA_MULTIPATH request into multiple routes and adding the
> second and later components, we must not simply remove NLM_F_REPLACE but
> instead replace it by NLM_F_CREATE. Otherwise, it may look like the netlink
> message was malformed.
> 
> For example,
> 	ip route add 2001:db8::1/128 dev dummy0
> 	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0 \
> 		nexthop via fe80::30:2 dev dummy0
> results in the following warnings:
> [ 1035.057019] IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
> [ 1035.057517] IPv6: NLM_F_CREATE should be set when creating new route
> 
> This patch makes the nlmsg sequence look equivalent for __ip6_ins_rt() to
> what it would get if the multipath route had been added in multiple netlink
> operations:
> 	ip route add 2001:db8::1/128 dev dummy0
> 	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0
> 	ip route append 2001:db8::1/128 nexthop via fe80::30:2 dev dummy0
> 
> Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ipv6/route.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 4fbdc60b4e07..2931224b674e 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5198,6 +5198,7 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
>  		 */
>  		cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
>  						     NLM_F_REPLACE);
> +		cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
>  		nhn++;
>  	}
>  
> -- 
> 2.25.0
> 
