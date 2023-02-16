Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039A0698C3E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjBPFpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBPFpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:45:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A164122A16;
        Wed, 15 Feb 2023 21:45:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51678B825D4;
        Thu, 16 Feb 2023 05:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39ACC433EF;
        Thu, 16 Feb 2023 05:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526307;
        bh=8iKXYlElwkfTRM4Qa75VuJIyTGdAOJpibU+USOqfrdM=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=uh/A27eczso0H9BjKdI12qzmUpAXuHeqM/oH5oiRJjrCku1VHkLFL/PUkS5gw6Lac
         Sep5NPDeoigO0x89Pv2dui3ZPANZAdnZomIdrLoF5Z5WmSbwaZvHGVnGFMT+2e/7Ow
         L39JEsPPLRID9tOHYq1kf5lETw1TQGvuveIYySGhwmBwSScTA3Tyhs3hht/lhv8u2k
         UlBmB0z2QznWnAfimy+UIo6ygf+b8eo81xK34hzs7QIpmQalytOwFr2EirVcj1lyNs
         G8WpTYn8m2Y+tlkrZ3XyAPyPTeQlR3Jk5cfQEP9yvS5vaMOroLjjK6xCCjEkp5VzPa
         4Ao4nFaIXlURw==
Message-ID: <2d3929ae-d7c6-80f4-a61f-f087073bc684@kernel.org>
Date:   Wed, 15 Feb 2023 22:45:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net,v2,1/2] ipv6: Add lwtunnel encap size of all siblings
 in nexthop calculation
Content-Language: en-US
To:     Lu Wei <luwei32@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230216042624.4069910-1-luwei32@huawei.com>
 <20230216042624.4069910-2-luwei32@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230216042624.4069910-2-luwei32@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 9:26 PM, Lu Wei wrote:
> In function rt6_nlmsg_size(), the length of nexthop is calculated
> by multipling the nexthop length of fib6_info and the number of
> siblings. However if the fib6_info has no lwtunnel but the siblings
> have lwtunnels, the nexthop length is less than it should be, and
> it will trigger a warning in inet6_rt_notify() as follows:
> 
> WARNING: CPU: 0 PID: 6082 at net/ipv6/route.c:6180 inet6_rt_notify+0x120/0x130
> ......
> Call Trace:
>  <TASK>
>  fib6_add_rt2node+0x685/0xa30
>  fib6_add+0x96/0x1b0
>  ip6_route_add+0x50/0xd0
>  inet6_rtm_newroute+0x97/0xa0
>  rtnetlink_rcv_msg+0x156/0x3d0
>  netlink_rcv_skb+0x5a/0x110
>  netlink_unicast+0x246/0x350
>  netlink_sendmsg+0x250/0x4c0
>  sock_sendmsg+0x66/0x70
>  ___sys_sendmsg+0x7c/0xd0
>  __sys_sendmsg+0x5d/0xb0
>  do_syscall_64+0x3f/0x90
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> 
> This bug can be reproduced by script:
> 
> ip -6 addr add 2002::2/64 dev ens2
> ip -6 route add 100::/64 via 2002::1 dev ens2 metric 100
> 
> for i in 10 20 30 40 50 60 70;
> do
> 	ip link add link ens2 name ipv_$i type ipvlan
> 	ip -6 addr add 2002::$i/64 dev ipv_$i
> 	ifconfig ipv_$i up
> done
> 
> for i in 10 20 30 40 50 60;
> do
> 	ip -6 route append 100::/64 encap ip6 dst 2002::$i via 2002::1
> dev ipv_$i metric 100
> done
> 
> ip -6 route append 100::/64 via 2002::1 dev ipv_70 metric 100
> 
> This patch fixes it by adding nexthop_len of every siblings using
> rt6_nh_nlmsg_size().
> 
> Fixes: beb1afac518d ("net: ipv6: Add support to dump multipath routes via RTA_MULTIPATH attribute")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/ipv6/route.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


