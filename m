Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E0E57125C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiGLGnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLGnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:43:09 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48D5528A5;
        Mon, 11 Jul 2022 23:43:08 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BFq2u1020001;
        Mon, 11 Jul 2022 23:43:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=1Hd5DhUpb0GuosInqk3haf2sH4mbjP/m2urZoH555U4=;
 b=F10Oe51NNKQqRxx9rbQG4kkzcTvSYFU60Ge/MskjMbvNcTqvbda8Rk9dT1t3eikduIbW
 CRPeE0YDjGLwKMwaZ2b+hSPoPMhfV5E5GmTHDy+1DPxck28oUL5Dw3RXU670Ph1elfjH
 vTY2EUWasxPCcpqe/2XOibOOIVA8PH1vBohiFsa5XdTlsgt1HPG5a58aTunyfZYBo3ZO
 agym6vjUfIYArtSgn+Kd29pz5sCl4dn2aEMMPi6cPJq841bZSk9ZjxeH89Z+eVlHrBD1
 njxCIc6mEY+XaZedc/qHX8b7sVK4K1SXlkkdh1jaECkzReAjkNrTuhcaexPi/PpOLokM wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h796n0ac3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 23:43:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jul
 2022 23:42:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 11 Jul 2022 23:42:59 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 9BFE23F7065;
        Mon, 11 Jul 2022 23:42:56 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next PATCH v2] octeontx2-af: Skip CGX/RPM probe incase of zero lmac count
Date:   Tue, 12 Jul 2022 12:12:50 +0530
Message-ID: <20220712064250.29903-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: iinDj5qGV2VRebYDNR00IHKCWL6Eg3Q_
X-Proofpoint-ORIG-GUID: iinDj5qGV2VRebYDNR00IHKCWL6Eg3Q_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

In few error cases MAC(CGX/RPM) block is having 0 lmacs.
AF driver uses MAC block with lmac pair to get firmware
data etc. These commands will fail as there is no LMAC
associated with MAC block.

This patch skips the probe of these MAC blocks such that AF driver
uses correct MAC block and LMAC pair for firmware communication and
define new LMAC_AF_ERROR types for command timeout etc.

This patch also enables channel back pressure for all LMACs.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
v1-v2:
  Rebased on latest net-next.

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c     | 13 ++++++++++---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c     |  3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h     |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c |  2 +-
 5 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 931a1a7ebf76..894425768a31 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1012,9 +1012,9 @@ int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 	if (!wait_event_timeout(lmac->wq_cmd_cmplt, !lmac->cmd_pend,
 				msecs_to_jiffies(CGX_CMD_TIMEOUT))) {
 		dev = &cgx->pdev->dev;
-		dev_err(dev, "cgx port %d:%d cmd timeout\n",
-			cgx->cgx_id, lmac->lmac_id);
-		err = -EIO;
+		dev_err(dev, "cgx port %d:%d cmd %lld timeout\n",
+			cgx->cgx_id, lmac->lmac_id, FIELD_GET(CMDREG_ID, req));
+		err = LMAC_AF_ERR_CMD_TIMEOUT;
 		goto unlock;
 	}
 
@@ -1750,6 +1750,13 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_release_regions;
 	}
 
+	cgx->lmac_count = cgx->mac_ops->get_nr_lmacs(cgx);
+	if (!cgx->lmac_count) {
+		dev_notice(dev, "CGX %d LMAC count is zero, skipping probe\n", cgx->cgx_id);
+		err = -EOPNOTSUPP;
+		goto err_release_regions;
+	}
+
 	nvec = pci_msix_vec_count(cgx->pdev);
 	err = pci_alloc_irq_vectors(pdev, nvec, nvec, PCI_IRQ_MSIX);
 	if (err < 0 || err != nvec) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 430aa8a05c23..51c2cadd1333 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1648,6 +1648,8 @@ enum cgx_af_status {
 	LMAC_AF_ERR_PERM_DENIED		= -1103,
 	LMAC_AF_ERR_PFC_ENADIS_PERM_DENIED       = -1104,
 	LMAC_AF_ERR_8023PAUSE_ENADIS_PERM_DENIED = -1105,
+	LMAC_AF_ERR_CMD_TIMEOUT = -1106,
+	LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED = -1107,
 	LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED = -1108,
 	LMAC_AF_ERR_EXACT_MATCH_TBL_DEL_FAILED = -1109,
 	LMAC_AF_ERR_EXACT_MATCH_TBL_LOOK_UP_FAILED = -1110,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 05666922a45b..9025825597a2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -281,6 +281,9 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
 	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, 0, cfg);
 	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
+
+	/* Enable channel mask for all LMACS */
+	rpm_write(rpm, 0, RPMX_CMR_CHAN_MSK_OR, ~0ULL);
 }
 
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 8205f2626f61..8247db8c1d36 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -51,6 +51,7 @@
 #define RPMX_CMR_RX_OVR_BP		0x4120
 #define RPMX_CMR_RX_OVR_BP_EN(x)	BIT_ULL((x) + 8)
 #define RPMX_CMR_RX_OVR_BP_BP(x)	BIT_ULL((x) + 4)
+#define RPMX_CMR_CHAN_MSK_OR            0x4118
 #define RPMX_MTI_STAT_RX_STAT_PAGES_COUNTERX 0x12000
 #define RPMX_MTI_STAT_TX_STAT_PAGES_COUNTERX 0x13000
 #define RPMX_MTI_STAT_DATA_HI_CDC            0x10038
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 5090ddcc7e8a..41c124b7aea9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1087,7 +1087,7 @@ int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_id, lmac_id;
 
 	if (!rvu->fwdata)
-		return -ENXIO;
+		return LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED;
 
 	if (!is_pf_cgxmapped(rvu, pf))
 		return -EPERM;
-- 
2.17.1

