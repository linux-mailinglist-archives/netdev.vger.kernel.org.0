Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB532214175
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgGCWRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:17:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:37552 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgGCWRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:17:21 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrTzY-0004Ot-JX; Sat, 04 Jul 2020 00:17:08 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrTzY-000J1e-9K; Sat, 04 Jul 2020 00:17:08 +0200
Subject: Re: [PATCH net v3] sched: consistently handle layer3 header accesses
 in the presence of VLANs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>, kafai@fb.com,
        alexei.starovoitov@gmail.com, edumazet@google.com
References: <20200703202643.12919-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <003ff65d-fc24-cd25-9e46-95e7ca2aa31f@iogearbox.net>
Date:   Sat, 4 Jul 2020 00:17:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200703202643.12919-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25862/Fri Jul  3 15:56:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/20 10:26 PM, Toke Høiland-Jørgensen wrote:
> There are a couple of places in net/sched/ that check skb->protocol and act
> on the value there. However, in the presence of VLAN tags, the value stored
> in skb->protocol can be inconsistent based on whether VLAN acceleration is
> enabled. The commit quoted in the Fixes tag below fixed the users of
> skb->protocol to use a helper that will always see the VLAN ethertype.
> 
> However, most of the callers don't actually handle the VLAN ethertype, but
> expect to find the IP header type in the protocol field. This means that
> things like changing the ECN field, or parsing diffserv values, stops
> working if there's a VLAN tag, or if there are multiple nested VLAN
> tags (QinQ).
> 
> To fix this, change the helper to take an argument that indicates whether
> the caller wants to skip the VLAN tags or not. When skipping VLAN tags, we
> make sure to skip all of them, so behaviour is consistent even in QinQ
> mode.
> 
> To make the helper usable from the ECN code, move it to if_vlan.h instead
> of pkt_sched.h.
> 
> v3:
> - Remove empty lines
> - Move vlan variable definitions inside loop in skb_protocol()
> - Also use skb_protocol() helper in IP{,6}_ECN_decapsulate() and
>    bpf_skb_ecn_set_ce()
> 
> v2:
> - Use eth_type_vlan() helper in skb_protocol()
> - Also fix code that reads skb->protocol directly
> - Change a couple of 'if/else if' statements to switch constructs to avoid
>    calling the helper twice
> 
> Reported-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
> Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   include/linux/if_vlan.h  | 28 ++++++++++++++++++++++++++++
>   include/net/inet_ecn.h   | 25 +++++++++++++++++--------
>   include/net/pkt_sched.h  | 11 -----------
>   net/core/filter.c        | 10 +++++++---
>   net/sched/act_connmark.c |  9 ++++++---
>   net/sched/act_csum.c     |  2 +-
>   net/sched/act_ct.c       |  9 ++++-----
>   net/sched/act_ctinfo.c   |  9 ++++++---
>   net/sched/act_mpls.c     |  2 +-
>   net/sched/act_skbedit.c  |  2 +-
>   net/sched/cls_api.c      |  2 +-
>   net/sched/cls_flow.c     |  8 ++++----
>   net/sched/cls_flower.c   |  2 +-
>   net/sched/em_ipset.c     |  2 +-
>   net/sched/em_ipt.c       |  2 +-
>   net/sched/em_meta.c      |  2 +-
>   net/sched/sch_cake.c     |  4 ++--
>   net/sched/sch_dsmark.c   |  6 +++---
>   net/sched/sch_teql.c     |  2 +-
>   19 files changed, 86 insertions(+), 51 deletions(-)
> 
> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
> index b05e855f1ddd..427a5b8597c2 100644
> --- a/include/linux/if_vlan.h
> +++ b/include/linux/if_vlan.h
> @@ -308,6 +308,34 @@ static inline bool eth_type_vlan(__be16 ethertype)
>   	}
>   }
>   
> +/* A getter for the SKB protocol field which will handle VLAN tags consistently
> + * whether VLAN acceleration is enabled or not.
> + */
> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
> +{
> +	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
> +	__be16 proto = skb->protocol;
> +
> +	if (!skip_vlan)
> +		/* VLAN acceleration strips the VLAN header from the skb and
> +		 * moves it to skb->vlan_proto
> +		 */
> +		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
> +
> +	while (eth_type_vlan(proto)) {
> +		struct vlan_hdr vhdr, *vh;
> +
> +		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
> +		if (!vh)
> +			break;
> +
> +		proto = vh->h_vlan_encapsulated_proto;
> +		offset += sizeof(vhdr);
> +	}

Hm, why is the while loop 'unbounded'? Does it even make sense to have a packet with
hundreds of vlan hdrs in there what you'd end up walking? What if an attacker crafts
a max sized packet with only vlan_hdr forcing exorbitant looping in fast-path here
(e.g. via af_packet)?

Did you validate that skb_mac_offset() is always valid for the call-sites you converted?
(We have a skb_mac_header_was_set() test to probe for whether skb->mac_header is set
to ~0.)

> +	return proto;
> +}
> +
>   static inline bool vlan_hw_offload_capable(netdev_features_t features,
>   					   __be16 proto)
>   {
[...]
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 73395384afe2..82e1b5b06167 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5853,12 +5853,16 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, skb)
>   {
>   	unsigned int iphdr_len;
>   
> -	if (skb->protocol == cpu_to_be16(ETH_P_IP))
> +	switch (skb_protocol(skb, true)) {
> +	case cpu_to_be16(ETH_P_IP):
>   		iphdr_len = sizeof(struct iphdr);
> -	else if (skb->protocol == cpu_to_be16(ETH_P_IPV6))
> +		break;
> +	case cpu_to_be16(ETH_P_IPV6):
>   		iphdr_len = sizeof(struct ipv6hdr);
> -	else
> +		break;
> +	default:
>   		return 0;
> +	}
>   
>   	if (skb_headlen(skb) < iphdr_len)
>   		return 0;
[...]
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index faa78b7dd962..e62beec0d844 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1538,7 +1538,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
>   reclassify:
>   #endif
>   	for (; tp; tp = rcu_dereference_bh(tp->next)) {
> -		__be16 protocol = tc_skb_protocol(skb);
> +		__be16 protocol = skb_protocol(skb, false);
>   		int err;
>   
>   		if (tp->protocol != protocol &&
