Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C83463A7B5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiK1MBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiK1MAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E5718B20
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:47 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoR-0005He-38; Mon, 28 Nov 2022 13:00:39 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoP-000oB0-F0; Mon, 28 Nov 2022 13:00:38 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoO-00H6P9-08; Mon, 28 Nov 2022 13:00:36 +0100
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
Subject: [PATCH v1 13/26] net: dsa: microchip: ksz8: add fdb_add/del support
Date:   Mon, 28 Nov 2022 13:00:21 +0100
Message-Id: <20221128120034.4075562-14-o.rempel@pengutronix.de>
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

Provide access to the static MAC table over fdb_add/del callbacks.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h       |  4 ++++
 drivers/net/dsa/microchip/ksz8795.c    | 12 ++++++++++++
 drivers/net/dsa/microchip/ksz_common.c |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 96d453af17c5..a28fa7cd4d98 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -30,6 +30,10 @@ void ksz8_freeze_mib(struct ksz_device *dev, int port, bool freeze);
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
index d16dc8e5ed18..208cf4dde397 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1077,6 +1077,18 @@ int ksz8_mdb_del(struct ksz_device *dev, int port,
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
index afb846c18b57..171cb0063fbf 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -197,6 +197,8 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.fdb_dump = ksz8_fdb_dump,
+	.fdb_add = ksz8_fdb_add,
+	.fdb_del = ksz8_fdb_del,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
-- 
2.30.2

