Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3257C41C48C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbhI2MR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:17:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4004 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343751AbhI2MQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:16:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T8dZqA008043;
        Wed, 29 Sep 2021 05:13:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+9YvhzItDfSK5wOzS4fBgZixP9azi6TNNRMNoG3TlSI=;
 b=W874V5vxJ32873zixCZy7J+i7AN0Y996utXVEy4MM4oYeEY6R7qJpBsyN8cyo6HpaOqi
 qZI3q80sDfJOMaNkbABJ8DJygiSohOsdrW5FrcvJq4vbvAeE91tSAvgvWjlNV+G8U731
 zzqm43AiOT1BQhrkC9Of2OM5p+H5ojTaG90se6tTwgv0iZ6Dcc2elUG08Ccrbmy1vojr
 v3OpfRLOO6RK9ZfZoh+12dfJJSa1JtjEOkBJ/e4kSHFLKMmqcANSqjOmyZkDpjLd3tKz
 8kOXefIWX3mNLakqQA1KzRgnWqcW/umN5DTdDyBBhGXPDFzOnt+X7SbtseZdD9afY7oH nA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bcfd4a0bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 05:13:11 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 05:13:09 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 29 Sep 2021 05:13:06 -0700
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <aelior@marvell.com>,
        <smalin@marvell.com>, <jhasan@marvell.com>,
        <mrangankar@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        Nikolay Assa <nassa@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>
Subject: [PATCH 10/12] qed: Update TCP silly-window-syndrome timeout for iwarp, scsi
Date:   Wed, 29 Sep 2021 15:12:13 +0300
Message-ID: <20210929121215.17864-11-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210929121215.17864-1-pkushwaha@marvell.com>
References: <20210929121215.17864-1-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Cw2539Yqpky_Spp4D3BdV0_NBV5Qrq60
X-Proofpoint-ORIG-GUID: Cw2539Yqpky_Spp4D3BdV0_NBV5Qrq60
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_05,2021-09-29_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Assa <nassa@marvell.com>

Update TCP silly-window-syndrome timeout, for the cases where
initiator's small TCP window size prevents FW from transmitting
packets on the connection. Timeout causes FW to retransmit
window probes if needed, preventing I/O stall if initiator ignores
first window probe.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nikolay Assa <nassa@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 1 +
 drivers/scsi/qedi/qedi_main.c               | 1 +
 include/linux/qed/qed_if.h                  | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 186d0048a9d1..b2c0e522e51f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -114,6 +114,7 @@ qed_iwarp_init_fw_ramrod(struct qed_hwfn *p_hwfn,
 	    RESC_START(p_hwfn, QED_LL2_RAM_QUEUE) +
 	    p_hwfn->p_rdma_info->iwarp.ll2_ooo_handle;
 
+	p_ramrod->tcp.tx_sws_timer = cpu_to_le16(QED_TX_SWS_TIMER_DFLT);
 	p_ramrod->tcp.max_fin_rt = QED_IWARP_MAX_FIN_RT_DEFAULT;
 
 	return;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index fe36ddb82aef..8c2f32655424 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -866,6 +866,7 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	qedi->pf_params.iscsi_pf_params.num_queues = qedi->num_queues;
 	qedi->pf_params.iscsi_pf_params.debug_mode = qedi_fw_debug;
 	qedi->pf_params.iscsi_pf_params.two_msl_timer = 4000;
+	qedi->pf_params.iscsi_pf_params.tx_sws_timer = QED_TX_SWS_TIMER_DFLT;
 	qedi->pf_params.iscsi_pf_params.max_fin_rt = 2;
 
 	for (log_page_size = 0 ; log_page_size < 32 ; log_page_size++) {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index fb3aa4c56939..829cbc148a67 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -24,6 +24,8 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <net/devlink.h>
 
+#define QED_TX_SWS_TIMER_DFLT  500
+
 enum dcbx_protocol_type {
 	DCBX_PROTOCOL_ISCSI,
 	DCBX_PROTOCOL_FCOE,
-- 
2.24.1

