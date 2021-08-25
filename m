Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6E3F7B24
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242163AbhHYRGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:06:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53282 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhHYRGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:06:22 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 558FF60126;
        Wed, 25 Aug 2021 19:04:39 +0200 (CEST)
Date:   Wed, 25 Aug 2021 19:05:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next 2/3] net: netfilter: Add RFC-7597 Section 5.1
 PSID support
Message-ID: <20210825170529.GA31115@salvia>
References: <20210726143729.GN9904@breakpoint.cc>
 <20210809041037.29969-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210809041037.29969-3-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210809041037.29969-3-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 09, 2021 at 04:10:36PM +1200, Cole Dishington wrote:
> Adds support for masquerading into a smaller subset of ports -
> defined by the PSID values from RFC-7597 Section 5.1. This is part of
> the support for MAP-E and Lightweight 4over6, which allows multiple
> devices to share an IPv4 address by splitting the L4 port / id into
> ranges.
> 
> Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> Reviewed-by: Florian Westphal <fw@strlen.de>
[...]

Looking at the userspace logic:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210716002219.30193-1-Cole.Dishington@alliedtelesis.co.nz/

Chunk extracted from void parse_psid(...)

>        offset = (1 << (16 - offset_len));

Assuming offset_len = 6, then you skip 0-1023 ports, OK.

>        psid = psid << (16 - offset_len - psid_len);

This psid calculation is correct? Maybe:

        psid = psid << (16 - offset_len);

instead?

        psid=0  =>      0 << (16 - 6) = 1024
        psid=1  =>      1 << (16 - 6) = 2048

This is implicitly assuming that 64 PSIDs are available, each of them
taking 1024 ports, ie. psid_len is 6 bits. But why are you subtracting
the psid_len above?

>        /* Handle the special case of no offset bits (a=0), so offset loops */
>        min = psid;

OK, this line above is the minimal port in the range

>        if (offset)
>                min += offset;

... which is incremented by the offset (to skip the 0-1023 ports).

>       r->min_proto.all = htons(min);
>       r->max_proto.all = htons(min + ((1 << (16 - offset_len - psid_len)) - 1));

Here, you subtract psid_len again, not sure why.

>       r->base_proto.all = htons(offset);

base is set to offset, ie. 1024.

>       r->flags |= NF_NAT_RANGE_PSID;
>       r->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;

Now looking at the kernel side.

> diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
> index 8e8a65d46345..19a4754cda76 100644
> --- a/net/netfilter/nf_nat_masquerade.c
> +++ b/net/netfilter/nf_nat_masquerade.c
> @@ -55,8 +55,31 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
>  	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
>  	newrange.min_addr.ip = newsrc;
>  	newrange.max_addr.ip = newsrc;
> -	newrange.min_proto   = range->min_proto;
> -	newrange.max_proto   = range->max_proto;
> +
> +	if (range->flags & NF_NAT_RANGE_PSID) {
> +		u16 base = ntohs(range->base_proto.all);
> +		u16 min =  ntohs(range->min_proto.all);
> +		u16 off = 0;
> +
> +		/* xtables should stop base > 2^15 by enforcement of
> +		 * 0 <= offset_len < 16 argument, with offset_len=0
> +		 * as a special case inwhich base=0.

I don't understand this comment.

> +		 */
> +		if (WARN_ON_ONCE(base > (1 << 15)))
> +			return NF_DROP;
> +
> +		/* If offset=0, port range is in one contiguous block */
> +		if (base)
> +			off = prandom_u32_max(((1 << 16) / base) - 1);

Assuming the example above, base is set to 1024. Then, off is a random
value between UINT16_MAX (you expressed this as 1 << 16) and the base
which is 1024 minus 1.

So this is picking a random off (actually the PSID?) between 0 and 63.
What about clashes? I mean, two different machines behind the NAT
might get the same off.

> +		newrange.min_proto.all   = htons(min + base * off);

min could be 1024, 2048, 3072... you add base which is 1024 * off.

Is this duplicated? Both calculated in user and kernel space?

> +		newrange.max_proto.all   = htons(ntohs(newrange.min_proto.all) + ntohs(range->max_proto.all) - min);

I'm stopping here, I'm getting lost.

My understanding about this RFC is that you would like to split the
16-bit ports in ranges to uniquely identify the host behind the NAT.

Why don't you just you just select the port range from userspace
utilizing the existing infrastructure? I mean, why do you need this
kernel patch?

Florian already suggested:

> Is it really needed to place all of this in the nat core?
> 
> The only thing that has to be done in the NAT core, afaics, is to
> suppress port reallocation attmepts when NF_NAT_RANGE_PSID is set.
> 
> Is there a reason why nf_nat_masquerade_ipv4/6 can't be changed instead
> to do what you want?
> 
> AFAICS its enough to set NF_NAT_RANGE_PROTO_SPECIFIED and init the
> upper/lower boundaries, i.e. change input given to nf_nat_setup_info().

extracted from:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210422023506.4651-1-Cole.Dishington@alliedtelesis.co.nz/
