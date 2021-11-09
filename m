Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D80644ACD0
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhKILri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:47:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:42898 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKILri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:47:38 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mkPYR-000DOW-2c; Tue, 09 Nov 2021 12:44:43 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mkPYQ-000L7j-RC; Tue, 09 Nov 2021 12:44:42 +0100
Subject: Re: [PATCH] ipv4: add sysctl knob to control the discarding of skb
 from local in ip_forward
To:     Changliang Wu <changliang.wu@smartx.com>, davem@davemloft.net
Cc:     kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, idosch@OSS.NVIDIA.COM, amcohen@nvidia.com,
        fw@strlen.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1636457577-43305-1-git-send-email-changliang.wu@smartx.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d9a5ac14-0252-496a-63c3-758151b41b9c@iogearbox.net>
Date:   Tue, 9 Nov 2021 12:44:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1636457577-43305-1-git-send-email-changliang.wu@smartx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26348/Tue Nov  9 10:18:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 12:32 PM, Changliang Wu wrote:
> This change is meant to add a control for forwarding skb from local.
> By default, ip forward will not receive the pakcet to/from the local.
> But in some special cases, for example:
> -
> |  ovs-bridge  gw-port |  <---->   kube-proxy(iptables) |
> -
> Ovs sends the packet to the gateway, which requires iptables for nat,
> such as kube-proxy (iptables), and then sends it back to the gateway
> through routing for further processing in ovs.
> 
> Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
> ---
>   include/net/netns/ipv4.h   | 1 +
>   net/ipv4/af_inet.c         | 1 +
>   net/ipv4/ip_forward.c      | 6 +++---
>   net/ipv4/sysctl_net_ipv4.c | 7 +++++++
>   4 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 2f65701..0dbe0d6 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -94,6 +94,7 @@ struct netns_ipv4 {
>   	u8 sysctl_ip_no_pmtu_disc;
>   	u8 sysctl_ip_fwd_use_pmtu;
>   	u8 sysctl_ip_fwd_update_priority;
> +	u8 sysctl_ip_fwd_accept_local;
>   	u8 sysctl_ip_nonlocal_bind;
>   	u8 sysctl_ip_autobind_reuse;
>   	/* Shall we try to damage output packets if routing dev changes? */
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 0189e3c..b5dc205 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1844,6 +1844,7 @@ static __net_init int inet_init_net(struct net *net)
>   	 */
>   	net->ipv4.sysctl_ip_default_ttl = IPDEFTTL;
>   	net->ipv4.sysctl_ip_fwd_update_priority = 1;
> +	net->ipv4.sysctl_ip_fwd_accept_local = 0;
>   	net->ipv4.sysctl_ip_dynaddr = 0;
>   	net->ipv4.sysctl_ip_early_demux = 1;
>   	net->ipv4.sysctl_udp_early_demux = 1;
> diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
> index 00ec819..06b7e00 100644
> --- a/net/ipv4/ip_forward.c
> +++ b/net/ipv4/ip_forward.c
> @@ -95,9 +95,6 @@ int ip_forward(struct sk_buff *skb)
>   	if (skb->pkt_type != PACKET_HOST)
>   		goto drop;
>   
> -	if (unlikely(skb->sk))
> -		goto drop;
> -
>   	if (skb_warn_if_lro(skb))
>   		goto drop;
>   
> @@ -110,6 +107,9 @@ int ip_forward(struct sk_buff *skb)
>   	skb_forward_csum(skb);
>   	net = dev_net(skb->dev);
>   
> +	if (unlikely(!net->ipv4.sysctl_ip_fwd_accept_local && skb->sk))
> +		goto drop;
> +

Why moving the check further down instead of initializing dev_net(skb->dev) earlier?

What about ip6_forward()? Same issue exists there too I presume?

>   	/*
>   	 *	According to the RFC, we must first decrease the TTL field. If
>   	 *	that reaches zero, we must reply an ICMP control message telling
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 97eb547..d95e2e3 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -756,6 +756,13 @@ static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
>   		.extra2		= SYSCTL_ONE,
>   	},
>   	{
> +		.procname	= "ip_forward_accept_local",
> +		.data		= &init_net.ipv4.sysctl_ip_fwd_accept_local,
> +		.maxlen		= sizeof(u8),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dou8vec_minmax,
> +	},
> +	{
>   		.procname	= "ip_nonlocal_bind",
>   		.data		= &init_net.ipv4.sysctl_ip_nonlocal_bind,
>   		.maxlen		= sizeof(u8),
> 

