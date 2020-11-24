Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244262C1B85
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 03:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgKXCmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 21:42:15 -0500
Received: from smtp.netregistry.net ([202.124.241.204]:44994 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbgKXCmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 21:42:15 -0500
Received: from 124-148-94-203.tpgi.com.au ([124.148.94.203]:53058 helo=192-168-1-16.tpgi.com.au)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1khOH8-000507-MC; Tue, 24 Nov 2020 13:42:12 +1100
Date:   Tue, 24 Nov 2020 12:41:49 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
Message-ID: <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
In-Reply-To: <20201123225505.GA21345@linux.home>
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
        <20201123225505.GA21345@linux.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 23:55:05 +0100
Guillaume Nault <gnault@redhat.com> wrote:

> On Sat, Nov 21, 2020 at 06:24:46PM +1000, Russell Strong wrote:
> > From 2f27f92d5a6f4dd69ac4af32cdb51ba8d2083606 Mon Sep 17 00:00:00 2001
> > From: Russell Strong <russell@strong.id.au>
> > Date: Sat, 21 Nov 2020 18:12:43 +1000
> > Subject: [PATCH] DSCP in IPv4 routing v2
> > 
> > This patch allows the use of DSCP values in routing  
> 
> Thanks. There are some problems with this patch though.
> 
> About the email:
>   * Why did you duplicate email headers in the body?
>   * For the subject, please put the "v2" in the "[PATCH ... ]" part.
>   * You're modifying many files, but haven't Cc-ed any of their authors
>     or maintainers.
>   * The patch content is corrupted.

I'm still quite new to this.  I used git format-patch then inserted
into claws.....  I have since read the doc on email clients and
switched off autowrapping :)

I was wondering if one patch would be acceptable, or should it be broken
up?  If broken up. It would not make sense to apply 1/2 of them.

> 
> > Use of TOS macros are replaced with DSCP macros
> > where the change does not change the user space API
> > with one exception:
> > 
> > net/ipv4/fib_rules.c has been changed to accept a
> > wider range of values ( dscp values ).  Previously
> > this would have returned an error.  
> 
> Have you really verified that replacing each of these RT_TOS calls had
> no unwanted side effect?
> 
> RT_TOS didn't clear the second lowest bit, while the new IP_DSCP does.
> Therefore, there's no guarantee that such a blanket replacement isn't
> going to change existing behaviours. Replacements have to be done
> step by step and accompanied by an explanation of why they're safe.

Original TOS did not use this bit until it was added in RFC1349 as "lowcost".
The DSCP change (RFC2474) marked these as currently unused, but worse than that,
with the introduction of ECN, both of those now "unused" bits are for ECN.
Other parts of the kernel are using those bits for ECN, so bit 1 probably
shouldn't be used in routing anymore as congestion could create unexpected
routing behaviour, i.e. fib_rules


> 
> BTW, I think there are some problems with RT_TOS that need to be fixed
> separately first.
> 
> For example some of the ip6_make_flowinfo() calls can probably
> erroneously mark some packets with ECT(0). Instead of masking the
> problem in this patch, I think it'd be better to have an explicit fix
> that'd mask the ECN bits in ip6_make_flowinfo() and drop the buggy
> RT_TOS() in the callers.
> 
> Another example is inet_rtm_getroute(). It calls
> ip_route_output_key_hash_rcu() without masking the tos field first.

Should rtm->tos be checked for validity in inet_rtm_valid_getroute_req? Seems
like it was missed.  That would make the mask unnecessary, but...  It's like
wack a mole.


> Therefore it can return a different route than what the routing code
> would actually use. Like for the ip6_make_flowinfo() case, it might
> be better to stop relying on the callers to mask ECN bits and do that
> in ip_route_output_key_hash_rcu() instead.

In this context one of the ECN bits is not an ECN bit, as can be seen by

#define RT_FL_TOS(oldflp4) \
        ((oldflp4)->flowi4_tos & (IP_DSCP_MASK | RTO_ONLINK))

It's all a bit messy and spread about.  Reducing the distributed nature of
the masking would be good.



> I'll verify that these two problems can actually happen in practice
> and will send patches if necessary.

Thanks


> 
> > iproute2 already supports setting dscp values through
> > ip route add dsfield <dscp value> lookup ......
> > 
> > Signed-off-by: Russell Strong <russell@strong.id.au>
> > ---
> >  .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  2 +-
> >  drivers/net/geneve.c                          |  4 ++--
> >  drivers/net/ipvlan/ipvlan_core.c              |  2 +-
> >  drivers/net/ppp/pptp.c                        |  2 +-
> >  drivers/net/vrf.c                             |  2 +-
> >  drivers/net/vxlan.c                           |  4 ++--
> >  include/net/ip.h                              |  2 +-
> >  include/net/route.h                           |  6 ++----
> >  include/uapi/linux/ip.h                       |  2 ++
> >  net/bridge/br_netfilter_hooks.c               |  2 +-
> >  net/core/filter.c                             |  4 ++--
> >  net/core/lwt_bpf.c                            |  2 +-
> >  net/ipv4/fib_frontend.c                       |  2 +-
> >  net/ipv4/fib_rules.c                          |  2 +-
> >  net/ipv4/icmp.c                               |  6 +++---
> >  net/ipv4/ip_gre.c                             |  2 +-
> >  net/ipv4/ip_output.c                          |  2 +-
> >  net/ipv4/ip_tunnel.c                          |  6 +++---
> >  net/ipv4/ipmr.c                               |  6 +++---
> >  net/ipv4/netfilter.c                          |  2 +-
> >  net/ipv4/netfilter/ipt_rpfilter.c             |  2 +-
> >  net/ipv4/netfilter/nf_dup_ipv4.c              |  2 +-
> >  net/ipv4/route.c                              | 20 +++++++++----------
> >  net/ipv6/ip6_output.c                         |  2 +-
> >  net/ipv6/ip6_tunnel.c                         |  4 ++--
> >  net/ipv6/sit.c                                |  4 ++--
> >  net/xfrm/xfrm_policy.c                        |  2 +-
> >  27 files changed, 49 insertions(+), 49 deletions(-)  
> 

