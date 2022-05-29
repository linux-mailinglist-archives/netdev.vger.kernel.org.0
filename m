Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17ED6537176
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiE2PIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiE2PIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:08:48 -0400
X-Greylist: delayed 1738 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 May 2022 08:08:46 PDT
Received: from janet.servers.dxld.at (janet.pub.dxld.at [IPv6:2001:678:4d8::1a57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364B052E63
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 08:08:46 -0700 (PDT)
Received: janet.servers.dxld.at; Sun, 29 May 2022 16:39:28 +0200
Date:   Sun, 29 May 2022 16:39:22 +0200
From:   Daniel =?utf-8?Q?Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [BUG] ip6tnl ignores phys_dev for outgoing packets
Message-ID: <20220529143922.r3yqp3d4p4etrvmt@House>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

I'm trying to build an ip6ip6 tunnel that sends encapsulated packets only
via a particular interface using the `dev PHYS_DEV` parameter but I'm
seeing packets leave via a different interface instead.

Since it's not totally clear to me what the dev option is really supposed
to do I tested with an ipip tunnel and that does what I'd expect: Even if
there's a more preferential route for the remote address via a different
interface it sends via PHYS_DEV.

To reproduce first setup some dummy interfaces:

    $ ip link add physdev type dummy
    $ ip link add othrdev type dummy

    $ ip addr add dev physdev fd00::1/64
    $ ip addr add dev othrdev fd00::2/64

    $ ip link set dev physdev up
    $ ip link set dev othrdev up

    $ ip link add name tun-test type ip6tnl mode ip6ip6 local fd00::1 remote fd00::3 dev physdev
    $ ip link set dev tun-test up

Make sure othrdev is ordinarily preferred for the remote address contrary
to our PHYS_DEV request above so we can see the difference:

    $ ip -6 route add fd00::3 dev othrdev metric 1

Now generate some traffic on tun-test and observe the encapsulated packets
going out via othrdev instead of physdev as we requested:

    $ ping fe80::1 -I tun-test&
    $ tcpdump -nli any host fd00::3
    othrdev Out IP6 fd00::1 > fd00::3: DSTOPT IP6 fe80::90ae:78ff:fe49:3eed > fe80::1: ICMP6, echo request, id 12880, seq 25, length 64

I did some digging though the code already and found that perhaps setting
`local any` would change the behaviour due to some logic I found in
ip6_route_output_flags_noref:

    any_src = ipv6_addr_any(&fl6->saddr);
    if ((sk && sk->sk_bound_dev_if) || rt6_need_strict(&fl6->daddr) ||
        (fl6->flowi6_oif && any_src))
            flags |= RT6_LOOKUP_F_IFACE;

Alas if I try with `local any` that seems even more broken as I just get
"Address unreachable" responses with or without the `dev physdev`
bit. Weird.

Any ideas whats going wrong here?

--Daniel

PS: I'm not subscribed please leave me in CC.
