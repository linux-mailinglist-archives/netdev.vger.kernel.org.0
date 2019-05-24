Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E28A292F3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389425AbfEXIUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:20:37 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:35508 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389156AbfEXIUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:37 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6E8F5C0124;
        Fri, 24 May 2019 08:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686044; bh=HP2s/EkjTJBIBsZOUwv1Fy9IpMGJCaEYmoUoQeH8v2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YR4pEakFYPc5mmIMfADc3Fyzx9R7EAGcG6SQ3D3irJGC2+lJBzA/eOks2ivmCFoYk
         JP2YmDa5qf0d2n6qJBjM4qK17v58mflmuyTXOfMpA067dAMCZc5lCENjTEHFwOUXlq
         m1En3iuyGTnJAmJ+TkUgwSMmwskCMhJBZzkw740iX9nyC/GVIDPmSdT5KpQm7+Q+4z
         VYvnVLNvLLRbZPHWFOzJDayktpfq9I7ORAa2HAWUX3KvGw6+IZXnAtvC32KP0p/D3U
         XViyFdtyhWVUyFcHLc2qPrdVqgodxYW4fKixNgwLQ9y9z461D6YDhaXNeBmH8o2jLK
         1X/kM2bSGWh6w==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 77B17A0245;
        Fri, 24 May 2019 08:20:36 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 97A1E3FAF6;
        Fri, 24 May 2019 10:20:35 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 04/18] net: stmmac: dwmac4/5: Add MAC loopback support
Date:   Fri, 24 May 2019 10:20:12 +0200
Message-Id: <c244efd73eabc6b8ff87558d10cf63705e3d6982.1558685827.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
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
index b4bb5629de38..45c294f39ea6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -703,6 +703,18 @@ static void dwmac4_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
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
@@ -732,6 +744,7 @@ const struct stmmac_ops dwmac4_ops = {
 	.pcs_get_adv_lp = dwmac4_get_adv_lp,
 	.debug = dwmac4_debug,
 	.set_filter = dwmac4_set_filter,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
 const struct stmmac_ops dwmac410_ops = {
@@ -763,6 +776,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.pcs_get_adv_lp = dwmac4_get_adv_lp,
 	.debug = dwmac4_debug,
 	.set_filter = dwmac4_set_filter,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -799,6 +813,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.safety_feat_dump = dwmac5_safety_feat_dump,
 	.rxp_config = dwmac5_rxp_config,
 	.flex_pps_config = dwmac5_flex_pps_config,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
-- 
2.7.4

