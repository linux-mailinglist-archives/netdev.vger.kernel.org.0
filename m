Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41BD2A6560
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgKDNlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:41:25 -0500
Received: from correo.us.es ([193.147.175.20]:47904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgKDNlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:41:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7DC7EE8633
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:41:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C385DA72F
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:41:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5CC82DA84D; Wed,  4 Nov 2020 14:41:21 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD521DA789;
        Wed,  4 Nov 2020 14:41:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 14:41:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8D4AE42EF9E2;
        Wed,  4 Nov 2020 14:41:18 +0100 (CET)
Date:   Wed, 4 Nov 2020 14:41:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net] ipv6/netfilter: Discard first fragment not including
 all headers
Message-ID: <20201104134118.GA28789@salvia>
References: <20201104130128.14619-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201104130128.14619-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 04, 2020 at 02:01:28PM +0100, Georg Kohmann wrote:
> Packets are processed even though the first fragment don't include all
> headers through the upper layer header. This breaks TAHI IPv6 Core
> Conformance Test v6LC.1.3.6.
> 
> Referring to RFC8200 SECTION 4.5: "If the first fragment does not include
> all headers through an Upper-Layer header, then that fragment should be
> discarded and an ICMP Parameter Problem, Code 3, message should be sent to
> the source of the fragment, with the Pointer field set to zero."
> 
> Utilize the fragment offset returned by find_prev_fhdr() to let
> ipv6_skip_exthdr() start it's traverse from the fragment header.
> Apply the same logic for checking that all headers are included as used
> in commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
> include all headers"). Check that TCP, UDP and ICMP headers are completely
> included in the fragment and all other headers are included with at least
> one byte.
> 
> Return 0 to drop the fragment. This is the same behaviour as used on other
> protocol errors in this function, e.g. when nf_ct_frag6_queue() returns
> -EPROTO. The Fragment will later be picked up by ipv6_frag_rcv() in
> reassembly.c. ipv6_frag_rcv() will then send an appropriate ICMP Parameter
> Problem message back to the source.
> 
> References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
> fragment don't include all headers")
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>
> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 054d287..dffa3a8 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -440,11 +440,13 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
>  int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
>  {
>  	u16 savethdr = skb->transport_header;
> -	int fhoff, nhoff, ret;
> +	int fhoff, nhoff, ret, offset;
>  	struct frag_hdr *fhdr;
>  	struct frag_queue *fq;
>  	struct ipv6hdr *hdr;
>  	u8 prevhdr;
> +	u8 nexthdr = NEXTHDR_FRAGMENT;
> +	__be16 frag_off;
>  
>  	/* Jumbo payload inhibits frag. header */
>  	if (ipv6_hdr(skb)->payload_len == 0) {
> @@ -455,6 +457,30 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
>  	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
>  		return 0;
>  
> +	/* Discard the first fragment if it does not include all headers
> +	 * RFC 8200, Section 4.5
> +	 */
> +	offset = ipv6_skip_exthdr(skb, fhoff, &nexthdr, &frag_off);
> +	if (offset >= 0 && !(frag_off & htons(IP6_OFFSET))) {
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
> +		if (offset > skb->len) {
> +			pr_debug("Drop incomplete fragment\n");
> +			return 0;
> +		}
> +	}

This code looks very similar to 2efdaaaf883a.

Would you wrap it in a function as call it use to reuse it? Something
like this sketch?

static bool ipv6_frag_validate(struct sk_buff *skb, ...)
{
        ...

	offset = ipv6_skip_exthdr(skb, fhoff, &nexthdr, &frag_off);
	if (offset >= 0 && !(frag_off & htons(IP6_OFFSET))) {
		switch (nexthdr) {
		case NEXTHDR_TCP:
			offset += sizeof(struct tcphdr);
			break;
		case NEXTHDR_UDP:
			offset += sizeof(struct udphdr);
			break;
		case NEXTHDR_ICMP:
			offset += sizeof(struct icmp6hdr);
			break;
		default:
			offset += 1;
		}
		if (offset > skb->len)
			return false;
	}

        return true;
}

then, from ipv6:

        if (!ipv6_frag_validate(skb, ...)) {
                __IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
                                        IPSTATS_MIB_INHDRERRORS);
                icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
                reurn -1;
        }

and from netfilter:

        if (!ipv6_frag_validate(skb, ...))
                return -1;

Thanks.

> +
>  	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
>  		return -ENOMEM;
>  
> -- 
> 2.10.2
> 
