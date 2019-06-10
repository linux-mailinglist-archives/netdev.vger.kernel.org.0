Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A003BDF5
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbfFJVCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388311AbfFJVCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:02:09 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C525F81E03;
        Mon, 10 Jun 2019 21:02:07 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E7A360A9F;
        Mon, 10 Jun 2019 21:01:58 +0000 (UTC)
Date:   Mon, 10 Jun 2019 23:01:54 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190610230154.63788980@redhat.com>
In-Reply-To: <20190610194238.3gke27kflrocrpwo@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
        <20190606231834.72182c33@redhat.com>
        <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
        <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
        <20190608075911.2622aecf@redhat.com>
        <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
        <20190608170206.4fa108f5@redhat.com>
        <20190608174707.33233a1b@redhat.com>
        <20190610194238.3gke27kflrocrpwo@kafai-mbp.dhcp.thefacebook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 10 Jun 2019 21:02:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 19:42:41 +0000
Martin Lau <kafai@fb.com> wrote:

> On Sat, Jun 08, 2019 at 05:47:07PM +0200, Stefano Brivio wrote:
> > On Sat, 8 Jun 2019 17:02:06 +0200
> > Stefano Brivio <sbrivio@redhat.com> wrote:
> >   
> > > On Sat, 8 Jun 2019 07:19:23 +0000
> > > Martin Lau <kafai@fb.com> wrote:
> > >   
> > > > On Sat, Jun 08, 2019 at 07:59:11AM +0200, Stefano Brivio wrote:    
> > > > > I also agree it makes more sense to filter routes this way.
> > > > > 
> > > > > But it wasn't like this before 2b760fcf5cfb, so this smells like
> > > > > breaking userspace expectations, even though iproute already filters
> > > > > routes this way: with 'cache' it only displays routes with
> > > > > RTM_F_CLONED, without, it won't display exceptions, see filter_nlmsg():      
> > > > Thanks for pointing it out.
> > > >     
> > > > > 	if (filter.cloned == !(r->rtm_flags & RTM_F_CLONED))
> > > > > 		return 0;
> > > > > 
> > > > > This, together with the fact it's been like that for almost two years
> > > > > now, makes it acceptable in my opinion. What do you think?      
> > > > With learning the above fact on iproute2,
> > > > it makes even less sense to dump exceptions from the kernel side
> > > > when RTM_F_CLONED is not set.    
> > > 
> > > I just hit a more fundamental problem though: iproute2 filters on the
> > > flag, but never sets it on a dump request. Flags will be NLM_F_DUMP |
> > > NLM_F_REQUEST, no matter what, see rtnl_routedump_req(). So the current
> > > iproute2 would have no way to dump cached routes.  
> > 
> > Partially wrong: it actually sets it on 'list':
> > 
> > 	if (rtnl_routedump_req(&rth, dump_family, iproute_dump_filter) < 0) {
> > 
> > [...]
> > static int iproute_dump_filter(struct nlmsghdr *nlh, int reqlen)
> > [...]
> > 	if (filter.cloned)
> > 		rtm->rtm_flags |= RTM_F_CLONED;
> > 
> > but not on 'flush':
> > 
> > 		if (rtnl_routedump_req(&rth, family, NULL) < 0) {
> > 
> > but this doesn't change things much: it still has no way to flush the
> > cache, because the dump to get the routes to flush doesn't contain the
> > exceptions.  
> 'ip -6 r l table cache' can be limited to dump the cache only, right?

Yes, at it was in v1 and v2. But that's arbitrary and inconsistent,
because without RTM_F_CLONED we would anyway need (with current
iproute2) to dump exceptions too.

RTM_F_CLONED just isn't a filter right now. Let's add support for
NLM_F_MATCH later and have clear semantics. I think this whole mess
comes from the fact we miss that.

> I am still missing something about why the kernel is required
> to output everything and then filtered out in the iproute2.
> 
> You meant either:
> The kernel needs to dump everything first. iproute2 can then figure out
> which one is cache and then flush them?

Yes, this is the case, right now.

> or
> the iproute2 can be changed to only get the cache from the kernel and then
> flush them?

I didn't mean this. In theory, we could, but I wouldn't fix a kernel
regression with a userspace change. I'm not adding NLM_F_MATCH support
in this fix because it wouldn't be a fix for past and current iproute2
versions, so it wouldn't be a fix.

> AFAIK, the kernel has never dumped the cache routes for IPv4.

Right now, it doesn't, but I can't believe that 'ip route list cache'
was implemented in iproute2 and it never worked. I haven't tested IPv4
with older kernels, though.

> What is done here has to be consistent with the future patch in IPv4.
> Each node can hold up to 5*1024 caches which is ok-ish but still a waste
> to dump it and then not printing it.

Indeed, I agree. For both IPv4 and IPv6, we need to have clear
semantics to avoid this waste. NLM_F_MATCH is specified by RFC 3549
exactly for this purpose, but we don't implement that.

Without NLM_F_MATCH, RTM_F_CLONED is just what the comment in UAPI says:

#define RTM_F_CLONED		0x200	/* This route is cloned		*/

So the future patch for IPv4 would be consistent: without NLM_F_MATCH
we'll dump everything and iproute2 filters (as it was until 2017 at
least for IPv6).

Then I'd add, for both IPv4 and IPv6, support for NLM_F_MATCH (both
for kernel and iproute2): kernel filters, sends NLM_F_DUMP_FILTERED
back and iproute2 doesn't (need to) filter. But this will be a (kind of
needed) optimisation, not a fix.

-- 
Stefano
