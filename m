Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 067B5186190
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgCPCdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:33:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43959 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgCPCdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:33:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id c144so9060965pfb.10;
        Sun, 15 Mar 2020 19:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UOxHJj4HdQ88hqvaq4HbY/GpiedINXJyx4lWisWkp0c=;
        b=CEKGHAhjNx5OVWJ6pH6qnuCyJDP4H6nJmuCMA1rGBhvKab++FPyywXOWYZQIEjkvfX
         l5zkH83RqCkyGX3ALgRUtORxDk/eEq2uMefH7QwOWOPqcWDukZFnHV+ESaJqE2c176k9
         pL3+4a/k1vj/2jfuiqPtj+JQN17QrOTG9ptDxrvRTxZWRuzde+oYSbsNMQJYL0lRMPlF
         MDa9oM4iRszS161T7Y7Q86mGUJ+w2hZutedTIclbRr8pYSVy0MhZpb/C20YRttwh1fV1
         aHcEThV/TOfHsSnJZaEecxz0VT9RaWsOSMdWfCDyKvPac85CbNjJCBI0Y5yuVC8sJGzN
         fZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UOxHJj4HdQ88hqvaq4HbY/GpiedINXJyx4lWisWkp0c=;
        b=i8tplBsVJV0TTzxDqNc0rsQHib3OPhkxx6H7+X4PTYVNxALY6/14KNWzDtD8F5XphA
         b3eaPZCjrHkMVGB9MzARdb/g8ADyfeq2QDkHYwFDIzphX5gfrVRVk2Wi5hlLPkdgYkAf
         LARSTomZOCeHWlt3+UsgESLRa4Zge5UObn4CLqGOXpSrGaLsu7Rbd3/URm5OxZTxMVzW
         LqBWiqRcj0lchgPWbhwIcJne8/i2WDt7Qq6aUuD5BBryTu7frAp8Mg2f8DgFPKWucMw/
         C3W3045AYaJoxFG6NIRyCiBnHrQmyxhtA7IRiVyF0JBUPJ04JsH/o9s8ig664PsPvaXZ
         LFGA==
X-Gm-Message-State: ANhLgQ3BwO6/hNK0UCiFpBKaPNR5JJyTS6avgTVnyd1P5F6sWjUvkVRn
        ioHt64YqCrod6RmzHdLDp6uWFsJj
X-Google-Smtp-Source: ADFU+vvjAcrdfpaC4Q9vMkz/EG7skwYb7zOD0ZKqUax3cK1CE/FEMScMnyrZrKrtsDbyLMmpSNvtqQ==
X-Received: by 2002:a63:ba5d:: with SMTP id l29mr4428057pgu.67.1584325988849;
        Sun, 15 Mar 2020 19:33:08 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id w188sm2510059pfb.198.2020.03.15.19.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 19:33:08 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, andrew@lunn.ch
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 2/2] net: stmmac: use readl_poll_timeout() function in dwmac4_dma_reset()
Date:   Mon, 16 Mar 2020 10:32:54 +0800
Message-Id: <20200316023254.13201-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200316023254.13201-1-zhengdejin5@gmail.com>
References: <20200316023254.13201-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dwmac4_dma_reset() function use an open coded of readl_poll_timeout().
Replace the open coded handling with the proper function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v2 -> v3:
	- return whatever error code by readl_poll_timeout() returned.
v1 -> v2:
	- no changed.

 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 9becca280074..6e30d7eb4983 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include "common.h"
 #include "dwmac4_dma.h"
@@ -14,22 +15,14 @@
 int dwmac4_dma_reset(void __iomem *ioaddr)
 {
 	u32 value = readl(ioaddr + DMA_BUS_MODE);
-	int limit;
 
 	/* DMA SW reset */
 	value |= DMA_BUS_MODE_SFT_RESET;
 	writel(value, ioaddr + DMA_BUS_MODE);
-	limit = 10;
-	while (limit--) {
-		if (!(readl(ioaddr + DMA_BUS_MODE) & DMA_BUS_MODE_SFT_RESET))
-			break;
-		mdelay(10);
-	}
-
-	if (limit < 0)
-		return -EBUSY;
 
-	return 0;
+	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+				 !(value & DMA_BUS_MODE_SFT_RESET),
+				 10000, 100000);
 }
 
 void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
-- 
2.25.0

