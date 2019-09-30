Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AF3C1CEC
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfI3IT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:19:27 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33662 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730011AbfI3IT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:19:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 48058C0388;
        Mon, 30 Sep 2019 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569831566; bh=MV+Pa6bWic8PJcQ0PmrvM1y6FtITxVDL2Xu5W5HutE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=aY2ZpTj0gPC5rJyO1lNM0LeulgSCTg92HZmjU9RuBLQewGTFWd6CVm3WvE+nLp3r2
         Ak/1TcdmSD175F2ZPluaqjH0upQyF2SMC/PZ+AZik5z7LQoZsyZLLD3TDu0CC76viW
         ps+zeMAO8kBszRxFlQrOesg3xpV1EXXi+tK2AV7n90IdEls+elyeY7WA5dZVuRv+Vw
         J/wZfc6zDnHyONvCBTUAzvdvgKJ3jyGdYWT2eod/xNkNSaMwDXag3/3Np8JY4cySl1
         46CyTzYNe14jPJkjvhHgGy2SZ7IU+zs2u9vSvPdVOM5ZuxFoobWY4SehmF0lVRaRq7
         MHgyvyRsNag2w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6A78FA0079;
        Mon, 30 Sep 2019 08:19:23 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 4/9] net: stmmac: dwmac4: Always update the MAC Hash Filter
Date:   Mon, 30 Sep 2019 10:19:08 +0200
Message-Id: <08edfc3e1c95d7ce243bae6879b16d0b103095cf.1569831229.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to always update the MAC Hash Filter so that previous entries
are invalidated.

Found out while running stmmac selftests.

Fixes: b8ef7020d6e5 ("net: stmmac: add support for hash table size 128/256 in dwmac4")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 9b4b5f69fc02..2cb9c53f93b8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -401,8 +401,11 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	int numhashregs = (hw->multicast_filter_bins >> 5);
 	int mcbitslog2 = hw->mcast_bits_log2;
 	unsigned int value;
+	u32 mc_filter[8];
 	int i;
 
+	memset(mc_filter, 0, sizeof(mc_filter));
+
 	value = readl(ioaddr + GMAC_PACKET_FILTER);
 	value &= ~GMAC_PACKET_FILTER_HMC;
 	value &= ~GMAC_PACKET_FILTER_HPF;
@@ -416,16 +419,13 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		/* Pass all multi */
 		value |= GMAC_PACKET_FILTER_PM;
 		/* Set all the bits of the HASH tab */
-		for (i = 0; i < numhashregs; i++)
-			writel(0xffffffff, ioaddr + GMAC_HASH_TAB(i));
+		memset(mc_filter, 0xff, sizeof(mc_filter));
 	} else if (!netdev_mc_empty(dev)) {
 		struct netdev_hw_addr *ha;
-		u32 mc_filter[8];
 
 		/* Hash filter for multicast */
 		value |= GMAC_PACKET_FILTER_HMC;
 
-		memset(mc_filter, 0, sizeof(mc_filter));
 		netdev_for_each_mc_addr(ha, dev) {
 			/* The upper n bits of the calculated CRC are used to
 			 * index the contents of the hash table. The number of
@@ -440,10 +440,11 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 			 */
 			mc_filter[bit_nr >> 5] |= (1 << (bit_nr & 0x1f));
 		}
-		for (i = 0; i < numhashregs; i++)
-			writel(mc_filter[i], ioaddr + GMAC_HASH_TAB(i));
 	}
 
+	for (i = 0; i < numhashregs; i++)
+		writel(mc_filter[i], ioaddr + GMAC_HASH_TAB(i));
+
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-- 
2.7.4

