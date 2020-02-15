Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAC315FF4D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgBOQyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:54:39 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:32796 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgBOQyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 11:54:39 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48KbvH4k0Cz1rVw0;
        Sat, 15 Feb 2020 17:54:33 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48KbvF2FzXz1r0bv;
        Sat, 15 Feb 2020 17:54:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id k7wq_l9hhaTc; Sat, 15 Feb 2020 17:54:32 +0100 (CET)
X-Auth-Info: W/MsjhbtyjA9D9aA3xY/KJvurE8AfgajsUwwJfDv6Y0=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 15 Feb 2020 17:54:31 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V2 1/3] net: ks8851-ml: Remove 8-bit bus accessors
Date:   Sat, 15 Feb 2020 17:54:17 +0100
Message-Id: <20200215165419.3901611-1-marex@denx.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver is mixing 8-bit and 16-bit bus accessors for reasons unknown,
however the speculation is that this was some sort of attempt to support
the 8-bit bus mode.

As per the KS8851-16MLL documentation, all two registers accessed via the
8-bit accessors are internally 16-bit registers, so reading them using
16-bit accessors is fine. The KS_CCR read can be converted to 16-bit read
outright, as it is already a concatenation of two 8-bit reads of that
register. The KS_RXQCR accesses are 8-bit only, however writing the top
8 bits of the register is OK as well, since the driver caches the entire
16-bit register value anyway.

Finally, the driver is not used by any hardware in the kernel right now.
The only hardware available to me is one with 16-bit bus, so I have no
way to test the 8-bit bus mode, however it is unlikely this ever really
worked anyway. If the 8-bit bus mode is ever required, it can be easily
added by adjusting the 16-bit accessors to do 2 consecutive accesses,
which is how this should have been done from the beginning.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: No change
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 45 +++---------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index a41a90c589db..e2fb20154511 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -156,24 +156,6 @@ static int msg_enable;
  * chip is busy transferring packet data (RX/TX FIFO accesses).
  */
 
-/**
- * ks_rdreg8 - read 8 bit register from device
- * @ks	  : The chip information
- * @offset: The register address
- *
- * Read a 8bit register from the chip, returning the result
- */
-static u8 ks_rdreg8(struct ks_net *ks, int offset)
-{
-	u16 data;
-	u8 shift_bit = offset & 0x03;
-	u8 shift_data = (offset & 1) << 3;
-	ks->cmd_reg_cache = (u16) offset | (u16)(BE0 << shift_bit);
-	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
-	data  = ioread16(ks->hw_addr);
-	return (u8)(data >> shift_data);
-}
-
 /**
  * ks_rdreg16 - read 16 bit register from device
  * @ks	  : The chip information
@@ -189,22 +171,6 @@ static u16 ks_rdreg16(struct ks_net *ks, int offset)
 	return ioread16(ks->hw_addr);
 }
 
-/**
- * ks_wrreg8 - write 8bit register value to chip
- * @ks: The chip information
- * @offset: The register address
- * @value: The value to write
- *
- */
-static void ks_wrreg8(struct ks_net *ks, int offset, u8 value)
-{
-	u8  shift_bit = (offset & 0x03);
-	u16 value_write = (u16)(value << ((offset & 1) << 3));
-	ks->cmd_reg_cache = (u16)offset | (BE0 << shift_bit);
-	iowrite16(ks->cmd_reg_cache, ks->hw_addr_cmd);
-	iowrite16(value_write, ks->hw_addr);
-}
-
 /**
  * ks_wrreg16 - write 16bit register value to chip
  * @ks: The chip information
@@ -324,8 +290,7 @@ static void ks_read_config(struct ks_net *ks)
 	u16 reg_data = 0;
 
 	/* Regardless of bus width, 8 bit read should always work.*/
-	reg_data = ks_rdreg8(ks, KS_CCR) & 0x00FF;
-	reg_data |= ks_rdreg8(ks, KS_CCR+1) << 8;
+	reg_data = ks_rdreg16(ks, KS_CCR);
 
 	/* addr/data bus are multiplexed */
 	ks->sharedbus = (reg_data & CCR_SHARED) == CCR_SHARED;
@@ -429,7 +394,7 @@ static inline void ks_read_qmu(struct ks_net *ks, u16 *buf, u32 len)
 
 	/* 1. set sudo DMA mode */
 	ks_wrreg16(ks, KS_RXFDPR, RXFDPR_RXFPAI);
-	ks_wrreg8(ks, KS_RXQCR, (ks->rc_rxqcr | RXQCR_SDA) & 0xff);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 
 	/* 2. read prepend data */
 	/**
@@ -446,7 +411,7 @@ static inline void ks_read_qmu(struct ks_net *ks, u16 *buf, u32 len)
 	ks_inblk(ks, buf, ALIGN(len, 4));
 
 	/* 4. reset sudo DMA Mode */
-	ks_wrreg8(ks, KS_RXQCR, ks->rc_rxqcr);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 }
 
 /**
@@ -679,13 +644,13 @@ static void ks_write_qmu(struct ks_net *ks, u8 *pdata, u16 len)
 	ks->txh.txw[1] = cpu_to_le16(len);
 
 	/* 1. set sudo-DMA mode */
-	ks_wrreg8(ks, KS_RXQCR, (ks->rc_rxqcr | RXQCR_SDA) & 0xff);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 	/* 2. write status/lenth info */
 	ks_outblk(ks, ks->txh.txw, 4);
 	/* 3. write pkt data */
 	ks_outblk(ks, (u16 *)pdata, ALIGN(len, 4));
 	/* 4. reset sudo-DMA mode */
-	ks_wrreg8(ks, KS_RXQCR, ks->rc_rxqcr);
+	ks_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
 	/* 5. Enqueue Tx(move the pkt from TX buffer into TXQ) */
 	ks_wrreg16(ks, KS_TXQCR, TXQCR_METFE);
 	/* 6. wait until TXQCR_METFE is auto-cleared */
-- 
2.25.0

