Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78612ACB31
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKJCkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:40:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJCki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 21:40:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJaG-006Cxn-IW; Tue, 10 Nov 2020 03:40:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/3] drivers: net: xilinx_emaclite: Fix -Wpointer-to-int-cast warnings with W=1
Date:   Tue, 10 Nov 2020 03:40:23 +0100
Message-Id: <20201110024024.1479741-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110024024.1479741-1-andrew@lunn.ch>
References: <20201110024024.1479741-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet//xilinx/xilinx_emaclite.c:341:35: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  341 |   addr = (void __iomem __force *)((u32 __force)addr ^

Use uintptr_t instead of u32 to avoid problems on 64 bit systems.

Also, cast the address to an unsigned long for printing.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 2c98e4cc07a5..008b9a40faad 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -97,7 +97,7 @@
 #define ALIGNMENT		4
 
 /* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignment. */
-#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
+#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((uintptr_t)adr)) % ALIGNMENT)
 
 #ifdef __BIG_ENDIAN
 #define xemaclite_readl		ioread32be
@@ -338,7 +338,7 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
 		 * if it is configured in HW
 		 */
 
-		addr = (void __iomem __force *)((u32 __force)addr ^
+		addr = (void __iomem __force *)((uintptr_t __force)addr ^
 						 XEL_BUFFER_OFFSET);
 		reg_data = xemaclite_readl(addr + XEL_TSR_OFFSET);
 
@@ -399,8 +399,9 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 		 * will correct on subsequent calls
 		 */
 		if (drvdata->rx_ping_pong != 0)
-			addr = (void __iomem __force *)((u32 __force)addr ^
-							 XEL_BUFFER_OFFSET);
+			addr = (void __iomem __force *)
+				((uintptr_t __force)addr ^
+				 XEL_BUFFER_OFFSET);
 		else
 			return 0;	/* No data was available */
 
@@ -1192,9 +1193,9 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=%d\n",
+		 "Xilinx EmacLite at 0x%08X mapped to 0x%08lX, irq=%d\n",
 		 (unsigned int __force)ndev->mem_start,
-		 (unsigned int __force)lp->base_addr, ndev->irq);
+		 (unsigned long __force)lp->base_addr, ndev->irq);
 	return 0;
 
 error:
-- 
2.29.2

