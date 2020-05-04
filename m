Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943F1C3464
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgEDI2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:28:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:30122 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgEDI2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 04:28:02 -0400
IronPort-SDR: xGi91J/k15cYDL6TIyZPndodP92ghaRm2W4KzZkPnKy/q9oGHvmafFeFCHypvEhS1Wm9Se7tmB
 6MGv5VU+h2kw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 01:28:02 -0700
IronPort-SDR: d+xy9UowYmFYWGnONQuAc9OxlqqA2jRopTTOmjNuaNydkDYJezaqW9tCktSa7LS8m/UhtZwkSY
 IQI5sE5CnRwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,351,1583222400"; 
   d="scan'208";a="295435988"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2020 01:27:59 -0700
From:   Joyce Ooi <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCHv2 01/10] net: eth: altera: tse_start_xmit ignores tx_buffer call response
Date:   Mon,  4 May 2020 16:25:49 +0800
Message-Id: <20200504082558.112627-2-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200504082558.112627-1-joyce.ooi@intel.com>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
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
---
 drivers/net/ethernet/altera/altera_sgdma.c    | 14 ++++++++------
 drivers/net/ethernet/altera/altera_tse_main.c |  4 +++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_sgdma.c b/drivers/net/ethernet/altera/altera_sgdma.c
index db97170da8c7..77e2c5e3650f 100644
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
@@ -174,7 +176,7 @@ int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 
 	/* wait 'til the tx sgdma is ready for the next transmit request */
 	if (sgdma_txbusy(priv))
-		return 0;
+		return NETDEV_TX_BUSY;
 
 	sgdma_setup_descrip(cdesc,			/* current descriptor */
 			    ndesc,			/* next descriptor */
@@ -191,7 +193,7 @@ int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *buffer)
 	/* enqueue the request to the pending transmit queue */
 	queue_tx(priv, buffer);
 
-	return 1;
+	return 0;
 }
 
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 1671c1f36691..2a9e6157a8a1 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -595,7 +595,9 @@ static int tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	buffer->dma_addr = dma_addr;
 	buffer->len = nopaged_len;
 
-	priv->dmaops->tx_buffer(priv, buffer);
+	ret = priv->dmaops->tx_buffer(priv, buffer);
+	if (ret)
+		goto out;
 
 	skb_tx_timestamp(skb);
 
-- 
2.13.0

