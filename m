Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBAC172E4
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfEHHva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:51:30 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:53824 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbfEHHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A06D8C0104;
        Wed,  8 May 2019 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301882; bh=5GcpIZToM0XZw8U1w+svdUz7F40dnGaIgWn064KmYDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=dqSMxH3Wn4rJ0EvAVK4Kxq/cgwPcKj7xhfEg45E1g2EZCyMW5VY24XCpCZgz2/7Q+
         H83NWJdod5cSwh61OCRFUX0R0DmSmY4tRf6ZIox1jFprh+djFTjjQ+Q5r/pPlFt/9v
         jT7CdZDeCT08HzwSyLZwAFphNMZCSwKl2m5McdtoSMbX75Aa0dbNLwgM4IW8HTAnz/
         gGyg1uROZauD/rrWf8nySyL5gLuwx9BBYhEqXdYE95OOqV5D4eCUkam/ZU8Ao9BrwY
         70xE+UlX7J7KZDkL8SJ0cA6ZqyLVnhZ+96PfiqqMGUwT7+XnYOSN345yDkIa3ANJCh
         xjuM+QQhmqFcQ==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 59E73A02DC;
        Wed,  8 May 2019 07:51:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 8C8093D520;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 04/11] net: stmmac: dwmac4/5: Add MAC loopback support
Date:   Wed,  8 May 2019 09:51:04 +0200
Message-Id: <01812f5cb5b8bdab3d7df3656b49f069dc7f5af1.1557300602.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
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

