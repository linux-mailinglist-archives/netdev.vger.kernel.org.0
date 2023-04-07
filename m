Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978006DAC9F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbjDGMZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240768AbjDGMYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:24:55 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB014AD37;
        Fri,  7 Apr 2023 05:24:33 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337AwkRr000607;
        Fri, 7 Apr 2023 05:24:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=La/ke9ZRJ7EVarRCZpDAcuhvINgB6+KJJy92FQiy70E=;
 b=VUKLbXAwqTDeRy5mYS4PauC2iJ2cBt2yK6NPxL8i/MfMhsc7vl1by5AiqZ6Y8Oi+zlDq
 0x1qj17LTudruFPQLWr+8Vj7xftvBfHbecbN34ytJ1lBdzFYcxXlpqi5Pw8jfhdycU2c
 4SLMYIwVHQnf+gnApzZwLXKwQM3K3X58535DsICUsuRPRxjqvXGOTZaCJPtbnyRdcSvO
 huBTMgXJkeBxxk2VDXQlpq902kqNry4kPlpq6OpmEWhP/1PRdsgJQ6FCTUue4Sd7dnOE
 ywUau/D0qPj/0C9Cw8CJgCAcbH6btO86g1+TgEGUlOSuQmSMWaC/fPERKYaQWEnG4UI6 Cg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pthvw88qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Apr 2023 05:24:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 7 Apr
 2023 05:24:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 7 Apr 2023 05:24:21 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 3D4495B697F;
        Fri,  7 Apr 2023 05:24:16 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <richardcochran@gmail.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v2 6/7] octeontx2-af: Skip PFs if not enabled
Date:   Fri, 7 Apr 2023 17:53:43 +0530
Message-ID: <20230407122344.4059-7-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230407122344.4059-1-saikrishnag@marvell.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Tmd0M3r2SqnQYOZnEIj2Z_1KnHBZLkwO
X-Proofpoint-GUID: Tmd0M3r2SqnQYOZnEIj2Z_1KnHBZLkwO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_08,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ratheesh Kannoth <rkannoth@marvell.com>

Skip mbox initialization of disabled PFs. Firmware configures PFs
and allocate mbox resources etc. Linux should configure particular
PFs, which ever are enabled by firmware.

Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF and it's VFs")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |  5 ++-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 38 ++++++++++++++++---
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 2898931d5260..9690ac01f02c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(otx2_mbox_init);
  */
 int otx2_mbox_regions_init(struct otx2_mbox *mbox, void **hwbase,
 			   struct pci_dev *pdev, void *reg_base,
-			   int direction, int ndevs)
+			   int direction, int ndevs, unsigned long *pf_bmap)
 {
 	struct otx2_mbox_dev *mdev;
 	int devid, err;
@@ -169,6 +169,9 @@ int otx2_mbox_regions_init(struct otx2_mbox *mbox, void **hwbase,
 	mbox->hwbase = hwbase[0];
 
 	for (devid = 0; devid < ndevs; devid++) {
+		if (!test_bit(devid, pf_bmap))
+			continue;
+
 		mdev = &mbox->dev[devid];
 		mdev->mbase = hwbase[devid];
 		mdev->hwbase = hwbase[devid];
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 0ce533848536..26636a4d7dcc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -96,9 +96,10 @@ void otx2_mbox_destroy(struct otx2_mbox *mbox);
 int otx2_mbox_init(struct otx2_mbox *mbox, void __force *hwbase,
 		   struct pci_dev *pdev, void __force *reg_base,
 		   int direction, int ndevs);
+
 int otx2_mbox_regions_init(struct otx2_mbox *mbox, void __force **hwbase,
 			   struct pci_dev *pdev, void __force *reg_base,
-			   int direction, int ndevs);
+			   int direction, int ndevs, unsigned long *bmap);
 void otx2_mbox_msg_send(struct otx2_mbox *mbox, int devid);
 int otx2_mbox_wait_for_rsp(struct otx2_mbox *mbox, int devid);
 int otx2_mbox_busy_poll_for_rsp(struct otx2_mbox *mbox, int devid);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 8683ce57ed3f..61c658fa3f28 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2282,7 +2282,7 @@ static inline void rvu_afvf_mbox_up_handler(struct work_struct *work)
 }
 
 static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
-				int num, int type)
+				int num, int type, unsigned long *pf_bmap)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	int region;
@@ -2294,6 +2294,9 @@ static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
 	 */
 	if (type == TYPE_AFVF) {
 		for (region = 0; region < num; region++) {
+			if (!test_bit(region, pf_bmap))
+				continue;
+
 			if (hw->cap.per_pf_mbox_regs) {
 				bar4 = rvu_read64(rvu, BLKADDR_RVUM,
 						  RVU_AF_PFX_BAR4_ADDR(0)) +
@@ -2315,6 +2318,9 @@ static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
 	 * RVU_AF_PF_BAR4_ADDR register.
 	 */
 	for (region = 0; region < num; region++) {
+		if (!test_bit(region, pf_bmap))
+			continue;
+
 		if (hw->cap.per_pf_mbox_regs) {
 			bar4 = rvu_read64(rvu, BLKADDR_RVUM,
 					  RVU_AF_PFX_BAR4_ADDR(region));
@@ -2343,8 +2349,27 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 	int err = -EINVAL, i, dir, dir_up;
 	void __iomem *reg_base;
 	struct rvu_work *mwork;
+	unsigned long *pf_bmap;
 	void **mbox_regions;
 	const char *name;
+	u64 cfg;
+
+	pf_bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(num), sizeof(long), GFP_KERNEL);
+	if (!pf_bmap)
+		return -ENOMEM;
+
+	/* RVU VFs */
+	if (type == TYPE_AFVF)
+		bitmap_set(pf_bmap, 0, num);
+
+	if (type == TYPE_AFPF) {
+		/* Mark enabled PFs in bitmap */
+		for (i = 0; i < num; i++) {
+			cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_PFX_CFG(i));
+			if (cfg & BIT_ULL(20))
+				set_bit(i, pf_bmap);
+		}
+	}
 
 	mbox_regions = kcalloc(num, sizeof(void *), GFP_KERNEL);
 	if (!mbox_regions)
@@ -2356,7 +2381,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		dir = MBOX_DIR_AFPF;
 		dir_up = MBOX_DIR_AFPF_UP;
 		reg_base = rvu->afreg_base;
-		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF);
+		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF, pf_bmap);
 		if (err)
 			goto free_regions;
 		break;
@@ -2365,7 +2390,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		dir = MBOX_DIR_PFVF;
 		dir_up = MBOX_DIR_PFVF_UP;
 		reg_base = rvu->pfreg_base;
-		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF);
+		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF, pf_bmap);
 		if (err)
 			goto free_regions;
 		break;
@@ -2396,16 +2421,19 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 	}
 
 	err = otx2_mbox_regions_init(&mw->mbox, mbox_regions, rvu->pdev,
-				     reg_base, dir, num);
+				     reg_base, dir, num, pf_bmap);
 	if (err)
 		goto exit;
 
 	err = otx2_mbox_regions_init(&mw->mbox_up, mbox_regions, rvu->pdev,
-				     reg_base, dir_up, num);
+				     reg_base, dir_up, num, pf_bmap);
 	if (err)
 		goto exit;
 
 	for (i = 0; i < num; i++) {
+		if (!test_bit(i, pf_bmap))
+			continue;
+
 		mwork = &mw->mbox_wrk[i];
 		mwork->rvu = rvu;
 		INIT_WORK(&mwork->work, mbox_handler);
-- 
2.25.1

