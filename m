Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B7E225450
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgGSVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 17:50:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726126AbgGSVuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 17:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595195409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDEF6Cj4pYr1n6Xe9LuwSCULPVrLIRelaWhdO0CoIVw=;
        b=Zb17Thoni2OCE7+UybyPJza+oDNBL/EqaH2rIT9lTbyOTNdrCbpFx6gairjhyqmF9Iukbq
        SlDCj3Iwc95k7ZHsksmMTS90aAkahf48XJJefy5x3lPjwaSjbGhaeTLM+vNBuHAfMENKKg
        4zUq7uK+E+R2i3+EbJ8Dg0aD8FlnyvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-dOjWs-gzMKiUL5-0l_xh1w-1; Sun, 19 Jul 2020 17:49:53 -0400
X-MC-Unique: dOjWs-gzMKiUL5-0l_xh1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 602CC800597;
        Sun, 19 Jul 2020 21:49:52 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58AE072E45;
        Sun, 19 Jul 2020 21:49:49 +0000 (UTC)
Date:   Sun, 19 Jul 2020 23:49:40 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200719234940.37adebe7@elisabeth>
In-Reply-To: <dda364c6-3ac8-31a8-23b5-c337042b7d5d@gmail.com>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Jul 2020 12:43:55 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/18/20 11:58 AM, Stefano Brivio wrote:
> > On Sat, 18 Jul 2020 11:02:46 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> >   
> >> On 7/18/20 12:56 AM, Stefano Brivio wrote:  
> >>> On Fri, 17 Jul 2020 09:04:51 -0600
> >>> David Ahern <dsahern@gmail.com> wrote:
> >>>     
> >>>> On 7/17/20 6:27 AM, Stefano Brivio wrote:    
> >>>>>>      
> >>>>>>> Note that this doesn't work as it is because of a number of reasons
> >>>>>>> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
> >>>>>>> shouldn't be using icmp_send(), but at a glance that looks simpler.        
> >>>>>>
> >>>>>> Yes, it also requires that the bridge has IP connectivity
> >>>>>> to reach the inner ip, which might not be the case.      
> >>>>>
> >>>>> If the VXLAN endpoint is a port of the bridge, that needs to be the
> >>>>> case, right? Otherwise the VXLAN endpoint can't be reached.
> >>>>>       
> >>>>>>> Another slight preference I have towards this idea is that the only
> >>>>>>> known way we can break PMTU discovery right now is by using a bridge,
> >>>>>>> so fixing the problem there looks more future-proof than addressing any
> >>>>>>> kind of tunnel with this problem. I think FoU and GUE would hit the
> >>>>>>> same problem, I don't know about IP tunnels, sticking that selftest
> >>>>>>> snippet to whatever other test in pmtu.sh should tell.        
> >>>>>>
> >>>>>> Every type of bridge port that needs to add additional header on egress
> >>>>>> has this problem in the bridge scenario once the peer of the IP tunnel
> >>>>>> signals a PMTU event.      
> >>>>>
> >>>>> Yes :(    
> >>>>
> >>>> The vxlan/tunnel device knows it is a bridge port, and it knows it is
> >>>> going to push a udp and ip{v6} header. So why not use that information
> >>>> in setting / updating the MTU? That's what I was getting at on Monday
> >>>> with my comment about lwtunnel_headroom equivalent.    
> >>>
> >>> If I understand correctly, you're proposing something similar to my
> >>> earlier draft from:
> >>>
> >>> 	<20200713003813.01f2d5d3@elisabeth>
> >>> 	https://lore.kernel.org/netdev/20200713003813.01f2d5d3@elisabeth/
> >>>
> >>> the problem with it is that it wouldn't help: the MTU is already set to
> >>> the right value for both port and bridge in the case Florian originally
> >>> reported.    
> >>
> >> I am definitely hand waving; I have not had time to create a setup
> >> showing the problem. Is there a reproducer using only namespaces?  
> > 
> > And I'm laser pointing: check the bottom of that email ;)
> >   
> 
> With this test case, the lookup fails:
> 
> [  144.689378] vxlan: vxlan_xmit_one: dev vxlan_a 10.0.1.1/57864 ->
> 10.0.0.0/4789 len 5010 gw 10.0.1.2
> [  144.692755] vxlan: skb_tunnel_check_pmtu: dst dev br0 skb dev vxlan_a
> skb len 5010 encap_mtu 4000 headroom 50
> [  144.697682] vxlan: skb_dst_update_pmtu_no_confirm: calling
> ip_rt_update_pmtu+0x0/0x160/ffffffff825ee850 for dev br0 mtu 3950
> [  144.703601] IPv4: __ip_rt_update_pmtu: dev br0 mtu 3950 old_mtu 5000
> 192.168.2.1 -> 192.168.2.2
> [  144.708177] IPv4: __ip_rt_update_pmtu: fib_lookup failed for
> 192.168.2.1 -> 192.168.2.2
> 
> Because the lookup fails, __ip_rt_update_pmtu skips creating the exception.
> 
> This hack gets the lookup to succeed:
> 
> fl4->flowi4_oif = dst->dev->ifindex;
> or
> fl4->flowi4_oif = 0;

Oh, I didn't consider that... route. :) Here comes an added twist, which
currently needs Florian's changes from:
	https://git.breakpoint.cc/cgit/fw/net-next.git/log/?h=udp_tun_pmtud_12

Test is as follows:

test_pmtu_ipv4_vxlan4_exception_bridge() {
	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception vxlan  4 4

	ip netns add ns-C

	ip -n ns-C link add veth_c_a type veth peer name veth_a_c
	ip -n ns-C link set veth_a_c netns ns-A

	ip -n ns-C addr add 192.168.2.100/24 dev veth_c

	ip -n ns-C link set dev veth_c_a mtu 5000
	ip -n ns-C link set veth_c_a up
	ip -n ns-A link set dev veth_a_c mtu 5000
	ip -n ns-A link set veth_c_a up

	ip -n ns-A link add br0 type bridge
	ip -n ns-A link set br0 up
	ip -n ns-A link set dev br0 mtu 5000
	ip -n ns-A link set veth_a_c master br0
	ip -n ns-A link set vxlan_a master br0

	ip -n ns-A addr del 192.168.2.1/24 dev vxlan_a
	ip -n ns-A addr add 192.168.2.1/24 dev br0

	ip -n ns-C exec ping -c 1 -w 2 -M want -s 5000 192.168.2.2
}

I didn't check the test itself recently, I'm just copying from some
local changes I was trying last week, some commands might be wrong.

The idea is: what if we now have another host (here, it's ns-C) sending
traffic to that bridge? Then the exception on a local interface isn't
enough, we actually need to send Fragmentation Needed back to where the
packet came from, and the bridge won't do it for us (with routing, it
already works).

I haven't tried your hack, but I guess it would have the same problem.

-- 
Stefano

