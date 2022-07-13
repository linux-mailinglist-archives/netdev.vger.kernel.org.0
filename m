Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D87A572B2F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 04:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiGMCHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 22:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGMCHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 22:07:09 -0400
X-Greylist: delayed 496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 19:07:08 PDT
Received: from mta02.start.ca (mta02.start.ca [162.250.196.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AA4C1676;
        Tue, 12 Jul 2022 19:07:08 -0700 (PDT)
Received: from mta02.start.ca (localhost [127.0.0.1])
        by mta02.start.ca (Postfix) with ESMTP id 9A5693FF60;
        Tue, 12 Jul 2022 21:58:50 -0400 (EDT)
Received: from localhost (dhcp-24-53-241-20.cable.user.start.ca [24.53.241.20])
        by mta02.start.ca (Postfix) with ESMTPS id 7178C3FD48;
        Tue, 12 Jul 2022 21:58:50 -0400 (EDT)
From:   Nick Bowler <nbowler@draconx.ca>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sunhme: output link status with a single print.
Date:   Tue, 12 Jul 2022 21:58:35 -0400
Message-Id: <20220713015835.23580-1-nbowler@draconx.ca>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver currently prints the link status using four separate
printk calls, which these days gets presented to the user as four
distinct messages, not exactly ideal:

  [   32.582778] eth0: Link is up using
  [   32.582828] internal
  [   32.582837] transceiver at
  [   32.582888] 100Mb/s, Full Duplex.

Restructure the display_link_mode function to use a single netdev_info
call to present all this information as a single message, which is much
nicer:

  [   33.640143] hme 0000:00:01.1 eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.

The display_forced_link_mode function has a similar structure, so adjust
it in a similar fashion.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
---
 drivers/net/ethernet/sun/sunhme.c | 43 +++++++++----------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 77e5dffb558f..8594ee839628 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -545,43 +545,24 @@ static int try_next_permutation(struct happy_meal *hp, void __iomem *tregs)
 
 static void display_link_mode(struct happy_meal *hp, void __iomem *tregs)
 {
-	printk(KERN_INFO "%s: Link is up using ", hp->dev->name);
-	if (hp->tcvr_type == external)
-		printk("external ");
-	else
-		printk("internal ");
-	printk("transceiver at ");
 	hp->sw_lpa = happy_meal_tcvr_read(hp, tregs, MII_LPA);
-	if (hp->sw_lpa & (LPA_100HALF | LPA_100FULL)) {
-		if (hp->sw_lpa & LPA_100FULL)
-			printk("100Mb/s, Full Duplex.\n");
-		else
-			printk("100Mb/s, Half Duplex.\n");
-	} else {
-		if (hp->sw_lpa & LPA_10FULL)
-			printk("10Mb/s, Full Duplex.\n");
-		else
-			printk("10Mb/s, Half Duplex.\n");
-	}
+
+	netdev_info(hp->dev,
+		    "Link is up using %s transceiver at %dMb/s, %s Duplex.\n",
+		    hp->tcvr_type == external ? "external" : "internal",
+		    hp->sw_lpa & (LPA_100HALF | LPA_100FULL) ? 100 : 10,
+		    hp->sw_lpa & (LPA_100FULL | LPA_10FULL) ? "Full" : "Half");
 }
 
 static void display_forced_link_mode(struct happy_meal *hp, void __iomem *tregs)
 {
-	printk(KERN_INFO "%s: Link has been forced up using ", hp->dev->name);
-	if (hp->tcvr_type == external)
-		printk("external ");
-	else
-		printk("internal ");
-	printk("transceiver at ");
 	hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-	if (hp->sw_bmcr & BMCR_SPEED100)
-		printk("100Mb/s, ");
-	else
-		printk("10Mb/s, ");
-	if (hp->sw_bmcr & BMCR_FULLDPLX)
-		printk("Full Duplex.\n");
-	else
-		printk("Half Duplex.\n");
+
+	netdev_info(hp->dev,
+		    "Link has been forced up using %s transceiver at %dMb/s, %s Duplex.\n",
+		    hp->tcvr_type == external ? "external" : "internal",
+		    hp->sw_bmcr & BMCR_SPEED100 ? 100 : 10,
+		    hp->sw_bmcr & BMCR_FULLDPLX ? "Full" : "Half");
 }
 
 static int set_happy_link_modes(struct happy_meal *hp, void __iomem *tregs)
-- 
2.35.1

