Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD4548131
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFQLqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:46:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725973AbfFQLqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:46:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HBjJar028449;
        Mon, 17 Jun 2019 04:46:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=u6ht7QRzfPEQw9bGNG/SxsSJesHteM4RlWM5AFFKhK0=;
 b=NCSwjTkbzZPhUXPfWhRo4dxy0D5j1usSJhz7Mr+0nMOrUMgWgKHC/HFg0xIvhsIKBhEY
 7/A+f2XvMldXmLeeFX8vtYP9cWVcWnFPLz4NeKQM7uo6SU3KmgxySRT8ZID9G8ceZPdh
 49pJ5DFalQe6jo3NJ31AXahlJZy+kx6QW0tOY1hQCdtZltIz3K5NWLGF2VkdFChzReUT
 v030ZhY0AxT9In8Tle6VB6VFTTi06PORJFC9zPXq7t4XJWhoWBsFts/rwsEmt1vNG7lG
 G+Ac+GHhT3cM9gSYepiEeY5Wqe2RoJX8/KctqvXWo3VIR2NtOnOrY8i5BJxor6vb795B nw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t68rp8aje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 04:46:13 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 04:46:11 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 17 Jun 2019 04:46:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C1BD13F703F;
        Mon, 17 Jun 2019 04:46:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x5HBkB9q017147;
        Mon, 17 Jun 2019 04:46:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x5HBkBcS017146;
        Mon, 17 Jun 2019 04:46:11 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 4/4] qed: Add devlink support for configuration attributes.
Date:   Mon, 17 Jun 2019 04:45:28 -0700
Message-ID: <20190617114528.17086-5-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190617114528.17086-1-skalluru@marvell.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds implementation for devlink callbacks for reading/
configuring the device attributes.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |   1 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 184 ++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  23 ++++
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  11 ++
 4 files changed, 219 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 89fe091..2afd5c7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -866,6 +866,7 @@ struct qed_dev {
 
 	struct devlink			*dl;
 	bool				iwarp_cmt;
+	u8				cfg_entity_id;
 };
 
 #define NUM_OF_VFS(dev)         (QED_IS_BB(dev) ? MAX_NUM_VFS_BB \
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index acb6c87..232a8c4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -4,6 +4,30 @@
 #include "qed_devlink.h"
 #include "qed_mcp.h"
 
+static const struct qed_devlink_cfg_param cfg_params[] = {
+	{DEVLINK_PARAM_GENERIC_ID_ENABLE_SRIOV, NVM_CFG_ID_ENABLE_SRIOV,
+	 DEVLINK_PARAM_TYPE_BOOL},
+	{QED_DEVLINK_ENTITY_ID, 0, DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_DEVICE_CAPABILITIES, NVM_CFG_ID_DEVICE_CAPABILITIES,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_MF_MODE, NVM_CFG_ID_MF_MODE, DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_DCBX_MODE, NVM_CFG_ID_DCBX_MODE, DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_PREBOOT_OPROM, NVM_CFG_ID_PREBOOT_OPROM,
+	 DEVLINK_PARAM_TYPE_BOOL},
+	{QED_DEVLINK_PREBOOT_BOOT_PROTOCOL, NVM_CFG_ID_PREBOOT_BOOT_PROTOCOL,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_PREBOOT_VLAN, NVM_CFG_ID_PREBOOT_VLAN,
+	 DEVLINK_PARAM_TYPE_U16},
+	{QED_DEVLINK_PREBOOT_VLAN_VALUE, NVM_CFG_ID_PREBOOT_VLAN_VALUE,
+	 DEVLINK_PARAM_TYPE_U16},
+	{QED_DEVLINK_MBA_DELAY_TIME, NVM_CFG_ID_MBA_DELAY_TIME,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_MBA_SETUP_HOT_KEY, NVM_CFG_ID_MBA_SETUP_HOT_KEY,
+	 DEVLINK_PARAM_TYPE_U8},
+	{QED_DEVLINK_MBA_HIDE_SETUP_PROMPT, NVM_CFG_ID_MBA_HIDE_SETUP_PROMPT,
+	 DEVLINK_PARAM_TYPE_BOOL},
+};
+
 static int qed_dl_param_get(struct devlink *dl, u32 id,
 			    struct devlink_param_gset_ctx *ctx)
 {
@@ -30,11 +54,171 @@ static int qed_dl_param_set(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int qed_dl_get_perm_cfg(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	u8 buf[QED_DL_PARAM_BUF_LEN];
+	struct qed_devlink *qed_dl;
+	int rc, cfg_idx, len = 0;
+	struct qed_hwfn *hwfn;
+	struct qed_dev *cdev;
+	struct qed_ptt *ptt;
+	u32 flags;
+
+	qed_dl = devlink_priv(dl);
+	cdev = qed_dl->cdev;
+	hwfn = QED_LEADING_HWFN(cdev);
+
+	if (id == QED_DEVLINK_ENTITY_ID) {
+		ctx->val.vu8 = cdev->cfg_entity_id;
+		return 0;
+	}
+
+	for (cfg_idx = 0; cfg_idx < ARRAY_SIZE(cfg_params); cfg_idx++)
+		if (cfg_params[cfg_idx].id == id)
+			break;
+
+	if (cfg_idx == ARRAY_SIZE(cfg_params)) {
+		DP_ERR(cdev, "Invalid command id %d\n", id);
+		return -EINVAL;
+	}
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	memset(buf, 0, QED_DL_PARAM_BUF_LEN);
+	flags = cdev->cfg_entity_id ? QED_DL_PARAM_PF_GET_FLAGS :
+		QED_DL_PARAM_GET_FLAGS;
+	rc = qed_mcp_nvm_get_cfg(hwfn, ptt, cfg_params[cfg_idx].cmd,
+				 cdev->cfg_entity_id, flags, buf, &len);
+	if (rc)
+		DP_ERR(cdev, "Error = %d\n", rc);
+	else
+		memcpy(&ctx->val, buf, len);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return rc;
+}
+
+static int qed_dl_set_perm_cfg(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	u8 buf[QED_DL_PARAM_BUF_LEN];
+	struct qed_devlink *qed_dl;
+	int rc, cfg_idx, len = 0;
+	struct qed_hwfn *hwfn;
+	struct qed_dev *cdev;
+	struct qed_ptt *ptt;
+	u32 flags;
+
+	qed_dl = devlink_priv(dl);
+	cdev = qed_dl->cdev;
+	hwfn = QED_LEADING_HWFN(cdev);
+
+	if (id == QED_DEVLINK_ENTITY_ID) {
+		cdev->cfg_entity_id = ctx->val.vu8;
+		return 0;
+	}
+
+	for (cfg_idx = 0; cfg_idx < ARRAY_SIZE(cfg_params); cfg_idx++)
+		if (cfg_params[cfg_idx].id == id)
+			break;
+
+	if (cfg_idx == ARRAY_SIZE(cfg_params)) {
+		DP_ERR(cdev, "Invalid command id %d\n", id);
+		return -EINVAL;
+	}
+
+	memset(buf, 0, QED_DL_PARAM_BUF_LEN);
+	switch (cfg_params[cfg_idx].type) {
+	case DEVLINK_PARAM_TYPE_BOOL:
+		len = 1;
+		break;
+	case DEVLINK_PARAM_TYPE_U8:
+		len = 1;
+		break;
+	case DEVLINK_PARAM_TYPE_U16:
+		len = 2;
+		break;
+	case DEVLINK_PARAM_TYPE_U32:
+		len = 4;
+		break;
+	case DEVLINK_PARAM_TYPE_STRING:
+		len = strlen(ctx->val.vstr);
+		break;
+	}
+
+	memcpy(buf, &ctx->val, len);
+	flags = cdev->cfg_entity_id ? QED_DL_PARAM_PF_SET_FLAGS :
+		QED_DL_PARAM_SET_FLAGS;
+
+	ptt = qed_ptt_acquire(hwfn);
+	if (!ptt)
+		return -EAGAIN;
+
+	rc = qed_mcp_nvm_set_cfg(hwfn, ptt, cfg_params[cfg_idx].cmd,
+				 cdev->cfg_entity_id, flags, buf, len);
+	if (rc)
+		DP_ERR(cdev, "Error = %d\n", rc);
+
+	qed_ptt_release(hwfn, ptt);
+
+	return rc;
+}
+
 static const struct devlink_param qed_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV, BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
 	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PARAM_ID_IWARP_CMT,
 			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     qed_dl_param_get, qed_dl_param_set, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_ENTITY_ID,
+			     "entity_id", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_DEVICE_CAPABILITIES,
+			     "device_capabilities", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_MF_MODE,
+			     "mf_mode", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_DCBX_MODE,
+			     "dcbx_mode", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PREBOOT_OPROM,
+			     "preboot_oprom", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PREBOOT_BOOT_PROTOCOL,
+			     "preboot_boot_protocol", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PREBOOT_VLAN,
+			     "preboot_vlan", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PREBOOT_VLAN_VALUE,
+			     "preboot_vlan_value", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_MBA_DELAY_TIME,
+			     "mba_delay_time", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_MBA_SETUP_HOT_KEY,
+			     "mba_setup_hot_key", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_MBA_HIDE_SETUP_PROMPT,
+			     "mba_hide_setup_prompt", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     qed_dl_get_perm_cfg, qed_dl_set_perm_cfg, NULL),
 };
 
 static const struct devlink_ops qed_dl_ops;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
index 86e1caa..ca52a3f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
@@ -3,6 +3,12 @@
 #define _QED_DEVLINK_H
 #include "qed.h"
 
+#define QED_DL_PARAM_GET_FLAGS		0xA
+#define QED_DL_PARAM_SET_FLAGS		0xE
+#define QED_DL_PARAM_PF_GET_FLAGS	0x1A
+#define QED_DL_PARAM_PF_SET_FLAGS	0x1E
+#define QED_DL_PARAM_BUF_LEN		32
+
 struct qed_devlink {
 	struct qed_dev *cdev;
 };
@@ -10,6 +16,23 @@ struct qed_devlink {
 enum qed_devlink_param_id {
 	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	QED_DEVLINK_PARAM_ID_IWARP_CMT,
+	QED_DEVLINK_ENTITY_ID,
+	QED_DEVLINK_DEVICE_CAPABILITIES,
+	QED_DEVLINK_MF_MODE,
+	QED_DEVLINK_DCBX_MODE,
+	QED_DEVLINK_PREBOOT_OPROM,
+	QED_DEVLINK_PREBOOT_BOOT_PROTOCOL,
+	QED_DEVLINK_PREBOOT_VLAN,
+	QED_DEVLINK_PREBOOT_VLAN_VALUE,
+	QED_DEVLINK_MBA_DELAY_TIME,
+	QED_DEVLINK_MBA_SETUP_HOT_KEY,
+	QED_DEVLINK_MBA_HIDE_SETUP_PROMPT,
+};
+
+struct qed_devlink_cfg_param {
+	u16 id;
+	u16 cmd;
+	enum devlink_param_type type;
 };
 
 int qed_devlink_register(struct qed_dev *cdev);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 5091f5b1..49b6a6e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -13338,6 +13338,17 @@ enum spad_sections {
 
 #define NVM_CFG_ID_MAC_ADDRESS			1
 #define NVM_CFG_ID_MF_MODE			9
+#define NVM_CFG_ID_DCBX_MODE			26
+#define NVM_CFG_ID_PREBOOT_OPROM		59
+#define NVM_CFG_ID_MBA_DELAY_TIME		61
+#define NVM_CFG_ID_MBA_SETUP_HOT_KEY		62
+#define NVM_CFG_ID_MBA_HIDE_SETUP_PROMPT	63
+#define NVM_CFG_ID_PREBOOT_BOOT_PROTOCOL	69
+#define NVM_CFG_ID_ENABLE_SRIOV			70
+#define NVM_CFG_ID_DEVICE_CAPABILITIES		117
+#define NVM_CFG_ID_PREBOOT_VLAN			133
+#define NVM_CFG_ID_PREBOOT_VLAN_VALUE		132
+
 
 #define MCP_TRACE_SIZE          2048	/* 2kb */
 
-- 
1.8.3.1

