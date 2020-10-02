Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB6281680
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388127AbgJBPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:25:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58349206DC;
        Fri,  2 Oct 2020 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601652319;
        bh=yJySMyNGLlbmS5lhCJUhQ4nYHc+LXmDrll9ccYdkbQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oNMJ1cU44MUQSZuW708MmtA4yLi3FQm5xCxj8tmgVlzoBMb2eq6ALziab0xbmYzZg
         y2v2UIDRfENjaJT9WK4T25rzUDsZiiONaSA709H6doH5GTrxWlfMGuSy5D4WmOp2Wa
         LSY1PkK/V3188PvFO0ifxS/Kc5ul9B6PKmD8D6+c=
Date:   Fri, 2 Oct 2020 08:25:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <db56057454ee3338a7fe13c8d5cc450b22b18c3b.camel@sipsolutions.net>
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
        <db56057454ee3338a7fe13c8d5cc450b22b18c3b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 17:13:28 +0200 Johannes Berg wrote:
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
> I suppose, I thought you wanted to change it to have separate dump/do
> policies? Whatever you like there, I don't really care much :)

I just want to make the uAPI future-proof for now.

At a quick look ethtool doesn't really accept any attributes but
headers for GET requests. DO and DUMP are the same there so it's 
not a priority for me.

> But I can also change my patches later to separately advertise dump/do
> policies, and simply always use the same one for now.

Right that was what I was thinking. Basically:

	if ((op.doit && nla_put_u32(skb, CTRL_whatever_DO, idx)) ||
	    (op.dumpit && nla_put_u32(skb, CTRL_whatever_DUMP, idx)))
		goto nla_put_failure;

> But this series does conflict with the little bugfix I also sent, could
> you please take a look?
> 
> https://lore.kernel.org/netdev/20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid/
> 
> I'm not really sure how to handle.

Yeah, just noticed that one now :S

Dave, are you planning a PR to Linus soon by any chance? The conflict
between this series and Johannes's fix would be logically simple to
resolve but not trivial :(
