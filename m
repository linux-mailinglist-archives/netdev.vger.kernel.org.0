Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F966E9843
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfJ3IkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:40:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60548 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726028AbfJ3IkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 04:40:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9U8ZS6S013402;
        Wed, 30 Oct 2019 01:40:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=b0hV3DMoDjhFUJD+2jdesyAP/iSissdxakYE9Wyp2gE=;
 b=tNQOH2c+RE9V4oT4Qr8LDK75rn3sLK1h6kFaWCYzldOEWHJyAUbWPQD2U85CtgLj3cY+
 R8ywhonN/lX1mk31TwuCi39KTtKKh6qcKOKJQBqA+KzqVzkajVT9hShgFnCux/0JMA9G
 ZJ/1Z4kGszmqAlld99RdQPm4dgStEGYWsXo1Kw/ePdqIh/McKCTLxQpsJW0HoazRY5Is
 nFiI0EADHGhr/DNkKAe3fZdfrklymEkQgNspgL4CxZIMRRgKfS5grK6QfPg8QW3NZec9
 S8huPIiaMmLExhnn89tCFNcHjqfmSEIymjt8dQ1al7SQy2BvVfgK82Ba1EMjw2ZTMrOq mw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjm1u2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Oct 2019 01:40:03 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 30 Oct
 2019 01:40:02 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 30 Oct 2019 01:40:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 93BF73F704A;
        Wed, 30 Oct 2019 01:40:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x9U8e2Ye021870;
        Wed, 30 Oct 2019 01:40:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x9U8e2qV021842;
        Wed, 30 Oct 2019 01:40:02 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net 1/1] qed: Optimize execution time for nvm attributes configuration.
Date:   Wed, 30 Oct 2019 01:39:58 -0700
Message-ID: <20191030083958.21723-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_04:2019-10-30,2019-10-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation for nvm_attr configuration instructs the management
FW to load/unload the nvm-cfg image for each user-provided attribute in
the input file. This consumes lot of cycles even for few tens of
attributes.
This patch updates the implementation to perform load/commit of the config
for every 50 attributes. After loading the nvm-image, MFW expects that
config should be committed in a predefined timer value (5 sec), hence it's
not possible to write large number of attributes in a single load/commit
window. Hence performing the commits in chunks.

Fixes: 0dabbe1bb3a4 ("qed: Add driver API for flashing the config attributes.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2ce7009..38f7f40 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -67,10 +67,9 @@
 #define QED_ROCE_QPS			(8192)
 #define QED_ROCE_DPIS			(8)
 #define QED_RDMA_SRQS                   QED_ROCE_QPS
-#define QED_NVM_CFG_SET_FLAGS		0xE
-#define QED_NVM_CFG_SET_PF_FLAGS	0x1E
 #define QED_NVM_CFG_GET_FLAGS		0xA
 #define QED_NVM_CFG_GET_PF_FLAGS	0x1A
+#define QED_NVM_CFG_MAX_ATTRS		50
 
 static char version[] =
 	"QLogic FastLinQ 4xxxx Core Module qed " DRV_MODULE_VERSION "\n";
@@ -2255,6 +2254,7 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 {
 	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
 	u8 entity_id, len, buf[32];
+	bool need_nvm_init = true;
 	struct qed_ptt *ptt;
 	u16 cfg_id, count;
 	int rc = 0, i;
@@ -2271,8 +2271,10 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 
 	DP_VERBOSE(cdev, NETIF_MSG_DRV,
 		   "Read config ids: num_attrs = %0d\n", count);
-	/* NVM CFG ID attributes */
-	for (i = 0; i < count; i++) {
+	/* NVM CFG ID attributes. Start loop index from 1 to avoid additional
+	 * arithmetic operations in the implementation.
+	 */
+	for (i = 1; i <= count; i++) {
 		cfg_id = *((u16 *)*data);
 		*data += 2;
 		entity_id = **data;
@@ -2282,8 +2284,21 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 		memcpy(buf, *data, len);
 		*data += len;
 
-		flags = entity_id ? QED_NVM_CFG_SET_PF_FLAGS :
-			QED_NVM_CFG_SET_FLAGS;
+		flags = 0;
+		if (need_nvm_init) {
+			flags |= QED_NVM_CFG_OPTION_INIT;
+			need_nvm_init = false;
+		}
+
+		/* Commit to flash and free the resources */
+		if (!(i % QED_NVM_CFG_MAX_ATTRS) || i == count) {
+			flags |= QED_NVM_CFG_OPTION_COMMIT |
+				 QED_NVM_CFG_OPTION_FREE;
+			need_nvm_init = true;
+		}
+
+		if (entity_id)
+			flags |= QED_NVM_CFG_OPTION_ENTITY_SEL;
 
 		DP_VERBOSE(cdev, NETIF_MSG_DRV,
 			   "cfg_id = %d entity = %d len = %d\n", cfg_id,
-- 
1.8.3.1

