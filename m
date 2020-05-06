Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DA1C6F65
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEFLd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:33:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgEFLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:33:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BXjRx030304;
        Wed, 6 May 2020 04:33:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ll+HOnuicoCRYhUV5pb0I8S4c03NOpJK39ZZb2OsCY0=;
 b=cPXe2Ti0UwncbsTsgEi8zvZ5qfT3ZFxRJhZKPNfbck1xfu4ovmjhzitpd7mYM0H/6qKo
 R2KkHTUA10dBnL8lHz6pX6JYhGPQyzKGzGgldspDayIyWtYXDGW/EGRb/ZcDa4nEwgIT
 GGsR10vjGcWZZD6iDyStC0Xm9bGk9NDhc9aRnn3rjoz7TSzc7Z8x7+UGzZU6EBG2C4ei
 2oejXaSEvGjtcygfSH+MBFSGWq1x+dJtvFkMrK0mBVDuBtjfl0ZiuY0m6HKLVCa9aZBf
 /Dk7n3o92N3z20esfF93Skw74ZLy4EtNbJ2TffI1a9/umIiRhRLH+gHc8s0oTxk0YGMx vQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytrs3w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:33:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:33:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:33:51 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 704183F7040;
        Wed,  6 May 2020 04:33:48 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 01/12] net: qed: adding hw_err states and handling
Date:   Wed, 6 May 2020 14:33:03 +0300
Message-ID: <9ef0ec556df586d1d9a75e3bf1a6fcb5cd7a25c6.1588758463.git.irusskikh@marvell.com>
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

Here we introduce qed device error tracking flags and error types.

qed_hw_err_notify is an entrace point to report errors.
It'll notify higher level drivers (qede/qedr/etc) to handle and recover
the error.

List of posible errors comes from hardware interfaces, but could be
extended in future.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_hw.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_hw.h   | 15 ++++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c | 29 ++++++++++++++++++++
 include/linux/qed/qed_if.h                 | 12 ++++++++
 5 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index fa41bf08a589..12c40ce3d876 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -1020,6 +1020,8 @@ u32 qed_unzip_data(struct qed_hwfn *p_hwfn,
 		   u32 input_len, u8 *input_buf,
 		   u32 max_size, u8 *unzip_buf);
 void qed_schedule_recovery_handler(struct qed_hwfn *p_hwfn);
+void qed_hw_error_occurred(struct qed_hwfn *p_hwfn,
+			   enum qed_hw_err_type err_type);
 void qed_get_protocol_stats(struct qed_dev *cdev,
 			    enum qed_mcp_protocol_type type,
 			    union qed_mcp_protocol_stats *stats);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index 4ab8cfaf63d1..90b777019cf5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -837,6 +837,38 @@ int qed_dmae_host2host(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
+void qed_hw_err_notify(struct qed_hwfn *p_hwfn,
+		       struct qed_ptt *p_ptt,
+		       enum qed_hw_err_type err_type, char *fmt, ...)
+{
+	char buf[QED_HW_ERR_MAX_STR_SIZE];
+	va_list vl;
+	int len;
+
+	if (fmt) {
+		va_start(vl, fmt);
+		len = vsnprintf(buf, QED_HW_ERR_MAX_STR_SIZE, fmt, vl);
+		va_end(vl);
+
+		if (len > QED_HW_ERR_MAX_STR_SIZE - 1)
+			len = QED_HW_ERR_MAX_STR_SIZE - 1;
+
+		DP_NOTICE(p_hwfn, "%s", buf);
+	}
+
+	/* Fan failure cannot be masked by handling of another HW error */
+	if (p_hwfn->cdev->recov_in_prog &&
+	    err_type != QED_HW_ERR_FAN_FAIL) {
+		DP_VERBOSE(p_hwfn,
+			   NETIF_MSG_DRV,
+			   "Recovery is in progress. Avoid notifying about HW error %d.\n",
+			   err_type);
+		return;
+	}
+
+	qed_hw_error_occurred(p_hwfn, err_type);
+}
+
 int qed_dmae_sanity(struct qed_hwfn *p_hwfn,
 		    struct qed_ptt *p_ptt, const char *phase)
 {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.h b/drivers/net/ethernet/qlogic/qed/qed_hw.h
index 505e94db939d..f5b109b04b66 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.h
@@ -315,4 +315,19 @@ int qed_init_fw_data(struct qed_dev *cdev,
 int qed_dmae_sanity(struct qed_hwfn *p_hwfn,
 		    struct qed_ptt *p_ptt, const char *phase);
 
+#define QED_HW_ERR_MAX_STR_SIZE 256
+
+/**
+ * @brief qed_hw_err_notify - Notify upper layer driver and management FW
+ *	about a HW error.
+ *
+ * @param p_hwfn
+ * @param p_ptt
+ * @param err_type
+ * @param fmt - debug data buffer to send to the MFW
+ * @param ... - buffer format args
+ */
+void qed_hw_err_notify(struct qed_hwfn *p_hwfn,
+		       struct qed_ptt *p_ptt,
+		       enum qed_hw_err_type err_type, char *fmt, ...);
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 38a1d26ca9db..d7c9d94e4c59 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2468,6 +2468,35 @@ void qed_schedule_recovery_handler(struct qed_hwfn *p_hwfn)
 		ops->schedule_recovery_handler(cookie);
 }
 
+char *qed_hw_err_type_descr[] = {
+	[QED_HW_ERR_FAN_FAIL]		= "Fan Failure",
+	[QED_HW_ERR_MFW_RESP_FAIL]	= "MFW Response Failure",
+	[QED_HW_ERR_HW_ATTN]		= "HW Attention",
+	[QED_HW_ERR_DMAE_FAIL]		= "DMAE Failure",
+	[QED_HW_ERR_RAMROD_FAIL]	= "Ramrod Failure",
+	[QED_HW_ERR_FW_ASSERT]		= "FW Assertion",
+	[QED_HW_ERR_LAST]		= "Unknown",
+};
+
+void qed_hw_error_occurred(struct qed_hwfn *p_hwfn,
+			   enum qed_hw_err_type err_type)
+{
+	struct qed_common_cb_ops *ops = p_hwfn->cdev->protocol_ops.common;
+	void *cookie = p_hwfn->cdev->ops_cookie;
+	char *err_str;
+
+	if (err_type > QED_HW_ERR_LAST)
+		err_type = QED_HW_ERR_LAST;
+	err_str = qed_hw_err_type_descr[err_type];
+
+	DP_NOTICE(p_hwfn, "HW error occurred [%s]\n", err_str);
+
+	/* Call the HW error handler of the protocol driver
+	 */
+	if (ops && ops->schedule_hw_err_handler)
+		ops->schedule_hw_err_handler(cookie, err_type);
+}
+
 static int qed_set_coalesce(struct qed_dev *cdev, u16 rx_coal, u16 tx_coal,
 			    void *handle)
 {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 8f29e0d8a7b3..1b7d9548ee43 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -607,6 +607,16 @@ struct qed_sb_info {
 	struct qed_dev *cdev;
 };
 
+enum qed_hw_err_type {
+	QED_HW_ERR_FAN_FAIL,
+	QED_HW_ERR_MFW_RESP_FAIL,
+	QED_HW_ERR_HW_ATTN,
+	QED_HW_ERR_DMAE_FAIL,
+	QED_HW_ERR_RAMROD_FAIL,
+	QED_HW_ERR_FW_ASSERT,
+	QED_HW_ERR_LAST,
+};
+
 enum qed_dev_type {
 	QED_DEV_TYPE_BB,
 	QED_DEV_TYPE_AH,
@@ -814,6 +824,8 @@ struct qed_common_cb_ops {
 	void	(*link_update)(void			*dev,
 			       struct qed_link_output	*link);
 	void (*schedule_recovery_handler)(void *dev);
+	void (*schedule_hw_err_handler)(void *dev,
+					enum qed_hw_err_type err_type);
 	void	(*dcbx_aen)(void *dev, struct qed_dcbx_get *get, u32 mib_type);
 	void (*get_generic_tlv_data)(void *dev, struct qed_generic_tlvs *data);
 	void (*get_protocol_tlv_data)(void *dev, void *data);
-- 
2.25.1

