Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F3E69AC17
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBQNFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBQNFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2026E4AFF3;
        Fri, 17 Feb 2023 05:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3074B82BF4;
        Fri, 17 Feb 2023 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADDBC4339B;
        Fri, 17 Feb 2023 13:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676639141;
        bh=LEp1XQy0hJEMTkmwkNJvxLOg+wrbhOGqVrxXx2bGgww=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=YBqI/F4v+AiDPtrVhS/j/K7nZGwNoTsd83KAv4FFfwdasb/8dmekzPk1+PiaGV3nj
         l9clnKbzJiu3oVhbk2qKzALhhxjP097mpbclEE2jeDx6M7cpLsuSu6iIneiXjFvFLY
         zDTS2fLcWYAK9dr2/hRufdgeKhl0L31TfG1qnI6vB90QJiTYMnzpIfLZaUrD372azG
         M0V5U8R7Em4VOG9JWcz7EjZiWnSSDTJuJuYjSg9Ae/4uUfFOUY3zwNiZEDllvzxxOG
         IwPyxvzRHov+rD231/3fY2QIUzB6RG7OgxwkNUOdPiEAAB2r9MwjPya5iAdboznXXV
         NeaOUF+rq8kwQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4BD13974854; Fri, 17 Feb 2023 14:05:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH v10 bpf-next 9/9] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
In-Reply-To: <20230216225524.1192789-10-joannelkoong@gmail.com>
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
 <20230216225524.1192789-10-joannelkoong@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Feb 2023 14:05:38 +0100
Message-ID: <87a61cqw65.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joanne Koong <joannelkoong@gmail.com> writes:

> Test skb and xdp dynptr functionality in the following ways:

One question on one of the usage examples:

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c b/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
> new file mode 100644
> index 000000000000..4c49fd42da6f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
> @@ -0,0 +1,257 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Meta */
> +#include <stddef.h>
> +#include <string.h>
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/if_packet.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/in.h>
> +#include <linux/udp.h>
> +#include <linux/tcp.h>
> +#include <linux/pkt_cls.h>
> +#include <sys/socket.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include "test_iptunnel_common.h"
> +
> +extern int bpf_dynptr_from_xdp(struct xdp_md *xdp, __u64 flags,
> +			       struct bpf_dynptr *ptr) __ksym;
> +extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, __u32 offset,
> +			      void *buffer, __u32 buffer__sz) __ksym;
> +extern void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr *ptr, __u32 offset,
> +			      void *buffer, __u32 buffer__sz) __ksym;
> +
> +const size_t tcphdr_sz = sizeof(struct tcphdr);
> +const size_t udphdr_sz = sizeof(struct udphdr);
> +const size_t ethhdr_sz = sizeof(struct ethhdr);
> +const size_t iphdr_sz = sizeof(struct iphdr);
> +const size_t ipv6hdr_sz = sizeof(struct ipv6hdr);
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +	__uint(max_entries, 256);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} rxcnt SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__uint(max_entries, MAX_IPTNL_ENTRIES);
> +	__type(key, struct vip);
> +	__type(value, struct iptnl_info);
> +} vip2tnl SEC(".maps");
> +
> +static __always_inline void count_tx(__u32 protocol)
> +{
> +	__u64 *rxcnt_count;
> +
> +	rxcnt_count = bpf_map_lookup_elem(&rxcnt, &protocol);
> +	if (rxcnt_count)
> +		*rxcnt_count += 1;
> +}
> +
> +static __always_inline int get_dport(void *trans_data, __u8 protocol)
> +{
> +	struct tcphdr *th;
> +	struct udphdr *uh;
> +
> +	switch (protocol) {
> +	case IPPROTO_TCP:
> +		th = (struct tcphdr *)trans_data;
> +		return th->dest;
> +	case IPPROTO_UDP:
> +		uh = (struct udphdr *)trans_data;
> +		return uh->dest;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static __always_inline void set_ethhdr(struct ethhdr *new_eth,
> +				       const struct ethhdr *old_eth,
> +				       const struct iptnl_info *tnl,
> +				       __be16 h_proto)
> +{
> +	memcpy(new_eth->h_source, old_eth->h_dest, sizeof(new_eth->h_source));
> +	memcpy(new_eth->h_dest, tnl->dmac, sizeof(new_eth->h_dest));
> +	new_eth->h_proto = h_proto;
> +}
> +
> +static __always_inline int handle_ipv4(struct xdp_md *xdp, struct bpf_dynptr *xdp_ptr)
> +{
> +	__u8 eth_buffer[ethhdr_sz + iphdr_sz + ethhdr_sz];
> +	__u8 iph_buffer_tcp[iphdr_sz + tcphdr_sz];
> +	__u8 iph_buffer_udp[iphdr_sz + udphdr_sz];
> +	struct bpf_dynptr new_xdp_ptr;
> +	struct iptnl_info *tnl;
> +	struct ethhdr *new_eth;
> +	struct ethhdr *old_eth;
> +	__u32 transport_hdr_sz;
> +	struct iphdr *iph;
> +	__u16 *next_iph;
> +	__u16 payload_len;
> +	struct vip vip = {};
> +	int dport;
> +	__u32 csum = 0;
> +	int i;
> +
> +	__builtin_memset(eth_buffer, 0, sizeof(eth_buffer));
> +	__builtin_memset(iph_buffer_tcp, 0, sizeof(iph_buffer_tcp));
> +	__builtin_memset(iph_buffer_udp, 0, sizeof(iph_buffer_udp));
> +
> +	if (ethhdr_sz + iphdr_sz + tcphdr_sz > xdp->data_end - xdp->data)
> +		iph = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, iph_buffer_udp, sizeof(iph_buffer_udp));
> +	else
> +		iph = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, iph_buffer_tcp, sizeof(iph_buffer_tcp));
> +
> +	if (!iph)
> +		return XDP_DROP;
> +
> +	dport = get_dport(iph + 1, iph->protocol);
> +	if (dport == -1)
> +		return XDP_DROP;
> +
> +	vip.protocol = iph->protocol;
> +	vip.family = AF_INET;
> +	vip.daddr.v4 = iph->daddr;
> +	vip.dport = dport;
> +	payload_len = bpf_ntohs(iph->tot_len);
> +
> +	tnl = bpf_map_lookup_elem(&vip2tnl, &vip);
> +	/* It only does v4-in-v4 */
> +	if (!tnl || tnl->family != AF_INET)
> +		return XDP_PASS;
> +
> +	if (bpf_xdp_adjust_head(xdp, 0 - (int)iphdr_sz))
> +		return XDP_DROP;
> +
> +	bpf_dynptr_from_xdp(xdp, 0, &new_xdp_ptr);
> +	new_eth = bpf_dynptr_slice_rdwr(&new_xdp_ptr, 0, eth_buffer, sizeof(eth_buffer));
> +	if (!new_eth)
> +		return XDP_DROP;

Here the program just gets a new pointer using bpf_dynptr_slice_rdwr()
and proceeds to write to it directly without any further checks. But
what happens if the pointer points to the eth_buffer? Presumably the
program would need to check this and do a bpf_dynptr_write() at the end
in this case? Would be good to have this in the example, as this is
basically the only documentation that exists, and people are probably
going to copy-paste code from here :)

-Toke



> +	iph = (struct iphdr *)(new_eth + 1);
> +	old_eth = (struct ethhdr *)(iph + 1);
> +
> +	set_ethhdr(new_eth, old_eth, tnl, bpf_htons(ETH_P_IP));
> +
> +	iph->version = 4;
> +	iph->ihl = iphdr_sz >> 2;
> +	iph->frag_off =	0;
> +	iph->protocol = IPPROTO_IPIP;
> +	iph->check = 0;
> +	iph->tos = 0;
> +	iph->tot_len = bpf_htons(payload_len + iphdr_sz);
> +	iph->daddr = tnl->daddr.v4;
> +	iph->saddr = tnl->saddr.v4;
> +	iph->ttl = 8;
> +
> +	next_iph = (__u16 *)iph;
> +	for (i = 0; i < iphdr_sz >> 1; i++)
> +		csum += *next_iph++;
> +
> +	iph->check = ~((csum & 0xffff) + (csum >> 16));
> +
> +	count_tx(vip.protocol);
> +
> +	return XDP_TX;
> +}
> +
> +static __always_inline int handle_ipv6(struct xdp_md *xdp, struct bpf_dynptr *xdp_ptr)
> +{
> +	__u8 eth_buffer[ethhdr_sz + ipv6hdr_sz + ethhdr_sz];
> +	__u8 ip6h_buffer_tcp[ipv6hdr_sz + tcphdr_sz];
> +	__u8 ip6h_buffer_udp[ipv6hdr_sz + udphdr_sz];
> +	struct bpf_dynptr new_xdp_ptr;
> +	struct iptnl_info *tnl;
> +	struct ethhdr *new_eth;
> +	struct ethhdr *old_eth;
> +	__u32 transport_hdr_sz;
> +	struct ipv6hdr *ip6h;
> +	__u16 payload_len;
> +	struct vip vip = {};
> +	int dport;
> +
> +	__builtin_memset(eth_buffer, 0, sizeof(eth_buffer));
> +	__builtin_memset(ip6h_buffer_tcp, 0, sizeof(ip6h_buffer_tcp));
> +	__builtin_memset(ip6h_buffer_udp, 0, sizeof(ip6h_buffer_udp));
> +
> +	if (ethhdr_sz + iphdr_sz + tcphdr_sz > xdp->data_end - xdp->data)
> +		ip6h = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, ip6h_buffer_udp, sizeof(ip6h_buffer_udp));
> +	else
> +		ip6h = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, ip6h_buffer_tcp, sizeof(ip6h_buffer_tcp));
> +
> +	if (!ip6h)
> +		return XDP_DROP;
> +
> +	dport = get_dport(ip6h + 1, ip6h->nexthdr);
> +	if (dport == -1)
> +		return XDP_DROP;
> +
> +	vip.protocol = ip6h->nexthdr;
> +	vip.family = AF_INET6;
> +	memcpy(vip.daddr.v6, ip6h->daddr.s6_addr32, sizeof(vip.daddr));
> +	vip.dport = dport;
> +	payload_len = ip6h->payload_len;
> +
> +	tnl = bpf_map_lookup_elem(&vip2tnl, &vip);
> +	/* It only does v6-in-v6 */
> +	if (!tnl || tnl->family != AF_INET6)
> +		return XDP_PASS;
> +
> +	if (bpf_xdp_adjust_head(xdp, 0 - (int)ipv6hdr_sz))
> +		return XDP_DROP;
> +
> +	bpf_dynptr_from_xdp(xdp, 0, &new_xdp_ptr);
> +	new_eth = bpf_dynptr_slice_rdwr(&new_xdp_ptr, 0, eth_buffer, sizeof(eth_buffer));
> +	if (!new_eth)
> +		return XDP_DROP;
> +
> +	ip6h = (struct ipv6hdr *)(new_eth + 1);
> +	old_eth = (struct ethhdr *)(ip6h + 1);
> +
> +	set_ethhdr(new_eth, old_eth, tnl, bpf_htons(ETH_P_IPV6));
> +
> +	ip6h->version = 6;
> +	ip6h->priority = 0;
> +	memset(ip6h->flow_lbl, 0, sizeof(ip6h->flow_lbl));
> +	ip6h->payload_len = bpf_htons(bpf_ntohs(payload_len) + ipv6hdr_sz);
> +	ip6h->nexthdr = IPPROTO_IPV6;
> +	ip6h->hop_limit = 8;
> +	memcpy(ip6h->saddr.s6_addr32, tnl->saddr.v6, sizeof(tnl->saddr.v6));
> +	memcpy(ip6h->daddr.s6_addr32, tnl->daddr.v6, sizeof(tnl->daddr.v6));
> +
> +	count_tx(vip.protocol);
> +
> +	return XDP_TX;
> +}
> +
> +SEC("xdp")
> +int _xdp_tx_iptunnel(struct xdp_md *xdp)
> +{
> +	__u8 buffer[ethhdr_sz];
> +	struct bpf_dynptr ptr;
> +	struct ethhdr *eth;
> +	__u16 h_proto;
> +
> +	__builtin_memset(buffer, 0, sizeof(buffer));
> +
> +	bpf_dynptr_from_xdp(xdp, 0, &ptr);
> +	eth = bpf_dynptr_slice(&ptr, 0, buffer, sizeof(buffer));
> +	if (!eth)
> +		return XDP_DROP;
> +
> +	h_proto = eth->h_proto;
> +
> +	if (h_proto == bpf_htons(ETH_P_IP))
> +		return handle_ipv4(xdp, &ptr);
> +	else if (h_proto == bpf_htons(ETH_P_IPV6))
> +
> +		return handle_ipv6(xdp, &ptr);
> +	else
> +		return XDP_DROP;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_tcp_hdr_options.h b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
> index 6118e3ab61fc..56c9f8a3ad3d 100644
> --- a/tools/testing/selftests/bpf/test_tcp_hdr_options.h
> +++ b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
> @@ -50,6 +50,7 @@ struct linum_err {
>  
>  #define TCPOPT_EOL		0
>  #define TCPOPT_NOP		1
> +#define TCPOPT_MSS		2
>  #define TCPOPT_WINDOW		3
>  #define TCPOPT_EXP		254
>  
> -- 
> 2.30.2
