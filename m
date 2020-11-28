Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB72C733A
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgK1VuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387791AbgK1VR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 16:17:58 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5ADA221FF;
        Sat, 28 Nov 2020 21:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606598237;
        bh=SKKV1Tz7EggOH0FDIuGQNzy+NEOrJQ/6ekMt5C92Djc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eBp3163ONGuQq6bQ+rqsMpjZs5d4pdyBIDH43GwT4y0oTq39SHUbUxZJ+DxqvmkyB
         nFTINTwcGt1TUireFCo/buSTj93ejJPqtYKFm3+I2HedllBUVsVBwt4czNEwL6BdP6
         7lV2DN/EkykGHyGEPyP1tOpOdkmJ4IYkoIYAXttk=
Date:   Sat, 28 Nov 2020 13:17:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net] ipv4: Fix tos mask in inet_rtm_getroute()
Message-ID: <20201128131716.783ff3dd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <ace2daed-7d88-7364-5395-80b63f59ffc1@gmail.com>
References: <b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com>
        <ace2daed-7d88-7364-5395-80b63f59ffc1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 10:03:42 -0700 David Ahern wrote:
> On 11/26/20 11:09 AM, Guillaume Nault wrote:
> > When inet_rtm_getroute() was converted to use the RCU variants of
> > ip_route_input() and ip_route_output_key(), the TOS parameters
> > stopped being masked with IPTOS_RT_MASK before doing the route lookup.
> > 
> > As a result, "ip route get" can return a different route than what
> > would be used when sending real packets.
> > 
> > For example:
> > 
> >     $ ip route add 192.0.2.11/32 dev eth0
> >     $ ip route add unreachable 192.0.2.11/32 tos 2
> >     $ ip route get 192.0.2.11 tos 2
> >     RTNETLINK answers: No route to host
> > 
> > But, packets with TOS 2 (ECT(0) if interpreted as an ECN bit) would
> > actually be routed using the first route:
> > 
> >     $ ping -c 1 -Q 2 192.0.2.11
> >     PING 192.0.2.11 (192.0.2.11) 56(84) bytes of data.
> >     64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.173 ms
> > 
> >     --- 192.0.2.11 ping statistics ---
> >     1 packets transmitted, 1 received, 0% packet loss, time 0ms
> >     rtt min/avg/max/mdev = 0.173/0.173/0.173/0.000 ms
> > 
> > This patch re-applies IPTOS_RT_MASK in inet_rtm_getroute(), to
> > return results consistent with real route lookups.
> > 
> > Fixes: 3765d35ed8b9 ("net: ipv4: Convert inet_rtm_getroute to rcu versions of route lookup")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!

Should the discrepancy between the behavior of ip_route_input_rcu() and
ip_route_input() be addressed, possibly? 
