Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CF415B323
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBLV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:57:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:33418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgBLV5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:57:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88284AF98;
        Wed, 12 Feb 2020 21:57:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D3A4BE03B3; Wed, 12 Feb 2020 22:57:22 +0100 (CET)
Date:   Wed, 12 Feb 2020 22:57:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: Fix route replacement with dev-only route
Message-ID: <20200212215722.GB21997@unicorn.suse.cz>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:41:06AM +0900, Benjamin Poirier wrote:
> After commit 27596472473a ("ipv6: fix ECMP route replacement") it is no
> longer possible to replace an ECMP-able route by a non ECMP-able route.
> For example,
> 	ip route add 2001:db8::1/128 via fe80::1 dev dummy0
> 	ip route replace 2001:db8::1/128 dev dummy0
> does not work as expected.
> 
> Tweak the replacement logic so that point 3 in the log of the above commit
> becomes:
> 3. If the new route is not ECMP-able, and no matching non-ECMP-able route
> exists, replace matching ECMP-able route (if any) or add the new route.
> 
> We can now summarize the entire replace semantics to:
> When doing a replace, prefer replacing a matching route of the same
> "ECMP-able-ness" as the replace argument. If there is no such candidate,
> fallback to the first route found.
> 
> Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ipv6/ip6_fib.c                       | 7 ++++---
>  tools/testing/selftests/net/fib_tests.sh | 6 ++++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 58fbde244381..72abf892302f 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -1102,8 +1102,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
>  					found++;
>  					break;
>  				}
> -				if (rt_can_ecmp)
> -					fallback_ins = fallback_ins ?: ins;
> +				fallback_ins = fallback_ins ?: ins;
>  				goto next_iter;
>  			}
>  
> @@ -1146,7 +1145,9 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
>  	}
>  
>  	if (fallback_ins && !found) {
> -		/* No ECMP-able route found, replace first non-ECMP one */
> +		/* No matching route with same ecmp-able-ness found, replace
> +		 * first matching route
> +		 */
>  		ins = fallback_ins;
>  		iter = rcu_dereference_protected(*ins,
>  				    lockdep_is_held(&rt->fib6_table->tb6_lock));
> diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> index 6dd403103800..60273f1bc7d9 100755
> --- a/tools/testing/selftests/net/fib_tests.sh
> +++ b/tools/testing/selftests/net/fib_tests.sh
> @@ -910,6 +910,12 @@ ipv6_rt_replace_mpath()
>  	check_route6 "2001:db8:104::/64 via 2001:db8:101::3 dev veth1 metric 1024"
>  	log_test $? 0 "Multipath with single path via multipath attribute"
>  
> +	# multipath with dev-only
> +	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
> +	run_cmd "$IP -6 ro replace 2001:db8:104::/64 dev veth1"
> +	check_route6 "2001:db8:104::/64 dev veth1 metric 1024"
> +	log_test $? 0 "Multipath with dev-only"
> +
>  	# route replace fails - invalid nexthop 1
>  	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
>  	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:111::3 nexthop via 2001:db8:103::3"
> -- 
> 2.25.0
> 
