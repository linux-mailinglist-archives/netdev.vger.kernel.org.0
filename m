Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0821DB9E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbgGMQW6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Jul 2020 12:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730050AbgGMQW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:22:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7441C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:22:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jv1EF-0000tB-UM; Mon, 13 Jul 2020 18:22:55 +0200
Date:   Mon, 13 Jul 2020 18:22:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org, aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713162255.GO32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc>
 <a6821eac-82f8-0d9e-6388-ea6c9f5535d1@gmail.com>
 <20200713145911.GN32005@breakpoint.cc>
 <20200713175709.2a547d7c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200713175709.2a547d7c@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> > so, packets coming in on the bridge (local tx or from remote bridge port)
> > can have the enap header (50 bytes) prepended without exceeding the
> > physical link mtu.
> > 
> > When the vxlan driver calls the ip output path, this line:
> > 
> >         mtu = ip_skb_dst_mtu(sk, skb);
> > 
> > in __ip_finish_output() will fetch the MTU based of the encap socket,
> > which will now be 1450 due to that route exception.
> > 
> > So this will behave as if someone had lowered the physical link mtu to 1450:
> > IP stack drops the packet and sends an icmp error (fragmentation needed,
> > MTU 1450).  The MTU of the VXLAN port is already at 1450.
> 
> It's not clear to me why the behaviour on this path is different from
> routed traffic. I understand the impact of bridged traffic on error
> reporting, but not here.

In routing case:
1. pmtu notification is received
2. route exception is added
3. next MTU-sized packet in vxlan triggers the if () condition in
   skb_tunnel_check_pmtu()
4. skb_dst_update_pmtu() gets called, new nexthop exception is added
5. packet is dropped in ip_output (too large)
6. next MTU-sized packet to be forwarded triggers PMTU check in
   ip_forward()
7. ip_forward drops packet and sends an icmp error for new mtu (1400 in
    the example)
8. sender receives+updates path mtu
9. next packet will be small enough

In Bridge case, 4) is a noop and even if we had dst entries here,
we do not enter ip_forward path for bridged case.

> Does it have something to do with metadata-based tunnels?

No.

> Should we omit
> the call to skb_tunnel_check_pmtu() call in vxlan_xmit_one() in that
> case (if (info)) because the dst is not the same dst?

skb_dst_update_pmtu is already omitted in this scenario since dst is NULL.

> > I don't think this patch is enough to resolve PMTU in general of course,
> > after all the VXLAN peer might be unable to receive packets larger than
> > what the ICMP error announces.  But I do not know how to resolve this
> > in the general case as everyone has a differnt opinion on how (and where)
> > this needs to be handled.
> 
> The sender here is sending packets matching the MTU, interface MTUs are
> correct, so we wouldn't benefit from "extending" PMTU discovery for
> this specific problem and we can let that topic aside for now, correct?

Yes and no.  What the hack patches (not this series, the icmp error
injection series for bridge...) does is to inject a new icmp error from
the vxlan icmp error processing callback that will report an MTU of
'received mtu - vxlan_overhead' to the sender.

So, the sender receives a PMTU update for 1400 in the given scenario.

Its not nice of course, as sender emitted a MTU-sized packet (1450)
to an on-link destination, only to be told by that *alleged* on-link
destination (address spoofed by bridge) that it needs to use 1400.

I don't see any better solution, since netdev police failed to make
such setups illegal 8)
