Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D41402A43
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhIGN4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhIGN4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 09:56:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C11C061575;
        Tue,  7 Sep 2021 06:55:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mNbYw-0007OY-Kd; Tue, 07 Sep 2021 15:54:58 +0200
Date:   Tue, 7 Sep 2021 15:54:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v2] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <20210907135458.GF23554@breakpoint.cc>
References: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907021415.962-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> index aace6768a64e..cf675dc589be 100644
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

Please add this to a header, e.g. include/net/netfilter/nf_nat.h.

> -	/* Try to get same port: if not, try to change it. */
> -	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
> -		int ret;
> +	if (htons(nat->range_info.min_proto.all) == 0 ||
> +	    htons(nat->range_info.max_proto.all) == 0) {

Either use if (nat->range_info.min_proto.all || ...

or use ntohs().  I will leave it up to you if you prefer
ntohs(nat->range_info.min_proto.all) == 0 or
nat->range_info.min_proto.all == ntohs(0).

(Use of htons here will trigger endian warnings from sparse tool).

> -		exp->tuple.dst.u.tcp.port = htons(port);
> +	/* Try to get same port if it matches NAT rule: if not, try to change it. */
> +	ret = -1;
> +	port = ntohs(exp->tuple.dst.u.tcp.port);
> +	if (port != 0 && ntohs(range.min_proto.all) <= port &&
> +	    port <= ntohs(range.max_proto.all)) {
>  		ret = nf_ct_expect_related(exp, 0);
> -		if (ret == 0)
> -			break;
> -		else if (ret != -EBUSY) {
> -			port = 0;
> -			break;
> +	}
> +	if (ret != 0 || port == 0) {
> +		if (!dir) {
> +			nf_nat_l4proto_unique_tuple(&exp->tuple, &range,
> +						    NF_NAT_MANIP_DST,
> +						    ct);

A small comment that explains why nf_nat_l4proto_unique_tuple() is
called conditionally would be good.

I don't understand this new logic, can you explain?

Old:

for (port = expr>tuple.port ; port > 0 ;port++)
    nf_ct_expect_related(exp, 0);
    if (success || fatal_error)
	 break;

New:
port = exp->tuple.port;
if (port && min <= port && port <= max) // in which case is port 0 here?
	ret = nf_ct_expect_related();

if (fatal_error || port == 0)	// how can port be 0?
    if (!dir) {
	    nf_nat_l4proto_unique_tuple();
            ret = nf_ct_expect_related();
    }
}

How can this work?  This removes the loop and relies on
nf_nat_l4proto_unique_tuple(), but NF_NAT_MANIP_DST doesn't support
port rewrite in !NF_NAT_RANGE_PROTO_SPECIFIED case.

Plus, it restricts nf_nat_l4proto_unique_tuple to !dir case, which
I don't understand either.

> +		port = ntohs(exp->tuple.dst.u.tcp.port);
> +		ret = nf_ct_expect_related(exp, 0);
>  	}
> -
> -	if (port == 0) {
> +	if (ret != 0 || port == 0) {

How can port be 0?  In the old code, it becomes 0 if all attempts
to find unused port failed, but after the rewrite I don't see how it can
happen.

> @@ -188,6 +188,16 @@ void nf_nat_follow_master(struct nf_conn *ct,
>  	range.flags = NF_NAT_RANGE_MAP_IPS;
>  	range.min_addr = range.max_addr
>  		= ct->master->tuplehash[!exp->dir].tuple.dst.u3;
> +	if (exp->master && !exp->dir) {

AFAIK exp->master can't be NULL.

> +		struct nf_conn_nat *nat = nfct_nat(exp->master);
> +
> +		if (nat && nat->range_info.min_proto.all != 0 &&
> +		    nat->range_info.max_proto.all != 0) {
> +			range.min_proto = nat->range_info.min_proto;
> +			range.max_proto = nat->range_info.max_proto;
> +			range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
> +		}
> +	}

!expr->dir means REPLY, i.e. new connection is reversed compared
to the master connection (from responder back to initiator).

So, why are we munging range in this case?

I would have expected exp->dir == IP_CT_DIR_ORIGINAL for your use case
(original connection subject to masquerade and source ports mangled to
 fall into special range, so related conntion should also be mangled
 to match said range).
