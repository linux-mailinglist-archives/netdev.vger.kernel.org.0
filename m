Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CD23BBB60
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhGEKmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhGEKmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 06:42:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FB4C061574;
        Mon,  5 Jul 2021 03:40:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m0M19-0001Ez-WE; Mon, 05 Jul 2021 12:40:00 +0200
Date:   Mon, 5 Jul 2021 12:39:59 +0200
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
Message-ID: <20210705103959.GG18022@breakpoint.cc>
References: <20210630142049.GC18022@breakpoint.cc>
 <20210705040856.25191-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210705040856.25191-3-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705040856.25191-3-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
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
> ---

Just a quick review:
> +	/* In this case we are in PSID mode, avoid checking all ranges by computing bitmasks */
> +	if (is_psid) {
> +		u16 j = ntohs(max->all) - ntohs(min->all) + 1;
> +		u16 a = (1 << 16) / ntohs(base->all);

This gives crash when base->all is 0.
If this is impossible, please add a comment, otherwise this needs
a sanity test on the divisor.

> @@ -55,8 +55,21 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
>  	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
>  	newrange.min_addr.ip = newsrc;
>  	newrange.max_addr.ip = newsrc;
> -	newrange.min_proto   = range->min_proto;
> -	newrange.max_proto   = range->max_proto;
> +
> +	if (range->flags & NF_NAT_RANGE_PSID) {
> +		u16 off = prandom_u32();
> +		u16 base = ntohs(range->base_proto.all);
> +		u16 min =  ntohs(range->min_proto.all);
> +		u16 max_off = ((1 << 16) / base) - 1;
> +
> +		newrange.flags           = newrange.flags | NF_NAT_RANGE_PROTO_SPECIFIED;
> +		newrange.min_proto.all   = htons(min + base * (off % max_off));

Same here for base and max_off.
