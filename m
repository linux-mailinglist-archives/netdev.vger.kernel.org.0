Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98585711BD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiGLFN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGLFNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:13:55 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DC7DF0B;
        Mon, 11 Jul 2022 22:13:54 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BKPWfU004021;
        Mon, 11 Jul 2022 22:13:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=cRu489J08uUWqtoD9hhE50LxSSvQsbpdkhiahnmGyD0=;
 b=eYpLcblP5hpNTZQ5dlloQEJLvqgsNENmk14F9NIDX4V3Cti6+Gy7RxVc3C5PAxjDTNq3
 DYXZ1BlK1XSIobdaGUyThAirMRpAkPZc4KgLc1gikiFeyiTL8065XMzCHV5QTFy7MwKG
 QkAbmcX79VrP88TmqQdyz7aaG7JomOgoJS2hmz/Mvns+h8Ozy/Yx8MdwZt8skq3mTfob
 ixzh6ja5m9Dej28qS2C0RBvz+C9CKJBxEBZphX0awPozXjNXD0fbmJvdQ3GjpHucihbu
 4u3aPdk+PUdFOU/FHiWlDDUtPMkdqc+FoCU1C7Zlmoc0KAS2I8DKDFokn3MgGKB/qRiZ 4A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h796n03pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 22:13:32 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jul
 2022 22:13:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 Jul 2022 22:13:30 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id D6BAC3F7060;
        Mon, 11 Jul 2022 22:13:27 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Skip CGX/RPM probe incase of zero lmac count
Date:   Tue, 12 Jul 2022 10:43:11 +0530
Message-ID: <20220712051311.3468-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 2RLJfwfd6I0xwV_9zrYMcQ0rJyliDfX4
X-Proofpoint-ORIG-GUID: 2RLJfwfd6I0xwV_9zrYMcQ0rJyliDfX4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_03,2022-07-08_01,2022-06-22_01
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
Signed-off-by: Geetha Sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 14 ++++++++++----
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  2 +-
 5 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 931a1a7ebf76..38e195726ee6 100644
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
 
@@ -1572,7 +1572,6 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 	cgx_lmac_get_fifolen(cgx);
 
-	cgx->lmac_count = cgx->mac_ops->get_nr_lmacs(cgx);
 	/* lmac_list specifies which lmacs are enabled
 	 * when bit n is set to 1, LMAC[n] is enabled
 	 */
@@ -1750,6 +1749,13 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
index 550cb11197bf..b92908554107 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1622,6 +1622,8 @@ enum cgx_af_status {
 	LMAC_AF_ERR_PERM_DENIED		= -1103,
 	LMAC_AF_ERR_PFC_ENADIS_PERM_DENIED       = -1104,
 	LMAC_AF_ERR_8023PAUSE_ENADIS_PERM_DENIED = -1105,
+	LMAC_AF_ERR_CMD_TIMEOUT = -1106,
+	LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED = -1107,
 };
 
 #endif /* MBOX_H */
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
index 9ffe99830e34..477282386fb9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1059,7 +1059,7 @@ int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
 	u8 cgx_id, lmac_id;
 
 	if (!rvu->fwdata)
-		return -ENXIO;
+		return LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED;
 
 	if (!is_pf_cgxmapped(rvu, pf))
 		return -EPERM;
-- 
2.17.1

