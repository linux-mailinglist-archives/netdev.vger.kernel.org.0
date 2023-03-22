Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26866C4DC6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjCVObx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjCVObr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:31:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0122262B4C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:31:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pezV1-0003Os-Aq; Wed, 22 Mar 2023 15:31:35 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pezUy-005wWF-Ix; Wed, 22 Mar 2023 15:31:32 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pezUx-0060Zl-2v; Wed, 22 Mar 2023 15:31:31 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net v1 2/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024 entries
Date:   Wed, 22 Mar 2023 15:31:26 +0100
Message-Id: <20230322143130.1432106-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322143130.1432106-1-o.rempel@pengutronix.de>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current ksz8_fdb_dump() is able to extract only max 249 entries on
the ksz8863/ksz8873 series of switches. This happened due to wrong
bit mask and offset calculation.

This commit corrects the issue and allows for the complete extraction of
all 1024 entries.

Fixes: d23a5e18606c ("net: dsa: microchip: move ksz8->masks to ksz_common")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7fc2155d93d6..3a1afc9f4621 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -407,10 +407,10 @@ static const u32 ksz8863_masks[] = {
 	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
 	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
 	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
-	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(5, 0),
+	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(1, 0),
 	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
-	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 28),
+	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 24),
 	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(19, 16),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(21, 20),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(23, 22),
@@ -420,7 +420,7 @@ static u8 ksz8863_shifts[] = {
 	[VLAN_TABLE_MEMBERSHIP_S]	= 16,
 	[STATIC_MAC_FWD_PORTS]		= 16,
 	[STATIC_MAC_FID]		= 22,
-	[DYNAMIC_MAC_ENTRIES_H]		= 3,
+	[DYNAMIC_MAC_ENTRIES_H]		= 8,
 	[DYNAMIC_MAC_ENTRIES]		= 24,
 	[DYNAMIC_MAC_FID]		= 16,
 	[DYNAMIC_MAC_TIMESTAMP]		= 24,
-- 
2.30.2

