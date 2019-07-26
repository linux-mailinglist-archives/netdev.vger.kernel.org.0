Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB98276E4D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 17:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbfGZPwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 11:52:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37656 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbfGZPwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 11:52:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6QFpFfW028982;
        Fri, 26 Jul 2019 08:52:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=/BZ/gLBsj3PhYyPK8t7hcqay4J2uJvu/CKixcdGj52o=;
 b=fhERv1leg2H5ejkExz+c/Yc6SbKyWZOoynaUb2uOi60dZUGlgJ0hbxPaFDmOqxoq8fFn
 HHBURYcgnGlvCAxfNrp0ExobAhLQNFi8Jz2lLISoGfibYkmelWpDH7hcdOSuzCGOxckV
 2dmu36IOxWOD3TIDoW33NFB2lKX0MQfSUU0BdcDGCXOhAPbGR0dQ5JvyuNl1jTXdjY2A
 kC5pUS0wJWzzFJoOOK7VMT0HWET1iftQTU3XR4URGgEyR3/8FNXkw1flt4MmAOD2J8hu
 3kha52p7lhXED09VfTpxFlerWZgdFbvXq9kwZiN+rzBT8/zE+qy2qxQWrC0IIpy+1IW9 qw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rqgun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jul 2019 08:52:44 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 26 Jul
 2019 08:52:43 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 26 Jul 2019 08:52:43 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EEBE53F703F;
        Fri, 26 Jul 2019 08:52:42 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6QFqgaB025196;
        Fri, 26 Jul 2019 08:52:42 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6QFqgBr025195;
        Fri, 26 Jul 2019 08:52:42 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next v2 2/2] qed: Add driver API for flashing the config attributes.
Date:   Fri, 26 Jul 2019 08:52:15 -0700
Message-ID: <20190726155215.25151-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190726155215.25151-1-skalluru@marvell.com>
References: <20190726155215.25151-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-26_11:2019-07-26,2019-07-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds driver interface for reading the NVM config request and
update the attributes on nvm config flash partition.
This API can be used by ethtool flash update command (i.e., ethtool -f) to
update config attributes in the NVM flash parition.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 65 ++++++++++++++++++++++++++++++
 include/linux/qed/qed_if.h                 |  1 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 829dd60..54f00d2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -67,6 +67,8 @@
 #define QED_ROCE_QPS			(8192)
 #define QED_ROCE_DPIS			(8)
 #define QED_RDMA_SRQS                   QED_ROCE_QPS
+#define QED_NVM_CFG_SET_FLAGS		0xE
+#define QED_NVM_CFG_SET_PF_FLAGS	0x1E
 
 static char version[] =
 	"QLogic FastLinQ 4xxxx Core Module qed " DRV_MODULE_VERSION "\n";
@@ -2227,6 +2229,66 @@ static int qed_nvm_flash_image_validate(struct qed_dev *cdev,
 	return 0;
 }
 
+/* Binary file format -
+ *     /----------------------------------------------------------------------\
+ * 0B  |                       0x5 [command index]                            |
+ * 4B  | Entity ID     | Reserved        |  Number of config attributes       |
+ * 8B  | Config ID                       | Length        | Value              |
+ *     |                                                                      |
+ *     \----------------------------------------------------------------------/
+ * There can be several Cfg_id-Length-Value sets as specified by 'Number of...'.
+ * Entity ID - A non zero entity value for which the config need to be updated.
+ */
+static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	u8 entity_id, len, buf[32];
+	struct qed_ptt *ptt;
+	u16 cfg_id, count;
+	int rc = 0, i;
+	u32 flags;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	/* NVM CFG ID attribute header */
+	*data += 4;
+	entity_id = **data;
+	*data += 2;
+	count = *((u16 *)*data);
+	*data += 2;
+
+	DP_VERBOSE(cdev, NETIF_MSG_DRV,
+		   "Read config ids: entity id %02x num _attrs = %0d\n",
+		   entity_id, count);
+	/* NVM CFG ID attributes */
+	for (i = 0; i < count; i++) {
+		cfg_id = *((u16 *)*data);
+		*data += 2;
+		len = **data;
+		(*data)++;
+		memcpy(buf, *data, len);
+		*data += len;
+
+		flags = entity_id ? QED_NVM_CFG_SET_PF_FLAGS :
+			QED_NVM_CFG_SET_FLAGS;
+
+		DP_VERBOSE(cdev, NETIF_MSG_DRV,
+			   "cfg_id = %d len = %d\n", cfg_id, len);
+		rc = qed_mcp_nvm_set_cfg(hwfn, ptt, cfg_id, entity_id, flags,
+					 buf, len);
+		if (rc) {
+			DP_ERR(cdev, "Error %d configuring %d\n", rc, cfg_id);
+			break;
+		}
+	}
+
+	qed_ptt_release(hwfn, ptt);
+
+	return rc;
+}
+
 static int qed_nvm_flash(struct qed_dev *cdev, const char *name)
 {
 	const struct firmware *image;
@@ -2268,6 +2330,9 @@ static int qed_nvm_flash(struct qed_dev *cdev, const char *name)
 			rc = qed_nvm_flash_image_access(cdev, &data,
 							&check_resp);
 			break;
+		case QED_NVM_FLASH_CMD_NVM_CFG_ID:
+			rc = qed_nvm_flash_cfg_write(cdev, &data);
+			break;
 		default:
 			DP_ERR(cdev, "Unknown command %08x\n", cmd_type);
 			rc = -EINVAL;
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index eef02e6..23805ea 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -804,6 +804,7 @@ enum qed_nvm_flash_cmd {
 	QED_NVM_FLASH_CMD_FILE_DATA = 0x2,
 	QED_NVM_FLASH_CMD_FILE_START = 0x3,
 	QED_NVM_FLASH_CMD_NVM_CHANGE = 0x4,
+	QED_NVM_FLASH_CMD_NVM_CFG_ID = 0x5,
 	QED_NVM_FLASH_CMD_NVM_MAX,
 };
 
-- 
1.8.3.1

