Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD5421D150
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgGMIEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGMIEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 04:04:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98626C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 01:04:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jutRd-00064J-2f; Mon, 13 Jul 2020 10:04:13 +0200
Date:   Mon, 13 Jul 2020 10:04:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713080413.GL32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713003813.01f2d5d3@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> Hi,
> 
> On Sun, 12 Jul 2020 22:07:03 +0200
> Florian Westphal <fw@strlen.de> wrote:
> 
> > vxlan and geneve take the to-be-transmitted skb, prepend the
> > encapsulation header and send the result.
> > 
> > Neither vxlan nor geneve can do anything about a lowered path mtu
> > except notifying the peer/upper dst entry.
> 
> It could, and I think it should, update its MTU, though. I didn't
> include this in the original implementation of PMTU discovery for UDP
> tunnels as it worked just fine for locally generated and routed
> traffic, but here we go.

I don't think its a good idea to muck with network config in response
to untrusted entity.

> As PMTU discovery happens, we have a route exception on the lower
> layer for the given path, and we know that VXLAN will use that path,
> so we also know there's no point in having a higher MTU on the VXLAN
> device, it's really the maximum packet size we can use.

No, in the setup that prompted this series the route exception is wrong.
The current "fix" is a shell script that flushes the exception as soon
as its added to keep the tunnel working...

> > Some setups, however, will use vxlan as a bridge port (or openvs vport).
> 
> And, on top of that, I think what we're missing on the bridge is to
> update the MTU when a port lowers its MTU. The MTU is changed only as
> interfaces are added, which feels like a bug. We could use the lower
> layer notifier to fix this.

I will defer to someone who knows bridges better but I think that
in bridge case we 100% depend on a human to set everything.

bridge might be forwarding frames of non-ip protocol and I worry that
this is a self-induced DoS when we start to alter configuration behind
sysadmins back.

> I tried to represent the issue you're hitting with a new test case in
> the pmtu.sh selftest, also included in the diff. Would that work for
> Open vSwitch?

No idea, I don't understand how it can work at all, we can't 'chop
up'/mangle l2 frame in arbitrary fashion to somehow make them pass to
the output port.  We also can't influence MTU config of the links peer.

> If OVS queries the MTU of VXLAN devices, I guess that should be enough.

What should it be doing...?
