Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190C03A084
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfFHPrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfFHPrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 11:47:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC811308FF30;
        Sat,  8 Jun 2019 15:47:16 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CAEC608A5;
        Sat,  8 Jun 2019 15:47:11 +0000 (UTC)
Date:   Sat, 8 Jun 2019 17:47:07 +0200
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
Message-ID: <20190608174707.33233a1b@redhat.com>
In-Reply-To: <20190608170206.4fa108f5@redhat.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
        <20190606231834.72182c33@redhat.com>
        <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
        <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
        <20190608075911.2622aecf@redhat.com>
        <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
        <20190608170206.4fa108f5@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Sat, 08 Jun 2019 15:47:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Jun 2019 17:02:06 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Sat, 8 Jun 2019 07:19:23 +0000
> Martin Lau <kafai@fb.com> wrote:
> 
> > On Sat, Jun 08, 2019 at 07:59:11AM +0200, Stefano Brivio wrote:  
> > > I also agree it makes more sense to filter routes this way.
> > > 
> > > But it wasn't like this before 2b760fcf5cfb, so this smells like
> > > breaking userspace expectations, even though iproute already filters
> > > routes this way: with 'cache' it only displays routes with
> > > RTM_F_CLONED, without, it won't display exceptions, see filter_nlmsg():    
> > Thanks for pointing it out.
> >   
> > > 	if (filter.cloned == !(r->rtm_flags & RTM_F_CLONED))
> > > 		return 0;
> > > 
> > > This, together with the fact it's been like that for almost two years
> > > now, makes it acceptable in my opinion. What do you think?    
> > With learning the above fact on iproute2,
> > it makes even less sense to dump exceptions from the kernel side
> > when RTM_F_CLONED is not set.  
> 
> I just hit a more fundamental problem though: iproute2 filters on the
> flag, but never sets it on a dump request. Flags will be NLM_F_DUMP |
> NLM_F_REQUEST, no matter what, see rtnl_routedump_req(). So the current
> iproute2 would have no way to dump cached routes.

Partially wrong: it actually sets it on 'list':

	if (rtnl_routedump_req(&rth, dump_family, iproute_dump_filter) < 0) {

[...]
static int iproute_dump_filter(struct nlmsghdr *nlh, int reqlen)
[...]
	if (filter.cloned)
		rtm->rtm_flags |= RTM_F_CLONED;

but not on 'flush':

		if (rtnl_routedump_req(&rth, family, NULL) < 0) {

but this doesn't change things much: it still has no way to flush the
cache, because the dump to get the routes to flush doesn't contain the
exceptions.

So I would stick to my latest plan.

-- 
Stefano
