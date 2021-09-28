Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07741ADD9
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbhI1LdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:33:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7852 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240420AbhI1LdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:33:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAF40P019486;
        Tue, 28 Sep 2021 04:31:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=O9huyqAxlqrFdX8ngmZIrOAwGm0KBbdKq02p9iQZYYk=;
 b=RtdYcMdlIt/aLdNpcmzzSBIbvZQNlZkOqdBtOrLV85i0H9UEeJr3/An8RJpu19wAvD4X
 isCxTpRaRE2XJCv3zNCbEihugr/dganyvDfO45iFRinIqwzKBaT7+PTCsfkiiQFEGFfv
 LnLB5H23pBKy7TLKm4jIeOGv879d/V1qgpqap0ElE5bbUWiLbztwBvJb2RcYrzlF9u1d
 HIoqsdfxkYNxhf2QQG6WqUVW8buFhk3iOaykQ+QgYziBEgOYLszinVQeTX7W/wRaarkc
 iq9zoHntCKb+lxvxeQMesqFUuuUvhDZ3vz85i69f0YmdxR9v7xWeaCO+kEMLsJmuxup4 bg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bc14pr84j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 04:31:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 04:31:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 04:31:17 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B3B5F3F70BC;
        Tue, 28 Sep 2021 04:31:14 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 3/4] octeontx2-af: Use ptp input clock info from firmware data
Date:   Tue, 28 Sep 2021 17:01:00 +0530
Message-ID: <20210928113101.16580-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210928113101.16580-1-hkelam@marvell.com>
References: <20210928113101.16580-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HYo38moXUys2BTdv-uXfThHCOi2ogYg4
X-Proofpoint-GUID: HYo38moXUys2BTdv-uXfThHCOi2ogYg4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

The input clock frequency of PTP block is figured
out from hardware reset block currently. The firmware
data already has this info in sclk. Hence simplify
ptp driver to use sclk from firmware data.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 80 +++++++------------
 .../net/ethernet/marvell/octeontx2/af/ptp.h   |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +
 3 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 9b8e59f4c206..477491c001b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -27,7 +27,6 @@
 #define PCI_DEVID_CN10K_PTP			0xA09E
 
 #define PCI_PTP_BAR_NO				0
-#define PCI_RST_BAR_NO				0
 
 #define PTP_CLOCK_CFG				0xF00ULL
 #define PTP_CLOCK_CFG_PTP_EN			BIT_ULL(0)
@@ -35,46 +34,9 @@
 #define PTP_CLOCK_HI				0xF10ULL
 #define PTP_CLOCK_COMP				0xF18ULL
 
-#define RST_BOOT				0x1600ULL
-#define RST_MUL_BITS				GENMASK_ULL(38, 33)
-#define CLOCK_BASE_RATE				50000000ULL
-
 static struct ptp *first_ptp_block;
 static const struct pci_device_id ptp_id_table[];
 
-static u64 get_clock_rate(void)
-{
-	u64 cfg, ret = CLOCK_BASE_RATE * 16;
-	struct pci_dev *pdev;
-	void __iomem *base;
-
-	/* To get the input clock frequency with which PTP co-processor
-	 * block is running the base frequency(50 MHz) needs to be multiplied
-	 * with multiplier bits present in RST_BOOT register of RESET block.
-	 * Hence below code gets the multiplier bits from the RESET PCI
-	 * device present in the system.
-	 */
-	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
-			      PCI_DEVID_OCTEONTX2_RST, NULL);
-	if (!pdev)
-		goto error;
-
-	base = pci_ioremap_bar(pdev, PCI_RST_BAR_NO);
-	if (!base)
-		goto error_put_pdev;
-
-	cfg = readq(base + RST_BOOT);
-	ret = CLOCK_BASE_RATE * FIELD_GET(RST_MUL_BITS, cfg);
-
-	iounmap(base);
-
-error_put_pdev:
-	pci_dev_put(pdev);
-
-error:
-	return ret;
-}
-
 struct ptp *ptp_get(void)
 {
 	struct ptp *ptp = first_ptp_block;
@@ -145,13 +107,40 @@ static int ptp_get_clock(struct ptp *ptp, u64 *clk)
 	return 0;
 }
 
+void ptp_start(struct ptp *ptp, u64 sclk)
+{
+	struct pci_dev *pdev;
+	u64 clock_comp;
+	u64 clock_cfg;
+
+	if (!ptp)
+		return;
+
+	pdev = ptp->pdev;
+
+	if (!sclk) {
+		dev_err(&pdev->dev, "PTP input clock cannot be zero\n");
+		return;
+	}
+
+	/* sclk is in MHz */
+	ptp->clock_rate = sclk * 1000000;
+
+	/* Enable PTP clock */
+	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
+	clock_cfg |= PTP_CLOCK_CFG_PTP_EN;
+	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
+
+	clock_comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
+	/* Initial compensation value to start the nanosecs counter */
+	writeq(clock_comp, ptp->reg_base + PTP_CLOCK_COMP);
+}
+
 static int ptp_probe(struct pci_dev *pdev,
 		     const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
 	struct ptp *ptp;
-	u64 clock_comp;
-	u64 clock_cfg;
 	int err;
 
 	ptp = devm_kzalloc(dev, sizeof(*ptp), GFP_KERNEL);
@@ -172,17 +161,6 @@ static int ptp_probe(struct pci_dev *pdev,
 
 	ptp->reg_base = pcim_iomap_table(pdev)[PCI_PTP_BAR_NO];
 
-	ptp->clock_rate = get_clock_rate();
-
-	/* Enable PTP clock */
-	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
-	clock_cfg |= PTP_CLOCK_CFG_PTP_EN;
-	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
-
-	clock_comp = ((u64)1000000000ull << 32) / ptp->clock_rate;
-	/* Initial compensation value to start the nanosecs counter */
-	writeq(clock_comp, ptp->reg_base + PTP_CLOCK_COMP);
-
 	pci_set_drvdata(pdev, ptp);
 	if (!first_ptp_block)
 		first_ptp_block = ptp;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
index 76d404b24552..1ed350ad6f1f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.h
@@ -20,6 +20,7 @@ struct ptp {
 
 struct ptp *ptp_get(void);
 void ptp_put(struct ptp *ptp);
+void ptp_start(struct ptp *ptp, u64 sclk);
 
 extern struct pci_driver ptp_driver;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5909173ff788..87a32a17d49e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3240,6 +3240,9 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mutex_init(&rvu->rswitch.switch_lock);
 
+	if (rvu->fwdata)
+		ptp_start(rvu->ptp, rvu->fwdata->sclk);
+
 	return 0;
 err_dl:
 	rvu_unregister_dl(rvu);
-- 
2.17.1

