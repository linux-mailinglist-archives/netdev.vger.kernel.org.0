Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E775815E3
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239491AbiGZPDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiGZPDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:03:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057232DABF;
        Tue, 26 Jul 2022 08:03:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9829B60684;
        Tue, 26 Jul 2022 15:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52ECC433D7;
        Tue, 26 Jul 2022 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658847798;
        bh=mF/czrBaEBaTqlrWA7WXTcJE7IHQ+wgHBudG1UTQM7s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=b3PKH6STd01hi2hgGefps5S8J1XNy3q34ipUbTEM1nK7nDTPzE2TpYrrxUMMxvRpY
         U1ekCbZwA7KZ/sx4xaWeG1wXTfTLso0qlumWtzNVuKX1ZfIlSjbbRuk41263d/60Th
         hGWglSEUUD0WJNrRPcdes5cpgR2lSLenXg60USJBsey+U9C6OYhdkp3/OLPPBa120Z
         NmUf5uHGVoia+guY74eHwzmXAsgQc2IIgHSxITp/CXkcK8RN4SHsLTfIi79MoaP8C1
         wTsHFMZsSaeDOlfSpFl4ZmjIIQXS0L2xzjpCHWxf1z112gOfWIb95YVVXvVW16wumM
         SS5JK9RLpwBVA==
Message-ID: <48fd2345-ef86-da0d-c471-c576aa93d9f5@kernel.org>
Date:   Tue, 26 Jul 2022 09:03:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] ipv6/addrconf: fix a null-ptr-deref bug for
 ip6_ptr
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220726115028.3055296-1-william.xuanziyang@huawei.com>
 <CANn89iJNHhq9zbmL2DF-up_hBRHuwkPiNUpMS+LHoumy5ohQZA@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iJNHhq9zbmL2DF-up_hBRHuwkPiNUpMS+LHoumy5ohQZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 6:13 AM, Eric Dumazet wrote:
> On Tue, Jul 26, 2022 at 1:50 PM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
>> device while matching route. That may trigger null-ptr-deref bug
>> for ip6_ptr probability as following.
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
>> It is because ip6_ptr has been assigned to NULL in addrconf_ifdown() firstly,
>> then ip6_ignore_linkdown() accesses ip6_ptr directly without NULL check.
>>
>>         cpu0                    cpu1
>> fib6_table_lookup
>> __find_rr_leaf
>>                         addrconf_notify [ NETDEV_CHANGEMTU ]
>>                         addrconf_ifdown
>>                         RCU_INIT_POINTER(dev->ip6_ptr, NULL)
>> find_match
>> ip6_ignore_linkdown
>>
>> So we can add NULL check for ip6_ptr before using in ip6_ignore_linkdown() to
>> fix the null-ptr-deref bug.
>>
>> Fixes: 6d3d07b45c86 ("ipv6: Refactor fib6_ignore_linkdown")
> 
> If we need to backport, I guess dcd1f572954f ("net/ipv6: Remove fib6_idev")
> already had the bug.

Yes, that is the right Fixes commit.

> 
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>
>> ---
>> v2:
>>   - Use NULL check in ip6_ignore_linkdown() but synchronize_net() in
>>     addrconf_ifdown()
>>   - Add timing analysis of the problem
>>
>> ---
>>  include/net/addrconf.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
>> index f7506f08e505..c04f359655b8 100644
>> --- a/include/net/addrconf.h
>> +++ b/include/net/addrconf.h
>> @@ -405,6 +405,9 @@ static inline bool ip6_ignore_linkdown(const struct net_device *dev)
>>  {
>>         const struct inet6_dev *idev = __in6_dev_get(dev);
>>
>> +       if (unlikely(!idev))
>> +               return true;
>> +

Reviewed-by: David Ahern <dsahern@kernel.org>

> 
> Note that we might read a non NULL pointer here, but read it again
> later in rt6_score_route(),
> since another thread could switch the pointer under us ?
> 

for silly MTU games yes, that could happen.
