Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9027763A7CA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiK1MCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiK1MAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA5418E1E
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:50 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoT-0005MO-Kl; Mon, 28 Nov 2022 13:00:41 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoS-000oBm-6A; Mon, 28 Nov 2022 13:00:40 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoN-00H6Ot-Ui; Mon, 28 Nov 2022 13:00:35 +0100
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
Subject: [PATCH v1 12/26] net: dsa: microchip: ksz8: move static mac table operations to a separate functions
Date:   Mon, 28 Nov 2022 13:00:20 +0100
Message-Id: <20221128120034.4075562-13-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
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

We need it to reuse the code for add/del_fdb

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 34 +++++++++++++++++++----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 392f6cb1f706..d16dc8e5ed18 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -993,8 +993,8 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	return 0;
 }
 
-int ksz8_mdb_add(struct ksz_device *dev, int port,
-		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
+static int ksz8_add_sta_mac(struct ksz_device *dev, int port,
+			    const unsigned char *addr, u16 vid)
 {
 	struct alu_struct alu;
 	int index;
@@ -1004,8 +1004,8 @@ int ksz8_mdb_add(struct ksz_device *dev, int port,
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
@@ -1021,23 +1021,23 @@ int ksz8_mdb_add(struct ksz_device *dev, int port,
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
@@ -1045,8 +1045,8 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
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
@@ -1065,6 +1065,18 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
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
2.30.2

