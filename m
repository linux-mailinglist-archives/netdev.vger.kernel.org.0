Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9E539915A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFBRVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:21:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229620AbhFBRVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:21:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152HFhou018964;
        Wed, 2 Jun 2021 10:17:44 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xr0ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 10:17:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 10:17:42 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Jun 2021 10:17:39 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-nvme@lists.infradead.org>, <sagi@grimberg.me>, <hch@lst.de>,
        <axboe@fb.com>, <kbusch@kernel.org>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <prabhakar.pkin@gmail.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>
Subject: [PATCH 4/7] qed: Add support of HW filter block
Date:   Wed, 2 Jun 2021 20:16:52 +0300
Message-ID: <20210602171655.23581-5-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210602171655.23581-1-smalin@marvell.com>
References: <20210602171655.23581-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: eB-_NaFSBTzgJr8CSIaD2RNEOCI8BJVe
X-Proofpoint-GUID: eB-_NaFSBTzgJr8CSIaD2RNEOCI8BJVe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_09:2021-06-02,2021-06-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

This patch introduces the functionality of HW filter block.
It adds and removes filters based on source and target TCP port.

It also add functionality to clear all filters at once.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  8 ++
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 90 +++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |  5 ++
 include/linux/qed/qed_nvmetcp_if.h            | 24 +++++
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index bc9bdb9d1bb9..b590c70539b5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -49,6 +49,8 @@ extern const struct qed_common_ops qed_common_ops_pass;
 #define QED_MIN_WIDS		(4)
 #define QED_PF_DEMS_SIZE        (4)
 
+#define QED_LLH_DONT_CARE 0
+
 /* cau states */
 enum qed_coalescing_mode {
 	QED_COAL_MODE_DISABLE,
@@ -1005,4 +1007,10 @@ int qed_mfw_fill_tlv_data(struct qed_hwfn *hwfn,
 void qed_hw_info_set_offload_tc(struct qed_hw_info *p_info, u8 tc);
 
 void qed_periodic_db_rec_start(struct qed_hwfn *p_hwfn);
+
+int qed_llh_add_src_tcp_port_filter(struct qed_dev *cdev, u16 src_port);
+int qed_llh_add_dst_tcp_port_filter(struct qed_dev *cdev, u16 dest_port);
+void qed_llh_remove_src_tcp_port_filter(struct qed_dev *cdev, u16 src_port);
+void qed_llh_remove_dst_tcp_port_filter(struct qed_dev *cdev, u16 src_port);
+void qed_llh_clear_all_filters(struct qed_dev *cdev);
 #endif /* _QED_H */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 932b892f1ef1..0410c3604abd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5362,3 +5362,93 @@ void qed_set_fw_mac_addr(__le16 *fw_msb,
 	((u8 *)fw_lsb)[0] = mac[5];
 	((u8 *)fw_lsb)[1] = mac[4];
 }
+
+static int qed_llh_shadow_remove_all_filters(struct qed_dev *cdev, u8 ppfid)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+	struct qed_llh_filter_info *p_filters;
+	int rc;
+
+	rc = qed_llh_shadow_sanity(cdev, ppfid, 0, "remove_all");
+	if (rc)
+		return rc;
+
+	p_filters = p_llh_info->pp_filters[ppfid];
+	memset(p_filters, 0, NIG_REG_LLH_FUNC_FILTER_EN_SIZE *
+	       sizeof(*p_filters));
+
+	return 0;
+}
+
+static void qed_llh_clear_ppfid_filters(struct qed_dev *cdev, u8 ppfid)
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	u8 filter_idx, abs_ppfid;
+	int rc = 0;
+
+	if (!p_ptt)
+		return;
+
+	if (!test_bit(QED_MF_LLH_PROTO_CLSS, &cdev->mf_bits) &&
+	    !test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits))
+		goto out;
+
+	rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+	if (rc)
+		goto out;
+
+	rc = qed_llh_shadow_remove_all_filters(cdev, ppfid);
+	if (rc)
+		goto out;
+
+	for (filter_idx = 0; filter_idx < NIG_REG_LLH_FUNC_FILTER_EN_SIZE;
+	     filter_idx++) {
+		rc = qed_llh_remove_filter(p_hwfn, p_ptt,
+					   abs_ppfid, filter_idx);
+		if (rc)
+			goto out;
+	}
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+}
+
+int qed_llh_add_src_tcp_port_filter(struct qed_dev *cdev, u16 src_port)
+{
+	return qed_llh_add_protocol_filter(cdev, 0,
+					   QED_LLH_FILTER_TCP_SRC_PORT,
+					   src_port, QED_LLH_DONT_CARE);
+}
+
+void qed_llh_remove_src_tcp_port_filter(struct qed_dev *cdev, u16 src_port)
+{
+	qed_llh_remove_protocol_filter(cdev, 0,
+				       QED_LLH_FILTER_TCP_SRC_PORT,
+				       src_port, QED_LLH_DONT_CARE);
+}
+
+int qed_llh_add_dst_tcp_port_filter(struct qed_dev *cdev, u16 dest_port)
+{
+	return qed_llh_add_protocol_filter(cdev, 0,
+					   QED_LLH_FILTER_TCP_DEST_PORT,
+					   QED_LLH_DONT_CARE, dest_port);
+}
+
+void qed_llh_remove_dst_tcp_port_filter(struct qed_dev *cdev, u16 dest_port)
+{
+	qed_llh_remove_protocol_filter(cdev, 0,
+				       QED_LLH_FILTER_TCP_DEST_PORT,
+				       QED_LLH_DONT_CARE, dest_port);
+}
+
+void qed_llh_clear_all_filters(struct qed_dev *cdev)
+{
+	u8 ppfid;
+
+	if (!test_bit(QED_MF_LLH_PROTO_CLSS, &cdev->mf_bits) &&
+	    !test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits))
+		return;
+
+	for (ppfid = 0; ppfid < cdev->p_llh_info->num_ppfid; ppfid++)
+		qed_llh_clear_ppfid_filters(cdev, ppfid);
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
index 7943804e88cd..d4d609a4d3a3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
@@ -805,6 +805,11 @@ static const struct qed_nvmetcp_ops qed_nvmetcp_ops_pass = {
 	.update_conn = &qed_nvmetcp_update_conn,
 	.destroy_conn = &qed_nvmetcp_destroy_conn,
 	.clear_sq = &qed_nvmetcp_clear_conn_sq,
+	.add_src_tcp_port_filter = &qed_llh_add_src_tcp_port_filter,
+	.remove_src_tcp_port_filter = &qed_llh_remove_src_tcp_port_filter,
+	.add_dst_tcp_port_filter = &qed_llh_add_dst_tcp_port_filter,
+	.remove_dst_tcp_port_filter = &qed_llh_remove_dst_tcp_port_filter,
+	.clear_all_filters = &qed_llh_clear_all_filters
 };
 
 const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void)
diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed_nvmetcp_if.h
index 5baf1c5ce798..5180edad24e5 100644
--- a/include/linux/qed/qed_nvmetcp_if.h
+++ b/include/linux/qed/qed_nvmetcp_if.h
@@ -123,6 +123,20 @@ struct qed_nvmetcp_cb_ops {
  *			@param cdev
  *			@param handle - the connection handle.
  *			@return 0 on success, otherwise error value.
+ * @add_src_tcp_port_filter: Add source tcp port filter
+ *			@param cdev
+ *			@param src_port
+ * @remove_src_tcp_port_filter: Remove source tcp port filter
+ *			@param cdev
+ *			@param src_port
+ * @add_dst_tcp_port_filter: Add destination tcp port filter
+ *			@param cdev
+ *			@param dest_port
+ * @remove_dst_tcp_port_filter: Remove destination tcp port filter
+ *			@param cdev
+ *			@param dest_port
+ * @clear_all_filters: Clear all filters.
+ *			@param cdev
  */
 struct qed_nvmetcp_ops {
 	const struct qed_common_ops *common;
@@ -158,6 +172,16 @@ struct qed_nvmetcp_ops {
 	int (*destroy_conn)(struct qed_dev *cdev, u32 handle, u8 abrt_conn);
 
 	int (*clear_sq)(struct qed_dev *cdev, u32 handle);
+
+	int (*add_src_tcp_port_filter)(struct qed_dev *cdev, u16 src_port);
+
+	void (*remove_src_tcp_port_filter)(struct qed_dev *cdev, u16 src_port);
+
+	int (*add_dst_tcp_port_filter)(struct qed_dev *cdev, u16 dest_port);
+
+	void (*remove_dst_tcp_port_filter)(struct qed_dev *cdev, u16 dest_port);
+
+	void (*clear_all_filters)(struct qed_dev *cdev);
 };
 
 const struct qed_nvmetcp_ops *qed_get_nvmetcp_ops(void);
-- 
2.22.0

