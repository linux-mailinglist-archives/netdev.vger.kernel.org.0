Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3C2CADAF
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgLAUqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLAUqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:46:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FA8C061A4A
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:45:13 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWN-0002sy-37; Tue, 01 Dec 2020 21:45:11 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWK-0002c4-6p; Tue, 01 Dec 2020 21:45:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 10/11] net: dsa: microchip: ksz8795: use port_cnt instead of TOTOAL_PORT_NUM
Date:   Tue,  1 Dec 2020 21:45:05 +0100
Message-Id: <20201201204506.13473-11-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
References: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To get the driver working with other chips using different port counts
the dyn_mac_table should be flushed depending on the amount of available
ports. This patch remove the extra define TOTOAL_PORT_NUM and is
making use of the dynamic port_cnt variable instead.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1:       - based on "[PATCH v4 05/11] net: dsa: microchip: ksz8795: dynamica allocate memory for flush_dyn_mac_table"
          - lore: https://lore.kernel.org/netdev/20200803054442.20089-6-m.grzeschik@pengutronix.de/
v1 -> v2: - renamed patch to clarify the purpose
            - based on: https://lore.kernel.org/netdev/20201118220357.22292-11-m.grzeschik@pengutronix.de/
          - using DSA_MAX_PORTS instead of dynamic kzalloc allocation
          - improved patch description
---
 drivers/net/dsa/microchip/ksz8795.c     | 4 ++--
 drivers/net/dsa/microchip/ksz8795_reg.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7b5c9283712e4..b13ac57ab8bba 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -751,11 +751,11 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 
 static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
-	u8 learn[TOTAL_PORT_NUM];
+	u8 learn[DSA_MAX_PORTS];
 	int first, index, cnt;
 	struct ksz_port *p;
 
-	if ((uint)port < TOTAL_PORT_NUM) {
+	if ((uint)port < dev->port_cnt) {
 		first = port;
 		cnt = port + 1;
 	} else {
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 6377165a236fd..681d19ab27b89 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -846,8 +846,6 @@
 
 #define KS_PRIO_IN_REG			4
 
-#define TOTAL_PORT_NUM			5
-
 #define KSZ8795_COUNTER_NUM		0x20
 
 /* Common names used by other drivers */
-- 
2.29.2

