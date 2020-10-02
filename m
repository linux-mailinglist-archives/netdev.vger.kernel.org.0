Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0485E281D22
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgJBUvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJBUvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 16:51:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919022065D;
        Fri,  2 Oct 2020 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601671862;
        bh=esICm/SvBtu16uuR6wSDH0z6U9GzCchURvk9Y/1OF0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DYWHC18/OM0Ao74PmVVu+XAEGaOHOddbPZSm7iyLHAmL9UoYgdSTyfER1ApngBlZJ
         vbxQAoYJiS9w3wWHZTByB/bs7s4EBd9OxVM/MPYnZMDO76kg/F55IxrPccjAwCORRC
         o3ZFZ1f/EOOwmqCzuk8Tkyu92i/rvFYhsYROeb3c=
Date:   Fri, 2 Oct 2020 13:50:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002135059.1657d673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cc9594d16270aeb55f9f429a234ec72468403b93.camel@sipsolutions.net>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
        <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
        <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
        <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
        <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cc9594d16270aeb55f9f429a234ec72468403b93.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 22:27:19 +0200 Johannes Berg wrote:
> On Fri, 2020-10-02 at 08:09 -0700, Jakub Kicinski wrote:
> > On Fri, 02 Oct 2020 17:04:11 +0200 Johannes Berg wrote:  
> > > > > Yeah, that'd work. I'd probably wonder if we shouldn't do
> > > > > 
> > > > > [OP_POLICY]
> > > > >   [OP] -> (u32, u32)
> > > > > 
> > > > > in a struct with two u32's, since that's quite a bit more compact.    
> > > > 
> > > > What do we do if the op doesn't have a dump or do callback?
> > > > 0 is a valid policy ID, sadly :(    
> > > 
> > > Hm, good point. We could do -1 since that can't ever be reached though.
> > > 
> > > But compactness isn't really that necessary here anyway, so ...  
> > 
> > Cool, sounds like a plan.
> > 
> > This series should be good to merge, then.  
> 
> So I'm having second thoughts on this now :)
> 
> If you ask me to split the policy dump to do/dump, like we discussed
> above, then what you did here for "retrieve a single policy" doesn't
> really make any sense? Because you'd be able to do that properly only
> for do, or you need my patches to get both?
> 
> Perhaps it would make sense if you removed patch 10 from your set, and
> we add it back after my patches?
> 
> Or I could submit my patches right after yours, but that leaves the code
> between the commits doing something weird, in that it would only give
> you the policies but no indication of which is for do/dump? Obviously
> today it'd only be one, but still, from a uAPI perspective.

My thinking was that until kernel actually start using separate dump
policies user space can assume policy 0 is relevant. But yeah, merging
your changes first would probably be best.

> I guess it doesn't matter too much though, we get to the state that we
> want to be in, just the intermediate steps won't necessarily make much
> sense.
> 
> For now I'll respin my patches so we see how the above do/dump
> separating looks.

I, OTOH, am having second thoughts about not implementing separate
policies for dump right away, since Michal said he'll need them soon :)

Any ideas on how to do that cleanly? At some point it will make sense
to have dumps and doits in separate structures, as you said earlier,
but can we have "small" and "full" ops for both? That seems like too
much :/
