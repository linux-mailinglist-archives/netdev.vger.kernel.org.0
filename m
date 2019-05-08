Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828C0172EE
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfEHHv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:51:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53830 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725860AbfEHHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A0228C00FF;
        Wed,  8 May 2019 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301882; bh=DK01hEvtlCe9jWvld2dQ+H24fyVE/McsxQGGm9vTecw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=UuvfZx38FdPYCmObPbXYqc0ZkqyUgMDUiZhnTqbyXT+e3q5HwG0uXAX9ln3NtwDph
         sKIpi1pPLGnquNiNHTJnRuHgGGeytoXyXggNzYgDe6nIbbtCaY29Wga+eXxFEcBuYD
         zVi22TlH6x/JHOSsWECK71WzJf8k70tdrGJ1qhwU6sjY7QSaoIVZdWTpW2k4jZ4cy8
         zI4sg1MkV2aiXZvRavL/G+0+pYFzX8ZEJD6vH79bg2tTUY1jWoodRnO/iJTPmwgixk
         UrZlnja3TOX3zHXQP4v8jcxDDv2akd6okvKfEhh6ENxYUGefwHwAlc7IyrU9DmOd1z
         iMQLv5uYiAeDQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 55FA8A02DB;
        Wed,  8 May 2019 07:51:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 790363D51D;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 03/11] net: stmmac: dwmac1000: Add MAC loopback support
Date:   Wed,  8 May 2019 09:51:03 +0200
Message-Id: <66de0c906104d6c4d1f641e366e0e80fc2e3d364.1557300602.git.joabreu@synopsys.com>
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
loopback callback in dwmac1000 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
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

