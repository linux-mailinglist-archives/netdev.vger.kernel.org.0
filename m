Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810C5289181
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbgJISz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388184AbgJISz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:55:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325D7C0613D2;
        Fri,  9 Oct 2020 11:55:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kQxYW-0000rj-1m; Fri, 09 Oct 2020 20:55:52 +0200
Date:   Fri, 9 Oct 2020 20:55:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, fw@strlen.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201009185552.GF5723@breakpoint.cc>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > The repro clears all rules, waits 4 seconds, then restores the ruleset. 
> > using iptables-restore < FOO; sleep 4; iptables-restore < FOO will not 
> > result in any unregister ops.
> >
> > We could make kernel defer unregister via some work queue but i don't
> > see what this would help/accomplish (and its questionable of how long it
> > should wait).
> 
> Sorry, I can't put together the two paragraphs above: in the first you 
> wrote that no (hook) unregister-register happens and in the second one 
> that those could be derefed.

Sorry, my reply is confusing indeed.

Matches/targets that need conntrack increment a refcount.
So, when all rules are flushed, refcount goes down to 0 and conntrack is
disabled because the hooks get removed..

Just doing iptables-restore doesn't unregister as long as both the old
and new rulesets need conntrack.

The "delay unregister" remark was wrt. the "all rules were deleted"
case, i.e. add a "grace period" rather than acting right away when
conntrack use count did hit 0.

> > We could disallow unregister, but that seems silly (forces reboot...).
> > 
> > I think the patch is fine.
> 
> The patch is fine, but why the packets are handled by conntrack (after the 
> first restore and during the 4s sleep? And then again after the second 
> restore?) as if all conntrack entries were removed?

Conntrack entries are not removed, only the base hooks get unregistered.
This is a problem for tcp window tracking.

When re-register occurs, kernel is supposed to switch the existing
entries to "loose" mode so window tracking won't flag packets as
invalid, but apparently this isn't enough to handle keepalive case.
