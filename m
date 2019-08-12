Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E689A2C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfHLJo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:44:27 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:50840 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727451AbfHLJoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 554CCC2174;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603064; bh=XI2I5+R2SHYrVzVFNLd0PzPsC/OJn37cwzcytnQNIFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Yzh+UtJXRTy7CZaq//jhIE4TfQrTXnO3X+9iI6w3THwON/FTW9jcK8Rkuh8kp5SEh
         mXBDg+XMGOhlvHqt9d9U61+VIuaagGR+e5CR5B/V6QSe9zQ7/YVU0Obhc+jZzYOj7D
         z/5O5/bk8DVYyCUg9xjS/oZRtNjVoWQMAIT24BbgkYex7bJSSAQUhLMrgdZ+HYj57t
         VwMtHdf5lxha72iEy861nZSsra7BWIEgDcIvtZs/dSy6TRYYGnzdjqGgFA6+oo+UAo
         IuAIpwEb5tA89Pes+3qChOdFywGFHJSGdQRoI/ntYuo1PnkGTG2b23Ci35uR9EXx1C
         b/5j56GPWxbQQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id F1343A0062;
        Mon, 12 Aug 2019 09:44:22 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 03/12] net: stmmac: xgmac: Correctly return that RX descriptor is not last one
Date:   Mon, 12 Aug 2019 11:44:02 +0200
Message-Id: <fb881abf7700041e4658fc999349b867e05b6856.1565602974.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the correct value when RX descriptor is not the last one.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 2391ede97597..717b50d4aa93 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -26,16 +26,15 @@ static int dwxgmac2_get_rx_status(void *data, struct stmmac_extra_stats *x,
 				  struct dma_desc *p)
 {
 	unsigned int rdes3 = le32_to_cpu(p->des3);
-	int ret = good_frame;
 
 	if (unlikely(rdes3 & XGMAC_RDES3_OWN))
 		return dma_own;
 	if (likely(!(rdes3 & XGMAC_RDES3_LD)))
+		return rx_not_ls;
+	if (unlikely((rdes3 & XGMAC_RDES3_ES) && (rdes3 & XGMAC_RDES3_LD)))
 		return discard_frame;
-	if (unlikely(rdes3 & XGMAC_RDES3_ES))
-		ret = discard_frame;
 
-	return ret;
+	return good_frame;
 }
 
 static int dwxgmac2_get_tx_len(struct dma_desc *p)
-- 
2.7.4

