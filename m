Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D155340C1FC
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 10:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhIOIsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 04:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhIOIsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 04:48:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2E1C061574;
        Wed, 15 Sep 2021 01:47:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mQQZI-0004F3-SI; Wed, 15 Sep 2021 10:47:00 +0200
Date:   Wed, 15 Sep 2021 10:47:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v3] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <20210915084700.GE25110@breakpoint.cc>
References: <20210914233006.8710-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914233006.8710-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> FTP port selection ignores specified port ranges (with iptables
> masquerade --to-ports) when creating an expectation, based on
> FTP commands PORT or PASV, for the data connection.

Can you elaborate here?
Why is this a problem, how to address it, etc?

> Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Co-developed-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     Thanks for your time reviewing!
>     
>     Changes:
>     - Removed check for port == 0.
>     - Added nf_nat_l4proto_unique_tuple() to include/net/netfilter/nf_nat.h.
>     - Simplify htons/ntohs calls.
>     - Move away from conditional call of nf_nat_l4proto_unique_tuple() to applying full range to dst port
>       if ftp active with PORT/ePORT is used.
>     - Remove check for exp->master != NULL.
>     
>     Comments:
>     - dir is the direction of the ftp PORT/PASV request, so exp->dir is the direction
>       of the data connection. In nat helper, the range should be applied on !exp->dir
>       source port since this is the connection from the client.

This should be part of the commit log, or augment your ...
	/* Avoid applying range to external ports */
... comment in the source code.

> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index ea923f8cf9c4..edfd72524c38 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -397,10 +397,10 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
>   *
>   * Per-protocol part of tuple is initialized to the incoming packet.
>   */
> -static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
> -					const struct nf_nat_range2 *range,
> -					enum nf_nat_manip_type maniptype,
> -					const struct nf_conn *ct)
> +void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
> +				 const struct nf_nat_range2 *range,
> +				 enum nf_nat_manip_type maniptype,
> +				 const struct nf_conn *ct)
>  {

Are you sure this doesn't need an EXPORT_SYMBOL_GPL()?
I seem to recall seeing a buildbot linker error because of this.

>  	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
> +	if (range && (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
> +		struct nf_conn_nat *nat = nf_ct_nat_ext_add(ct);
> +
> +		if (WARN_ON_ONCE(!nat))
> +			return NF_DROP;
> +

This WARN needs to be removed, nf_ct_nat_ext_add() can fail if memory
is low.

WARN signals 'cannot happen, if it does something else is wrong and has
to be debugged'.

> diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
> index aace6768a64e..f14e53e8dc04 100644
> --- a/net/netfilter/nf_nat_ftp.c
> +++ b/net/netfilter/nf_nat_ftp.c
> -	/* Try to get same port: if not, try to change it. */
> -	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
> -		int ret;
> +	/* Avoid applying range to external ports */
> +	if (!exp->dir || !nat->range_info.min_proto.all || !nat->range_info.max_proto.all) {
> +		range.min_proto.all = htons(1);
> +		range.max_proto.all = htons(65535);
> +	} else {
> +		range.min_proto     = nat->range_info.min_proto;
> +		range.max_proto     = nat->range_info.max_proto;
> +	}
> +	range.flags                 = NF_NAT_RANGE_PROTO_SPECIFIED;
> +
> +	/* Try to get same port if it matches range */
> +	ret = -1;
> +	port = ntohs(exp->tuple.dst.u.tcp.port);
> +	if (ntohs(range.min_proto.all) <= port && port <= ntohs(range.max_proto.all))
> +		ret = nf_ct_expect_related(exp, 0);
>  
> -		exp->tuple.dst.u.tcp.port = htons(port);
> +	/* Same port is not available, try to change it */
> +	if (ret != 0) {
> +		nf_nat_l4proto_unique_tuple(&exp->tuple, &range, NF_NAT_MANIP_DST, ct);

This looks buggy.  nf_nat_l4proto_unique_tuple() uses 'ct' as 'please
ignore this one' when checking for port collisions.

But the way its used here, 'ct' has little to do with the future tuple.
So, as far as i can see, this needs a fixup to also detect when
exp->tuple reply direction would collide with the existing ct, no?
