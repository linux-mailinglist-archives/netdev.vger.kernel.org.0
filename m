Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBF61D2C00
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgENJ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:58:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29370 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgENJ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 05:58:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E9tvxY028123;
        Thu, 14 May 2020 02:58:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nDuh3ZV5GoeRGgIim9jlnuguIsva8B0cXEvt4G30RQE=;
 b=fQQjMJ2p5dM2ewqC+SYz9TuvHFLzbZrpSJx+a1smsYJMaeFfpZDUx8L0YJbfvqffwvZ2
 m869WOiKI2Bcpj+KHkQ2vIdllpuwwfLGrtFRUi4XGi1tY9Qp9HKcaaCHEpKscK8EaxkP
 dpCN70eoMm/SiganTNcUMk2TnHoAZ0iy5EkGwF55raPELlNLyljN52dzfTXqeGJjdnlI
 Z33vdZ0/p9hW/iQR0jOfEJNb8G0bZJrE1fGxfovzThNcXgAzAUAQQrmppg91aP7lf4a3
 5r91bk3zf/1ziy1y1Lf2Pju9ZvNn6FxccoWXuv72shaCoxP/MnKEND5mQrOcsB0ce9Ke Kw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1qxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 02:58:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:58:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:58:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 02:58:23 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id CE9A53F7040;
        Thu, 14 May 2020 02:58:20 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "Michal Kalderon" <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 10/11] net: qed: introduce critical hardware error handler
Date:   Thu, 14 May 2020 12:57:26 +0300
Message-ID: <20200514095727.1361-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514095727.1361-1-irusskikh@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MCP may signal driver about generic critical failure.
Driver has to collect mdump information (get_retain),
it pushes that to logs and triggers generic notification on
"hardware attention" event.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h |  28 +++++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 113 ++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h |  13 +++
 3 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index ab042b835797..f00460d00cab 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12400,6 +12400,13 @@ struct load_rsp_stc {
 #define LOAD_RSP_FLAGS0_DRV_EXISTS      (0x1 << 0)
 };
 
+struct mdump_retain_data_stc {
+	u32 valid;
+	u32 epoch;
+	u32 pf;
+	u32 status;
+};
+
 union drv_union_data {
 	u32 ver_str[MCP_DRV_VER_STR_SIZE_DWORD];
 	struct mcp_mac wol_mac;
@@ -12488,6 +12495,8 @@ struct public_drv_mb {
 #define DRV_MSG_CODE_BIST_TEST			0x001e0000
 #define DRV_MSG_CODE_SET_LED_MODE		0x00200000
 #define DRV_MSG_CODE_RESOURCE_CMD		0x00230000
+/* Send crash dump commands with param[3:0] - opcode */
+#define DRV_MSG_CODE_MDUMP_CMD			0x00250000
 #define DRV_MSG_CODE_GET_TLV_DONE		0x002f0000
 #define DRV_MSG_CODE_GET_ENGINE_CONFIG		0x00370000
 #define DRV_MSG_CODE_GET_PPFID_BITMAP		0x43000000
@@ -12519,6 +12528,21 @@ struct public_drv_mb {
 
 #define RESOURCE_DUMP				0
 
+/* DRV_MSG_CODE_MDUMP_CMD parameters */
+#define MDUMP_DRV_PARAM_OPCODE_MASK             0x0000000f
+#define DRV_MSG_CODE_MDUMP_ACK                  0x01
+#define DRV_MSG_CODE_MDUMP_SET_VALUES           0x02
+#define DRV_MSG_CODE_MDUMP_TRIGGER              0x03
+#define DRV_MSG_CODE_MDUMP_GET_CONFIG           0x04
+#define DRV_MSG_CODE_MDUMP_SET_ENABLE           0x05
+#define DRV_MSG_CODE_MDUMP_CLEAR_LOGS           0x06
+#define DRV_MSG_CODE_MDUMP_GET_RETAIN           0x07
+#define DRV_MSG_CODE_MDUMP_CLR_RETAIN           0x08
+
+#define DRV_MSG_CODE_HW_DUMP_TRIGGER            0x0a
+#define DRV_MSG_CODE_MDUMP_GEN_MDUMP2           0x0b
+#define DRV_MSG_CODE_MDUMP_FREE_MDUMP2          0x0c
+
 #define DRV_MSG_CODE_GET_PF_RDMA_PROTOCOL	0x002b0000
 #define DRV_MSG_CODE_OS_WOL			0x002e0000
 
@@ -12697,6 +12721,8 @@ struct public_drv_mb {
 #define FW_MSG_CODE_DEBUG_NOT_ENABLED		0xb00a0000
 #define FW_MSG_CODE_DEBUG_DATA_SEND_OK		0xb00b0000
 
+#define FW_MSG_CODE_MDUMP_INVALID_CMD		0x00030000
+
 	u32 fw_mb_param;
 #define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_MASK	0xFFFF0000
 #define FW_MB_PARAM_RESOURCE_ALLOC_VERSION_MAJOR_SHIFT	16
@@ -12763,7 +12789,7 @@ enum MFW_DRV_MSG_TYPE {
 	MFW_DRV_MSG_GET_RDMA_STATS,
 	MFW_DRV_MSG_FAILURE_DETECTED,
 	MFW_DRV_MSG_TRANSCEIVER_STATE_CHANGE,
-	MFW_DRV_MSG_BW_UPDATE11,
+	MFW_DRV_MSG_CRITICAL_ERROR_OCCURRED,
 	MFW_DRV_MSG_RESERVED,
 	MFW_DRV_MSG_GET_TLV_REQ,
 	MFW_DRV_MSG_OEM_CFG_UPDATE,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 0058e804efc3..8a0bbc7d4b24 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -1717,6 +1717,116 @@ static void qed_mcp_handle_fan_failure(struct qed_hwfn *p_hwfn,
 			  "Fan failure was detected on the network interface card and it's going to be shut down.\n");
 }
 
+struct qed_mdump_cmd_params {
+	u32 cmd;
+	void *p_data_src;
+	u8 data_src_size;
+	void *p_data_dst;
+	u8 data_dst_size;
+	u32 mcp_resp;
+};
+
+static int
+qed_mcp_mdump_cmd(struct qed_hwfn *p_hwfn,
+		  struct qed_ptt *p_ptt,
+		  struct qed_mdump_cmd_params *p_mdump_cmd_params)
+{
+	struct qed_mcp_mb_params mb_params;
+	int rc;
+
+	memset(&mb_params, 0, sizeof(mb_params));
+	mb_params.cmd = DRV_MSG_CODE_MDUMP_CMD;
+	mb_params.param = p_mdump_cmd_params->cmd;
+	mb_params.p_data_src = p_mdump_cmd_params->p_data_src;
+	mb_params.data_src_size = p_mdump_cmd_params->data_src_size;
+	mb_params.p_data_dst = p_mdump_cmd_params->p_data_dst;
+	mb_params.data_dst_size = p_mdump_cmd_params->data_dst_size;
+	rc = qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
+	if (rc)
+		return rc;
+
+	p_mdump_cmd_params->mcp_resp = mb_params.mcp_resp;
+
+	if (p_mdump_cmd_params->mcp_resp == FW_MSG_CODE_MDUMP_INVALID_CMD) {
+		DP_INFO(p_hwfn,
+			"The mdump sub command is unsupported by the MFW [mdump_cmd 0x%x]\n",
+			p_mdump_cmd_params->cmd);
+		rc = -EOPNOTSUPP;
+	} else if (p_mdump_cmd_params->mcp_resp == FW_MSG_CODE_UNSUPPORTED) {
+		DP_INFO(p_hwfn,
+			"The mdump command is not supported by the MFW\n");
+		rc = -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+static int qed_mcp_mdump_ack(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+{
+	struct qed_mdump_cmd_params mdump_cmd_params;
+
+	memset(&mdump_cmd_params, 0, sizeof(mdump_cmd_params));
+	mdump_cmd_params.cmd = DRV_MSG_CODE_MDUMP_ACK;
+
+	return qed_mcp_mdump_cmd(p_hwfn, p_ptt, &mdump_cmd_params);
+}
+
+int
+qed_mcp_mdump_get_retain(struct qed_hwfn *p_hwfn,
+			 struct qed_ptt *p_ptt,
+			 struct mdump_retain_data_stc *p_mdump_retain)
+{
+	struct qed_mdump_cmd_params mdump_cmd_params;
+	int rc;
+
+	memset(&mdump_cmd_params, 0, sizeof(mdump_cmd_params));
+	mdump_cmd_params.cmd = DRV_MSG_CODE_MDUMP_GET_RETAIN;
+	mdump_cmd_params.p_data_dst = p_mdump_retain;
+	mdump_cmd_params.data_dst_size = sizeof(*p_mdump_retain);
+
+	rc = qed_mcp_mdump_cmd(p_hwfn, p_ptt, &mdump_cmd_params);
+	if (rc)
+		return rc;
+
+	if (mdump_cmd_params.mcp_resp != FW_MSG_CODE_OK) {
+		DP_INFO(p_hwfn,
+			"Failed to get the mdump retained data [mcp_resp 0x%x]\n",
+			mdump_cmd_params.mcp_resp);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void qed_mcp_handle_critical_error(struct qed_hwfn *p_hwfn,
+					  struct qed_ptt *p_ptt)
+{
+	struct mdump_retain_data_stc mdump_retain;
+	int rc;
+
+	/* In CMT mode - no need for more than a single acknowledgment to the
+	 * MFW, and no more than a single notification to the upper driver.
+	 */
+	if (p_hwfn != QED_LEADING_HWFN(p_hwfn->cdev))
+		return;
+
+	rc = qed_mcp_mdump_get_retain(p_hwfn, p_ptt, &mdump_retain);
+	if (rc == 0 && mdump_retain.valid)
+		DP_NOTICE(p_hwfn,
+			  "The MFW notified that a critical error occurred in the device [epoch 0x%08x, pf 0x%x, status 0x%08x]\n",
+			  mdump_retain.epoch,
+			  mdump_retain.pf, mdump_retain.status);
+	else
+		DP_NOTICE(p_hwfn,
+			  "The MFW notified that a critical error occurred in the device\n");
+
+	DP_NOTICE(p_hwfn,
+		  "Acknowledging the notification to not allow the MFW crash dump [driver debug data collection is preferable]\n");
+	qed_mcp_mdump_ack(p_hwfn, p_ptt);
+
+	qed_hw_err_notify(p_hwfn, p_ptt, QED_HW_ERR_HW_ATTN, NULL);
+}
+
 void qed_mcp_read_ufp_config(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	struct public_func shmem_info;
@@ -1866,6 +1976,9 @@ int qed_mcp_handle_events(struct qed_hwfn *p_hwfn,
 		case MFW_DRV_MSG_FAILURE_DETECTED:
 			qed_mcp_handle_fan_failure(p_hwfn, p_ptt);
 			break;
+		case MFW_DRV_MSG_CRITICAL_ERROR_OCCURRED:
+			qed_mcp_handle_critical_error(p_hwfn, p_ptt);
+			break;
 		case MFW_DRV_MSG_GET_TLV_REQ:
 			qed_mfw_tlv_req(p_hwfn);
 			break;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index bc248418a5f5..5750b4c5ef63 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1016,6 +1016,19 @@ int __qed_configure_pf_min_bandwidth(struct qed_hwfn *p_hwfn,
 int qed_mcp_mask_parities(struct qed_hwfn *p_hwfn,
 			  struct qed_ptt *p_ptt, u32 mask_parities);
 
+/* @brief - Gets the mdump retained data from the MFW.
+ *
+ * @param p_hwfn
+ * @param p_ptt
+ * @param p_mdump_retain
+ *
+ * @param return 0 upon success.
+ */
+int
+qed_mcp_mdump_get_retain(struct qed_hwfn *p_hwfn,
+			 struct qed_ptt *p_ptt,
+			 struct mdump_retain_data_stc *p_mdump_retain);
+
 /**
  * @brief - Sets the MFW's max value for the given resource
  *
-- 
2.17.1

