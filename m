Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4737918DB24
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCTW1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:27:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:56184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCTW1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 18:27:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7368AD66;
        Fri, 20 Mar 2020 22:27:36 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F1BF8E0FD3; Fri, 20 Mar 2020 23:27:35 +0100 (CET)
Date:   Fri, 20 Mar 2020 23:27:35 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netlink: check for null extack in cookie helpers
Message-ID: <20200320222735.GA31519@unicorn.suse.cz>
References: <20200320211343.4BD38E0FD3@unicorn.suse.cz>
 <b4b1d7b252820591ebb00e3851d44dc6c3f2d1b9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4b1d7b252820591ebb00e3851d44dc6c3f2d1b9.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 10:22:45PM +0100, Johannes Berg wrote:
> Hi Michal,
> 
> > Unlike NL_SET_ERR_* macros, nl_set_extack_cookie_u64() and
> > nl_set_extack_cookie_u32() helpers do not check extack argument for null
> > and neither do their callers, as syzbot recently discovered for
> > ethnl_parse_header().
> 
> What exactly did it discover?

It's this report:

  https://lkml.kernel.org/r/00000000000027204705a1354443@google.com

The reproducer does not set NLM_F_ACK in a dump request so that extack
is null and nl_set_extack_cookie_u32() tries to write at address 0x10.

> > Instead of fixing the callers and leaving the trap in place, add check of
> > null extack to both helpers to make them consistent with NL_SET_ERR_*
> > macros.
> > 
> > Fixes: 2363d73a2f3e ("ethtool: reject unrecognized request flags")
> > Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
> 
> I'm not really convinced, at least not for the second patch.

Now I see that I was mistaken by the name and nl80211_pmsr_start() is in
fact ->doit() handler, not ->start(), so that it seems that it cannot be
really called with null info->extack. I'm not 100% sure of that either
(I would need to check the whole call path carefully again) but I'll
drop the second Fixes line.

> After all, this is an important part of the functionality, and the whole
> thing is pretty useless if no extack/cookie is returned since then you
> don't have a handle to the in-progress operation.
> 
> That was the intention originally too, until now the cookie also got
> used for auxiliary error information...
> 
> Now, I don't think we need to *crash* when something went wrong here,
> but then I'd argue there should at least be a WARN_ON(). But then that
> means syzbot will just trigger the WARN_ON which also makes it unhappy,
> so you still would have to check in the caller?

From my point of view, having to keep in mind that NL_SET_ERR_MSG* are
no-op if extack is null but nl_set_extack_cookie_u{64,32} would crash
seems very inconvenient and even if I add the check into
ethnl_parse_header(), sooner or later someone is going to fall into the
same trap. Thus I believe that if there is a need for a warning when
nl80211_pmsr_start() is unexpectedly called with null info->extack, such
check should be done in nl80211_pmsr_start(), not by letting
nl_set_extack_cookie_u64() crash.

Michal

