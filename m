Return-Path: <netdev+bounces-11371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 297C8732D0C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D45D528170B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28CAA19501;
	Fri, 16 Jun 2023 10:05:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B051990A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:05:41 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5570B194;
	Fri, 16 Jun 2023 03:05:39 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686909938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NYtleP6ALm9DjFnX75BkWEiXccu4UQqKWZMcyeQcTVc=;
	b=bVuD32OCRkfoKqqd+GjpOZlYBL3/cZ0Gs1SZIDvFe+/r51UUGDB5Cx5AYiAKtYihhicTB9
	QPA8ezsc4lv0pVDzIXZ/E4xMMXQ2cVJPko+EmH4Qer8NH3fl7CN07G4C1ufbp0DO3OZdA8
	R5SO/tk4qD/V6AIFTnmJWYx6hHYkLiT1lEEBlfXgZJSx2giXMIEbIIHy5FIKi4DTWzbqhp
	BBZ+OAPvRSYaki/0kKFa8d5l6n0JpTLOZPKiX/TCp20ieG/9r8tiIUn8Mwn+Rg9341eCIJ
	UQcYf+abSmCGMKr5WDElVT3bSdYWIr9FrcHr77Xp6qe2awhZVUVwvtHIBZp1fw==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id EB87C20013;
	Fri, 16 Jun 2023 10:05:36 +0000 (UTC)
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
Subject: [PATCH net-next 6/8] net: stmmac: introduce setter/getter for timestamp configuration
Date: Fri, 16 Jun 2023 12:04:07 +0200
Message-ID: <20230616100409.164583-7-alexis.lothore@bootlin.com>
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

stmmac_hwtstamp_set currently writes the whole Timestamp Control register
when configuring hardware timestamping. It is done for all GMAC variants,
and leads to issues with DWMAC1000: this version also bears the Auxiliary
Snapshot Trigger bit in the same register. This field, which is set
independently with during PTP_CLK_REQ_EXTTS ioctl, is then overwritten when
stmmac_hwtstamp_set is called.
Introduce setter and getter to allow modifying only relevant parts of the
timestamp control register instead of overwriting it all.

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h            |  9 ++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 10 ++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |  4 ++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index d0b2f13510aa..927324e3d748 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -534,7 +534,8 @@ struct stmmac_ops {
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
-	void (*config_hw_tstamping) (void __iomem *ioaddr, u32 data);
+	void (*config_hw_tstamping_set)(void __iomem *ioaddr, u32 data);
+	u32 (*config_hw_tstamping_get)(void __iomem *ioaddr);
 	void (*config_sub_second_increment)(void __iomem *ioaddr, u32 ptp_clock,
 					   int gmac4, u32 *ssinc);
 	int (*init_systime) (void __iomem *ioaddr, u32 sec, u32 nsec);
@@ -546,8 +547,10 @@ struct stmmac_hwtimestamp {
 	void (*timestamp_interrupt)(struct stmmac_priv *priv);
 };
 
-#define stmmac_config_hw_tstamping(__priv, __args...) \
-	stmmac_do_void_callback(__priv, ptp, config_hw_tstamping, __args)
+#define stmmac_config_hw_tstamping_set(__priv, __args...) \
+	stmmac_do_void_callback(__priv, ptp, config_hw_tstamping_set, __args)
+#define stmmac_config_hw_tstamping_get(__priv, __args...) \
+	stmmac_do_callback(__priv, ptp, config_hw_tstamping_get, __args)
 #define stmmac_config_sub_second_increment(__priv, __args...) \
 	stmmac_do_void_callback(__priv, ptp, config_sub_second_increment, __args)
 #define stmmac_init_systime(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 2cd0ec17f4c6..cbb94d3e0fa1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -18,11 +18,16 @@
 #include "dwmac4.h"
 #include "stmmac.h"
 
-static void config_hw_tstamping(void __iomem *ioaddr, u32 data)
+static void config_hw_tstamping_set(void __iomem *ioaddr, u32 data)
 {
 	writel(data, ioaddr + PTP_TCR);
 }
 
+static u32 config_hw_tstamping_get(void __iomem *ioaddr)
+{
+	return readl(ioaddr + PTP_TCR);
+}
+
 static void config_sub_second_increment(void __iomem *ioaddr,
 		u32 ptp_clock, int gmac4, u32 *ssinc)
 {
@@ -163,7 +168,8 @@ static void get_systime(void __iomem *ioaddr, u64 *systime)
 }
 
 const struct stmmac_hwtimestamp stmmac_ptp = {
-	.config_hw_tstamping = config_hw_tstamping,
+	.config_hw_tstamping_set = config_hw_tstamping_set,
+	.config_hw_tstamping_get = config_hw_tstamping_get,
 	.init_systime = init_systime,
 	.config_sub_second_increment = config_sub_second_increment,
 	.config_addend = config_addend,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4f0ef73d5121..528d2e010926 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -792,7 +792,7 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 				       ts_master_en | snap_type_sel;
 	}
 
-	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
+	stmmac_config_hw_tstamping_set(priv, priv->ptpaddr, priv->systime_flags);
 
 	memcpy(&priv->tstamp_config, &config, sizeof(config));
 
@@ -841,7 +841,7 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
 		return -EOPNOTSUPP;
 
-	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
+	stmmac_config_hw_tstamping_set(priv, priv->ptpaddr, systime_flags);
 	priv->systime_flags = systime_flags;
 
 	/* program Sub Second Increment reg */
-- 
2.41.0


