Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1813CB98D
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbhGPPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhGPPVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:21:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E62C06175F;
        Fri, 16 Jul 2021 08:18:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m4Pbl-0004ys-49; Fri, 16 Jul 2021 17:18:33 +0200
Date:   Fri, 16 Jul 2021 17:18:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Message-ID: <20210716151833.GD9904@breakpoint.cc>
References: <20210705103959.GG18022@breakpoint.cc>
 <20210716002742.31078-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210716002742.31078-3-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716002742.31078-3-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 7de595ead06a..4a9448684504 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -195,13 +195,36 @@ static bool nf_nat_inet_in_range(const struct nf_conntrack_tuple *t,
>  static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
>  			     enum nf_nat_manip_type maniptype,
>  			     const union nf_conntrack_man_proto *min,
> -			     const union nf_conntrack_man_proto *max)
> +			     const union nf_conntrack_man_proto *max,
> +			     const union nf_conntrack_man_proto *base,
> +			     bool is_psid)
>  {
>  	__be16 port;
> +	u16 psid, psid_mask, offset_mask;
> +
> +	/* In this case we are in PSID mode, avoid checking all ranges by computing bitmasks */
> +	if (is_psid) {
> +		u16 power_j = ntohs(max->all) - ntohs(min->all) + 1;
> +		u32 offset = ntohs(base->all);
> +		u16 power_a;
> +
> +		if (offset == 0)
> +			offset = 1 << 16;
> +
> +		power_a = (1 << 16) / offset;

Since the dividie is only needed nat setup and not for each packet I
think its ok.

> +	if (range->flags & NF_NAT_RANGE_PSID) {
> +		u16 base = ntohs(range->base_proto.all);
> +		u16 min =  ntohs(range->min_proto.all);
> +		u16 off = 0;
> +
> +		/* If offset=0, port range is in one contiguous block */
> +		if (base)
> +			off = prandom_u32() % (((1 << 16) / base) - 1);

Bases 32769 > gives 0 for the modulo value, so perhaps compute that
independently.

You could reject > 32769 in the iptables checkentry target.

Also, base of 21846 and above always give 0 result (% 1).

I don't know psid well enough to give a recommendation here.

If such inputs are nonsensical, just reject it when userspace asks for
this and add a 

if (WARN_ON_ONCE(base > bogus))
	return NF_DROP;

with s small coment explaining that xtables is supposed to not provide
such value.

Other than this I think its ok.

I still dislike the 'bool is_psid' in the nat core, but I can't find
a better solution.
