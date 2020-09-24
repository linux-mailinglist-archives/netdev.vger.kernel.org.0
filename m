Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D54277B94
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIXWTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:19:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:51492 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:19:43 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZaW-0005WL-Lk; Fri, 25 Sep 2020 00:19:40 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZaW-000LwA-GY; Fri, 25 Sep 2020 00:19:40 +0200
Subject: Re: [PATCH bpf-next 3/6] bpf: add redirect_neigh helper as redirect
 drop-in
To:     David Ahern <dsahern@gmail.com>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <721fd3f8d5cf55169561e59fdec5fad2e0bf6115.1600967205.git.daniel@iogearbox.net>
 <09aedc04-ee19-e72d-9a8d-aa4be7551a53@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <595d79aa-5960-71a2-0299-c69a38bb287d@iogearbox.net>
Date:   Fri, 25 Sep 2020 00:19:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <09aedc04-ee19-e72d-9a8d-aa4be7551a53@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 12:12 AM, David Ahern wrote:
> On 9/24/20 12:21 PM, Daniel Borkmann wrote:
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 0f913755bcba..19caa2fc21e8 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -2160,6 +2160,205 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>>   		return __bpf_redirect_no_mac(skb, dev, flags);
>>   }
>>   
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
>> +{
>> +	struct dst_entry *dst = skb_dst(skb);
>> +	struct net_device *dev = dst->dev;
>> +	const struct in6_addr *nexthop;
>> +	struct neighbour *neigh;
>> +
>> +	if (dev_xmit_recursion())
>> +		goto out_rec;
>> +	skb->dev = dev;
>> +	rcu_read_lock_bh();
>> +	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
>> +	neigh = __ipv6_neigh_lookup_noref_stub(dev, nexthop);
>> +	if (unlikely(!neigh))
>> +		neigh = __neigh_create(ipv6_stub->nd_tbl, nexthop, dev, false);
> 
> the last 3 lines can be replaced with ip_neigh_gw6.

Ah, nice, I wasn't aware of that one. I'll take it. :)

>> +	if (likely(!IS_ERR(neigh))) {
>> +		int ret;
>> +
>> +		sock_confirm_neigh(skb, neigh);
>> +		dev_xmit_recursion_inc();
>> +		ret = neigh_output(neigh, skb, false);
>> +		dev_xmit_recursion_dec();
>> +		rcu_read_unlock_bh();
>> +		return ret;
>> +	}
>> +	rcu_read_unlock_bh();
>> +	IP6_INC_STATS(dev_net(dst->dev),
>> +		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
>> +out_drop:
>> +	kfree_skb(skb);
>> +	return -EINVAL;
>> +out_rec:
>> +	net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
>> +	goto out_drop;
>> +}
>> +
> 
> ...
> 
>> +#if IS_ENABLED(CONFIG_INET)
>> +static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
>> +{
>> +	struct dst_entry *dst = skb_dst(skb);
>> +	struct rtable *rt = (struct rtable *)dst;
> 
> please use container_of here; I'd like to see the typecasts get removed.

Will do, thx!

>> +	struct net_device *dev = dst->dev;
>> +	u32 hh_len = LL_RESERVED_SPACE(dev);
>> +	struct neighbour *neigh;
>> +	bool is_v6gw = false;
>> +
>> +	if (dev_xmit_recursion())
>> +		goto out_rec;

