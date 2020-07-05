Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CEB214F63
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgGEUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:36:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgGEUgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 16:36:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBNP-003k2I-R0; Sun, 05 Jul 2020 22:36:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/3] net: dsa: b53: Fixup endianness warnings
Date:   Sun,  5 Jul 2020 22:36:23 +0200
Message-Id: <20200705203625.891900-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705203625.891900-1-andrew@lunn.ch>
References: <20200705203625.891900-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

leX_to_cpu() expects to be passed an __leX type.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/b53/b53_spi.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_spi.c b/drivers/net/dsa/b53/b53_spi.c
index f89f5308a99b..7abec8dab8ba 100644
--- a/drivers/net/dsa/b53/b53_spi.c
+++ b/drivers/net/dsa/b53/b53_spi.c
@@ -145,42 +145,52 @@ static int b53_spi_read8(struct b53_device *dev, u8 page, u8 reg, u8 *val)
 
 static int b53_spi_read16(struct b53_device *dev, u8 page, u8 reg, u16 *val)
 {
-	int ret = b53_spi_read(dev, page, reg, (u8 *)val, 2);
+	__le16 value;
+	int ret;
+
+	ret = b53_spi_read(dev, page, reg, (u8 *)&value, 2);
 
 	if (!ret)
-		*val = le16_to_cpu(*val);
+		*val = le16_to_cpu(value);
 
 	return ret;
 }
 
 static int b53_spi_read32(struct b53_device *dev, u8 page, u8 reg, u32 *val)
 {
-	int ret = b53_spi_read(dev, page, reg, (u8 *)val, 4);
+	__le32 value;
+	int ret;
+
+	ret = b53_spi_read(dev, page, reg, (u8 *)&value, 4);
 
 	if (!ret)
-		*val = le32_to_cpu(*val);
+		*val = le32_to_cpu(value);
 
 	return ret;
 }
 
 static int b53_spi_read48(struct b53_device *dev, u8 page, u8 reg, u64 *val)
 {
+	__le64 value;
 	int ret;
 
 	*val = 0;
-	ret = b53_spi_read(dev, page, reg, (u8 *)val, 6);
+	ret = b53_spi_read(dev, page, reg, (u8 *)&value, 6);
 	if (!ret)
-		*val = le64_to_cpu(*val);
+		*val = le64_to_cpu(value);
 
 	return ret;
 }
 
 static int b53_spi_read64(struct b53_device *dev, u8 page, u8 reg, u64 *val)
 {
-	int ret = b53_spi_read(dev, page, reg, (u8 *)val, 8);
+	__le64 value;
+	int ret;
+
+	ret = b53_spi_read(dev, page, reg, (u8 *)&value, 8);
 
 	if (!ret)
-		*val = le64_to_cpu(*val);
+		*val = le64_to_cpu(value);
 
 	return ret;
 }
-- 
2.27.0.rc2

