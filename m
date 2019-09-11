Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AFCAFB9F
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfIKLnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:43:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28088 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727800AbfIKLnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:43:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8BBct4k021647;
        Wed, 11 Sep 2019 04:43:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XoXOBNOFN4metjwoGEoYhxhZ2HameOvusEw9LQwPSdk=;
 b=rVunX1plPW4ANrX6y2hsndOW/T8Xem0El8HTvPGzzydSk0iEM8C/WZz7GlzLhcTaprNa
 XUfp98I6b64Bmv5oX4JnSTv+NwXRkR/+SYA3SiUiXFWPVu3KJXubejYwucdxQ/LHdVj2
 pKnjmCHBpoO1I9xv48okcV+McewUsQx3HNHlUHiFCghq6D+AzEf2WYv4mI7HlGwKswFj
 g+pMcKd6o+ZhYea0R2lUJiNoBnnfYx0a6vW7novI8dKpIauGpbB8xtm91XxdvCQQzhik
 rXv/SxiHT14kMX9vEmbaHAFS4foFL5WOvYTNgVzog0KPyCl0ci7JoDaS/bfx32VjSXvE Hg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uvc2js698-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 04:43:01 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 11 Sep
 2019 04:42:59 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 11 Sep 2019 04:42:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E9C093F703F;
        Wed, 11 Sep 2019 04:42:58 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8BBgwMB007054;
        Wed, 11 Sep 2019 04:42:58 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8BBgwQo007053;
        Wed, 11 Sep 2019 04:42:58 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/2] qed*: Fix size of config attribute dump.
Date:   Wed, 11 Sep 2019 04:42:50 -0700
Message-ID: <20190911114251.7013-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190911114251.7013-1-skalluru@marvell.com>
References: <20190911114251.7013-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_07:2019-09-11,2019-09-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver currently returns max-buf-size as size of the config attribute.
This patch incorporates changes to read this value from MFW (if available)
and provide it to the user. Also did a trivial clean up in this path.

Fixes: d44a3ced7023 ("qede: Add support for reading the config id attributes.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c      | 26 +++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 14 +++++++------
 include/linux/qed/qed_if.h                      |  8 ++++++++
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index ac1511a8..38c0ec3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2300,6 +2300,31 @@ static int qed_nvm_flash_cfg_write(struct qed_dev *cdev, const u8 **data)
 	return rc;
 }
 
+#define QED_MAX_NVM_BUF_LEN	32
+static int qed_nvm_flash_cfg_len(struct qed_dev *cdev, u32 cmd)
+{
+	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	u8 buf[QED_MAX_NVM_BUF_LEN];
+	struct qed_ptt *ptt;
+	u32 len;
+	int rc;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return QED_MAX_NVM_BUF_LEN;
+
+	rc = qed_mcp_nvm_get_cfg(hwfn, ptt, cmd, 0, QED_NVM_CFG_GET_FLAGS, buf,
+				 &len);
+	if (rc || !len) {
+		DP_ERR(cdev, "Error %d reading %d\n", rc, cmd);
+		len = QED_MAX_NVM_BUF_LEN;
+	}
+
+	qed_ptt_release(hwfn, ptt);
+
+	return len;
+}
+
 static int qed_nvm_flash_cfg_read(struct qed_dev *cdev, u8 **data,
 				  u32 cmd, u32 entity_id)
 {
@@ -2657,6 +2682,7 @@ static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)
 	.read_module_eeprom = &qed_read_module_eeprom,
 	.get_affin_hwfn_idx = &qed_get_affin_hwfn_idx,
 	.read_nvm_cfg = &qed_nvm_flash_cfg_read,
+	.read_nvm_cfg_len = &qed_nvm_flash_cfg_len,
 	.set_grc_config = &qed_set_grc_config,
 };
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index ec27a43..8a426af 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -49,7 +49,6 @@
 
 #define QEDE_SELFTEST_POLL_COUNT 100
 #define QEDE_DUMP_VERSION	0x1
-#define QEDE_DUMP_NVM_BUF_LEN	32
 #define QEDE_DUMP_NVM_ARG_COUNT	2
 
 static const struct {
@@ -2026,7 +2025,8 @@ static int qede_get_dump_flag(struct net_device *dev,
 	switch (edev->dump_info.cmd) {
 	case QEDE_DUMP_CMD_NVM_CFG:
 		dump->flag = QEDE_DUMP_CMD_NVM_CFG;
-		dump->len = QEDE_DUMP_NVM_BUF_LEN;
+		dump->len = edev->ops->common->read_nvm_cfg_len(edev->cdev,
+						edev->dump_info.args[0]);
 		break;
 	case QEDE_DUMP_CMD_GRCDUMP:
 		dump->flag = QEDE_DUMP_CMD_GRCDUMP;
@@ -2051,9 +2051,8 @@ static int qede_get_dump_data(struct net_device *dev,
 
 	if (!edev->ops || !edev->ops->common) {
 		DP_ERR(edev, "Edev ops not populated\n");
-		edev->dump_info.cmd = QEDE_DUMP_CMD_NONE;
-		edev->dump_info.num_args = 0;
-		return -EINVAL;
+		rc = -EINVAL;
+		goto err;
 	}
 
 	switch (edev->dump_info.cmd) {
@@ -2062,7 +2061,8 @@ static int qede_get_dump_data(struct net_device *dev,
 			DP_ERR(edev, "Arg count = %d required = %d\n",
 			       edev->dump_info.num_args,
 			       QEDE_DUMP_NVM_ARG_COUNT);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto err;
 		}
 		rc =  edev->ops->common->read_nvm_cfg(edev->cdev, (u8 **)&buf,
 						      edev->dump_info.args[0],
@@ -2078,8 +2078,10 @@ static int qede_get_dump_data(struct net_device *dev,
 		break;
 	}
 
+err:
 	edev->dump_info.cmd = QEDE_DUMP_CMD_NONE;
 	edev->dump_info.num_args = 0;
+	memset(edev->dump_info.args, 0, sizeof(edev->dump_info.args));
 
 	return rc;
 }
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index e354638..b5db1ee 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1143,6 +1143,14 @@ struct qed_common_ops {
  */
 	int (*read_nvm_cfg)(struct qed_dev *cdev, u8 **buf, u32 cmd,
 			    u32 entity_id);
+/**
+ * @brief read_nvm_cfg - Read NVM config attribute value.
+ * @param cdev
+ * @param cmd - NVM CFG command id
+ *
+ * @return config id length, 0 on error.
+ */
+	int (*read_nvm_cfg_len)(struct qed_dev *cdev, u32 cmd);
 
 /**
  * @brief set_grc_config - Configure value for grc config id.
-- 
1.8.3.1

