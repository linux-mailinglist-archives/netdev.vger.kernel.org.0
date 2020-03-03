Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CD7176CF2
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgCCCr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgCCCr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CDC24684;
        Tue,  3 Mar 2020 02:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203646;
        bh=wCxkECia1Bdipl3Uk+Po1/dnEMVWPfTLv75tbY6FuOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gH168ITudI3w+I3EdHTD0wUIaCV8p4bS8PJVxtNiJQazpS30Nq0KkhH1raioRkyka
         5ttoG7F/DBr/HcQgHC9A73mu93w66LOe6kXIp6BiSXhPdHJN4PxQW/XOLx+UmP/IhJ
         vRoI63mc/Fa/V/+LLnU4UUY4ROVKRZ9Ku79gIPtA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Robert Jones <rjones@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 57/66] net: thunderx: workaround BGX TX Underflow issue
Date:   Mon,  2 Mar 2020 21:46:06 -0500
Message-Id: <20200303024615.8889-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 971617c3b761c876d686a2188220a33898c90e99 ]

While it is not yet understood why a TX underflow can easily occur
for SGMII interfaces resulting in a TX wedge. It has been found that
disabling/re-enabling the LMAC resolves the issue.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Robert Jones <rjones@gateworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/cavium/thunder/thunder_bgx.c | 62 ++++++++++++++++++-
 .../net/ethernet/cavium/thunder/thunder_bgx.h |  9 +++
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index c4f6ec0cd183e..00751771f6624 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -410,10 +410,19 @@ void bgx_lmac_rx_tx_enable(int node, int bgx_idx, int lmacid, bool enable)
 	lmac = &bgx->lmac[lmacid];
 
 	cfg = bgx_reg_read(bgx, lmacid, BGX_CMRX_CFG);
-	if (enable)
+	if (enable) {
 		cfg |= CMR_PKT_RX_EN | CMR_PKT_TX_EN;
-	else
+
+		/* enable TX FIFO Underflow interrupt */
+		bgx_reg_modify(bgx, lmacid, BGX_GMP_GMI_TXX_INT_ENA_W1S,
+			       GMI_TXX_INT_UNDFLW);
+	} else {
 		cfg &= ~(CMR_PKT_RX_EN | CMR_PKT_TX_EN);
+
+		/* Disable TX FIFO Underflow interrupt */
+		bgx_reg_modify(bgx, lmacid, BGX_GMP_GMI_TXX_INT_ENA_W1C,
+			       GMI_TXX_INT_UNDFLW);
+	}
 	bgx_reg_write(bgx, lmacid, BGX_CMRX_CFG, cfg);
 
 	if (bgx->is_rgx)
@@ -1535,6 +1544,48 @@ static int bgx_init_phy(struct bgx *bgx)
 	return bgx_init_of_phy(bgx);
 }
 
+static irqreturn_t bgx_intr_handler(int irq, void *data)
+{
+	struct bgx *bgx = (struct bgx *)data;
+	u64 status, val;
+	int lmac;
+
+	for (lmac = 0; lmac < bgx->lmac_count; lmac++) {
+		status = bgx_reg_read(bgx, lmac, BGX_GMP_GMI_TXX_INT);
+		if (status & GMI_TXX_INT_UNDFLW) {
+			pci_err(bgx->pdev, "BGX%d lmac%d UNDFLW\n",
+				bgx->bgx_id, lmac);
+			val = bgx_reg_read(bgx, lmac, BGX_CMRX_CFG);
+			val &= ~CMR_EN;
+			bgx_reg_write(bgx, lmac, BGX_CMRX_CFG, val);
+			val |= CMR_EN;
+			bgx_reg_write(bgx, lmac, BGX_CMRX_CFG, val);
+		}
+		/* clear interrupts */
+		bgx_reg_write(bgx, lmac, BGX_GMP_GMI_TXX_INT, status);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void bgx_register_intr(struct pci_dev *pdev)
+{
+	struct bgx *bgx = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = pci_alloc_irq_vectors(pdev, BGX_LMAC_VEC_OFFSET,
+				    BGX_LMAC_VEC_OFFSET, PCI_IRQ_ALL_TYPES);
+	if (ret < 0) {
+		pci_err(pdev, "Req for #%d msix vectors failed\n",
+			BGX_LMAC_VEC_OFFSET);
+		return;
+	}
+	ret = pci_request_irq(pdev, GMPX_GMI_TX_INT, bgx_intr_handler, NULL,
+			      bgx, "BGX%d", bgx->bgx_id);
+	if (ret)
+		pci_free_irq(pdev, GMPX_GMI_TX_INT, bgx);
+}
+
 static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err;
@@ -1550,7 +1601,7 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, bgx);
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(dev, "Failed to enable PCI device\n");
 		pci_set_drvdata(pdev, NULL);
@@ -1604,6 +1655,8 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bgx_init_hw(bgx);
 
+	bgx_register_intr(pdev);
+
 	/* Enable all LMACs */
 	for (lmac = 0; lmac < bgx->lmac_count; lmac++) {
 		err = bgx_lmac_enable(bgx, lmac);
@@ -1620,6 +1673,7 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_enable:
 	bgx_vnic[bgx->bgx_id] = NULL;
+	pci_free_irq(pdev, GMPX_GMI_TX_INT, bgx);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -1637,6 +1691,8 @@ static void bgx_remove(struct pci_dev *pdev)
 	for (lmac = 0; lmac < bgx->lmac_count; lmac++)
 		bgx_lmac_disable(bgx, lmac);
 
+	pci_free_irq(pdev, GMPX_GMI_TX_INT, bgx);
+
 	bgx_vnic[bgx->bgx_id] = NULL;
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.h b/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
index 25888706bdcd1..cdea493921857 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
@@ -180,6 +180,15 @@
 #define BGX_GMP_GMI_TXX_BURST		0x38228
 #define BGX_GMP_GMI_TXX_MIN_PKT		0x38240
 #define BGX_GMP_GMI_TXX_SGMII_CTL	0x38300
+#define BGX_GMP_GMI_TXX_INT		0x38500
+#define BGX_GMP_GMI_TXX_INT_W1S		0x38508
+#define BGX_GMP_GMI_TXX_INT_ENA_W1C	0x38510
+#define BGX_GMP_GMI_TXX_INT_ENA_W1S	0x38518
+#define  GMI_TXX_INT_PTP_LOST			BIT_ULL(4)
+#define  GMI_TXX_INT_LATE_COL			BIT_ULL(3)
+#define  GMI_TXX_INT_XSDEF			BIT_ULL(2)
+#define  GMI_TXX_INT_XSCOL			BIT_ULL(1)
+#define  GMI_TXX_INT_UNDFLW			BIT_ULL(0)
 
 #define BGX_MSIX_VEC_0_29_ADDR		0x400000 /* +(0..29) << 4 */
 #define BGX_MSIX_VEC_0_29_CTL		0x400008
-- 
2.20.1

