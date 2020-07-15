Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75499220F68
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgGOOd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgGOOd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 10:33:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1BFC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 07:33:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jviTs-00027q-Bn; Wed, 15 Jul 2020 16:33:56 +0200
Date:   Wed, 15 Jul 2020 16:33:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org, aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200715143356.GQ32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc>
 <20200714143327.2d5b8581@redhat.com>
 <20200715124258.GP32005@breakpoint.cc>
 <20200715153547.77dbaf82@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715153547.77dbaf82@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> On Wed, 15 Jul 2020 14:42:58 +0200
> Florian Westphal <fw@strlen.de> wrote:
> > With your skeleton patch, br0 updates MTU, but the sender still
> > won't know that unless input traffic to br0 is routed (or locally
> > generated).
> 
> To let the sender know, I still think it's a bit simpler with this
> approach, we don't have to do all the peeling. In br_handle_frame(), we
> would need to add *something like*:
> 
> 	if (skb->len > p->br->dev->mtu) {
> 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
> 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
> 			  htonl(p->br->dev->mtu));
> 		goto drop;
> 	}
> 
> just like IP tunnels do, see tnl_update_pmtu().

Yes, but the caveat here is that a bridge might be transporting
non-IP protocol too.

So, MTU-reduction+ICMP won't help for them.
I would try to avoid mixing IP functionality into the bridge,
its a slippery slope (look at bridge netfilter for an example).

I agree that for a 'ip only' bridge that might work indeed.

> Note that this doesn't work as it is because of a number of reasons
> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
> shouldn't be using icmp_send(), but at a glance that looks simpler.

Yes, it also requires that the bridge has IP connectivity
to reach the inner ip, which might not be the case.

> Another slight preference I have towards this idea is that the only
> known way we can break PMTU discovery right now is by using a bridge,
> so fixing the problem there looks more future-proof than addressing any
> kind of tunnel with this problem. I think FoU and GUE would hit the
> same problem, I don't know about IP tunnels, sticking that selftest
> snippet to whatever other test in pmtu.sh should tell.

Every type of bridge port that needs to add additional header on egress
has this problem in the bridge scenario once the peer of the IP tunnel
signals a PMTU event.

I agree that excess copy&paste should be avoided, but at this point
I don't see an easy solution.

> I might be wrong of course as I haven't tried to implement this bit,
> and if this turns out to be just moving the problem without making it
> simpler, then sure, I'd rather stick to your approach.
> 
> > Furthermore, such MTU reduction would require a mechanism to
> > auto-reconfig every device in the same linklevel broadcast domain,
> > and I am not aware of any such mechanism.
> 
> You mean for other ports connected to the same bridge? They would then
> get ICMP errors as well, no?

Yes, if you don't do that then we have devices with MTU X hooked to
a bridge with MTU Y, where X > Y.  I don't see how this could work.

> If you refer to other drivers that need to adjust the MTU, instead,
> that's why I would use skb_tunnel_check_pmtu() for that, to avoid
> implementing the same logic in every driver.

Yes, it might be possible to move the proposed icmp inject into
skb_tunnel_check_pmtu() -- it gets the needed headroom passed as arg,
it could detect when device driver is in a bridge and it already knows
when skb has no dst entry that it a pmtu change could be propagated to.

Given the affected setups all use ovs I think it makes sense to make
sure the intended solution would work for ovs too, bridge seems more
like a nice-to-have thing at the moment.
