Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68E93BC59
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388680AbfFJTBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387674AbfFJTBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 15:01:37 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBAE38535D;
        Mon, 10 Jun 2019 19:01:31 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EED5F600C4;
        Mon, 10 Jun 2019 19:01:25 +0000 (UTC)
Date:   Mon, 10 Jun 2019 21:01:21 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "Vaittinen, Matti" <Matti.Vaittinen@fi.rohmeurope.com>
Cc:     "kafai@fb.com" <kafai@fb.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "weiwan@google.com" <weiwan@google.com>,
        "jishi@redhat.com" <jishi@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190610210121.5d543bb0@redhat.com>
In-Reply-To: <876287da6e45876a9874782a00eea0b6cb8a9aa0.camel@fi.rohmeurope.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
        <20190606231834.72182c33@redhat.com>
        <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
        <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
        <20190608075911.2622aecf@redhat.com>
        <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
        <20190608170206.4fa108f5@redhat.com>
        <876287da6e45876a9874782a00eea0b6cb8a9aa0.camel@fi.rohmeurope.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 10 Jun 2019 19:01:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matti,

On Mon, 10 Jun 2019 05:56:03 +0000
"Vaittinen, Matti" <Matti.Vaittinen@fi.rohmeurope.com> wrote:

> Hi Dee Ho Peeps!
> 
> Wow Stefano, you seem to be quite a detective :) How on earth did you
> match my new email to this sole netdev intrusion done back at the 2011
> %) Impressive!

I was looking for lost UDP jokes. :)

> On Sat, 2019-06-08 at 17:02 +0200, Stefano Brivio wrote:
> 
> > 
> > - retry adding NLM_F_MATCH (for net-next and iproute-next) according
> >   to RFC 3549. Things changed a bit from 2011: we now have
> >   NLM_F_DUMP_FILTERED, iproute2 already uses it (ip neigh) and we
> >   wouldn't need to make iproute2 more complicated by handling old/new
> >   kernel cases. So I think this would be reasonable now.
> >   
> I am pretty sure the iproute would not have become more complicated
> back in 2011 even if we did push this change back then. iproute2 could
> have chosen to stick with own userspace filtering - supporting the
> NLM_F_MATCH flag back then would not have broken that. And if we did it
> back then - there now probably was some other tools utilizing the
> kernel filtering - and today the iproute2 could pretty safely drop the
> user-space route filtering code and transition to do filtering already
> in kernel. Well, that's a bit late to say today :)

Well, yes, it wouldn't have become more complicated. The difference
today is that, with NLM_F_DUMP_FILTERED codifying this, we could safely
and simply skip userspace filtering with just two lines, something like:

	if (n->nlmsg_flags & RTM_F_DUMP_FILTERED)
		return 1;

in filter_nlmsg().

> But yes, this unfinished thing has indeed haunted me during some black
> nights =) I would be delighted to see the proper NLM_F_MATCH support in
> kernel.
> 
> What stopped me back in the 2011 was actually Dave's comment that even
> if he could consider applying this change he would require it for IPv4
> too. And that makes perfect sense. It was just too much for me back
> then. I guess this has not changed - IPv6 and IPv4 should still handle
> these flags in a same way.

Indeed, we'll have to take care of both. It's on my to do list now, I
should get to it soon.

Right now my priority is to fix the fact that, at least with iproute2,
flushing IPv6 routed caches is simply not possible anymore. This looks
like a serious breakage to me.

-- 
Stefano
