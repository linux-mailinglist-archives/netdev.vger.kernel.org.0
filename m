Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3276E68E8D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfGOOHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388364AbfGOOHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:07:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 533F121873;
        Mon, 15 Jul 2019 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199654;
        bh=dMS4IlMtitQta4w5eymfq+mTgMKszYDZ+A8Kxy3G5DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPKABndB5XQUsXEQtdaeI4TemBYsXhJfoziaitVS8B8JfTuMvLVK89Oj7rzFNhmr9
         wXLJLpRFnmwSgfVT+E21+ImAyGvDnB/Jd2cCo6Xe7BEGM8cAi74jSVa453Rcx5WmvY
         C9BqYn1pFJIIJkrhnQc7/0IAUjKv3KxLysT9jc6A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biao Huang <biao.huang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 062/219] net: stmmac: dwmac4: fix flow control issue
Date:   Mon, 15 Jul 2019 10:01:03 -0400
Message-Id: <20190715140341.6443-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit ee326fd01e79dfa42014d55931260b68b9fa3273 ]

Current dwmac4_flow_ctrl will not clear
GMAC_RX_FLOW_CTRL_RFE/GMAC_RX_FLOW_CTRL_RFE bits,
so MAC hw will keep flow control on although expecting
flow control off by ethtool. Add codes to fix it.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index a2f3db39221e..d0e6e1503581 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -475,8 +475,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
-		writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 	}
+	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
+
 	if (fc & FLOW_TX) {
 		pr_debug("\tTransmit Flow-Control ON\n");
 
@@ -484,7 +485,7 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 			pr_debug("\tduplex mode: PAUSE %d\n", pause_time);
 
 		for (queue = 0; queue < tx_cnt; queue++) {
-			flow |= GMAC_TX_FLOW_CTRL_TFE;
+			flow = GMAC_TX_FLOW_CTRL_TFE;
 
 			if (duplex)
 				flow |=
@@ -492,6 +493,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 
 			writel(flow, ioaddr + GMAC_QX_TX_FLOW_CTRL(queue));
 		}
+	} else {
+		for (queue = 0; queue < tx_cnt; queue++)
+			writel(0, ioaddr + GMAC_QX_TX_FLOW_CTRL(queue));
 	}
 }
 
-- 
2.20.1

