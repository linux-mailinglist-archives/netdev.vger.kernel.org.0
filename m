Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A76F2773B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbfEWHha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:37:30 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46698 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbfEWHh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 89AB7C0A62;
        Thu, 23 May 2019 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597035; bh=vMtkeGJYR0zyPoI1aSHR7lqITOvxpI1w439NYnSYuo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=PvXYs1VDJuY2z4jYpViAsdw6lojp/C8J5++6T4j6pThZLelIatZs24JPiZS3pCw49
         WbRwxsMU/xHuOTLxYxkfYbq8cyoaNNPRI3C0j7k3kd/MCrZcTr8kikwKMjyjKOZ6fE
         IQ6xF+0DNLcwzFkwa2GNxGAg7E39///gG8rA7Q5+6Ge0XGoI59kSMdZhEqZ3ZKmzXB
         LLUiSpRktsO1/CoRSd09LSed84mHjcgIo8Ca6b81ZbPZbskherhWrhi88kB80TLxYd
         sJJc8YTqOh/RNKf90FT8vPzwRkrY7FxHdM0OrJPkTenmJXtqYv32mIE+8Uq8eHvkPY
         rCiDTbBGuuUgw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 012A4A00A3;
        Thu, 23 May 2019 07:37:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 2A06C3D93E;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH net-next 04/18] net: stmmac: dwmac4/5: Add MAC loopback support
Date:   Thu, 23 May 2019 09:36:54 +0200
Message-Id: <aeea6b531e9a738163f61a99ecc650463576e376.1558596600.git.joabreu@synopsys.com>
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
loopback callback in dwmac4/5 cores.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index eb013d54025a..3dddd7902b0f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -160,6 +160,7 @@ enum power_event {
 #define GMAC_CONFIG_PS			BIT(15)
 #define GMAC_CONFIG_FES			BIT(14)
 #define GMAC_CONFIG_DM			BIT(13)
+#define GMAC_CONFIG_LM			BIT(12)
 #define GMAC_CONFIG_DCRS		BIT(9)
 #define GMAC_CONFIG_TE			BIT(1)
 #define GMAC_CONFIG_RE			BIT(0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 7e5d5db0d516..2f1a2a6f9b33 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -701,6 +701,18 @@ static void dwmac4_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
 		x->mac_gmii_rx_proto_engine++;
 }
 
+static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + GMAC_CONFIG);
+
+	if (enable)
+		value |= GMAC_CONFIG_LM;
+	else
+		value &= ~GMAC_CONFIG_LM;
+
+	writel(value, ioaddr + GMAC_CONFIG);
+}
+
 const struct stmmac_ops dwmac4_ops = {
 	.core_init = dwmac4_core_init,
 	.set_mac = stmmac_set_mac,
@@ -730,6 +742,7 @@ const struct stmmac_ops dwmac4_ops = {
 	.pcs_get_adv_lp = dwmac4_get_adv_lp,
 	.debug = dwmac4_debug,
 	.set_filter = dwmac4_set_filter,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
 const struct stmmac_ops dwmac410_ops = {
@@ -761,6 +774,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.pcs_get_adv_lp = dwmac4_get_adv_lp,
 	.debug = dwmac4_debug,
 	.set_filter = dwmac4_set_filter,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -797,6 +811,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.safety_feat_dump = dwmac5_safety_feat_dump,
 	.rxp_config = dwmac5_rxp_config,
 	.flex_pps_config = dwmac5_flex_pps_config,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
-- 
2.7.4

