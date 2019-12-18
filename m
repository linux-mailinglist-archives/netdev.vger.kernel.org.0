Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040571244AC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfLRKdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:33:45 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:46470 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726723AbfLRKdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:33:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BFB254052A;
        Wed, 18 Dec 2019 10:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576665201; bh=vuO/iRik/hGL2Vv+JKcoZy+K4zCKCj0tWBiTM++ZPfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=PffUb5PVDywRMU9+q050nJJypTkUbmuWL+jeWOsz1iq70N7R5+/cZPEuxRN3FuuYg
         ENz87FkhHqw0nEpBDUHEPzJXP9X497BIx/nn1/roGb9jJaZ9+B3D8nlnTtIzPkvqTy
         Js4DZ19oRzfQB1J/4h3Dp2H3IJM1zQHsWEldoBuA/JySXWfSNDdKxKjo+AXD2Vubay
         2MnS0BXSNnoJSnx4j2PBlVAk2vOQnoQ76jZD1i1sRJL5TgXAiWnJ6Oj/a4Rm7VbGyg
         1xlDo2mj3LDpxWWX/1fbO+zN5zJu6cydW4VnP7hBQgtqNRrdAACR/wrKZpDNtCsB1D
         YrptOtWkxXltg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 91E53A0098;
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
Subject: [PATCH net-next 4/7] net: stmmac: Add Frame Preemption support using TAPRIO API
Date:   Wed, 18 Dec 2019 11:33:08 +0100
Message-Id: <54e12f671c58f14a2d8a3a54e5d6d0f7d78f1c93.1576664870.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the support for Frame Preemption using TAPRIO API. This works along
with EST feature and allows to select if preemptable traffic shall be
sent during specific queues opening time.

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
 drivers/net/ethernet/stmicro/stmmac/common.h    |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h      |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 29 ++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 2f1fc93a9b1e..09c72025ed3e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -367,6 +367,7 @@ struct dma_features {
 	unsigned int estwid;
 	unsigned int estdep;
 	unsigned int estsel;
+	unsigned int fpesel;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index e9355d05b3c2..c3ca3a3b2421 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -374,6 +374,8 @@ struct stmmac_ops {
 	void (*set_arp_offload)(struct mac_device_info *hw, bool en, u32 addr);
 	int (*est_configure)(void __iomem *ioaddr, struct stmmac_est *cfg,
 			     unsigned int ptp_rate);
+	void (*fpe_configure)(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
+			      bool enable);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -462,6 +464,8 @@ struct stmmac_ops {
 	stmmac_do_void_callback(__priv, mac, set_arp_offload, __args)
 #define stmmac_est_configure(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, est_configure, __args)
+#define stmmac_fpe_configure(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, fpe_configure, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 58d4ce094381..8ff8f9b9bb22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -597,6 +597,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
 	struct plat_stmmacenet_data *plat = priv->plat;
 	struct timespec64 time;
+	bool fpe = false;
 	int i, ret = 0;
 
 	if (!priv->dma_cap.estsel)
@@ -667,8 +668,23 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 			return -ERANGE;
 		if (gates > GENMASK(31 - wid, 0))
 			return -ERANGE;
-		if (qopt->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
+
+		switch (qopt->entries[i].command) {
+		case TC_TAPRIO_CMD_SET_GATES:
+			if (fpe)
+				return -EINVAL;
+			break;
+		case TC_TAPRIO_CMD_SET_AND_HOLD:
+			gates |= BIT(0);
+			fpe = true;
+			break;
+		case TC_TAPRIO_CMD_SET_AND_RELEASE:
+			gates &= ~BIT(0);
+			fpe = true;
+			break;
+		default:
 			return -EOPNOTSUPP;
+		}
 
 		priv->plat->est->gcl[i] = delta_ns | (gates << wid);
 	}
@@ -681,6 +697,17 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	priv->plat->est->ctr[0] = (u32)(qopt->cycle_time % NSEC_PER_SEC);
 	priv->plat->est->ctr[1] = (u32)(qopt->cycle_time / NSEC_PER_SEC);
 
+	if (fpe && !priv->dma_cap.fpesel)
+		return -EOPNOTSUPP;
+
+	ret = stmmac_fpe_configure(priv, priv->ioaddr,
+				   priv->plat->tx_queues_to_use,
+				   priv->plat->rx_queues_to_use, fpe);
+	if (ret && fpe) {
+		netdev_err(priv->dev, "failed to enable Frame Preemption\n");
+		return ret;
+	}
+
 	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 				   priv->plat->clk_ptp_rate);
 	if (ret) {
-- 
2.7.4

