Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D77522496C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 08:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgGRG5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 02:57:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725983AbgGRG5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 02:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595055423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTVXVg9Iy+utNHgyi7qKG5POUJGJ+x1yg1zUk4MRTvw=;
        b=ih3CgzGRYb9bS47A6+YEr4sBheN31gbey7e17gjhU/8CXjPlU1TcFvEuDBmv2RmmoSxDeg
        QVlAWuC5Hi94QjPKQElMlILKCGrY0qMkUpA9DzWe1mFF8Uq56odZU/fxTEaoBu8QwaL3Jj
        /JKf3yU9ySvrj0C9lhD0wBBOR4ZUSz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-qFMDtgYrM5qwpIxiqOm5gw-1; Sat, 18 Jul 2020 02:56:57 -0400
X-MC-Unique: qFMDtgYrM5qwpIxiqOm5gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BCD7107ACCA;
        Sat, 18 Jul 2020 06:56:56 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B86060E3E;
        Sat, 18 Jul 2020 06:56:51 +0000 (UTC)
Date:   Sat, 18 Jul 2020 08:56:45 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200718085645.7420da02@elisabeth>
In-Reply-To: <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
        <20200713140219.GM32005@breakpoint.cc>
        <20200714143327.2d5b8581@redhat.com>
        <20200715124258.GP32005@breakpoint.cc>
        <20200715153547.77dbaf82@elisabeth>
        <20200715143356.GQ32005@breakpoint.cc>
        <20200717142743.6d05d3ae@elisabeth>
        <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 09:04:51 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/17/20 6:27 AM, Stefano Brivio wrote:
> >>  
> >>> Note that this doesn't work as it is because of a number of reasons
> >>> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
> >>> shouldn't be using icmp_send(), but at a glance that looks simpler.    
> >>
> >> Yes, it also requires that the bridge has IP connectivity
> >> to reach the inner ip, which might not be the case.  
> > 
> > If the VXLAN endpoint is a port of the bridge, that needs to be the
> > case, right? Otherwise the VXLAN endpoint can't be reached.
> >   
> >>> Another slight preference I have towards this idea is that the only
> >>> known way we can break PMTU discovery right now is by using a bridge,
> >>> so fixing the problem there looks more future-proof than addressing any
> >>> kind of tunnel with this problem. I think FoU and GUE would hit the
> >>> same problem, I don't know about IP tunnels, sticking that selftest
> >>> snippet to whatever other test in pmtu.sh should tell.    
> >>
> >> Every type of bridge port that needs to add additional header on egress
> >> has this problem in the bridge scenario once the peer of the IP tunnel
> >> signals a PMTU event.  
> > 
> > Yes :(
> 
> The vxlan/tunnel device knows it is a bridge port, and it knows it is
> going to push a udp and ip{v6} header. So why not use that information
> in setting / updating the MTU? That's what I was getting at on Monday
> with my comment about lwtunnel_headroom equivalent.

If I understand correctly, you're proposing something similar to my
earlier draft from:

	<20200713003813.01f2d5d3@elisabeth>
	https://lore.kernel.org/netdev/20200713003813.01f2d5d3@elisabeth/

the problem with it is that it wouldn't help: the MTU is already set to
the right value for both port and bridge in the case Florian originally
reported.

Also, given the implications on overriding configured MTUs, and
introducing (further) IP logic into the bridge, if Florian's idea of
injecting ICMP messages could be implemented in a generic function:

On Wed, 15 Jul 2020 16:33:56 +0200
Florian Westphal <fw@strlen.de> wrote:

> Yes, it might be possible to move the proposed icmp inject into
> skb_tunnel_check_pmtu() -- it gets the needed headroom passed as arg,
> it could detect when device driver is in a bridge and it already knows
> when skb has no dst entry that it a pmtu change could be propagated to.

I think that would be preferable: then it's fixed for all tunnels in a
generic, probably simpler way, without those two issues.

But then again, we're talking about Linux bridge. Unfortunately this
doesn't fix the problem with Open vSwitch either.

-- 
Stefano

