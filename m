Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9303C443A2
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392242AbfFMQa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:30:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730898AbfFMIbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:31:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8UDEV017730;
        Thu, 13 Jun 2019 01:31:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=iLDH2sMmw+v/25k+r44yQi2k/6wkQwUVK8NAFpYxe7M=;
 b=hu8Jz3vzrCyeoXPlWrGY3egcZ+mE1IR7FX2GyXtsrgBPeF/1V6aazpcceJsWbNlRczqZ
 tGm4bCUAtf5iV5Gzyo2g9/KJZK+PeSpjVQuJ1EfsKusNIkRM5m2wyOYBSlujgO9i9tv7
 C3rzzRedDKQPOHDaEBjWN4g2zsVZTMlTDg5r7YC7IjCiAy4jm4xzy8muful6BcvXYR+d
 v85strrSkKCxNBioC7ShiUD/4kiT761SDZg+vqq/tV/bWQAVf9nwf9xP8sOOa2X2vLGH
 TvIiwr5UAY/ENZzpOmAp/cBkmrEURALNhjn8lMAsptNVSgMaBosaEbPt6paeH6BGCx8Y 1w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t3hvpr8dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:31:06 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:31:04 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:31:04 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id AAF343F7040;
        Thu, 13 Jun 2019 01:31:03 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/4] qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state
Date:   Thu, 13 Jun 2019 11:29:40 +0300
Message-ID: <20190613082943.5859-2-michal.kalderon@marvell.com>
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

Destroy QP waits for it's ep object state to be set to CLOSED
before proceeding. ep->state can be updated from a different
context. Add smp_store_release/READ_ONCE to synchronize.

Fixes: fc4c6065e661 ("qed: iWARP implement disconnect flows")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 7c71ea15251f..4c69adb0b535 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -532,7 +532,8 @@ int qed_iwarp_destroy_qp(struct qed_hwfn *p_hwfn, struct qed_rdma_qp *qp)
 
 	/* Make sure ep is closed before returning and freeing memory. */
 	if (ep) {
-		while (ep->state != QED_IWARP_EP_CLOSED && wait_count++ < 200)
+		while (READ_ONCE(ep->state) != QED_IWARP_EP_CLOSED &&
+		       wait_count++ < 200)
 			msleep(100);
 
 		if (ep->state != QED_IWARP_EP_CLOSED)
@@ -1022,8 +1023,6 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 
 	params.ep_context = ep;
 
-	ep->state = QED_IWARP_EP_CLOSED;
-
 	switch (fw_return_code) {
 	case RDMA_RETURN_OK:
 		ep->qp->max_rd_atomic_req = ep->cm_info.ord;
@@ -1083,6 +1082,10 @@ qed_iwarp_mpa_complete(struct qed_hwfn *p_hwfn,
 		break;
 	}
 
+	if (fw_return_code != RDMA_RETURN_OK)
+		/* paired with READ_ONCE in destroy_qp */
+		smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	ep->event_cb(ep->cb_context, &params);
 
 	/* on passive side, if there is no associated QP (REJECT) we need to
@@ -2825,7 +2828,9 @@ static void qed_iwarp_qp_in_error(struct qed_hwfn *p_hwfn,
 	params.status = (fw_return_code == IWARP_QP_IN_ERROR_GOOD_CLOSE) ?
 			 0 : -ECONNRESET;
 
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
+
 	spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 	list_del(&ep->list_entry);
 	spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
@@ -2914,7 +2919,8 @@ qed_iwarp_tcp_connect_unsuccessful(struct qed_hwfn *p_hwfn,
 	params.event = QED_IWARP_EVENT_ACTIVE_COMPLETE;
 	params.ep_context = ep;
 	params.cm_info = &ep->cm_info;
-	ep->state = QED_IWARP_EP_CLOSED;
+	/* paired with READ_ONCE in destroy_qp */
+	smp_store_release(&ep->state, QED_IWARP_EP_CLOSED);
 
 	switch (fw_return_code) {
 	case IWARP_CONN_ERROR_TCP_CONNECT_INVALID_PACKET:
-- 
2.14.5

