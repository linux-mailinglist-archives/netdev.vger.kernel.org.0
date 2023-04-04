Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797886D5CFA
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbjDDKTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbjDDKTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:19:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB2A3AA6
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:18:53 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-000089-R6; Tue, 04 Apr 2023 12:18:45 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-008tRk-2F; Tue, 04 Apr 2023 12:18:45 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkR-005nnP-Mp; Tue, 04 Apr 2023 12:18:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v1 4/7] net: dsa: microchip: ksz8_r_sta_mac_table(): Avoid using error code for empty entries
Date:   Tue,  4 Apr 2023 12:18:39 +0200
Message-Id: <20230404101842.1382986-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404101842.1382986-1-o.rempel@pengutronix.de>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
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

Prepare for the next patch by ensuring that ksz8_r_sta_mac_table() does
not use error codes for empty entries. This change will enable better
handling of read/write errors in the upcoming patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 87 +++++++++++++++++------------
 1 file changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index fc079d6eee80..4dcf68a7f6c0 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -458,7 +458,7 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 }
 
 static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-				struct alu_struct *alu)
+				struct alu_struct *alu, bool *valid)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
@@ -471,28 +471,32 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
 	data_hi = data >> 32;
 	data_lo = (u32)data;
-	if (data_hi & (masks[STATIC_MAC_TABLE_VALID] |
-			masks[STATIC_MAC_TABLE_OVERRIDE])) {
-		alu->mac[5] = (u8)data_lo;
-		alu->mac[4] = (u8)(data_lo >> 8);
-		alu->mac[3] = (u8)(data_lo >> 16);
-		alu->mac[2] = (u8)(data_lo >> 24);
-		alu->mac[1] = (u8)data_hi;
-		alu->mac[0] = (u8)(data_hi >> 8);
-		alu->port_forward =
-			(data_hi & masks[STATIC_MAC_TABLE_FWD_PORTS]) >>
-				shifts[STATIC_MAC_FWD_PORTS];
-		alu->is_override =
-			(data_hi & masks[STATIC_MAC_TABLE_OVERRIDE]) ? 1 : 0;
-		data_hi >>= 1;
-		alu->is_static = true;
-		alu->is_use_fid =
-			(data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ? 1 : 0;
-		alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
-				shifts[STATIC_MAC_FID];
+
+	if (!(data_hi & (masks[STATIC_MAC_TABLE_VALID] |
+			 masks[STATIC_MAC_TABLE_OVERRIDE]))) {
+		*valid = false;
 		return 0;
 	}
-	return -ENXIO;
+
+	alu->mac[5] = (u8)data_lo;
+	alu->mac[4] = (u8)(data_lo >> 8);
+	alu->mac[3] = (u8)(data_lo >> 16);
+	alu->mac[2] = (u8)(data_lo >> 24);
+	alu->mac[1] = (u8)data_hi;
+	alu->mac[0] = (u8)(data_hi >> 8);
+	alu->port_forward =
+		(data_hi & masks[STATIC_MAC_TABLE_FWD_PORTS]) >>
+			shifts[STATIC_MAC_FWD_PORTS];
+	alu->is_override = (data_hi & masks[STATIC_MAC_TABLE_OVERRIDE]) ? 1 : 0;
+	data_hi >>= 1;
+	alu->is_static = true;
+	alu->is_use_fid = (data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ? 1 : 0;
+	alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
+		shifts[STATIC_MAC_FID];
+
+	*valid = true;
+
+	return 0;
 }
 
 void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
@@ -993,20 +997,25 @@ static int ksz8_add_sta_mac(struct ksz_device *dev, int port,
 			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
-	int index;
+	int index, ret;
 	int empty = 0;
 
 	alu.port_forward = 0;
 	for (index = 0; index < dev->info->num_statics; index++) {
-		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
-			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, addr, ETH_ALEN) &&
-			    alu.fid == vid)
-				break;
-		/* Remember the first empty entry. */
-		} else if (!empty) {
-			empty = index + 1;
+		bool valid;
+
+		ret = ksz8_r_sta_mac_table(dev, index, &alu, &valid);
+		if (ret)
+			return ret;
+		if (!valid) {
+			/* Remember the first empty entry. */
+			if (!empty)
+				empty = index + 1;
+			continue;
 		}
+
+		if (!memcmp(alu.mac, addr, ETH_ALEN) && alu.fid == vid)
+			break;
 	}
 
 	/* no available entry */
@@ -1036,15 +1045,19 @@ static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
 			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
-	int index;
+	int index, ret;
 
 	for (index = 0; index < dev->info->num_statics; index++) {
-		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
-			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, addr, ETH_ALEN) &&
-			    alu.fid == vid)
-				break;
-		}
+		bool valid;
+
+		ret = ksz8_r_sta_mac_table(dev, index, &alu, &valid);
+		if (ret)
+			return ret;
+		if (!valid)
+			continue;
+
+		if (!memcmp(alu.mac, addr, ETH_ALEN) && alu.fid == vid)
+			break;
 	}
 
 	/* no available entry */
-- 
2.39.2

