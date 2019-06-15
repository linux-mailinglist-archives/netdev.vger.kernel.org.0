Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCAC46E05
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfFOD1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:27:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfFOD1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 23:27:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABDAB3082AE5;
        Sat, 15 Jun 2019 03:27:12 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E53919C67;
        Sat, 15 Jun 2019 03:27:09 +0000 (UTC)
Date:   Sat, 15 Jun 2019 05:27:05 +0200
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
Message-ID: <20190615052705.66f3fe62@redhat.com>
In-Reply-To: <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
        <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
        <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
        <20190615051342.7e32c2bb@redhat.com>
        <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sat, 15 Jun 2019 03:27:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 21:16:54 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/14/19 9:13 PM, Stefano Brivio wrote:
> > On Fri, 14 Jun 2019 20:54:49 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> >   
> >> On 6/14/19 7:32 PM, Stefano Brivio wrote:  
> >>> ip_valid_fib_dump_req() does two things: performs strict checking on
> >>> netlink attributes for dump requests, and sets a dump filter if netlink
> >>> attributes require it.
> >>>
> >>> We might want to just set a filter, without performing strict validation.
> >>>
> >>> Rename it to ip_filter_fib_dump_req(), and add a 'strict' boolean
> >>> argument that must be set if strict validation is requested.
> >>>
> >>> This patch doesn't introduce any functional changes.
> >>>
> >>> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> >>> ---
> >>> v4: New patch
> >>>     
> >>
> >> Can you explain why this patch is needed? The existing function requires
> >> strict mode and is needed to enable any of the kernel side filtering
> >> beyond the RTM_F_CLONED setting in rtm_flags.  
> > 
> > It's mostly to have proper NLM_F_MATCH support. Let's pick an iproute2
> > version without strict checking support (< 5.0), that sets NLM_F_MATCH
> > though. Then we need this check:
> > 
> > 	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm)))  
> 
> but that check existed long before any of the strict checking and kernel
> side filtering was added.

Indeed. And now I'm recycling it, even if strict checking is not
requested.

> > and to set filter parameters not just based on flags (i.e. RTM_F_CLONED),
> > but also on table, protocol, etc.  
> 
> and to do that you *must* have strict checking. There is no way to trust
> userspace without that strict flag set because iproute2 for the longest
> time sent the wrong header for almost all dump requests.

So you're implying that:

- we shouldn't support NLM_F_MATCH

- we should keep this broken for iproute2 < 5.0.0?

I guess this might be acceptable, but please state it clearly.

By the way, if really needed, we can do strict checking even if not
requested. But this might add more and more userspace breakage, I guess.

-- 
Stefano
