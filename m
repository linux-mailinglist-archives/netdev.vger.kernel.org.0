Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B2A6FB7B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfGVIjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:39:53 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:45682 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfGVIjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 04:39:52 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E9E2BC0070;
        Mon, 22 Jul 2019 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563784792; bh=5hkdNv+d4ulwOI3yH55Iw6BH1syqXjCwb21YV26gLjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=MuBz0WJ31rRDWMQDsHazo4zP38yyAHMYpCgTWCGCnBq+/UCZdPTGSxxbIOApHBlqi
         eJGhMcA6wLuv6WBfqoIP+2TbwKpnLPP8bkExyP8/0JFd7qynDHBdNCuFL/5/085hfs
         M0H3D+0raSAcKMryfiHEmMDWgLBZY9ZPXE0jGOWZdT+rkOCUC1zMPsF+lv2zdhE38M
         7AQ8t6zxRxnyL2NvregM1fLhQAMlCxFJUW/UvbmE4Z89yr18ch4a4ERdhN01g1fQgo
         E/nG/Zn920b7LFfUSW23wM/5AIzQK30Ni+tRuLIDWUuU9qRGZW1BEzU6xBwQ3OrxFw
         ayt1dGMD3Je4g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5FEB0A005C;
        Mon, 22 Jul 2019 08:39:50 +0000 (UTC)
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
Subject: [PATCH net 1/2] net: stmmac: RX Descriptors need to be clean before setting buffers
Date:   Mon, 22 Jul 2019 10:39:30 +0200
Message-Id: <00bfde6f589e60ba1a2d0671c8ba0fcd0964d6e7.1563784666.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1563784666.git.joabreu@synopsys.com>
References: <cover.1563784666.git.joabreu@synopsys.com>
In-Reply-To: <cover.1563784666.git.joabreu@synopsys.com>
References: <cover.1563784666.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX Descriptors are being cleaned after setting the buffers which may
lead to buffer addresses being wiped out.

Fix this by clearing earlier the RX Descriptors.

Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c7c9e5f162e6..5f1294ce0216 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1295,6 +1295,8 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 			  "(%s) dma_rx_phy=0x%08x\n", __func__,
 			  (u32)rx_q->dma_rx_phy);
 
+		stmmac_clear_rx_descriptors(priv, queue);
+
 		for (i = 0; i < DMA_RX_SIZE; i++) {
 			struct dma_desc *p;
 
@@ -1312,8 +1314,6 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		rx_q->cur_rx = 0;
 		rx_q->dirty_rx = (unsigned int)(i - DMA_RX_SIZE);
 
-		stmmac_clear_rx_descriptors(priv, queue);
-
 		/* Setup the chained descriptor addresses */
 		if (priv->mode == STMMAC_CHAIN_MODE) {
 			if (priv->extend_desc)
-- 
2.7.4

