Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DE72A7B74
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKEKPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:15:18 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5910 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgKEKPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:15:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa3d0b90000>; Thu, 05 Nov 2020 02:15:21 -0800
Received: from [172.27.15.55] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 10:15:07 +0000
Subject: Re: [net 4/9] net/mlx5e: Fix refcount leak on kTLS RX resync
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
 <20201103191830.60151-5-saeedm@nvidia.com>
 <20201104145927.3e7efaa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <0c929b0f-750a-3618-3891-4fa40dd14104@nvidia.com>
Date:   Thu, 5 Nov 2020 12:15:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201104145927.3e7efaa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604571321; bh=a4Ucl1t5AvX1mIgRQqjEwNII9lNygzf1TnIAsqV00UU=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=pL2RVWy7JvDLQBFQVdWTGT6RK4gbTTkDoEa5Lw2N2//XE5IKhkGhWLj5svHYHn0lk
         zEv0Zntb9Syw8ZZ7jZcy5D3sxwvBro7C0zX/mepuE041CeLTd+wSd0PGJBpEQtedIT
         t4OsCbx13F0GqCYYHTwnd9CoUtSKsPzFmCwdYzwa28rUBrmI5/K7LYAfS3WsQ+X3Bb
         OWKxhu9sioinJI+vh8Vcty83jGzkvg6+jAfoZZhks0ly75ItZpsz4BhIzfr+tNlH7I
         mizJAs5JX3jfN25GSCSR1qttRsjfBWbP8HZJGqSa7BSRPa/+o4q4tUT6QH0fi9st/v
         /25JUgU/IsghQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-05 00:59, Jakub Kicinski wrote:
> On Tue, 3 Nov 2020 11:18:25 -0800 Saeed Mahameed wrote:
>> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>>
>> On resync, the driver calls inet_lookup_established
>> (__inet6_lookup_established) that increases sk_refcnt of the socket. To
>> decrease it, the driver set skb->destructor to sock_edemux. However, it
>> didn't work well, because the TCP stack also sets this destructor for
>> early demux, and the refcount gets decreased only once
> 
> Why is the stack doing early_demux if there is already a socket
> assigned? Or is it not early_demux but something else?
> Can you point us at the code?

I thought this was the code that was in conflict with setting 
skb->destructor in the driver:

void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
{
         skb_orphan(skb);
         skb->sk = sk;
#ifdef CONFIG_INET
         if (unlikely(!sk_fullsock(sk))) {
                 skb->destructor = sock_edemux;
                 sock_hold(sk);
                 return;
         }
#endif

However, after taking another look, it seems that the root cause is 
somewhere else. This piece of code actually calls skb_orphan before 
reassigning the destructor.

I'll debug it further to try to find where the destructor is replaced or 
just not called.

> IPv4:
> 	if (net->ipv4.sysctl_ip_early_demux &&
> 	    !skb_dst(skb) &&
> 	    !skb->sk &&                              <============
> 	    !ip_is_fragment(iph)) {
> 		const struct net_protocol *ipprot;
> 		int protocol = iph->protocol;
> 
> 		ipprot = rcu_dereference(inet_protos[protocol]);
> 		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
> 			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
> 					      udp_v4_early_demux, skb);
> 			if (unlikely(err))
> 				goto drop_error;
> 			/* must reload iph, skb->head might have changed */
> 			iph = ip_hdr(skb);
> 		}
> 	}
> 
> IPv6:
> 	if (net->ipv4.sysctl_ip_early_demux && !skb_dst(skb) && skb->sk == NULL) {
>                                                                  ~~~~~~~~~~~~~~~
> 		const struct inet6_protocol *ipprot;
> 
> 		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
> 		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
> 			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
> 					udp_v6_early_demux, skb);
> 	}
> 

