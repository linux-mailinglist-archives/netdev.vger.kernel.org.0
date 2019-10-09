Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC87ED1324
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfJIPmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbfJIPmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 11:42:20 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E8BD830A922E;
        Wed,  9 Oct 2019 15:42:19 +0000 (UTC)
Received: from localhost (ovpn-204-237.brq.redhat.com [10.40.204.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47B625D9E2;
        Wed,  9 Oct 2019 15:42:18 +0000 (UTC)
Date:   Wed, 9 Oct 2019 17:42:16 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191009174216.1b3dd3dc@redhat.com>
In-Reply-To: <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
        <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
        <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
        <20191009124814.GB17712@martin-VirtualBox>
        <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 09 Oct 2019 15:42:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 10:58:51 -0400, Willem de Bruijn wrote:
> Yes, this needs a call to gro_cells_receive like geneve_udp_encap_recv
> and vxlan_rcv, instead of returning a negative value back to
> udp_queue_rcv_one_skb. Though that's not a major change.

Willem, how would you do that? The whole fou code including its netlink
API is built around the assumption that it's L4 encapsulation. I see no
way to extend it to do L3 encapsulation without major hacks - in fact,
you'll add all that Martin's patch adds, including a new netlink API,
but just mix that into fou.c.

> Transmit is easier. The example I shared already encapsulates packets
> with MPLs and sends them through a tunnel device. Admittedly using
> mpls routing. But the ip tunneling infrastructure supports adding
> arbitrary inner headers using ip_tunnel_encap_ops.build_header.
> net/ipv4/fou.c could be extended with a mpls_build_header alongside
> fou_build_header and gue_build_header?

The nice thing about the bareudp tunnel is that it's generic. It's just
(outer) UDP header followed by (inner) L3 header. You can use it for
NSH over UDP. Or for multitude of other purposes.

What you're proposing is MPLS only. And it would require similar amount
of code as the bareudp generic solution. It also doesn't fit fou
design: MPLS is not an IP protocol. Trying to add it there is like
forcing a round peg into a square hole. Just look at the code.
Start with parse_nl_config.

> Extending this existing code has more benefits than code reuse (and
> thereby fewer bugs), it also allows reusing the existing GRO logic,
> say.

In this case, it's the opposite: trying to retrofit L3 encapsulation
into fou is going to introduce bugs.

Moreover, given the expected usage of bareudp, the nice benefit is it's
lwtunnel only. No need to carry all the baggage of standalone
configuration fou has.

> At a high level, I think we should try hard to avoid duplicating
> tunnel code for every combination of inner and outer protocol.

Yet you're proposing to do exactly that with special casing MPLS in fou.

I'd say bareudp is as generic as you could get it. It allows any L3
protocol inside UDP. You can hardly make it more generic than that.
With ETH_P_TEB, it could also encapsulate Ethernet (that is, L2).

> Geneve
> and vxlan on the one hand and generic ip tunnel and FOU on the other
> implement most of these features. Indeed, already implements the
> IPxIPx, just not MPLS. It will be less code to add MPLS support based
> on existing infrastructure.

You're mixing apples with oranges. IP tunnels and FOU encapsulate L4
payload. VXLAN and Geneve encapsulate L2 payload (or L3 payload for
VXLAN-GPE).

I agree that VXLAN, Geneve and the proposed bareudp module have
duplicated code. The solution is to factoring it out to a common
location.

> I think it will be preferable to work the other way around and extend
> existing ip tunnel infra to add MPLS.

You see, that's the problem: this is not IP tunneling.

 Jiri
