Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56EF443A0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732899AbfFMQa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:30:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40434 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730902AbfFMIbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:31:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8UIeH017745;
        Thu, 13 Jun 2019 01:31:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hHYa/ThrQL4PyjRo0DocnuHG9NoBe/NPDOG8BsJmqWk=;
 b=GlH0WmzUrQw/IJnSxMmP2Na4r8EXFCX4e+KY0/znptJnGf+4RW+Q9l0NvCYzR6Bmlb0J
 paIs7qFgoFePMbzvQkFgNs0UxgvqQNzVy+oBhRbgLvbXZtdDC9tbWqqAeUGKf1PKKHWO
 GSWfO6nH3/vssHBaTKf8rMg4Mk+a7RFuhfKSQgPXn3VL0BCcRwJsDcMnDLl5RsYzQ9wU
 uXqKSgj8OHC9fcqWqUvqv2jbW78JZQfPsZrVhh1262z2vikZ2Ke/N6WA7arlvjdfqtbi
 R424GaIsNLcww+wdIdgesGt7+6Jm9gxzCz8DgV4DmwsV5a5mUIlW/LzuKPUrTDxCLDWL 6g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t3hvpr8dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:31:10 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:31:09 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:31:09 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 0CAE03F7040;
        Thu, 13 Jun 2019 01:31:07 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 4/4] qed: iWARP - Fix default window size to be based on chip
Date:   Thu, 13 Jun 2019 11:29:43 +0300
Message-ID: <20190613082943.5859-5-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190613082943.5859-1-michal.kalderon@marvell.com>
References: <20190613082943.5859-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default window size is calculated for best performance based
on internal hw buffer sizes. The size differs between the
different chips and modes.

Fixes: 67b40dccc45f ("qed: Implement iWARP initialization, teardown and qp operations")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 30 ++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 431688c236ed..f380fae8799d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -63,7 +63,12 @@ struct mpa_v2_hdr {
 #define MPA_REV2(_mpa_rev) ((_mpa_rev) == MPA_NEGOTIATION_TYPE_ENHANCED)
 
 #define QED_IWARP_INVALID_TCP_CID	0xffffffff
-#define QED_IWARP_RCV_WND_SIZE_DEF	(256 * 1024)
+
+#define QED_IWARP_RCV_WND_SIZE_DEF_BB_2P (200 * 1024)
+#define QED_IWARP_RCV_WND_SIZE_DEF_BB_4P (100 * 1024)
+#define QED_IWARP_RCV_WND_SIZE_DEF_AH_2P (150 * 1024)
+#define QED_IWARP_RCV_WND_SIZE_DEF_AH_4P (90 * 1024)
+
 #define QED_IWARP_RCV_WND_SIZE_MIN	(0xffff)
 #define TIMESTAMP_HEADER_SIZE		(12)
 #define QED_IWARP_MAX_FIN_RT_DEFAULT	(2)
@@ -2612,7 +2617,8 @@ qed_iwarp_ll2_alloc_buffers(struct qed_hwfn *p_hwfn,
 
 static int
 qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
-		    struct qed_rdma_start_in_params *params)
+		    struct qed_rdma_start_in_params *params,
+		    u32 rcv_wnd_size)
 {
 	struct qed_iwarp_info *iwarp_info;
 	struct qed_ll2_acquire_data data;
@@ -2679,7 +2685,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	data.input.conn_type = QED_LL2_TYPE_OOO;
 	data.input.mtu = params->max_mtu;
 
-	n_ooo_bufs = (QED_IWARP_MAX_OOO * QED_IWARP_RCV_WND_SIZE_DEF) /
+	n_ooo_bufs = (QED_IWARP_MAX_OOO * rcv_wnd_size) /
 		     iwarp_info->max_mtu;
 	n_ooo_bufs = min_t(u32, n_ooo_bufs, QED_IWARP_LL2_OOO_MAX_RX_SIZE);
 
@@ -2768,16 +2774,30 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
+static struct {
+	u32 two_ports;
+	u32 four_ports;
+} qed_iwarp_rcv_wnd_size[MAX_CHIP_IDS] = {
+	{QED_IWARP_RCV_WND_SIZE_DEF_BB_2P, QED_IWARP_RCV_WND_SIZE_DEF_BB_4P},
+	{QED_IWARP_RCV_WND_SIZE_DEF_AH_2P, QED_IWARP_RCV_WND_SIZE_DEF_AH_4P}
+};
+
 int qed_iwarp_setup(struct qed_hwfn *p_hwfn,
 		    struct qed_rdma_start_in_params *params)
 {
+	struct qed_dev *cdev = p_hwfn->cdev;
 	struct qed_iwarp_info *iwarp_info;
+	enum chip_ids chip_id;
 	u32 rcv_wnd_size;
 
 	iwarp_info = &p_hwfn->p_rdma_info->iwarp;
 
 	iwarp_info->tcp_flags = QED_IWARP_TS_EN;
-	rcv_wnd_size = QED_IWARP_RCV_WND_SIZE_DEF;
+
+	chip_id = QED_IS_BB(cdev) ? CHIP_BB : CHIP_K2;
+	rcv_wnd_size = (qed_device_num_ports(cdev) == 4) ?
+		qed_iwarp_rcv_wnd_size[chip_id].four_ports :
+		qed_iwarp_rcv_wnd_size[chip_id].two_ports;
 
 	/* value 0 is used for ilog2(QED_IWARP_RCV_WND_SIZE_MIN) */
 	iwarp_info->rcv_wnd_scale = ilog2(rcv_wnd_size) -
@@ -2800,7 +2820,7 @@ int qed_iwarp_setup(struct qed_hwfn *p_hwfn,
 				  qed_iwarp_async_event);
 	qed_ooo_setup(p_hwfn);
 
-	return qed_iwarp_ll2_start(p_hwfn, params);
+	return qed_iwarp_ll2_start(p_hwfn, params, rcv_wnd_size);
 }
 
 int qed_iwarp_stop(struct qed_hwfn *p_hwfn)
-- 
2.14.5

