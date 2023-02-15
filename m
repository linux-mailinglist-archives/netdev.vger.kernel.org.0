Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9199C69766A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 07:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjBOG25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 01:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjBOG2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:28:55 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679F83609F;
        Tue, 14 Feb 2023 22:28:31 -0800 (PST)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PGp3t4nR4zRs3G;
        Wed, 15 Feb 2023 14:25:46 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 15 Feb 2023 14:28:19 +0800
Subject: Re: [PATCH net] ipv6: Add lwtunnel encap size of all siblings in
 nexthop calculation
To:     David Ahern <dsahern@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230214092933.3817533-1-luwei32@huawei.com>
 <32817680-56e6-594c-2acb-0022e4e8548e@kernel.org>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <0fa82f21-015a-c89f-c837-18df04c3965d@huawei.com>
Date:   Wed, 15 Feb 2023 14:28:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <32817680-56e6-594c-2acb-0022e4e8548e@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ok, I will send v2 version

在 2023/2/14 11:45 PM, David Ahern 写道:
> On 2/14/23 2:29 AM, Lu Wei wrote:
>> In function rt6_nlmsg_size(), the length of nexthop is calculated
>> by multipling the nexthop length of fib6_info and the number of
>> siblings. However if the fib6_info has no lwtunnel but the siblings
>> have lwtunnels, the nexthop length is less than it should be, and
>> it will trigger a warning in inet6_rt_notify() as follows:
>>
>> WARNING: CPU: 0 PID: 6082 at net/ipv6/route.c:6180 inet6_rt_notify+0x120/0x130
>> ......
>> Call Trace:
>>   <TASK>
>>   fib6_add_rt2node+0x685/0xa30
>>   fib6_add+0x96/0x1b0
>>   ip6_route_add+0x50/0xd0
>>   inet6_rtm_newroute+0x97/0xa0
>>   rtnetlink_rcv_msg+0x156/0x3d0
>>   netlink_rcv_skb+0x5a/0x110
>>   netlink_unicast+0x246/0x350
>>   netlink_sendmsg+0x250/0x4c0
>>   sock_sendmsg+0x66/0x70
>>   ___sys_sendmsg+0x7c/0xd0
>>   __sys_sendmsg+0x5d/0xb0
>>   do_syscall_64+0x3f/0x90
>>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>
>> This bug can be reproduced by script:
>>
>> ip -6 addr add 2002::2/64 dev ens2
>> ip -6 route add 100::/64 via 2002::1 dev ens2 metric 100
>>
>> for i in 10 20 30 40 50 60 70;
>> do
>> 	ip link add link ens2 name ipv_$i type ipvlan
>> 	ip -6 addr add 2002::$i/64 dev ipv_$i
>> 	ifconfig ipv_$i up
>> done
>>
>> for i in 10 20 30 40 50 60;
>> do
>> 	ip -6 route append 100::/64 encap ip6 dst 2002::$i via 2002::1
>> dev ipv_$i metric 100
>> done
>>
>> ip -6 route append 100::/64 via 2002::1 dev ipv_70 metric 100
> would be good to add that test to
>     tools/testing/selftests/net/fib_tests.sh
>
> along with a similar one for IPv4.
>
>> This patch fixes it by adding nexthop_len of every siblings using
>> rt6_nh_nlmsg_size().
>>
>> Fixes: beb1afac518d ("net: ipv6: Add support to dump multipath routes via RTA_MULTIPATH attribute")
>> Signed-off-by: Lu Wei <luwei32@huawei.com>
>> ---
>>   net/ipv6/route.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>
>
> .

-- 
Best Regards,
Lu Wei

