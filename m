Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A9563A79C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiK1MBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiK1MAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D2518E2B
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:18 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcns-0003pN-P3; Mon, 28 Nov 2022 13:00:04 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnr-000o9F-52; Mon, 28 Nov 2022 13:00:03 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnn-00Gzdu-RN; Mon, 28 Nov 2022 12:59:59 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v1 10/26] net: dsa: microchip: ksz8: refactor ksz8_fdb_dump()
Date:   Mon, 28 Nov 2022 12:59:42 +0100
Message-Id: <20221128115958.4049431-11-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128115958.4049431-1-o.rempel@pengutronix.de>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After fixing different bugs we can refactor this function:
- be paranoid - read only max possibly amount of entries supported by
  the HW.
- pass error values returned by regmap

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c     | 41 ++++++++++++++-----------
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 +
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 736cf4e54333..308b46bb2ce5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -949,26 +949,31 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 int ksz8_fdb_dump(struct ksz_device *dev, int port,
 		  dsa_fdb_dump_cb_t *cb, void *data)
 {
-	int ret = 0;
-	u16 i = 0;
-	u16 entries = 0;
-	u8 src_port;
-	u8 mac[ETH_ALEN];
+	u16 i, entries = 0;
+	int ret;
 
-	do {
-		ret = ksz8_r_dyn_mac_table(dev, i, mac, &src_port,
-					   &entries);
-		if (!ret && port == src_port) {
-			ret = cb(mac, 0, false, data);
-			if (ret)
-				break;
-		}
-		i++;
-	} while (i < entries);
-	if (i >= entries)
-		ret = 0;
+	for (i = 0; i < KSZ8_DYN_MAC_ENTRIES; i++) {
+		u8 mac[ETH_ALEN];
+		u8 src_port;
 
-	return ret;
+		ret = ksz8_r_dyn_mac_table(dev, i, mac, &src_port, &entries);
+		if (ret == -ENXIO)
+			return 0;
+		if (ret)
+			return ret;
+
+		if (i >= entries)
+			return 0;
+
+		if (port != src_port)
+			continue;
+
+		ret = cb(mac, 0, false, data);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 int ksz8_mdb_add(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 7a57c6088f80..0bdceb534192 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -811,5 +811,6 @@
 #define TAIL_TAG_LOOKUP			BIT(7)
 
 #define FID_ENTRIES			128
+#define KSZ8_DYN_MAC_ENTRIES		1024
 
 #endif
-- 
2.30.2

