Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E2921D363
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgGMKE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:04:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726523AbgGMKE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594634695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyPMRX8lWauWk121QBf3nlkNlgLa4TUnNK0Qq9Zicrc=;
        b=CSqnqESLPx26vw1ZYC0nAXn3X1IcDo+xvv7fbeuN8/UXh2SC05kDSTq1Pl4h3hobmTu1cf
        DBTaEbtVIraMsSM+bqafXRcEjFldpMQFsMb7Jf+zgr3v5090KWTYyT2EwbBt5wqqTUKVv9
        sU00O6TY7KR8RHqJsrfc/fYwZjZzIic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-r5Z6go0_O_uwSMeQDUBpCA-1; Mon, 13 Jul 2020 06:04:52 -0400
X-MC-Unique: r5Z6go0_O_uwSMeQDUBpCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D8BC1081;
        Mon, 13 Jul 2020 10:04:51 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1788B5D9DC;
        Mon, 13 Jul 2020 10:04:48 +0000 (UTC)
Date:   Mon, 13 Jul 2020 12:04:39 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, aconole@redhat.com,
        Numan Siddique <nusiddiq@redhat.com>
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713120158.665a6677@elisabeth>
In-Reply-To: <20200713080413.GL32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 10:04:13 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > Hi,
> > 
> > On Sun, 12 Jul 2020 22:07:03 +0200
> > Florian Westphal <fw@strlen.de> wrote:
> >   
> > > vxlan and geneve take the to-be-transmitted skb, prepend the
> > > encapsulation header and send the result.
> > > 
> > > Neither vxlan nor geneve can do anything about a lowered path mtu
> > > except notifying the peer/upper dst entry.  
> > 
> > It could, and I think it should, update its MTU, though. I didn't
> > include this in the original implementation of PMTU discovery for UDP
> > tunnels as it worked just fine for locally generated and routed
> > traffic, but here we go.  
> 
> I don't think its a good idea to muck with network config in response
> to untrusted entity.

I agree that this (changing MTU on VXLAN) looks like a further step,
but the practical effect is zero: we can't send those packets already
today.

PMTU discovery has security impacts, and they are mentioned in the
RFCs. Also here, we wouldn't increase the MTU as a result, and if the
entity is considered untrusted, considerations from RFC 8201 and RFC
4890 cover that.

In practice, we might have broken networks, but at a practical level, I
guess it's enough to not make the situation any worse.

> > As PMTU discovery happens, we have a route exception on the lower
> > layer for the given path, and we know that VXLAN will use that path,
> > so we also know there's no point in having a higher MTU on the VXLAN
> > device, it's really the maximum packet size we can use.  
> 
> No, in the setup that prompted this series the route exception is wrong.
> The current "fix" is a shell script that flushes the exception as soon
> as its added to keep the tunnel working...

Oh, oops.

Well, as I mentioned, if this is breaking setups and this series is the
only way to fix things, I have nothing against it, we can still work on
a more comprehensive solution (including the bridge) once we have it.

> > > Some setups, however, will use vxlan as a bridge port (or openvs vport).  
> > 
> > And, on top of that, I think what we're missing on the bridge is to
> > update the MTU when a port lowers its MTU. The MTU is changed only as
> > interfaces are added, which feels like a bug. We could use the lower
> > layer notifier to fix this.  
> 
> I will defer to someone who knows bridges better but I think that
> in bridge case we 100% depend on a human to set everything.

Not entirely, MTU is auto-adjusted when interfaces are added (unless
the user set it explicitly), however:

> bridge might be forwarding frames of non-ip protocol and I worry that
> this is a self-induced DoS when we start to alter configuration behind
> sysadmins back.

...yes, I agree that the matter with the bridge is different. And we
don't know if that fixes anything else than the selftest I showed, so
let's forget about the bridge for a moment.

> > I tried to represent the issue you're hitting with a new test case in
> > the pmtu.sh selftest, also included in the diff. Would that work for
> > Open vSwitch?  
> 
> No idea, I don't understand how it can work at all, we can't 'chop
> up'/mangle l2 frame in arbitrary fashion to somehow make them pass to
> the output port.  We also can't influence MTU config of the links peer.

Sorry I didn't expand right away.

In the test case I showed, it works because at that point sending
packets to the bridge will result in an error, and the (local) sender
fragments. Let's set this aside together with the bridge affair, though.

Back to VXLAN and OVS: OVS implements a "check_pkt_len" action, cf.
commit 4d5ec89fc8d1 ("net: openvswitch: Add a new action
check_pkt_len"), that should be used when packets exceed link MTUs:

  With the help of this action, OVN will check the packet length
  and if it is greater than the MTU size, it will generate an
  ICMP packet (type 3, code 4) and includes the next hop mtu in it
  so that the sender can fragment the packets.

and my understanding is that this can only work if we reflect the
effective MTU on the device itself (including VXLAN).

Side note: I'm not fond of the idea behind that OVS action because I
think it competes with the kernel (and with ICMP itself, or PLPMTUD if
ICMP is not an option) to do PMTU discovery.

However, if that already works for OVS (I really don't know. Aaron,
Numan?), perhaps you could simply consider going with that solution...

-- 
Stefano

