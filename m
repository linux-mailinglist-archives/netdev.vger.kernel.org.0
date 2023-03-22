Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3506C4DC0
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCVOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjCVObs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:31:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A954562B76
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:31:47 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pezV1-0003Oo-Ay; Wed, 22 Mar 2023 15:31:35 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pezUx-005wW3-ST; Wed, 22 Mar 2023 15:31:31 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pezUx-0060Zc-2B; Wed, 22 Mar 2023 15:31:31 +0100
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
Subject: [PATCH net v1 1/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
Date:   Wed, 22 Mar 2023 15:31:25 +0100
Message-Id: <20230322143130.1432106-2-o.rempel@pengutronix.de>
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

Before this patch, the ksz8_fdb_dump() function had several issues, such
as uninitialized variables and incorrect usage of source port as a bit
mask. These problems caused inaccurate reporting of vid information and
port assignment in the bridge fdb.

Fixes: e587be759e6e ("net: dsa: microchip: update fdb add/del/dump in ksz_common")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 003b0ac2854c..3fffd5da8d3b 100644
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
+			ret = cb(mac, fid, false, data);
 			if (ret)
 				break;
 		}
-- 
2.30.2

