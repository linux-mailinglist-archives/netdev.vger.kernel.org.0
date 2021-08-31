Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F763FCD06
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 20:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhHaSmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 14:42:25 -0400
Received: from frotz.zork.net ([69.164.197.204]:53162 "EHLO frotz.zork.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhHaSmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 14:42:25 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2021 14:42:25 EDT
Received: by frotz.zork.net (Postfix, from userid 1008)
        id E45DC11999; Tue, 31 Aug 2021 18:34:08 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 frotz.zork.net E45DC11999
Date:   Tue, 31 Aug 2021 11:34:08 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Gilmore <gnu@toad.com>
Subject: [PATCH v3] ip.7: Add "Special and reserved addresses" section
Message-ID: <20210831183408.GI1796634@frotz.zork.net>
Mail-Followup-To: Seth David Schoen <schoen@loyalty.org>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        John Gilmore <gnu@toad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new section with a more detailed description of the IPv4 addresses
that have a special meaning in Internet standards, and how these affect
Linux.

The occasion for this update is the inclusion of our patch in Linux 5.14,
which changes Linux's subnet broadcast address behavior.

The divergences in Linux's behavior mentioned in this patch were
introduced at

unicast 240/4 (since 2.6.25):
  commit 1e637c74b0f84eaca02b914c0b8c6f67276e9697
  Author: Jan Engelhardt <jengelh@computergmbh.de>
  Date:   Mon Jan 21 03:18:08 2008 -0800

unicast 0/8 (since 5.3):
  commit 96125bf9985a75db00496dd2bc9249b777d2b19b
  Author: Dave Taht <dave.taht@gmail.com>
  Date:   Sat Jun 22 10:07:34 2019 -0700

unicast subnet lowest address (since 5.14):
  commit 58fee5fc83658aaacf60246aeab738946a9ba516
  Merge: 77091933e453 6101ca0384e3
  Author: David S. Miller <davem@davemloft.net>
  Date:   Mon May 17 13:47:58 2021 -0700

Signed-off-by: Seth David Schoen <schoen@loyalty.org>
Suggested-by: John Gilmore <gnu@toad.com>
---
 man7/ip.7 | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/man7/ip.7 b/man7/ip.7
index 7eee2811e..0c228a9c2 100644
--- a/man7/ip.7
+++ b/man7/ip.7
@@ -232,6 +232,7 @@ In particular, this means that you need to call
 on the number that is assigned to a port.
 All address/port manipulation
 functions in the standard library work in network byte order.
+.SS Special and reserved addresses
 .PP
 There are several special addresses:
 .B INADDR_LOOPBACK
@@ -239,12 +240,53 @@ There are several special addresses:
 always refers to the local host via the loopback device;
 .B INADDR_ANY
 (0.0.0.0)
-means any address for binding;
+means any address for socket binding;
 .B INADDR_BROADCAST
 (255.255.255.255)
-means any host and has the same effect on bind as
+has the same effect on socket binding as
 .B INADDR_ANY
-for historical reasons.
+for historical reasons. A packet addressed to
+.B INADDR_BROADCAST
+through a socket which has
+.B SO_BROADCAST
+set will be broadcast to all hosts on the local network segment, as
+long as the link is broadcast-capable.
+.PP
+Internet standards have also traditionally reserved various
+addresses for particular uses. (Some reserved addresses are no longer
+treated specially by Linux kernels, as described below.) The addresses
+in the ranges 0.0.0.1 through 0.255.255.255 and 240.0.0.0 through
+255.255.255.254 (0/8 and 240/4, in CIDR notation) are reserved globally.
+All addresses from 127.0.0.1 through 127.255.255.254
+are treated as loopback addresses akin to the standardized
+local loopback address 127.0.0.1, while addresses in 224.0.0.0 through
+239.255.255.255 (224/4) are dedicated to multicast use.
+.PP
+On any locally-attached IP subnet with a link type that supports
+broadcasts, the highest-numbered address (e.g., the .255 address on a
+subnet with netmask 255.255.255.0) is designated as a broadcast address.
+This "broadcast address" cannot usefully be assigned to an interface, and
+can only be addressed
+with a socket on which the
+.B SO_BROADCAST
+option has been set.
+Internet standards have historically also reserved the lowest-numbered
+address (e.g., the .0 address on a subnet with netmask 255.255.255.0)
+for broadcast, though they call it "obsolete" for this purpose.
+.IP \(bu 2
+Since Linux 2.6.25, 240/4 addresses (except 255.255.255.255) are treated
+as ordinary unicast addresses, and can therefore be assigned to an interface.
+.IP \(bu
+Since Linux 5.3, this is also true for 0/8 addresses (except 0.0.0.0).
+.IP \(bu
+Since Linux 5.14, this is also true for the lowest address on a subnet
+(e.g., the .0 address in a /24 network).
+.PP
+Operating systems that follow the traditional behaviors may not
+interoperate with a system using these historically reserved addresses.
+However, distant hosts will interoperate with the lowest address on a
+subnet, as long as the local router and the host to which it is assigned
+both treat it as a unicast address.
 .SS Socket options
 IP supports some protocol-specific socket options that can be set with
 .BR setsockopt (2)
-- 
2.25.1

