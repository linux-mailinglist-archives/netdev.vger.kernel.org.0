Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51D22AC64E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgKIUuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730041AbgKIUuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 15:50:12 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276F92068D;
        Mon,  9 Nov 2020 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604955011;
        bh=svRzKxeDL9i9eaHdfuzM6yC/zPPqc0bApCVraMxFmbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oot1yi8Ru6Ox9qlUSTyzVispjYgICBfDd9QPM8fHuBtqZKTLrnePTZTEP4ALeWlcU
         yKwYqmrnfS2FDWgETtj9OKVM5U9Y7ayrfBSFvSbujZJUwr08ey7Y+ndDMrUcNElDcS
         2/PkLUwrsWil8TzKhIZ3tOXrjsJWte2hiSNJ+RvM=
Date:   Mon, 9 Nov 2020 12:50:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net v3] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201109125009.5e54ec8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109115249.14491-1-geokohma@cisco.com>
References: <20201109115249.14491-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 12:52:49 +0100 Georg Kohmann wrote:
> Packets are processed even though the first fragment don't include all
> headers through the upper layer header. This breaks TAHI IPv6 Core
> Conformance Test v6LC.1.3.6.
> 
> Referring to RFC8200 SECTION 4.5: "If the first fragment does not include
> all headers through an Upper-Layer header, then that fragment should be
> discarded and an ICMP Parameter Problem, Code 3, message should be sent to
> the source of the fragment, with the Pointer field set to zero."
> 
> The fragment needs to be validated the same way it is done in
> commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
> include all headers") for ipv6. Wrap the validation into a common function,
> ipv6_frag_validate(). A closer inspection of the existing validation show
> that it does not fullfill all aspects of RFC 8200, section 4.5, but is at
> the moment sufficient to pass mentioned TAHI test.
> 
> In netfilter, utilize the fragment offset returned by find_prev_fhdr() to
> let ipv6_frag_validate() start it's traverse from the fragment header.
> 
> Return 0 to drop the fragment in the netfilter. This is the same behaviour
> as used on other protocol errors in this function, e.g. when
> nf_ct_frag6_queue() returns -EPROTO. The Fragment will later be picked up
> by ipv6_frag_rcv() in reassembly.c. ipv6_frag_rcv() will then send an
> appropriate ICMP Parameter Problem message back to the source.
> 
> References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
> fragment don't include all headers")

new line here, since the line above is not really a tag.

> Signed-off-by: Georg Kohmann <geokohma@cisco.com>

> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index bd1f396..489f3f9 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1064,6 +1064,8 @@ int ipv6_skip_exthdr(const struct sk_buff *, int start, u8 *nexthdrp,
>  
>  bool ipv6_ext_hdr(u8 nexthdr);
>  
> +bool ipv6_frag_validate(struct sk_buff *skb, int start, u8 *nexthdrp);
> +
>  enum {
>  	IP6_FH_F_FRAG		= (1 << 0),
>  	IP6_FH_F_AUTH		= (1 << 1),
> diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
> index da46c42..7a94fdf 100644
> --- a/net/ipv6/exthdrs_core.c
> +++ b/net/ipv6/exthdrs_core.c
> @@ -278,3 +278,46 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
>  	return nexthdr;
>  }
>  EXPORT_SYMBOL(ipv6_find_hdr);
> +
> +/* Validate that the upper layer header is not truncated in fragment.
> + *
> + * This function returns false if a TCP, UDP or ICMP header is truncated
> + * just before or in the middle of the header. It also returns false if
> + * any other upper layer header is truncated just before the first byte.
> + *
> + * Notes:
> + * -It does NOT return false if the first fragment where truncated

More spaces needed, i.e.

Notes:
 - It...

> + * elsewhere, i.e. between or in the middle of one of the extension
> + * headers or in the middle of one of the upper layer headers, except for
> + * TCP, UDP and ICMP.
> + * -The function also returns true if the fragment is not the first
> + * fragment.
> + */
> +

no need for a new line here

> +bool ipv6_frag_validate(struct sk_buff *skb, int start, u8 *nexthdrp)

(a) why place this function in exthdrs_core? I don't see any header
    specific code here, IMO it belongs in reassembly.c.

(b) the name is a bit broad, how about ipv6_frag_thdr_tuncated() or
    some such?

> +{
> +	int offset;
> +	u8 nexthdr = *nexthdrp;
> +	__be16 frag_off;

order these longest line to shortest (rev xmas tree) please.

> +
> +	offset = ipv6_skip_exthdr(skb, start, &nexthdr, &frag_off);
> +	if (offset >= 0 && !(frag_off & htons(IP6_OFFSET))) {

nit: since this is a function now you can reverse the condition, return
early, and save the indentation level in all the code below

> +		switch (nexthdr) {
> +		case NEXTHDR_TCP:
> +			offset += sizeof(struct tcphdr);
> +			break;
> +		case NEXTHDR_UDP:
> +			offset += sizeof(struct udphdr);
> +			break;
> +		case NEXTHDR_ICMP:
> +			offset += sizeof(struct icmp6hdr);
> +			break;
> +		default:
> +			offset += 1;
> +		}
> +		if (offset > skb->len)
> +			return false;
> +	}
> +	return true;
> +}
> +EXPORT_SYMBOL(ipv6_frag_validate);
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 054d287..f6cae28 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -445,6 +445,7 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
>  	struct frag_queue *fq;
>  	struct ipv6hdr *hdr;
>  	u8 prevhdr;
> +	u8 nexthdr = NEXTHDR_FRAGMENT;

rev xmas tree

>  	/* Jumbo payload inhibits frag. header */
>  	if (ipv6_hdr(skb)->payload_len == 0) {
> @@ -455,6 +456,14 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
>  	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
>  		return 0;
>  
> +	/* Discard the first fragment if it does not include all headers
> +	 * RFC 8200, Section 4.5
> +	 */
> +	if (!ipv6_frag_validate(skb, fhoff, &nexthdr)) {
> +		pr_debug("Drop incomplete fragment\n");
> +		return 0;
> +	}
>
>  	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
>  		return -ENOMEM;
>  
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index c8cf1bb..04e078e 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -324,8 +324,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
>  	struct frag_queue *fq;
>  	const struct ipv6hdr *hdr = ipv6_hdr(skb);
>  	struct net *net = dev_net(skb_dst(skb)->dev);
> -	__be16 frag_off;
> -	int iif, offset;
> +	int iif;

rev xmas tree

>  	u8 nexthdr;
>  
>  	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
> @@ -362,24 +361,11 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
>  	 * the source of the fragment, with the Pointer field set to zero.
>  	 */
>  	nexthdr = hdr->nexthdr;
> -	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> -	if (offset >= 0) {
> -		/* Check some common protocols' header */
> -		if (nexthdr == IPPROTO_TCP)
> -			offset += sizeof(struct tcphdr);
> -		else if (nexthdr == IPPROTO_UDP)
> -			offset += sizeof(struct udphdr);
> -		else if (nexthdr == IPPROTO_ICMPV6)
> -			offset += sizeof(struct icmp6hdr);
> -		else
> -			offset += 1;
> -
> -		if (!(frag_off & htons(IP6_OFFSET)) && offset > skb->len) {
> -			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
> -					IPSTATS_MIB_INHDRERRORS);
> -			icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> -			return -1;
> -		}
> +	if (!ipv6_frag_validate(skb, skb_transport_offset(skb), &nexthdr)) {
> +		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
> +				IPSTATS_MIB_INHDRERRORS);
> +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> +		return -1;
>  	}
>  
>  	iif = skb->dev ? skb->dev->ifindex : 0;

