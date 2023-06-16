Return-Path: <netdev+bounces-11367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A591F732CF0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59893281591
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C8F17FEC;
	Fri, 16 Jun 2023 10:05:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DCE182D5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:05:36 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0992D67;
	Fri, 16 Jun 2023 03:05:34 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686909932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlKfBubQaLPW6K+ql37Q+2HGvyJMouSBVoPzyWY8+lQ=;
	b=abt1qeClvlCyL9z75uDOY0nQ5EnUQwmGYXSQLVRjO5Q+K0qaH5HZFECsb/jfWAfTGmiwiI
	K2G6belDwjs+QVzaFr84OxGGRJanZVw5Tt7qGn91iooeVuNNxqb3F3FTbyS/BAy3Q366vo
	ITok6AyovOMB4aJhksCAVYNMrYkfnwW4Ryn6V5Ijiw1pjNXEnR9nPeF1zsV96rM0EIRTLf
	tsK5I/FGVNRZwUIaxl+U5XzLctE3ZsMCdYDT2JoUaxCokTxVIyJcIj3bmR/q/9XJ1BORYA
	Gy2ZlECDEv9Cf5E2SCPYz+WWeNUWpHcp29AIORVPsW3Hb8B5NNhTTQcum2LiFw==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id D258D2000D;
	Fri, 16 Jun 2023 10:05:31 +0000 (UTC)
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
Subject: [PATCH net-next 2/8] net: stmmac: populate dwmac4 callbacks for auxiliary snapshots
Date: Fri, 16 Jun 2023 12:04:03 +0200
Message-ID: <20230616100409.164583-3-alexis.lothore@bootlin.com>
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

Contrary to generic PTP registers (timestamp control, system time, time
update, addend, etc), auxiliary snapshots registers addresses and layout
differ depending on exact DWMAC IP. Current implementation matches register
layout for DWMAC4, so move current behaviour from stmmac_ptp.c to
dwmac4_core.c. Wire those callbacks for all DWMAC4 versions.

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  | 22 ++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 34 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 24 +++----------
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.h  | 19 -----------
 4 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index d3c5306f1c41..d249a68f6787 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -51,6 +51,7 @@
 #define GMAC_L3_ADDR0(reg)		(0x910 + (reg) * 0x30)
 #define GMAC_L3_ADDR1(reg)		(0x914 + (reg) * 0x30)
 #define GMAC_TIMESTAMP_STATUS		0x00000b20
+#define GMAC_AUXILIARY_CONTROL		0x00000b40	/* Auxiliary Control Reg */
 
 /* RX Queues Routing */
 #define GMAC_RXQCTRL_AVCPQ_MASK		GENMASK(2, 0)
@@ -580,6 +581,27 @@ static inline u32 mtl_low_credx_base_addr(const struct dwmac4_addrs *addrs,
 #define GMAC_PHYIF_CTRLSTATUS_SPEED_25		0x1
 #define GMAC_PHYIF_CTRLSTATUS_SPEED_2_5		0x0
 
+/* Auxiliary Control defines */
+#define	PTP_ACR_ATSFC		BIT(0)	/* Auxiliary Snapshot FIFO Clear */
+#define	PTP_ACR_ATSEN0		BIT(4)	/* Auxiliary Snapshot 0 Enable */
+#define	PTP_ACR_ATSEN1		BIT(5)	/* Auxiliary Snapshot 1 Enable */
+#define	PTP_ACR_ATSEN2		BIT(6)	/* Auxiliary Snapshot 2 Enable */
+#define	PTP_ACR_ATSEN3		BIT(7)	/* Auxiliary Snapshot 3 Enable */
+#define	PTP_ACR_ATSEN_SHIFT	5	/* Auxiliary Snapshot shift */
+#define	PTP_ACR_MASK		GENMASK(7, 4)	/* Aux Snapshot Mask */
+#define	PMC_ART_VALUE0		0x01	/* PMC_ART[15:0] timer value */
+#define	PMC_ART_VALUE1		0x02	/* PMC_ART[31:16] timer value */
+#define	PMC_ART_VALUE2		0x03	/* PMC_ART[47:32] timer value */
+#define	PMC_ART_VALUE3		0x04	/* PMC_ART[63:48] timer value */
+#define	GMAC4_ART_TIME_SHIFT	16	/* ART TIME 16-bits shift */
+
+enum aux_snapshot {
+	AUX_SNAPSHOT0 = 0x10,
+	AUX_SNAPSHOT1 = 0x20,
+	AUX_SNAPSHOT2 = 0x40,
+	AUX_SNAPSHOT3 = 0x80,
+};
+
 extern const struct stmmac_dma_ops dwmac4_dma_ops;
 extern const struct stmmac_dma_ops dwmac410_dma_ops;
 #endif /* __DWMAC4_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 03b1c5a97826..01c0822d37e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -1129,6 +1129,34 @@ static int dwmac4_config_l4_filter(struct mac_device_info *hw, u32 filter_no,
 	return 0;
 }
 
+static void dwmac4_extts_configure(void __iomem *ioaddr, int ext_snapshot_num, bool on,
+				   struct net_device *dev)
+{
+	u32 acr_value;
+
+	acr_value = readl(ioaddr + GMAC_AUXILIARY_CONTROL);
+	acr_value &= ~PTP_ACR_MASK;
+	if (on) {
+		/* Enable External snapshot trigger */
+		acr_value |= ext_snapshot_num;
+		acr_value |= PTP_ACR_ATSFC;
+		netdev_dbg(dev, "Auxiliary Snapshot %d enabled.\n",
+			   ext_snapshot_num >> PTP_ACR_ATSEN_SHIFT);
+	} else {
+		netdev_dbg(dev, "Auxiliary Snapshot %d disabled.\n",
+			   ext_snapshot_num >> PTP_ACR_ATSEN_SHIFT);
+	}
+	writel(acr_value, ioaddr + GMAC_AUXILIARY_CONTROL);
+}
+
+static int dwmac4_clear_snapshot_fifo(void __iomem *ioaddr)
+{
+	u32 acr_value;
+
+	return readl_poll_timeout(ioaddr + GMAC_AUXILIARY_CONTROL, acr_value,
+				  !(acr_value & PTP_ACR_ATSFC), 10, 10000);
+}
+
 const struct stmmac_ops dwmac4_ops = {
 	.core_init = dwmac4_core_init,
 	.set_mac = stmmac_set_mac,
@@ -1169,6 +1197,8 @@ const struct stmmac_ops dwmac4_ops = {
 	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
 	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
 	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
+	.extts_configure = dwmac4_extts_configure,
+	.clear_snapshot_fifo = dwmac4_clear_snapshot_fifo
 };
 
 const struct stmmac_ops dwmac410_ops = {
@@ -1217,6 +1247,8 @@ const struct stmmac_ops dwmac410_ops = {
 	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
 	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
 	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
+	.extts_configure = dwmac4_extts_configure,
+	.clear_snapshot_fifo = dwmac4_clear_snapshot_fifo
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -1269,6 +1301,8 @@ const struct stmmac_ops dwmac510_ops = {
 	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
 	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
 	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
+	.extts_configure = dwmac4_extts_configure,
+	.clear_snapshot_fifo = dwmac4_clear_snapshot_fifo
 };
 
 static u32 dwmac4_get_num_vlan(void __iomem *ioaddr)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index b4388ca8d211..167bfbf68911 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -165,11 +165,9 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 {
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
-	void __iomem *ptpaddr = priv->ptpaddr;
 	struct stmmac_pps_cfg *cfg;
 	int ret = -EOPNOTSUPP;
 	unsigned long flags;
-	u32 acr_value;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
@@ -194,26 +192,12 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 	case PTP_CLK_REQ_EXTTS:
 		priv->plat->ext_snapshot_en = on;
 		mutex_lock(&priv->aux_ts_lock);
-		acr_value = readl(ptpaddr + PTP_ACR);
-		acr_value &= ~PTP_ACR_MASK;
-		if (on) {
-			/* Enable External snapshot trigger */
-			acr_value |= priv->plat->ext_snapshot_num;
-			acr_value |= PTP_ACR_ATSFC;
-			netdev_dbg(priv->dev, "Auxiliary Snapshot %d enabled.\n",
-				   priv->plat->ext_snapshot_num >>
-				   PTP_ACR_ATSEN_SHIFT);
-		} else {
-			netdev_dbg(priv->dev, "Auxiliary Snapshot %d disabled.\n",
-				   priv->plat->ext_snapshot_num >>
-				   PTP_ACR_ATSEN_SHIFT);
-		}
-		writel(acr_value, ptpaddr + PTP_ACR);
+		stmmac_extts_configure(priv, priv->ioaddr,
+				       priv->plat->ext_snapshot_num, on,
+				       priv->dev);
 		mutex_unlock(&priv->aux_ts_lock);
 		/* wait for auxts fifo clear to finish */
-		ret = readl_poll_timeout(ptpaddr + PTP_ACR, acr_value,
-					 !(acr_value & PTP_ACR_ATSFC),
-					 10, 10000);
+		ret = stmmac_clear_snapshot_fifo(priv, priv->ioaddr);
 		break;
 
 	default:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index bf619295d079..9e0ff2cec352 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -67,25 +67,6 @@
 #define	PTP_SSIR_SSINC_MAX		0xff
 #define	GMAC4_PTP_SSIR_SSINC_SHIFT	16
 
-/* Auxiliary Control defines */
-#define	PTP_ACR_ATSFC		BIT(0)	/* Auxiliary Snapshot FIFO Clear */
-#define	PTP_ACR_ATSEN0		BIT(4)	/* Auxiliary Snapshot 0 Enable */
-#define	PTP_ACR_ATSEN1		BIT(5)	/* Auxiliary Snapshot 1 Enable */
-#define	PTP_ACR_ATSEN2		BIT(6)	/* Auxiliary Snapshot 2 Enable */
-#define	PTP_ACR_ATSEN3		BIT(7)	/* Auxiliary Snapshot 3 Enable */
-#define	PTP_ACR_ATSEN_SHIFT	5	/* Auxiliary Snapshot shift */
-#define	PTP_ACR_MASK		GENMASK(7, 4)	/* Aux Snapshot Mask */
-#define	PMC_ART_VALUE0		0x01	/* PMC_ART[15:0] timer value */
-#define	PMC_ART_VALUE1		0x02	/* PMC_ART[31:16] timer value */
-#define	PMC_ART_VALUE2		0x03	/* PMC_ART[47:32] timer value */
-#define	PMC_ART_VALUE3		0x04	/* PMC_ART[63:48] timer value */
-#define	GMAC4_ART_TIME_SHIFT	16	/* ART TIME 16-bits shift */
 
-enum aux_snapshot {
-	AUX_SNAPSHOT0 = 0x10,
-	AUX_SNAPSHOT1 = 0x20,
-	AUX_SNAPSHOT2 = 0x40,
-	AUX_SNAPSHOT3 = 0x80,
-};
 
 #endif	/* __STMMAC_PTP_H__ */
-- 
2.41.0


