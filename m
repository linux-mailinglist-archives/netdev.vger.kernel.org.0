Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FACB696C6
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbfGOOFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388008AbfGOOFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DAD212F5;
        Mon, 15 Jul 2019 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199515;
        bh=a38p4zhkTkWbyv49GuuwcUCfXc8SLvwSsrch9QqF9TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNCLTITbvQVXhCtMIsBz6Htc+xGpEBcgOtfWVs9/RzP5DYd2pef7NrZEyn3z38WFV
         wv3eTNVQB8IVQK21LbfPf6Ixyhi32+2Befty7xDxhPmYIP/eGbMOh1uqfxZs0WoLaK
         Jq08mIao4sk/43+1gs5RqYlT3mS0lR1/jsiYeAM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Joao Pinto <jpinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 029/219] net: stmmac: dwmac4/5: Clear unused address entries
Date:   Mon, 15 Jul 2019 10:00:30 -0400
Message-Id: <20190715140341.6443-29-sashal@kernel.org>
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

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 0620ec6c62a5a07625b65f699adc5d1b90394ee6 ]

In case we don't use a given address entry we need to clear it because
it could contain previous values that are no longer valid.

Found out while running stmmac selftests.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 7e5d5db0d516..a2f3db39221e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -444,14 +444,20 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		 * are required
 		 */
 		value |= GMAC_PACKET_FILTER_PR;
-	} else if (!netdev_uc_empty(dev)) {
-		int reg = 1;
+	} else {
 		struct netdev_hw_addr *ha;
+		int reg = 1;
 
 		netdev_for_each_uc_addr(ha, dev) {
 			dwmac4_set_umac_addr(hw, ha->addr, reg);
 			reg++;
 		}
+
+		while (reg <= GMAC_MAX_PERFECT_ADDRESSES) {
+			writel(0, ioaddr + GMAC_ADDR_HIGH(reg));
+			writel(0, ioaddr + GMAC_ADDR_LOW(reg));
+			reg++;
+		}
 	}
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
-- 
2.20.1

