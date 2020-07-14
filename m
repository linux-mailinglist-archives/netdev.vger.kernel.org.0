Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38DF21F157
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgGNMd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:33:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726955AbgGNMdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594730003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C63dF9gfSHVApzJ/jLL1WN7IQ6LQXyPx+6cv2jYh+SQ=;
        b=Kqs+eAoBFrQxlbfH7FvDV/ByzCJ+ek0lmoiKzIkOXXk61bUJNvMUGu3F/2czwg4jm6koDJ
        c7BOlWJ91yTd3+di3iafk+85B2hNHUFRz/W1YtZbbKjrL2t2zZpZNQsgP8AvPfIEs+k7xn
        1++azQylbfHJeZwSZDytL0QJiS0I0lc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-zSUdgSAUOSi9PZsJPeIskw-1; Tue, 14 Jul 2020 08:33:19 -0400
X-MC-Unique: zSUdgSAUOSi9PZsJPeIskw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815418014D4;
        Tue, 14 Jul 2020 12:33:18 +0000 (UTC)
Received: from localhost (unknown [10.36.110.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D00CE61983;
        Tue, 14 Jul 2020 12:33:15 +0000 (UTC)
Date:   Tue, 14 Jul 2020 14:33:11 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200714143311.0ce8edaa@redhat.com>
In-Reply-To: <20200713162255.GO32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
        <20200713140219.GM32005@breakpoint.cc>
        <a6821eac-82f8-0d9e-6388-ea6c9f5535d1@gmail.com>
        <20200713145911.GN32005@breakpoint.cc>
        <20200713175709.2a547d7c@redhat.com>
        <20200713162255.GO32005@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 18:22:55 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > > so, packets coming in on the bridge (local tx or from remote bridge port)
> > > can have the enap header (50 bytes) prepended without exceeding the
> > > physical link mtu.
> > > 
> > > When the vxlan driver calls the ip output path, this line:
> > > 
> > >         mtu = ip_skb_dst_mtu(sk, skb);
> > > 
> > > in __ip_finish_output() will fetch the MTU based of the encap socket,
> > > which will now be 1450 due to that route exception.
> > > 
> > > So this will behave as if someone had lowered the physical link mtu to 1450:
> > > IP stack drops the packet and sends an icmp error (fragmentation needed,
> > > MTU 1450).  The MTU of the VXLAN port is already at 1450.  
> > 
> > It's not clear to me why the behaviour on this path is different from
> > routed traffic. I understand the impact of bridged traffic on error
> > reporting, but not here.  
> 
> In routing case:
> 1. pmtu notification is received
> 2. route exception is added
> 3. next MTU-sized packet in vxlan triggers the if () condition in
>    skb_tunnel_check_pmtu()
> 4. skb_dst_update_pmtu() gets called, new nexthop exception is added
> 5. packet is dropped in ip_output (too large)
> 6. next MTU-sized packet to be forwarded triggers PMTU check in
>    ip_forward()
> 7. ip_forward drops packet and sends an icmp error for new mtu (1400 in
>     the example)
> 8. sender receives+updates path mtu
> 9. next packet will be small enough

I'm not sure it changes the conclusion or if it affects your problem in
any way, but what I see in the routing case is a bit different.

Running the pmtu_ipv4_vxlan4_exception test from pmtu.sh with 1500 as
lowest MTU on the path shows effectively a MTU of 1450 on the link
(1424 bytes of inner IP payload in the first packet going through,
inner IPv4 total length being 1444).

That's because we already relay an ICMP Fragmentation Needed at step 5,
and in the next step the packet is small enough.

> In Bridge case, 4) is a noop and even if we had dst entries here,
> we do not enter ip_forward path for bridged case.

Also not in my test, because:

> [...]
>
> > Should we omit
> > the call to skb_tunnel_check_pmtu() call in vxlan_xmit_one() in that
> > case (if (info)) because the dst is not the same dst?  
> 
> skb_dst_update_pmtu is already omitted in this scenario since dst is NULL.

...skb_dst_update_pmtu(), there, is called with 'ndst' (dst for the
route returned by vxlan_get_route()), not skb->dst. But yes, as you
mentioned, we don't hit ip_forward(), so that doesn't matter.

The original problem remains, and unless we find another explanation
I'd go ahead and start reviewing this series, FWIW.

> > > I don't think this patch is enough to resolve PMTU in general of course,
> > > after all the VXLAN peer might be unable to receive packets larger than
> > > what the ICMP error announces.  But I do not know how to resolve this
> > > in the general case as everyone has a differnt opinion on how (and where)
> > > this needs to be handled.  
> > 
> > The sender here is sending packets matching the MTU, interface MTUs are
> > correct, so we wouldn't benefit from "extending" PMTU discovery for
> > this specific problem and we can let that topic aside for now, correct?  
> 
> Yes and no.  What the hack patches (not this series, the icmp error
> injection series for bridge...) does is to inject a new icmp error from
> the vxlan icmp error processing callback that will report an MTU of
> 'received mtu - vxlan_overhead' to the sender.

Okay, I see.

> So, the sender receives a PMTU update for 1400 in the given scenario.
> 
> Its not nice of course, as sender emitted a MTU-sized packet (1450)
> to an on-link destination, only to be told by that *alleged* on-link
> destination (address spoofed by bridge) that it needs to use 1400.

Still, I don't think that we should use 1400, assuming that 1450 is in
fact the right value.

> I don't see any better solution, since netdev police failed to make
> such setups illegal 8)

I'll file a complaint :)

-- 
Stefano

