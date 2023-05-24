Return-Path: <netdev+bounces-5000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B8A70F682
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C142D28142D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84270C8D1;
	Wed, 24 May 2023 12:32:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06618C06
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:32:35 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B4E139
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:32:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfE-0006vq-2r; Wed, 24 May 2023 14:32:24 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfC-002TzA-SI; Wed, 24 May 2023 14:32:22 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfB-00APZs-MT; Wed, 24 May 2023 14:32:21 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 1/5] net: dsa: microchip: improving error handling for 8-bit register RMW operations
Date: Wed, 24 May 2023 14:32:16 +0200
Message-Id: <20230524123220.2481565-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524123220.2481565-1-o.rempel@pengutronix.de>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
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

This patch refines the error handling mechanism for 8-bit register
read-modify-write operations. In case of a failure, it now logs an error
message detailing the problematic offset. This enhancement aids in
debugging by providing more precise information when these operations
encounter issues.

Furthermore, the ksz_prmw8() function has been updated to return error
values rather than void, enabling calling functions to appropriately
respond to errors.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.h | 28 ++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8abecaf6089e..b86f1e27a0c3 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -508,7 +508,14 @@ static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 
 static inline int ksz_rmw8(struct ksz_device *dev, int offset, u8 mask, u8 val)
 {
-	return regmap_update_bits(dev->regmap[0], offset, mask, val);
+	int ret;
+
+	ret = regmap_update_bits(dev->regmap[0], offset, mask, val);
+	if (ret)
+		dev_err(dev->dev, "can't rmw 8bit reg 0x%x: %pe\n", offset,
+			ERR_PTR(ret));
+
+	return ret;
 }
 
 static inline int ksz_pread8(struct ksz_device *dev, int port, int offset,
@@ -549,12 +556,21 @@ static inline int ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 			   data);
 }
 
-static inline void ksz_prmw8(struct ksz_device *dev, int port, int offset,
-			     u8 mask, u8 val)
+static inline int ksz_prmw8(struct ksz_device *dev, int port, int offset,
+			    u8 mask, u8 val)
 {
-	regmap_update_bits(dev->regmap[0],
-			   dev->dev_ops->get_port_addr(port, offset),
-			   mask, val);
+	int ret;
+
+	ret = regmap_update_bits(dev->regmap[0],
+				 dev->dev_ops->get_port_addr(port, offset),
+				 mask, val);
+	if (ret)
+		dev_err(dev->dev, "can't rmw 8bit reg 0x%x: %pe\n",
+			dev->dev_ops->get_port_addr(port, offset),
+			ERR_PTR(ret));
+
+	return ret;
+
 }
 
 static inline void ksz_regmap_lock(void *__mtx)
-- 
2.39.2


