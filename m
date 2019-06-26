Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C951C56B19
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfFZNsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:19 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:51152 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727873AbfFZNrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:55 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BC8EAC0C48;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=FAiLRSEXJ0qA3Iqo2KYj0X7IBYFXYKqet0FPvksvnRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gofzt5jqudT6yXBy4wSnXKyoLs26yDiTc+wQZm512IhL+945e7R3kyoSOt2F5Ex0s
         SlMhn4+LsJaW8uYA9X3iWLDYcTnoAvYYYch/Zwl58dTr7BCueJUejXD7y34v9WdC0D
         OFKtsHhulaV30f30iuVn9aQQ3tNXaGeKPkKuhUROHhoU1PKNO6+BP6ed9IvzZOHLQV
         x+o+cGF4HcgfSPxvu/LSwrw7hzBwCPow8D/GEsTw5E9fvN5pMOFW4NFgzjffLDhutD
         XrfkMOJgABLzsLuDxSrQ9XUOiJ43GIlzfV/3agXwtJy8ANnV6KDv1cF1Wk28DoAf98
         j6BhtLec9biag==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4B01AA0071;
        Wed, 26 Jun 2019 13:47:52 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 0F1F83B56F;
        Wed, 26 Jun 2019 15:47:52 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 06/10] net: stmmac: Do not disable interrupts when cleaning TX
Date:   Wed, 26 Jun 2019 15:47:40 +0200
Message-Id: <f55c822885bbb33a3dc2b53ce6ad9e600c6a3b32.1561556556.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a performance killer and anyways the interrupts are being
disabled by RX NAPI so no need to disable them again.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1247066c371c..3a6fac22854e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2057,10 +2057,8 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 		napi_schedule_irqoff(&ch->rx_napi);
 	}
 
-	if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use)) {
-		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
+	if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use))
 		napi_schedule_irqoff(&ch->tx_napi);
-	}
 
 	return status;
 }
@@ -3560,8 +3558,8 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
 	work_done = stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
 	work_done = min(work_done, budget);
 
-	if (work_done < budget && napi_complete_done(napi, work_done))
-		stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
+	if (work_done < budget)
+		napi_complete_done(napi, work_done);
 
 	/* Force transmission restart */
 	tx_q = &priv->tx_queue[chan];
-- 
2.7.4

