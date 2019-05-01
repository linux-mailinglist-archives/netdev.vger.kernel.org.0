Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDDB3106AC
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfEAJ6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34332 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfEAJ6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419u3j8014809;
        Wed, 1 May 2019 02:58:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=oRuEnjoNJ/X2cO+9NvMYh5Bl5JLyvlpKcic+CkC1JjY=;
 b=AZlN6ze7646w+ROt3FnA5iZDkWC5yw6kLkbzdy63OyWBYgDF/jM7DSJYq2+UfNdPS9ii
 vujfGGW/Kb3XMvdzz1GCba7cwKxn4v0+8T8QEONU4H0TfT1/0TXHuZH2Bqwal3Yrx74u
 nkscrZ8ek+vZJgbVVLCt76ze9PV+c5StxjLkqwwjVV7sJAvUULgXsVJhXX1X7RqUAv+L
 lTUzFrAkPTw0HVu5CKbYHT05o8X1CyAW/uHOV6WaobrNwqDBwyA+kMXLHkPeqQqX/y2u
 K3+NM6HokJTu7sfYfBORFSfk4smaYZQLFAjK256UJk3BdWYF57PLv9SXBExSpzm5jm0b lQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2s6xgchwa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:37 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:35 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:35 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id A6EA33F7048;
        Wed,  1 May 2019 02:58:33 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 03/10] qed: Change hwfn used for sb initialization
Date:   Wed, 1 May 2019 12:57:15 +0300
Message-ID: <20190501095722.6902-4-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When initializing status blocks use the affined hwfn
instead of the leading one for RDMA / Storage

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c            |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c   | 47 ++++++++++++++++------------
 drivers/net/ethernet/qlogic/qede/qede_main.c |  3 +-
 include/linux/qed/qed_if.h                   | 10 +++++-
 4 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 996d9ecd93e0..fd94100ee03a 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -326,7 +326,8 @@ static void qedr_free_mem_sb(struct qedr_dev *dev,
 			     struct qed_sb_info *sb_info, int sb_id)
 {
 	if (sb_info->sb_virt) {
-		dev->ops->common->sb_release(dev->cdev, sb_info, sb_id);
+		dev->ops->common->sb_release(dev->cdev, sb_info, sb_id,
+					     QED_SB_TYPE_CNQ);
 		dma_free_coherent(&dev->pdev->dev, sizeof(*sb_info->sb_virt),
 				  (void *)sb_info->sb_virt, sb_info->sb_phys);
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 6de23b56b294..7f19fefe0d79 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1301,26 +1301,21 @@ static u32 qed_sb_init(struct qed_dev *cdev,
 {
 	struct qed_hwfn *p_hwfn;
 	struct qed_ptt *p_ptt;
-	int hwfn_index;
 	u16 rel_sb_id;
-	u8 n_hwfns;
 	u32 rc;
 
-	/* RoCE uses single engine and CMT uses two engines. When using both
-	 * we force only a single engine. Storage uses only engine 0 too.
-	 */
-	if (type == QED_SB_TYPE_L2_QUEUE)
-		n_hwfns = cdev->num_hwfns;
-	else
-		n_hwfns = 1;
-
-	hwfn_index = sb_id % n_hwfns;
-	p_hwfn = &cdev->hwfns[hwfn_index];
-	rel_sb_id = sb_id / n_hwfns;
+	/* RoCE/Storage use a single engine in CMT mode while L2 uses both */
+	if (type == QED_SB_TYPE_L2_QUEUE) {
+		p_hwfn = &cdev->hwfns[sb_id % cdev->num_hwfns];
+		rel_sb_id = sb_id / cdev->num_hwfns;
+	} else {
+		p_hwfn = QED_AFFIN_HWFN(cdev);
+		rel_sb_id = sb_id;
+	}
 
 	DP_VERBOSE(cdev, NETIF_MSG_INTR,
 		   "hwfn [%d] <--[init]-- SB %04x [0x%04x upper]\n",
-		   hwfn_index, rel_sb_id, sb_id);
+		   IS_LEAD_HWFN(p_hwfn) ? 0 : 1, rel_sb_id, sb_id);
 
 	if (IS_PF(p_hwfn->cdev)) {
 		p_ptt = qed_ptt_acquire(p_hwfn);
@@ -1339,20 +1334,26 @@ static u32 qed_sb_init(struct qed_dev *cdev,
 }
 
 static u32 qed_sb_release(struct qed_dev *cdev,
-			  struct qed_sb_info *sb_info, u16 sb_id)
+			  struct qed_sb_info *sb_info,
+			  u16 sb_id,
+			  enum qed_sb_type type)
 {
 	struct qed_hwfn *p_hwfn;
-	int hwfn_index;
 	u16 rel_sb_id;
 	u32 rc;
 
-	hwfn_index = sb_id % cdev->num_hwfns;
-	p_hwfn = &cdev->hwfns[hwfn_index];
-	rel_sb_id = sb_id / cdev->num_hwfns;
+	/* RoCE/Storage use a single engine in CMT mode while L2 uses both */
+	if (type == QED_SB_TYPE_L2_QUEUE) {
+		p_hwfn = &cdev->hwfns[sb_id % cdev->num_hwfns];
+		rel_sb_id = sb_id / cdev->num_hwfns;
+	} else {
+		p_hwfn = QED_AFFIN_HWFN(cdev);
+		rel_sb_id = sb_id;
+	}
 
 	DP_VERBOSE(cdev, NETIF_MSG_INTR,
 		   "hwfn [%d] <--[init]-- SB %04x [0x%04x upper]\n",
-		   hwfn_index, rel_sb_id, sb_id);
+		   IS_LEAD_HWFN(p_hwfn) ? 0 : 1, rel_sb_id, sb_id);
 
 	rc = qed_int_sb_release(p_hwfn, sb_info, rel_sb_id);
 
@@ -2372,6 +2373,11 @@ static int qed_read_module_eeprom(struct qed_dev *cdev, char *buf,
 	return rc;
 }
 
+static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
+{
+	return QED_AFFIN_HWFN_IDX(cdev);
+}
+
 static struct qed_selftest_ops qed_selftest_ops_pass = {
 	.selftest_memory = &qed_selftest_memory,
 	.selftest_interrupt = &qed_selftest_interrupt,
@@ -2419,6 +2425,7 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.db_recovery_add = &qed_db_recovery_add,
 	.db_recovery_del = &qed_db_recovery_del,
 	.read_module_eeprom = &qed_read_module_eeprom,
+	.get_affin_hwfn_idx = &qed_get_affin_hwfn_idx,
 };
 
 void qed_get_protocol_stats(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 02a97c659e29..a9684a881f2a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1306,7 +1306,8 @@ static void qede_free_mem_sb(struct qede_dev *edev, struct qed_sb_info *sb_info,
 			     u16 sb_id)
 {
 	if (sb_info->sb_virt) {
-		edev->ops->common->sb_release(edev->cdev, sb_info, sb_id);
+		edev->ops->common->sb_release(edev->cdev, sb_info, sb_id,
+					      QED_SB_TYPE_L2_QUEUE);
 		dma_free_coherent(&edev->pdev->dev, sizeof(*sb_info->sb_virt),
 				  (void *)sb_info->sb_virt, sb_info->sb_phys);
 		memset(sb_info, 0, sizeof(*sb_info));
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index f6165d304b4d..8fd11aaa3172 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -907,7 +907,8 @@ struct qed_common_ops {
 
 	u32		(*sb_release)(struct qed_dev *cdev,
 				      struct qed_sb_info *sb_info,
-				      u16 sb_id);
+				      u16 sb_id,
+				      enum qed_sb_type type);
 
 	void		(*simd_handler_config)(struct qed_dev *cdev,
 					       void *token,
@@ -1123,6 +1124,13 @@ struct qed_common_ops {
  */
 	int (*read_module_eeprom)(struct qed_dev *cdev,
 				  char *buf, u8 dev_addr, u32 offset, u32 len);
+
+/**
+ * @brief get_affin_hwfn_idx
+ *
+ * @param cdev
+ */
+	u8 (*get_affin_hwfn_idx)(struct qed_dev *cdev);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
2.14.5

