Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E12677309
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 23:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjAVWt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 17:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjAVWt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 17:49:26 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4931714E;
        Sun, 22 Jan 2023 14:49:24 -0800 (PST)
Received: (Authenticated sender: schoen@loyalty.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 00B41FF803;
        Sun, 22 Jan 2023 22:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=loyalty.org; s=gm1;
        t=1674427763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cV2qhPqki74Px+vTRxaDMKbdo3dSKb5l5S7PACpgtjo=;
        b=MAQEOBqKAEZOB8oKJ8IkCD5KGI+MhnFb2Eda7XLRQGXJjPLeBOl6Xsr5Cbu4qzwLhwh+yK
        o4wma26Ybfrki5z/pR0zJXL8K+v62j8An9Ayak4PoKlJXK1ffehCnvIVgTiQ//FyMsLcLR
        GQ9eQCS82+pGS68LNWBWUE7kearxJh8zUu47655zPkypa5v7wTSzVakuT4n/uKG36BZmMW
        QNc3/yfXnbeechot/ld+NiZxTHD9Ga4UdxJWj2mLsNuhi7arpueHccXw/ZQLUqgJqUNR0T
        oG5fLptR6mkZslKLZViSJHxjMk4F/iBwiPaH4S8xmW74L+JeN7qBGbu56sbobw==
Date:   Sun, 22 Jan 2023 14:49:18 -0800
From:   Seth David Schoen <schoen@loyalty.org>
To:     linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v4] ip.7: Add Special and Reserved IP Addresses section
Message-ID: <20230122224918.GA373019@demorgan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
