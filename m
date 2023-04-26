Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104AE6EEF9A
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbjDZHp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbjDZHpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:45:11 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED594499;
        Wed, 26 Apr 2023 00:44:44 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q75YDr012965;
        Wed, 26 Apr 2023 00:44:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=xKgGYL5KkxCtvOyFZdXDawIBtMlQrhDYmS6la3p2gVI=;
 b=TChv5F+KPifaEGHpR/4jkc+VBYDdqfwJ23PM+pldf4OPPRXMBYwXfLMr3YdpXY6Punww
 684fScaRyq5/DVzZi+HSy5VfjwEkn7vlhmsk7fsYh+sZ9jEt7ti7xicVke571qutAvVT
 dKuJQ2XYj/MFaXfUcdkA/Cjn5EvkVg2m3ztzuLZlR0ihS4UbK1jI69/RDhphn8FOh2zX
 Lci6sHE5+pG7ZJ0cS7XFyyToj++5VXuRC3JVCc2YcV+m85f5NOc3veDioED84nS5P8vB
 ADyksoZQ4uU7a2uSUGob9coiivAh9Xgmn2gLBJs7Su9mUYQIyv3nIlslOLLrmAVt0Q2V mQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2fdd59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 00:44:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 26 Apr
 2023 00:44:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 26 Apr 2023 00:44:36 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id C76B45B692B;
        Wed, 26 Apr 2023 00:44:31 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not enabled
Date:   Wed, 26 Apr 2023 13:13:44 +0530
Message-ID: <20230426074345.750135-10-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230426074345.750135-1-saikrishnag@marvell.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ovf8VffQH8M66mcovGBFZe4BkVTPmgK9
X-Proofpoint-ORIG-GUID: ovf8VffQH8M66mcovGBFZe4BkVTPmgK9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ratheesh Kannoth <rkannoth@marvell.com>

Fiwmware enables set of PFs and allocate mbox resources based on the
number of enabled PFs. Current driver tries to initialize the mbox
resources even for disabled PFs, which may waste the resources.
This patch fixes the issue by skipping the mbox initialization of
disabled PFs.

Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF and it's VFs")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.c  |  5 ++-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  3 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 44 ++++++++++++++++---
 3 files changed, 44 insertions(+), 8 deletions(-)

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
index 8683ce57ed3f..242089b6f199 100644
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
@@ -2343,12 +2349,33 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 	int err = -EINVAL, i, dir, dir_up;
 	void __iomem *reg_base;
 	struct rvu_work *mwork;
+	unsigned long *pf_bmap;
 	void **mbox_regions;
 	const char *name;
+	u64 cfg;
+
+	pf_bmap = bitmap_zalloc(num, GFP_KERNEL);
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
-	if (!mbox_regions)
+	if (!mbox_regions) {
+		bitmap_free(pf_bmap);
 		return -ENOMEM;
+	}
 
 	switch (type) {
 	case TYPE_AFPF:
@@ -2356,7 +2383,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		dir = MBOX_DIR_AFPF;
 		dir_up = MBOX_DIR_AFPF_UP;
 		reg_base = rvu->afreg_base;
-		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF);
+		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFPF, pf_bmap);
 		if (err)
 			goto free_regions;
 		break;
@@ -2365,7 +2392,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		dir = MBOX_DIR_PFVF;
 		dir_up = MBOX_DIR_PFVF_UP;
 		reg_base = rvu->pfreg_base;
-		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF);
+		err = rvu_get_mbox_regions(rvu, mbox_regions, num, TYPE_AFVF, pf_bmap);
 		if (err)
 			goto free_regions;
 		break;
@@ -2396,16 +2423,19 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
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
@@ -2415,6 +2445,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		INIT_WORK(&mwork->work, mbox_up_handler);
 	}
 	kfree(mbox_regions);
+	bitmap_free(pf_bmap);
 	return 0;
 
 exit:
@@ -2424,6 +2455,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 		iounmap((void __iomem *)mbox_regions[num]);
 free_regions:
 	kfree(mbox_regions);
+	bitmap_free(pf_bmap);
 	return err;
 }
 
-- 
2.25.1

