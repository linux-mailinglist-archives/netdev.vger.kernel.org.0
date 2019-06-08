Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2143A059
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfFHPCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfFHPCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 11:02:19 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C23A130842CE;
        Sat,  8 Jun 2019 15:02:13 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 242A6601A6;
        Sat,  8 Jun 2019 15:02:10 +0000 (UTC)
Date:   Sat, 8 Jun 2019 17:02:06 +0200
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
Message-ID: <20190608170206.4fa108f5@redhat.com>
In-Reply-To: <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
        <20190606231834.72182c33@redhat.com>
        <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
        <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
        <20190608075911.2622aecf@redhat.com>
        <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Sat, 08 Jun 2019 15:02:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Jun 2019 07:19:23 +0000
Martin Lau <kafai@fb.com> wrote:

> On Sat, Jun 08, 2019 at 07:59:11AM +0200, Stefano Brivio wrote:
> > I also agree it makes more sense to filter routes this way.
> > 
> > But it wasn't like this before 2b760fcf5cfb, so this smells like
> > breaking userspace expectations, even though iproute already filters
> > routes this way: with 'cache' it only displays routes with
> > RTM_F_CLONED, without, it won't display exceptions, see filter_nlmsg():  
> Thanks for pointing it out.
> 
> > 	if (filter.cloned == !(r->rtm_flags & RTM_F_CLONED))
> > 		return 0;
> > 
> > This, together with the fact it's been like that for almost two years
> > now, makes it acceptable in my opinion. What do you think?  
> With learning the above fact on iproute2,
> it makes even less sense to dump exceptions from the kernel side
> when RTM_F_CLONED is not set.

I just hit a more fundamental problem though: iproute2 filters on the
flag, but never sets it on a dump request. Flags will be NLM_F_DUMP |
NLM_F_REQUEST, no matter what, see rtnl_routedump_req(). So the current
iproute2 would have no way to dump cached routes.

It could from 2007, iproute2 9ab4c85b9af1 ("Fix bug in display of ipv6
cloned/cached routes"), to 2017, kernel 2b760fcf5cfb ("ipv6: hook up
exception table to store dst cache").

Something tells me it's wrong to fix userspace, because userspace "is
always right". There has been by the way a similar discussion on this
list in 2011, see https://lists.openwall.net/netdev/2011/12/28/27.

I would proceed like this:

- stick to the original semantic of RTM_F_CLONED and fix the issue at
  hand, which would be v2 with your suggested clean-up and without
  check on RTM_F_CLONED. Exceptions are always dumped and iproute2 will
  filter them as it always did. Result: kernel sends exceptions on
  netlink even if not "requested" but iproute2 works again and won't
  spam you anyway, and the issue is fixed for the users

- fix this on IPv4 (as I mentioned, I think it's less critical, because
  at least flushing works, and listing with 'route get' is awkward but
  possible)

- retry adding NLM_F_MATCH (for net-next and iproute-next) according
  to RFC 3549. Things changed a bit from 2011: we now have
  NLM_F_DUMP_FILTERED, iproute2 already uses it (ip neigh) and we
  wouldn't need to make iproute2 more complicated by handling old/new
  kernel cases. So I think this would be reasonable now.

-- 
Stefano
