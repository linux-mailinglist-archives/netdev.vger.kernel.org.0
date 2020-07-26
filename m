Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D463F22E18A
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 19:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGZRCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 13:02:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38492 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726117AbgGZRCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 13:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595782950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q4PSV4GeGBjCn5FsDdwn0t3kpi998oH57DHP0BLkxWw=;
        b=UNZ5R97spH4BYKoktDD9LooGWC8TOvwNLwMeb5b67V8F3PsmYAWOAf2RAmo9PnkDnfkMRv
        7fdGb6JOS4NfZi7oIMNRweRB+ZcVQ1Mu/nKZj64UpAI/+6kiEm/wvJGAP9+6JTvrBdFRlg
        hEKxwOvNMoOhE6n+lSNeVBdUwXAM/tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129--iMjGbg8PtuwOEjWhAq1qg-1; Sun, 26 Jul 2020 13:02:15 -0400
X-MC-Unique: -iMjGbg8PtuwOEjWhAq1qg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E62DF800688;
        Sun, 26 Jul 2020 17:02:13 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F5385F21F;
        Sun, 26 Jul 2020 17:02:11 +0000 (UTC)
Date:   Sun, 26 Jul 2020 19:01:54 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200726190154.3f6e5134@elisabeth>
In-Reply-To: <5d5deb1f-0a7f-1519-4716-6a92aec40bd2@gmail.com>
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
        <20200718085645.7420da02@elisabeth>
        <9e47f521-b3dc-f116-658b-d6897b0ddf20@gmail.com>
        <20200718195850.61104dd2@elisabeth>
        <dda364c6-3ac8-31a8-23b5-c337042b7d5d@gmail.com>
        <20200719234940.37adebe7@elisabeth>
        <5d5deb1f-0a7f-1519-4716-6a92aec40bd2@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Jul 2020 21:19:44 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/19/20 3:49 PM, Stefano Brivio wrote:
> >>
> >> With this test case, the lookup fails:
> >>
> >> [  144.689378] vxlan: vxlan_xmit_one: dev vxlan_a 10.0.1.1/57864 ->
> >> 10.0.0.0/4789 len 5010 gw 10.0.1.2
> >> [  144.692755] vxlan: skb_tunnel_check_pmtu: dst dev br0 skb dev vxlan_a
> >> skb len 5010 encap_mtu 4000 headroom 50
> >> [  144.697682] vxlan: skb_dst_update_pmtu_no_confirm: calling
> >> ip_rt_update_pmtu+0x0/0x160/ffffffff825ee850 for dev br0 mtu 3950
> >> [  144.703601] IPv4: __ip_rt_update_pmtu: dev br0 mtu 3950 old_mtu 5000
> >> 192.168.2.1 -> 192.168.2.2
> >> [  144.708177] IPv4: __ip_rt_update_pmtu: fib_lookup failed for
> >> 192.168.2.1 -> 192.168.2.2
> >>
> >> Because the lookup fails, __ip_rt_update_pmtu skips creating the exception.
> >>
> >> This hack gets the lookup to succeed:
> >>
> >> fl4->flowi4_oif = dst->dev->ifindex;
> >> or
> >> fl4->flowi4_oif = 0;  
> > 
> > Oh, I didn't consider that... route. :) Here comes an added twist, which
> > currently needs Florian's changes from:
> > 	https://git.breakpoint.cc/cgit/fw/net-next.git/log/?h=udp_tun_pmtud_12
> > 
> > Test is as follows:
> > 
> > test_pmtu_ipv4_vxlan4_exception_bridge() {
> > 	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception vxlan  4 4
> > 
> > 	ip netns add ns-C
> > 
> > 	ip -n ns-C link add veth_c_a type veth peer name veth_a_c
> > 	ip -n ns-C link set veth_a_c netns ns-A
> > 
> > 	ip -n ns-C addr add 192.168.2.100/24 dev veth_c
> > 
> > 	ip -n ns-C link set dev veth_c_a mtu 5000
> > 	ip -n ns-C link set veth_c_a up
> > 	ip -n ns-A link set dev veth_a_c mtu 5000
> > 	ip -n ns-A link set veth_c_a up
> > 
> > 	ip -n ns-A link add br0 type bridge
> > 	ip -n ns-A link set br0 up
> > 	ip -n ns-A link set dev br0 mtu 5000
> > 	ip -n ns-A link set veth_a_c master br0
> > 	ip -n ns-A link set vxlan_a master br0
> > 
> > 	ip -n ns-A addr del 192.168.2.1/24 dev vxlan_a
> > 	ip -n ns-A addr add 192.168.2.1/24 dev br0
> > 
> > 	ip -n ns-C exec ping -c 1 -w 2 -M want -s 5000 192.168.2.2
> > }
> > 
> > I didn't check the test itself recently, I'm just copying from some
> > local changes I was trying last week, some commands might be wrong.  
> 
> I fixed the exec typo, but yes even with my flowi4_oif hack it fails.
> 
> > 
> > The idea is: what if we now have another host (here, it's ns-C) sending
> > traffic to that bridge? Then the exception on a local interface isn't
> > enough, we actually need to send Fragmentation Needed back to where the
> > packet came from, and the bridge won't do it for us (with routing, it
> > already works).
> > 
> > I haven't tried your hack, but I guess it would have the same problem.
> >   
> 
> What I saw in my tests and debug statements is that vxlan xmit does
> compensate for the tunnel overhead (e.g., skb_tunnel_check_pmtu in
> vxlan_xmit_one). It still feels like there are some minor details that
> are wrong - like the fib_lookup failing when called from the
> vxlan_xmit_one path. Does finding and fixing those make it work vs
> adding another config item? I can send my debug diff if it helps.

Sorry, I forgot to answer this: I don't think so.

With your hack you can create an exception on the bridge, which fixes
the local bridge case, but if you add another node, the exception on
the local bridge doesn't help (Florian explained why in better detail),
nothing will be sent to the sender. The ICMP message is sent to the
sender in the routed case because of IP forwarding, but it won't work
here.

On top of your hack, we could now tell the bridge to send an ICMP
message if the packet is too big for the destination. The destination
isn't there, though -- finding it means building quite some IP logic
into the bridge.

The most logical thing to do, to me, seems to stick with Florian's
approach (tunnel implementation sending ICMP to the IP sender, as it
logically represents a part of the router forwarding implementation,
and it implies adjusted MTU) and try to expose that functionality in a
generic function. I'll try in a bit.

-- 
Stefano

