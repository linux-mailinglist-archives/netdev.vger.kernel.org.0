Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A4258439
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 00:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgHaWzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 18:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHaWzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 18:55:08 -0400
X-Greylist: delayed 2463 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Aug 2020 15:55:08 PDT
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D137C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 15:55:08 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.92.2)
        (envelope-from <mh+netdev@zugschlus.de>)
        id 1kCs3u-0003JZ-V4
        for netdev@vger.kernel.org; Tue, 01 Sep 2020 00:14:02 +0200
Date:   Tue, 1 Sep 2020 00:14:02 +0200
From:   Marc Haber <mh+netdev@zugschlus.de>
To:     netdev@vger.kernel.org
Subject: Policy Routing and two independent, not cooperating IPv6 uplinks
Message-ID: <20200831221402.GA30996@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

my current use case is a small machine providing Out-of-Band access to a
bunch of routers in a small company's datacenter. The machine has IPv6
only. It is directly connected both to the ISP's CPE router and to a
backup router providing Internet via cellular just in case the ISP or
its router is out. The cell router's access is severely shaped and
expensive, so it is desired that the machine does fetch its OS updates
through the ISP while being reachable for ssh and ICMPv6 via both
uplinks, even in the case when one of the uplinks has completely failed.
Both uplinks have reverse path filtering in place, will only forward
packets with a source address from their own prefix (no, not even
hairpin them back into the LAN), and generally should not need to know
about each other.

This use case does not currently look as it is supported, but may be
I have done wrong configuration. The documentation that can easily be
found on the net is usually grossly outdated or written by people with
expandable network knowledge, so I don't see any other way than to ask
here. If there is a mailing list that could help me better than
pestering the developers, I'd appreciate a pointer.

Here my config:
|$ ip -6 rule
|0:      from all lookup local
|29000:  from 2001:db8:42bc:a18e::/64 lookup ka51
|30000:  from all lookup main
|$ ip -6 route show table ka51
|2001:db8:42bc:a11d::/64 via 2001:db8:42bc:a18e::70:100 dev unt381 proto static metric 1024 pref medium
|2001:db8:42bc:a180::/59 via 2001:db8:42bc:a18e::70:100 dev unt381 proto static metric 1024 pref medium
|2001:db8:42bc:a1b0::/60 via 2001:db8:42bc:a18e::70:100 dev unt381 proto static metric 1024 pref medium
|default via 2001:db8:42bc:a18e::70:100 dev unt381 proto static metric 1000 pref medium
|$ ip -6 route show table main
|::1 dev lo proto kernel metric 256 pref medium
|2001:16b8:3037:6900::/64 dev unt381 proto ra metric 1024 expires 6801sec pref medium
|2001:16b8:3037:6900::/56 via fe80::cece:1eff:fe29:7745 dev unt381 proto ra metric 1024 expires 1401sec pref medium
|2001:db8:42bc:a18e::/64 dev unt381 proto kernel metric 256 pref medium
|fe80::/64 dev unt381 proto kernel metric 256 pref medium
|default via fe80::cece:1eff:fe29:7745 dev unt381 proto ra metric 1024 expires 1401sec mtu 1492 pref medium
|$

(ISP 1 has statically assigned 2001:db8:42bc:a180::/59,
2001:db8:42bc:a11d::/64 and 2001:db8:42bc:a1b0::/60; ISP 2 assigns
dynamic prefixes, here 2001:16b8:3037:6900::/56)

In the addrlabel table, I have manually assigned label 8 to
2a01:238:42bc:a180::/59:

prefix ::1/128 label 0 
prefix ::/96 label 3 
prefix ::ffff:0.0.0.0/96 label 4 
prefix 2a01:238:42bc:a180::/59 label 8 
prefix 2001::/32 label 6 
prefix 2001:10::/28 label 7 
prefix 3ffe::/16 label 12 
prefix 2002::/16 label 2 
prefix fec0::/10 label 11 
prefix fc00::/7 label 5 
prefix ::/0 label 1 

I would therefore expect that a packet going out to a destination
address in 2a01:238:42bc:a180::/59 would automatically get assigned a
source address from the same prefix (RFC6724 Chapter 5 Rule 6 "Prefer
Matching Label") and routed to the default gateway listed in the ka51
routing table.

This does not work. When I ping 2001:db8:42bc:a182::1d:100 without
explicitly specifying 2001:db8:42bc:a18e::9:100 as source address, my
host automatically chooses the correct source address as configured per
ip addrlabel, but chooses the wrong default router and sends out the
following packet to the default router from the main table:

|20:38:22.569941 02:48:05:c1:4b:81 > cc:ce:1e:29:77:45, ethertype IPv6 (0x86dd), length 154: 2001:db8:42bc:a18e::9:100 > 2001:db8:42bc:a182::1d:100: ICMP6, echo request, seq 1, length 100

This is consistent with what I have understood about how the Linux
routing process works: Linux first does the routing and THEN chooses the
source IP address. In my case, the correct choice of source IP address
has invalidated the routing process, which results in the packet being
sent out to the wrong router (and dropped there).

RFC6724 Chapter 7 has some musings about interaction of source address
selection with the routing process that indicate that the RFC authors
have suspected possible trouble her but didn't have policy routing in
mind.

I am also concerned that the system behaves differently when the
application has explicitly selected an IP address. In that case, the
routing decision is taken with the correct source address and is
therefore correct. Also, when a packet received via the network (and
thus already has a source address), routing is correct. The only case
that results in the observed behavior is a locally originated packet
where the application has indicated that it would like the OS to choose
the source address. This is confusing and inconsistent.

I might be missing something here, or have been doing something wrong,
but to me this looks like it would be a good idea to revisit a routing
decision when subsequent processing has changed aspects of the packet
that might affect the correctness of the routing decision.

A colleague has also advised that I might be better off by using the
"src" selector inside a route and doing things completely without
routing rules, but I haven't gotten that to work at all. If that is a
promising approach, I'd appreciate a pointer towards some documentation.

Thanks for your help and consideration. I hope this message is not going
to be ignored and I would love to have this taken up by you developers
as an every-day, but non-trivial use case from a productive network.

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

