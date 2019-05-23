Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0E27752
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfEWHha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:37:30 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:46686 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbfEWHh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 831E3C0095;
        Thu, 23 May 2019 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597035; bh=pP5DR9i3AWyLzsZCvhK9gxgeY8E2DkEss6ulcg1/dFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=mZSR9f3kiHtjQIrqbVtyFlfUrtPrp5E2sP7EgKrfWx5qY5Oi3ix7HXRI0nhFNoeIe
         dqhHiI7K70UopjKObihk3RjtWqbcywS1iN9bphjIsF9/9oDwy46j56wahXbkHUIdAC
         GcHEWSOCYDALcEwNuIXqGoguwiwNmpKkbAWFX4i0zDHWmkK66YHdkr+tzPa9ZcDqcD
         Reab0W6uycxrIRDc6RgJc7QY3lHlGtnu1obv7kzYtzlDcgp4utVdl74WqURBF3aBOe
         aXSd+ezEvuhN4I8BUqr/Wbq+nxgosCz52VfsLE1RAlnno23tf7hEq9+tvYig1SsVCI
         xxFz3l4XCuLSA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id E625BA00A0;
        Thu, 23 May 2019 07:37:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 172153D93B;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH net-next 03/18] net: stmmac: dwmac1000: Add MAC loopback support
Date:   Thu, 23 May 2019 09:36:53 +0200
Message-Id: <2d2987abead97d9ce2ca82cdf543bce06bb63b1d.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the addition of stmmac selftests we implement the MAC
loopback callback in dwmac1000 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 0877bde6e860..398303c783f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -499,6 +499,18 @@ static void dwmac1000_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
 		x->mac_gmii_rx_proto_engine++;
 }
 
+static void dwmac1000_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + GMAC_CONTROL);
+
+	if (enable)
+		value |= GMAC_CONTROL_LM;
+	else
+		value &= ~GMAC_CONTROL_LM;
+
+	writel(value, ioaddr + GMAC_CONTROL);
+}
+
 const struct stmmac_ops dwmac1000_ops = {
 	.core_init = dwmac1000_core_init,
 	.set_mac = stmmac_set_mac,
@@ -518,6 +530,7 @@ const struct stmmac_ops dwmac1000_ops = {
 	.pcs_ctrl_ane = dwmac1000_ctrl_ane,
 	.pcs_rane = dwmac1000_rane,
 	.pcs_get_adv_lp = dwmac1000_get_adv_lp,
+	.set_mac_loopback = dwmac1000_set_mac_loopback,
 };
 
 int dwmac1000_setup(struct stmmac_priv *priv)
-- 
2.7.4

