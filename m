Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C4037F25B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 06:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhEMEhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 00:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhEMEhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 00:37:43 -0400
Received: from frotz.zork.net (frotz.zork.net [IPv6:2600:3c00:e000:35f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3230C0613ED
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 21:36:30 -0700 (PDT)
Received: by frotz.zork.net (Postfix, from userid 1008)
        id 5BBA01199F; Thu, 13 May 2021 04:36:25 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 frotz.zork.net 5BBA01199F
Date:   Wed, 12 May 2021 21:36:25 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     netdev@vger.kernel.org
Cc:     John Gilmore <gnu@toad.com>, Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [RESEND PATCH net-next 0/2] Treat IPv4 lowest address as ordinary
 unicast address
Message-ID: <20210513043625.GL1047389@frotz.zork.net>
Mail-Followup-To: Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, John Gilmore <gnu@toad.com>,
        Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat the lowest address in a subnet (the address within the subnet
which contains all 0 bits) as an ordinary unicast address instead
of as a potential second broadcast address.  For example, in subnet
192.168.17.24/29, which contains 8 addresses, make address 192.168.17.24
usable as a normal unicast address (while continuing to support
192.168.17.31 as a broadcast address).

Since EVERY network number or subnet formerly had its host number 0
reserved, this patchset adds 1 more usable host address to every network
and subnet (i.e., 2^(32-n)-1 instead of 2^(32-n)-2 addresses available
for assignment on each IPv4 /n subnet).  For small subnets, this is a
significant gain; instead of 6 usable host addresses, a /29 would now
contain 7, a 16% increase.

The reserving of host number 0 for broadcast came about in RFC 1122 from
1989 (page 31, "IP addresses are not permitted to have the value 0 or -1
for any of the <Host-number>, <Network-number>, or <Subnet-number>
fields (except in the special cases listed above)" and page 66, "There
is a class of hosts [4.2BSD Unix and its derivatives, but not 4.3BSD]
that use non-standard broadcast address forms, substituting 0 for -1.
All hosts SHOULD recognize and accept any of these non-standard
broadcast addresses as the destination address of an incoming
datagram.").  This has been repeated in subsequent RFCs, always with
backwards-compatibility rationales.  Network troubles (broadcast storms)
ensued when some early hosts on a LAN treated the lowest address as
unicast and others treated it as broadcast.  Multiple 1989 changes to IP
successfully prevented these.  The key was adding the layering violation
rule requiring hosts to ignore all IP datagrams with unicast destination
addresses that were received in low-level (Ethernet) broadcasts.  That
change is still in effect, and this patchset does not alter it.  All
operating systems since 4.3BSD, including all the current BSD OSes, now
use the standard IP broadcast address.  4.2BSD has been obsolete for
more than 30 years, and all modern hosts ignore hardware broadcasts
containing unicast IP addresses, so there is no modern likelihood of
broadcast storms even when hosts disagree on the unicast vs. broadcast
status of a given address.

Tests with this patchset show that other Linux hosts on the local segment
simply ignore a host numbered with the lowest address, both for incoming
and outgoing packet purposes.  They don't interoperate with it, but they
also don't cause broadcast storms or any other malfunction.  If patched,
they have no trouble interoperating with a host at the lowest address.

Unmodified "distant" hosts that are not on the same segment successfully
interoperate, as long as the gateway on the local segment, and the local
host itself using the lowest address, have this patch.  (Distant hosts
have no way of knowing whether a given address is the lowest address
in a faraway network segment, so they treat it no differently than any
other unicast address.)  This means that each local site can change this
behavior locally, resulting immediately in global interoperability with
the newly usable lowest local address.

Modern software and documentation continues to use the definition of the
directed, or "net-directed", broadcast address as "a host ID of all one
bits".  The Internet no longer gets any benefit from having two different
broadcast addresses usable on every Ethernet segment.  I have not been
able to find any documentation that suggests that users or software should
ever intentionally use the all-zero form, or that justifies it other than
as a historic Berkeleyism.  RFCs 1112, 1812, and 3021 state that hosts and
routers need to maintain compatibility with the old form -- but they give
no rationale other than the past existence of the 4.2BSD behavior.

We're happy to provide more historical details or information about
behavior of other systems in this regard by e-mail or as future patches
to kernel documentation files.

Seth David Schoen (2):
  ip: Treat IPv4 segment's lowest address as unicast
  selftests: Lowest IPv4 address in a subnet is valid

 net/ipv4/fib_frontend.c                         |  4 +---
 .../testing/selftests/net/unicast_extensions.sh | 17 +++++++++--------
 2 files changed, 10 insertions(+), 11 deletions(-)

-- 
2.25.1
