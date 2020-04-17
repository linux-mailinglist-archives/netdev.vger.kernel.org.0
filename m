Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634AE1AD882
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgDQI2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgDQI2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 04:28:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E71207FC;
        Fri, 17 Apr 2020 08:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587112086;
        bh=QQPzFCVlCGkCSBFNb28/iOz36ajcfDrwqM74tyC4Rlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ykRPkOqdb3bmWZUJYvUIrR1xDHeyXWh8QvFUWLfjq/x7xYxQCKWlHNXLwnH7UuVoB
         H9m78bQhnyUSXGapxOjCkCvaWSMCNAM/pJcVvJVbqhvFVM76pMAh4UQWReXrIqJqfq
         P8XGQYMA2PgenqKMYeZit5y1omcEd1pMDeOMOAcA=
Date:   Fri, 17 Apr 2020 10:28:04 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200417082804.GB140064@kroah.com>
References: <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
 <20200416052409.GC1309273@unreal>
 <20200416133001.GK1068@sasha-vm>
 <550d615e14258c744cb76dd06c417d08d9e4de16.camel@mellanox.com>
 <20200416195859.GP1068@sasha-vm>
 <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 09:08:06PM +0000, Saeed Mahameed wrote:
> On Thu, 2020-04-16 at 15:58 -0400, Sasha Levin wrote:
> > On Thu, Apr 16, 2020 at 07:07:13PM +0000, Saeed Mahameed wrote:
> > > On Thu, 2020-04-16 at 09:30 -0400, Sasha Levin wrote:
> > > > On Thu, Apr 16, 2020 at 08:24:09AM +0300, Leon Romanovsky wrote:
> > > > > On Thu, Apr 16, 2020 at 04:08:10AM +0000, Saeed Mahameed wrote:
> > > > > > On Wed, 2020-04-15 at 20:00 -0400, Sasha Levin wrote:
> > > > > > > On Wed, Apr 15, 2020 at 05:18:38PM +0100, Edward Cree
> > > > > > > wrote:
> > > > > > > > Firstly, let me apologise: my previous email was too
> > > > > > > > harsh
> > > > > > > > and too
> > > > > > > >  assertiveabout things that were really more uncertain
> > > > > > > > and
> > > > > > > > unclear.
> > > > > > > > 
> > > > > > > > On 14/04/2020 21:57, Sasha Levin wrote:
> > > > > > > > > I've pointed out that almost 50% of commits tagged for
> > > > > > > > > stable do
> > > > > > > > > not
> > > > > > > > > have a fixes tag, and yet they are fixes. You really
> > > > > > > > > deduce
> > > > > > > > > things based
> > > > > > > > > on coin flip probability?
> > > > > > > > Yes, but far less than 50% of commits *not* tagged for
> > > > > > > > stable
> > > > > > > > have
> > > > > > > > a fixes
> > > > > > > >  tag.  It's not about hard-and-fast Aristotelian
> > > > > > > > "deductions", like
> > > > > > > > "this
> > > > > > > >  doesn't have Fixes:, therefore it is not a stable
> > > > > > > > candidate", it's
> > > > > > > > about
> > > > > > > >  probabilistic "induction".
> > > > > > > > 
> > > > > > > > > "it does increase the amount of countervailing evidence
> > > > > > > > > needed to
> > > > > > > > > conclude a commit is a fix" - Please explain this
> > > > > > > > > argument
> > > > > > > > > given
> > > > > > > > > the
> > > > > > > > > above.
> > > > > > > > Are you familiar with Bayesian statistics?  If not, I'd
> > > > > > > > suggest
> > > > > > > > reading
> > > > > > > >  something like http://yudkowsky.net/rational/bayes/
> > > > > > > > which
> > > > > > > > explains
> > > > > > > > it.
> > > > > > > > There's a big difference between a coin flip and a
> > > > > > > > _correlated_
> > > > > > > > coin flip.
> > > > > > > 
> > > > > > > I'd maybe point out that the selection process is based on
> > > > > > > a
> > > > > > > neural
> > > > > > > network which knows about the existence of a Fixes tag in a
> > > > > > > commit.
> > > > > > > 
> > > > > > > It does exactly what you're describing, but also taking a
> > > > > > > bunch
> > > > > > > more
> > > > > > > factors into it's desicion process ("panic"? "oops"?
> > > > > > > "overflow"?
> > > > > > > etc).
> > > > > > > 
> > > > > > 
> > > > > > I am not against AUTOSEL in general, as long as the decision
> > > > > > to
> > > > > > know
> > > > > > how far back it is allowed to take a patch is made
> > > > > > deterministically
> > > > > > and not statistically based on some AI hunch.
> > > > > > 
> > > > > > Any auto selection for a patch without a Fixes tags can be
> > > > > > catastrophic
> > > > > > .. imagine a patch without a Fixes Tag with a single line
> > > > > > that is
> > > > > > fixing some "oops", such patch can be easily applied cleanly
> > > > > > to
> > > > > > stable-
> > > > > > v.x and stable-v.y .. while it fixes the issue on v.x it
> > > > > > might
> > > > > > have
> > > > > > catastrophic results on v.y ..
> > > > > 
> > > > > I tried to imagine such flow and failed to do so. Are you
> > > > > talking
> > > > > about
> > > > > anything specific or imaginary case?
> > > > 
> > > > It happens, rarely, but it does. However, all the cases I can
> > > > think
> > > > of
> > > > happened with a stable tagged commit without a fixes where it's
> > > > backport
> > > > to an older tree caused unintended behavior (local denial of
> > > > service
> > > > in
> > > > one case).
> > > > 
> > > > The scenario you have in mind is true for both stable and non-
> > > > stable
> > > > tagged patches, so it you want to restrict how we deal with
> > > > commits
> > > > that
> > > > don't have a fixes tag shouldn't it be true for *all* commits?
> > > 
> > > All commits? even the ones without "oops" in them ? where does this
> > > stop ? :)
> > > We _must_ have a hard and deterministic cut for how far back to
> > > take a
> > > patch based on a human decision.. unless we are 100% positive
> > > autoselection AI can never make a mistake.
> > > 
> > > Humans are allowed to make mistakes, AI is not.
> > 
> > Oh I'm reviewing all patches myself after the bot does it's
> > selection,
> > you can blame me for these screw ups.
> > 
> > > If a Fixes tag is wrong, then a human will be blamed, and that is
> > > perfectly fine, but if we have some statistical model that we know
> > > it
> > > is going to be wrong 0.001% of the time.. and we still let it run..
> > > then something needs to be done about this.
> > > 
> > > I know there are benefits to autosel, but overtime, if this is not
> > > being audited, many pieces of the kernel will get broken unnoticed
> > > until some poor distro decides to upgrade their kernel version.
> > 
> > Quite a few distros are always running on the latest LTS releases,
> > Android isn't that far behind either at this point.
> > 
> > There are actually very few non-LTS users at this point...
> > 
> > > > > <...>
> > > > > > > Let me put my Microsoft employee hat on here. We have
> > > > > > > driver/net/hyperv/
> > > > > > > which definitely wasn't getting all the fixes it should
> > > > > > > have
> > > > > > > been
> > > > > > > getting without AUTOSEL.
> > > > > > > 
> > > > > > 
> > > > > > until some patch which shouldn't get backported slips
> > > > > > through,
> > > > > > believe
> > > > > > me this will happen, just give it some time ..
> > > > > 
> > > > > Bugs are inevitable, I don't see many differences between bugs
> > > > > introduced by manually cherry-picking or automatically one.
> > > > 
> > > > Oh bugs slip in, that's why I track how many bugs slipped via
> > > > stable
> > > > tagged commits vs non-stable tagged ones, and the statistic may
> > > > surprise
> > > > you.
> > > > 
> > > 
> > > Statistics do not matter here, what really matters is that there is
> > > a
> > > possibility of a non-human induced error, this should be a no no.
> > > or at least make it an opt-in thing for those who want to take
> > > their
> > > chances and keep a close eye on it..
> > 
> > Hrm, why? Pretend that the bot is a human sitting somewhere sending
> > mails out, how does it change anything?
> > 
> 
> If i know a bot might do something wrong, i Fix it and make sure it
> will never do it again. For humans i just can't do that, can I ? :)
> so this is the difference and why we all have jobs .. 
> 
> > > > The solution here is to beef up your testing infrastructure
> > > > rather
> > > > than
> > > 
> > > So please let me opt-in until I beef up my testing infra.
> > 
> > Already did :)
> 
> No you didn't :), I received more than 5 AUTOSEL emails only today and
> yesterday.
> 
> Please don't opt mlx5 out just yet ;-), i need to do some more research
> and make up my mind..
> 
> > 
> > > > taking less patches; we still want to have *all* the fixes,
> > > > right?
> > > > 
> > > 
> > > if you can be sure 100% it is the right thing to do, then yes,
> > > please
> > > don't hesitate to take that patch, even without asking anyone !!
> > > 
> > > Again, Humans are allowed to make mistakes.. AI is not.
> > 
> > Again, why?
> > 
> 
> Because AI is not there yet.. and this is a very big philosophical
> question.
> 
> Let me simplify: there is a bug in the AI, where it can choose a wrong
> patch, let's fix it.

You do realize that there are at least 2 steps in this "AI" where people
are involved.  The first is when Sasha goes thorough the patches and
weeds out all of the "bad ones".

The second is when you, the maintainer, is asked if you think there is a
problem if the patch is to be merged.

Then there's also the third, when again, I send out emails for the -rc
process with the patches involved, and you are cc:ed on it.

This isn't an unchecked process here running with no human checks at all
in it, so please don't speak of it like it is.

thanks,

greg k-h
