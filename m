Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B79760C36F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiJYFpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiJYFpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:45:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3380263F0F;
        Mon, 24 Oct 2022 22:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666676711; x=1698212711;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p2UaT46WgwCPZyBsHVRtMczv0jT1EuB9P7Y5ogY+vmE=;
  b=MZOJ0u5MJzGPrbnITa2JJDTOVNaTNbZGuCe+BjrrOP/eDSLBYLm5wQ7M
   ziZ0VqBCxnMm6oOEhERHp2p5OX6Rk/uwztquvGDNtNDHKheIOwmL6rpKz
   4+DcRGKkqm3qV7QyhfcNqWU9t11avHAJgUdsnMrNQ+XcOUHvqfZGyDJ7J
   ddNCKIkipej5TPxBR9yY0kS7Q5Js49BVVLQUetX0S5mwq1MmZHefhoeUw
   sTF7cooUCBw8GL9pjMt3R67MnruAJSbhpRX8eGpatg+KuEMP0ENrJXEoA
   5Fqr9WCL3opaSY4ZKvn57nXbncA5MUc3dGAw5wlRb+vPtxHO6VikU+1Vw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="371808612"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="371808612"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 22:45:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="694824890"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="694824890"
Received: from junxiaochang.bj.intel.com ([10.238.135.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 22:45:04 -0700
From:   Junxiao Chang <junxiao.chang@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        Joao.Pinto@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     junxiao.chang@intel.com
Subject: [PATCH net-next] net: stmmac: remove duplicate dma queue channel macros
Date:   Tue, 25 Oct 2022 13:35:55 +0800
Message-Id: <20221025053555.1883731-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It doesn't need extra macros for queue 0 & 4. Same macro could
be used for all 8 queues.

Original macro which has two same parameters is unsafe macro and
might have potential side effects. Each MTL RxQ DMA channel mask
is 4 bits, so using (0xf << chan) instead of GENMASK(x + 3, x) to
avoid unsafe macro.

Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  4 +---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 11 ++++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

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
index c25bfecb4a2df..64b916728bdd4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -219,15 +219,12 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	else
 		value = readl(ioaddr + MTL_RXQ_DMA_MAP1);
 
-	if (queue == 0 || queue == 4) {
-		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
-		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
-	} else if (queue > 4) {
-		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
-		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
-	} else {
+	if (queue < 4) {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
+	} else {
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 	}
 
 	if (queue < 4)
-- 
2.25.1

