Return-Path: <netdev+bounces-11372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 304D5732D0F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 576781C20F97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C311992F;
	Fri, 16 Jun 2023 10:05:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFB21990A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:05:42 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D1A2D67;
	Fri, 16 Jun 2023 03:05:40 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686909939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rkCCowvxOYGZg7Z9wbkDB7S4cuEwrkMFzeVio1wTdXo=;
	b=NlNjR5IkiS/CJUICRXHd3Pdo1W8yas6A2Oo6pwfqiAQO+7QGvo0k3a8IM+afn5B2XKdwbr
	MtWhVmbCN5DDEioTii3QuSGjQfveVj0G0Z/sJBRwIdWmECCZuMGdr4u7V1a/ss6AhgUQMg
	PVSZdgDUpckaph1m4J6etyD8BvA1x/eynmEZTnzUq9ALTNbD5dj4Nj1H0odPELVqLvjir6
	onQGCqinFG/Wk6VozVsdDsZPNGuEzLFuZUre7dTmQ/OYkkzcVCWJZQXo7F0UoykYmDAUIE
	9xy34PWfCvDrG9OGH1DwUk2YpoiMDT6jVQHxr/OQWJXCZsE0d3ec7yOTicWFmw==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2E0CE2000F;
	Fri, 16 Jun 2023 10:05:38 +0000 (UTC)
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
Subject: [PATCH net-next 7/8] net: stmmac: do not overwrite other flags when writing timestamp control
Date: Fri, 16 Jun 2023 12:04:08 +0200
Message-ID: <20230616100409.164583-8-alexis.lothore@bootlin.com>
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
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

On some versions of GMAC IP, for example, DWMAC1000, we may overwrite some
other flags like ATSEN0 when writing Timestamp Control register.
Avoid overwriting those additional flags by setting a read-write-modify
process only on flags of interest

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 528d2e010926..ba483adf4e1a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -616,6 +616,10 @@ static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
  */
 static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 {
+	u32 reset_mask = PTP_TCR_SNAPTYPSEL_1 | PTP_TCR_TSIPV4ENA |
+			 PTP_TCR_TSIPV6ENA | PTP_TCR_TSEVNTENA |
+			 PTP_TCR_TSMSTRENA | PTP_TCR_TSVER2ENA |
+			 PTP_TCR_TSIPENA | PTP_TCR_TSENALL;
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct hwtstamp_config config;
 	u32 ptp_v2 = 0;
@@ -783,7 +787,9 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	priv->hwts_rx_en = ((config.rx_filter == HWTSTAMP_FILTER_NONE) ? 0 : 1);
 	priv->hwts_tx_en = config.tx_type == HWTSTAMP_TX_ON;
 
-	priv->systime_flags = STMMAC_HWTS_ACTIVE;
+	priv->systime_flags = stmmac_config_hw_tstamping_get(priv, priv->ptpaddr);
+	priv->systime_flags &= ~reset_mask;
+	priv->systime_flags |= STMMAC_HWTS_ACTIVE;
 
 	if (priv->hwts_tx_en || priv->hwts_rx_en) {
 		priv->systime_flags |= tstamp_all | ptp_v2 |
-- 
2.41.0


