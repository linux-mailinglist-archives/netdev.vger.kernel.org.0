Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AFB2C89F0
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgK3QwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgK3QwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 11:52:12 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1C982073C;
        Mon, 30 Nov 2020 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606755092;
        bh=v0BlTFEvoneGaKk6HVhjN8sdc7izbYsibGUaPrdoVrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtv5o57QQEkSa8cQ/tsCPxsztHKeqCyxT2sc1JRauCgv/wJRw7ox4sMI0cv3ut/LJ
         eycSt5XvDBAZSxld3TJ/1MnGVruMB6mL8FQEOY3iN5W1qHcixIGJjVaer+wR9aXNHF
         t2GflJBkK4VtpOP2PaEzda5IN5vULB0WWKSC4FH0=
Date:   Mon, 30 Nov 2020 08:51:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net] ipv4: Fix tos mask in inet_rtm_getroute()
Message-ID: <20201130085130.61498967@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201129125416.GA28479@linux.home>
References: <b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com>
        <ace2daed-7d88-7364-5395-80b63f59ffc1@gmail.com>
        <20201128131716.783ff3dd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201129125416.GA28479@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020 13:54:16 +0100 Guillaume Nault wrote:
> On Sat, Nov 28, 2020 at 01:17:16PM -0800, Jakub Kicinski wrote:
> > On Sat, 28 Nov 2020 10:03:42 -0700 David Ahern wrote:  
> > > On 11/26/20 11:09 AM, Guillaume Nault wrote:  
> > > > When inet_rtm_getroute() was converted to use the RCU variants of
> > > > ip_route_input() and ip_route_output_key(), the TOS parameters
> > > > stopped being masked with IPTOS_RT_MASK before doing the route lookup.
> > > > 
> > > > As a result, "ip route get" can return a different route than what
> > > > would be used when sending real packets.
> > > > 
> > > > For example:
> > > > 
> > > >     $ ip route add 192.0.2.11/32 dev eth0
> > > >     $ ip route add unreachable 192.0.2.11/32 tos 2
> > > >     $ ip route get 192.0.2.11 tos 2
> > > >     RTNETLINK answers: No route to host
> > > > 
> > > > But, packets with TOS 2 (ECT(0) if interpreted as an ECN bit) would
> > > > actually be routed using the first route:
> > > > 
> > > >     $ ping -c 1 -Q 2 192.0.2.11
> > > >     PING 192.0.2.11 (192.0.2.11) 56(84) bytes of data.
> > > >     64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.173 ms
> > > > 
> > > >     --- 192.0.2.11 ping statistics ---
> > > >     1 packets transmitted, 1 received, 0% packet loss, time 0ms
> > > >     rtt min/avg/max/mdev = 0.173/0.173/0.173/0.000 ms
> > > > 
> > > > This patch re-applies IPTOS_RT_MASK in inet_rtm_getroute(), to
> > > > return results consistent with real route lookups.
> > > > 
> > > > Fixes: 3765d35ed8b9 ("net: ipv4: Convert inet_rtm_getroute to rcu versions of route lookup")
> > > > Signed-off-by: Guillaume Nault <gnault@redhat.com>  
> > > 
> > > Reviewed-by: David Ahern <dsahern@kernel.org>  
> > 
> > Applied, thanks!
> > 
> > Should the discrepancy between the behavior of ip_route_input_rcu() and
> > ip_route_input() be addressed, possibly?  
> 
> Do you mean masking TOS with IPTOS_RT_MASK directly in
> ip_route_input_rcu(), instead of in the callers?
> 
> After this patch, all callers apply IPTOS_RT_MASK before calling
> ip_route_input_rcu(). So, yes, that could be easily consolidated there,
> and I'll do that after net merges into net-next.
> 
> More generally, my long term plan is indeed to do mask the TOS in
> central places, to get consistent behaviour across the networking
> stack. However, generally speaking, I need to be careful not to break
> any established behaviour.
> 
> I'm mostly worried about the ECN bits. I guess that any caller that
> doesn't mask these bits has a bug (as that may break ECN, which is
> there since a long time). However, there are many code paths to audit
> before we can be sure.
> 
> The end goal is to fully support DSCP. Once we'll be sure that no
> code path can possibly intreprete an ECN bit as TOS, we'll can safely
> drop all those obsolete TOS* masks and macros from the kernel code and
> simply mask out the ECN bits (thus preserving the whole DSCP space).

Sounds great!

> Please note that this is background work for me. Expect slow (but
> hopefully regular) progress from me.
