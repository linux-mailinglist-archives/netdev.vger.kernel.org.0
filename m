Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CFE3B84F9
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 16:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhF3OXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 10:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbhF3OXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 10:23:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386F8C061756;
        Wed, 30 Jun 2021 07:21:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lyb57-0001Fh-WB; Wed, 30 Jun 2021 16:20:50 +0200
Date:   Wed, 30 Jun 2021 16:20:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Message-ID: <20210630142049.GC18022@breakpoint.cc>
References: <20210426122324.GA975@breakpoint.cc>
 <20210629004819.4750-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629004819.4750-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
>     Comments:
>     Selecting the ports for psid needs to be in nf_nat_core since the PSID ranges are not a single range. e.g. offset=1024, PSID=0, psid_length=8 generates the ranges 1024-1027, 2048-2051, ..., 63488-63491, ... (example taken from RFC7597 B.2).
>     This is why it is enough to set NF_NAT_RANGE_PROTO_SPECIFIED and init upper/lower boundaries.

I suspect this misses a NOT.  But current algorithm has problems, see
below.

> +	if (range->flags & NF_NAT_RANGE_PSID) {
> +		/* PSID defines a group of port ranges, per PSID. PSID
> +		 * is already contained in min and max.
> +		 */
> +		unsigned int min_to_max, base;
> +
> +		min = ntohs(range->min_proto.all);
> +		max = ntohs(range->max_proto.all);
> +		base = ntohs(range->base_proto.all);
> +		min_to_max = max - min;
> +		for (; max <= (1 << 16) - 1; min += base, max = min + min_to_max) {
> +			for (off = 0; off <= min_to_max; off++) {
> +				*keyptr = htons(min + off);
> +				if (!nf_nat_used_tuple(tuple, ct))
> +					return;
> +			}
> +		}
> +	}

I fear this searches waaaay to many ports.
We had softlockups in the past because of exhausive searches.

See a504b703bb1da526a01593da0e4be2af9d9f5fa8
("netfilter: nat: limit port clash resolution attempts").

I suggest you try pre-selecting one of the eligible ranges in
nf_nat_masquerade_ipv4 when the 'newrange' is filled in and set
RANGE_PROTO_SPECIFIED.

Maybe even prandom-based preselection is good enough.

>  	/* If no range specified... */
>  	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
>  		/* If it's dst rewrite, can't change port */
> @@ -529,11 +572,19 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
>  
>  	/* Only bother mapping if it's not already in range and unique */
>  	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
> -		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
> +		/* PSID mode is present always needs to check
> +		 * to see if the source ports are in range.
> +		 */
> +		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED ||
> +		    (range->flags & NF_NAT_RANGE_PSID &&

Why the extra check?
Can't you set NF_NAT_RANGE_PROTO_SPECIFIED in case PSID is requested by
userspace?

> diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
> index aace6768a64e..f65163278db0 100644
> --- a/net/netfilter/nf_nat_ftp.c
> +++ b/net/netfilter/nf_nat_ftp.c
> @@ -17,6 +17,10 @@
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <net/netfilter/nf_conntrack_expect.h>
>  #include <linux/netfilter/nf_conntrack_ftp.h>
> +void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
> +				 const struct nf_nat_range2 *range,
> +				 enum nf_nat_manip_type maniptype,
> +				 const struct nf_conn *ct);
>  
>  #define NAT_HELPER_NAME "ftp"
>  
> @@ -72,8 +76,13 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
>  	u_int16_t port;
>  	int dir = CTINFO2DIR(ctinfo);
>  	struct nf_conn *ct = exp->master;
> +	struct nf_conn_nat *nat = nfct_nat(ct);
>  	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
>  	unsigned int buflen;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(!nat))
> +		return NF_DROP;
>  
>  	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
>  
> @@ -86,18 +95,14 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
>  	 * this one. */
>  	exp->expectfn = nf_nat_follow_master;
>  
> -	/* Try to get same port: if not, try to change it. */
> -	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
> -		int ret;
> -
> -		exp->tuple.dst.u.tcp.port = htons(port);
> -		ret = nf_ct_expect_related(exp, 0);
> -		if (ret == 0)
> -			break;
> -		else if (ret != -EBUSY) {
> -			port = 0;
> -			break;
> -		}
> +	/* Find a port that matches the MASQ rule. */
> +	nf_nat_l4proto_unique_tuple(&exp->tuple, nat->range,
> +				    dir ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST,
> +				    ct);

Hmm, I am ingorant on details here, but is this correct?

This could be an inbound connection, rather than outbound.

> diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
> index a263505455fc..2d105e4eb8f8 100644
> --- a/net/netfilter/nf_nat_helper.c
> +++ b/net/netfilter/nf_nat_helper.c
> @@ -179,15 +179,23 @@ EXPORT_SYMBOL(nf_nat_mangle_udp_packet);
>  void nf_nat_follow_master(struct nf_conn *ct,
>  			  struct nf_conntrack_expect *exp)
>  {
> +	struct nf_conn_nat *nat = NULL;
>  	struct nf_nat_range2 range;
>  
>  	/* This must be a fresh one. */
>  	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
>  
> -	/* Change src to where master sends to */
> -	range.flags = NF_NAT_RANGE_MAP_IPS;
> -	range.min_addr = range.max_addr
> -		= ct->master->tuplehash[!exp->dir].tuple.dst.u3;
> +	if (exp->master && !exp->dir) {
> +		nat = nfct_nat(exp->master);
> +		if (nat)
> +			range = *nat->range;

Can't you store the psid-relevant parts of the range struct only?
Non-PSID doesn't need the original range, so why do you?

> diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
> index 8e8a65d46345..d83cd3d8ad3f 100644
> --- a/net/netfilter/nf_nat_masquerade.c
> +++ b/net/netfilter/nf_nat_masquerade.c
> @@ -45,10 +45,6 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
>  		return NF_DROP;
>  	}
>  
> -	nat = nf_ct_nat_ext_add(ct);
> -	if (nat)
> -		nat->masq_index = out->ifindex;
> -
>  	/* Transfer from original range. */
>  	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
>  	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
> @@ -57,6 +53,15 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
>  	newrange.max_addr.ip = newsrc;
>  	newrange.min_proto   = range->min_proto;
>  	newrange.max_proto   = range->max_proto;
> +	newrange.base_proto  = range->base_proto;
> +
> +	nat = nf_ct_nat_ext_add(ct);
> +	if (nat) {
> +		nat->masq_index = out->ifindex;
> +		if (!nat->range)
> +			nat->range = kmalloc(sizeof(*nat->range), 0);
> +		memcpy(nat->range, &newrange, sizeof(*nat->range));

kmemdup.  Also misses error handling.  Should use GFP_ATOMIC.
Where is this free'd again?

It would be good if you could chop this up in smaller chunks.
A selftest would be nice as well (see tools/testing/selftests/netfilter).
