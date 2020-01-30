Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7711214E4CD
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 22:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgA3VdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 16:33:08 -0500
Received: from lists.gateworks.com ([108.161.130.12]:36186 "EHLO
        lists.gateworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgA3VdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 16:33:08 -0500
Received: from 68-189-91-139.static.snlo.ca.charter.com ([68.189.91.139] helo=rjones.pdc.gateworks.com)
        by lists.gateworks.com with esmtp (Exim 4.82)
        (envelope-from <rjones@gateworks.com>)
        id 1ixHRL-00011c-SA; Thu, 30 Jan 2020 21:33:31 +0000
From:   Robert Jones <rjones@gateworks.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH net v2] net: thunderx: workaround BGX TX Underflow issue
Date:   Thu, 30 Jan 2020 13:32:52 -0800
Message-Id: <20200130213252.17005-1-rjones@gateworks.com>
X-Mailer: git-send-email 2.9.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

While it is not yet understood why a TX underflow can easily occur
for SGMII interfaces resulting in a TX wedge. It has been found that
disabling/re-enabling the LMAC resolves the issue.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Robert Jones <rjones@gateworks.com>
---
Changes in v2:
 - Changed bgx_register_intr() to a void return
 - Added pci_free_irq_vectors() calls to free irq if named/allocated
 - Use snprintf instead of sprintf for irq names

 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 59 +++++++++++++++++++++++
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h |  9 ++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index c4f6ec0..cbf8596 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -74,6 +74,7 @@ struct bgx {
 	struct pci_dev		*pdev;
 	bool                    is_dlm;
 	bool                    is_rgx;
+	char			irq_name[7];
 };
 
 static struct bgx *bgx_vnic[MAX_BGX_THUNDER];
@@ -1535,6 +1536,53 @@ static int bgx_init_phy(struct bgx *bgx)
 	return bgx_init_of_phy(bgx);
 }
 
+static irqreturn_t bgx_intr_handler(int irq, void *data)
+{
+	struct bgx *bgx = (struct bgx *)data;
+	struct device *dev = &bgx->pdev->dev;
+	u64 status, val;
+	int lmac;
+
+	for (lmac = 0; lmac < bgx->lmac_count; lmac++) {
+		status = bgx_reg_read(bgx, lmac, BGX_GMP_GMI_TXX_INT);
+		if (status & GMI_TXX_INT_UNDFLW) {
+			dev_err(dev, "BGX%d lmac%d UNDFLW\n", bgx->bgx_id,
+				lmac);
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
+	struct device *dev = &pdev->dev;
+	int num_vec, ret;
+
+	/* Enable MSI-X */
+	num_vec = pci_msix_vec_count(pdev);
+	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(dev, "Req for #%d msix vectors failed\n", num_vec);
+		return;
+	}
+	snprintf(bgx->irq_name, sizeof(bgx->irqname), "BGX%d", bgx->bgx_id);
+	ret = request_irq(pci_irq_vector(pdev, GMPX_GMI_TX_INT),
+			  bgx_intr_handler, 0, bgx->irq_name, bgx);
+	if (ret) {
+		if (bgx->irq_name[0])
+			pci_free_irq_vectors(pdev);
+	}
+}
+
 static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err;
@@ -1604,6 +1652,8 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bgx_init_hw(bgx);
 
+	bgx_register_intr(pdev);
+
 	/* Enable all LMACs */
 	for (lmac = 0; lmac < bgx->lmac_count; lmac++) {
 		err = bgx_lmac_enable(bgx, lmac);
@@ -1614,12 +1664,18 @@ static int bgx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				bgx_lmac_disable(bgx, --lmac);
 			goto err_enable;
 		}
+
+		/* enable TX FIFO Underflow interrupt */
+		bgx_reg_modify(bgx, lmac, BGX_GMP_GMI_TXX_INT_ENA_W1S,
+			       GMI_TXX_INT_UNDFLW);
 	}
 
 	return 0;
 
 err_enable:
 	bgx_vnic[bgx->bgx_id] = NULL;
+	if (bgx->irq_name[0])
+		pci_free_irq_vectors(pdev);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -1637,6 +1693,9 @@ static void bgx_remove(struct pci_dev *pdev)
 	for (lmac = 0; lmac < bgx->lmac_count; lmac++)
 		bgx_lmac_disable(bgx, lmac);
 
+	if (bgx->irq_name[0])
+		pci_free_irq_vectors(pdev);
+
 	bgx_vnic[bgx->bgx_id] = NULL;
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.h b/drivers/net/ethernet/cavium/thunder/thunder_bgx.h
index 2588870..cdea493 100644
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
2.9.2

