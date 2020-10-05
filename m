Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8CD284270
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJEWVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgJEWVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:21:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9B92206CB;
        Mon,  5 Oct 2020 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601936472;
        bh=8k6woZ6m6AbXlUy4wQY8SPP2viDp8VHvNTGjZxVlidQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ru616cAdktdTvqGVsk/Hqx0jsg3UngsUTBXY4bFcz8sp8c7erlY79lnupeezH4iGp
         Q7cz2LJMXEiy8agmmSsJYKELfTLbht5DrZFCGCXiz1znkfNiKWtYmZV/H+nWX/24h5
         z5GLhq80HIHQsrg2UO2ES49L8OmO5WX4pN+G5EFo=
Date:   Mon, 5 Oct 2020 15:21:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
Message-ID: <20201005152110.42b8e71e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <667995b1fe577e6c6c562856fe85cb1a853acb68.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-6-kuba@kernel.org>
        <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
        <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
        <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
        <20201005124029.5ebe684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <37c768d663f7f3158f1bfae6d7e1aa86e76e9880.camel@sipsolutions.net>
        <667995b1fe577e6c6c562856fe85cb1a853acb68.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 22:12:25 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 21:53 +0200, Johannes Berg wrote:
> > Hm. I like that idea.
> > 
> > If we have NLMSGERR_ATTR_OFFS we could accompany that with the sub-
> > policy for that particular attribute, something like
> > 
> > [NLMSGERR_ATTR_POLICY] = nested {
> >   [NL_POLICY_TYPE_ATTR_TYPE] = ...
> >   [NL_POLICY_TYPE_ATTR_MASK] = ...
> > }
> > 
> > which we could basically do by factoring out the inner portion of
> > netlink_policy_dump_write():
> > 
> > 	attr = nla_nest_start(skb, state->attr_idx);
> > 	if (!attr)
> > 		goto nla_put_failure;
> > 	...
> > 	nla_nest_end(skb, attr);
> > 
> > from there into a separate function, give it the pt and the nested
> > attribute (what's "state->attr_idx" here) as arguments, and then we call
> > it with NLMSGERR_ATTR_POLICY from here, and with "state->attr_idx" from
> > netlink_policy_dump_write() :-)
> > 
> > Nice, easy & useful, maybe I'll code it up tomorrow.  
> 
> OK I thought about it a bit more and looked at the code, and it's not
> actually possible to do easily right now, because we can't actually
> point to the bad attribute from the general lib/nlattr.c code ...
> 
> Why? Because we don't know right now, e.g. for nla_validate(), where in
> the message we started validation, i.e. the offset of the "head" inside
> the particular message.
> 
> For nlmsg_parse() and friends that's a bit easier, but it needs more
> rejiggering than I'm willing to do tonight ;)

I thought we'd record the const struct nla_policy *tp for the failing
attr in struct netlink_ext_ack and output based on that.
