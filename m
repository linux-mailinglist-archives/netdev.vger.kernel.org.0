Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668973BED80
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhGGRz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 13:55:58 -0400
Received: from relay.sw.ru ([185.231.240.75]:54002 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhGGRzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 13:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=tEfE2VqgpC/vOu1Jn+j+qL1K3BXCnedDnYWrh/++J28=; b=sp3HgHSRcUfD2vxCg
        UJ5/t+ohIGa2sOMALHumKn8NfRb/h+A5LRjO77nQmXR7tHH9iHb9y/F1W0tiACw75ZE2rfQ1G/J3Z
        v9zgGeL2AgYYAUlOnk1h58VB68c4SVa5kmwLI0+PDR0HMY6tgWnESYSakWqBc2iRXYCpCUp3X6jjw
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m1BjQ-003ERE-RJ; Wed, 07 Jul 2021 20:53:08 +0300
Subject: Re: [PATCH IPV6 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1625665132.git.vvs@virtuozzo.com>
 <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
 <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
 <20210707094218.0e9b6ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <85c06696-eb66-3beb-e576-9f6ba0611d11@virtuozzo.com>
Date:   Wed, 7 Jul 2021 20:53:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 8:41 PM, Eric Dumazet wrote:
> On 7/7/21 6:42 PM, Jakub Kicinski wrote:
>> On Wed, 7 Jul 2021 08:45:13 -0600 David Ahern wrote:
>>> On 7/7/21 8:04 AM, Vasily Averin wrote:
>>>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>>>> index ff4f9eb..e5af740 100644
>>>> --- a/net/ipv6/ip6_output.c
>>>> +++ b/net/ipv6/ip6_output.c
>>>> @@ -61,9 +61,24 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
>>>>  	struct dst_entry *dst = skb_dst(skb);
>>>>  	struct net_device *dev = dst->dev;
>>>>  	const struct in6_addr *nexthop;
>>>> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
>>>>  	struct neighbour *neigh;
>>>>  	int ret;
>>>>  
>>>> +	/* Be paranoid, rather than too clever. */
>>>> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
>>>> +		struct sk_buff *skb2;
>>>> +
>>>> +		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));  
>>>
>>> why not use hh_len here?
>>
>> Is there a reason for the new skb? Why not pskb_expand_head()?
> 
> pskb_expand_head() might crash, if skb is shared.
> 
> We possibly can add a helper, factorizing all this,
> and eventually use pskb_expand_head() if safe.

Thank you for feedback, I'll do it in 2nd version.
	Vasily Averin
