Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303482AB430
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 10:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgKIJ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 04:58:19 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:52508 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgKIJ6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 04:58:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A47A3200BC;
        Mon,  9 Nov 2020 10:58:15 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mHvVf0SRTQlv; Mon,  9 Nov 2020 10:58:15 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 035C820078;
        Mon,  9 Nov 2020 10:58:15 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 9 Nov 2020 10:58:14 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 9 Nov 2020
 10:58:14 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id BA61131844B0;
 Mon,  9 Nov 2020 10:58:13 +0100 (CET)
Date:   Mon, 9 Nov 2020 10:58:13 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Lorenzo Colitti <lorenzo@google.com>
CC:     mtk81216 <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Greg Kroah-Hartman <gregkh@google.com>
Subject: Re: [PATCH] xfrm:fragmented ipv4 tunnel packets in inner interface
Message-ID: <20201109095813.GV26422@gauss3.secunet.de>
References: <20200909062613.18604-1-lina.wang@mediatek.com>
 <20200915073006.GR20687@gauss3.secunet.de>
 <CAKD1Yr1VsueZWUtCL4iMWLhnADypUOtDK=dgqM2Y2HDvXc77iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKD1Yr1VsueZWUtCL4iMWLhnADypUOtDK=dgqM2Y2HDvXc77iw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 01:52:01PM +0900, Lorenzo Colitti wrote:
> On Tue, Sep 15, 2020 at 4:30 PM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> > > In esp's tunnel mode,if inner interface is ipv4,outer is ipv4,one big
> > > packet which travels through tunnel will be fragmented with outer
> > > interface's mtu,peer server will remove tunnelled esp header and assemble
> > > them in big packet.After forwarding such packet to next endpoint,it will
> > > be dropped because of exceeding mtu or be returned ICMP(packet-too-big).
> >
> > What is the exact case where packets are dropped? Given that the packet
> > was fragmented (and reassembled), I'd assume the DF bit was not set. So
> > every router along the path is allowed to fragment again if needed.
> 
> In general, isn't it just suboptimal to rely on fragmentation if the
> sender already knows the packet is too big? That's why we have things
> like path MTU discovery (RFC 1191).

When we setup packets that are sent from a local socket, we take
MTU/PMTU info we have into account. So we don't create fragments in
that case.

When forwarding packets it is different. The router that can not
TX the packet because it exceeds the MTU of the sending interface
is responsible to either fragment (if DF is not set), or send a
PMTU notification (if DF is set). So if we are able to transmit
the packet, we do it.

> Fragmentation is generally
> expensive, increases the chance of packet loss, and has historically
> caused lots of security vulnerabilities. Also, in real world networks,
> fragments sometimes just don't work, either because intermediate
> routers don't fragment, or because firewalls drop the fragments due to
> security reasons.
> 
> While it's possible in theory to ask these operators to configure
> their routers to fragment packets, that may not result in the network
> being fixed, due to hardware constraints, security policy or other
> reasons.

We can not really do anything here. If a flow has no DF bit set
on the packets, we can not rely on PMTU information. If we have PMTU
info on the route, then we have it because some other flow (that has
DF bit set on the packets) triggered PMTU discovery. That means that
the PMTU information is reset when this flow (with DF set) stops
sending packets. So the other flow (with DF not set) will send
big packets again.

> Those operators may also be in a position to place
> requirements on devices that have to use their network. If the Linux
> stack does not work as is on these networks, then those devices will
> have to meet those requirements by making out-of-tree changes. It
> would be good to avoid that if there's a better solution (e.g., make
> this configurable via sysctl).

We should not try to workaround broken configurations, there are just
too many possibilities to configure a broken network.
