Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EEA611F58
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 04:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJ2CiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 22:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJ2CiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 22:38:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B4B20F78;
        Fri, 28 Oct 2022 19:38:20 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mzk425T5gz15MDD;
        Sat, 29 Oct 2022 10:33:22 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 10:38:18 +0800
Subject: Re: [PATCH net] ipv4: fix source address and gateway mismatch under
 multiple default gateways
To:     Julian Anastasov <ja@ssi.bg>
CC:     <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20221026032017.3675060-1-william.xuanziyang@huawei.com>
 <5e0249d-b6e1-44fa-147b-e2af65e56f64@ssi.bg>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <dd75da01-ef55-cd4f-4e8c-12c6b5cc4ab7@huawei.com>
Date:   Sat, 29 Oct 2022 10:38:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5e0249d-b6e1-44fa-147b-e2af65e56f64@ssi.bg>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> 	Hello,
> 
> On Wed, 26 Oct 2022, Ziyang Xuan wrote:
> 
>> We found a problem that source address doesn't match with selected gateway
>> under multiple default gateways. The reproducer is as following:
>>
>> Setup in client as following:
>>
>> $ ip link add link eth2 dev eth2.71 type vlan id 71
>> $ ip link add link eth2 dev eth2.72 type vlan id 72
>> $ ip addr add 192.168.71.41/24 dev eth2.71
>> $ ip addr add 192.168.72.41/24 dev eth2.72
>> $ ip link set eth2.71 up
>> $ ip link set eth2.72 up
>> $ route add -net default gw 192.168.71.1 dev eth2.71
>> $ route add -net default gw 192.168.72.1 dev eth2.72
> 
> 	Second route goes to first position due to the
> prepend operation for the route add command. That is
> why 192.168.72.41 is selected.
> 
>> Add a nameserver configuration in the following file:
>> $ cat /etc/resolv.conf
>> nameserver 8.8.8.8
>>
>> Setup in peer server as following:
>>
>> $ ip link add link eth2 dev eth2.71 type vlan id 71
>> $ ip link add link eth2 dev eth2.72 type vlan id 72
>> $ ip addr add 192.168.71.1/24 dev eth2.71
>> $ ip addr add 192.168.72.1/24 dev eth2.72
>> $ ip link set eth2.71 up
>> $ ip link set eth2.72 up
>>
>> Use the following command trigger DNS packet in client:
>> $ ping www.baidu.com
>>
>> Capture packets with tcpdump in client when ping:
>> $ tcpdump -i eth2 -vne
>> ...
>> 20:30:22.996044 52:54:00:20:23:a9 > 52:54:00:d2:4f:e3, ethertype 802.1Q (0x8100), length 77: vlan 71, p 0, ethertype IPv4, (tos 0x0, ttl 64, id 25407, offset 0, flags [DF], proto UDP (17), length 59)
>>     192.168.72.41.42666 > 8.8.8.8.domain: 58562+ A? www.baidu.com. (31)
>> ...
>>
>> We get the problem that IPv4 saddr "192.168.72.41" do not match with
>> selected VLAN device "eth2.71".
> 
> 	The problem could be that source address is selected
> once and later used as source address in following routing lookups.
> 
> 	And your routing rules do not express the restriction that
> both addresses can not be used for specific route. If you have
> such restriction which is common, you should use source-specific routes:

Hi Julian,

Thank you for your quick reply.

Can we make some work to make the restriction "both addresses can not be used for specific route" in code but in consciousness?

Thanks.

> 
> 1. ip rule to consider table main only for link routes,
> no default routes here
> 
> ip rule add prio 10 table main
> 
> 2. source-specific routes:
> 
> ip rule add prio 20 from 192.168.71.0/24 table 20
> ip route append default via 192.168.71.1 dev eth2.71 src 192.168.71.41 table 20
> ip rule add prio 30 from 192.168.72.0/24 table 30
> ip route append default via 192.168.72.1 dev eth2.72 src 192.168.72.41 table 30
> 
> 3. Store default alternative routes not in table main:
> ip rule add prio 200 table 200
> ip route append default via 192.168.71.1 dev eth2.71 src 192.168.71.41 table 200
> ip route append default via 192.168.72.1 dev eth2.72 src 192.168.72.41 table 200
> 
> 	Above routes should work even without specifying prefsrc.
> 
> 	As result, table 200 is used only for routing lookups
> without specific source address, usually for first packet in
> connection, next packets should hit tables 20/30.
> 
> 	You can check https://ja.ssi.bg/dgd-usage.txt for such
> examples, see under 2. Alternative routes and dead gateway detection
> 
>> In above scenario, the process does __ip_route_output_key() twice in
>> ip_route_connect(), the two processes have chosen different default gateway,
>> and the last choice is not the best.
>>
>> Add flowi4->saddr and fib_nh_common->nhc_gw.ipv4 matching consideration in
>> fib_select_default() to fix that.
> 
> 	Other setups may not have such restriction, they can
> prefer any gateway in reachable state no matter the saddr.
> 
>> Fixes: 19baf839ff4a ("[IPV4]: Add LC-Trie FIB lookup algorithm.")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  net/ipv4/fib_semantics.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index e9a7f70a54df..8bd94875a009 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -2046,6 +2046,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
>>  	int order = -1, last_idx = -1;
>>  	struct fib_alias *fa, *fa1 = NULL;
>>  	u32 last_prio = res->fi->fib_priority;
>> +	u8 prefix, max_prefix = 0;
>>  	dscp_t last_dscp = 0;
>>  
>>  	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
>> @@ -2078,6 +2079,11 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
>>  		if (!nhc->nhc_gw_family || nhc->nhc_scope != RT_SCOPE_LINK)
>>  			continue;
>>  
>> +		prefix = __ffs(flp->saddr ^ nhc->nhc_gw.ipv4);
>> +		if (prefix < max_prefix)
>> +			continue;
>> +		max_prefix = max_t(u8, prefix, max_prefix);
>> +
>>  		fib_alias_accessed(fa);
>>  
>>  		if (!fi) {
>> -- 
>> 2.25.1
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
> 
> .
> 
