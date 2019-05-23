Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437B92772A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbfEWHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:37:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43610 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1730178AbfEWHhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:31 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F3AD2C0197;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597058; bh=XUsua8QiKQIilIpw5Wo6XrXlSz3zgdfM7HiyZjxTcjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=FdxZRRlJJxMRJTZu55BB69hos4AMhBP+mYiV0/oFYOkc3svfIX7T6SoWPjIEzeyDo
         L9i98oX33S3DZarGzL9EIvYyQlMpmBj96+kybnLAbTbP2ovcC4T35hLZvk/AI7Oh26
         U1be3V8yKih4qQl6wWBj+K1W02OmSM0FIgMYWA5zv6JNSHtNwpHGX51wqaAWAaCHTX
         VM92R+Sgj3+5zSerW3bNtV001Z5RM1k/rVbMrKML4NFnEMLxpjRkPrqO1IyBDX0sYY
         LVcrqDRH+ZYDo5qfDQQzqfLoVFZwSQVpdpuDZYR8oZSv8XkBR+aFFyTcUfYeggKoVu
         C1QU/G5fyWI6w==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7B0C2A0242;
        Thu, 23 May 2019 07:37:30 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 2A3223D96D;
        Thu, 23 May 2019 09:37:29 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 17/18] net: stmmac: dwmac4/5: Clear unused address entries
Date:   Thu, 23 May 2019 09:37:07 +0200
Message-Id: <83f187d192b6c43262d23a56a68096ffff71fa7a.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case we don't use a given address entry we need to clear it because
it could contain previous values that are no longer valid.

Found out while running stmmac selftests.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 094bd069c093..9f14943ca34c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -446,14 +446,20 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
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
2.7.4

