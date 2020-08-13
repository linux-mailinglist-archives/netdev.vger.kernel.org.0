Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BEB243A9F
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 15:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHMNND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 09:13:03 -0400
Received: from mail.efficios.com ([167.114.26.124]:33942 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgHMNNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 09:13:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 77A542DF54F;
        Thu, 13 Aug 2020 09:12:59 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id OtzXpHowJV5J; Thu, 13 Aug 2020 09:12:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 0EA3D2DF806;
        Thu, 13 Aug 2020 09:12:59 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 0EA3D2DF806
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1597324379;
        bh=VBKQCj/kud5BMBF6tM7kT6T7mx6+KiHHiIHf9/8Scs8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=iYMXC/ce20eiLM7zr8zIx+2+VDxKw4TEcqL/0q4i/rrKpkDMyo9Fcdn/qMuiBvj1Y
         rLUS1HURjnCAPiAWgm+C8juJYYhTxXk6dB9d3IF4Mcq3KIaKPbGLZEM5HW1Z8SEV80
         EDlrwSj4W63/nH5/nFUj6lKtGC8JKUSh/4ZOjgwl/IGOjsOiwpOuCyqPIZPEGa1Cst
         O8f3VkDoL671uDaBovs5Zt1m/LKG6un1Z9bH7p4xbgE9oW48+8o4Nfov/4i6V65728
         vg4tpkjGgjTu6QYJA9axcWYKmxGZ5cXB+I96Upx49uQWMCoPvMT+ts8vvZ4jZ0HDly
         ZRM2s/+NtFX8Q==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BC93StRkz6-s; Thu, 13 Aug 2020 09:12:59 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 014322DF805;
        Thu, 13 Aug 2020 09:12:59 -0400 (EDT)
Date:   Thu, 13 Aug 2020 09:12:58 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Message-ID: <1251597699.6518.1597324378911.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200812.144332.2288214156822456254.davem@davemloft.net>
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com> <20200811195003.1812-3-mathieu.desnoyers@efficios.com> <20200812.144332.2288214156822456254.davem@davemloft.net>
Subject: Re: [PATCH 2/3] ipv4/icmp: l3mdev: Perform icmp error route lookup
 on source device routing table
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3959 (ZimbraWebClient - FF79 (Linux)/8.8.15_GA_3953)
Thread-Topic: ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table
Thread-Index: 8g/yc6nr9wyV5cTP8YHHM46D/Twxnw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Aug 12, 2020, at 5:43 PM, David S. Miller davem@davemloft.net wrote:

> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date: Tue, 11 Aug 2020 15:50:02 -0400
> 
>> @@ -465,6 +465,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
>>  					int type, int code,
>>  					struct icmp_bxm *param)
>>  {
>> +	struct net_device *route_lookup_dev = NULL;
>>  	struct rtable *rt, *rt2;
>>  	struct flowi4 fl4_dec;
>>  	int err;
>> @@ -479,7 +480,17 @@ static struct rtable *icmp_route_lookup(struct net *net,
>>  	fl4->flowi4_proto = IPPROTO_ICMP;
>>  	fl4->fl4_icmp_type = type;
>>  	fl4->fl4_icmp_code = code;
>> -	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
>> +	/*
>> +	 * The device used for looking up which routing table to use is
>> +	 * preferably the source whenever it is set, which should ensure
>> +	 * the icmp error can be sent to the source host, else fallback
>> +	 * on the destination device.
>> +	 */
>> +	if (skb_in->dev)
>> +		route_lookup_dev = skb_in->dev;
>> +	else if (skb_dst(skb_in))
>> +		route_lookup_dev = skb_dst(skb_in)->dev;
>> +	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
> 
> The caller of icmp_route_lookup() uses the opposite prioritization of
> devices for determining the network namespace to use:
> 
>	if (rt->dst.dev)
>		net = dev_net(rt->dst.dev);
>	else if (skb_in->dev)
>		net = dev_net(skb_in->dev);
>	else
>		goto out;
> 
> Do we have to reverse the ordering there too?

Looking at the history:

Originally dst.dev was used as network namespace for icmp errors:

dde1bc0e6f861 (Denis V. Lunev           2008-01-22 23:50:57 -0800  450)         net = rt->u.dst.dev->nd_net;

commit dde1bc0e6f86183bc095d0774cd109f4edf66ea2
Author: Denis V. Lunev <den@openvz.org>
Date:   Tue Jan 22 23:50:57 2008 -0800

    [NETNS]: Add namespace for ICMP replying code.
    
    All needed API is done, the namespace is available when required from
    the device on the DST entry from the incoming packet. So, just replace
    init_net with proper namespace.

Here I wonder what motivated use of the DST entry here ?

Note that this choice of DST network namespace applies to both __icmp_send and
icmp_unreach.

It has been followed by a few data structure layout changes:

c346dca10840a (YOSHIFUJI Hideaki        2008-03-25 21:47:49 +0900  430)         net = dev_net(rt->u.dst.dev);
d8d1f30b95a63 (Changli Gao              2010-06-10 23:31:35 -0700  585)         net = dev_net(rt->dst.dev);

It was then changed to fix a NULL pointer deref:

e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  586) 
e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  587)         if (rt->dst.dev)
e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  588)                 net = dev_net(rt->dst.dev);
e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  589)         else if (skb_in->dev)
e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  590)                 net = dev_net(skb_in->dev);
e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  591)         else
e2c693934194f (Hangbin Liu              2019-08-22 22:19:48 +0800  592)                 goto out;


> And when I read fallback in your commit message description, I
> imagined that you would have a two tiered lookup scheme.  First you
> would be trying the skb_in->dev for a lookup (to accomodate the VRF
> case), and if that failed you'd try again with skb_dst()->dev.

The code I proposed basically does use the skb_in->dev (if non-null)
for looking up which VRF table to use, else use skb_dst(skb_in) (if non-null)
for looking up which VRF table to use, else route_lookup_dev is NULL, which
means use the master table.

Whether this should instead try to lookup the source address with the skb_in->dev
table, and of that fails go to the next, is a good question. I think the context
I am missing in order to understand which approach is appropriate is which
scenario can cause skb_in->dev to be NULL, and which can cause skb_dst(skb_in)
to be NULL, and what is the expected behavior for icmp error route lookup in those
cases ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
