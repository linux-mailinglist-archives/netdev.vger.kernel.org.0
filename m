Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9E1E1B98
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 08:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgEZG4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 02:56:42 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727873AbgEZG4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 02:56:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04Q6uJAa010778;
        Mon, 25 May 2020 23:56:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=PZZ6yLmRgwYHiqWBYqcT0+ykcV30uS1VN1LfGXot3d0=;
 b=GdGW8qxitvPLaMKWQaQ64zYfMoCZ02KrtO8OLIu3xTBVOFVHaAJwZoINbHgxXyyMPv9j
 QyGzbFA2hD/IIjaEpSG5+B9et1a6dRTA7yAGuhwfqYcue9qu77eAZn1ErxeIYxazpNFo
 TED/WoNCT23RPpTy0/GMV64DZjyFLf4B6GjyD+2MYRdrEHrR2438X2BuqPtdkh/nvpzz
 D5GIvZxT6piudytu8CLMDU/whQ4V9xiZX+xg+D+qtFDNgRI2cEVqKtlgjMMo7TmgjUIb
 RYn3GUHnZwRMhVSdXEE01oKuZ9YYqHRwrCxj86q7nKVxcq9LfVq0M74hoEjGA9WaaWCD +A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3173bnqgh0-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 May 2020 23:56:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 May
 2020 23:53:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 May 2020 23:53:15 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 502453F703F;
        Mon, 25 May 2020 23:53:14 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <davem@davemloft.net>, <michal.kalderon@marvell.com>,
        <yuval.bason@marvell.com>, <ariel.elior@marvell.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next] qed: Add EDPM mode type for user-fw compatibility
Date:   Tue, 26 May 2020 09:41:20 +0300
Message-ID: <20200526064120.750-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-25_12:2020-05-25,2020-05-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <yuval.bason@marvell.com>

In older FW versions the completion flag was treated as the ack flag in
edpm messages. Expose the FW option of setting which mode the QP is in
by adding a flag to the qedr <-> qed API.

Flag is added for backward compatibility with libqedr.
This flag will be set by qedr after determining whether the libqedr is
using the updated version.

Fixes: f10939403352 ("qed: Add support for QP verbs")
Signed-off-by: Yuval Basson <yuval.bason@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 1 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.h | 1 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c | 3 +++
 include/linux/qed/qed_rdma_if.h            | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 50985871cd3d..98455f698f53 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1378,6 +1378,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 		rc = qed_iwarp_create_qp(p_hwfn, qp, out_params);
 		qp->qpid = qp->icid;
 	} else {
+		qp->edpm_mode = GET_FIELD(in_params->flags, QED_ROCE_EDPM_MODE);
 		rc = qed_roce_alloc_cid(p_hwfn, &qp->icid);
 		qp->qpid = ((0xFF << 16) | qp->icid);
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.h b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
index 5a7ebc764bb6..3898cae61e7a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
@@ -183,6 +183,7 @@ struct qed_rdma_qp {
 	void *shared_queue;
 	dma_addr_t shared_queue_phys_addr;
 	struct qed_iwarp_ep *ep;
+	u8 edpm_mode;
 };
 
 static inline bool qed_rdma_is_xrc_qp(struct qed_rdma_qp *qp)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 46a4d09eacef..4566815f7b87 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -459,6 +459,9 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 		  ROCE_CREATE_QP_REQ_RAMROD_DATA_XRC_FLAG,
 		  qed_rdma_is_xrc_qp(qp));
 
+	SET_FIELD(p_ramrod->flags2,
+		  ROCE_CREATE_QP_REQ_RAMROD_DATA_EDPM_MODE, qp->edpm_mode);
+
 	p_ramrod->max_ord = qp->max_rd_atomic_req;
 	p_ramrod->traffic_class = qp->traffic_class_tos;
 	p_ramrod->hop_limit = qp->hop_limit_ttl;
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index f93edd5750a5..584077565f12 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -335,6 +335,9 @@ struct qed_rdma_create_qp_in_params {
 	u16 xrcd_id;
 	u8 stats_queue;
 	enum qed_rdma_qp_type qp_type;
+	u8 flags;
+#define QED_ROCE_EDPM_MODE_MASK      0x1
+#define QED_ROCE_EDPM_MODE_SHIFT     0
 };
 
 struct qed_rdma_create_qp_out_params {
-- 
2.14.5

