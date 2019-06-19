Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CC84B567
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbfFSJtI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 05:49:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6938 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731186AbfFSJtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 05:49:07 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 55BFF979A653C45FD5B1;
        Wed, 19 Jun 2019 17:49:05 +0800 (CST)
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Jun 2019 17:49:04 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme763-chm.china.huawei.com (10.3.19.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 19 Jun 2019 17:49:04 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1591.008;
 Wed, 19 Jun 2019 17:49:04 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: [PATCH v3] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Topic: [PATCH v3] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Index: AdUmfDnLJBRdmfpcd0eT0vsD259sjw==
Date:   Wed, 19 Jun 2019 09:49:04 +0000
Message-ID: <30442ee669c44d9db01fb374b73fd2dd@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/18 23:58, Pablo Neira Ayuso wrote:
> On Thu, Apr 25, 2019 at 09:43:53PM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>> When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
>> ipv4/ipv6 packets will be dropped because in device is vrf but out 
>> device is an enslaved device. So failed with the check of the 
>> rpfilter.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>> --- a/net/ipv4/netfilter/ipt_rpfilter.c
>> +++ b/net/ipv4/netfilter/ipt_rpfilter.c
>> @@ -81,6 +81,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>  	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
>>  	flow.flowi4_tos = RT_TOS(iph->tos);
>>  	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
>> +	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
>>
>>  	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par),
>> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
>> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
>> @@ -58,7 +58,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>>  	if (rpfilter_addr_linklocal(&iph->saddr)) {
>>  		lookup_flags |= RT6_LOOKUP_F_IFACE;
>>  		fl6.flowi6_oif = dev->ifindex;
>> -	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
>> +	} else if (((flags & XT_RPFILTER_LOOSE) == 0) ||
>> +		   (netif_is_l3_master(dev)) ||
>> +		   (netif_is_l3_slave(dev)))
>>  		fl6.flowi6_oif = dev->ifindex;
>>
>>  	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags); @@
>> -73,6 +75,12 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>>  		goto out;
>>  	}
>>
>> +	if (netif_is_l3_master(dev)) {
>> +		dev = dev_get_by_index_rcu(dev_net(dev), IP6CB(skb)->iif);
>> +		if (!dev)
>> +			goto out;
>> +	}
> 
> So, for the l3 device cases this makes:
> 
> #1 ip6_route_lookup() to fetch the route, using the device in xt_in()
>    (the _LOOSE flag is ignored for the l3 device case).
> 
> #2 If this is a l3dev master, then you make a global lookup for the
>    device using IP6CB(skb)->iif.
> 
> #3 You check if route matches with the device, using the new device
>    from the lookup:
> 
>    if (rt->rt6i_idev->dev == dev ...
> 
> If there is no other way to fix this, OK, that's fair enough.
> 
> Still this fix looks a bit tricky to me.
> 
> And this assymmetric between the IPv4 and IPv6 codebase looks rare.
> 
> Probably someone can explain me this in more detail? I'd appreciate.
> 
> Thanks!
> 
    Thanks for your reply. I will try to explain this in more detail.
    Vrf device will pass through netfilter hook twice. One with skb->dev=l3mdev
Slave device and another one with skb->dev=l3mdev master deivce.
    If a device is an l3mdev,  l3mdev_master_ifindex_rcu will return l3mdev
master device ifindex otherwise 0 . So for non l3mdev cases,  v4 version is
as same as the previous one. And for l3mdev cases,  flow.flowi4_oif
will be l3mdev master device ifindex, so we can do a fib lookup in l3mdev
domain as expected. Since fib_info_nh_uses_dev help us handle the case with
dev=l3mdev slave or master and  XT_RPFILTER_LOOSE do not lookup route
table, we finish v4.
    For v6 version we need to set fl6.flowi6_oif as we are supposed to lookup 
fib in l3mdev domain even in XT_RPFILTER_LOOSE mode.
    And fib result rt->rt6i_idev->dev is l3mdev slave device, we need change
dev to enslaved l3mdev device when dev passed in is l3mdev master device.
    The key is l3mdev will pass through netfilter hook twice with skb dev is l3mdev slave
and master . And we need to set flowi6_oif as fib lookup should in the l3mdev
domain.
    Thanks a lot. Have a good day!
