Return-Path: <netdev+bounces-11368-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A8C732CFE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28A612816E0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A56C18B14;
	Fri, 16 Jun 2023 10:05:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B9B18B12
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:05:37 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9779F2137;
	Fri, 16 Jun 2023 03:05:35 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686909934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bu3ZgXdHuaAGXwkANc4+sjRTQos43KxjZuFR24WnayE=;
	b=MB6d8Q+efJDjMCCibSm0q2VQUawspSNupGdeu4AIyYnF8Kr/l2mSqcHmOklij2dXf0xHUk
	tjpJ5i/Mi+0wmJExgdWlqVW/EeLGopEBvb5S7RLExSoEDMwzH5NG5cdznKjVziHCoAhNMv
	HTftMCzak3QoMU8w92BIjqKQtJCwUndNbxSE5G4SDWYX18y5NO+ebczf/lCTkPfOr/KlNQ
	xjmsdTImMhCVfrhyc3SZgGs8QxDijRNejOAKG5t8JlfOiAHMljNy/Ds/Sc8kN6GQlh7sqF
	Wb9IGt0MI7XvUZHfT5Rn5v98g5wbq3yY2zEk2lbKidkyldL9m6SE5koVDAHj9Q==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0F28620010;
	Fri, 16 Jun 2023 10:05:33 +0000 (UTC)
From: alexis.lothore@bootlin.com
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Nicolas Carrier <nicolas.carrier@nav-timing.safrangroup.com>
Subject: [PATCH net-next 3/8] net: stmmac: move PTP interrupt handling to IP-specific DWMAC file
Date: Fri, 16 Jun 2023 12:04:04 +0200
Message-ID: <20230616100409.164583-4-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230616100409.164583-1-alexis.lothore@bootlin.com>
References: <20230616100409.164583-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

As for auxiliary snapshot triggers configuration, reading snapshots depends
on specific registers addresses and layout. As a consequence, move
PTP-specific part of stmmac interrupt handling to specific DWMAC IP file

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  2 +
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 51 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 52 -------------------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 -
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.h  |  3 --
 5 files changed, 53 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index d249a68f6787..9e7ba5f2e53a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -52,6 +52,8 @@
 #define GMAC_L3_ADDR1(reg)		(0x914 + (reg) * 0x30)
 #define GMAC_TIMESTAMP_STATUS		0x00000b20
 #define GMAC_AUXILIARY_CONTROL		0x00000b40	/* Auxiliary Control Reg */
+#define GMAC_AT_NS			0x00000b48	/* Auxiliary Timestamp - Nanoseconds Reg */
+#define GMAC_AT_S			0x00000b4c	/* Auxiliary Timestamp - Seconds Reg */
 
 /* RX Queues Routing */
 #define GMAC_RXQCTRL_AVCPQ_MASK		GENMASK(2, 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 01c0822d37e6..b36fbb0fa5da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
+#include "stmmac_ptp.h"
 #include "dwmac4.h"
 #include "dwmac5.h"
 
@@ -798,9 +799,56 @@ static int dwmac4_irq_mtl_status(struct stmmac_priv *priv,
 	return ret;
 }
 
+static void get_ptptime(void __iomem *ioaddr, u64 *ptp_time)
+{
+	u64 ns;
+
+	ns = readl(ioaddr + GMAC_AT_NS);
+	ns += readl(ioaddr + GMAC_AT_S) * NSEC_PER_SEC;
+
+	*ptp_time = ns;
+}
+
+static void dwmac4_ptp_isr(struct stmmac_priv *priv)
+{
+	u32 num_snapshot, ts_status;
+	struct ptp_clock_event event;
+	unsigned long flags;
+	u64 ptp_time;
+	int i;
+
+	if (priv->plat->int_snapshot_en) {
+		wake_up(&priv->tstamp_busy_wait);
+		return;
+	}
+
+	/* Read timestamp status to clear interrupt from either external
+	 * timestamp or start/end of PPS.
+	 */
+	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
+
+	if (!priv->plat->ext_snapshot_en)
+		return;
+
+	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
+		       GMAC_TIMESTAMP_ATSNS_SHIFT;
+
+	for (i = 0; i < num_snapshot; i++) {
+		read_lock_irqsave(&priv->ptp_lock, flags);
+		get_ptptime(priv->ioaddr, &ptp_time);
+		read_unlock_irqrestore(&priv->ptp_lock, flags);
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = 0;
+		event.timestamp = ptp_time;
+		ptp_clock_event(priv->ptp_clock, &event);
+	}
+}
+
 static int dwmac4_irq_status(struct mac_device_info *hw,
 			     struct stmmac_extra_stats *x)
 {
+	struct stmmac_priv *priv =
+		container_of(x, struct stmmac_priv, xstats);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 intr_status = readl(ioaddr + GMAC_INT_STATUS);
 	u32 intr_enable = readl(ioaddr + GMAC_INT_EN);
@@ -841,6 +889,9 @@ static int dwmac4_irq_status(struct mac_device_info *hw,
 			x->irq_rx_path_exit_lpi_mode_n++;
 	}
 
+	if (intr_status & time_stamp_irq)
+		dwmac4_ptp_isr(priv);
+
 	dwmac_pcs_isr(ioaddr, GMAC_PCS_BASE, intr_status, x);
 	if (intr_status & PCS_RGSMIIIS_IRQ)
 		dwmac4_phystatus(ioaddr, x);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 8b50f03056b7..2cd0ec17f4c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -162,56 +162,6 @@ static void get_systime(void __iomem *ioaddr, u64 *systime)
 		*systime = ns + (sec1 * 1000000000ULL);
 }
 
-static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
-{
-	u64 ns;
-
-	ns = readl(ptpaddr + PTP_ATNR);
-	ns += readl(ptpaddr + PTP_ATSR) * NSEC_PER_SEC;
-
-	*ptp_time = ns;
-}
-
-static void timestamp_interrupt(struct stmmac_priv *priv)
-{
-	u32 num_snapshot, ts_status, tsync_int;
-	struct ptp_clock_event event;
-	unsigned long flags;
-	u64 ptp_time;
-	int i;
-
-	if (priv->plat->int_snapshot_en) {
-		wake_up(&priv->tstamp_busy_wait);
-		return;
-	}
-
-	tsync_int = readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE;
-
-	if (!tsync_int)
-		return;
-
-	/* Read timestamp status to clear interrupt from either external
-	 * timestamp or start/end of PPS.
-	 */
-	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
-
-	if (!priv->plat->ext_snapshot_en)
-		return;
-
-	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
-		       GMAC_TIMESTAMP_ATSNS_SHIFT;
-
-	for (i = 0; i < num_snapshot; i++) {
-		read_lock_irqsave(&priv->ptp_lock, flags);
-		get_ptptime(priv->ptpaddr, &ptp_time);
-		read_unlock_irqrestore(&priv->ptp_lock, flags);
-		event.type = PTP_CLOCK_EXTTS;
-		event.index = 0;
-		event.timestamp = ptp_time;
-		ptp_clock_event(priv->ptp_clock, &event);
-	}
-}
-
 const struct stmmac_hwtimestamp stmmac_ptp = {
 	.config_hw_tstamping = config_hw_tstamping,
 	.init_systime = init_systime,
@@ -219,6 +169,4 @@ const struct stmmac_hwtimestamp stmmac_ptp = {
 	.config_addend = config_addend,
 	.adjust_systime = adjust_systime,
 	.get_systime = get_systime,
-	.get_ptptime = get_ptptime,
-	.timestamp_interrupt = timestamp_interrupt,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5c645b6d5660..4f0ef73d5121 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5804,8 +5804,6 @@ static void stmmac_common_interrupt(struct stmmac_priv *priv)
 			else
 				netif_carrier_off(priv->dev);
 		}
-
-		stmmac_timestamp_interrupt(priv, priv);
 	}
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index 9e0ff2cec352..92ed421702b9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -23,9 +23,6 @@
 #define	PTP_STSUR	0x10	/* System Time – Seconds Update Reg */
 #define	PTP_STNSUR	0x14	/* System Time – Nanoseconds Update Reg */
 #define	PTP_TAR		0x18	/* Timestamp Addend Reg */
-#define	PTP_ACR		0x40	/* Auxiliary Control Reg */
-#define	PTP_ATNR	0x48	/* Auxiliary Timestamp - Nanoseconds Reg */
-#define	PTP_ATSR	0x4c	/* Auxiliary Timestamp - Seconds Reg */
 
 #define	PTP_STNSUR_ADDSUB_SHIFT	31
 #define	PTP_DIGITAL_ROLLOVER_MODE	0x3B9ACA00	/* 10e9-1 ns */
-- 
2.41.0


