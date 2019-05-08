Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB0D172D8
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfEHHvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:51:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53808 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725910AbfEHHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A75A5C010A;
        Wed,  8 May 2019 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301882; bh=/xA5D2KU4oFCZigXo3GxuD0B41696Ac9xBvAFVj5Z6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QdEXCT2SMfcY8E8UWJnndM/ZBwqnQVYyjnmNE4iHST+PSQB+jbkipAFTWXFQxJrbR
         HlgqCI4YmNQH/AtUecW7ywYVLN03qRWxva0Uh2MSL9S2u9JfbiJNQ/r3YcQS1XWNl0
         dHr/vI1vLi28MEaRqoRMn+NoDp4BbWl29dH2KFuM/94t9xOa8kl9vjwegaqq2k+o+V
         Yi+ziuqhuEaDwovQ1lO7wp4HKdvbKZotcG2Vk59MlUpFRpiVM8L4dTQsFGrjCAEPhx
         cEjouaAkLt7SbbM2jCS4H7O7aVAfOjmLQY3S59KrhmUf8EiuI8UdlpW5RzCsXWcaYQ
         LtxDAKOaDIMUQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 54D93A02D9;
        Wed,  8 May 2019 07:51:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 67E9D3D51A;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 02/11] net: stmmac: dwmac100: Add MAC loopback support
Date:   Wed,  8 May 2019 09:51:02 +0200
Message-Id: <2d1be0a657068fa66fb5271e7088705f16f06958.1557300602.git.joabreu@synopsys.com>
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
loopback callback in dwmac100 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
index b735143987e1..d621b5189c41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
@@ -160,6 +160,18 @@ static void dwmac100_pmt(struct mac_device_info *hw, unsigned long mode)
 	return;
 }
 
+static void dwmac100_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + MAC_CONTROL);
+
+	if (enable)
+		value |= MAC_CONTROL_OM;
+	else
+		value &= ~MAC_CONTROL_OM;
+
+	writel(value, ioaddr + MAC_CONTROL);
+}
+
 const struct stmmac_ops dwmac100_ops = {
 	.core_init = dwmac100_core_init,
 	.set_mac = stmmac_set_mac,
@@ -171,6 +183,7 @@ const struct stmmac_ops dwmac100_ops = {
 	.pmt = dwmac100_pmt,
 	.set_umac_addr = dwmac100_set_umac_addr,
 	.get_umac_addr = dwmac100_get_umac_addr,
+	.set_mac_loopback = dwmac100_set_mac_loopback,
 };
 
 int dwmac100_setup(struct stmmac_priv *priv)
-- 
2.7.4

