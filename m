Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60163242EA
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfETViB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:38:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:54415 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfETViB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 17:38:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 14:38:00 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga001.jf.intel.com with ESMTP; 20 May 2019 14:37:58 -0700
From:   Weifeng Voon <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Weifeng Voon <weifeng.voon@intel.com>
Subject: [PATCH net] net: stmmac: dma channel control register need to be init first
Date:   Tue, 21 May 2019 13:38:38 +0800
Message-Id: <1558417118-28985-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_init_chan() needs to be called before stmmac_init_rx_chan() and
stmmac_init_tx_chan(). This is because if PBLx8 is to be used,
"DMA_CH(#i)_Control.PBLx8" needs to be set before programming
"DMA_CH(#i)_TX_Control.TxPBL" and "DMA_CH(#i)_RX_Control.RxPBL".

Fixes: 47f2a9ce527a ("net: stmmac: dma channel init prepared for multiple queues")
Reviewed-by: Zhang, Baoli <baoli.zhang@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5678b869cbff..2a1052704885 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2208,6 +2208,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 	if (priv->plat->axi)
 		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
 
+	/* DMA CSR Channel configuration */
+	for (chan = 0; chan < dma_csr_ch; chan++)
+		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
+
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
 		rx_q = &priv->rx_queue[chan];
@@ -2233,10 +2237,6 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 				       tx_q->tx_tail_addr, chan);
 	}
 
-	/* DMA CSR Channel configuration */
-	for (chan = 0; chan < dma_csr_ch; chan++)
-		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
-
 	return ret;
 }
 
-- 
1.9.1

