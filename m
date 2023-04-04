Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995CF6D5CFF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjDDKTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjDDKTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:19:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5297A3AAE
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:18:55 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-000088-R9; Tue, 04 Apr 2023 12:18:46 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-008tRj-1K; Tue, 04 Apr 2023 12:18:45 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkR-005nmv-Ke; Tue, 04 Apr 2023 12:18:43 +0200
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
Subject: [PATCH net-next v1 1/7] net: dsa: microchip: ksz8: Separate static MAC table operations for code reuse
Date:   Tue,  4 Apr 2023 12:18:36 +0200
Message-Id: <20230404101842.1382986-2-o.rempel@pengutronix.de>
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

Move static MAC table operations to separate functions in order to reuse
the code for add/del_fdb. This is needed to address kernel warnings
caused by the lack of fdb add function support in the current driver.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 34 +++++++++++++++++++----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8917f22f90d2..97a6c5516673 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -989,8 +989,8 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	return ret;
 }
 
-int ksz8_mdb_add(struct ksz_device *dev, int port,
-		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+static int ksz8_add_sta_mac(struct ksz_device *dev, int port,
+			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
 	int index;
@@ -1000,8 +1000,8 @@ int ksz8_mdb_add(struct ksz_device *dev, int port,
 	for (index = 0; index < dev->info->num_statics; index++) {
 		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
-			    alu.fid == mdb->vid)
+			if (!memcmp(alu.mac, addr, ETH_ALEN) &&
+			    alu.fid == vid)
 				break;
 		/* Remember the first empty entry. */
 		} else if (!empty) {
@@ -1017,23 +1017,23 @@ int ksz8_mdb_add(struct ksz_device *dev, int port,
 	if (index == dev->info->num_statics) {
 		index = empty - 1;
 		memset(&alu, 0, sizeof(alu));
-		memcpy(alu.mac, mdb->addr, ETH_ALEN);
+		memcpy(alu.mac, addr, ETH_ALEN);
 		alu.is_static = true;
 	}
 	alu.port_forward |= BIT(port);
-	if (mdb->vid) {
+	if (vid) {
 		alu.is_use_fid = true;
 
 		/* Need a way to map VID to FID. */
-		alu.fid = mdb->vid;
+		alu.fid = vid;
 	}
 	ksz8_w_sta_mac_table(dev, index, &alu);
 
 	return 0;
 }
 
-int ksz8_mdb_del(struct ksz_device *dev, int port,
-		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+static int ksz8_del_sta_mac(struct ksz_device *dev, int port,
+			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
 	int index;
@@ -1041,8 +1041,8 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
 	for (index = 0; index < dev->info->num_statics; index++) {
 		if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
-			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
-			    alu.fid == mdb->vid)
+			if (!memcmp(alu.mac, addr, ETH_ALEN) &&
+			    alu.fid == vid)
 				break;
 		}
 	}
@@ -1061,6 +1061,18 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
+int ksz8_mdb_add(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+{
+	return ksz8_add_sta_mac(dev, port, mdb->addr, mdb->vid);
+}
+
+int ksz8_mdb_del(struct ksz_device *dev, int port,
+		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+{
+	return ksz8_del_sta_mac(dev, port, mdb->addr, mdb->vid);
+}
+
 int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 			     struct netlink_ext_ack *extack)
 {
-- 
2.39.2

