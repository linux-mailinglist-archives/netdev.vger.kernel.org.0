Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5081727751
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbfEWHj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:39:26 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:46704 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727919AbfEWHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5A157C0A67;
        Thu, 23 May 2019 07:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597036; bh=b2ymDc1sTBfRFOKmSWq0wNVbV9n3u1N7F2xrFuu36MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=O/GHoRiFwLSVpRiCWp6sHpFlGDEowA/ClcJ/bNNeNZcU4REOIh2fRrykjlqzWEI6Z
         tsq+relg4fgYECHWrC6JBH5tvgs1e4okYOSBsF/hYOEj0hWoFT2vhpspJvB3nscVb9
         3/+gnPGM8CcdsLBX5h06f0pLC9dWfKAY5Vt1HAzUyi5zt/WTNWZyG86E4jQPENF8u2
         Zkg25bEQKXduwzscqzxXI3Ke4rRTPIqGT9iOO/vRjmk7OmjjpWQYbzHYe5AsgqcZFw
         /BG6R1B76KTTd9b24vSemMf2K/nic1//f0/+hOu8Thg0fgXh4RtM6ULChSA8ReRmjg
         boZX8jkZTuVvw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id D445FA0099;
        Thu, 23 May 2019 07:37:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 3B71D3D941;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH net-next 05/18] net: stmmac: dwxgmac2: Add MAC loopback support
Date:   Thu, 23 May 2019 09:36:55 +0200
Message-Id: <acfcf629ca6345f315014cc6fd7ab5047eb5ed02.1558596600.git.joabreu@synopsys.com>
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
loopback callback in dwxgmac2 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
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

