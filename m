Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E74513A0E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350208AbiD1Qo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349054AbiD1Qo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:44:59 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139157C7AB;
        Thu, 28 Apr 2022 09:41:43 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A571724000B;
        Thu, 28 Apr 2022 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651164102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wTH6ZEk/Y++FSk1qrFx/NjlNBR+hPifrLu8zie/kLiE=;
        b=AVqOosPs4Dry4Bg/cBfEdCXTwbs0XJy/Bk28t7urXxLAXgKH1YmZC9PkFL5+h9qDiWaRQ5
        /efDBNdqMD4qnCXnCxJNWEI1F4D4MDZ06zjzenhxUh4+vqion4neuuu7uH2pxD1ydpEHAT
        w46Exax5a12n6oJsbTxjH++JuEZmHNsffL3us4eQ5bSps7wXk7kKbeYcm8McvadWVAOlY/
        IdcASigH4Wp7DKBNwi/C76Sks0A2WvI8QI9AE+HnU/EDj6d9NMhVbGF4QOE0ixXOPChqBk
        2lqhAGZ/Zbr2jdIpNq3u67VLT55dfZd+C4SGki74G6oklLNh5nAHceEy3HQMuw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next] net: mac802154: Fix symbol durations
Date:   Thu, 28 Apr 2022 18:41:40 +0200
Message-Id: <20220428164140.251965-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two major issues in the logic calculating the symbol durations
based on the page/channel:
- The page number is used in place of the channel value.
- The BIT() macro is missing because we want to check the channel
  value against a bitmask.

Fix these two errors and apologize loudly for this mistake.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 5546ef86e231..bd7bdb1219dd 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -119,26 +119,26 @@ void ieee802154_configure_durations(struct wpan_phy *phy)
 
 	switch (phy->current_page) {
 	case 0:
-		if (BIT(phy->current_page) & 0x1)
+		if (BIT(phy->current_channel) & 0x1)
 			/* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
 			duration = 50 * NSEC_PER_USEC;
-		else if (phy->current_page & 0x7FE)
+		else if (BIT(phy->current_channel) & 0x7FE)
 			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
 			duration = 25 * NSEC_PER_USEC;
-		else if (phy->current_page & 0x7FFF800)
+		else if (BIT(phy->current_channel) & 0x7FFF800)
 			/* 2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
 			duration = 16 * NSEC_PER_USEC;
 		break;
 	case 2:
-		if (BIT(phy->current_page) & 0x1)
+		if (BIT(phy->current_channel) & 0x1)
 			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
 			duration = 40 * NSEC_PER_USEC;
-		else if (phy->current_page & 0x7FE)
+		else if (BIT(phy->current_channel) & 0x7FE)
 			/* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
 			duration = 16 * NSEC_PER_USEC;
 		break;
 	case 3:
-		if (BIT(phy->current_page) & 0x3FFF)
+		if (BIT(phy->current_channel) & 0x3FFF)
 			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
 			duration = 6 * NSEC_PER_USEC;
 		break;
-- 
2.27.0

