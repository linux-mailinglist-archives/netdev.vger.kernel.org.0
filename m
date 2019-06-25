Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF155C92
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfFYXqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:46:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48899 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFYXp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:45:59 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45YN8Q0tj8z1rlwr;
        Wed, 26 Jun 2019 01:45:58 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45YN8Q0NQXz20V2L;
        Wed, 26 Jun 2019 01:45:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id PNi0gJwZMrp1; Wed, 26 Jun 2019 01:45:57 +0200 (CEST)
X-Auth-Info: WOSgP83qjc8uzDE0/hSaiyntUCWHtQo7CQ3THVNNPRg=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 26 Jun 2019 01:45:56 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V4 06/10] net: dsa: microchip: Factor out register access opcode generation
Date:   Wed, 26 Jun 2019 01:43:44 +0200
Message-Id: <20190625234348.16246-7-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625234348.16246-1-marex@denx.de>
References: <20190625234348.16246-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the code which sends out the register read/write opcodes
to the switch, since the code differs in single bit between read and
write.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
V2: New patch
V3: - Rebase on next/master
    - Test on KSZ9477EVB
V4: Add RB
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index a34e66eccbcd..49aeb92d36fc 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -25,19 +25,24 @@
 /* Enough to read all switch port registers. */
 #define SPI_TX_BUF_LEN			0x100
 
-static int ksz9477_spi_read_reg(struct spi_device *spi, u32 reg, u8 *val,
-				unsigned int len)
+static u32 ksz9477_spi_cmd(u32 reg, bool read)
 {
 	u32 txbuf;
-	int ret;
 
 	txbuf = reg & SPI_ADDR_MASK;
-	txbuf |= KS_SPIOP_RD << SPI_ADDR_SHIFT;
+	txbuf |= (read ? KS_SPIOP_RD : KS_SPIOP_WR) << SPI_ADDR_SHIFT;
 	txbuf <<= SPI_TURNAROUND_SHIFT;
 	txbuf = cpu_to_be32(txbuf);
 
-	ret = spi_write_then_read(spi, &txbuf, 4, val, len);
-	return ret;
+	return txbuf;
+}
+
+static int ksz9477_spi_read_reg(struct spi_device *spi, u32 reg, u8 *val,
+				unsigned int len)
+{
+	u32 txbuf = ksz9477_spi_cmd(reg, true);
+
+	return spi_write_then_read(spi, &txbuf, 4, val, len);
 }
 
 static int ksz9477_spi_write_reg(struct spi_device *spi, u32 reg, u8 *val,
@@ -45,10 +50,7 @@ static int ksz9477_spi_write_reg(struct spi_device *spi, u32 reg, u8 *val,
 {
 	u32 *txbuf = (u32 *)val;
 
-	*txbuf = reg & SPI_ADDR_MASK;
-	*txbuf |= (KS_SPIOP_WR << SPI_ADDR_SHIFT);
-	*txbuf <<= SPI_TURNAROUND_SHIFT;
-	*txbuf = cpu_to_be32(*txbuf);
+	*txbuf = ksz9477_spi_cmd(reg, false);
 
 	return spi_write(spi, txbuf, 4 + len);
 }
-- 
2.20.1

