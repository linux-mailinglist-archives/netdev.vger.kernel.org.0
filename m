Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB32476A7
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 22:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfFPUEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 16:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfFPUEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 16:04:25 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C02F308404B;
        Sun, 16 Jun 2019 20:04:24 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9590852DC;
        Sun, 16 Jun 2019 20:04:21 +0000 (UTC)
Date:   Sun, 16 Jun 2019 22:04:17 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
Message-ID: <20190616220417.573be9a6@redhat.com>
In-Reply-To: <20190615052705.66f3fe62@redhat.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
        <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
        <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
        <20190615051342.7e32c2bb@redhat.com>
        <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
        <20190615052705.66f3fe62@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sun, 16 Jun 2019 20:04:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Jun 2019 05:27:05 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Fri, 14 Jun 2019 21:16:54 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
> > On 6/14/19 9:13 PM, Stefano Brivio wrote:  
> > > On Fri, 14 Jun 2019 20:54:49 -0600
> > > David Ahern <dsahern@gmail.com> wrote:
> > >     
> > >> On 6/14/19 7:32 PM, Stefano Brivio wrote:    
> > >>> ip_valid_fib_dump_req() does two things: performs strict checking on
> > >>> netlink attributes for dump requests, and sets a dump filter if netlink
> > >>> attributes require it.
> > >>>
> > >>> We might want to just set a filter, without performing strict validation.
> > >>>
> > >>> Rename it to ip_filter_fib_dump_req(), and add a 'strict' boolean
> > >>> argument that must be set if strict validation is requested.
> > >>>
> > >>> This patch doesn't introduce any functional changes.
> > >>>
> > >>> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > >>> ---
> > >>> v4: New patch
> > >>>       
> > >>
> > >> Can you explain why this patch is needed? The existing function requires
> > >> strict mode and is needed to enable any of the kernel side filtering
> > >> beyond the RTM_F_CLONED setting in rtm_flags.    
> > > 
> > > It's mostly to have proper NLM_F_MATCH support. Let's pick an iproute2
> > > version without strict checking support (< 5.0), that sets NLM_F_MATCH
> > > though. Then we need this check:
> > > 
> > > 	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm)))    
> > 
> > but that check existed long before any of the strict checking and kernel
> > side filtering was added.  
> 
> Indeed. And now I'm recycling it, even if strict checking is not
> requested.
> 
> > > and to set filter parameters not just based on flags (i.e. RTM_F_CLONED),
> > > but also on table, protocol, etc.    
> > 
> > and to do that you *must* have strict checking. There is no way to trust
> > userspace without that strict flag set because iproute2 for the longest
> > time sent the wrong header for almost all dump requests.  
> 
> So you're implying that:
> 
> - we shouldn't support NLM_F_MATCH
> 
> - we should keep this broken for iproute2 < 5.0.0?
> 
> I guess this might be acceptable, but please state it clearly.
> 
> By the way, if really needed, we can do strict checking even if not
> requested. But this might add more and more userspace breakage, I guess.

Maybe I have a simpler alternative, that doesn't allow filters without
strict checking (your concern above) and fixes the issue for most
iproute2 versions (except for 'ip -6 route cache flush' from 5.0.0 to
current, unpatched version). I would also like to avoid introducing
this bug:

- 'ip route list cache table main' currently returns nothing (bug)

- 'ip route list cache table main' with v1-v3 would return all cached
  routes (new bug)

and retain this feature from v4:

- if neither NLM_F_MATCH nor other filters are set, dump all cached and
  uncached routes. There's no way to get cached and uncached ones with
  a single request, otherwise. This would also fit RFC 3549.

We could do this:

- strict checking enabled (iproute2 >= 5.0.0):
  - in inet{,6}_dump_fib(): if NLM_F_MATCH is set, set
    filter->filter_set in any case

  - in fn_trie_dump_leaf() and rt6_dump_route(): use filter->filter_set
    to decide if we want to filter depending on RTM_F_CLONED being
    set/unset. If other filters (rt_type, dev, protocol) are not set,
    they are still wildcards (existing implementation)

- no strict checking (iproute2 < 5.0.0):
  - we can't filter consistently, so apply no filters at all: dump all
    the routes (filter->filter_set not set), cached and uncached. That
    means more netlink messages, but no spam as iproute2 filters them
    anyway, and list/flush cache commands work again.

I would drop 1/8, turn 2/8 and 6/8 into a straightforward:

 	if (cb->strict_check) {
 		err = ip_valid_fib_dump_req(net, nlh, &filter, cb);
 		if (err < 0)
 			return err;
+		if (nlh->nlmsg_flags & NLM_F_MATCH)
+			filter.filter_set = 1;
 	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
 		struct rtmsg *rtm = nlmsg_data(nlh);

and other patches remain the same.

What do you think?

-- 
Stefano
