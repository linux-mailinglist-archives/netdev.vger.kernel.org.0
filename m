Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0DC176D2A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgCCCq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgCCCq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B69D24682;
        Tue,  3 Mar 2020 02:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203617;
        bh=Rk9wq54YArR8AwJkIfvtCrBBOr/4+oP9g+gu/tchcRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8LqeeILAs1B+9RmfowqZOkUEXDaWXdbBix3RdyBxC2MXiI+z85qIhASHX0+AC0Tx
         YhpXdCZXqG7LtCPT8YO4CgbbRWQGnGo7u9e0EbUNkoqsGRuJqmktV5fNNNNH14RxRB
         WNVk/r3xZ3PmEr69A5F33lJECXHAml7lZ0jpG0nU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 33/66] net: ks8851-ml: Remove 8-bit bus accessors
Date:   Mon,  2 Mar 2020 21:45:42 -0500
Message-Id: <20200303024615.8889-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 69233bba6543a37755158ca3382765387b8078df ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_mll.c | 45 +++---------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index a41a90c589db2..e2fb20154511e 100644
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
2.20.1

