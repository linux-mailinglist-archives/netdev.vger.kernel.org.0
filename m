Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4644F2A1914
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgJaRrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:47:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgJaRrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 13:47:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYuyU-004XAR-Jl; Sat, 31 Oct 2020 18:47:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix -Wpointer-to-int-cast warnings with W=1
Date:   Sat, 31 Oct 2020 18:47:20 +0100
Message-Id: <20201031174721.1080756-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031174721.1080756-1-andrew@lunn.ch>
References: <20201031174721.1080756-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet//xilinx/xilinx_emaclite.c:341:35: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  341 |   addr = (void __iomem __force *)((u32 __force)addr ^

Use long instead of u32 to avoid problems on 64 bit systems.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 2c98e4cc07a5..f56c1fd01061 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -97,7 +97,7 @@
 #define ALIGNMENT		4
 
 /* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignment. */
-#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
+#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((long)adr)) % ALIGNMENT)
 
 #ifdef __BIG_ENDIAN
 #define xemaclite_readl		ioread32be
@@ -338,7 +338,7 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
 		 * if it is configured in HW
 		 */
 
-		addr = (void __iomem __force *)((u32 __force)addr ^
+		addr = (void __iomem __force *)((long __force)addr ^
 						 XEL_BUFFER_OFFSET);
 		reg_data = xemaclite_readl(addr + XEL_TSR_OFFSET);
 
@@ -399,7 +399,7 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 		 * will correct on subsequent calls
 		 */
 		if (drvdata->rx_ping_pong != 0)
-			addr = (void __iomem __force *)((u32 __force)addr ^
+			addr = (void __iomem __force *)((long __force)addr ^
 							 XEL_BUFFER_OFFSET);
 		else
 			return 0;	/* No data was available */
@@ -1192,9 +1192,9 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
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
2.28.0

