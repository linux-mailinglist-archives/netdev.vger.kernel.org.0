Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6315EC362
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiI0M41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiI0M4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:56:25 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5438F16707B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:56:23 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id EE7FA1EE84;
        Tue, 27 Sep 2022 15:56:20 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id DA4FC1ECDD;
        Tue, 27 Sep 2022 15:56:18 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 5AA963C043E;
        Tue, 27 Sep 2022 15:56:18 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 28RCuFB0061628;
        Tue, 27 Sep 2022 15:56:17 +0300
Date:   Tue, 27 Sep 2022 15:56:15 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ip: fix triggering of 'icmp redirect'
In-Reply-To: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
Message-ID: <6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg>
References: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 29 Aug 2022, Nicolas Dichtel wrote:

> __mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
> My understanding is that fib_validate_source() is used to know if the src
> address and the gateway address are on the same link. For that,
> fib_validate_source() returns 1 (same link) or 0 (not the same network).
> __mkroute_input() is the only user of these positive values, all other
> callers only look if the returned value is negative.
> 
> Since the below patch, fib_validate_source() didn't return anymore 1 when
> both addresses are on the same network, because the route lookup returns
> RT_SCOPE_LINK instead of RT_SCOPE_HOST. But this is, in fact, right.
> Let's adapat the test to return 1 again when both addresses are on the same
> link.
> 
> CC: stable@vger.kernel.org
> Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
> Reported-by: kernel test robot <yujie.liu@intel.com>
> Reported-by: Heng Qi <hengqi@linux.alibaba.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> This code exists since more than two decades:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=0c2c94df8133f
> 
> Please, feel free to comment if my analysis seems wrong.
> 
> Regards,
> Nicolas
> 
>  net/ipv4/fib_frontend.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index f361d3d56be2..943edf4ad4db 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -389,7 +389,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  	dev_match = dev_match || (res.type == RTN_LOCAL &&
>  				  dev == net->loopback_dev);
>  	if (dev_match) {
> -		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
> +		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;

	Looks like I'm late here. nhc_scope is related to the
nhc_gw. nhc_scope = RT_SCOPE_LINK means rt_gw4 is a target behing a GW 
(nhc_gw). OTOH, RT_SCOPE_HOST means nhc_gw is 0 (missing) or a local IP 
and as result, rt_gw4 is directly connected. IIRC, this should look
like this:

nhc_gw	nhc_scope		rt_gw4		fib_scope (route)
---------------------------------------------------------------------------
0	RT_SCOPE_NOWHERE	Host		RT_SCOPE_HOST (local)
0	RT_SCOPE_HOST		LAN_TARGET	RT_SCOPE_LINK (link)
LOCAL1	RT_SCOPE_HOST		LAN_TARGET	RT_SCOPE_LINK (link)
REM_GW1	RT_SCOPE_LINK		Universe	RT_SCOPE_UNIVERSE (indirect)

	For the code above: we do not check res->scope,
we are interested what is the nhc_gw's scope (LINK/HOST/NOWHERE).
It means, reverse route points back to same device and sender is not
reached via gateway REM_GW1.

	By changing it to nhc_scope >= RT_SCOPE_LINK, ret always
will be 1 because nhc_scope is not set below RT_SCOPE_LINK (253).
Note that RT_SCOPE_HOST is 254.

	Looks like calling fib_info_update_nhc_saddr() in
nh_create_ipv4() with fib_nh->fib_nh_scope (nhc_scope) is a problem,
it should be fib_nh->fib_nh_scope - 1 or something like that,
see below. 127.0.0.1 is selected because it is
ifa_scope = RT_SCOPE_HOST, lo is first device and fib_nh_scope is 
RT_SCOPE_HOST when GW is not provided while creating the nexthop.

	About commit 747c14307214:

- if nexthop_create() assigns always nhc_scope = RT_SCOPE_LINK then
the assumption is that all added gateways are forced to be used
for routes to universe? If GW is not provided, we should use
nhc_scope = RT_SCOPE_HOST to allow link routes, right?
Now, the question is, can I use same nexthop in routes
with different scope ? What if later I add local IP that matches
the IP used in nexthop? This nexthop's GW becomes local one.
But these are corner cases.

	What I see as things to change:

- fib_check_nexthop(): "scope == RT_SCOPE_HOST",
"Route with host scope can not have multiple nexthops".
Why not? We may need to spread traffic to multiple
local IPs. But this is old problem and needs more
investigation.

- as fib_check_nh() is called (and sets nhc_scope) in
nh_create_ipv4(), i.e. when a nexthop is added, we should
tune nhc_scope in nh_create_ipv4() by selecting fib_cfg.fc_scope
based on the present GW and then to provide it to fib_check_nh()
and fib_info_update_nhc_saddr. As result, this nexthop will get
valid nhc_scope based on the current IPs and link routes and
also valid nh_saddr (not 127.0.0.1). We can do it as follows:

	.fc_scope = cfg->gw.ipv4 ? RT_SCOPE_UNIVERSE :
				   RT_SCOPE_LINK,

	As result, we will also fix the scope provided to
fib_info_update_nhc_saddr which looks like the main
problem here.

- later, if created route refers to this nexthop,
fib_check_nexthop() should make sure the provided
route's scope is not >= the nhc_scope, may be a
check in nexthop_check_scope() is needed. This
will ensure that new link route is not using nexthop
with provided gateway.

- __fib_validate_source() should match for RT_SCOPE_HOST
as before.

- fib_check_nh_nongw: no GW => RT_SCOPE_HOST

	So, we return to all state but with fixed
argument to fib_info_update_nhc_saddr().

>  		return ret;
>  	}
>  	if (no_addr)
> @@ -401,7 +401,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  	ret = 0;
>  	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
>  		if (res.type == RTN_UNICAST)
> -			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
> +			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
>  	}
>  	return ret;
>  
> -- 
> 2.33.0

Regards

--
Julian Anastasov <ja@ssi.bg>

