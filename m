Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5123375F8
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfFFOEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:04:12 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51304 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfFFOEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:04:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYszy-0001Sg-9o; Thu, 06 Jun 2019 16:04:10 +0200
Date:   Thu, 6 Jun 2019 16:04:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     John Hurley <john.hurley@netronome.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        oss-drivers@netronome.com
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
Message-ID: <20190606140410.4rp3eudxamdtfme7@breakpoint.cc>
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
 <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
 <CAK+XE=kQyq-ZW=DOaQq92zSmwcEi3BBwma1MydrdpnZ6F3Gp+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK+XE=kQyq-ZW=DOaQq92zSmwcEi3BBwma1MydrdpnZ6F3Gp+A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hurley <john.hurley@netronome.com> wrote:
> On Thu, Jun 6, 2019 at 1:58 PM Florian Westphal <fw@strlen.de> wrote:
> > I dislike this, why can't we just use a pcpu counter?
> >
> > The only problem is with recursion/nesting; whenever we
> > hit something that queues the skb for later we're safe.
> >
> 
> Hi Florian,
> The per cpu counter (initial proposal) should protect against
> recursion through loops and the potential stack overflows.
> It will not protect against a packet infinitely looping through a poor
> configuration if (as you say) the packet is queued at some point and
> the cpu counter reset.

Yes, it won't help, but thats not harmful, such cycle will be
broken/resolved as soon as the configuration is fixed.

> The per skb tracking seems to accommodate both issues.

Yes, but I do not see the 'looping with queueing' as a problem,
it can also occur for different reasons.

> Do you see the how the cpu counter could stop infinite loops in the
> case of queuing?

No, but I don't think it has to.

> Or perhaps these are 2 different issues and should be treated differently?

The recursion is a problem, so, yes, I think these are different issues.

> > We can't catch loops in real (physical) setups either,
> > e.g. bridge looping back on itself.
> 
> yes, this is only targeted at 'internal' loops.

Right, however, I'm not sure we should bother with those, we can't
prevent this (looping packets) from happening for other reasons.

I'm sure you can make packets go in circles without tc, e.g. via
veth+bridge+netns.
