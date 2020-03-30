Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA42819748A
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgC3Gat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:30:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728065AbgC3Gar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:30:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6PEHl016756;
        Sun, 29 Mar 2020 23:30:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=aquEnToZsWMQZdaaH5Ow2eN8zxiSdlMVIuuTyRL8K0I=;
 b=s1CcfoZpNGNQ2sAm1+g7r95byzERwbLNZhUwQTN5BT368kwQEN0+lGYeR96lxwb0iRsi
 CAQAYjah8cFBp2nAWtLuVeUKV33FjjwZ/qa9sQOZDJVciXlylHYxWV1tPqM+BMD8WJ76
 cqlhrF/xL7qSwTvBmJHD67Wq832/ZcdgLLETpmtNp5LcIRigju06ZOqz3aurKWoPV+g3
 jI/ZsODL4APHct5e3cW3D0pIwd4D6yaiMxBLZhdHVQeOBtQgRBeY7LnFdA5kLUB0viRp
 ET+gtpXgS6sSxW6FK5wVWMPnAdnRBRjVAFFxGUGA17ntSeHiNcHfSst5mlhihMWn/5X+ sQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xnwda7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:30:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:45 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:44 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:30:44 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8D0823F703F;
        Sun, 29 Mar 2020 23:30:44 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6UiIJ027356;
        Sun, 29 Mar 2020 23:30:44 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6UiUE027355;
        Sun, 29 Mar 2020 23:30:44 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 3/8] qed: Send BW update notifications to the protocol drivers.
Date:   Sun, 29 Mar 2020 23:30:29 -0700
Message-ID: <20200330063034.27309-4-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

Management firmware (MFW) send a notification whenever there is a change in
the bandwidth values. The patch adds driver support to send this info to
the upper layer drivers (e.g., qedf).

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      | 1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c | 9 +++++++++
 include/linux/qed/qed_if.h                 | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index fa41bf0..d006639 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -1016,6 +1016,7 @@ void qed_set_fw_mac_addr(__le16 *fw_msb,
 int qed_fill_dev_info(struct qed_dev *cdev,
 		      struct qed_dev_info *dev_info);
 void qed_link_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt);
+void qed_bw_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt);
 u32 qed_unzip_data(struct qed_hwfn *p_hwfn,
 		   u32 input_len, u8 *input_buf,
 		   u32 max_size, u8 *unzip_buf);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2c189c6..8d82d65 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1949,6 +1949,15 @@ void qed_link_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt)
 		op->link_update(cookie, &if_link);
 }
 
+void qed_bw_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt)
+{
+	void *cookie = hwfn->cdev->ops_cookie;
+	struct qed_common_cb_ops *op = hwfn->cdev->protocol_ops.common;
+
+	if (IS_LEAD_HWFN(hwfn) && cookie && op && op->bw_update)
+		op->bw_update(cookie);
+}
+
 static int qed_drain(struct qed_dev *cdev)
 {
 	struct qed_hwfn *hwfn;
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 8f29e0d..c495637 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -817,6 +817,7 @@ struct qed_common_cb_ops {
 	void	(*dcbx_aen)(void *dev, struct qed_dcbx_get *get, u32 mib_type);
 	void (*get_generic_tlv_data)(void *dev, struct qed_generic_tlvs *data);
 	void (*get_protocol_tlv_data)(void *dev, void *data);
+	void (*bw_update)(void *dev);
 };
 
 struct qed_selftest_ops {
-- 
1.8.3.1

