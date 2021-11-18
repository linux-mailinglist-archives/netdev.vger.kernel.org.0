Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270D1455E67
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhKROop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:44:45 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:53891 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhKROop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1637246505; x=1668782505;
  h=from:to:cc:subject:date:message-id;
  bh=t2I8o2x03tIkjpXNO1UmbqLdi++NbU1U5tYQ4OEwDhc=;
  b=AqhOkEPKqC/eIKagvUYToeUq1hiJhqv+0VPvwOveVHQNHA3YigK7QWKm
   fpjC/CY2cv75yuAlofCJb23amgmTY7c5BcO/ZhHuRid6va2sUkSr0FcE8
   XpHwHWeYQaU41HPWJFW8kXZzSWY2quF2+Pc1oItYzDFoNTXwB30H5r9HY
   fdIDa4cRzTf2I0SJEiMlgDdWodz8HE0NnvfNuiB6ilg+UT92eqag81xvR
   Vj1h8C+YsI0soIiwo9c9B4fJpwAEqrnPQJRUDP5B9+9AKy628FIlU/Az8
   +QMbuVruRedP64paf2sHIH9+SkAg8tppd3h2KF+CRXX30/sKCBPRyrMZ7
   g==;
X-IronPort-AV: E=Sophos;i="5.87,245,1631570400"; 
   d="scan'208";a="20545389"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 18 Nov 2021 15:41:43 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 18 Nov 2021 15:41:43 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 18 Nov 2021 15:41:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1637246503; x=1668782503;
  h=from:to:cc:subject:date:message-id;
  bh=t2I8o2x03tIkjpXNO1UmbqLdi++NbU1U5tYQ4OEwDhc=;
  b=Q9qMcRqt67tJDEwR9Od0PYclll5wYhs1g+1Cbfb/rXcBunPz4afdyDix
   Jd1lQcGVRk4WAXfqRDfImjVfdZn6wmjsULdDFDFQ89NhczMubKonrnqRD
   ZfLPvGOLFsA+Mo7i36US1PtN4rvUkm1rxQunLeNvTRJZJgERHd8vS4UbN
   SqMsHZsh9PwBaXjtKEWGBuveZEuHsTGt3SKVO/PguPmRsHxpkvKqrISJ+
   eh2xrR1+PnLKOb6LNheAU+Q0lHMY74H5ryG7pTu/5A86rKaciueLC5Wk2
   QKrhzORcp76Mx/ppyQT+itYCzUm56N9iU9ZSTK8pm7V8dWuCgBY96X3Op
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,245,1631570400"; 
   d="scan'208";a="20545388"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 18 Nov 2021 15:41:43 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 487DA280065;
        Thu, 18 Nov 2021 15:41:43 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Matt Kline <matt@bitbashing.io>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net] can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()
Date:   Thu, 18 Nov 2021 15:40:11 +0100
Message-Id: <20211118144011.10921-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same fix that was previously done in m_can_platform in commit
99d173fbe894 ("can: m_can: fix iomap_read_fifo() and iomap_write_fifo()")
is required in m_can_pci as well to make iomap_read_fifo() and
iomap_write_fifo() work for val_count > 1.

Fixes: 812270e5445b ("can: m_can: Batch FIFO writes during CAN transmit")
Fixes: 1aa6772f64b4 ("can: m_can: Batch FIFO reads during CAN receive")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/can/m_can/m_can_pci.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 8bbbaa264f0d..b56a54d6c5a9 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -47,8 +47,13 @@ static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 static int iomap_read_fifo(struct m_can_classdev *cdev, int offset, void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
+	void __iomem *src = priv->base + offset;
 
-	ioread32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		*(unsigned int *)val = ioread32(src);
+		val += 4;
+		src += 4;
+	}
 
 	return 0;
 }
@@ -66,8 +71,13 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
 			    const void *val, size_t val_count)
 {
 	struct m_can_pci_priv *priv = cdev_to_priv(cdev);
+	void __iomem *dst = priv->base + offset;
 
-	iowrite32_rep(priv->base + offset, val, val_count);
+	while (val_count--) {
+		iowrite32(*(unsigned int *)val, dst);
+		val += 4;
+		dst += 4;
+	}
 
 	return 0;
 }
-- 
2.17.1

