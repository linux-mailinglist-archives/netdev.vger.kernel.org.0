Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1AF91273
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfHQSy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:54:59 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:53882 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbfHQSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:54:58 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BEA96C0E36;
        Sat, 17 Aug 2019 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068097; bh=iq3hH5ItBLwsoXkEnES6jnm2/Kr55SPPUNaF8bdtcgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=flXQjdRy23IKOACVe4vUHEwQk9nkWtlpBc92ya2dKyRbyGwHg3uqI4msAUVfblUkk
         +h9u606CJI0uh/iNi5vkeNIh5cfVlkFfTPRtsyPMyCekLhN4Bd+w5h36WebywlN1HG
         75QOLoCYYdoW/Y3v3mE7AKFu48zSDZRaXH61blyx0vvhJ3yqHz7HiErdAf7Crah/Ii
         pfBOzoWUnJCxR7gCc2Em5qDTCfiqt3xZdhR2Xie1vX8uNcyAvtOeBg2i9wyOoi8k/H
         ITdoHrmXujFC4JqvmQd05CFnzljo6ep3QLnod2i/QvQmz7wyRPRjT/b5g1cu80T9X5
         BnT0kjW15/33A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 836B4A0068;
        Sat, 17 Aug 2019 18:54:55 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 03/12] net: stmmac: xgmac: Correctly return that RX descriptor is not last one
Date:   Sat, 17 Aug 2019 20:54:42 +0200
Message-Id: <6d563e40fd326f61cc104ab455264b49c77e569b.1566067802.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
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
index 58b69fa97837..2c1ed8c2a9d3 100644
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

