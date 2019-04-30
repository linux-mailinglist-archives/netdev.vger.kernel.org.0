Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C1CF128
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfD3HS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:26 -0400
Received: from first.geanix.com ([116.203.34.67]:43666 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfD3HSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:25 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id F1770308E98;
        Tue, 30 Apr 2019 07:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608696; bh=L4BSxf8yN7NAr/W/eSas9zI+aejeW0OdPJur/e8dozo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Tr7na9Jk3hHNyHsxJa+8gx0gY2p5qQ3Dx3Hq1ltBS443rUzo6+o7ic7h1XuCygiN4
         HOR+sL9fuqa8eYCf5BBiYXsN5gjOXnvf9UjhvsHkDBZBgSnRlY79BvS3MqTNXFn385
         9dnAGP/G4JJvtJHVrCRNqTR2Xcfoi2MmqxjiLw3FXdsd1CyuJQR/O3RBuvPRZ7jBsm
         o8mOrnZMqFX0YMwyw36PxA8w7rrM5kLDUbtAyjiANgRdRnyp42ywNEEcGENErdx4Da
         TCUmpEvfeFFUtRhkLVWJvHJfjC0JdSfCcd/ZZ/UtWAz5ZVJTmzpdYTXunncahzdgyn
         boTrNg1OZc+XA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/12] net: ll_temac: Add support for non-native register endianness
Date:   Tue, 30 Apr 2019 09:17:51 +0200
Message-Id: <20190430071759.2481-5-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the powerpc specific MMIO register access functions with the
generic big-endian mmio access functions, and add support for
little-endian access depending on configuration.

Big-endian access is maintained as the default, but little-endian can
be configured in device-tree binding or in platform data.

The temac_ior()/temac_iow() functions are replaced with macro wrappers
to avoid modifying existing code more than necessary.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h        | 12 ++--
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 87 +++++++++++++++++++++------
 include/linux/platform_data/xilinx-ll-temac.h |  2 +
 3 files changed, 79 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index e338b4f..23d8dd5 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -347,8 +347,10 @@ struct temac_local {
 #ifdef CONFIG_PPC_DCR
 	dcr_host_t sdma_dcrs;
 #endif
-	u32 (*dma_in)(struct temac_local *, int);
-	void (*dma_out)(struct temac_local *, int, u32);
+	u32 (*temac_ior)(struct temac_local *lp, int offset);
+	void (*temac_iow)(struct temac_local *lp, int offset, u32 value);
+	u32 (*dma_in)(struct temac_local *lp, int reg);
+	void (*dma_out)(struct temac_local *lp, int reg, u32 value);
 
 	int tx_irq;
 	int rx_irq;
@@ -372,9 +374,11 @@ struct temac_local {
 	int rx_bd_ci;
 };
 
+/* Wrappers for temac_ior()/temac_iow() function pointers above */
+#define temac_ior(lp, o) ((lp)->temac_ior(lp, o))
+#define temac_iow(lp, o, v) ((lp)->temac_iow(lp, o, v))
+
 /* xilinx_temac.c */
-u32 temac_ior(struct temac_local *lp, int offset);
-void temac_iow(struct temac_local *lp, int offset, u32 value);
 int temac_indirect_busywait(struct temac_local *lp);
 u32 temac_indirect_in32(struct temac_local *lp, int reg);
 void temac_indirect_out32(struct temac_local *lp, int reg, u32 value);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index bcafb89..58c6713 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -63,14 +63,24 @@
  * Low level register access functions
  */
 
-u32 temac_ior(struct temac_local *lp, int offset)
+u32 _temac_ior_be(struct temac_local *lp, int offset)
 {
-	return in_be32(lp->regs + offset);
+	return ioread32be(lp->regs + offset);
 }
 
-void temac_iow(struct temac_local *lp, int offset, u32 value)
+void _temac_iow_be(struct temac_local *lp, int offset, u32 value)
 {
-	out_be32(lp->regs + offset, value);
+	return iowrite32be(value, lp->regs + offset);
+}
+
+u32 _temac_ior_le(struct temac_local *lp, int offset)
+{
+	return ioread32(lp->regs + offset);
+}
+
+void _temac_iow_le(struct temac_local *lp, int offset, u32 value)
+{
+	return iowrite32(value, lp->regs + offset);
 }
 
 int temac_indirect_busywait(struct temac_local *lp)
@@ -121,23 +131,35 @@ void temac_indirect_out32(struct temac_local *lp, int reg, u32 value)
 }
 
 /**
- * temac_dma_in32 - Memory mapped DMA read, this function expects a
- * register input that is based on DCR word addresses which
- * are then converted to memory mapped byte addresses
+ * temac_dma_in32_* - Memory mapped DMA read, these function expects a
+ * register input that is based on DCR word addresses which are then
+ * converted to memory mapped byte addresses.  To be assigned to
+ * lp->dma_in32.
  */
-static u32 temac_dma_in32(struct temac_local *lp, int reg)
+static u32 temac_dma_in32_be(struct temac_local *lp, int reg)
 {
-	return in_be32(lp->sdma_regs + (reg << 2));
+	return ioread32be(lp->sdma_regs + (reg << 2));
+}
+
+static u32 temac_dma_in32_le(struct temac_local *lp, int reg)
+{
+	return ioread32(lp->sdma_regs + (reg << 2));
 }
 
 /**
- * temac_dma_out32 - Memory mapped DMA read, this function expects a
- * register input that is based on DCR word addresses which
- * are then converted to memory mapped byte addresses
+ * temac_dma_out32_* - Memory mapped DMA read, these function expects
+ * a register input that is based on DCR word addresses which are then
+ * converted to memory mapped byte addresses.  To be assigned to
+ * lp->dma_out32.
  */
-static void temac_dma_out32(struct temac_local *lp, int reg, u32 value)
+static void temac_dma_out32_be(struct temac_local *lp, int reg, u32 value)
+{
+	iowrite32be(value, lp->sdma_regs + (reg << 2));
+}
+
+static void temac_dma_out32_le(struct temac_local *lp, int reg, u32 value)
 {
-	out_be32(lp->sdma_regs + (reg << 2), value);
+	iowrite32(value, lp->sdma_regs + (reg << 2));
 }
 
 /* DMA register access functions can be DCR based or memory mapped.
@@ -1024,6 +1046,7 @@ static int temac_probe(struct platform_device *pdev)
 	struct resource *res;
 	const void *addr;
 	__be32 *p;
+	bool little_endian;
 	int rc = 0;
 
 	/* Init network device structure */
@@ -1068,6 +1091,24 @@ static int temac_probe(struct platform_device *pdev)
 		return PTR_ERR(lp->regs);
 	}
 
+	/* Select register access functions with the specified
+	 * endianness mode.  Default for OF devices is big-endian.
+	 */
+	little_endian = false;
+	if (temac_np) {
+		if (of_get_property(temac_np, "little-endian", NULL))
+			little_endian = true;
+	} else if (pdata) {
+		little_endian = pdata->reg_little_endian;
+	}
+	if (little_endian) {
+		lp->temac_ior = _temac_ior_le;
+		lp->temac_iow = _temac_iow_le;
+	} else {
+		lp->temac_ior = _temac_ior_be;
+		lp->temac_iow = _temac_iow_be;
+	}
+
 	/* Setup checksum offload, but default to off if not specified */
 	lp->temac_features = 0;
 	if (temac_np) {
@@ -1111,8 +1152,13 @@ static int temac_probe(struct platform_device *pdev)
 				of_node_put(dma_np);
 				return PTR_ERR(lp->sdma_regs);
 			}
-			lp->dma_in = temac_dma_in32;
-			lp->dma_out = temac_dma_out32;
+			if (of_get_property(dma_np, "little-endian", NULL)) {
+				lp->dma_in = temac_dma_in32_le;
+				lp->dma_out = temac_dma_out32_le;
+			} else {
+				lp->dma_in = temac_dma_in32_be;
+				lp->dma_out = temac_dma_out32_be;
+			}
 			dev_dbg(&pdev->dev, "MEM base: %p\n", lp->sdma_regs);
 		}
 
@@ -1132,8 +1178,13 @@ static int temac_probe(struct platform_device *pdev)
 				"could not map DMA registers\n");
 			return PTR_ERR(lp->sdma_regs);
 		}
-		lp->dma_in = temac_dma_in32;
-		lp->dma_out = temac_dma_out32;
+		if (pdata->dma_little_endian) {
+			lp->dma_in = temac_dma_in32_le;
+			lp->dma_out = temac_dma_out32_le;
+		} else {
+			lp->dma_in = temac_dma_in32_be;
+			lp->dma_out = temac_dma_out32_be;
+		}
 
 		/* Get DMA RX and TX interrupts */
 		lp->rx_irq = platform_get_irq(pdev, 0);
diff --git a/include/linux/platform_data/xilinx-ll-temac.h b/include/linux/platform_data/xilinx-ll-temac.h
index 82e2f80..af87927 100644
--- a/include/linux/platform_data/xilinx-ll-temac.h
+++ b/include/linux/platform_data/xilinx-ll-temac.h
@@ -14,6 +14,8 @@ struct ll_temac_platform_data {
 	unsigned long long mdio_bus_id; /* Unique id for MDIO bus */
 	int phy_addr;		/* Address of the PHY to connect to */
 	phy_interface_t phy_interface; /* PHY interface mode */
+	bool reg_little_endian;	/* Little endian TEMAC register access  */
+	bool dma_little_endian;	/* Little endian DMA register access  */
 };
 
 #endif /* __LINUX_XILINX_LL_TEMAC_H */
-- 
2.4.11

