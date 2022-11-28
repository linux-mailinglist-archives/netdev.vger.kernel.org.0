Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3977663A792
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiK1MA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiK1MAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3451186E2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:16 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnr-0003n2-NM; Mon, 28 Nov 2022 13:00:03 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnp-000o8S-IO; Mon, 28 Nov 2022 13:00:02 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnn-00Gzck-NJ; Mon, 28 Nov 2022 12:59:59 +0100
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
Subject: [PATCH v1 02/26] net: dsa: microchip: ksz8: ksz8_fdb_dump: fix port validation and VID information
Date:   Mon, 28 Nov 2022 12:59:34 +0100
Message-Id: <20221128115958.4049431-3-o.rempel@pengutronix.de>
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

The ksz8_fdb_dump() has multiple issues:
- struct alu_struct was used only to store MAC address.
- port value was misinterpreted as a bit mask
- Filter ID was attempted to use as VID. FID can be used to get VID, but
  currently it is not supported.
- by the attempt to use FID, was used not initialized alu.fid...

Before this patch, "bridge fdb" command was providing random results,
which are fixed by this patch:
- random vid information
- assignment to wrong port

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 003b0ac2854c..e0530bc3bec0 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -958,15 +958,14 @@ int ksz8_fdb_dump(struct ksz_device *dev, int port,
 	u16 entries = 0;
 	u8 timestamp = 0;
 	u8 fid;
-	u8 member;
-	struct alu_struct alu;
+	u8 src_port;
+	u8 mac[ETH_ALEN];
 
 	do {
-		alu.is_static = false;
-		ret = ksz8_r_dyn_mac_table(dev, i, alu.mac, &fid, &member,
+		ret = ksz8_r_dyn_mac_table(dev, i, mac, &fid, &src_port,
 					   &timestamp, &entries);
-		if (!ret && (member & BIT(port))) {
-			ret = cb(alu.mac, alu.fid, alu.is_static, data);
+		if (!ret && port == src_port) {
+			ret = cb(mac, 0, false, data);
 			if (ret)
 				break;
 		}
-- 
2.30.2

