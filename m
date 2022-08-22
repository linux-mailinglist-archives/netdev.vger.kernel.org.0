Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CE559BE32
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiHVLEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbiHVLEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:04:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7C127B3B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:04:24 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Dx-0005S0-Fs; Mon, 22 Aug 2022 13:04:05 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Dw-001Hme-MC; Mon, 22 Aug 2022 13:04:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Ds-009gyq-Ce; Mon, 22 Aug 2022 13:04:00 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 05/17] net: dsa: microchip: forward error value on all ksz_pread/ksz_pwrite functions
Date:   Mon, 22 Aug 2022 13:03:46 +0200
Message-Id: <20220822110358.2310055-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822110358.2310055-1-o.rempel@pengutronix.de>
References: <20220822110358.2310055-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz_read*/ksz_write* are able to return errors, so forward it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index baaeb60533faf..be0e5d6ef2bf0 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -393,40 +393,42 @@ static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 	return regmap_bulk_write(dev->regmap[2], reg, val, 2);
 }
 
-static inline void ksz_pread8(struct ksz_device *dev, int port, int offset,
+static inline int ksz_pread8(struct ksz_device *dev, int port, int offset,
 			      u8 *data)
 {
-	ksz_read8(dev, dev->dev_ops->get_port_addr(port, offset), data);
+	return ksz_read8(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
-static inline void ksz_pread16(struct ksz_device *dev, int port, int offset,
+static inline int ksz_pread16(struct ksz_device *dev, int port, int offset,
 			       u16 *data)
 {
-	ksz_read16(dev, dev->dev_ops->get_port_addr(port, offset), data);
+	return ksz_read16(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
-static inline void ksz_pread32(struct ksz_device *dev, int port, int offset,
+static inline int ksz_pread32(struct ksz_device *dev, int port, int offset,
 			       u32 *data)
 {
-	ksz_read32(dev, dev->dev_ops->get_port_addr(port, offset), data);
+	return ksz_read32(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
-static inline void ksz_pwrite8(struct ksz_device *dev, int port, int offset,
+static inline int ksz_pwrite8(struct ksz_device *dev, int port, int offset,
 			       u8 data)
 {
-	ksz_write8(dev, dev->dev_ops->get_port_addr(port, offset), data);
+	return ksz_write8(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
-static inline void ksz_pwrite16(struct ksz_device *dev, int port, int offset,
+static inline int ksz_pwrite16(struct ksz_device *dev, int port, int offset,
 				u16 data)
 {
-	ksz_write16(dev, dev->dev_ops->get_port_addr(port, offset), data);
+	return ksz_write16(dev, dev->dev_ops->get_port_addr(port, offset),
+			   data);
 }
 
-static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
+static inline int ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 				u32 data)
 {
-	ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset), data);
+	return ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset),
+			   data);
 }
 
 static inline void ksz_prmw8(struct ksz_device *dev, int port, int offset,
-- 
2.30.2

