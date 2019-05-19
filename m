Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600532283E
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfESSHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:07:38 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:55775 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbfESSHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:07:36 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hSQDe-00089l-4u; Sun, 19 May 2019 20:07:34 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>
Subject: [[PATCH net-next] 2/2] net: xilinx_emaclite: use readx_poll_timeout() in mdio wait function
Date:   Sun, 19 May 2019 19:59:37 +0200
Message-Id: <20190519175937.3955-3-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190519175937.3955-1-b.spranger@linutronix.de>
References: <20190519175937.3955-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

On loaded systems with a preemptible kernel the mdio_wait() function may
report an error while everything is working fine:

xemaclite_mdio_wait():
  xemaclite_readl() -> chip not ready
  --> interrupt here (other work for some time / chip become ready)
  if (time_before_eq(end, jiffies))
    --> false positive error report

Replace the current code with readx_poll_timeout() which takes care
of the situation.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 6886270da695..c409bab63bd3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -27,6 +27,7 @@
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 
 #define DRIVER_NAME "xilinx_emaclite"
 
@@ -714,20 +715,15 @@ static irqreturn_t xemaclite_interrupt(int irq, void *dev_id)
 
 static int xemaclite_mdio_wait(struct net_local *lp)
 {
-	unsigned long end = jiffies + 2;
+	u32 val;
 
 	/* wait for the MDIO interface to not be busy or timeout
 	 * after some time.
 	 */
-	while (xemaclite_readl(lp->base_addr + XEL_MDIOCTRL_OFFSET) &
-			XEL_MDIOCTRL_MDIOSTS_MASK) {
-		if (time_before_eq(end, jiffies)) {
-			WARN_ON(1);
-			return -ETIMEDOUT;
-		}
-		msleep(1);
-	}
-	return 0;
+	return readx_poll_timeout(xemaclite_readl,
+				  lp->base_addr + XEL_MDIOCTRL_OFFSET,
+				  val, !(val & XEL_MDIOCTRL_MDIOSTS_MASK),
+				  1000, 20000);
 }
 
 /**
-- 
2.20.1

