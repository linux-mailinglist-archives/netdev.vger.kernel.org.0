Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F7657E079
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiGVLGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGVLGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:06:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB2240BDE;
        Fri, 22 Jul 2022 04:06:44 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lq65D6DTXzkXQ5;
        Fri, 22 Jul 2022 19:04:16 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Jul 2022 19:06:41 +0800
Subject: Re: [net] ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220722074153.2454007-1-william.xuanziyang@huawei.com>
 <CANn89iKWr-VJVus9GbafrghR2MKUz64sX9fg1YA=oHE0SYdZCg@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <3e1a132a-c3b0-8e5d-ca23-1c02617d14cc@huawei.com>
Date:   Fri, 22 Jul 2022 19:06:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKWr-VJVus9GbafrghR2MKUz64sX9fg1YA=oHE0SYdZCg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

> On Fri, Jul 22, 2022 at 9:42 AM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
>> device while matching route. That may trigger null-ptr-deref bug
>> for ip6_ptr probability as following.
>>
>> Reproducer as following:
>> Firstly, prepare conditions:
>> $ip netns add ns1
>> $ip netns add ns2
>> $ip link add veth1 type veth peer name veth2
>> $ip link set veth1 netns ns1
>> $ip link set veth2 netns ns2
>> $ip netns exec ns1 ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1
>> $ip netns exec ns2 ip -6 addr add 2001:0db8:0:f101::2/64 dev veth2
>> $ip netns exec ns1 ifconfig veth1 up
>> $ip netns exec ns2 ifconfig veth2 up
>> $ip netns exec ns1 ip -6 route add 2000::/64 dev veth1 metric 1
>> $ip netns exec ns2 ip -6 route add 2001::/64 dev veth2 metric 1
>>
>> Secondly, execute the following two commands in two ssh windows
>> respectively:
>> $ip netns exec ns1 sh
>> $while true; do ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1; ip -6 route add 2000::/64 dev veth1 metric 1; ping6 2000::2; done
>>
>> $ip netns exec ns1 sh
>> $while true; do ip link set veth1 mtu 1000; ip link set veth1 mtu 1500; sleep 5; done
>>
>> And in order to increase the probability of reproduce,
>> we can add mdelay() in find_match() as following:
>>
>> static bool find_match(struct fib6_nh *nh, u32 fib6_flags,
>>         if (nh->fib_nh_flags & RTNH_F_DEAD)
>>                 goto out;
>>
>> +       mdelay(1000);
> 
> But adding a mdelay() in an rcu_read_lock() should not be possible.
> 
> I guess this means _this_ function is not properly using rcu protection.

This just to increase the probability during reproducing.

The problem needs ip6_ptr assigned to NULL in addrconf_ifdown() firstly,
then accesses ip6_ptr without any NULL check in ip6_ignore_linkdown().

	cpu0						cpu1
fib6_table_lookup [ under rcu_read_lock() ]
__find_rr_leaf [ traverse fib6_info list ]
						addrconf_notify [ NETDEV_CHANGEMTU ]
						addrconf_ifdown
						RCU_INIT_POINTER(dev->ip6_ptr, NULL)
find_match
ip6_ignore_linkdown

static inline bool ip6_ignore_linkdown(const struct net_device *dev)
{
	const struct inet6_dev *idev = __in6_dev_get(dev);

	// without NULL check, access idev directly. If idev is NULL, null-ptr-deref occur.
	return !!idev->cnf.ignore_routes_with_linkdown;
}

> 
>>         if (ip6_ignore_linkdown(nh->fib_nh_dev) &&
>>             nh->fib_nh_flags & RTNH_F_LINKDOWN &&
>>             !(strict & RT6_LOOKUP_F_IGNORE_LINKSTATE))
>>
>> =========================================================
>> BUG: KASAN: null-ptr-deref in find_match.part.0+0x70/0x134
>> Read of size 4 at addr 0000000000000308 by task ping6/263
>>
>> CPU: 2 PID: 263 Comm: ping6 Not tainted 5.19.0-rc7+ #14
>> Call trace:
>>  dump_backtrace+0x1a8/0x230
>>  show_stack+0x20/0x70
>>  dump_stack_lvl+0x68/0x84
>>  print_report+0xc4/0x120
>>  kasan_report+0x84/0x120
>>  __asan_load4+0x94/0xd0
>>  find_match.part.0+0x70/0x134
>>  __find_rr_leaf+0x408/0x470
>>  fib6_table_lookup+0x264/0x540
>>  ip6_pol_route+0xf4/0x260
>>  ip6_pol_route_output+0x58/0x70
>>  fib6_rule_lookup+0x1a8/0x330
>>  ip6_route_output_flags_noref+0xd8/0x1a0
>>  ip6_route_output_flags+0x58/0x160
>>  ip6_dst_lookup_tail+0x5b4/0x85c
>>  ip6_dst_lookup_flow+0x98/0x120
>>  rawv6_sendmsg+0x49c/0xc70
>>  inet_sendmsg+0x68/0x94
>>  sock_sendmsg+0x8c/0xb0
>>
>> It is because ip6_ptr has been assigned to NULL in addrconf_ifdown(),
>> and ip6_ignore_linkdown() in find_match() accesses ip6_ptr directly.
>> Although find_match() routine is under rcu_read_lock(), but there is
>> not synchronize_net() before assign NULL to make rcu grace period end.
>>
> 
> This is not how RCU works.
> 
>> So we can add synchronize_net() before assign ip6_ptr to NULL in
>> addrconf_ifdown() to fix the null-ptr-deref bug.
> 
> This does not make sense to me.
> 
>>
>> Fixes: 8814c4b53381 ("[IPV6] ADDRCONF: Convert addrconf_lock to RCU.")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  net/ipv6/addrconf.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index 49cc6587dd77..63d33b29ad21 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -3757,6 +3757,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>>                 idev->dead = 1;
>>
>>                 /* protected by rtnl_lock */
>> +               synchronize_net();
> 
> I do not think we want yet another expensive synchronize_net(),
> especially  before setting ip6_ptr to NULL

Maybe the following solution can be considered.

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index f7506f08e505..c04f359655b8 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -405,6 +405,9 @@ static inline bool ip6_ignore_linkdown(const struct net_device *dev)
 {
        const struct inet6_dev *idev = __in6_dev_get(dev);

+       if (unlikely(!idev))
+               return true;
+
        return !!idev->cnf.ignore_routes_with_linkdown;
 }

> 
> 
> 
>>                 RCU_INIT_POINTER(dev->ip6_ptr, NULL);
>>
>>                 /* Step 1.5: remove snmp6 entry */
>> --
>> 2.25.1
>>
> .
> 
