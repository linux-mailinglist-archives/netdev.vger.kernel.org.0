Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C270C60DEB9
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiJZKPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiJZKPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:15:39 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9291C40E31;
        Wed, 26 Oct 2022 03:15:33 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 7750B1102D;
        Wed, 26 Oct 2022 13:15:31 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 56210111A8;
        Wed, 26 Oct 2022 13:15:29 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 3440E3C07D9;
        Wed, 26 Oct 2022 13:15:29 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 29QAFR91036797;
        Wed, 26 Oct 2022 13:15:28 +0300
Date:   Wed, 26 Oct 2022 13:15:27 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
cc:     netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ipv4: fix source address and gateway mismatch under
 multiple default gateways
In-Reply-To: <20221026032017.3675060-1-william.xuanziyang@huawei.com>
Message-ID: <5e0249d-b6e1-44fa-147b-e2af65e56f64@ssi.bg>
References: <20221026032017.3675060-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 26 Oct 2022, Ziyang Xuan wrote:

> We found a problem that source address doesn't match with selected gateway
> under multiple default gateways. The reproducer is as following:
> 
> Setup in client as following:
> 
> $ ip link add link eth2 dev eth2.71 type vlan id 71
> $ ip link add link eth2 dev eth2.72 type vlan id 72
> $ ip addr add 192.168.71.41/24 dev eth2.71
> $ ip addr add 192.168.72.41/24 dev eth2.72
> $ ip link set eth2.71 up
> $ ip link set eth2.72 up
> $ route add -net default gw 192.168.71.1 dev eth2.71
> $ route add -net default gw 192.168.72.1 dev eth2.72

	Second route goes to first position due to the
prepend operation for the route add command. That is
why 192.168.72.41 is selected.

> Add a nameserver configuration in the following file:
> $ cat /etc/resolv.conf
> nameserver 8.8.8.8
> 
> Setup in peer server as following:
> 
> $ ip link add link eth2 dev eth2.71 type vlan id 71
> $ ip link add link eth2 dev eth2.72 type vlan id 72
> $ ip addr add 192.168.71.1/24 dev eth2.71
> $ ip addr add 192.168.72.1/24 dev eth2.72
> $ ip link set eth2.71 up
> $ ip link set eth2.72 up
> 
> Use the following command trigger DNS packet in client:
> $ ping www.baidu.com
> 
> Capture packets with tcpdump in client when ping:
> $ tcpdump -i eth2 -vne
> ...
> 20:30:22.996044 52:54:00:20:23:a9 > 52:54:00:d2:4f:e3, ethertype 802.1Q (0x8100), length 77: vlan 71, p 0, ethertype IPv4, (tos 0x0, ttl 64, id 25407, offset 0, flags [DF], proto UDP (17), length 59)
>     192.168.72.41.42666 > 8.8.8.8.domain: 58562+ A? www.baidu.com. (31)
> ...
> 
> We get the problem that IPv4 saddr "192.168.72.41" do not match with
> selected VLAN device "eth2.71".

	The problem could be that source address is selected
once and later used as source address in following routing lookups.

	And your routing rules do not express the restriction that
both addresses can not be used for specific route. If you have
such restriction which is common, you should use source-specific routes:

1. ip rule to consider table main only for link routes,
no default routes here

ip rule add prio 10 table main

2. source-specific routes:

ip rule add prio 20 from 192.168.71.0/24 table 20
ip route append default via 192.168.71.1 dev eth2.71 src 192.168.71.41 table 20
ip rule add prio 30 from 192.168.72.0/24 table 30
ip route append default via 192.168.72.1 dev eth2.72 src 192.168.72.41 table 30

3. Store default alternative routes not in table main:
ip rule add prio 200 table 200
ip route append default via 192.168.71.1 dev eth2.71 src 192.168.71.41 table 200
ip route append default via 192.168.72.1 dev eth2.72 src 192.168.72.41 table 200

	Above routes should work even without specifying prefsrc.

	As result, table 200 is used only for routing lookups
without specific source address, usually for first packet in
connection, next packets should hit tables 20/30.

	You can check https://ja.ssi.bg/dgd-usage.txt for such
examples, see under 2. Alternative routes and dead gateway detection

> In above scenario, the process does __ip_route_output_key() twice in
> ip_route_connect(), the two processes have chosen different default gateway,
> and the last choice is not the best.
> 
> Add flowi4->saddr and fib_nh_common->nhc_gw.ipv4 matching consideration in
> fib_select_default() to fix that.

	Other setups may not have such restriction, they can
prefer any gateway in reachable state no matter the saddr.

> Fixes: 19baf839ff4a ("[IPV4]: Add LC-Trie FIB lookup algorithm.")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/ipv4/fib_semantics.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index e9a7f70a54df..8bd94875a009 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -2046,6 +2046,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
>  	int order = -1, last_idx = -1;
>  	struct fib_alias *fa, *fa1 = NULL;
>  	u32 last_prio = res->fi->fib_priority;
> +	u8 prefix, max_prefix = 0;
>  	dscp_t last_dscp = 0;
>  
>  	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
> @@ -2078,6 +2079,11 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
>  		if (!nhc->nhc_gw_family || nhc->nhc_scope != RT_SCOPE_LINK)
>  			continue;
>  
> +		prefix = __ffs(flp->saddr ^ nhc->nhc_gw.ipv4);
> +		if (prefix < max_prefix)
> +			continue;
> +		max_prefix = max_t(u8, prefix, max_prefix);
> +
>  		fib_alias_accessed(fa);
>  
>  		if (!fi) {
> -- 
> 2.25.1

Regards

--
Julian Anastasov <ja@ssi.bg>

