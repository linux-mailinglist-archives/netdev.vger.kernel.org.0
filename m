Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D5A280464
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbgJAQ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732274AbgJAQ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:57:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C832C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:57:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO1tg-00Ehx2-Lx; Thu, 01 Oct 2020 18:57:36 +0200
Message-ID: <f5b9fe3a40de1e9d2b98c6ce21c2c3ae95065da9.camel@sipsolutions.net>
Subject: Re: [RFC net-next 9/9] genetlink: allow dumping command-specific
 policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 18:57:35 +0200
In-Reply-To: <20201001092434.3f916d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-10-kuba@kernel.org>
         <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
         <20201001084152.33cc5bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3de28a3b54737ffd5c7d9944acc0614745242a30.camel@sipsolutions.net>
         <20201001092434.3f916d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 09:24 -0700, Jakub Kicinski wrote:

> > I guess the most compact representation, that also preserves the most
> > data about sharing, would be to do something like
> > 
> > [ATTR_FAMILY_ID]
> > [ATTR_POLICY]
> >   [policy idx, 0 = main policy]
> >     [bla]
> >     ...
> >   ...
> > [ATTR_OP_POLICY]
> >   [op] = [policy idx]
> >   ...

> Only comment I have is - can we make sure to put the ATTR_OP_POLICY
> first? That way user space can parse the stream an pick out the info
> it needs rather than recording all the policies only to find out later
> which one is which.

Hmm. Yes, that makes sense. But I don't see why not - you could go do
the netlink_policy_dump_start() which that assigns the indexes, then
dump out ATTR_OP_POLICY looking up the indexes in the table that it
created, and then dump out all the policies?

> > I guess it's doable. Just seems a bit more complex. OTOH, it may be that
> > such complexity also completely makes sense for non-generic netlink
> > families anyway, I haven't looked at them much at all.
> 
> IDK, doesn't seem crazy hard. We can create some iterator or expand the
> API with "begin" "add" "end" calls. Then once dumper state is build we
> can ask it which ids it assigned.

Yeah. Seems feasible. Maybe I'll take a stab at it (later, when I can).

> OTOH I don't think we have a use for this in ethtool, because user
> space usually does just one op per execution. So I'm thinking to use
> your structure for the dump, but leave the actual implementation of
> "dump all" for "later".
> 
> How does that sound?

I'm not sure you even need that structure if you have the "filter by
op"? I mean, then just stick to what you had?

When I started down this road I more had in mind "sniffer-like" tools
that want to understand the messages better, etc. without really having
any domain-specific "knowledge" encoded in them. And then you'd probably
really want to build the entire policy representation in the tool side
first.

Or perhaps even tools you could run on the latest kernel to generate
code (e.g. python code was discussed) that would be able to build
messages. You'd want to generate the code once on the latest kernel when
you need a new feature, and then actually use it instead of redoing it
at runtime, but still, could be done.

I suppose you have a completely different use case in mind :-)

johannes

