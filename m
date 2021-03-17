Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139A233FB91
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCQW7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:59:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:42894 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCQW6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 18:58:55 -0400
IronPort-SDR: ychNmywUka1Y5A02/xqjkRN/8Fm+GOmuxexuvaxkoKTVIyr+KRhIqVvRoJMugCslzDZSpvOkEV
 StZcfYkNIe7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="274613028"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="274613028"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 15:58:55 -0700
IronPort-SDR: X2Hxi+OTD1O6/6DBJW1btMNX2QwG1PaAw14WTqgQ5Jm2agGOmNAyhec79YR3aDbmkVBYbcahNP
 uK+8MnWhlLUA==
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="389012698"
Received: from jpclancy-mobl.amr.corp.intel.com ([10.251.18.252])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 15:58:54 -0700
Date:   Wed, 17 Mar 2021 15:58:54 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        jamorris@linux.microsoft.com, paul@paul-moore.com,
        rdias@singlestore.com, dccp@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] ipv6: weaken the v4mapped source check
In-Reply-To: <20210317165515.1914146-1-kuba@kernel.org>
Message-ID: <b5f2f124-cdd1-ce9a-49e-878ad45d385@linux.intel.com>
References: <20210317165515.1914146-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 17 Mar 2021, Jakub Kicinski wrote:

> This reverts commit 6af1799aaf3f1bc8defedddfa00df3192445bbf3.
>
> Commit 6af1799aaf3f ("ipv6: drop incoming packets having a v4mapped
> source address") introduced an input check against v4mapped addresses.
> Use of such addresses on the wire is indeed questionable and not
> allowed on public Internet. As the commit pointed out
>
>  https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
>
> lists potential issues.
>
> Unfortunately there are applications which use v4mapped addresses,
> and breaking them is a clear regression. For example v4mapped
> addresses (or any semi-valid addresses, really) may be used
> for uni-direction event streams or packet export.
>
> Since the issue which sparked the addition of the check was with
> TCP and request_socks in particular push the check down to TCPv6
> and DCCP. This restores the ability to receive UDPv6 packets with
> v4mapped address as the source.
>
> Keep using the IPSTATS_MIB_INHDRERRORS statistic to minimize the
> user-visible changes.
>
> Fixes: 6af1799aaf3f ("ipv6: drop incoming packets having a v4mapped source address")
> Reported-by: Sunyi Shao <sunyishao@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> net/dccp/ipv6.c      |  5 +++++
> net/ipv6/ip6_input.c | 10 ----------
> net/ipv6/tcp_ipv6.c  |  5 +++++
> net/mptcp/subflow.c  |  5 +++++
> 4 files changed, 15 insertions(+), 10 deletions(-)

Jakub -

Thanks for keeping the MPTCP code in sync. The IPv6 and v4mapped MPTCP 
selftests still pass. For the MPTCP content:

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>


>
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index 1f73603913f5..2be5c69824f9 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -319,6 +319,11 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
> 	if (!ipv6_unicast_destination(skb))
> 		return 0;	/* discard, don't send a reset here */
>
> +	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
> +		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
> +		return 0;
> +	}
> +
> 	if (dccp_bad_service_code(sk, service)) {
> 		dcb->dccpd_reset_code = DCCP_RESET_CODE_BAD_SERVICE_CODE;
> 		goto drop;
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index e9d2a4a409aa..80256717868e 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -245,16 +245,6 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> 	if (ipv6_addr_is_multicast(&hdr->saddr))
> 		goto err;
>
> -	/* While RFC4291 is not explicit about v4mapped addresses
> -	 * in IPv6 headers, it seems clear linux dual-stack
> -	 * model can not deal properly with these.
> -	 * Security models could be fooled by ::ffff:127.0.0.1 for example.
> -	 *
> -	 * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
> -	 */
> -	if (ipv6_addr_v4mapped(&hdr->saddr))
> -		goto err;
> -
> 	skb->transport_header = skb->network_header + sizeof(*hdr);
> 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
>
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index bd44ded7e50c..d0f007741e8e 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1175,6 +1175,11 @@ static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
> 	if (!ipv6_unicast_destination(skb))
> 		goto drop;
>
> +	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
> +		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
> +		return 0;
> +	}
> +
> 	return tcp_conn_request(&tcp6_request_sock_ops,
> 				&tcp_request_sock_ipv6_ops, sk, skb);
>
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 3d47d670e665..d17d39ccdf34 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -477,6 +477,11 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
> 	if (!ipv6_unicast_destination(skb))
> 		goto drop;
>
> +	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
> +		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
> +		return 0;
> +	}
> +
> 	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
> 				&subflow_request_sock_ipv6_ops, sk, skb);
>
> -- 
> 2.30.2

--
Mat Martineau
Intel
