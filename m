Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9B2BC2E3
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 01:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgKVAoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 19:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgKVAoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 19:44:44 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83FC9207D3;
        Sun, 22 Nov 2020 00:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606005883;
        bh=aYAcu9g5uwrUz51rMwTPxA1dHvWAXgrSDJc0DfQ6sLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uDNAYn41dWx7zYomT1tUqOihFG17oUmavNHGrF9rQcPuHCb7thM1MBf+gdxVtcp/v
         UjzqZ73sye8G/710O05oFEwG9Fq6St+/pJvduXkqpJIVwdSrwE89cIvW6JKt7Tt+KF
         2JdxKDURJ5VwWzYs62/ur8ElLK2p3E3zsopgi3lM=
Date:   Sat, 21 Nov 2020 16:44:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/4] netfilter: nftables_offload: set address type
 in control dissector
Message-ID: <20201121164442.01b39ffb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201121123601.21733-2-pablo@netfilter.org>
References: <20201121123601.21733-1-pablo@netfilter.org>
        <20201121123601.21733-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 13:35:58 +0100 Pablo Neira Ayuso wrote:
> If the address type is missing through the control dissector, then
> matching on IPv4 and IPv6 addresses does not work.

Doesn't work where? Are you talking about a specific driver?

> Set it accordingly so
> rules that specify an IP address succesfully match on packets.
> 
> Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables_offload.h |  4 ++++
>  net/netfilter/nf_tables_offload.c         | 18 ++++++++++++++++++
>  net/netfilter/nft_payload.c               |  4 ++++
>  3 files changed, 26 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
> index ea7d1d78b92d..bddd34c5bd79 100644
> --- a/include/net/netfilter/nf_tables_offload.h
> +++ b/include/net/netfilter/nf_tables_offload.h
> @@ -37,6 +37,7 @@ void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
>  
>  struct nft_flow_key {
>  	struct flow_dissector_key_basic			basic;
> +	struct flow_dissector_key_control		control;
>  	union {
>  		struct flow_dissector_key_ipv4_addrs	ipv4;
>  		struct flow_dissector_key_ipv6_addrs	ipv6;
> @@ -62,6 +63,9 @@ struct nft_flow_rule {
>  
>  #define NFT_OFFLOAD_F_ACTION	(1 << 0)
>  
> +void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
> +				 enum flow_dissector_key_id addr_type);
> +
>  struct nft_rule;
>  struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
>  void nft_flow_rule_destroy(struct nft_flow_rule *flow);
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 9f625724a20f..9a3c5ac057b6 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -28,6 +28,24 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
>  	return flow;
>  }
>  
> +void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
> +				 enum flow_dissector_key_id addr_type)
> +{
> +	struct nft_flow_match *match = &flow->match;
> +	struct nft_flow_key *mask = &match->mask;
> +	struct nft_flow_key *key = &match->key;
> +
> +	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL))
> +		return;
> +
> +	key->control.addr_type = addr_type;
> +	mask->control.addr_type = 0xffff;
> +	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
> +	match->dissector.offset[FLOW_DISSECTOR_KEY_CONTROL] =
> +		offsetof(struct nft_flow_key, control);

Why is this injecting the match conditionally?

> +}
> +EXPORT_SYMBOL_GPL(nft_flow_rule_set_addr_type);

And why is this exported? 

nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
                                                ^^^^^^^^^^^^^
		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
		  nft_chain_route.o nf_tables_offload.o \
                                    ^^^^^^^^^^^^^^^^^^^
		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
		  nft_set_pipapo.o

These are linked together.
