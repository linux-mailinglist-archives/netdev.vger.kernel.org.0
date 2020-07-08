Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E0421811C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 09:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbgGHHYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 03:24:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:6610 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbgGHHYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 03:24:45 -0400
IronPort-SDR: aMG/7VZ5jz4Rgc8dRjnuEXep5ksX7skclcyefLcCyfBPSgeuHxR0cUfXvH4Q++R8HvJatRixwx
 9UJ0EboYiN8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="212696229"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="212696229"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 00:24:43 -0700
IronPort-SDR: qAtOVyqfRt82AV/Cnkg60XL6x2dxQavtkEBEAmnZn6THvxnHiA2+E+UFs8LOfMLeCM6UsktdLa
 q5BIMcqvXWVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="358024931"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2020 00:24:40 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: [PATCH v4 01/10] net: eth: altera: tse_start_xmit ignores tx_buffer call response
Date:   Wed,  8 Jul 2020 15:23:52 +0800
Message-Id: <20200708072401.169150-2-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200708072401.169150-1-joyce.ooi@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

The return from tx_buffer call in tse_start_xmit is
inapropriately ignored.  tse_buffer calls should return
0 for success or NETDEV_TX_BUSY.  tse_start_xmit should
return not report a successful transmit when the tse_buffer
call returns an error condition.

In addition to the above, the msgdma and sgdma do not return
the same value on success or failure.  The sgdma_tx_buffer
returned 0 on failure and a positive number of transmitted
packets on success.  Given that it only ever sends 1 packet,
this made no sense.  The msgdma implementation msgdma_tx_buffer
returns 0 on success.

  -> Don't ignore the return from tse_buffer calls
  -> Fix sgdma tse_buffer call to return 0 on success
     and NETDEV_TX_BUSY on failure.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: no change
v3: queue is stopped before returning NETDEV_TX_BUSY
v4: no change
---
 drivers/net/ethernet/altera/altera_sgdma.c    | 19 ++++++++++++-------
 drivers/net/ethernet/altera/altera_tse_main.c |  4 +++-
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_sgdma.c b/drivers/net/ethernet/altera/altera_sgdma.c
index db97170da8c7..fe6276c7e4a3 100644
--- a/drivers/net/ethernet/altera/altera_sgdma.c
+++ b/drivers/net/ethernet/altera/altera_sgdma.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/netdevice.h>
 #include "altera_utils.h"
 #include "altera_tse.h"
 #include "altera_sgdmahw.h"
@@ -159,10 +160,11 @@ void sgdma_clear_txirq(struct altera_tse_private *priv)
 		    SGDMA_CTRLREG_CLRINT);
 }
 
-/* transmits buffer through SGDMA. Returns number of buffers
- * transmitted, 0 if not possible.
- *
- * tx_lock is held by the caller
+/* transmits buffer through SGDMA.
+ *   original behavior returned the number of transmitted packets (always 1) &
+ *   returned 0 on error.  This differs from the msgdma.  the calling function
+ *   will now actually look at the code, so from now, 0 is good and return
+ *   NETDEV_TX_BUSY when busy.
  */
 int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 {
@@ -173,8 +175,11 @@ int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 	struct sgdma_descrip __iomem *ndesc = &descbase[1];
 
 	/* wait 'til the tx sgdma is ready for the next transmit request */
-	if (sgdma_txbusy(priv))
-		return 0;
+	if (sgdma_txbusy(priv)) {
+		if (!netif_queue_stopped(priv->dev))
+			netif_stop_queue(priv->dev);
+		return NETDEV_TX_BUSY;
+	}
 
 	sgdma_setup_descrip(cdesc,			/* current descriptor */
 			    ndesc,			/* next descriptor */
@@ -191,7 +196,7 @@ int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 	/* enqueue the request to the pending transmit queue */
 	queue_tx(priv, buffer);
 
-	return 1;
+	return 0;
 }
 
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 907125abef2c..ec2b36e05c3f 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -595,7 +595,9 @@ static netdev_tx_t tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	buffer->dma_addr = dma_addr;
 	buffer->len = nopaged_len;
 
-	priv->dmaops->tx_buffer(priv, buffer);
+	ret = priv->dmaops->tx_buffer(priv, buffer);
+	if (ret)
+		goto out;
 
 	skb_tx_timestamp(skb);
 
-- 
2.13.0

