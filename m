Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452B136B300
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhDZMYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhDZMYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 08:24:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2A4C061574;
        Mon, 26 Apr 2021 05:23:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lb0Gq-0000LU-Iv; Mon, 26 Apr 2021 14:23:24 +0200
Date:   Mon, 26 Apr 2021 14:23:24 +0200
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
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Message-ID: <20210426122324.GA975@breakpoint.cc>
References: <20210422023506.4651-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422023506.4651-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> This adds support for masquerading into a smaller subset of ports -
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
> ---
>  include/net/netfilter/nf_conntrack.h          |   2 +
>  .../netfilter/nf_conntrack_tuple_common.h     |   5 +
>  include/uapi/linux/netfilter/nf_nat.h         |   3 +-
>  net/netfilter/nf_nat_core.c                   | 101 ++++++++++++++++--
>  net/netfilter/nf_nat_ftp.c                    |  23 ++--
>  net/netfilter/nf_nat_helper.c                 |  15 ++-
>  6 files changed, 120 insertions(+), 29 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 439379ca9ffa..d63d38aa7188 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -92,6 +92,8 @@ struct nf_conn {
>  	/* If we were expected by an expectation, this will be it */
>  	struct nf_conn *master;
>  
> +	struct nf_nat_range2 *range;

Increasing nf_conn size should be avoided unless
absolutely neccessary.

> --- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> @@ -39,6 +39,11 @@ union nf_conntrack_man_proto {
>  	struct {
>  		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
>  	} gre;
> +	struct {
> +		unsigned char psid_length;
> +		unsigned char offset;
> +		__be16 psid;
> +	} psid;

This breaks the ABI, you cannot change these structures.

This is the reason there is a 'struct nf_nat_range2', it wasn't
possible to add to the existing 'struct nf_nat_range'.

> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index b7c3c902290f..7730ce4ca9a9 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -232,13 +232,33 @@ static bool nf_nat_inet_in_range(const struct nf_conntrack_tuple *t,
>  static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
>  			     enum nf_nat_manip_type maniptype,
>  			     const union nf_conntrack_man_proto *min,
> -			     const union nf_conntrack_man_proto *max)
> +			     const union nf_conntrack_man_proto *max,
> +			     bool is_psid)
>  {

...
>  	__be16 port;
>  
> +	int m = 0;
> +	u16 offset_mask = 0;
> +	u16 psid_mask = 0;
> +
> +	/* In this case we are in PSID mode and the rules are all different */
> +	if (is_psid) {
> +		/* m = number of bits in each valid range */
> +		m = 16 - min->psid.psid_length - min->psid.offset;
> +		offset_mask = ((1 << min->psid.offset) - 1) <<
> +				(16 - min->psid.offset);
> +		psid_mask = ((1 << min->psid.psid_length) - 1) << m;
> +	}

...

Is it really needed to place all of this in the nat core?

The only thing that has to be done in the NAT core, afaics, is to
suppress port reallocation attmepts when NF_NAT_RANGE_PSID is set.

Is there a reason why nf_nat_masquerade_ipv4/6 can't be changed instead
to do what you want?

AFAICS its enough to set NF_NAT_RANGE_PROTO_SPECIFIED and init the
upper/lower boundaries, i.e. change input given to nf_nat_setup_info().

>  	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
> +	if (range) {
> +		if (!ct->range)
> +			ct->range = kmalloc(sizeof(*ct->range), 0);

If you absolutely have to store extra data in nf_conn, please extend
struct nf_conn_nat, masquerade already stores the interface index, so
you could place the psid len/offset there as well.

> +	/* Find a port that matches the MASQ rule. */
> +	nf_nat_l4proto_unique_tuple(&exp->tuple, ct->range,
> +				    dir ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST,
> +				    ct);
> +	port = ntohs(exp->tuple.dst.u.tcp.port);
> +	nf_ct_expect_related(exp, 0);

This removes there error check for nf_ct_expect_related(), why?

Also, how is this going to be used?

I see no changes to any of the nftables or iptables modules that would
be needed for userspace to enable this feature.
