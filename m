Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA783304A98
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbhAZFDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:03:35 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50716 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbhAYMqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:46:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3ED7C201E2;
        Mon, 25 Jan 2021 13:45:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y0TCKvbPCv9L; Mon, 25 Jan 2021 13:45:44 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DC7D32018D;
        Mon, 25 Jan 2021 13:45:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 25 Jan 2021 13:45:44 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 25 Jan
 2021 13:45:43 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 603043182E73;
 Mon, 25 Jan 2021 13:45:44 +0100 (CET)
Date:   Mon, 25 Jan 2021 13:45:44 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alobakin@pm.me>, <namkyu78.kim@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Willem de Bruijn" <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Message-ID: <20210125124544.GW3576117@gauss3.secunet.de>
References: <CGME20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70@epcas2p4.samsung.com>
 <1611235479-39399-1-git-send-email-dseok.yi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1611235479-39399-1-git-send-email-dseok.yi@samsung.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 10:24:39PM +0900, Dongseok Yi wrote:
> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> skb_gso_segment is updated but following frag_skbs are not updated.
> 
> A call path skb_mac_gso_segment -> inet_gso_segment ->
> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> does not try to update UDP/IP header of the segment list but copy
> only the MAC header.
> 
> Update port, addr and check of each skb of the segment list in
> __udp_gso_segment_list. It covers both SNAT and DNAT.
> 
> Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> ---
> v1:
> Steffen Klassert said, there could be 2 options.
> https://lore.kernel.org/patchwork/patch/1362257/
> I was trying to write a quick fix, but it was not easy to forward
> segmented list. Currently, assuming DNAT only.
> 
> v2:
> Per Steffen Klassert request, moved the procedure from
> udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> 
> v3:
> Per Steffen Klassert request, applied fast return by comparing seg
> and seg->next at the beginning of __udpv4_gso_segment_list_csum.
> 
> Fixed uh->dest = *newport and iph->daddr = *newip to
> *oldport = *newport and *oldip = *newip.
> 
>  include/net/udp.h      |  2 +-
>  net/ipv4/udp_offload.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++----
>  net/ipv6/udp_offload.c |  2 +-
>  3 files changed, 69 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 877832b..01351ba 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
>  
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> -				  netdev_features_t features);
> +				  netdev_features_t features, bool is_ipv6);
>  
>  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
>  {
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94..43660cf 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -187,8 +187,67 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(skb_udp_tunnel_segment);
>  
> +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> +				     __be32 *oldip, __be32 *newip,
> +				     __be16 *oldport, __be16 *newport)
> +{
> +	struct udphdr *uh;
> +	struct iphdr *iph;
> +
> +	if (*oldip == *newip && *oldport == *newport)
> +		return;

This check is redundant as you check this already in
__udpv4_gso_segment_list_csum.

Looks ok otherwise.

> +
> +	uh = udp_hdr(seg);
> +	iph = ip_hdr(seg);
> +
> +	if (uh->check) {
> +		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> +					 true);
> +		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> +					 false);
> +		if (!uh->check)
> +			uh->check = CSUM_MANGLED_0;
> +	}
> +	*oldport = *newport;
> +
> +	csum_replace4(&iph->check, *oldip, *newip);
> +	*oldip = *newip;
> +}
> +
> +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> +{
> +	struct sk_buff *seg;
> +	struct udphdr *uh, *uh2;
> +	struct iphdr *iph, *iph2;
> +
> +	seg = segs;
> +	uh = udp_hdr(seg);
> +	iph = ip_hdr(seg);
> +
> +	if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
> +	    (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
> +	    (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
> +	    (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
> +		return segs;
> +
> +	while ((seg = seg->next)) {
> +		uh2 = udp_hdr(seg);
> +		iph2 = ip_hdr(seg);
> +
> +		__udpv4_gso_segment_csum(seg,
> +					 &iph2->saddr, &iph->saddr,
> +					 &uh2->source, &uh->source);
> +		__udpv4_gso_segment_csum(seg,
> +					 &iph2->daddr, &iph->daddr,
> +					 &uh2->dest, &uh->dest);
> +	}
> +
> +	return segs;
> +}
> +
>  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> -					      netdev_features_t features)
> +					      netdev_features_t features,
> +					      bool is_ipv6)
>  {
>  	unsigned int mss = skb_shinfo(skb)->gso_size;
>  
> @@ -198,11 +257,14 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
>  
>  	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
>  
> -	return skb;
> +	if (is_ipv6)
> +		return skb;
> +	else
> +		return __udpv4_gso_segment_list_csum(skb);
>  }
>  
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> -				  netdev_features_t features)
> +				  netdev_features_t features, bool is_ipv6)
>  {
>  	struct sock *sk = gso_skb->sk;
>  	unsigned int sum_truesize = 0;
> @@ -214,7 +276,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>  	__be16 newlen;
>  
>  	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
> -		return __udp_gso_segment_list(gso_skb, features);
> +		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
>  
>  	mss = skb_shinfo(gso_skb)->gso_size;
>  	if (gso_skb->len <= sizeof(*uh) + mss)
> @@ -328,7 +390,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>  		goto out;
>  
>  	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> -		return __udp_gso_segment(skb, features);
> +		return __udp_gso_segment(skb, features, false);
>  
>  	mss = skb_shinfo(skb)->gso_size;
>  	if (unlikely(skb->len <= mss))
> diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> index c7bd7b1..faa823c 100644
> --- a/net/ipv6/udp_offload.c
> +++ b/net/ipv6/udp_offload.c
> @@ -42,7 +42,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
>  			goto out;
>  
>  		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> -			return __udp_gso_segment(skb, features);
> +			return __udp_gso_segment(skb, features, true);
>  
>  		mss = skb_shinfo(skb)->gso_size;
>  		if (unlikely(skb->len <= mss))
> -- 
> 2.7.4
