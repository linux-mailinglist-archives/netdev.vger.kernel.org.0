Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05C32804B4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733001AbgJARJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732213AbgJARJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 13:09:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 031D420897;
        Thu,  1 Oct 2020 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601572175;
        bh=bgPR/lLlUkHS1Pw8Jgu1JPoVWLdJONn2kCntR2elb/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z0ZraMMM+zcQM7IltBLpVZ0BAIdq9LJ6VmcRKqqfc19rZR85ePLOXmJVcoqDOWbtk
         JYKmYt+1od9QrwNmRxB1zwhOWPWdTK0/Ny8Ze1t9K0u1b8ZAFwqh2ZuqAHha5ixafb
         M91DbiXt1HG8kh7gB2oSvFfXQbwoEqOamoVMy8BQ=
Date:   Thu, 1 Oct 2020 10:09:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Subject: Re: [RFC net-next 9/9] genetlink: allow dumping command-specific
 policy
Message-ID: <20201001100933.26afbb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f5b9fe3a40de1e9d2b98c6ce21c2c3ae95065da9.camel@sipsolutions.net>
References: <20201001000518.685243-1-kuba@kernel.org>
        <20201001000518.685243-10-kuba@kernel.org>
        <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
        <20201001084152.33cc5bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3de28a3b54737ffd5c7d9944acc0614745242a30.camel@sipsolutions.net>
        <20201001092434.3f916d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f5b9fe3a40de1e9d2b98c6ce21c2c3ae95065da9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Oct 2020 18:57:35 +0200 Johannes Berg wrote:
> On Thu, 2020-10-01 at 09:24 -0700, Jakub Kicinski wrote:
> > > I guess the most compact representation, that also preserves the most
> > > data about sharing, would be to do something like
> > > 
> > > [ATTR_FAMILY_ID]
> > > [ATTR_POLICY]
> > >   [policy idx, 0 = main policy]
> > >     [bla]
> > >     ...
> > >   ...
> > > [ATTR_OP_POLICY]
> > >   [op] = [policy idx]
> > >   ...  
> 
> > Only comment I have is - can we make sure to put the ATTR_OP_POLICY
> > first? That way user space can parse the stream an pick out the info
> > it needs rather than recording all the policies only to find out later
> > which one is which.  
> 
> Hmm. Yes, that makes sense. But I don't see why not - you could go do
> the netlink_policy_dump_start() which that assigns the indexes, then
> dump out ATTR_OP_POLICY looking up the indexes in the table that it
> created, and then dump out all the policies?

Ack.

> > > I guess it's doable. Just seems a bit more complex. OTOH, it may be that
> > > such complexity also completely makes sense for non-generic netlink
> > > families anyway, I haven't looked at them much at all.  
> > 
> > IDK, doesn't seem crazy hard. We can create some iterator or expand the
> > API with "begin" "add" "end" calls. Then once dumper state is build we
> > can ask it which ids it assigned.  
> 
> Yeah. Seems feasible. Maybe I'll take a stab at it (later, when I can).
> 
> > OTOH I don't think we have a use for this in ethtool, because user
> > space usually does just one op per execution. So I'm thinking to use
> > your structure for the dump, but leave the actual implementation of
> > "dump all" for "later".
> > 
> > How does that sound?  
> 
> I'm not sure you even need that structure if you have the "filter by
> op"? I mean, then just stick to what you had?

I was adding OP as an attribute to each message. I will just ditch that
given user space should know what it asked for.

> When I started down this road I more had in mind "sniffer-like" tools
> that want to understand the messages better, etc. without really having
> any domain-specific "knowledge" encoded in them. And then you'd probably
> really want to build the entire policy representation in the tool side
> first.
> 
> Or perhaps even tools you could run on the latest kernel to generate
> code (e.g. python code was discussed) that would be able to build
> messages. You'd want to generate the code once on the latest kernel when
> you need a new feature, and then actually use it instead of redoing it
> at runtime, but still, could be done.
> 
> I suppose you have a completely different use case in mind :-)

I see. Yes, I'm trying to avoid having to probe the kernel for features.
We added new flags to ethtool to include extra info in the output, and
older kernels with return EOPNOTSUPP for the entire operation if those
are set (due to strict checking). While user would probably expect the
information to just not be there if kernel can't provide it. New
kernels can't provide it all the time either (it's extra stats from the
driver).

I'm hoping Michal will accept this as a solution :) Retrying on
EOPNOTSUPP gets a little hairy for my taste.

That should have been in the cover letter, I guess.
