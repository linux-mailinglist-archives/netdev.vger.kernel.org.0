Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05176172EF
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfEHHwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:52:53 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:53836 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbfEHHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 59476C010D;
        Wed,  8 May 2019 07:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301883; bh=g7s+I8un+FY7/k4BwweRm2ebGOtvijMXRTX2Cm1zU7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=GG8f5Ejd9f/sSqYsb8EorFjzCYpYd4ZBW9Mom0NEUOPexU6sV2dSiJOXzstwEAStI
         MKuaW66yRRFP6nAeiaPq1FI9qb11Lhwb6AZuSATaFB6cl+3LhDrQHxZiTsWJa9v28r
         1Aji3UMz9pKmPqwizDUieFcdccWoMnNey/OwD8kPEaKFh8NDzCal/dI4zQeS7OWUr7
         sEaibAs9qWHZQaklbX7VPx2WtPQfB1qJw0/CiLacOkv1N+Pm4obC3qjBduKOon10qm
         Y2WVteEz00GSkZJ8M3Erglf2kUpmWzfX1lBHci7MwkLDxK7Y0t+hsb5BMNoZuKw1pz
         diEbZlj7f/8iA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5EE9EA02D0;
        Wed,  8 May 2019 07:51:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 9DAE63D523;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 05/11] net: stmmac: dwxgmac2: Add MAC loopback support
Date:   Wed,  8 May 2019 09:51:05 +0200
Message-Id: <12299cb8b9fdd4d4f482ab10e90b77625d70093e.1557300602.git.joabreu@synopsys.com>
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
loopback callback in dwxgmac2 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 085b700a4994..f629ccc8932a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -29,6 +29,7 @@
 #define XGMAC_CONFIG_GPSL		GENMASK(29, 16)
 #define XGMAC_CONFIG_GPSL_SHIFT		16
 #define XGMAC_CONFIG_S2KP		BIT(11)
+#define XGMAC_CONFIG_LM			BIT(10)
 #define XGMAC_CONFIG_IPC		BIT(9)
 #define XGMAC_CONFIG_JE			BIT(8)
 #define XGMAC_CONFIG_WD			BIT(7)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 64b8cb88ea45..c27b3ca052ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -321,6 +321,18 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	writel(value, ioaddr + XGMAC_PACKET_FILTER);
 }
 
+static void dwxgmac2_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + XGMAC_RX_CONFIG);
+
+	if (enable)
+		value |= XGMAC_CONFIG_LM;
+	else
+		value &= ~XGMAC_CONFIG_LM;
+
+	writel(value, ioaddr + XGMAC_RX_CONFIG);
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -350,6 +362,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.pcs_get_adv_lp = NULL,
 	.debug = NULL,
 	.set_filter = dwxgmac2_set_filter,
+	.set_mac_loopback = dwxgmac2_set_mac_loopback,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
-- 
2.7.4

