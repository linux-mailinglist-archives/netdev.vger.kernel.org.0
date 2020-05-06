Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7641C6F67
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEFLeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38560 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727804AbgEFLeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BX840029783;
        Wed, 6 May 2020 04:34:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=4FKY3g8h9X8daw8Op+aWthHY30JcEbg6AIfCLdKpJKI=;
 b=ADz3t3cHwmBisAOCM/5CD0JHK/37iK+YmC79qCVCaaF1ChY3TrXp8eh6taewJ8se+BDL
 wcxqx6utcwGFctiw3mYlPX6QvAmNj4mjjRygPdBnh2Kux36wZDxU9El95O7RFd/YZl2W
 Kn3zQcXqcB+T4yX0l6lQnuMMLzA6hnGWXcrwrdG/KPFtOlsgEu1MLwguBTn/2rBjE/ne
 WuCPVls1frdfEeAvWwWY+xOdUjuWabUZMqDH1k6EVSL9JBMgaIodv2DRa+YPsJ0HlATM
 E0y8FrmFUdeNDWxUUcuD69NbgXiTLJDBp+9o2X+mfeIpj6XADq4CfkFbRoo6fCwy0al0 Tw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytrs49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:33:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:33:59 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 264B43F703F;
        Wed,  6 May 2020 04:33:56 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 04/12] net: qed: critical err reporting to management firmware
Date:   Wed, 6 May 2020 14:33:06 +0300
Message-ID: <ec35f96d4435deb51eb9266b1682a070d1fe2608.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On various critical errors, notification handler should also report
the err information into the management firmware.

MFW can interact with server/motherboard backend agents - these are
used by server manufacturers to monitor server HW health.

Thus, it is important for driver to report on any faulty conditions

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h |  19 ++++
 drivers/net/ethernet/qlogic/qed/qed_hw.c  |   3 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 125 ++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h |  15 +++
 4 files changed, 162 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 4597015b8bff..21d53b00c2e6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12492,6 +12492,8 @@ struct public_drv_mb {
 #define DRV_MSG_CODE_GET_ENGINE_CONFIG		0x00370000
 #define DRV_MSG_CODE_GET_PPFID_BITMAP		0x43000000
 
+#define DRV_MSG_CODE_DEBUG_DATA_SEND		0xc0040000
+
 #define RESOURCE_CMD_REQ_RESC_MASK		0x0000001F
 #define RESOURCE_CMD_REQ_RESC_SHIFT		0
 #define RESOURCE_CMD_REQ_OPCODE_MASK		0x000000E0
@@ -12626,6 +12628,17 @@ struct public_drv_mb {
 #define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_EEE		0x00000002
 #define DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK		0x00010000
 
+/* DRV_MSG_CODE_DEBUG_DATA_SEND parameters */
+#define DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE_OFFSET	0
+#define DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE_MASK		0xFF
+
+/* Driver attributes params */
+#define DRV_MB_PARAM_ATTRIBUTE_KEY_OFFSET		0
+#define DRV_MB_PARAM_ATTRIBUTE_KEY_MASK			0x00FFFFFF
+#define DRV_MB_PARAM_ATTRIBUTE_CMD_OFFSET		24
+#define DRV_MB_PARAM_ATTRIBUTE_CMD_MASK			0xFF000000
+
+#define DRV_MB_PARAM_NVM_CFG_OPTION_ID_OFFSET		0
 #define DRV_MB_PARAM_NVM_CFG_OPTION_ID_SHIFT		0
 #define DRV_MB_PARAM_NVM_CFG_OPTION_ID_MASK		0x0000FFFF
 #define DRV_MB_PARAM_NVM_CFG_OPTION_ALL_SHIFT		16
@@ -12678,6 +12691,12 @@ struct public_drv_mb {
 #define FW_MSG_CODE_DRV_CFG_PF_VFS_MSIX_DONE	0x00870000
 #define FW_MSG_SEQ_NUMBER_MASK			0x0000ffff
 
+#define FW_MSG_CODE_DEBUG_DATA_SEND_INV_ARG	0xb0070000
+#define FW_MSG_CODE_DEBUG_DATA_SEND_BUF_FULL	0xb0080000
+#define FW_MSG_CODE_DEBUG_DATA_SEND_NO_BUF	0xb0090000
+#define FW_MSG_CODE_DEBUG_NOT_ENABLED		0xb00a0000
+#define FW_MSG_CODE_DEBUG_DATA_SEND_OK		0xb00b0000
+
 	u32 fw_mb_param;
 #define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK	0xFFFF0000
 #define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT	16
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index 2d176e1b508c..5fa251489536 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -868,6 +868,9 @@ void qed_hw_err_notify(struct qed_hwfn *p_hwfn,
 	}
 
 	qed_hw_error_occurred(p_hwfn, err_type);
+
+	if (fmt)
+		qed_mcp_send_raw_debug_data(p_hwfn, p_ptt, buf, len);
 }
 
 int qed_dmae_sanity(struct qed_hwfn *p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 46653afc385c..62be13d49dd8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3821,3 +3821,128 @@ int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 				  DRV_MSG_CODE_SET_NVM_CFG_OPTION,
 				  mb_param, &resp, &param, len, (u32 *)p_buf);
 }
+
+#define QED_MCP_DBG_DATA_MAX_SIZE               MCP_DRV_NVM_BUF_LEN
+#define QED_MCP_DBG_DATA_MAX_HEADER_SIZE        sizeof(u32)
+#define QED_MCP_DBG_DATA_MAX_PAYLOAD_SIZE \
+	(QED_MCP_DBG_DATA_MAX_SIZE - QED_MCP_DBG_DATA_MAX_HEADER_SIZE)
+
+static int
+__qed_mcp_send_debug_data(struct qed_hwfn *p_hwfn,
+			  struct qed_ptt *p_ptt, u8 *p_buf, u8 size)
+{
+	struct qed_mcp_mb_params mb_params;
+	int rc;
+
+	if (size > QED_MCP_DBG_DATA_MAX_SIZE) {
+		DP_ERR(p_hwfn,
+		       "Debug data size is %d while it should not exceed %d\n",
+		       size, QED_MCP_DBG_DATA_MAX_SIZE);
+		return -EINVAL;
+	}
+
+	memset(&mb_params, 0, sizeof(mb_params));
+	mb_params.cmd = DRV_MSG_CODE_DEBUG_DATA_SEND;
+	SET_MFW_FIELD(mb_params.param, DRV_MSG_CODE_DEBUG_DATA_SEND_SIZE, size);
+	mb_params.p_data_src = p_buf;
+	mb_params.data_src_size = size;
+	rc = qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
+	if (rc)
+		return rc;
+
+	if (mb_params.mcp_resp == FW_MSG_CODE_UNSUPPORTED) {
+		DP_INFO(p_hwfn,
+			"The DEBUG_DATA_SEND command is unsupported by the MFW\n");
+		return -EOPNOTSUPP;
+	} else if (mb_params.mcp_resp == (u32)FW_MSG_CODE_DEBUG_NOT_ENABLED) {
+		DP_INFO(p_hwfn, "The DEBUG_DATA_SEND command is not enabled\n");
+		return -EBUSY;
+	} else if (mb_params.mcp_resp != (u32)FW_MSG_CODE_DEBUG_DATA_SEND_OK) {
+		DP_NOTICE(p_hwfn,
+			  "Failed to send debug data to the MFW [resp 0x%08x]\n",
+			  mb_params.mcp_resp);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+enum qed_mcp_dbg_data_type {
+	QED_MCP_DBG_DATA_TYPE_RAW,
+};
+
+/* Header format: [31:28] PFID, [27:20] flags, [19:12] type, [11:0] S/N */
+#define QED_MCP_DBG_DATA_HDR_SN_OFFSET  0
+#define QED_MCP_DBG_DATA_HDR_SN_MASK            0x00000fff
+#define QED_MCP_DBG_DATA_HDR_TYPE_OFFSET        12
+#define QED_MCP_DBG_DATA_HDR_TYPE_MASK  0x000ff000
+#define QED_MCP_DBG_DATA_HDR_FLAGS_OFFSET       20
+#define QED_MCP_DBG_DATA_HDR_FLAGS_MASK 0x0ff00000
+#define QED_MCP_DBG_DATA_HDR_PF_OFFSET  28
+#define QED_MCP_DBG_DATA_HDR_PF_MASK            0xf0000000
+
+#define QED_MCP_DBG_DATA_HDR_FLAGS_FIRST        0x1
+#define QED_MCP_DBG_DATA_HDR_FLAGS_LAST 0x2
+
+static int
+qed_mcp_send_debug_data(struct qed_hwfn *p_hwfn,
+			struct qed_ptt *p_ptt,
+			enum qed_mcp_dbg_data_type type, u8 *p_buf, u32 size)
+{
+	u8 raw_data[QED_MCP_DBG_DATA_MAX_SIZE], *p_tmp_buf = p_buf;
+	u32 tmp_size = size, *p_header, *p_payload;
+	u8 flags = 0;
+	u16 seq;
+	int rc;
+
+	p_header = (u32 *)raw_data;
+	p_payload = (u32 *)(raw_data + QED_MCP_DBG_DATA_MAX_HEADER_SIZE);
+
+	seq = (u16)atomic_inc_return(&p_hwfn->mcp_info->dbg_data_seq);
+
+	/* First chunk is marked as 'first' */
+	flags |= QED_MCP_DBG_DATA_HDR_FLAGS_FIRST;
+
+	*p_header = 0;
+	SET_MFW_FIELD(*p_header, QED_MCP_DBG_DATA_HDR_SN, seq);
+	SET_MFW_FIELD(*p_header, QED_MCP_DBG_DATA_HDR_TYPE, type);
+	SET_MFW_FIELD(*p_header, QED_MCP_DBG_DATA_HDR_FLAGS, flags);
+	SET_MFW_FIELD(*p_header, QED_MCP_DBG_DATA_HDR_PF, p_hwfn->abs_pf_id);
+
+	while (tmp_size > QED_MCP_DBG_DATA_MAX_PAYLOAD_SIZE) {
+		memcpy(p_payload, p_tmp_buf, QED_MCP_DBG_DATA_MAX_PAYLOAD_SIZE);
+		rc = __qed_mcp_send_debug_data(p_hwfn, p_ptt, raw_data,
+					       QED_MCP_DBG_DATA_MAX_SIZE);
+		if (rc)
+			return rc;
+
+		/* Clear the 'first' marking after sending the first chunk */
+		if (p_tmp_buf == p_buf) {
+			flags &= ~QED_MCP_DBG_DATA_HDR_FLAGS_FIRST;
+			SET_MFW_FIELD(*p_header, QED_MCP_DBG_DATA_HDR_FLAGS,
+				      flags);
+		}
+
+		p_tmp_buf += QED_MCP_DBG_DATA_MAX_PAYLOAD_SIZE;
+		tmp_size -= QED_MCP_DBG_DATA_MAX_PAYLOAD_SIZE;
+	}
+
+	/* Last chunk is marked as 'last' */
+	flags |= QED_MCP_DBG_DATA_HDR_FLAGS_LAST;
+	SET_MFW_FIELD(*p_header, QED_MCP_DBG_DATA_HDR_FLAGS, flags);
+	memcpy(p_payload, p_tmp_buf, tmp_size);
+
+	/* Casting the left size to u8 is ok since at this point it is <= 32 */
+	return __qed_mcp_send_debug_data(p_hwfn, p_ptt, raw_data,
+					 (u8)(QED_MCP_DBG_DATA_MAX_HEADER_SIZE +
+					 tmp_size));
+}
+
+int
+qed_mcp_send_raw_debug_data(struct qed_hwfn *p_hwfn,
+			    struct qed_ptt *p_ptt, u8 *p_buf, u32 size)
+{
+	return qed_mcp_send_debug_data(p_hwfn, p_ptt,
+				       QED_MCP_DBG_DATA_TYPE_RAW, p_buf, size);
+}
+
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 9c4c2763de8d..bc248418a5f5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -685,6 +685,18 @@ int qed_mcp_bist_nvm_get_image_att(struct qed_hwfn *p_hwfn,
  */
 int qed_mfw_process_tlv_req(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
 
+/**
+ * @brief Send raw debug data to the MFW
+ *
+ * @param p_hwfn
+ * @param p_ptt
+ * @param p_buf - raw debug data buffer
+ * @param size - buffer size
+ */
+int
+qed_mcp_send_raw_debug_data(struct qed_hwfn *p_hwfn,
+			    struct qed_ptt *p_ptt, u8 *p_buf, u32 size);
+
 /* Using hwfn number (and not pf_num) is required since in CMT mode,
  * same pf_num may be used by two different hwfn
  * TODO - this shouldn't really be in .h file, but until all fields
@@ -731,6 +743,9 @@ struct qed_mcp_info {
 
 	/* Capabilties negotiated with the MFW */
 	u32					capabilities;
+
+	/* S/N for debug data mailbox commands */
+	atomic_t dbg_data_seq;
 };
 
 struct qed_mcp_mb_params {
-- 
2.25.1

