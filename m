Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5F9DC6E1
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633754AbfJROF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:05:27 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:51150 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408654AbfJROF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 10:05:27 -0400
Received: by unicorn.mansr.com (Postfix, from userid 51770)
        id A8DB71560D; Fri, 18 Oct 2019 15:05:19 +0100 (BST)
From:   Mans Rullgard <mans@mansr.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: dwmac-sun8i: show message only when switching to promisc
Date:   Fri, 18 Oct 2019 15:05:14 +0100
Message-Id: <20191018140514.21454-1-mans@mansr.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Printing the info message every time more than the max number of mac
addresses are requested generates unnecessary log spam.  Showing it only
when the hw is not already in promiscous mode is equally informative
without being annoying.

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 79c91526f3ec..5be2de1f1179 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -646,7 +646,8 @@ static void sun8i_dwmac_set_filter(struct mac_device_info *hw,
 			}
 		}
 	} else {
-		netdev_info(dev, "Too many address, switching to promiscuous\n");
+		if (readl(ioaddr + EMAC_RX_FRM_FLT) != EMAC_FRM_FLT_RXALL)
+			netdev_info(dev, "Too many address, switching to promiscuous\n");
 		v = EMAC_FRM_FLT_RXALL;
 	}
 
-- 
2.23.0

