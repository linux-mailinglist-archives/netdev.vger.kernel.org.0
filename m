Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D199F235318
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHAPvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 11:51:07 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:60722 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726432AbgHAPvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 11:51:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id EA2C2837F24D;
        Sat,  1 Aug 2020 15:51:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3354:3865:3867:3868:3871:3872:4321:5007:6119:7903:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12291:12296:12297:12438:12555:12683:12731:12737:12760:13439:14110:14181:14394:14659:14721:21080:21451:21627:21939:21990:30029:30046:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: flag31_57050f426f8d
X-Filterd-Recvd-Size: 4502
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sat,  1 Aug 2020 15:51:04 +0000 (UTC)
Message-ID: <e45d15ad36a0c9a994b5a1136c72518215c99f7a.camel@perches.com>
Subject: [PATCH] via-velocity: Add missing KERN_<LEVEL> where needed
From:   Joe Perches <joe@perches.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 01 Aug 2020 08:51:03 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link status is emitted on multiple lines as it does not use
KERN_CONT.

Coalesce the multi-part logging into a single line output and
add missing KERN_<LEVEL> to a couple logging calls.

This also reduces object size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/via/via-velocity.c | 46 ++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 713dbc04b25b..84d456464b88 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -927,12 +927,12 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 		if (mii_status & VELOCITY_DUPLEX_FULL) {
 			CHIPGCR |= CHIPGCR_FCFDX;
 			writeb(CHIPGCR, &regs->CHIPGCR);
-			VELOCITY_PRT(MSG_LEVEL_INFO, "set Velocity to forced full mode\n");
+			VELOCITY_PRT(MSG_LEVEL_INFO, KERN_INFO "set Velocity to forced full mode\n");
 			if (vptr->rev_id < REV_ID_VT3216_A0)
 				BYTE_REG_BITS_OFF(TCR_TB2BDIS, &regs->TCR);
 		} else {
 			CHIPGCR &= ~CHIPGCR_FCFDX;
-			VELOCITY_PRT(MSG_LEVEL_INFO, "set Velocity to forced half mode\n");
+			VELOCITY_PRT(MSG_LEVEL_INFO, KERN_INFO "set Velocity to forced half mode\n");
 			writeb(CHIPGCR, &regs->CHIPGCR);
 			if (vptr->rev_id < REV_ID_VT3216_A0)
 				BYTE_REG_BITS_ON(TCR_TB2BDIS, &regs->TCR);
@@ -985,45 +985,61 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
  */
 static void velocity_print_link_status(struct velocity_info *vptr)
 {
+	const char *link;
+	const char *speed;
+	const char *duplex;
 
 	if (vptr->mii_status & VELOCITY_LINK_FAIL) {
 		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: failed to detect cable link\n", vptr->netdev->name);
-	} else if (vptr->options.spd_dpx == SPD_DPX_AUTO) {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: Link auto-negotiation", vptr->netdev->name);
+		return;
+	}
+
+	if (vptr->options.spd_dpx == SPD_DPX_AUTO) {
+		link = "auto-negotiation";
 
 		if (vptr->mii_status & VELOCITY_SPEED_1000)
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 1000M bps");
+			speed = "1000";
 		else if (vptr->mii_status & VELOCITY_SPEED_100)
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 100M bps");
+			speed = "100";
 		else
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 10M bps");
+			speed = "10";
 
 		if (vptr->mii_status & VELOCITY_DUPLEX_FULL)
-			VELOCITY_PRT(MSG_LEVEL_INFO, " full duplex\n");
+			duplex = "full";
 		else
-			VELOCITY_PRT(MSG_LEVEL_INFO, " half duplex\n");
+			duplex = "half";
 	} else {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: Link forced", vptr->netdev->name);
+		link = "forced";
+
 		switch (vptr->options.spd_dpx) {
 		case SPD_DPX_1000_FULL:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 1000M bps full duplex\n");
+			speed = "1000";
+			duplex = "full";
 			break;
 		case SPD_DPX_100_HALF:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 100M bps half duplex\n");
+			speed = "100";
+			duplex = "half";
 			break;
 		case SPD_DPX_100_FULL:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 100M bps full duplex\n");
+			speed = "100";
+			duplex = "full";
 			break;
 		case SPD_DPX_10_HALF:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 10M bps half duplex\n");
+			speed = "10";
+			duplex = "half";
 			break;
 		case SPD_DPX_10_FULL:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 10M bps full duplex\n");
+			speed = "10";
+			duplex = "full";
 			break;
 		default:
+			speed = "unknown";
+			duplex = "unknown";
 			break;
 		}
 	}
+	VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: Link %s speed %sM bps %s duplex\n",
+		     vptr->netdev->name, link, speed, duplex);
 }
 
 /**


