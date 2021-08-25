Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888953F74FB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbhHYMUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55564 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240915AbhHYMT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:19:58 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6evIt015441;
        Wed, 25 Aug 2021 05:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=//HMRroppuFtElaTdWuhJmh1ltfe7diLj21USNEKWq0=;
 b=aJASttc+ePyk6fu7Lga43axnjcoqlK/4DZvbKrexqQfntN2qMigv/VfdfUIbz2VmnyF6
 ShsCd83m8nYLM7KM9U839VNF15EMC+q3KcQSnApNrz8hdyvAdGQL36828M4TnkWazXGz
 cCfo6sErlEAKYZe8BwtUdAYYbDMyARVfVUO8EXPunNP71S85SZiO/BE9WBU1xKypegvt
 p+cigb48fon/i5ny30EP/4MSDY/+b3eWNpiV4qXZVokHYYbPj9Jie4wPjPcUHIxJlTF4
 0YI+z3j/XF8ZNS8O3df/IYeCLpYMLv0dMZeTFJSvNsf7XwnP8XqhhAZD2KBclSDPFqxZ kA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:19:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:19:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:19:10 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 38E303F7072;
        Wed, 25 Aug 2021 05:19:07 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 7/9] octeontx2-af: Add PTP device id for CN10K and 95O silcons
Date:   Wed, 25 Aug 2021 17:48:44 +0530
Message-ID: <1629893926-18398-8-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7NWDxFnKUbsjvqooFntMRtg_f-o9cVp0
X-Proofpoint-GUID: 7NWDxFnKUbsjvqooFntMRtg_f-o9cVp0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

CN10K slicon has different device id for PTP device.
Hence this patch updates the driver with new id.
Though ptp driver being a separate driver AF manages
configuring PTP block by all PFs. To manage ptp, AF
driver checks in its probe whether
1. ptp hardware device found on silicon
2. A driver is bound to ptp device
3. The ptp driver probe is successful

In failure of cases 1 and 3, AF proceeds with out ptp
and for case 2 defers the probe. This patch refactors
code also to check for all the PTP device ids given in
ptp device ids table for case 1.

Also added PTP device ID for 95O silicon

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 43 +++++++++++--------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 1ee3785..ce193ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -19,12 +19,11 @@
 #define PCI_SUBSYS_DEVID_OCTX2_98xx_PTP		0xB100
 #define PCI_SUBSYS_DEVID_OCTX2_96XX_PTP		0xB200
 #define PCI_SUBSYS_DEVID_OCTX2_95XX_PTP		0xB300
-#define PCI_SUBSYS_DEVID_OCTX2_LOKI_PTP		0xB400
+#define PCI_SUBSYS_DEVID_OCTX2_95XXN_PTP	0xB400
 #define PCI_SUBSYS_DEVID_OCTX2_95MM_PTP		0xB500
-#define PCI_SUBSYS_DEVID_CN10K_A_PTP		0xB900
-#define PCI_SUBSYS_DEVID_CNF10K_A_PTP		0xBA00
-#define PCI_SUBSYS_DEVID_CNF10K_B_PTP		0xBC00
+#define PCI_SUBSYS_DEVID_OCTX2_95XXO_PTP	0xB600
 #define PCI_DEVID_OCTEONTX2_RST			0xA085
+#define PCI_DEVID_CN10K_PTP			0xA09E
 
 #define PCI_PTP_BAR_NO				0
 #define PCI_RST_BAR_NO				0
@@ -39,6 +38,9 @@
 #define RST_MUL_BITS				GENMASK_ULL(38, 33)
 #define CLOCK_BASE_RATE				50000000ULL
 
+static struct ptp *first_ptp_block;
+static const struct pci_device_id ptp_id_table[];
+
 static u64 get_clock_rate(void)
 {
 	u64 cfg, ret = CLOCK_BASE_RATE * 16;
@@ -74,23 +76,14 @@ static u64 get_clock_rate(void)
 
 struct ptp *ptp_get(void)
 {
-	struct pci_dev *pdev;
-	struct ptp *ptp;
+	struct ptp *ptp = first_ptp_block;
 
-	/* If the PTP pci device is found on the system and ptp
-	 * driver is bound to it then the PTP pci device is returned
-	 * to the caller(rvu driver).
-	 */
-	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
-			      PCI_DEVID_OCTEONTX2_PTP, NULL);
-	if (!pdev)
+	/* Check PTP block is present in hardware */
+	if (!pci_dev_present(ptp_id_table))
 		return ERR_PTR(-ENODEV);
-
-	ptp = pci_get_drvdata(pdev);
+	/* Check driver is bound to PTP block */
 	if (!ptp)
 		ptp = ERR_PTR(-EPROBE_DEFER);
-	if (IS_ERR(ptp))
-		pci_dev_put(pdev);
 
 	return ptp;
 }
@@ -190,6 +183,8 @@ static int ptp_probe(struct pci_dev *pdev,
 	writeq(clock_comp, ptp->reg_base + PTP_CLOCK_COMP);
 
 	pci_set_drvdata(pdev, ptp);
+	if (!first_ptp_block)
+		first_ptp_block = ptp;
 
 	return 0;
 
@@ -204,6 +199,9 @@ static int ptp_probe(struct pci_dev *pdev,
 	 * `dev->driver_data`.
 	 */
 	pci_set_drvdata(pdev, ERR_PTR(err));
+	if (!first_ptp_block)
+		first_ptp_block = ERR_PTR(err);
+
 	return 0;
 }
 
@@ -233,19 +231,14 @@ static const struct pci_device_id ptp_id_table[] = {
 			 PCI_SUBSYS_DEVID_OCTX2_95XX_PTP) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
 			 PCI_VENDOR_ID_CAVIUM,
-			 PCI_SUBSYS_DEVID_OCTX2_LOKI_PTP) },
+			 PCI_SUBSYS_DEVID_OCTX2_95XXN_PTP) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
 			 PCI_VENDOR_ID_CAVIUM,
 			 PCI_SUBSYS_DEVID_OCTX2_95MM_PTP) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
 			 PCI_VENDOR_ID_CAVIUM,
-			 PCI_SUBSYS_DEVID_CN10K_A_PTP) },
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
-			 PCI_VENDOR_ID_CAVIUM,
-			 PCI_SUBSYS_DEVID_CNF10K_A_PTP) },
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_PTP,
-			 PCI_VENDOR_ID_CAVIUM,
-			 PCI_SUBSYS_DEVID_CNF10K_B_PTP) },
+			 PCI_SUBSYS_DEVID_OCTX2_95XXO_PTP) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_PTP) },
 	{ 0, }
 };
 
-- 
2.7.4

