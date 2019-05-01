Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA5B106AF
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfEAJ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33740 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726376AbfEAJ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419tYin026237;
        Wed, 1 May 2019 02:58:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Gc0hvFzf8S7sYQ3L1YHsYInpcrohSPsenUud27H3pE0=;
 b=Jydy99D7bmEE3Z93E22m8f0cJVXkb/Xgyx7TQzo7vk1qdBuddBK4ERn5JUdw9J7lvRxA
 eW5cqaD5frWUf0ako+i0yjbnJ2x+Yp90/BxExpP18IGIRqS/2Pu5+i+UQ7NrlDTDWT6+
 7VxpW9Za6hu2GOr6Vs29W6OpLmc8Kj6jnXARtYRxbuN4M/cVjwkKkUkLN3k+5vaApfQ1
 GnSXq15KQU+rD+ks1cac9Vhlb8JJ3TNYG7aOZClqv9irao2m2ddFnt12QUV5iNjwO592
 bO6usDviQy6mY3h+wedM2csKpUb/KMPZo/GhXkz6pgyHlYcBcBMYZRIda4mS4Rma+Ywk hg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2s6xj61wp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:34 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:33 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:33 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 527CA3F7044;
        Wed,  1 May 2019 02:58:31 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 02/10] qed: Add llh ppfid interface and 100g support for offload protocols
Date:   Wed, 1 May 2019 12:57:14 +0300
Message-ID: <20190501095722.6902-3-michal.kalderon@marvell.com>
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

This patch refactors the current llh implementation. It exposes a hw
resource called ppfid (port-pfid) and implements an API for configuring
the resource. Default configuration which was used until now limited
the number of filters per PF and did not support engine affinity per
protocol. The new API enables allocating more filter rules per PF and
enables affinitizing protocol packets to a certain engine which
enables full 100g protocol offload support.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h          |   21 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 1246 +++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h  |   97 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h      |   16 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c    |   24 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h    |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c      |   28 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c      |   65 ++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h      |   16 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c     |   19 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h |    6 +
 11 files changed, 1203 insertions(+), 339 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index c5e96ce20f59..e8e8d7c4af5a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -140,6 +140,7 @@ struct qed_cxt_mngr;
 struct qed_sb_sp_info;
 struct qed_ll2_info;
 struct qed_mcp_info;
+struct qed_llh_info;
 
 struct qed_rt_data {
 	u32	*init_val;
@@ -741,6 +742,7 @@ struct qed_dev {
 #define QED_DEV_ID_MASK		0xff00
 #define QED_DEV_ID_MASK_BB	0x1600
 #define QED_DEV_ID_MASK_AH	0x8000
+#define QED_IS_E4(dev)  (QED_IS_BB(dev) || QED_IS_AH(dev))
 
 	u16	chip_num;
 #define CHIP_NUM_MASK                   0xffff
@@ -801,6 +803,11 @@ struct qed_dev {
 	u8				num_hwfns;
 	struct qed_hwfn			hwfns[MAX_HWFNS_PER_DEVICE];
 
+	/* Engine affinity */
+	u8				l2_affin_hint;
+	u8				fir_affin;
+	u8				iwarp_affin;
+
 	/* SRIOV */
 	struct qed_hw_sriov_info *p_iov_info;
 #define IS_QED_SRIOV(cdev)              (!!(cdev)->p_iov_info)
@@ -815,6 +822,10 @@ struct qed_dev {
 	/* Recovery */
 	bool recov_in_prog;
 
+	/* LLH info */
+	u8 ppfid_bitmap;
+	struct qed_llh_info *p_llh_info;
+
 	/* Linux specific here */
 	struct  qede_dev		*edev;
 	struct  pci_dev			*pdev;
@@ -904,6 +915,14 @@ void qed_set_fw_mac_addr(__le16 *fw_msb,
 			 __le16 *fw_mid, __le16 *fw_lsb, u8 *mac);
 
 #define QED_LEADING_HWFN(dev)   (&dev->hwfns[0])
+#define QED_IS_CMT(dev)		((dev)->num_hwfns > 1)
+/* Macros for getting the engine-affinitized hwfn (FIR: fcoe,iscsi,roce) */
+#define QED_FIR_AFFIN_HWFN(dev)		(&(dev)->hwfns[dev->fir_affin])
+#define QED_IWARP_AFFIN_HWFN(dev)       (&(dev)->hwfns[dev->iwarp_affin])
+#define QED_AFFIN_HWFN(dev)				   \
+	(QED_IS_IWARP_PERSONALITY(QED_LEADING_HWFN(dev)) ? \
+	 QED_IWARP_AFFIN_HWFN(dev) : QED_FIR_AFFIN_HWFN(dev))
+#define QED_AFFIN_HWFN_IDX(dev) (IS_LEAD_HWFN(QED_AFFIN_HWFN(dev)) ? 0 : 1)
 
 /* Flags for indication of required queues */
 #define PQ_FLAGS_RLS    (BIT(0))
@@ -923,8 +942,6 @@ u16 qed_get_cm_pq_idx_vf(struct qed_hwfn *p_hwfn, u16 vf);
 u16 qed_get_cm_pq_idx_ofld_mtc(struct qed_hwfn *p_hwfn, u8 tc);
 u16 qed_get_cm_pq_idx_llt_mtc(struct qed_hwfn *p_hwfn, u8 tc);
 
-#define QED_LEADING_HWFN(dev)   (&dev->hwfns[0])
-
 /* doorbell recovery mechanism */
 void qed_db_recovery_dp(struct qed_hwfn *p_hwfn);
 void qed_db_recovery_execute(struct qed_hwfn *p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index fccdb06fc5c5..c2b91d0adf1f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -361,6 +361,926 @@ void qed_db_recovery_execute(struct qed_hwfn *p_hwfn)
 
 /******************** Doorbell Recovery end ****************/
 
+/********************************** NIG LLH ***********************************/
+
+enum qed_llh_filter_type {
+	QED_LLH_FILTER_TYPE_MAC,
+	QED_LLH_FILTER_TYPE_PROTOCOL,
+};
+
+struct qed_llh_mac_filter {
+	u8 addr[ETH_ALEN];
+};
+
+struct qed_llh_protocol_filter {
+	enum qed_llh_prot_filter_type_t type;
+	u16 source_port_or_eth_type;
+	u16 dest_port;
+};
+
+union qed_llh_filter {
+	struct qed_llh_mac_filter mac;
+	struct qed_llh_protocol_filter protocol;
+};
+
+struct qed_llh_filter_info {
+	bool b_enabled;
+	u32 ref_cnt;
+	enum qed_llh_filter_type type;
+	union qed_llh_filter filter;
+};
+
+struct qed_llh_info {
+	/* Number of LLH filters banks */
+	u8 num_ppfid;
+
+#define MAX_NUM_PPFID   8
+	u8 ppfid_array[MAX_NUM_PPFID];
+
+	/* Array of filters arrays:
+	 * "num_ppfid" elements of filters banks, where each is an array of
+	 * "NIG_REG_LLH_FUNC_FILTER_EN_SIZE" filters.
+	 */
+	struct qed_llh_filter_info **pp_filters;
+};
+
+static void qed_llh_free(struct qed_dev *cdev)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+	u32 i;
+
+	if (p_llh_info) {
+		if (p_llh_info->pp_filters)
+			for (i = 0; i < p_llh_info->num_ppfid; i++)
+				kfree(p_llh_info->pp_filters[i]);
+
+		kfree(p_llh_info->pp_filters);
+	}
+
+	kfree(p_llh_info);
+	cdev->p_llh_info = NULL;
+}
+
+static int qed_llh_alloc(struct qed_dev *cdev)
+{
+	struct qed_llh_info *p_llh_info;
+	u32 size, i;
+
+	p_llh_info = kzalloc(sizeof(*p_llh_info), GFP_KERNEL);
+	if (!p_llh_info)
+		return -ENOMEM;
+	cdev->p_llh_info = p_llh_info;
+
+	for (i = 0; i < MAX_NUM_PPFID; i++) {
+		if (!(cdev->ppfid_bitmap & (0x1 << i)))
+			continue;
+
+		p_llh_info->ppfid_array[p_llh_info->num_ppfid] = i;
+		DP_VERBOSE(cdev, QED_MSG_SP, "ppfid_array[%d] = %hhd\n",
+			   p_llh_info->num_ppfid, i);
+		p_llh_info->num_ppfid++;
+	}
+
+	size = p_llh_info->num_ppfid * sizeof(*p_llh_info->pp_filters);
+	p_llh_info->pp_filters = kzalloc(size, GFP_KERNEL);
+	if (!p_llh_info->pp_filters)
+		return -ENOMEM;
+
+	size = NIG_REG_LLH_FUNC_FILTER_EN_SIZE *
+	    sizeof(**p_llh_info->pp_filters);
+	for (i = 0; i < p_llh_info->num_ppfid; i++) {
+		p_llh_info->pp_filters[i] = kzalloc(size, GFP_KERNEL);
+		if (!p_llh_info->pp_filters[i])
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int qed_llh_shadow_sanity(struct qed_dev *cdev,
+				 u8 ppfid, u8 filter_idx, const char *action)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+
+	if (ppfid >= p_llh_info->num_ppfid) {
+		DP_NOTICE(cdev,
+			  "LLH shadow [%s]: using ppfid %d while only %d ppfids are available\n",
+			  action, ppfid, p_llh_info->num_ppfid);
+		return -EINVAL;
+	}
+
+	if (filter_idx >= NIG_REG_LLH_FUNC_FILTER_EN_SIZE) {
+		DP_NOTICE(cdev,
+			  "LLH shadow [%s]: using filter_idx %d while only %d filters are available\n",
+			  action, filter_idx, NIG_REG_LLH_FUNC_FILTER_EN_SIZE);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define QED_LLH_INVALID_FILTER_IDX      0xff
+
+static int
+qed_llh_shadow_search_filter(struct qed_dev *cdev,
+			     u8 ppfid,
+			     union qed_llh_filter *p_filter, u8 *p_filter_idx)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+	struct qed_llh_filter_info *p_filters;
+	int rc;
+	u8 i;
+
+	rc = qed_llh_shadow_sanity(cdev, ppfid, 0, "search");
+	if (rc)
+		return rc;
+
+	*p_filter_idx = QED_LLH_INVALID_FILTER_IDX;
+
+	p_filters = p_llh_info->pp_filters[ppfid];
+	for (i = 0; i < NIG_REG_LLH_FUNC_FILTER_EN_SIZE; i++) {
+		if (!memcmp(p_filter, &p_filters[i].filter,
+			    sizeof(*p_filter))) {
+			*p_filter_idx = i;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int
+qed_llh_shadow_get_free_idx(struct qed_dev *cdev, u8 ppfid, u8 *p_filter_idx)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+	struct qed_llh_filter_info *p_filters;
+	int rc;
+	u8 i;
+
+	rc = qed_llh_shadow_sanity(cdev, ppfid, 0, "get_free_idx");
+	if (rc)
+		return rc;
+
+	*p_filter_idx = QED_LLH_INVALID_FILTER_IDX;
+
+	p_filters = p_llh_info->pp_filters[ppfid];
+	for (i = 0; i < NIG_REG_LLH_FUNC_FILTER_EN_SIZE; i++) {
+		if (!p_filters[i].b_enabled) {
+			*p_filter_idx = i;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int
+__qed_llh_shadow_add_filter(struct qed_dev *cdev,
+			    u8 ppfid,
+			    u8 filter_idx,
+			    enum qed_llh_filter_type type,
+			    union qed_llh_filter *p_filter, u32 *p_ref_cnt)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+	struct qed_llh_filter_info *p_filters;
+	int rc;
+
+	rc = qed_llh_shadow_sanity(cdev, ppfid, filter_idx, "add");
+	if (rc)
+		return rc;
+
+	p_filters = p_llh_info->pp_filters[ppfid];
+	if (!p_filters[filter_idx].ref_cnt) {
+		p_filters[filter_idx].b_enabled = true;
+		p_filters[filter_idx].type = type;
+		memcpy(&p_filters[filter_idx].filter, p_filter,
+		       sizeof(p_filters[filter_idx].filter));
+	}
+
+	*p_ref_cnt = ++p_filters[filter_idx].ref_cnt;
+
+	return 0;
+}
+
+static int
+qed_llh_shadow_add_filter(struct qed_dev *cdev,
+			  u8 ppfid,
+			  enum qed_llh_filter_type type,
+			  union qed_llh_filter *p_filter,
+			  u8 *p_filter_idx, u32 *p_ref_cnt)
+{
+	int rc;
+
+	/* Check if the same filter already exist */
+	rc = qed_llh_shadow_search_filter(cdev, ppfid, p_filter, p_filter_idx);
+	if (rc)
+		return rc;
+
+	/* Find a new entry in case of a new filter */
+	if (*p_filter_idx == QED_LLH_INVALID_FILTER_IDX) {
+		rc = qed_llh_shadow_get_free_idx(cdev, ppfid, p_filter_idx);
+		if (rc)
+			return rc;
+	}
+
+	/* No free entry was found */
+	if (*p_filter_idx == QED_LLH_INVALID_FILTER_IDX) {
+		DP_NOTICE(cdev,
+			  "Failed to find an empty LLH filter to utilize [ppfid %d]\n",
+			  ppfid);
+		return -EINVAL;
+	}
+
+	return __qed_llh_shadow_add_filter(cdev, ppfid, *p_filter_idx, type,
+					   p_filter, p_ref_cnt);
+}
+
+static int
+__qed_llh_shadow_remove_filter(struct qed_dev *cdev,
+			       u8 ppfid, u8 filter_idx, u32 *p_ref_cnt)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+	struct qed_llh_filter_info *p_filters;
+	int rc;
+
+	rc = qed_llh_shadow_sanity(cdev, ppfid, filter_idx, "remove");
+	if (rc)
+		return rc;
+
+	p_filters = p_llh_info->pp_filters[ppfid];
+	if (!p_filters[filter_idx].ref_cnt) {
+		DP_NOTICE(cdev,
+			  "LLH shadow: trying to remove a filter with ref_cnt=0\n");
+		return -EINVAL;
+	}
+
+	*p_ref_cnt = --p_filters[filter_idx].ref_cnt;
+	if (!p_filters[filter_idx].ref_cnt)
+		memset(&p_filters[filter_idx],
+		       0, sizeof(p_filters[filter_idx]));
+
+	return 0;
+}
+
+static int
+qed_llh_shadow_remove_filter(struct qed_dev *cdev,
+			     u8 ppfid,
+			     union qed_llh_filter *p_filter,
+			     u8 *p_filter_idx, u32 *p_ref_cnt)
+{
+	int rc;
+
+	rc = qed_llh_shadow_search_filter(cdev, ppfid, p_filter, p_filter_idx);
+	if (rc)
+		return rc;
+
+	/* No matching filter was found */
+	if (*p_filter_idx == QED_LLH_INVALID_FILTER_IDX) {
+		DP_NOTICE(cdev, "Failed to find a filter in the LLH shadow\n");
+		return -EINVAL;
+	}
+
+	return __qed_llh_shadow_remove_filter(cdev, ppfid, *p_filter_idx,
+					      p_ref_cnt);
+}
+
+static int qed_llh_abs_ppfid(struct qed_dev *cdev, u8 ppfid, u8 *p_abs_ppfid)
+{
+	struct qed_llh_info *p_llh_info = cdev->p_llh_info;
+
+	if (ppfid >= p_llh_info->num_ppfid) {
+		DP_NOTICE(cdev,
+			  "ppfid %d is not valid, available indices are 0..%hhd\n",
+			  ppfid, p_llh_info->num_ppfid - 1);
+		return -EINVAL;
+	}
+
+	*p_abs_ppfid = p_llh_info->ppfid_array[ppfid];
+
+	return 0;
+}
+
+static int
+qed_llh_set_engine_affin(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+{
+	struct qed_dev *cdev = p_hwfn->cdev;
+	enum qed_eng eng;
+	u8 ppfid;
+	int rc;
+
+	rc = qed_mcp_get_engine_config(p_hwfn, p_ptt);
+	if (rc != 0 && rc != -EOPNOTSUPP) {
+		DP_NOTICE(p_hwfn,
+			  "Failed to get the engine affinity configuration\n");
+		return rc;
+	}
+
+	/* RoCE PF is bound to a single engine */
+	if (QED_IS_ROCE_PERSONALITY(p_hwfn)) {
+		eng = cdev->fir_affin ? QED_ENG1 : QED_ENG0;
+		rc = qed_llh_set_roce_affinity(cdev, eng);
+		if (rc) {
+			DP_NOTICE(cdev,
+				  "Failed to set the RoCE engine affinity\n");
+			return rc;
+		}
+
+		DP_VERBOSE(cdev,
+			   QED_MSG_SP,
+			   "LLH: Set the engine affinity of RoCE packets as %d\n",
+			   eng);
+	}
+
+	/* Storage PF is bound to a single engine while L2 PF uses both */
+	if (QED_IS_FCOE_PERSONALITY(p_hwfn) || QED_IS_ISCSI_PERSONALITY(p_hwfn))
+		eng = cdev->fir_affin ? QED_ENG1 : QED_ENG0;
+	else			/* L2_PERSONALITY */
+		eng = QED_BOTH_ENG;
+
+	for (ppfid = 0; ppfid < cdev->p_llh_info->num_ppfid; ppfid++) {
+		rc = qed_llh_set_ppfid_affinity(cdev, ppfid, eng);
+		if (rc) {
+			DP_NOTICE(cdev,
+				  "Failed to set the engine affinity of ppfid %d\n",
+				  ppfid);
+			return rc;
+		}
+	}
+
+	DP_VERBOSE(cdev, QED_MSG_SP,
+		   "LLH: Set the engine affinity of non-RoCE packets as %d\n",
+		   eng);
+
+	return 0;
+}
+
+static int qed_llh_hw_init_pf(struct qed_hwfn *p_hwfn,
+			      struct qed_ptt *p_ptt)
+{
+	struct qed_dev *cdev = p_hwfn->cdev;
+	u8 ppfid, abs_ppfid;
+	int rc;
+
+	for (ppfid = 0; ppfid < cdev->p_llh_info->num_ppfid; ppfid++) {
+		u32 addr;
+
+		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+		if (rc)
+			return rc;
+
+		addr = NIG_REG_LLH_PPFID2PFID_TBL_0 + abs_ppfid * 0x4;
+		qed_wr(p_hwfn, p_ptt, addr, p_hwfn->rel_pf_id);
+	}
+
+	if (test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits) &&
+	    !QED_IS_FCOE_PERSONALITY(p_hwfn)) {
+		rc = qed_llh_add_mac_filter(cdev, 0,
+					    p_hwfn->hw_info.hw_mac_addr);
+		if (rc)
+			DP_NOTICE(cdev,
+				  "Failed to add an LLH filter with the primary MAC\n");
+	}
+
+	if (QED_IS_CMT(cdev)) {
+		rc = qed_llh_set_engine_affin(p_hwfn, p_ptt);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+u8 qed_llh_get_num_ppfid(struct qed_dev *cdev)
+{
+	return cdev->p_llh_info->num_ppfid;
+}
+
+#define NIG_REG_PPF_TO_ENGINE_SEL_ROCE_MASK             0x3
+#define NIG_REG_PPF_TO_ENGINE_SEL_ROCE_SHIFT            0
+#define NIG_REG_PPF_TO_ENGINE_SEL_NON_ROCE_MASK         0x3
+#define NIG_REG_PPF_TO_ENGINE_SEL_NON_ROCE_SHIFT        2
+
+int qed_llh_set_ppfid_affinity(struct qed_dev *cdev, u8 ppfid, enum qed_eng eng)
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	u32 addr, val, eng_sel;
+	u8 abs_ppfid;
+	int rc = 0;
+
+	if (!p_ptt)
+		return -EAGAIN;
+
+	if (!QED_IS_CMT(cdev))
+		goto out;
+
+	rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+	if (rc)
+		goto out;
+
+	switch (eng) {
+	case QED_ENG0:
+		eng_sel = 0;
+		break;
+	case QED_ENG1:
+		eng_sel = 1;
+		break;
+	case QED_BOTH_ENG:
+		eng_sel = 2;
+		break;
+	default:
+		DP_NOTICE(cdev, "Invalid affinity value for ppfid [%d]\n", eng);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	addr = NIG_REG_PPF_TO_ENGINE_SEL + abs_ppfid * 0x4;
+	val = qed_rd(p_hwfn, p_ptt, addr);
+	SET_FIELD(val, NIG_REG_PPF_TO_ENGINE_SEL_NON_ROCE, eng_sel);
+	qed_wr(p_hwfn, p_ptt, addr, val);
+
+	/* The iWARP affinity is set as the affinity of ppfid 0 */
+	if (!ppfid && QED_IS_IWARP_PERSONALITY(p_hwfn))
+		cdev->iwarp_affin = (eng == QED_ENG1) ? 1 : 0;
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+
+	return rc;
+}
+
+int qed_llh_set_roce_affinity(struct qed_dev *cdev, enum qed_eng eng)
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	u32 addr, val, eng_sel;
+	u8 ppfid, abs_ppfid;
+	int rc = 0;
+
+	if (!p_ptt)
+		return -EAGAIN;
+
+	if (!QED_IS_CMT(cdev))
+		goto out;
+
+	switch (eng) {
+	case QED_ENG0:
+		eng_sel = 0;
+		break;
+	case QED_ENG1:
+		eng_sel = 1;
+		break;
+	case QED_BOTH_ENG:
+		eng_sel = 2;
+		qed_wr(p_hwfn, p_ptt, NIG_REG_LLH_ENG_CLS_ROCE_QP_SEL,
+		       0xf /* QP bit 15 */);
+		break;
+	default:
+		DP_NOTICE(cdev, "Invalid affinity value for RoCE [%d]\n", eng);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	for (ppfid = 0; ppfid < cdev->p_llh_info->num_ppfid; ppfid++) {
+		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+		if (rc)
+			goto out;
+
+		addr = NIG_REG_PPF_TO_ENGINE_SEL + abs_ppfid * 0x4;
+		val = qed_rd(p_hwfn, p_ptt, addr);
+		SET_FIELD(val, NIG_REG_PPF_TO_ENGINE_SEL_ROCE, eng_sel);
+		qed_wr(p_hwfn, p_ptt, addr, val);
+	}
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+
+	return rc;
+}
+
+struct qed_llh_filter_details {
+	u64 value;
+	u32 mode;
+	u32 protocol_type;
+	u32 hdr_sel;
+	u32 enable;
+};
+
+static int
+qed_llh_access_filter(struct qed_hwfn *p_hwfn,
+		      struct qed_ptt *p_ptt,
+		      u8 abs_ppfid,
+		      u8 filter_idx,
+		      struct qed_llh_filter_details *p_details)
+{
+	struct qed_dmae_params params = {0};
+	u32 addr;
+	u8 pfid;
+	int rc;
+
+	/* The NIG/LLH registers that are accessed in this function have only 16
+	 * rows which are exposed to a PF. I.e. only the 16 filters of its
+	 * default ppfid. Accessing filters of other ppfids requires pretending
+	 * to another PFs.
+	 * The calculation of PPFID->PFID in AH is based on the relative index
+	 * of a PF on its port.
+	 * For BB the pfid is actually the abs_ppfid.
+	 */
+	if (QED_IS_BB(p_hwfn->cdev))
+		pfid = abs_ppfid;
+	else
+		pfid = abs_ppfid * p_hwfn->cdev->num_ports_in_engine +
+		    MFW_PORT(p_hwfn);
+
+	/* Filter enable - should be done first when removing a filter */
+	if (!p_details->enable) {
+		qed_fid_pretend(p_hwfn, p_ptt,
+				pfid << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
+
+		addr = NIG_REG_LLH_FUNC_FILTER_EN + filter_idx * 0x4;
+		qed_wr(p_hwfn, p_ptt, addr, p_details->enable);
+
+		qed_fid_pretend(p_hwfn, p_ptt,
+				p_hwfn->rel_pf_id <<
+				PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
+	}
+
+	/* Filter value */
+	addr = NIG_REG_LLH_FUNC_FILTER_VALUE + 2 * filter_idx * 0x4;
+
+	params.flags = QED_DMAE_FLAG_PF_DST;
+	params.dst_pfid = pfid;
+	rc = qed_dmae_host2grc(p_hwfn,
+			       p_ptt,
+			       (u64)(uintptr_t)&p_details->value,
+			       addr, 2 /* size_in_dwords */,
+			       &params);
+	if (rc)
+		return rc;
+
+	qed_fid_pretend(p_hwfn, p_ptt,
+			pfid << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
+
+	/* Filter mode */
+	addr = NIG_REG_LLH_FUNC_FILTER_MODE + filter_idx * 0x4;
+	qed_wr(p_hwfn, p_ptt, addr, p_details->mode);
+
+	/* Filter protocol type */
+	addr = NIG_REG_LLH_FUNC_FILTER_PROTOCOL_TYPE + filter_idx * 0x4;
+	qed_wr(p_hwfn, p_ptt, addr, p_details->protocol_type);
+
+	/* Filter header select */
+	addr = NIG_REG_LLH_FUNC_FILTER_HDR_SEL + filter_idx * 0x4;
+	qed_wr(p_hwfn, p_ptt, addr, p_details->hdr_sel);
+
+	/* Filter enable - should be done last when adding a filter */
+	if (p_details->enable) {
+		addr = NIG_REG_LLH_FUNC_FILTER_EN + filter_idx * 0x4;
+		qed_wr(p_hwfn, p_ptt, addr, p_details->enable);
+	}
+
+	qed_fid_pretend(p_hwfn, p_ptt,
+			p_hwfn->rel_pf_id <<
+			PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
+
+	return 0;
+}
+
+static int
+qed_llh_add_filter(struct qed_hwfn *p_hwfn,
+		   struct qed_ptt *p_ptt,
+		   u8 abs_ppfid,
+		   u8 filter_idx, u8 filter_prot_type, u32 high, u32 low)
+{
+	struct qed_llh_filter_details filter_details;
+
+	filter_details.enable = 1;
+	filter_details.value = ((u64)high << 32) | low;
+	filter_details.hdr_sel = 0;
+	filter_details.protocol_type = filter_prot_type;
+	/* Mode: 0: MAC-address classification 1: protocol classification */
+	filter_details.mode = filter_prot_type ? 1 : 0;
+
+	return qed_llh_access_filter(p_hwfn, p_ptt, abs_ppfid, filter_idx,
+				     &filter_details);
+}
+
+static int
+qed_llh_remove_filter(struct qed_hwfn *p_hwfn,
+		      struct qed_ptt *p_ptt, u8 abs_ppfid, u8 filter_idx)
+{
+	struct qed_llh_filter_details filter_details = {0};
+
+	return qed_llh_access_filter(p_hwfn, p_ptt, abs_ppfid, filter_idx,
+				     &filter_details);
+}
+
+int qed_llh_add_mac_filter(struct qed_dev *cdev,
+			   u8 ppfid, u8 mac_addr[ETH_ALEN])
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	union qed_llh_filter filter = {0};
+	u8 filter_idx, abs_ppfid;
+	u32 high, low, ref_cnt;
+	int rc = 0;
+
+	if (!p_ptt)
+		return -EAGAIN;
+
+	if (!test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits))
+		goto out;
+
+	memcpy(filter.mac.addr, mac_addr, ETH_ALEN);
+	rc = qed_llh_shadow_add_filter(cdev, ppfid,
+				       QED_LLH_FILTER_TYPE_MAC,
+				       &filter, &filter_idx, &ref_cnt);
+	if (rc)
+		goto err;
+
+	/* Configure the LLH only in case of a new the filter */
+	if (ref_cnt == 1) {
+		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+		if (rc)
+			goto err;
+
+		high = mac_addr[1] | (mac_addr[0] << 8);
+		low = mac_addr[5] | (mac_addr[4] << 8) | (mac_addr[3] << 16) |
+		      (mac_addr[2] << 24);
+		rc = qed_llh_add_filter(p_hwfn, p_ptt, abs_ppfid, filter_idx,
+					0, high, low);
+		if (rc)
+			goto err;
+	}
+
+	DP_VERBOSE(cdev,
+		   QED_MSG_SP,
+		   "LLH: Added MAC filter [%pM] to ppfid %hhd [abs %hhd] at idx %hhd [ref_cnt %d]\n",
+		   mac_addr, ppfid, abs_ppfid, filter_idx, ref_cnt);
+
+	goto out;
+
+err:	DP_NOTICE(cdev,
+		  "LLH: Failed to add MAC filter [%pM] to ppfid %hhd\n",
+		  mac_addr, ppfid);
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+
+	return rc;
+}
+
+static int
+qed_llh_protocol_filter_stringify(struct qed_dev *cdev,
+				  enum qed_llh_prot_filter_type_t type,
+				  u16 source_port_or_eth_type,
+				  u16 dest_port, u8 *str, size_t str_len)
+{
+	switch (type) {
+	case QED_LLH_FILTER_ETHERTYPE:
+		snprintf(str, str_len, "Ethertype 0x%04x",
+			 source_port_or_eth_type);
+		break;
+	case QED_LLH_FILTER_TCP_SRC_PORT:
+		snprintf(str, str_len, "TCP src port 0x%04x",
+			 source_port_or_eth_type);
+		break;
+	case QED_LLH_FILTER_UDP_SRC_PORT:
+		snprintf(str, str_len, "UDP src port 0x%04x",
+			 source_port_or_eth_type);
+		break;
+	case QED_LLH_FILTER_TCP_DEST_PORT:
+		snprintf(str, str_len, "TCP dst port 0x%04x", dest_port);
+		break;
+	case QED_LLH_FILTER_UDP_DEST_PORT:
+		snprintf(str, str_len, "UDP dst port 0x%04x", dest_port);
+		break;
+	case QED_LLH_FILTER_TCP_SRC_AND_DEST_PORT:
+		snprintf(str, str_len, "TCP src/dst ports 0x%04x/0x%04x",
+			 source_port_or_eth_type, dest_port);
+		break;
+	case QED_LLH_FILTER_UDP_SRC_AND_DEST_PORT:
+		snprintf(str, str_len, "UDP src/dst ports 0x%04x/0x%04x",
+			 source_port_or_eth_type, dest_port);
+		break;
+	default:
+		DP_NOTICE(cdev,
+			  "Non valid LLH protocol filter type %d\n", type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+qed_llh_protocol_filter_to_hilo(struct qed_dev *cdev,
+				enum qed_llh_prot_filter_type_t type,
+				u16 source_port_or_eth_type,
+				u16 dest_port, u32 *p_high, u32 *p_low)
+{
+	*p_high = 0;
+	*p_low = 0;
+
+	switch (type) {
+	case QED_LLH_FILTER_ETHERTYPE:
+		*p_high = source_port_or_eth_type;
+		break;
+	case QED_LLH_FILTER_TCP_SRC_PORT:
+	case QED_LLH_FILTER_UDP_SRC_PORT:
+		*p_low = source_port_or_eth_type << 16;
+		break;
+	case QED_LLH_FILTER_TCP_DEST_PORT:
+	case QED_LLH_FILTER_UDP_DEST_PORT:
+		*p_low = dest_port;
+		break;
+	case QED_LLH_FILTER_TCP_SRC_AND_DEST_PORT:
+	case QED_LLH_FILTER_UDP_SRC_AND_DEST_PORT:
+		*p_low = (source_port_or_eth_type << 16) | dest_port;
+		break;
+	default:
+		DP_NOTICE(cdev,
+			  "Non valid LLH protocol filter type %d\n", type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int
+qed_llh_add_protocol_filter(struct qed_dev *cdev,
+			    u8 ppfid,
+			    enum qed_llh_prot_filter_type_t type,
+			    u16 source_port_or_eth_type, u16 dest_port)
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	u8 filter_idx, abs_ppfid, str[32], type_bitmap;
+	union qed_llh_filter filter = {0};
+	u32 high, low, ref_cnt;
+	int rc = 0;
+
+	if (!p_ptt)
+		return -EAGAIN;
+
+	if (!test_bit(QED_MF_LLH_PROTO_CLSS, &cdev->mf_bits))
+		goto out;
+
+	rc = qed_llh_protocol_filter_stringify(cdev, type,
+					       source_port_or_eth_type,
+					       dest_port, str, sizeof(str));
+	if (rc)
+		goto err;
+
+	filter.protocol.type = type;
+	filter.protocol.source_port_or_eth_type = source_port_or_eth_type;
+	filter.protocol.dest_port = dest_port;
+	rc = qed_llh_shadow_add_filter(cdev,
+				       ppfid,
+				       QED_LLH_FILTER_TYPE_PROTOCOL,
+				       &filter, &filter_idx, &ref_cnt);
+	if (rc)
+		goto err;
+
+	/* Configure the LLH only in case of a new the filter */
+	if (ref_cnt == 1) {
+		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+		if (rc)
+			goto err;
+
+		rc = qed_llh_protocol_filter_to_hilo(cdev, type,
+						     source_port_or_eth_type,
+						     dest_port, &high, &low);
+		if (rc)
+			goto err;
+
+		type_bitmap = 0x1 << type;
+		rc = qed_llh_add_filter(p_hwfn, p_ptt, abs_ppfid,
+					filter_idx, type_bitmap, high, low);
+		if (rc)
+			goto err;
+	}
+
+	DP_VERBOSE(cdev,
+		   QED_MSG_SP,
+		   "LLH: Added protocol filter [%s] to ppfid %hhd [abs %hhd] at idx %hhd [ref_cnt %d]\n",
+		   str, ppfid, abs_ppfid, filter_idx, ref_cnt);
+
+	goto out;
+
+err:	DP_NOTICE(p_hwfn,
+		  "LLH: Failed to add protocol filter [%s] to ppfid %hhd\n",
+		  str, ppfid);
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+
+	return rc;
+}
+
+void qed_llh_remove_mac_filter(struct qed_dev *cdev,
+			       u8 ppfid, u8 mac_addr[ETH_ALEN])
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	union qed_llh_filter filter = {0};
+	u8 filter_idx, abs_ppfid;
+	int rc = 0;
+	u32 ref_cnt;
+
+	if (!p_ptt)
+		return;
+
+	if (!test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits))
+		goto out;
+
+	ether_addr_copy(filter.mac.addr, mac_addr);
+	rc = qed_llh_shadow_remove_filter(cdev, ppfid, &filter, &filter_idx,
+					  &ref_cnt);
+	if (rc)
+		goto err;
+
+	/* Remove from the LLH in case the filter is not in use */
+	if (!ref_cnt) {
+		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+		if (rc)
+			goto err;
+
+		rc = qed_llh_remove_filter(p_hwfn, p_ptt, abs_ppfid,
+					   filter_idx);
+		if (rc)
+			goto err;
+	}
+
+	DP_VERBOSE(cdev,
+		   QED_MSG_SP,
+		   "LLH: Removed MAC filter [%pM] from ppfid %hhd [abs %hhd] at idx %hhd [ref_cnt %d]\n",
+		   mac_addr, ppfid, abs_ppfid, filter_idx, ref_cnt);
+
+	goto out;
+
+err:	DP_NOTICE(cdev,
+		  "LLH: Failed to remove MAC filter [%pM] from ppfid %hhd\n",
+		  mac_addr, ppfid);
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+}
+
+void qed_llh_remove_protocol_filter(struct qed_dev *cdev,
+				    u8 ppfid,
+				    enum qed_llh_prot_filter_type_t type,
+				    u16 source_port_or_eth_type, u16 dest_port)
+{
+	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
+	u8 filter_idx, abs_ppfid, str[32];
+	union qed_llh_filter filter = {0};
+	int rc = 0;
+	u32 ref_cnt;
+
+	if (!p_ptt)
+		return;
+
+	if (!test_bit(QED_MF_LLH_PROTO_CLSS, &cdev->mf_bits))
+		goto out;
+
+	rc = qed_llh_protocol_filter_stringify(cdev, type,
+					       source_port_or_eth_type,
+					       dest_port, str, sizeof(str));
+	if (rc)
+		goto err;
+
+	filter.protocol.type = type;
+	filter.protocol.source_port_or_eth_type = source_port_or_eth_type;
+	filter.protocol.dest_port = dest_port;
+	rc = qed_llh_shadow_remove_filter(cdev, ppfid, &filter, &filter_idx,
+					  &ref_cnt);
+	if (rc)
+		goto err;
+
+	/* Remove from the LLH in case the filter is not in use */
+	if (!ref_cnt) {
+		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+		if (rc)
+			goto err;
+
+		rc = qed_llh_remove_filter(p_hwfn, p_ptt, abs_ppfid,
+					   filter_idx);
+		if (rc)
+			goto err;
+	}
+
+	DP_VERBOSE(cdev,
+		   QED_MSG_SP,
+		   "LLH: Removed protocol filter [%s] from ppfid %hhd [abs %hhd] at idx %hhd [ref_cnt %d]\n",
+		   str, ppfid, abs_ppfid, filter_idx, ref_cnt);
+
+	goto out;
+
+err:	DP_NOTICE(cdev,
+		  "LLH: Failed to remove protocol filter [%s] from ppfid %hhd\n",
+		  str, ppfid);
+out:
+	qed_ptt_release(p_hwfn, p_ptt);
+}
+
+/******************************* NIG LLH - End ********************************/
+
 #define QED_MIN_DPIS            (4)
 #define QED_MIN_PWM_REGION      (QED_WID_SIZE * QED_MIN_DPIS)
 
@@ -461,6 +1381,8 @@ void qed_resc_free(struct qed_dev *cdev)
 	kfree(cdev->reset_stats);
 	cdev->reset_stats = NULL;
 
+	qed_llh_free(cdev);
+
 	for_each_hwfn(cdev, i) {
 		struct qed_hwfn *p_hwfn = &cdev->hwfns[i];
 
@@ -1428,6 +2350,13 @@ int qed_resc_alloc(struct qed_dev *cdev)
 			goto alloc_err;
 	}
 
+	rc = qed_llh_alloc(cdev);
+	if (rc) {
+		DP_NOTICE(cdev,
+			  "Failed to allocate memory for the llh_info structure\n");
+		goto alloc_err;
+	}
+
 	cdev->reset_stats = kzalloc(sizeof(*cdev->reset_stats), GFP_KERNEL);
 	if (!cdev->reset_stats)
 		goto alloc_no_mem;
@@ -1879,6 +2808,10 @@ static int qed_hw_init_port(struct qed_hwfn *p_hwfn,
 {
 	int rc = 0;
 
+	/* In CMT the gate should be cleared by the 2nd hwfn */
+	if (!QED_IS_CMT(p_hwfn->cdev) || !IS_LEAD_HWFN(p_hwfn))
+		STORE_RT_REG(p_hwfn, NIG_REG_BRB_GATE_DNTFWD_PORT_RT_OFFSET, 0);
+
 	rc = qed_init_run(p_hwfn, p_ptt, PHASE_PORT, p_hwfn->port_id, hw_mode);
 	if (rc)
 		return rc;
@@ -1964,6 +2897,13 @@ static int qed_hw_init_pf(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
+	/* Use the leading hwfn since in CMT only NIG #0 is operational */
+	if (IS_LEAD_HWFN(p_hwfn)) {
+		rc = qed_llh_hw_init_pf(p_hwfn, p_ptt);
+		if (rc)
+			return rc;
+	}
+
 	if (b_hw_start) {
 		/* enable interrupts */
 		qed_int_igu_enable(p_hwfn, p_ptt, int_mode);
@@ -2393,6 +3333,12 @@ int qed_hw_stop(struct qed_dev *cdev)
 		qed_wr(p_hwfn, p_ptt, DORQ_REG_PF_DB_ENABLE, 0);
 		qed_wr(p_hwfn, p_ptt, QM_REG_PF_EN, 0);
 
+		if (IS_LEAD_HWFN(p_hwfn) &&
+		    test_bit(QED_MF_LLH_MAC_CLSS, &cdev->mf_bits) &&
+		    !QED_IS_FCOE_PERSONALITY(p_hwfn))
+			qed_llh_remove_mac_filter(cdev, 0,
+						  p_hwfn->hw_info.hw_mac_addr);
+
 		if (!cdev->recov_in_prog) {
 			rc = qed_mcp_unload_done(p_hwfn, p_ptt);
 			if (rc) {
@@ -2868,6 +3814,36 @@ static int qed_hw_set_resc_info(struct qed_hwfn *p_hwfn)
 	return 0;
 }
 
+static int qed_hw_get_ppfid_bitmap(struct qed_hwfn *p_hwfn,
+				   struct qed_ptt *p_ptt)
+{
+	struct qed_dev *cdev = p_hwfn->cdev;
+	u8 native_ppfid_idx;
+	int rc;
+
+	/* Calculation of BB/AH is different for native_ppfid_idx */
+	if (QED_IS_BB(cdev))
+		native_ppfid_idx = p_hwfn->rel_pf_id;
+	else
+		native_ppfid_idx = p_hwfn->rel_pf_id /
+		    cdev->num_ports_in_engine;
+
+	rc = qed_mcp_get_ppfid_bitmap(p_hwfn, p_ptt);
+	if (rc != 0 && rc != -EOPNOTSUPP)
+		return rc;
+	else if (rc == -EOPNOTSUPP)
+		cdev->ppfid_bitmap = 0x1 << native_ppfid_idx;
+
+	if (!(cdev->ppfid_bitmap & (0x1 << native_ppfid_idx))) {
+		DP_INFO(p_hwfn,
+			"Fix the PPFID bitmap to inculde the native PPFID [native_ppfid_idx %hhd, orig_bitmap 0x%hhx]\n",
+			native_ppfid_idx, cdev->ppfid_bitmap);
+		cdev->ppfid_bitmap = 0x1 << native_ppfid_idx;
+	}
+
+	return 0;
+}
+
 static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	struct qed_resc_unlock_params resc_unlock_params;
@@ -2925,6 +3901,13 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 				"Failed to release the resource lock for the resource allocation commands\n");
 	}
 
+	/* PPFID bitmap */
+	if (IS_LEAD_HWFN(p_hwfn)) {
+		rc = qed_hw_get_ppfid_bitmap(p_hwfn, p_ptt);
+		if (rc)
+			return rc;
+	}
+
 	/* Sanity for ILT */
 	if ((b_ah && (RESC_END(p_hwfn, QED_ILT) > PXP_NUM_ILT_RECORDS_K2)) ||
 	    (!b_ah && (RESC_END(p_hwfn, QED_ILT) > PXP_NUM_ILT_RECORDS_BB))) {
@@ -3951,269 +4934,6 @@ int qed_fw_rss_eng(struct qed_hwfn *p_hwfn, u8 src_id, u8 *dst_id)
 	return 0;
 }
 
-static void qed_llh_mac_to_filter(u32 *p_high, u32 *p_low,
-				  u8 *p_filter)
-{
-	*p_high = p_filter[1] | (p_filter[0] << 8);
-	*p_low = p_filter[5] | (p_filter[4] << 8) |
-		 (p_filter[3] << 16) | (p_filter[2] << 24);
-}
-
-int qed_llh_add_mac_filter(struct qed_hwfn *p_hwfn,
-			   struct qed_ptt *p_ptt, u8 *p_filter)
-{
-	u32 high = 0, low = 0, en;
-	int i;
-
-	if (!test_bit(QED_MF_LLH_MAC_CLSS, &p_hwfn->cdev->mf_bits))
-		return 0;
-
-	qed_llh_mac_to_filter(&high, &low, p_filter);
-
-	/* Find a free entry and utilize it */
-	for (i = 0; i < NIG_REG_LLH_FUNC_FILTER_EN_SIZE; i++) {
-		en = qed_rd(p_hwfn, p_ptt,
-			    NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32));
-		if (en)
-			continue;
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE +
-		       2 * i * sizeof(u32), low);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE +
-		       (2 * i + 1) * sizeof(u32), high);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_MODE + i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_PROTOCOL_TYPE +
-		       i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32), 1);
-		break;
-	}
-	if (i >= NIG_REG_LLH_FUNC_FILTER_EN_SIZE) {
-		DP_NOTICE(p_hwfn,
-			  "Failed to find an empty LLH filter to utilize\n");
-		return -EINVAL;
-	}
-
-	DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-		   "mac: %pM is added at %d\n",
-		   p_filter, i);
-
-	return 0;
-}
-
-void qed_llh_remove_mac_filter(struct qed_hwfn *p_hwfn,
-			       struct qed_ptt *p_ptt, u8 *p_filter)
-{
-	u32 high = 0, low = 0;
-	int i;
-
-	if (!test_bit(QED_MF_LLH_MAC_CLSS, &p_hwfn->cdev->mf_bits))
-		return;
-
-	qed_llh_mac_to_filter(&high, &low, p_filter);
-
-	/* Find the entry and clean it */
-	for (i = 0; i < NIG_REG_LLH_FUNC_FILTER_EN_SIZE; i++) {
-		if (qed_rd(p_hwfn, p_ptt,
-			   NIG_REG_LLH_FUNC_FILTER_VALUE +
-			   2 * i * sizeof(u32)) != low)
-			continue;
-		if (qed_rd(p_hwfn, p_ptt,
-			   NIG_REG_LLH_FUNC_FILTER_VALUE +
-			   (2 * i + 1) * sizeof(u32)) != high)
-			continue;
-
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE + 2 * i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE +
-		       (2 * i + 1) * sizeof(u32), 0);
-
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "mac: %pM is removed from %d\n",
-			   p_filter, i);
-		break;
-	}
-	if (i >= NIG_REG_LLH_FUNC_FILTER_EN_SIZE)
-		DP_NOTICE(p_hwfn, "Tried to remove a non-configured filter\n");
-}
-
-int
-qed_llh_add_protocol_filter(struct qed_hwfn *p_hwfn,
-			    struct qed_ptt *p_ptt,
-			    u16 source_port_or_eth_type,
-			    u16 dest_port, enum qed_llh_port_filter_type_t type)
-{
-	u32 high = 0, low = 0, en;
-	int i;
-
-	if (!test_bit(QED_MF_LLH_PROTO_CLSS, &p_hwfn->cdev->mf_bits))
-		return 0;
-
-	switch (type) {
-	case QED_LLH_FILTER_ETHERTYPE:
-		high = source_port_or_eth_type;
-		break;
-	case QED_LLH_FILTER_TCP_SRC_PORT:
-	case QED_LLH_FILTER_UDP_SRC_PORT:
-		low = source_port_or_eth_type << 16;
-		break;
-	case QED_LLH_FILTER_TCP_DEST_PORT:
-	case QED_LLH_FILTER_UDP_DEST_PORT:
-		low = dest_port;
-		break;
-	case QED_LLH_FILTER_TCP_SRC_AND_DEST_PORT:
-	case QED_LLH_FILTER_UDP_SRC_AND_DEST_PORT:
-		low = (source_port_or_eth_type << 16) | dest_port;
-		break;
-	default:
-		DP_NOTICE(p_hwfn,
-			  "Non valid LLH protocol filter type %d\n", type);
-		return -EINVAL;
-	}
-	/* Find a free entry and utilize it */
-	for (i = 0; i < NIG_REG_LLH_FUNC_FILTER_EN_SIZE; i++) {
-		en = qed_rd(p_hwfn, p_ptt,
-			    NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32));
-		if (en)
-			continue;
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE +
-		       2 * i * sizeof(u32), low);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE +
-		       (2 * i + 1) * sizeof(u32), high);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_MODE + i * sizeof(u32), 1);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_PROTOCOL_TYPE +
-		       i * sizeof(u32), 1 << type);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32), 1);
-		break;
-	}
-	if (i >= NIG_REG_LLH_FUNC_FILTER_EN_SIZE) {
-		DP_NOTICE(p_hwfn,
-			  "Failed to find an empty LLH filter to utilize\n");
-		return -EINVAL;
-	}
-	switch (type) {
-	case QED_LLH_FILTER_ETHERTYPE:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "ETH type %x is added at %d\n",
-			   source_port_or_eth_type, i);
-		break;
-	case QED_LLH_FILTER_TCP_SRC_PORT:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "TCP src port %x is added at %d\n",
-			   source_port_or_eth_type, i);
-		break;
-	case QED_LLH_FILTER_UDP_SRC_PORT:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "UDP src port %x is added at %d\n",
-			   source_port_or_eth_type, i);
-		break;
-	case QED_LLH_FILTER_TCP_DEST_PORT:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "TCP dst port %x is added at %d\n", dest_port, i);
-		break;
-	case QED_LLH_FILTER_UDP_DEST_PORT:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "UDP dst port %x is added at %d\n", dest_port, i);
-		break;
-	case QED_LLH_FILTER_TCP_SRC_AND_DEST_PORT:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "TCP src/dst ports %x/%x are added at %d\n",
-			   source_port_or_eth_type, dest_port, i);
-		break;
-	case QED_LLH_FILTER_UDP_SRC_AND_DEST_PORT:
-		DP_VERBOSE(p_hwfn, NETIF_MSG_HW,
-			   "UDP src/dst ports %x/%x are added at %d\n",
-			   source_port_or_eth_type, dest_port, i);
-		break;
-	}
-	return 0;
-}
-
-void
-qed_llh_remove_protocol_filter(struct qed_hwfn *p_hwfn,
-			       struct qed_ptt *p_ptt,
-			       u16 source_port_or_eth_type,
-			       u16 dest_port,
-			       enum qed_llh_port_filter_type_t type)
-{
-	u32 high = 0, low = 0;
-	int i;
-
-	if (!test_bit(QED_MF_LLH_PROTO_CLSS, &p_hwfn->cdev->mf_bits))
-		return;
-
-	switch (type) {
-	case QED_LLH_FILTER_ETHERTYPE:
-		high = source_port_or_eth_type;
-		break;
-	case QED_LLH_FILTER_TCP_SRC_PORT:
-	case QED_LLH_FILTER_UDP_SRC_PORT:
-		low = source_port_or_eth_type << 16;
-		break;
-	case QED_LLH_FILTER_TCP_DEST_PORT:
-	case QED_LLH_FILTER_UDP_DEST_PORT:
-		low = dest_port;
-		break;
-	case QED_LLH_FILTER_TCP_SRC_AND_DEST_PORT:
-	case QED_LLH_FILTER_UDP_SRC_AND_DEST_PORT:
-		low = (source_port_or_eth_type << 16) | dest_port;
-		break;
-	default:
-		DP_NOTICE(p_hwfn,
-			  "Non valid LLH protocol filter type %d\n", type);
-		return;
-	}
-
-	for (i = 0; i < NIG_REG_LLH_FUNC_FILTER_EN_SIZE; i++) {
-		if (!qed_rd(p_hwfn, p_ptt,
-			    NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32)))
-			continue;
-		if (!qed_rd(p_hwfn, p_ptt,
-			    NIG_REG_LLH_FUNC_FILTER_MODE + i * sizeof(u32)))
-			continue;
-		if (!(qed_rd(p_hwfn, p_ptt,
-			     NIG_REG_LLH_FUNC_FILTER_PROTOCOL_TYPE +
-			     i * sizeof(u32)) & BIT(type)))
-			continue;
-		if (qed_rd(p_hwfn, p_ptt,
-			   NIG_REG_LLH_FUNC_FILTER_VALUE +
-			   2 * i * sizeof(u32)) != low)
-			continue;
-		if (qed_rd(p_hwfn, p_ptt,
-			   NIG_REG_LLH_FUNC_FILTER_VALUE +
-			   (2 * i + 1) * sizeof(u32)) != high)
-			continue;
-
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_EN + i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_MODE + i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_PROTOCOL_TYPE +
-		       i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE + 2 * i * sizeof(u32), 0);
-		qed_wr(p_hwfn, p_ptt,
-		       NIG_REG_LLH_FUNC_FILTER_VALUE +
-		       (2 * i + 1) * sizeof(u32), 0);
-		break;
-	}
-
-	if (i >= NIG_REG_LLH_FUNC_FILTER_EN_SIZE)
-		DP_NOTICE(p_hwfn, "Tried to remove a non-configured filter\n");
-}
-
 static int qed_set_coalesce(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 			    u32 hw_addr, void *p_eth_qzone,
 			    size_t eth_qzone_size, u8 timeset)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index 35f0a586bd90..47376d4d071f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -374,26 +374,66 @@ int qed_fw_rss_eng(struct qed_hwfn *p_hwfn,
 		   u8 *dst_id);
 
 /**
- * @brief qed_llh_add_mac_filter - configures a MAC filter in llh
+ * @brief qed_llh_get_num_ppfid - Return the allocated number of LLH filter
+ *	banks that are allocated to the PF.
  *
- * @param p_hwfn
- * @param p_ptt
- * @param p_filter - MAC to add
+ * @param cdev
+ *
+ * @return u8 - Number of LLH filter banks
  */
-int qed_llh_add_mac_filter(struct qed_hwfn *p_hwfn,
-			   struct qed_ptt *p_ptt, u8 *p_filter);
+u8 qed_llh_get_num_ppfid(struct qed_dev *cdev);
+
+enum qed_eng {
+	QED_ENG0,
+	QED_ENG1,
+	QED_BOTH_ENG,
+};
 
 /**
- * @brief qed_llh_remove_mac_filter - removes a MAC filter from llh
+ * @brief qed_llh_set_ppfid_affinity - Set the engine affinity for the given
+ *	LLH filter bank.
+ *
+ * @param cdev
+ * @param ppfid - relative within the allocated ppfids ('0' is the default one).
+ * @param eng
+ *
+ * @return int
+ */
+int qed_llh_set_ppfid_affinity(struct qed_dev *cdev,
+			       u8 ppfid, enum qed_eng eng);
+
+/**
+ * @brief qed_llh_set_roce_affinity - Set the RoCE engine affinity
+ *
+ * @param cdev
+ * @param eng
+ *
+ * @return int
+ */
+int qed_llh_set_roce_affinity(struct qed_dev *cdev, enum qed_eng eng);
+
+/**
+ * @brief qed_llh_add_mac_filter - Add a LLH MAC filter into the given filter
+ *	bank.
+ *
+ * @param cdev
+ * @param ppfid - relative within the allocated ppfids ('0' is the default one).
+ * @param mac_addr - MAC to add
+ */
+int qed_llh_add_mac_filter(struct qed_dev *cdev,
+			   u8 ppfid, u8 mac_addr[ETH_ALEN]);
+
+/**
+ * @brief qed_llh_remove_mac_filter - Remove a LLH MAC filter from the given
+ *	filter bank.
  *
- * @param p_hwfn
  * @param p_ptt
  * @param p_filter - MAC to remove
  */
-void qed_llh_remove_mac_filter(struct qed_hwfn *p_hwfn,
-			       struct qed_ptt *p_ptt, u8 *p_filter);
+void qed_llh_remove_mac_filter(struct qed_dev *cdev,
+			       u8 ppfid, u8 mac_addr[ETH_ALEN]);
 
-enum qed_llh_port_filter_type_t {
+enum qed_llh_prot_filter_type_t {
 	QED_LLH_FILTER_ETHERTYPE,
 	QED_LLH_FILTER_TCP_SRC_PORT,
 	QED_LLH_FILTER_TCP_DEST_PORT,
@@ -404,36 +444,37 @@ enum qed_llh_port_filter_type_t {
 };
 
 /**
- * @brief qed_llh_add_protocol_filter - configures a protocol filter in llh
+ * @brief qed_llh_add_protocol_filter - Add a LLH protocol filter into the
+ *	given filter bank.
  *
- * @param p_hwfn
- * @param p_ptt
+ * @param cdev
+ * @param ppfid - relative within the allocated ppfids ('0' is the default one).
+ * @param type - type of filters and comparing
  * @param source_port_or_eth_type - source port or ethertype to add
  * @param dest_port - destination port to add
  * @param type - type of filters and comparing
  */
 int
-qed_llh_add_protocol_filter(struct qed_hwfn *p_hwfn,
-			    struct qed_ptt *p_ptt,
-			    u16 source_port_or_eth_type,
-			    u16 dest_port,
-			    enum qed_llh_port_filter_type_t type);
+qed_llh_add_protocol_filter(struct qed_dev *cdev,
+			    u8 ppfid,
+			    enum qed_llh_prot_filter_type_t type,
+			    u16 source_port_or_eth_type, u16 dest_port);
 
 /**
- * @brief qed_llh_remove_protocol_filter - remove a protocol filter in llh
+ * @brief qed_llh_remove_protocol_filter - Remove a LLH protocol filter from
+ *	the given filter bank.
  *
- * @param p_hwfn
- * @param p_ptt
+ * @param cdev
+ * @param ppfid - relative within the allocated ppfids ('0' is the default one).
+ * @param type - type of filters and comparing
  * @param source_port_or_eth_type - source port or ethertype to add
  * @param dest_port - destination port to add
- * @param type - type of filters and comparing
  */
 void
-qed_llh_remove_protocol_filter(struct qed_hwfn *p_hwfn,
-			       struct qed_ptt *p_ptt,
-			       u16 source_port_or_eth_type,
-			       u16 dest_port,
-			       enum qed_llh_port_filter_type_t type);
+qed_llh_remove_protocol_filter(struct qed_dev *cdev,
+			       u8 ppfid,
+			       enum qed_llh_prot_filter_type_t type,
+			       u16 source_port_or_eth_type, u16 dest_port);
 
 /**
  * *@brief Cleanup of previous driver remains prior to load
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 37edaa847512..e054f6c69e3a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12612,8 +12612,10 @@ struct public_drv_mb {
 
 #define DRV_MSG_CODE_BIST_TEST			0x001e0000
 #define DRV_MSG_CODE_SET_LED_MODE		0x00200000
-#define DRV_MSG_CODE_RESOURCE_CMD	0x00230000
+#define DRV_MSG_CODE_RESOURCE_CMD		0x00230000
 #define DRV_MSG_CODE_GET_TLV_DONE		0x002f0000
+#define DRV_MSG_CODE_GET_ENGINE_CONFIG		0x00370000
+#define DRV_MSG_CODE_GET_PPFID_BITMAP		0x43000000
 
 #define RESOURCE_CMD_REQ_RESC_MASK		0x0000001F
 #define RESOURCE_CMD_REQ_RESC_SHIFT		0
@@ -12802,6 +12804,18 @@ struct public_drv_mb {
 
 #define FW_MB_PARAM_LOAD_DONE_DID_EFUSE_ERROR	(1 << 0)
 
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_MASK   0x00000001
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID_SHIFT 0
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_MASK   0x00000002
+#define FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE_SHIFT 1
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_MASK    0x00000004
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID_SHIFT  2
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_MASK    0x00000008
+#define FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE_SHIFT  3
+
+#define FW_MB_PARAM_PPFID_BITMAP_MASK	0xFF
+#define FW_MB_PARAM_PPFID_BITMAP_SHIFT	0
+
 	u32 drv_pulse_mb;
 #define DRV_PULSE_SEQ_MASK			0x00007fff
 #define DRV_PULSE_SYSTEM_TIME_MASK		0xffff0000
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index ded556b7bab5..7c71ea15251f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2528,7 +2528,7 @@ qed_iwarp_ll2_slowpath(void *cxt,
 		memset(fpdu, 0, sizeof(*fpdu));
 }
 
-static int qed_iwarp_ll2_stop(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+static int qed_iwarp_ll2_stop(struct qed_hwfn *p_hwfn)
 {
 	struct qed_iwarp_info *iwarp_info = &p_hwfn->p_rdma_info->iwarp;
 	int rc = 0;
@@ -2563,8 +2563,9 @@ static int qed_iwarp_ll2_stop(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		iwarp_info->ll2_mpa_handle = QED_IWARP_HANDLE_INVAL;
 	}
 
-	qed_llh_remove_mac_filter(p_hwfn,
-				  p_ptt, p_hwfn->p_rdma_info->iwarp.mac_addr);
+	qed_llh_remove_mac_filter(p_hwfn->cdev, 0,
+				  p_hwfn->p_rdma_info->iwarp.mac_addr);
+
 	return rc;
 }
 
@@ -2608,8 +2609,7 @@ qed_iwarp_ll2_alloc_buffers(struct qed_hwfn *p_hwfn,
 
 static int
 qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
-		    struct qed_rdma_start_in_params *params,
-		    struct qed_ptt *p_ptt)
+		    struct qed_rdma_start_in_params *params)
 {
 	struct qed_iwarp_info *iwarp_info;
 	struct qed_ll2_acquire_data data;
@@ -2628,7 +2628,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 
 	ether_addr_copy(p_hwfn->p_rdma_info->iwarp.mac_addr, params->mac_addr);
 
-	rc = qed_llh_add_mac_filter(p_hwfn, p_ptt, params->mac_addr);
+	rc = qed_llh_add_mac_filter(p_hwfn->cdev, 0, params->mac_addr);
 	if (rc)
 		return rc;
 
@@ -2653,7 +2653,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	rc = qed_ll2_acquire_connection(p_hwfn, &data);
 	if (rc) {
 		DP_NOTICE(p_hwfn, "Failed to acquire LL2 connection\n");
-		qed_llh_remove_mac_filter(p_hwfn, p_ptt, params->mac_addr);
+		qed_llh_remove_mac_filter(p_hwfn->cdev, 0, params->mac_addr);
 		return rc;
 	}
 
@@ -2757,12 +2757,12 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 			      &iwarp_info->mpa_buf_list);
 	return rc;
 err:
-	qed_iwarp_ll2_stop(p_hwfn, p_ptt);
+	qed_iwarp_ll2_stop(p_hwfn);
 
 	return rc;
 }
 
-int qed_iwarp_setup(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+int qed_iwarp_setup(struct qed_hwfn *p_hwfn,
 		    struct qed_rdma_start_in_params *params)
 {
 	struct qed_iwarp_info *iwarp_info;
@@ -2794,10 +2794,10 @@ int qed_iwarp_setup(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 				  qed_iwarp_async_event);
 	qed_ooo_setup(p_hwfn);
 
-	return qed_iwarp_ll2_start(p_hwfn, params, p_ptt);
+	return qed_iwarp_ll2_start(p_hwfn, params);
 }
 
-int qed_iwarp_stop(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+int qed_iwarp_stop(struct qed_hwfn *p_hwfn)
 {
 	int rc;
 
@@ -2808,7 +2808,7 @@ int qed_iwarp_stop(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_IWARP);
 
-	return qed_iwarp_ll2_stop(p_hwfn, p_ptt);
+	return qed_iwarp_ll2_stop(p_hwfn);
 }
 
 static void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
index 7ac959038324..c1b2057d23b8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
@@ -183,13 +183,13 @@ struct qed_iwarp_listener {
 
 int qed_iwarp_alloc(struct qed_hwfn *p_hwfn);
 
-int qed_iwarp_setup(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
+int qed_iwarp_setup(struct qed_hwfn *p_hwfn,
 		    struct qed_rdma_start_in_params *params);
 
 void qed_iwarp_init_fw_ramrod(struct qed_hwfn *p_hwfn,
 			      struct iwarp_init_func_ramrod_data *p_ramrod);
 
-int qed_iwarp_stop(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
+int qed_iwarp_stop(struct qed_hwfn *p_hwfn);
 
 void qed_iwarp_resc_free(struct qed_hwfn *p_hwfn);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index b5f419b71287..922b7940c069 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1574,12 +1574,12 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 
 	if (p_ll2_conn->input.conn_type == QED_LL2_TYPE_FCOE) {
 		if (!test_bit(QED_MF_UFP_SPECIFIC, &p_hwfn->cdev->mf_bits))
-			qed_llh_add_protocol_filter(p_hwfn, p_ptt,
-						    ETH_P_FCOE, 0,
-						    QED_LLH_FILTER_ETHERTYPE);
-		qed_llh_add_protocol_filter(p_hwfn, p_ptt,
-					    ETH_P_FIP, 0,
-					    QED_LLH_FILTER_ETHERTYPE);
+			qed_llh_add_protocol_filter(p_hwfn->cdev, 0,
+						    QED_LLH_FILTER_ETHERTYPE,
+						    ETH_P_FCOE, 0);
+		qed_llh_add_protocol_filter(p_hwfn->cdev, 0,
+					    QED_LLH_FILTER_ETHERTYPE,
+					    ETH_P_FIP, 0);
 	}
 
 out:
@@ -1980,12 +1980,12 @@ int qed_ll2_terminate_connection(void *cxt, u8 connection_handle)
 
 	if (p_ll2_conn->input.conn_type == QED_LL2_TYPE_FCOE) {
 		if (!test_bit(QED_MF_UFP_SPECIFIC, &p_hwfn->cdev->mf_bits))
-			qed_llh_remove_protocol_filter(p_hwfn, p_ptt,
-						       ETH_P_FCOE, 0,
-						      QED_LLH_FILTER_ETHERTYPE);
-		qed_llh_remove_protocol_filter(p_hwfn, p_ptt,
-					       ETH_P_FIP, 0,
-					       QED_LLH_FILTER_ETHERTYPE);
+			qed_llh_remove_protocol_filter(p_hwfn->cdev, 0,
+						       QED_LLH_FILTER_ETHERTYPE,
+						       ETH_P_FCOE, 0);
+		qed_llh_remove_protocol_filter(p_hwfn->cdev, 0,
+					       QED_LLH_FILTER_ETHERTYPE,
+					       ETH_P_FIP, 0);
 	}
 
 out:
@@ -2386,8 +2386,6 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 		goto release_terminate;
 	}
 
-	rc = qed_llh_add_mac_filter(QED_LEADING_HWFN(cdev), p_ptt,
-				    params->ll2_mac_address);
 	qed_ptt_release(QED_LEADING_HWFN(cdev), p_ptt);
 	if (rc) {
 		DP_ERR(cdev, "Failed to allocate LLH filter\n");
@@ -2423,8 +2421,6 @@ static int qed_ll2_stop(struct qed_dev *cdev)
 		goto fail;
 	}
 
-	qed_llh_remove_mac_filter(QED_LEADING_HWFN(cdev), p_ptt,
-				  cdev->ll2_mac_address);
 	qed_ptt_release(QED_LEADING_HWFN(cdev), p_ptt);
 	eth_zero_addr(cdev->ll2_mac_address);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index cc27fd60d689..758702c1ce9c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3685,3 +3685,68 @@ int qed_mcp_set_capabilities(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return qed_mcp_cmd(p_hwfn, p_ptt, DRV_MSG_CODE_FEATURE_SUPPORT,
 			   features, &mcp_resp, &mcp_param);
 }
+
+int qed_mcp_get_engine_config(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+{
+	struct qed_mcp_mb_params mb_params = {0};
+	struct qed_dev *cdev = p_hwfn->cdev;
+	u8 fir_valid, l2_valid;
+	int rc;
+
+	mb_params.cmd = DRV_MSG_CODE_GET_ENGINE_CONFIG;
+	rc = qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
+	if (rc)
+		return rc;
+
+	if (mb_params.mcp_resp == FW_MSG_CODE_UNSUPPORTED) {
+		DP_INFO(p_hwfn,
+			"The get_engine_config command is unsupported by the MFW\n");
+		return -EOPNOTSUPP;
+	}
+
+	fir_valid = QED_MFW_GET_FIELD(mb_params.mcp_param,
+				      FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALID);
+	if (fir_valid)
+		cdev->fir_affin =
+		    QED_MFW_GET_FIELD(mb_params.mcp_param,
+				      FW_MB_PARAM_ENG_CFG_FIR_AFFIN_VALUE);
+
+	l2_valid = QED_MFW_GET_FIELD(mb_params.mcp_param,
+				     FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALID);
+	if (l2_valid)
+		cdev->l2_affin_hint =
+		    QED_MFW_GET_FIELD(mb_params.mcp_param,
+				      FW_MB_PARAM_ENG_CFG_L2_AFFIN_VALUE);
+
+	DP_INFO(p_hwfn,
+		"Engine affinity config: FIR={valid %hhd, value %hhd}, L2_hint={valid %hhd, value %hhd}\n",
+		fir_valid, cdev->fir_affin, l2_valid, cdev->l2_affin_hint);
+
+	return 0;
+}
+
+int qed_mcp_get_ppfid_bitmap(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
+{
+	struct qed_mcp_mb_params mb_params = {0};
+	struct qed_dev *cdev = p_hwfn->cdev;
+	int rc;
+
+	mb_params.cmd = DRV_MSG_CODE_GET_PPFID_BITMAP;
+	rc = qed_mcp_cmd_and_union(p_hwfn, p_ptt, &mb_params);
+	if (rc)
+		return rc;
+
+	if (mb_params.mcp_resp == FW_MSG_CODE_UNSUPPORTED) {
+		DP_INFO(p_hwfn,
+			"The get_ppfid_bitmap command is unsupported by the MFW\n");
+		return -EOPNOTSUPP;
+	}
+
+	cdev->ppfid_bitmap = QED_MFW_GET_FIELD(mb_params.mcp_param,
+					       FW_MB_PARAM_PPFID_BITMAP);
+
+	DP_VERBOSE(p_hwfn, QED_MSG_SP, "PPFID bitmap 0x%hhx\n",
+		   cdev->ppfid_bitmap);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 261c1a392e2c..e4f8fe4bd062 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1186,4 +1186,20 @@ void qed_mcp_read_ufp_config(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
  */
 int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn);
 
+/**
+ * @brief Get the engine affinity configuration.
+ *
+ * @param p_hwfn
+ * @param p_ptt
+ */
+int qed_mcp_get_engine_config(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
+
+/**
+ * @brief Get the PPFID bitmap.
+ *
+ * @param p_hwfn
+ * @param p_ptt
+ */
+int qed_mcp_get_ppfid_bitmap(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt);
+
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 7873d6dfd91f..7cf9bd8de708 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -700,7 +700,7 @@ static int qed_rdma_setup(struct qed_hwfn *p_hwfn,
 		return rc;
 
 	if (QED_IS_IWARP_PERSONALITY(p_hwfn)) {
-		rc = qed_iwarp_setup(p_hwfn, p_ptt, params);
+		rc = qed_iwarp_setup(p_hwfn, params);
 		if (rc)
 			return rc;
 	} else {
@@ -742,7 +742,7 @@ static int qed_rdma_stop(void *rdma_cxt)
 	       (ll2_ethertype_en & 0xFFFE));
 
 	if (QED_IS_IWARP_PERSONALITY(p_hwfn)) {
-		rc = qed_iwarp_stop(p_hwfn, p_ptt);
+		rc = qed_iwarp_stop(p_hwfn);
 		if (rc) {
 			qed_ptt_release(p_hwfn, p_ptt);
 			return rc;
@@ -1899,23 +1899,12 @@ static int qed_roce_ll2_set_mac_filter(struct qed_dev *cdev,
 				       u8 *old_mac_address,
 				       u8 *new_mac_address)
 {
-	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
-	struct qed_ptt *p_ptt;
 	int rc = 0;
 
-	p_ptt = qed_ptt_acquire(p_hwfn);
-	if (!p_ptt) {
-		DP_ERR(cdev,
-		       "qed roce ll2 mac filter set: failed to acquire PTT\n");
-		return -EINVAL;
-	}
-
 	if (old_mac_address)
-		qed_llh_remove_mac_filter(p_hwfn, p_ptt, old_mac_address);
+		qed_llh_remove_mac_filter(cdev, 0, old_mac_address);
 	if (new_mac_address)
-		rc = qed_llh_add_mac_filter(p_hwfn, p_ptt, new_mac_address);
-
-	qed_ptt_release(p_hwfn, p_ptt);
+		rc = qed_llh_add_mac_filter(cdev, 0, new_mac_address);
 
 	if (rc)
 		DP_ERR(cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
index 5ce825ca5f24..60f850c3bdd6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
@@ -254,6 +254,10 @@
 	0x500840UL
 #define NIG_REG_LLH_TAGMAC_DEF_PF_VECTOR \
 	0x50196cUL
+#define NIG_REG_LLH_PPFID2PFID_TBL_0 \
+	0x501970UL
+#define NIG_REG_LLH_ENG_CLS_ROCE_QP_SEL	\
+	0x50
 #define NIG_REG_LLH_CLS_TYPE_DUALMODE \
 	0x501964UL
 #define NIG_REG_LLH_FUNC_TAG_EN 0x5019b0UL
@@ -1626,6 +1630,8 @@
 #define PHY_PCIE_REG_PHY1_K2_E5 \
 	0x624000UL
 #define NIG_REG_ROCE_DUPLICATE_TO_HOST 0x5088f0UL
+#define NIG_REG_PPF_TO_ENGINE_SEL 0x508900UL
+#define NIG_REG_PPF_TO_ENGINE_SEL_SIZE 8
 #define PRS_REG_LIGHT_L2_ETHERTYPE_EN 0x1f0968UL
 #define NIG_REG_LLH_ENG_CLS_ENG_ID_TBL 0x501b90UL
 #define DORQ_REG_PF_DPM_ENABLE 0x100510UL
-- 
2.14.5

