Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E826B192B13
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgCYOZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:25:57 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52926 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgCYOZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:25:57 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nVlj3L02z1rtyS;
        Wed, 25 Mar 2020 15:25:52 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nVlh4QLTz1qqkL;
        Wed, 25 Mar 2020 15:25:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 4IiR2WJ4rxXc; Wed, 25 Mar 2020 15:25:51 +0100 (CET)
X-Auth-Info: xGtY6wJcdIrptKmF2AWLQPmmJHt2noMdGsVbxlgWqV8=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 15:25:51 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net: ks8851-ml: Fix IO operations, again
Date:   Wed, 25 Mar 2020 15:25:47 +0100
Message-Id: <20200325142547.45393-1-marex@denx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reverts 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
and edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access"), because it
turns out these were only necessary due to buggy hardware. This patch adds
a check for such a buggy hardware to prevent any such mistakes again.

While working further on the KS8851 driver, it came to light that the
KS8851-16MLL is capable of switching bus endianness by a hardware strap,
EESK pin. If this strap is incorrect, the IO accesses require such endian
swapping as is being reverted by this patch. Such swapping also impacts
the performance significantly.

Hence, in addition to removing it, detect that the hardware is broken,
report to user, and fail to bind with such hardware.

Fixes: 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
Fixes: edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
NOTE: I tested this with KS8851-16MLL in both EESK settings, sorry for
      the problems these previous patches caused.
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 56 ++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index 58579baf3f7a..45cc840d8e2e 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -156,6 +156,50 @@ static int msg_enable;
  * chip is busy transferring packet data (RX/TX FIFO accesses).
  */
 
+/**
+ * ks_check_endian - Check whether endianness of the bus is correct
+ * @ks	  : The chip information
+ *
+ * The KS8851-16MLL EESK pin allows selecting the endianness of the 16bit
+ * bus. To maintain optimum performance, the bus endianness should be set
+ * such that it matches the endianness of the CPU.
+ */
+
+static int ks_check_endian(struct ks_net *ks)
+{
+	u16 cider;
+
+	/*
+	 * Read CIDER register first, however read it the "wrong" way around.
+	 * If the endian strap on the KS8851-16MLL in incorrect and the chip
+	 * is operating in different endianness than the CPU, then the meaning
+	 * of BE[3:0] byte-enable bits is also swapped such that:
+	 *    BE[3,2,1,0] becomes BE[1,0,3,2]
+	 *
+	 * Luckily for us, the byte-enable bits are the top four MSbits of
+	 * the address register and the CIDER register is at offset 0xc0.
+	 * Hence, by reading address 0xc0c0, which is not impacted by endian
+	 * swapping, we assert either BE[3:2] or BE[1:0] while reading the
+	 * CIDER register.
+	 *
+	 * If the bus configuration is correct, reading 0xc0c0 asserts
+	 * BE[3:2] and this read returns 0x0000, because to read register
+	 * with bottom two LSbits of address set to 0, BE[1:0] must be
+	 * asserted.
+	 *
+	 * If the bus configuration is NOT correct, reading 0xc0c0 asserts
+	 * BE[1:0] and this read returns non-zero 0x8872 value.
+	 */
+	iowrite16(BE3 | BE2 | KS_CIDER, ks->hw_addr_cmd);
+	cider = ioread16(ks->hw_addr);
+	if (!cider)
+		return 0;
+
+	netdev_err(ks->netdev, "incorrect EESK endian strap setting\n");
+
+	return -EINVAL;
+}
+
 /**
  * ks_rdreg16 - read 16 bit register from device
  * @ks	  : The chip information
@@ -166,7 +210,7 @@ static int msg_enable;
 
 static u16 ks_rdreg16(struct ks_net *ks, int offset)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	return ioread16(ks->hw_addr);
 }
@@ -181,7 +225,7 @@ static u16 ks_rdreg16(struct ks_net *ks, int offset)
 
 static void ks_wrreg16(struct ks_net *ks, int offset, u16 value)
 {
-	ks->cmd_reg_cache = (u16)offset | ((BE3 | BE2) >> (offset & 0x02));
+	ks->cmd_reg_cache = (u16)offset | ((BE1 | BE0) << (offset & 0x02));
 	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
 	iowrite16(value, ks->hw_addr);
 }
@@ -197,7 +241,7 @@ static inline void ks_inblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		*wptr++ = be16_to_cpu(ioread16(ks->hw_addr));
+		*wptr++ = (u16)ioread16(ks->hw_addr);
 }
 
 /**
@@ -211,7 +255,7 @@ static inline void ks_outblk(struct ks_net *ks, u16 *wptr, u32 len)
 {
 	len >>= 1;
 	while (len--)
-		iowrite16(cpu_to_be16(*wptr++), ks->hw_addr);
+		iowrite16(*wptr++, ks->hw_addr);
 }
 
 static void ks_disable_int(struct ks_net *ks)
@@ -1218,6 +1262,10 @@ static int ks8851_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
+	err = ks_check_endian(ks);
+	if (err)
+		goto err_free;
+
 	netdev->irq = platform_get_irq(pdev, 0);
 
 	if ((int)netdev->irq < 0) {
-- 
2.25.1

