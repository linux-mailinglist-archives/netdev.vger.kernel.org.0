Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C582A2850D7
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgJFRcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 13:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgJFRcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 13:32:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFBFC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 10:32:02 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPqoh-000O3y-4D; Tue, 06 Oct 2020 19:31:59 +0200
Message-ID: <43795133d78467ebb6f77f5aac8e320360d42212.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] netlink: export policy in extended ACK
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Date:   Tue, 06 Oct 2020 19:31:58 +0200
In-Reply-To: <20201006091644.0425e0fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201006123202.57898-1-johannes@sipsolutions.net>
         <20201006142714.3c8b8db03517.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
         <0f534e06a9b2248cc4a5ae941caf7772a864a68f.camel@sipsolutions.net>
         <20201006091644.0425e0fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 09:16 -0700, Jakub Kicinski wrote:
> On Tue, 06 Oct 2020 17:10:44 +0200 Johannes Berg wrote:
> > Sorry, hat to run out earlier and forgot to comment here.
> > 
> > On Tue, 2020-10-06 at 14:32 +0200, Johannes Berg wrote:
> > > +	/* the max policy content is currently ~44 bytes for range min/max */
> > > +	if (err && nlk_has_extack && extack && extack->policy)
> > > +		tlvlen += 64;  
> > 
> > So I'm not really happy with this. I counted 44 bytes content (so 48
> > bytes for the nested attribute) for the biggest that we have now, but if
> > we ever implement e.g. dumping out the reject string for NLA_REJECT
> > (though not sure anyone even uses that?) then it'd be more variable.
> 
> I wonder if we should in fact dump the reject string, in this case it
> feels like an omission not to have it... although as you say, grep for
> reject_message reveals it's completely unused today.

Yeah. I'm not even sure why I allowed for it. I mean, I added NLA_REJECT
so you could explicitly reject old stuff when you don't have strict
policy enforcement yet (where NLA_UNSPEC is basically the same), but
then never used the string ... *shrug*

Perhaps if somebody wants it they can add it?

> > I couldn't really come up with any better idea, but I believe we do need
> > to size the skb fairly well to return the original one ...
> > 
> > The only solution I _could_ think of was to allocate another skb, put
> > the attribute into it, check the length, and then later append it to the
> > message ... but that seemed kinda ugly.
> > 
> > Any preferences?
> 
> It'd feel pretty idiomatic for (rt)netlink to have
> 
> 	netlink_policy_dump_attr_size()
> 
> which would calculate the size. That'd cost us probably ~100 LoC?

From an API POV I'd agree, but it's ~100 LOC that's effectively
duplicated, and we'd have to maintain both. And if we add something
(like you added the mask) we'd have to add it again there in the size
calculation, and somehow maintain that the two are always in sync.

Feels like a lot of pain for no practical gain?

> If that's too much we could at least add a define for this constant,
> and WARN_ON_ONCE() in __netlink_policy_dump_write_attr() if the dump
> ends up larger?

I didn't feel very comfortable putting a WARN_ON there that effectively
ends up being user-triggerable at will when we made a mistake somewhere,
but will basically never happen on our (developers') machines ...

But hmm, yeah, if we put it into __netlink_policy_dump_write_attr()
rather than netlink_ack() which I had considered, at least there's a
chance we'd exercise the code path in "good" cases an hit the WARN_ON,
and, more importantly, developers will hopefully at least once test
their code and hit it.

So yeah, I think I'll do that.

The other option would be to implement *both* (in a way), and check that
the size returned by netlink_policy_dump_attr_size() matched the actual
size (or at least was bigger), but I still don't really know if I want
to have the duplication?

johannes

