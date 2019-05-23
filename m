Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4A2773A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfEWHiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:38:11 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43612 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730188AbfEWHhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:31 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4BB32C0199;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597058; bh=UiKf7HDuJujDmZp22y/1Bu+T4dmQ9e5+EBajegy2VME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=dyQiukpOyxpmomgcInVHhluX8nMcfekCiAwczhUm+6gEMU0su+36ieJ2GJnQXqNTp
         jc1NLEPOMWQ5srF/8mqc0Bpr7rPwvzFCvP3yUHmfDVBlNK4NM4p3j66//d12N1w72J
         quUTg2gkpLhG7oWV9OMWc4fgktEr7oZNxBtaQ/3TxIlTMsZNWyllP62HgT5yQIUi9i
         inNlX+Nozpd56c6XLhkwMmsMnWN1wN51gYv32M5qJwT39pr8BDeurBStQ6CYMo/+le
         tkLdZbOWcez0NDkOLsNj09u5r/GQaRghWsmqFHJPb0+JXr7txtLgnbTC+fYfr9uZId
         ALt+ULfQvZf+A==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5DB23A00A2;
        Thu, 23 May 2019 07:37:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 4EE423D944;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 06/18] net: ethernet: stmmac: dwmac-sun8i: Enable control of loopback
Date:   Thu, 23 May 2019 09:36:56 +0200
Message-Id: <c1c6edfd3f0461bad427cb9174c6d33e9d71fc7a.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

This patch enable use of set_mac_loopback in dwmac-sun8i

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 195669f550f0..f7ff5858e522 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -986,6 +986,18 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 		regulator_disable(gmac->regulator);
 }
 
+static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + EMAC_BASIC_CTL0);
+
+	if (enable)
+		value |= EMAC_LOOPBACK;
+	else
+		value &= ~EMAC_LOOPBACK;
+
+	writel(value, ioaddr + EMAC_BASIC_CTL0);
+}
+
 static const struct stmmac_ops sun8i_dwmac_ops = {
 	.core_init = sun8i_dwmac_core_init,
 	.set_mac = sun8i_dwmac_set_mac,
@@ -995,6 +1007,7 @@ static const struct stmmac_ops sun8i_dwmac_ops = {
 	.flow_ctrl = sun8i_dwmac_flow_ctrl,
 	.set_umac_addr = sun8i_dwmac_set_umac_addr,
 	.get_umac_addr = sun8i_dwmac_get_umac_addr,
+	.set_mac_loopback = sun8i_dwmac_set_mac_loopback,
 };
 
 static struct mac_device_info *sun8i_dwmac_setup(void *ppriv)
-- 
2.7.4

