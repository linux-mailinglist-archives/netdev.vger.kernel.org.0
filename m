Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549EF223B5D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGQM2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:28:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726056AbgGQM2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 08:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594988889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9VptYIcHjd8g/lwaqmm7CWe7E022P/W0I2N017WoIw=;
        b=Vdh8wbpPn0WScxHr4WyEfGARwQIxrqLSYo8Q/pad8NkDNSO17RJhh1Rkn4Dw42+KmC3/MB
        zJ0j+UbOJGO+B3Knn4l5eddN5guM8cik4/cdC8DPPIDVjocrXp4zSKCncf8mKRklxjrX0c
        IE5ahiC4gp+jgyNNto3c1MgJwYqnNLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-wI1UCqOCNqKlqV3Yi0DAkA-1; Fri, 17 Jul 2020 08:28:05 -0400
X-MC-Unique: wI1UCqOCNqKlqV3Yi0DAkA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2FDB800463;
        Fri, 17 Jul 2020 12:28:04 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 785A219C58;
        Fri, 17 Jul 2020 12:28:01 +0000 (UTC)
Date:   Fri, 17 Jul 2020 14:27:43 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200717142743.6d05d3ae@elisabeth>
In-Reply-To: <20200715143356.GQ32005@breakpoint.cc>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 16:33:56 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > On Wed, 15 Jul 2020 14:42:58 +0200
> > Florian Westphal <fw@strlen.de> wrote:  
> > > With your skeleton patch, br0 updates MTU, but the sender still
> > > won't know that unless input traffic to br0 is routed (or locally
> > > generated).  
> > 
> > To let the sender know, I still think it's a bit simpler with this
> > approach, we don't have to do all the peeling. In br_handle_frame(), we
> > would need to add *something like*:
> > 
> > 	if (skb->len > p->br->dev->mtu) {
> > 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
> > 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
> > 			  htonl(p->br->dev->mtu));
> > 		goto drop;
> > 	}
> > 
> > just like IP tunnels do, see tnl_update_pmtu().  
> 
> Yes, but the caveat here is that a bridge might be transporting
> non-IP protocol too.
> 
> So, MTU-reduction+ICMP won't help for them.

Well, it doesn't need to, PMTU discovery is only implemented for IP,
so, to handle this, we can just check if the frame contains an IP
packet. The kind of check (skb->protocol == htons(ETH_P_...)) is
already there on all sorts of paths in the bridge.

However,

> I would try to avoid mixing IP functionality into the bridge,

if we stick to the fact the bridge is a L2 device, sure, we should drop
packets silently. The problem is that bridging an UDP tunnel forces the
combination to become a router.

So, either we forbid that, or I guess it's acceptable to have (even
further) L3 functionality implemented in the bridge.

> its a slippery slope (look at bridge netfilter for an example).

Oops, I was taking it as a positive example :)

> I agree that for a 'ip only' bridge that might work indeed.
> 
> > Note that this doesn't work as it is because of a number of reasons
> > (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
> > shouldn't be using icmp_send(), but at a glance that looks simpler.  
> 
> Yes, it also requires that the bridge has IP connectivity
> to reach the inner ip, which might not be the case.

If the VXLAN endpoint is a port of the bridge, that needs to be the
case, right? Otherwise the VXLAN endpoint can't be reached.

> > Another slight preference I have towards this idea is that the only
> > known way we can break PMTU discovery right now is by using a bridge,
> > so fixing the problem there looks more future-proof than addressing any
> > kind of tunnel with this problem. I think FoU and GUE would hit the
> > same problem, I don't know about IP tunnels, sticking that selftest
> > snippet to whatever other test in pmtu.sh should tell.  
> 
> Every type of bridge port that needs to add additional header on egress
> has this problem in the bridge scenario once the peer of the IP tunnel
> signals a PMTU event.

Yes :(

> I agree that excess copy&paste should be avoided, but at this point
> I don't see an easy solution.

I think what you mention below is way more acceptable.

> > I might be wrong of course as I haven't tried to implement this bit,
> > and if this turns out to be just moving the problem without making it
> > simpler, then sure, I'd rather stick to your approach.
> >   
> > > Furthermore, such MTU reduction would require a mechanism to
> > > auto-reconfig every device in the same linklevel broadcast domain,
> > > and I am not aware of any such mechanism.  
> > 
> > You mean for other ports connected to the same bridge? They would then
> > get ICMP errors as well, no?  
> 
> Yes, if you don't do that then we have devices with MTU X hooked to
> a bridge with MTU Y, where X > Y.  I don't see how this could work.

Yes, I see, and my point is: they would get ICMP errors from the
bridge, and that would create route exceptions.

> > If you refer to other drivers that need to adjust the MTU, instead,
> > that's why I would use skb_tunnel_check_pmtu() for that, to avoid
> > implementing the same logic in every driver.  
> 
> Yes, it might be possible to move the proposed icmp inject into
> skb_tunnel_check_pmtu() -- it gets the needed headroom passed as arg,
> it could detect when device driver is in a bridge and it already knows
> when skb has no dst entry that it a pmtu change could be propagated to.

I didn't mean to move the ICMP injection there, I meant we could
override the MTU there.

Moving the ICMP injection there: I think that would be totally
reasonable, it comes with none of the issues of the solution I proposed
and with almost none of the issues I raised about your idea.

> Given the affected setups all use ovs I think it makes sense to make
> sure the intended solution would work for ovs too, bridge seems more
> like a nice-to-have thing at the moment.

Yes, agreed.

As I see it, we don't know what the problem is there, we might even
have to do absolutely nothing in kernel. I guess we should know before
trying to hack up something.

-- 
Stefano

