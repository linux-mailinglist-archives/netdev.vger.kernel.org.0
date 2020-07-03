Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CA3213729
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGCJD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 05:03:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbgGCJDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 05:03:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0638w0L1000510;
        Fri, 3 Jul 2020 02:03:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=a9wF/+uUiRveHVijX6qjBA2kDHqt8RJI3osEo4twyUk=;
 b=p+gagi02dQbAhvZDIeeUFHe9KxHpzMAS+gsJCCawPjrrImKFPnBR9ftOFAeKZRhX+YSc
 G+ZcRjU+Wi6+WtkOvwn09lkggbQpvedjUbwM9LK0iRO4gsvO9tauJuW1U/Y1z1olbJlW
 0FxyijcJqPVIRSqe36GtIFfRCm9gE0XKj0q4/DodhlWC/4sfl6gV33b2912FoP4D9Ju7
 T5+H5f1VNJf1LVo/45HJ11N1kHt5It+gA5IaAfl/J5Mjt05OtjRVPDO2NR5ytvo6kYkg
 NOTmF3rpzko/5I2wN2idnOBnIkGy+oZ/EmmOLNcZGIUdI16KE/Zu2V3nEX+Trj3ojwq7 Rg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31x5mp1475-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 02:03:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 02:03:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 02:03:48 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 8DE283F703F;
        Fri,  3 Jul 2020 02:03:45 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: qed: prevent buffer overflow when collecting debug data
Date:   Fri, 3 Jul 2020 12:02:58 +0300
Message-ID: <20200703090258.2076-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_03:2020-07-02,2020-07-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating debug dump, driver firstly collects all data in binary
form, and then performs per-feature formatting to human-readable if it
is supported.
The size of the new formatted data is often larger than the raw's. This
becomes critical when user requests dump via ethtool (-d/-w), as output
buffer size is strictly determined (by ethtool_ops::get_regs_len() etc),
as it may lead to out-of-bounds writes and memory corruption.

To not go past initial lengths, add a flag to return original,
non-formatted debug data, and set it in such cases. Also set data type
in regdump headers, so userland parsers could handle it.

Fixes: c965db444629 ("qed: Add support for debug data collection")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h       |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index a49743d56b9c..6c2f9ff4a53e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -876,6 +876,8 @@ struct qed_dev {
 	struct qed_dbg_feature dbg_features[DBG_FEATURE_NUM];
 	u8 engine_for_debug;
 	bool disable_ilt_dump;
+	bool				dbg_bin_dump;
+
 	DECLARE_HASHTABLE(connections, 10);
 	const struct firmware		*firmware;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 81e8fbe4a05b..cb80863d5a77 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7506,6 +7506,12 @@ static enum dbg_status format_feature(struct qed_hwfn *p_hwfn,
 	if (p_hwfn->cdev->print_dbg_data)
 		qed_dbg_print_feature(text_buf, text_size_bytes);
 
+	/* Just return the original binary buffer if requested */
+	if (p_hwfn->cdev->dbg_bin_dump) {
+		vfree(text_buf);
+		return DBG_STATUS_OK;
+	}
+
 	/* Free the old dump_buf and point the dump_buf to the newly allocagted
 	 * and formatted text buffer.
 	 */
@@ -7733,7 +7739,9 @@ int qed_dbg_mcp_trace_size(struct qed_dev *cdev)
 #define REGDUMP_HEADER_SIZE_SHIFT		0
 #define REGDUMP_HEADER_SIZE_MASK		0xffffff
 #define REGDUMP_HEADER_FEATURE_SHIFT		24
-#define REGDUMP_HEADER_FEATURE_MASK		0x3f
+#define REGDUMP_HEADER_FEATURE_MASK		0x1f
+#define REGDUMP_HEADER_BIN_DUMP_SHIFT		29
+#define REGDUMP_HEADER_BIN_DUMP_MASK		0x1
 #define REGDUMP_HEADER_OMIT_ENGINE_SHIFT	30
 #define REGDUMP_HEADER_OMIT_ENGINE_MASK		0x1
 #define REGDUMP_HEADER_ENGINE_SHIFT		31
@@ -7771,6 +7779,7 @@ static u32 qed_calc_regdump_header(struct qed_dev *cdev,
 			  feature, feature_size);
 
 	SET_FIELD(res, REGDUMP_HEADER_FEATURE, feature);
+	SET_FIELD(res, REGDUMP_HEADER_BIN_DUMP, 1);
 	SET_FIELD(res, REGDUMP_HEADER_OMIT_ENGINE, omit_engine);
 	SET_FIELD(res, REGDUMP_HEADER_ENGINE, engine);
 
@@ -7794,6 +7803,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		omit_engine = 1;
 
 	mutex_lock(&qed_dbg_lock);
+	cdev->dbg_bin_dump = true;
 
 	org_engine = qed_get_debug_engine(cdev);
 	for (cur_engine = 0; cur_engine < cdev->num_hwfns; cur_engine++) {
@@ -7993,6 +8003,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		       QED_NVM_IMAGE_MDUMP, "QED_NVM_IMAGE_MDUMP", rc);
 	}
 
+	cdev->dbg_bin_dump = false;
 	mutex_unlock(&qed_dbg_lock);
 
 	return 0;
-- 
2.25.1

