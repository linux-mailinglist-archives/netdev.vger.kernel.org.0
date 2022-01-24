Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A96497E53
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 12:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiAXLyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 06:54:35 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44836 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiAXLye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 06:54:34 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 955BE60013;
        Mon, 24 Jan 2022 12:51:32 +0100 (CET)
Date:   Mon, 24 Jan 2022 12:54:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     kai zhang <zhangkaiheb@126.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix duplicate logs of iptables TRACE target
Message-ID: <Ye6TdpcBXlgmo16g@salvia>
References: <20220124053732.55985-1-zhangkaiheb@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220124053732.55985-1-zhangkaiheb@126.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 05:37:32AM +0000, kai zhang wrote:
> Below configuration, mangle,filter and security tables have no rule:

Yes, but there are loaded in your iptables-legacy environment.
In iptables-nft this will not happen.

> # iptables -t raw -I PREROUTING 1 -p tcp --dport 22 -j TRACE
> # sysctl net.netfilter.nf_log.2=nf_log_ipv4
> 
> There are 5 logs for incoming ssh packet:
> 
> kernel: [ 7018.727278] TRACE: raw:PREROUTING:policy:2 IN=enp9s0 ...
> kernel: [ 7018.727304] TRACE: mangle:PREROUTING:policy:1 IN=enp9s0 ...
> kernel: [ 7018.727327] TRACE: mangle:INPUT:policy:1 IN=enp9s0 ...
> kernel: [ 7018.727343] TRACE: filter:INPUT:policy:1 IN=enp9s0 ...
> kernel: [ 7018.727359] TRACE: security:INPUT:policy:1 IN=enp9s0 ...

tracing was not designed to display every registered table/chain even
if it has not rules.

> Signed-off-by: kai zhang <zhangkaiheb@126.com>
> ---
>  net/ipv4/netfilter/ip_tables.c  | 4 +++-
>  net/ipv6/netfilter/ip6_tables.c | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 2ed7c58b4..5f0e6096e 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -304,9 +304,11 @@ ipt_do_table(void *priv,
>  
>  #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
>  		/* The packet is traced: log it */
> -		if (unlikely(skb->nf_trace))
> +		if (unlikely(skb->nf_trace)) {
>  			trace_packet(state->net, skb, hook, state->in,
>  				     state->out, table->name, private, e);
> +			nf_reset_trace(skb);
> +		}
>  #endif
>  		/* Standard target? */
>  		if (!t->u.kernel.target->target) {
> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> index 2d816277f..ae842a835 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -327,9 +327,11 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
>  
>  #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
>  		/* The packet is traced: log it */
> -		if (unlikely(skb->nf_trace))
> +		if (unlikely(skb->nf_trace)) {
>  			trace_packet(state->net, skb, hook, state->in,
>  				     state->out, table->name, private, e);
> +			nf_reset_trace(skb);
> +		}
>  #endif
>  		/* Standard target? */
>  		if (!t->u.kernel.target->target) {
> -- 
> 2.30.2
> 
