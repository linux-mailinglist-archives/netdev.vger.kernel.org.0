Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3793284070
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 22:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgJEUMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 16:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgJEUMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 16:12:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C34C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 13:12:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPWqQ-00HPq6-78; Mon, 05 Oct 2020 22:12:26 +0200
Message-ID: <667995b1fe577e6c6c562856fe85cb1a853acb68.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Date:   Mon, 05 Oct 2020 22:12:25 +0200
In-Reply-To: <37c768d663f7f3158f1bfae6d7e1aa86e76e9880.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
         <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
         <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
         <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
         <20201005124029.5ebe684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <37c768d663f7f3158f1bfae6d7e1aa86e76e9880.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 21:53 +0200, Johannes Berg wrote:
> On Mon, 2020-10-05 at 12:40 -0700, Jakub Kicinski wrote:
> 
> > > I would totally support doing that here in the general validation code,
> > > but (again) don't really think NLMSGERR_ATTR_COOKIE is an appropriate
> > > attribute for it.
> > 
> > Hm. Perhaps we can do a partial policy dump into the extack?
> 
> Hm. I like that idea.
> 
> If we have NLMSGERR_ATTR_OFFS we could accompany that with the sub-
> policy for that particular attribute, something like
> 
> [NLMSGERR_ATTR_POLICY] = nested {
>   [NL_POLICY_TYPE_ATTR_TYPE] = ...
>   [NL_POLICY_TYPE_ATTR_MASK] = ...
> }
> 
> which we could basically do by factoring out the inner portion of
> netlink_policy_dump_write():
> 
> 	attr = nla_nest_start(skb, state->attr_idx);
> 	if (!attr)
> 		goto nla_put_failure;
> 	...
> 	nla_nest_end(skb, attr);
> 
> from there into a separate function, give it the pt and the nested
> attribute (what's "state->attr_idx" here) as arguments, and then we call
> it with NLMSGERR_ATTR_POLICY from here, and with "state->attr_idx" from
> netlink_policy_dump_write() :-)
> 
> Nice, easy & useful, maybe I'll code it up tomorrow.

OK I thought about it a bit more and looked at the code, and it's not
actually possible to do easily right now, because we can't actually
point to the bad attribute from the general lib/nlattr.c code ...

Why? Because we don't know right now, e.g. for nla_validate(), where in
the message we started validation, i.e. the offset of the "head" inside
the particular message.

For nlmsg_parse() and friends that's a bit easier, but it needs more
rejiggering than I'm willing to do tonight ;)

johannes

