Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324AE6D5D04
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjDDKTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbjDDKTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:19:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EE93AB1
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:18:55 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkU-000087-8E; Tue, 04 Apr 2023 12:18:46 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkS-008tRe-No; Tue, 04 Apr 2023 12:18:44 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkR-005nn5-LQ; Tue, 04 Apr 2023 12:18:43 +0200
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
Subject: [PATCH net-next v1 2/7] net: dsa: microchip: ksz8: Implement add/del_fdb and use static MAC table operations
Date:   Tue,  4 Apr 2023 12:18:37 +0200
Message-Id: <20230404101842.1382986-3-o.rempel@pengutronix.de>
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

Add support for add/del_fdb operations and utilize the refactored static
MAC table code. This resolves kernel warnings caused by the lack of fdb
add function support in the current driver.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h       |  4 ++++
 drivers/net/dsa/microchip/ksz8795.c    | 12 ++++++++++++
 drivers/net/dsa/microchip/ksz_common.c |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 9bb19764fa33..ad2c3a72a576 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -32,6 +32,10 @@ void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze);
 void ksz8_port_init_cnt(struct ksz_device *dev, int port);
 int ksz8_fdb_dump(struct ksz_device *dev, int port,
 		  dsa_fdb_dump_cb_t *cb, void *data);
+int ksz8_fdb_add(struct ksz_device *dev, int port, const unsigned char *addr,
+		 u16 vid, struct dsa_db db);
+int ksz8_fdb_del(struct ksz_device *dev, int port, const unsigned char *addr,
+		 u16 vid, struct dsa_db db);
 int ksz8_mdb_add(struct ksz_device *dev, int port,
 		 const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
 int ksz8_mdb_del(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 97a6c5516673..ee68e166fc44 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1073,6 +1073,18 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
 	return ksz8_del_sta_mac(dev, port, mdb->addr, mdb->vid);
 }
 
+int ksz8_fdb_add(struct ksz_device *dev, int port, const unsigned char *addr,
+		 u16 vid, struct dsa_db db)
+{
+	return ksz8_add_sta_mac(dev, port, addr, vid);
+}
+
+int ksz8_fdb_del(struct ksz_device *dev, int port, const unsigned char *addr,
+		 u16 vid, struct dsa_db db)
+{
+	return ksz8_del_sta_mac(dev, port, addr, vid);
+}
+
 int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 			     struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 93131347ad98..6e19ad70c671 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -200,6 +200,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.fdb_dump = ksz8_fdb_dump,
+	.fdb_add = ksz8_fdb_add,
+	.fdb_del = ksz8_fdb_del,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
-- 
2.39.2

