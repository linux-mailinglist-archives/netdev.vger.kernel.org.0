Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855436E03A6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDMBX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:23:58 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C81C1712;
        Wed, 12 Apr 2023 18:23:54 -0700 (PDT)
Received: (Authenticated sender: schoen@loyalty.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 8D9D240002;
        Thu, 13 Apr 2023 01:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=loyalty.org; s=gm1;
        t=1681349033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cV2qhPqki74Px+vTRxaDMKbdo3dSKb5l5S7PACpgtjo=;
        b=SGB9B5mDqf0gn3rrCAGCmvgKWS9dMlL65Ok77cYT06MilK7BKPN5PQbWchV4FU++Q0G16Y
        zbM64Ykaj3SupQFAtulVIED3zjyJYeJGlgKo2Ub/HyDrJ6uPsLus1E4MdlZjj04CcsjvdX
        pxdrEzXy8Ebl6vbC7DZOkNSeUHdVr2M98FjdgD4X8En9bxLm6p+TGTsjW0lRTlPxpED9iA
        8dDSotyNwir30abxPibKsne3kbXTXmFHNg99g5wSyyL1+yU3LYarboz9mN/7KNIpAleZdQ
        3fpeqj6Zyvjq7kqBCyCAPiDDXrHWFvUB4yvYA+11YcHGA6NFT55aFCzc2bLijA==
Date:   Wed, 12 Apr 2023 18:23:48 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v4 resend] ip.7: Add Special and Reserved IP Addresses section
Message-ID: <20230413012348.GA2492327@demorgan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Break out the discussion of special and reserved IPv4 addresses
into a subsection, and briefly describe three cases in which
Linux no longer treats addresses specially, where other systems
do or did.

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
 man7/ip.7 | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/man7/ip.7 b/man7/ip.7
index f69af1b32..94de21979 100644
--- a/man7/ip.7
+++ b/man7/ip.7
@@ -237,6 +237,7 @@ In particular, this means that you need to call
 on the number that is assigned to a port.
 All address/port manipulation
 functions in the standard library work in network byte order.
+.SS Special and reserved addresses
 .PP
 There are several special addresses:
 .B INADDR_LOOPBACK
@@ -244,12 +245,43 @@ There are several special addresses:
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
+On any locally-attached IP subnet with a link type that supports
+broadcasts, the highest-numbered address (e.g., the .255 address on a
+subnet with netmask 255.255.255.0) is designated as a broadcast address.
+This "broadcast address" cannot usefully be assigned to an interface, and
+can only be addressed with a socket on which the
+.B SO_BROADCAST
+option has been set.
+Internet standards have historically also reserved the lowest-numbered
+address (e.g., the .0 address on a subnet with netmask 255.255.255.0)
+for broadcast, though they call it "obsolete" for this purpose.  Since
+Linux 5.14, it is treated as an ordinary unicast address.
+.PP
+Internet standards have also traditionally reserved various addresses
+for particular uses, though Linux no longer treats some of these
+specially. Addresses in the ranges 0.0.0.1 through 0.255.255.255 and
+240.0.0.0 through 255.255.255.254 (0/8 and 240/4) are reserved globally.
+Since Linux 5.3 and Linux 2.6.245, respectively, the 0/8 and 240/4
+addresses are treated as ordinary unicast addresses. Systems that follow
+the traditional behaviors may not interoperate with these historically
+reserved addresses.
+.PP
+All addresses from 127.0.0.1 through 127.255.255.254
+are treated as loopback addresses akin to the standardized
+local loopback address 127.0.0.1, while addresses in 224.0.0.0 through
+239.255.255.255 (224/4) are dedicated to multicast use.
 .SS Socket options
 IP supports some protocol-specific socket options that can be set with
 .BR setsockopt (2)
-- 
2.25.1
