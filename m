Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1906B1244A6
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfLRKdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:33:22 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:46362 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfLRKdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:33:21 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EF7C9405C6;
        Wed, 18 Dec 2019 10:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576665201; bh=wj6sCtmNcy6nxZMnDQRmD3lTcMPEpv2f8Ae23zQUnfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Al6xwfkkTpgN6/CIyhzEPpgQjYPsmXRxyahxOokpKKehlePwbBQkQvqTYLOwkvsVI
         tLDow+F5u09U73gJqSMVOBlhZrRk5z/WkpFJTQ7TOCREUXwOAWxsUm65VtDn5D2Fn/
         b/0adpvs/op5hUURgh4Bd5iEdxvVHiFsd1uJVs9VBPI1dIuLeDF0qo/FEdSPSc2FrZ
         RuwIkGm6Sd9e8cOYqLdVq+ne1xbqEauoGCaNeX3PHuhgvn0QB/NXxGbZ9Glmx/IEtE
         hFgfey8rwVvgwz3O6eDPmaDQI1m9jn1iFqLqVQ2nVqTErWZU8uf83nvj/BDoDyrGtQ
         FllDaFBzkceVQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id BE22CA00B1;
        Wed, 18 Dec 2019 10:33:19 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Richard.Ong@synopsys.com, Boon Leong <boon.leong.ong@intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: stmmac: mmc: Add Frame Preemption counters on GMAC5+ cores
Date:   Wed, 18 Dec 2019 11:33:11 +0100
Message-Id: <fd0742e12751ee0d2b54aba9464b4ff5387628aa.1576664870.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be useful for debug. Add these counters on GMAC5+ cores just
like we did for XGMAC.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
index 252cf48c5816..a57b0fa815ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
@@ -119,6 +119,13 @@
 #define MMC_RX_ICMP_GD_OCTETS		0x180
 #define MMC_RX_ICMP_ERR_OCTETS		0x184
 
+#define MMC_TX_FPE_FRAG			0x1a8
+#define MMC_TX_HOLD_REQ			0x1ac
+#define MMC_RX_PKT_ASSEMBLY_ERR		0x1c8
+#define MMC_RX_PKT_SMD_ERR		0x1cc
+#define MMC_RX_PKT_ASSEMBLY_OK		0x1d0
+#define MMC_RX_FPE_FRAG			0x1d4
+
 /* XGMAC MMC Registers */
 #define MMC_XGMAC_TX_OCTET_GB		0x14
 #define MMC_XGMAC_TX_PKT_GB		0x1c
@@ -315,6 +322,15 @@ static void dwmac_mmc_read(void __iomem *mmcaddr, struct stmmac_counters *mmc)
 	mmc->mmc_rx_tcp_err_octets += readl(mmcaddr + MMC_RX_TCP_ERR_OCTETS);
 	mmc->mmc_rx_icmp_gd_octets += readl(mmcaddr + MMC_RX_ICMP_GD_OCTETS);
 	mmc->mmc_rx_icmp_err_octets += readl(mmcaddr + MMC_RX_ICMP_ERR_OCTETS);
+
+	mmc->mmc_tx_fpe_fragment_cntr += readl(mmcaddr + MMC_TX_FPE_FRAG);
+	mmc->mmc_tx_hold_req_cntr += readl(mmcaddr + MMC_TX_HOLD_REQ);
+	mmc->mmc_rx_packet_assembly_err_cntr +=
+		readl(mmcaddr + MMC_RX_PKT_ASSEMBLY_ERR);
+	mmc->mmc_rx_packet_smd_err_cntr += readl(mmcaddr + MMC_RX_PKT_SMD_ERR);
+	mmc->mmc_rx_packet_assembly_ok_cntr +=
+		readl(mmcaddr + MMC_RX_PKT_ASSEMBLY_OK);
+	mmc->mmc_rx_fpe_fragment_cntr += readl(mmcaddr + MMC_RX_FPE_FRAG);
 }
 
 const struct stmmac_mmc_ops dwmac_mmc_ops = {
-- 
2.7.4

