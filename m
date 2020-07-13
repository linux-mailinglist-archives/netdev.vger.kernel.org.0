Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD36321D94C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgGMO7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgGMO7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:59:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01514C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 07:59:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1juzvD-0000DW-Bb; Mon, 13 Jul 2020 16:59:11 +0200
Date:   Mon, 13 Jul 2020 16:59:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713145911.GN32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc>
 <a6821eac-82f8-0d9e-6388-ea6c9f5535d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6821eac-82f8-0d9e-6388-ea6c9f5535d1@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> On 7/13/20 8:02 AM, Florian Westphal wrote:
> > David Ahern <dsahern@gmail.com> wrote:
> >> On 7/13/20 2:04 AM, Florian Westphal wrote:
> >>>> As PMTU discovery happens, we have a route exception on the lower
> >>>> layer for the given path, and we know that VXLAN will use that path,
> >>>> so we also know there's no point in having a higher MTU on the VXLAN
> >>>> device, it's really the maximum packet size we can use.
> >>> No, in the setup that prompted this series the route exception is wrong.
> >>
> >> Why is the exception wrong and why can't the exception code be fixed to
> >> include tunnel headers?
> > 
> > I don't know.  This occurs in a 3rd party (read: "cloud") environment.
> > After some days, tcp connections on the overlay network hang.
> > 
> > Flushing the route exception in the namespace of the vxlan interface makes
> > the traffic flow again, i.e. if the vxlan tunnel would just use the
> > physical devices MTU things would be fine.
> > 
> > I don't know what you mean by 'fix exception code to include tunnel
> > headers'.  Can you elaborate?
> 
> lwtunnel has lwtunnel_headroom which allows ipv4_mtu to accommodate the
> space needed for the encap header. Can something similar be adapted for
> the device based tunnels?

I don't see how it would help for this particular problem.

> > AFAICS everyhing functions as designed, except:
> > 1. The route exception should not exist in first place in this case
> > 2. The route exception never times out (gets refreshed every time
> >    tunnel tries to send a mtu-sized packet).
> > 3. The original sender never learns about the pmtu event
> 
> meaning the VM / container? ie., this is a VPC using VxLAN in the host
> to send packets to another hypervisor. If that is the case why isn't the
> underlay MTU bumped to handle the encap header, or the VMs MTU lowered
> to handle the encap header? seems like a config problem.

Its configured properly:

ovs bridge mtu: 1450
vxlan device mtu: 1450
physical link: 1500

so, packets coming in on the bridge (local tx or from remote bridge port)
can have the enap header (50 bytes) prepended without exceeding the
physical link mtu.

When the vxlan driver calls the ip output path, this line:

        mtu = ip_skb_dst_mtu(sk, skb);

in __ip_finish_output() will fetch the MTU based of the encap socket,
which will now be 1450 due to that route exception.

So this will behave as if someone had lowered the physical link mtu to 1450:
IP stack drops the packet and sends an icmp error (fragmentation needed,
MTU 1450).  The MTU of the VXLAN port is already at 1450.

I could make a patch that lowers the vxlan port MTU to 1450 - 50 (encap
overhead) automatically, but I don't think making such change
automatically is a good idea.

With this proposed patch, the MTU retrieved would always be the link
MTU.

I don't think this patch is enough to resolve PMTU in general of course,
after all the VXLAN peer might be unable to receive packets larger than
what the ICMP error announces.  But I do not know how to resolve this
in the general case as everyone has a differnt opinion on how (and where)
this needs to be handled.
