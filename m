Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A6763A79D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiK1MBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiK1MAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39D918B3D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:17 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnt-0003r6-Bl; Mon, 28 Nov 2022 13:00:05 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcnr-000o9f-Nu; Mon, 28 Nov 2022 13:00:04 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcno-00GzgP-1r; Mon, 28 Nov 2022 13:00:00 +0100
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
Subject: [PATCH v1 22/26] net: dsa: microchip: ksz8_r_sta_mac_table(): make use of error values provided by read/write functions
Date:   Mon, 28 Nov 2022 12:59:54 +0100
Message-Id: <20221128115958.4049431-23-o.rempel@pengutronix.de>
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

Read/write operations may fail. So, make use of return values.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b7487be91f67..1de33ceb50de 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -336,19 +336,26 @@ void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 	}
 }
 
-static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
+static int ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 {
 	const u16 *regs;
 	u16 ctrl_addr;
+	int ret;
 
 	regs = dev->info->regs;
 
 	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
-	ksz_read64(dev, regs[REG_IND_DATA_HI], data);
+	ret = ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	if (ret)
+		goto unlock_alu;
+
+	ret = ksz_read64(dev, regs[REG_IND_DATA_HI], data);
+unlock_alu:
 	mutex_unlock(&dev->alu_mutex);
+
+	return ret;
 }
 
 static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
@@ -463,11 +470,15 @@ static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	const u8 *shifts;
 	const u32 *masks;
 	u64 data;
+	int ret;
 
 	shifts = dev->info->shifts;
 	masks = dev->info->masks;
 
-	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
+	ret = ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
+	if (ret)
+		return ret;
+
 	data_hi = data >> 32;
 	data_lo = (u32)data;
 
-- 
2.30.2

