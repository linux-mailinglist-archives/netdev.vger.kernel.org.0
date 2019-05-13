Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796EE1B6FE
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfEMNZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:25:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728434AbfEMNZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 09:25:51 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F099C31F1596DC0FA4C0;
        Mon, 13 May 2019 21:25:31 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 May 2019
 21:25:24 +0800
Subject: Re: [PATCH v3] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <kadlec@blackhole.kfki.hu>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>, Mingfangsen <mingfangsen@huawei.com>
References: <212e4feb-39de-2627-9948-bbb117ff4d4e@huawei.com>
 <20190513094203.atnko3xbim5hzb7y@salvia>
From:   linmiaohe <linmiaohe@huawei.com>
Message-ID: <e5083883-27c7-e210-0f94-d8177264bd84@huawei.com>
Date:   Mon, 13 May 2019 21:25:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190513094203.atnko3xbim5hzb7y@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/13 17:42, Pablo Neira Ayuso wrote:
> On Thu, Apr 25, 2019 at 09:43:53PM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>> When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
>> ipv4/ipv6 packets will be dropped because in device is
>> vrf but out device is an enslaved device. So failed with
>> the check of the rpfilter.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  net/ipv4/netfilter/ipt_rpfilter.c  |  1 +
>>  net/ipv6/netfilter/ip6t_rpfilter.c | 10 +++++++++-
>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>
> 
> Suggestion: Could you just call l3mdev_master_ifindex_rcu() when
> invoking rpfilter_lookup_reverse6() ?
> 
> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index c3c6b09acdc4..ce64ff5d6fb6 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -101,7 +101,8 @@ static bool rpfilter_mt(const struct sk_buff *skb,
> struct xt_action_param *par)
>         if (unlikely(saddrtype == IPV6_ADDR_ANY))
>                 return true ^ invert; /* not routable: forward path will drop it */
>  
> -       return rpfilter_lookup_reverse6(xt_net(par), skb, xt_in(par),
> +       return rpfilter_lookup_reverse6(xt_net(par), skb,
> +                                       l3mdev_master_ifindex_rcu(xt_in(par)),
>                                         info->flags) ^ invert;
>  }
> 
> .
>     rpfilter_lookup_reverse6 requests struct net_device *dev as third argument, so
what you really mean is this ?
 diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
 index c3c6b09acdc4..ce64ff5d6fb6 100644
 --- a/net/ipv6/netfilter/ip6t_rpfilter.c
 +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
 @@ -101,7 +101,8 @@ static bool rpfilter_mt(const struct sk_buff *skb,
 struct xt_action_param *par)
         if (unlikely(saddrtype == IPV6_ADDR_ANY))
                 return true ^ invert; /* not routable: forward path will drop it */

 -       return rpfilter_lookup_reverse6(xt_net(par), skb, xt_in(par),
 +       return rpfilter_lookup_reverse6(xt_net(par), skb,
 +                                       l3mdev_master_dev_rcu(xt_in(par)) ? : xt_in(par),
                                         info->flags) ^ invert;
  }
    I'am sorry but I tested this. It doesn't work. When flags with XT_RPFILTER_LOOSE set,
we need set fl6.flowi6_oif to complete fib lookup in an l3mdev domain. And we need
enslaved network device to compute rpfilter rather than l3 master device.
    Many thanks for your suggestion.
    Best regards.

