Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D59860C665
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiJYI1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiJYI1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:27:03 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941DE65FC;
        Tue, 25 Oct 2022 01:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666686422; x=1698222422;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/8wa08b9rvNl5cMcmZVDXdij/gFrnDmrwVc10g0xUnw=;
  b=QWUFLDuNTW8yN8mZX56u9C94dw4wOn3lzRuiYLAe2ApA8B+L95zCZTAl
   E2ASSzwh6k0gc+T8AtYZbLflLqtWHHauikpepbt1DZyQl4R67xNGQ2DFB
   jD7TYSZVn3sfjZl6j8OtPYaZ9ollXr3lXYdOQs5gLXN8HqLxMY1n/zFmJ
   INAE5jI7oGwYkSvZQ7tP3KwMj3EUdsQCMiC0YETzFGJBQCMUo6YfX0Mae
   UlhA9iYp5UYgJljd+N9cc8kw6F6tWAwJrFBMgZe9O7R/KneH2+RzEwo3y
   ibM23yKA4sRX8BtomSnycxIRpKUqRupWBg4X0VE591O/6ZN1vqU+aaT9W
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="307614741"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="307614741"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 01:26:59 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="582697282"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="582697282"
Received: from junxiaochang.bj.intel.com ([10.238.135.52])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 01:26:55 -0700
From:   Junxiao Chang <junxiao.chang@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        Joao.Pinto@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     junxiao.chang@intel.com, veekhee@gmail.com
Subject: [PATCH net-next,v2] net: stmmac: remove duplicate dma queue channel macros
Date:   Tue, 25 Oct 2022 16:17:47 +0800
Message-Id: <20221025081747.1884926-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It doesn't need extra macros for queue 0 & 4. Same macro could
be used for all 8 queues. Related queue/channel functions could
be combined together.

Original macro which has two same parameters is unsafe macro and
might have potential side effects. Each MTL RxQ DMA channel mask
is 4 bits, so using (0xf << chan) instead of GENMASK(x + 3, x) to
avoid unsafe macro.

Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
v2: combined "if (queue < 4)" and "else" according to Vee Khee's suggestion.
v1: https://lore.kernel.org/r/20221025053555.1883731-1-junxiao.chang@intel.com
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  4 +---
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 21 ++++++-------------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 71dad409f78b0..ccd49346d3b30 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -331,9 +331,7 @@ enum power_event {
 
 #define MTL_RXQ_DMA_MAP0		0x00000c30 /* queue 0 to 3 */
 #define MTL_RXQ_DMA_MAP1		0x00000c34 /* queue 4 to 7 */
-#define MTL_RXQ_DMA_Q04MDMACH_MASK	GENMASK(3, 0)
-#define MTL_RXQ_DMA_Q04MDMACH(x)	((x) << 0)
-#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	GENMASK(11 + (8 * ((x) - 1)), 8 * (x))
+#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	(0xf << 8 * (x))
 #define MTL_RXQ_DMA_QXMDMACH(chan, q)	((chan) << (8 * (q)))
 
 #define MTL_CHAN_BASE_ADDR		0x00000d00
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index c25bfecb4a2df..513f6ea335a82 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -214,26 +214,17 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value;
 
-	if (queue < 4)
+	if (queue < 4) {
 		value = readl(ioaddr + MTL_RXQ_DMA_MAP0);
-	else
-		value = readl(ioaddr + MTL_RXQ_DMA_MAP1);
-
-	if (queue == 0 || queue == 4) {
-		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
-		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
-	} else if (queue > 4) {
-		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
-		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
-	} else {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
-	}
-
-	if (queue < 4)
 		writel(value, ioaddr + MTL_RXQ_DMA_MAP0);
-	else
+	} else {
+		value = readl(ioaddr + MTL_RXQ_DMA_MAP1);
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 		writel(value, ioaddr + MTL_RXQ_DMA_MAP1);
+	}
 }
 
 static void dwmac4_config_cbs(struct mac_device_info *hw,
-- 
2.25.1

