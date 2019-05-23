Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4375D2774D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfEWHha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:37:30 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46674 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbfEWHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 83279C0A54;
        Thu, 23 May 2019 07:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597035; bh=Ky3auTImAfe37zrIkXpYgTd4Sk3t6wEQs0RE5Rcse8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=bYZ29dV83vzla+JK8x+MU8/ogkBZvGKVET8LdN/VC8GiHBiw8aJ2D2PjidhodCBth
         3wRYFKex2mGgPhIq2PJA3jPWj2rvUp8oHCkaJ11NrN7jz1oIYP1Uf1lz752ST424uR
         DpOOwll22AixfZn6uoh9rzaHW7fnNOijyfX419XG30K8sa3Tw22sXzESMopRy9d2xd
         vjEjjsAzhXgcGhQmUJte/5EMOZ2+y3KXDUiG1qxs5jmVhtD0WbEQniP2GovWFQiZeK
         h33bK6JexTOK0f7Zl32eoces6qEsVI/KaBtXFNqpFvxigM3HopxuhUR8rmM+XjSuDg
         o9FeDNRh+3JBw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id DF2C7A0097;
        Thu, 23 May 2019 07:37:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 059DC3D937;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH net-next 02/18] net: stmmac: dwmac100: Add MAC loopback support
Date:   Thu, 23 May 2019 09:36:52 +0200
Message-Id: <1e869f7e767c8937e0e38c4c1492f1f896412d90.1558596600.git.joabreu@synopsys.com>
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
loopback callback in dwmac100 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
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

