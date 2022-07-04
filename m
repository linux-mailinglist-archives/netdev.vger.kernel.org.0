Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B2D565282
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiGDKjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiGDKi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:38:58 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1524E9FDF
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 03:38:57 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o8JTi-0041tb-3H; Mon, 04 Jul 2022 12:38:54 +0200
Date:   Mon, 4 Jul 2022 12:38:54 +0200
From:   David Lamparter <equinox@diac24.net>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v2] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <YsLDPnuC6dlROlj3@eidolon.nox.tf>
References: <20220630202706.33555ad2@kernel.org>
 <20220704095845.365359-1-equinox@diac24.net>
 <80dd41cc-5ff2-f27f-3764-841acf008237@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80dd41cc-5ff2-f27f-3764-841acf008237@blackwall.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 01:22:36PM +0300, Nikolay Aleksandrov wrote:
> On 04/07/2022 12:58, David Lamparter wrote:
> > +const struct nla_policy rtm_ipv6_mr_policy[RTA_MAX + 1] = {
> > +	[RTA_UNSPEC]		= { .strict_start_type = RTA_UNSPEC },
> 
> I don't think you need to add RTA_UNSPEC, nlmsg_parse() would reject
> it due to NL_VALIDATE_STRICT

Will remove it.

> > +	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm))) {
> > +		NL_SET_ERR_MSG(extack, "ipv6: Invalid header for multicast route get request");
> > +		return -EINVAL;
> > +	}
> 
> I think you can drop this check if you...
> 
> > +
> > +	rtm = nlmsg_data(nlh);
> > +	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
> > +	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
> > +	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
> > +	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
> > +		NL_SET_ERR_MSG(extack,
> > +			       "ipv6: Invalid values in header for multicast route get request");
> > +		return -EINVAL;
> > +	}
> 
> ...move these after nlmsg_parse() because it already does the hdrlen
> check for you

Indeed it does.  Moving it down.

[...]
> > +	/* rtm_ipv6_mr_policy does not list other attributes right now, but
> > +	 * future changes may reuse rtm_ipv6_mr_policy with adding further
> > +	 * attrs.  Enforce the subset.
> > +	 */
> > +	for (i = 0; i <= RTA_MAX; i++) {
> > +		if (!tb[i])
> > +			continue;
> > +
> > +		switch (i) {
> > +		case RTA_SRC:
> > +		case RTA_DST:
> > +		case RTA_TABLE:
> > +			break;
> > +		default:
> > +			NL_SET_ERR_MSG_ATTR(extack, tb[i],
> > +					    "ipv6: Unsupported attribute in multicast route get request");
> > +			return -EINVAL;
> > +		}
> > +	}
> 
> I think you can skip this loop as well, nlmsg_parse() shouldn't allow attributes that
> don't have policy defined when policy is provided (i.e. they should show up as NLA_UNSPEC
> and you should get "Error: Unknown attribute type.").

I left it in with the comment above:

> > +	/* rtm_ipv6_mr_policy does not list other attributes right now, but
> > +	 * future changes may reuse rtm_ipv6_mr_policy with adding further
> > +	 * attrs.  Enforce the subset.
> > +	 */

... to try and avoid silently starting to accept more attributes if/when
future patches add other netlink operations reusing the same policy but
with adding new attributes.

But I don't feel particularly about this - shall I remove it?  (just
confirming with the rationale above)

> > +	struct net *net = sock_net(in_skb->sk);
> > +	struct nlattr *tb[RTA_MAX + 1];
> > +	struct sk_buff *skb = NULL;
> > +	struct mfc6_cache *cache;
> > +	struct mr_table *mrt;
> > +	struct in6_addr src = {}, grp = {};
> 
> reverse xmas tree order

Ah.  Wasn't aware of that coding style aspect.  Fixing.

Thanks for the review!


-David/equi
