Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91D65822DF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiG0JOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiG0JN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:13:59 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F78474E2;
        Wed, 27 Jul 2022 02:11:18 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lt7K923Syz9sv0;
        Wed, 27 Jul 2022 17:10:05 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Jul 2022 17:11:15 +0800
Subject: Re: [PATCH net v2] ipv6/addrconf: fix a null-ptr-deref bug for
 ip6_ptr
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220726115028.3055296-1-william.xuanziyang@huawei.com>
 <CANn89iJNHhq9zbmL2DF-up_hBRHuwkPiNUpMS+LHoumy5ohQZA@mail.gmail.com>
 <48fd2345-ef86-da0d-c471-c576aa93d9f5@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <b63eeb55-df38-618a-d7af-91b18f1d6f0f@huawei.com>
Date:   Wed, 27 Jul 2022 17:11:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <48fd2345-ef86-da0d-c471-c576aa93d9f5@kernel.org>
Content-Type: text/plain; charset="utf-8"
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

> On 7/26/22 6:13 AM, Eric Dumazet wrote:
>> On Tue, Jul 26, 2022 at 1:50 PM Ziyang Xuan
>> <william.xuanziyang@huawei.com> wrote:
>>>
>>> Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
>>> device while matching route. That may trigger null-ptr-deref bug
>>> for ip6_ptr probability as following.
>>>
>>> =========================================================
>>> BUG: KASAN: null-ptr-deref in find_match.part.0+0x70/0x134
>>> Read of size 4 at addr 0000000000000308 by task ping6/263
>>>
>>> CPU: 2 PID: 263 Comm: ping6 Not tainted 5.19.0-rc7+ #14
>>> Call trace:
>>>  dump_backtrace+0x1a8/0x230
>>>  show_stack+0x20/0x70
>>>  dump_stack_lvl+0x68/0x84
>>>  print_report+0xc4/0x120
>>>  kasan_report+0x84/0x120
>>>  __asan_load4+0x94/0xd0
>>>  find_match.part.0+0x70/0x134
>>>  __find_rr_leaf+0x408/0x470
>>>  fib6_table_lookup+0x264/0x540
>>>  ip6_pol_route+0xf4/0x260
>>>  ip6_pol_route_output+0x58/0x70
>>>  fib6_rule_lookup+0x1a8/0x330
>>>  ip6_route_output_flags_noref+0xd8/0x1a0
>>>  ip6_route_output_flags+0x58/0x160
>>>  ip6_dst_lookup_tail+0x5b4/0x85c
>>>  ip6_dst_lookup_flow+0x98/0x120
>>>  rawv6_sendmsg+0x49c/0xc70
>>>  inet_sendmsg+0x68/0x94
>>>
>>> Reproducer as following:
>>> Firstly, prepare conditions:
>>> $ip netns add ns1
>>> $ip netns add ns2
>>> $ip link add veth1 type veth peer name veth2
>>> $ip link set veth1 netns ns1
>>> $ip link set veth2 netns ns2
>>> $ip netns exec ns1 ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1
>>> $ip netns exec ns2 ip -6 addr add 2001:0db8:0:f101::2/64 dev veth2
>>> $ip netns exec ns1 ifconfig veth1 up
>>> $ip netns exec ns2 ifconfig veth2 up
>>> $ip netns exec ns1 ip -6 route add 2000::/64 dev veth1 metric 1
>>> $ip netns exec ns2 ip -6 route add 2001::/64 dev veth2 metric 1
>>>
>>> Secondly, execute the following two commands in two ssh windows
>>> respectively:
>>> $ip netns exec ns1 sh
>>> $while true; do ip -6 addr add 2001:0db8:0:f101::1/64 dev veth1; ip -6 route add 2000::/64 dev veth1 metric 1; ping6 2000::2; done
>>>
>>> $ip netns exec ns1 sh
>>> $while true; do ip link set veth1 mtu 1000; ip link set veth1 mtu 1500; sleep 5; done
>>>
>>> It is because ip6_ptr has been assigned to NULL in addrconf_ifdown() firstly,
>>> then ip6_ignore_linkdown() accesses ip6_ptr directly without NULL check.
>>>
>>>         cpu0                    cpu1
>>> fib6_table_lookup
>>> __find_rr_leaf
>>>                         addrconf_notify [ NETDEV_CHANGEMTU ]
>>>                         addrconf_ifdown
>>>                         RCU_INIT_POINTER(dev->ip6_ptr, NULL)
>>> find_match
>>> ip6_ignore_linkdown
>>>
>>> So we can add NULL check for ip6_ptr before using in ip6_ignore_linkdown() to
>>> fix the null-ptr-deref bug.
>>>
>>> Fixes: 6d3d07b45c86 ("ipv6: Refactor fib6_ignore_linkdown")
>>
>> If we need to backport, I guess dcd1f572954f ("net/ipv6: Remove fib6_idev")
>> already had the bug.
> 
> Yes, that is the right Fixes commit.

OK

> 
>>
>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>
>>> ---
>>> v2:
>>>   - Use NULL check in ip6_ignore_linkdown() but synchronize_net() in
>>>     addrconf_ifdown()
>>>   - Add timing analysis of the problem
>>>
>>> ---
>>>  include/net/addrconf.h | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
>>> index f7506f08e505..c04f359655b8 100644
>>> --- a/include/net/addrconf.h
>>> +++ b/include/net/addrconf.h
>>> @@ -405,6 +405,9 @@ static inline bool ip6_ignore_linkdown(const struct net_device *dev)
>>>  {
>>>         const struct inet6_dev *idev = __in6_dev_get(dev);
>>>
>>> +       if (unlikely(!idev))
>>> +               return true;
>>> +
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
>>
>> Note that we might read a non NULL pointer here, but read it again
>> later in rt6_score_route(),
>> since another thread could switch the pointer under us ?
>>

Yes, this patch just cover the problem I'm having.
I have checked the codes in kernel, there are some scenarios using __in6_dev_get()
without NULL check and rtnl_lock. There is a possibility of null-ptr-deref bug.
I will give a patch to fix them later.

> 
> for silly MTU games yes, that could happen.
> .
> 
