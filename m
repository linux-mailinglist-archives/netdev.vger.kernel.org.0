Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9CD2283D
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfESSHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:07:37 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:55774 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbfESSHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:07:36 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hSQDd-00089l-AV; Sun, 19 May 2019 20:07:33 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>
Subject: [[PATCH net-next] 1/2] net: axienet: use readx_poll_timeout() in mdio wait function
Date:   Sun, 19 May 2019 19:59:36 +0200
Message-Id: <20190519175937.3955-2-b.spranger@linutronix.de>
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

axienet_mdio_wait_until_ready():
  axienet_ior() -> chip not ready
  --> interrupt here (other work for some time / chip become ready)
  if (time_before_eq(end, jiffies))
    --> false positive error report

Replace the current code with readx_poll_timeout() which take care
of the situation.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h     |  5 +++++
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c    | 16 ++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index c337400485da..011adae32b89 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -484,6 +484,11 @@ static inline u32 axienet_ior(struct axienet_local *lp, off_t offset)
 	return in_be32(lp->regs + offset);
 }
 
+static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
+{
+	return axienet_ior(lp, XAE_MDIO_MCR_OFFSET);
+}
+
 /**
  * axienet_iow - Memory mapped Axi Ethernet register write
  * @lp:         Pointer to axienet local structure
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 757a3b37ae8a..704babdbc8a2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -11,6 +11,7 @@
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/jiffies.h>
+#include <linux/iopoll.h>
 
 #include "xilinx_axienet.h"
 
@@ -20,16 +21,11 @@
 /* Wait till MDIO interface is ready to accept a new transaction.*/
 int axienet_mdio_wait_until_ready(struct axienet_local *lp)
 {
-	unsigned long end = jiffies + 2;
-	while (!(axienet_ior(lp, XAE_MDIO_MCR_OFFSET) &
-		 XAE_MDIO_MCR_READY_MASK)) {
-		if (time_before_eq(end, jiffies)) {
-			WARN_ON(1);
-			return -ETIMEDOUT;
-		}
-		udelay(1);
-	}
-	return 0;
+	u32 val;
+
+	return readx_poll_timeout(axinet_ior_read_mcr, lp,
+				  val, val & XAE_MDIO_MCR_READY_MASK,
+				  1, 20000);
 }
 
 /**
-- 
2.20.1

