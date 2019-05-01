Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40427106C2
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfEAJ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33762 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725959AbfEAJ6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419uLun027319;
        Wed, 1 May 2019 02:58:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=heyblr7VB09fxwxhNhlMOFoJ7QQiLyPxcghtGGRA0NY=;
 b=IuYnrQVC/6xqDGODr275A81xsE6lft58wtX35PbFy0FW/iD9mSlfpBeZ1+LRth1Nn4da
 BmIkbsG5XgNvUyRM6/LdGNxbZx9U/q9v9gJVcgNUK+4pFC6+LCMwLOWW4d+IWN9/qKRq
 CrAHd/gOlBWhilcvxkEUv37RsbDnc4DTZaHvDKeIOJX1dvRlFcM2dQxLXQjyXXihhhD2
 MjdKRlkeyNxvUc7W8OE5ovlgMiD7zi/woQz8S6yMVcfExeenv3uSUOZ4hyJaqaWlVpdQ
 eW0fYxYHPCLAJZmrDMOCE2uMIM73b+QDYYHQtRdA75HcVqyEk0Tfa7GPjseVGGbkuKI9 LA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2s6xj61wpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:38 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:38 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:38 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 0489C3F7043;
        Wed,  1 May 2019 02:58:35 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 04/10] qed: Modify offload protocols to use the affined engine
Date:   Wed, 1 May 2019 12:57:16 +0300
Message-ID: <20190501095722.6902-5-michal.kalderon@marvell.com>
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

To enable 100g support for offload protocols each PF gets
a dedicated engine to work on from the MFW.
This patch modifies the code to use the affined hwfn instead
of the leading one.
The offload protocols require the ll2 to be opened on both
engines, and not just the affined hwfn.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c  |  26 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c |  35 ++-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c   | 378 +++++++++++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c  |  23 +-
 4 files changed, 273 insertions(+), 189 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
index 46dc93d3b9b5..de31a382f58e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
@@ -745,7 +745,7 @@ struct qed_hash_fcoe_con {
 static int qed_fill_fcoe_dev_info(struct qed_dev *cdev,
 				  struct qed_dev_fcoe_info *info)
 {
-	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_hwfn *hwfn = QED_AFFIN_HWFN(cdev);
 	int rc;
 
 	memset(info, 0, sizeof(*info));
@@ -806,15 +806,15 @@ static int qed_fcoe_stop(struct qed_dev *cdev)
 		return -EINVAL;
 	}
 
-	p_ptt = qed_ptt_acquire(QED_LEADING_HWFN(cdev));
+	p_ptt = qed_ptt_acquire(QED_AFFIN_HWFN(cdev));
 	if (!p_ptt)
 		return -EAGAIN;
 
 	/* Stop the fcoe */
-	rc = qed_sp_fcoe_func_stop(QED_LEADING_HWFN(cdev), p_ptt,
+	rc = qed_sp_fcoe_func_stop(QED_AFFIN_HWFN(cdev), p_ptt,
 				   QED_SPQ_MODE_EBLOCK, NULL);
 	cdev->flags &= ~QED_FLAG_STORAGE_STARTED;
-	qed_ptt_release(QED_LEADING_HWFN(cdev), p_ptt);
+	qed_ptt_release(QED_AFFIN_HWFN(cdev), p_ptt);
 
 	return rc;
 }
@@ -828,8 +828,8 @@ static int qed_fcoe_start(struct qed_dev *cdev, struct qed_fcoe_tid *tasks)
 		return 0;
 	}
 
-	rc = qed_sp_fcoe_func_start(QED_LEADING_HWFN(cdev),
-				    QED_SPQ_MODE_EBLOCK, NULL);
+	rc = qed_sp_fcoe_func_start(QED_AFFIN_HWFN(cdev), QED_SPQ_MODE_EBLOCK,
+				    NULL);
 	if (rc) {
 		DP_NOTICE(cdev, "Failed to start fcoe\n");
 		return rc;
@@ -849,7 +849,7 @@ static int qed_fcoe_start(struct qed_dev *cdev, struct qed_fcoe_tid *tasks)
 			return -ENOMEM;
 		}
 
-		rc = qed_cxt_get_tid_mem_info(QED_LEADING_HWFN(cdev), tid_info);
+		rc = qed_cxt_get_tid_mem_info(QED_AFFIN_HWFN(cdev), tid_info);
 		if (rc) {
 			DP_NOTICE(cdev, "Failed to gather task information\n");
 			qed_fcoe_stop(cdev);
@@ -884,7 +884,7 @@ static int qed_fcoe_acquire_conn(struct qed_dev *cdev,
 	}
 
 	/* Acquire the connection */
-	rc = qed_fcoe_acquire_connection(QED_LEADING_HWFN(cdev), NULL,
+	rc = qed_fcoe_acquire_connection(QED_AFFIN_HWFN(cdev), NULL,
 					 &hash_con->con);
 	if (rc) {
 		DP_NOTICE(cdev, "Failed to acquire Connection\n");
@@ -898,7 +898,7 @@ static int qed_fcoe_acquire_conn(struct qed_dev *cdev,
 	hash_add(cdev->connections, &hash_con->node, *handle);
 
 	if (p_doorbell)
-		*p_doorbell = qed_fcoe_get_db_addr(QED_LEADING_HWFN(cdev),
+		*p_doorbell = qed_fcoe_get_db_addr(QED_AFFIN_HWFN(cdev),
 						   *handle);
 
 	return 0;
@@ -916,7 +916,7 @@ static int qed_fcoe_release_conn(struct qed_dev *cdev, u32 handle)
 	}
 
 	hlist_del(&hash_con->node);
-	qed_fcoe_release_connection(QED_LEADING_HWFN(cdev), hash_con->con);
+	qed_fcoe_release_connection(QED_AFFIN_HWFN(cdev), hash_con->con);
 	kfree(hash_con);
 
 	return 0;
@@ -971,7 +971,7 @@ static int qed_fcoe_offload_conn(struct qed_dev *cdev,
 	con->d_id.addr_mid = conn_info->d_id.addr_mid;
 	con->d_id.addr_lo = conn_info->d_id.addr_lo;
 
-	return qed_sp_fcoe_conn_offload(QED_LEADING_HWFN(cdev), con,
+	return qed_sp_fcoe_conn_offload(QED_AFFIN_HWFN(cdev), con,
 					QED_SPQ_MODE_EBLOCK, NULL);
 }
 
@@ -992,13 +992,13 @@ static int qed_fcoe_destroy_conn(struct qed_dev *cdev,
 	con = hash_con->con;
 	con->terminate_params = terminate_params;
 
-	return qed_sp_fcoe_conn_destroy(QED_LEADING_HWFN(cdev), con,
+	return qed_sp_fcoe_conn_destroy(QED_AFFIN_HWFN(cdev), con,
 					QED_SPQ_MODE_EBLOCK, NULL);
 }
 
 static int qed_fcoe_stats(struct qed_dev *cdev, struct qed_fcoe_stats *stats)
 {
-	return qed_fcoe_get_stats(QED_LEADING_HWFN(cdev), stats);
+	return qed_fcoe_get_stats(QED_AFFIN_HWFN(cdev), stats);
 }
 
 void qed_get_protocol_stats_fcoe(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 4f8a685d1a55..5585c18053ec 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -1082,7 +1082,7 @@ struct qed_hash_iscsi_con {
 static int qed_fill_iscsi_dev_info(struct qed_dev *cdev,
 				   struct qed_dev_iscsi_info *info)
 {
-	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_hwfn *hwfn = QED_AFFIN_HWFN(cdev);
 
 	int rc;
 
@@ -1141,8 +1141,8 @@ static int qed_iscsi_stop(struct qed_dev *cdev)
 	}
 
 	/* Stop the iscsi */
-	rc = qed_sp_iscsi_func_stop(QED_LEADING_HWFN(cdev),
-				    QED_SPQ_MODE_EBLOCK, NULL);
+	rc = qed_sp_iscsi_func_stop(QED_AFFIN_HWFN(cdev), QED_SPQ_MODE_EBLOCK,
+				    NULL);
 	cdev->flags &= ~QED_FLAG_STORAGE_STARTED;
 
 	return rc;
@@ -1161,9 +1161,8 @@ static int qed_iscsi_start(struct qed_dev *cdev,
 		return 0;
 	}
 
-	rc = qed_sp_iscsi_func_start(QED_LEADING_HWFN(cdev),
-				     QED_SPQ_MODE_EBLOCK, NULL, event_context,
-				     async_event_cb);
+	rc = qed_sp_iscsi_func_start(QED_AFFIN_HWFN(cdev), QED_SPQ_MODE_EBLOCK,
+				     NULL, event_context, async_event_cb);
 	if (rc) {
 		DP_NOTICE(cdev, "Failed to start iscsi\n");
 		return rc;
@@ -1182,8 +1181,7 @@ static int qed_iscsi_start(struct qed_dev *cdev,
 		return -ENOMEM;
 	}
 
-	rc = qed_cxt_get_tid_mem_info(QED_LEADING_HWFN(cdev),
-				      tid_info);
+	rc = qed_cxt_get_tid_mem_info(QED_AFFIN_HWFN(cdev), tid_info);
 	if (rc) {
 		DP_NOTICE(cdev, "Failed to gather task information\n");
 		qed_iscsi_stop(cdev);
@@ -1215,7 +1213,7 @@ static int qed_iscsi_acquire_conn(struct qed_dev *cdev,
 		return -ENOMEM;
 
 	/* Acquire the connection */
-	rc = qed_iscsi_acquire_connection(QED_LEADING_HWFN(cdev), NULL,
+	rc = qed_iscsi_acquire_connection(QED_AFFIN_HWFN(cdev), NULL,
 					  &hash_con->con);
 	if (rc) {
 		DP_NOTICE(cdev, "Failed to acquire Connection\n");
@@ -1229,7 +1227,7 @@ static int qed_iscsi_acquire_conn(struct qed_dev *cdev,
 	hash_add(cdev->connections, &hash_con->node, *handle);
 
 	if (p_doorbell)
-		*p_doorbell = qed_iscsi_get_db_addr(QED_LEADING_HWFN(cdev),
+		*p_doorbell = qed_iscsi_get_db_addr(QED_AFFIN_HWFN(cdev),
 						    *handle);
 
 	return 0;
@@ -1247,7 +1245,7 @@ static int qed_iscsi_release_conn(struct qed_dev *cdev, u32 handle)
 	}
 
 	hlist_del(&hash_con->node);
-	qed_iscsi_release_connection(QED_LEADING_HWFN(cdev), hash_con->con);
+	qed_iscsi_release_connection(QED_AFFIN_HWFN(cdev), hash_con->con);
 	kfree(hash_con);
 
 	return 0;
@@ -1324,7 +1322,7 @@ static int qed_iscsi_offload_conn(struct qed_dev *cdev,
 	/* Set default values on other connection fields */
 	con->offl_flags = 0x1;
 
-	return qed_sp_iscsi_conn_offload(QED_LEADING_HWFN(cdev), con,
+	return qed_sp_iscsi_conn_offload(QED_AFFIN_HWFN(cdev), con,
 					 QED_SPQ_MODE_EBLOCK, NULL);
 }
 
@@ -1351,7 +1349,7 @@ static int qed_iscsi_update_conn(struct qed_dev *cdev,
 	con->first_seq_length = conn_info->first_seq_length;
 	con->exp_stat_sn = conn_info->exp_stat_sn;
 
-	return qed_sp_iscsi_conn_update(QED_LEADING_HWFN(cdev), con,
+	return qed_sp_iscsi_conn_update(QED_AFFIN_HWFN(cdev), con,
 					QED_SPQ_MODE_EBLOCK, NULL);
 }
 
@@ -1366,8 +1364,7 @@ static int qed_iscsi_clear_conn_sq(struct qed_dev *cdev, u32 handle)
 		return -EINVAL;
 	}
 
-	return qed_sp_iscsi_conn_clear_sq(QED_LEADING_HWFN(cdev),
-					  hash_con->con,
+	return qed_sp_iscsi_conn_clear_sq(QED_AFFIN_HWFN(cdev), hash_con->con,
 					  QED_SPQ_MODE_EBLOCK, NULL);
 }
 
@@ -1385,14 +1382,13 @@ static int qed_iscsi_destroy_conn(struct qed_dev *cdev,
 
 	hash_con->con->abortive_dsconnect = abrt_conn;
 
-	return qed_sp_iscsi_conn_terminate(QED_LEADING_HWFN(cdev),
-					   hash_con->con,
+	return qed_sp_iscsi_conn_terminate(QED_AFFIN_HWFN(cdev), hash_con->con,
 					   QED_SPQ_MODE_EBLOCK, NULL);
 }
 
 static int qed_iscsi_stats(struct qed_dev *cdev, struct qed_iscsi_stats *stats)
 {
-	return qed_iscsi_get_stats(QED_LEADING_HWFN(cdev), stats);
+	return qed_iscsi_get_stats(QED_AFFIN_HWFN(cdev), stats);
 }
 
 static int qed_iscsi_change_mac(struct qed_dev *cdev,
@@ -1407,8 +1403,7 @@ static int qed_iscsi_change_mac(struct qed_dev *cdev,
 		return -EINVAL;
 	}
 
-	return qed_sp_iscsi_mac_update(QED_LEADING_HWFN(cdev),
-				       hash_con->con,
+	return qed_sp_iscsi_mac_update(QED_AFFIN_HWFN(cdev), hash_con->con,
 				       QED_SPQ_MODE_EBLOCK, NULL);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 922b7940c069..dcff69aa8613 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -239,9 +239,8 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
 	buffer->phys_addr = new_phys_addr;
 
 out_post:
-	rc = qed_ll2_post_rx_buffer(QED_LEADING_HWFN(cdev), cdev->ll2->handle,
-				    buffer->phys_addr, 0,  buffer, 1);
-
+	rc = qed_ll2_post_rx_buffer(p_hwfn, cdev->ll2->handle,
+				    buffer->phys_addr, 0, buffer, 1);
 	if (rc)
 		qed_ll2_dealloc_buffer(cdev, buffer);
 }
@@ -926,16 +925,15 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	return 0;
 }
 
-static void qed_ll2_stop_ooo(struct qed_dev *cdev)
+static void qed_ll2_stop_ooo(struct qed_hwfn *p_hwfn)
 {
-	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
-	u8 *handle = &hwfn->pf_params.iscsi_pf_params.ll2_ooo_queue_id;
+	u8 *handle = &p_hwfn->pf_params.iscsi_pf_params.ll2_ooo_queue_id;
 
-	DP_VERBOSE(cdev, QED_MSG_STORAGE, "Stopping LL2 OOO queue [%02x]\n",
-		   *handle);
+	DP_VERBOSE(p_hwfn, (QED_MSG_STORAGE | QED_MSG_LL2),
+		   "Stopping LL2 OOO queue [%02x]\n", *handle);
 
-	qed_ll2_terminate_connection(hwfn, *handle);
-	qed_ll2_release_connection(hwfn, *handle);
+	qed_ll2_terminate_connection(p_hwfn, *handle);
+	qed_ll2_release_connection(p_hwfn, *handle);
 	*handle = QED_LL2_UNUSED_HANDLE;
 }
 
@@ -2086,12 +2084,12 @@ static void _qed_ll2_get_port_stats(struct qed_hwfn *p_hwfn,
 			TSTORM_LL2_PORT_STAT_OFFSET(MFW_PORT(p_hwfn)),
 			sizeof(port_stats));
 
-	p_stats->gsi_invalid_hdr = HILO_64_REGPAIR(port_stats.gsi_invalid_hdr);
-	p_stats->gsi_invalid_pkt_length =
+	p_stats->gsi_invalid_hdr += HILO_64_REGPAIR(port_stats.gsi_invalid_hdr);
+	p_stats->gsi_invalid_pkt_length +=
 	    HILO_64_REGPAIR(port_stats.gsi_invalid_pkt_length);
-	p_stats->gsi_unsupported_pkt_typ =
+	p_stats->gsi_unsupported_pkt_typ +=
 	    HILO_64_REGPAIR(port_stats.gsi_unsupported_pkt_typ);
-	p_stats->gsi_crcchksm_error =
+	p_stats->gsi_crcchksm_error +=
 	    HILO_64_REGPAIR(port_stats.gsi_crcchksm_error);
 }
 
@@ -2109,9 +2107,9 @@ static void _qed_ll2_get_tstats(struct qed_hwfn *p_hwfn,
 		      CORE_LL2_TSTORM_PER_QUEUE_STAT_OFFSET(qid);
 	qed_memcpy_from(p_hwfn, p_ptt, &tstats, tstats_addr, sizeof(tstats));
 
-	p_stats->packet_too_big_discard =
+	p_stats->packet_too_big_discard +=
 			HILO_64_REGPAIR(tstats.packet_too_big_discard);
-	p_stats->no_buff_discard = HILO_64_REGPAIR(tstats.no_buff_discard);
+	p_stats->no_buff_discard += HILO_64_REGPAIR(tstats.no_buff_discard);
 }
 
 static void _qed_ll2_get_ustats(struct qed_hwfn *p_hwfn,
@@ -2128,12 +2126,12 @@ static void _qed_ll2_get_ustats(struct qed_hwfn *p_hwfn,
 		      CORE_LL2_USTORM_PER_QUEUE_STAT_OFFSET(qid);
 	qed_memcpy_from(p_hwfn, p_ptt, &ustats, ustats_addr, sizeof(ustats));
 
-	p_stats->rcv_ucast_bytes = HILO_64_REGPAIR(ustats.rcv_ucast_bytes);
-	p_stats->rcv_mcast_bytes = HILO_64_REGPAIR(ustats.rcv_mcast_bytes);
-	p_stats->rcv_bcast_bytes = HILO_64_REGPAIR(ustats.rcv_bcast_bytes);
-	p_stats->rcv_ucast_pkts = HILO_64_REGPAIR(ustats.rcv_ucast_pkts);
-	p_stats->rcv_mcast_pkts = HILO_64_REGPAIR(ustats.rcv_mcast_pkts);
-	p_stats->rcv_bcast_pkts = HILO_64_REGPAIR(ustats.rcv_bcast_pkts);
+	p_stats->rcv_ucast_bytes += HILO_64_REGPAIR(ustats.rcv_ucast_bytes);
+	p_stats->rcv_mcast_bytes += HILO_64_REGPAIR(ustats.rcv_mcast_bytes);
+	p_stats->rcv_bcast_bytes += HILO_64_REGPAIR(ustats.rcv_bcast_bytes);
+	p_stats->rcv_ucast_pkts += HILO_64_REGPAIR(ustats.rcv_ucast_pkts);
+	p_stats->rcv_mcast_pkts += HILO_64_REGPAIR(ustats.rcv_mcast_pkts);
+	p_stats->rcv_bcast_pkts += HILO_64_REGPAIR(ustats.rcv_bcast_pkts);
 }
 
 static void _qed_ll2_get_pstats(struct qed_hwfn *p_hwfn,
@@ -2150,23 +2148,21 @@ static void _qed_ll2_get_pstats(struct qed_hwfn *p_hwfn,
 		      CORE_LL2_PSTORM_PER_QUEUE_STAT_OFFSET(stats_id);
 	qed_memcpy_from(p_hwfn, p_ptt, &pstats, pstats_addr, sizeof(pstats));
 
-	p_stats->sent_ucast_bytes = HILO_64_REGPAIR(pstats.sent_ucast_bytes);
-	p_stats->sent_mcast_bytes = HILO_64_REGPAIR(pstats.sent_mcast_bytes);
-	p_stats->sent_bcast_bytes = HILO_64_REGPAIR(pstats.sent_bcast_bytes);
-	p_stats->sent_ucast_pkts = HILO_64_REGPAIR(pstats.sent_ucast_pkts);
-	p_stats->sent_mcast_pkts = HILO_64_REGPAIR(pstats.sent_mcast_pkts);
-	p_stats->sent_bcast_pkts = HILO_64_REGPAIR(pstats.sent_bcast_pkts);
+	p_stats->sent_ucast_bytes += HILO_64_REGPAIR(pstats.sent_ucast_bytes);
+	p_stats->sent_mcast_bytes += HILO_64_REGPAIR(pstats.sent_mcast_bytes);
+	p_stats->sent_bcast_bytes += HILO_64_REGPAIR(pstats.sent_bcast_bytes);
+	p_stats->sent_ucast_pkts += HILO_64_REGPAIR(pstats.sent_ucast_pkts);
+	p_stats->sent_mcast_pkts += HILO_64_REGPAIR(pstats.sent_mcast_pkts);
+	p_stats->sent_bcast_pkts += HILO_64_REGPAIR(pstats.sent_bcast_pkts);
 }
 
-int qed_ll2_get_stats(void *cxt,
-		      u8 connection_handle, struct qed_ll2_stats *p_stats)
+int __qed_ll2_get_stats(void *cxt,
+			u8 connection_handle, struct qed_ll2_stats *p_stats)
 {
 	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_ll2_info *p_ll2_conn = NULL;
 	struct qed_ptt *p_ptt;
 
-	memset(p_stats, 0, sizeof(*p_stats));
-
 	if ((connection_handle >= QED_MAX_NUM_OF_LL2_CONNECTIONS) ||
 	    !p_hwfn->p_ll2_info)
 		return -EINVAL;
@@ -2181,15 +2177,26 @@ int qed_ll2_get_stats(void *cxt,
 
 	if (p_ll2_conn->input.gsi_enable)
 		_qed_ll2_get_port_stats(p_hwfn, p_ptt, p_stats);
+
 	_qed_ll2_get_tstats(p_hwfn, p_ptt, p_ll2_conn, p_stats);
+
 	_qed_ll2_get_ustats(p_hwfn, p_ptt, p_ll2_conn, p_stats);
+
 	if (p_ll2_conn->tx_stats_en)
 		_qed_ll2_get_pstats(p_hwfn, p_ptt, p_ll2_conn, p_stats);
 
 	qed_ptt_release(p_hwfn, p_ptt);
+
 	return 0;
 }
 
+int qed_ll2_get_stats(void *cxt,
+		      u8 connection_handle, struct qed_ll2_stats *p_stats)
+{
+	memset(p_stats, 0, sizeof(*p_stats));
+	return __qed_ll2_get_stats(cxt, connection_handle, p_stats);
+}
+
 static void qed_ll2b_release_rx_packet(void *cxt,
 				       u8 connection_handle,
 				       void *cookie,
@@ -2216,7 +2223,7 @@ struct qed_ll2_cbs ll2_cbs = {
 	.tx_release_cb = &qed_ll2b_complete_tx_packet,
 };
 
-static void qed_ll2_set_conn_data(struct qed_dev *cdev,
+static void qed_ll2_set_conn_data(struct qed_hwfn *p_hwfn,
 				  struct qed_ll2_acquire_data *data,
 				  struct qed_ll2_params *params,
 				  enum qed_ll2_conn_type conn_type,
@@ -2232,7 +2239,7 @@ static void qed_ll2_set_conn_data(struct qed_dev *cdev,
 	data->input.tx_num_desc = QED_LL2_TX_SIZE;
 	data->p_connection_handle = handle;
 	data->cbs = &ll2_cbs;
-	ll2_cbs.cookie = QED_LEADING_HWFN(cdev);
+	ll2_cbs.cookie = p_hwfn;
 
 	if (lb) {
 		data->input.tx_tc = PKT_LB_TC;
@@ -2243,74 +2250,102 @@ static void qed_ll2_set_conn_data(struct qed_dev *cdev,
 	}
 }
 
-static int qed_ll2_start_ooo(struct qed_dev *cdev,
+static int qed_ll2_start_ooo(struct qed_hwfn *p_hwfn,
 			     struct qed_ll2_params *params)
 {
-	struct qed_hwfn *hwfn = QED_LEADING_HWFN(cdev);
-	u8 *handle = &hwfn->pf_params.iscsi_pf_params.ll2_ooo_queue_id;
+	u8 *handle = &p_hwfn->pf_params.iscsi_pf_params.ll2_ooo_queue_id;
 	struct qed_ll2_acquire_data data;
 	int rc;
 
-	qed_ll2_set_conn_data(cdev, &data, params,
+	qed_ll2_set_conn_data(p_hwfn, &data, params,
 			      QED_LL2_TYPE_OOO, handle, true);
 
-	rc = qed_ll2_acquire_connection(hwfn, &data);
+	rc = qed_ll2_acquire_connection(p_hwfn, &data);
 	if (rc) {
-		DP_INFO(cdev, "Failed to acquire LL2 OOO connection\n");
+		DP_INFO(p_hwfn, "Failed to acquire LL2 OOO connection\n");
 		goto out;
 	}
 
-	rc = qed_ll2_establish_connection(hwfn, *handle);
+	rc = qed_ll2_establish_connection(p_hwfn, *handle);
 	if (rc) {
-		DP_INFO(cdev, "Failed to establist LL2 OOO connection\n");
+		DP_INFO(p_hwfn, "Failed to establish LL2 OOO connection\n");
 		goto fail;
 	}
 
 	return 0;
 
 fail:
-	qed_ll2_release_connection(hwfn, *handle);
+	qed_ll2_release_connection(p_hwfn, *handle);
 out:
 	*handle = QED_LL2_UNUSED_HANDLE;
 	return rc;
 }
 
-static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
+static bool qed_ll2_is_storage_eng1(struct qed_dev *cdev)
 {
-	struct qed_ll2_buffer *buffer, *tmp_buffer;
-	enum qed_ll2_conn_type conn_type;
-	struct qed_ll2_acquire_data data;
-	struct qed_ptt *p_ptt;
-	int rc, i;
+	return (QED_IS_FCOE_PERSONALITY(QED_LEADING_HWFN(cdev)) ||
+		QED_IS_ISCSI_PERSONALITY(QED_LEADING_HWFN(cdev))) &&
+		(QED_AFFIN_HWFN(cdev) != QED_LEADING_HWFN(cdev));
+}
 
+static int __qed_ll2_stop(struct qed_hwfn *p_hwfn)
+{
+	struct qed_dev *cdev = p_hwfn->cdev;
+	int rc;
 
-	/* Initialize LL2 locks & lists */
-	INIT_LIST_HEAD(&cdev->ll2->list);
-	spin_lock_init(&cdev->ll2->lock);
-	cdev->ll2->rx_size = NET_SKB_PAD + ETH_HLEN +
-			     L1_CACHE_BYTES + params->mtu;
+	rc = qed_ll2_terminate_connection(p_hwfn, cdev->ll2->handle);
+	if (rc)
+		DP_INFO(cdev, "Failed to terminate LL2 connection\n");
 
-	/*Allocate memory for LL2 */
-	DP_INFO(cdev, "Allocating LL2 buffers of size %08x bytes\n",
-		cdev->ll2->rx_size);
-	for (i = 0; i < QED_LL2_RX_SIZE; i++) {
-		buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
-		if (!buffer) {
-			DP_INFO(cdev, "Failed to allocate LL2 buffers\n");
-			goto fail;
-		}
+	qed_ll2_release_connection(p_hwfn, cdev->ll2->handle);
 
-		rc = qed_ll2_alloc_buffer(cdev, (u8 **)&buffer->data,
-					  &buffer->phys_addr);
-		if (rc) {
-			kfree(buffer);
-			goto fail;
-		}
+	return rc;
+}
 
-		list_add_tail(&buffer->list, &cdev->ll2->list);
+static int qed_ll2_stop(struct qed_dev *cdev)
+{
+	bool b_is_storage_eng1 = qed_ll2_is_storage_eng1(cdev);
+	struct qed_hwfn *p_hwfn = QED_AFFIN_HWFN(cdev);
+	int rc = 0, rc2 = 0;
+
+	if (cdev->ll2->handle == QED_LL2_UNUSED_HANDLE)
+		return 0;
+
+	qed_llh_remove_mac_filter(cdev, 0, cdev->ll2_mac_address);
+	eth_zero_addr(cdev->ll2_mac_address);
+
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
+		qed_ll2_stop_ooo(p_hwfn);
+
+	/* In CMT mode, LL2 is always started on engine 0 for a storage PF */
+	if (b_is_storage_eng1) {
+		rc2 = __qed_ll2_stop(QED_LEADING_HWFN(cdev));
+		if (rc2)
+			DP_NOTICE(QED_LEADING_HWFN(cdev),
+				  "Failed to stop LL2 on engine 0\n");
 	}
 
-	switch (QED_LEADING_HWFN(cdev)->hw_info.personality) {
+	rc = __qed_ll2_stop(p_hwfn);
+	if (rc)
+		DP_NOTICE(p_hwfn, "Failed to stop LL2\n");
+
+	qed_ll2_kill_buffers(cdev);
+
+	cdev->ll2->handle = QED_LL2_UNUSED_HANDLE;
+
+	return rc | rc2;
+}
+
+static int __qed_ll2_start(struct qed_hwfn *p_hwfn,
+			   struct qed_ll2_params *params)
+{
+	struct qed_ll2_buffer *buffer, *tmp_buffer;
+	struct qed_dev *cdev = p_hwfn->cdev;
+	enum qed_ll2_conn_type conn_type;
+	struct qed_ll2_acquire_data data;
+	int rc, rx_cnt;
+
+	switch (p_hwfn->hw_info.personality) {
 	case QED_PCI_FCOE:
 		conn_type = QED_LL2_TYPE_FCOE;
 		break;
@@ -2321,33 +2356,34 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 		conn_type = QED_LL2_TYPE_ROCE;
 		break;
 	default:
+
 		conn_type = QED_LL2_TYPE_TEST;
 	}
 
-	qed_ll2_set_conn_data(cdev, &data, params, conn_type,
+	qed_ll2_set_conn_data(p_hwfn, &data, params, conn_type,
 			      &cdev->ll2->handle, false);
 
-	rc = qed_ll2_acquire_connection(QED_LEADING_HWFN(cdev), &data);
+	rc = qed_ll2_acquire_connection(p_hwfn, &data);
 	if (rc) {
-		DP_INFO(cdev, "Failed to acquire LL2 connection\n");
-		goto fail;
+		DP_INFO(p_hwfn, "Failed to acquire LL2 connection\n");
+		return rc;
 	}
 
-	rc = qed_ll2_establish_connection(QED_LEADING_HWFN(cdev),
-					  cdev->ll2->handle);
+	rc = qed_ll2_establish_connection(p_hwfn, cdev->ll2->handle);
 	if (rc) {
-		DP_INFO(cdev, "Failed to establish LL2 connection\n");
-		goto release_fail;
+		DP_INFO(p_hwfn, "Failed to establish LL2 connection\n");
+		goto release_conn;
 	}
 
 	/* Post all Rx buffers to FW */
 	spin_lock_bh(&cdev->ll2->lock);
+	rx_cnt = cdev->ll2->rx_cnt;
 	list_for_each_entry_safe(buffer, tmp_buffer, &cdev->ll2->list, list) {
-		rc = qed_ll2_post_rx_buffer(QED_LEADING_HWFN(cdev),
+		rc = qed_ll2_post_rx_buffer(p_hwfn,
 					    cdev->ll2->handle,
 					    buffer->phys_addr, 0, buffer, 1);
 		if (rc) {
-			DP_INFO(cdev,
+			DP_INFO(p_hwfn,
 				"Failed to post an Rx buffer; Deleting it\n");
 			dma_unmap_single(&cdev->pdev->dev, buffer->phys_addr,
 					 cdev->ll2->rx_size, DMA_FROM_DEVICE);
@@ -2355,96 +2391,127 @@ static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
 			list_del(&buffer->list);
 			kfree(buffer);
 		} else {
-			cdev->ll2->rx_cnt++;
+			rx_cnt++;
 		}
 	}
 	spin_unlock_bh(&cdev->ll2->lock);
 
-	if (!cdev->ll2->rx_cnt) {
-		DP_INFO(cdev, "Failed passing even a single Rx buffer\n");
-		goto release_terminate;
+	if (rx_cnt == cdev->ll2->rx_cnt) {
+		DP_NOTICE(p_hwfn, "Failed passing even a single Rx buffer\n");
+		goto terminate_conn;
 	}
+	cdev->ll2->rx_cnt = rx_cnt;
+
+	return 0;
+
+terminate_conn:
+	qed_ll2_terminate_connection(p_hwfn, cdev->ll2->handle);
+release_conn:
+	qed_ll2_release_connection(p_hwfn, cdev->ll2->handle);
+	return rc;
+}
+
+static int qed_ll2_start(struct qed_dev *cdev, struct qed_ll2_params *params)
+{
+	bool b_is_storage_eng1 = qed_ll2_is_storage_eng1(cdev);
+	struct qed_hwfn *p_hwfn = QED_AFFIN_HWFN(cdev);
+	struct qed_ll2_buffer *buffer;
+	int rx_num_desc, i, rc;
 
 	if (!is_valid_ether_addr(params->ll2_mac_address)) {
-		DP_INFO(cdev, "Invalid Ethernet address\n");
-		goto release_terminate;
+		DP_NOTICE(cdev, "Invalid Ethernet address\n");
+		return -EINVAL;
 	}
 
-	if (QED_LEADING_HWFN(cdev)->hw_info.personality == QED_PCI_ISCSI) {
-		DP_VERBOSE(cdev, QED_MSG_STORAGE, "Starting OOO LL2 queue\n");
-		rc = qed_ll2_start_ooo(cdev, params);
+	WARN_ON(!cdev->ll2->cbs);
+
+	/* Initialize LL2 locks & lists */
+	INIT_LIST_HEAD(&cdev->ll2->list);
+	spin_lock_init(&cdev->ll2->lock);
+
+	cdev->ll2->rx_size = NET_SKB_PAD + ETH_HLEN +
+			     L1_CACHE_BYTES + params->mtu;
+
+	/* Allocate memory for LL2.
+	 * In CMT mode, in case of a storage PF which is affintized to engine 1,
+	 * LL2 is started also on engine 0 and thus we need twofold buffers.
+	 */
+	rx_num_desc = QED_LL2_RX_SIZE * (b_is_storage_eng1 ? 2 : 1);
+	DP_INFO(cdev, "Allocating %d LL2 buffers of size %08x bytes\n",
+		rx_num_desc, cdev->ll2->rx_size);
+	for (i = 0; i < rx_num_desc; i++) {
+		buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
+		if (!buffer) {
+			DP_INFO(cdev, "Failed to allocate LL2 buffers\n");
+			rc = -ENOMEM;
+			goto err0;
+		}
+
+		rc = qed_ll2_alloc_buffer(cdev, (u8 **)&buffer->data,
+					  &buffer->phys_addr);
 		if (rc) {
-			DP_INFO(cdev,
-				"Failed to initialize the OOO LL2 queue\n");
-			goto release_terminate;
+			kfree(buffer);
+			goto err0;
 		}
-	}
 
-	p_ptt = qed_ptt_acquire(QED_LEADING_HWFN(cdev));
-	if (!p_ptt) {
-		DP_INFO(cdev, "Failed to acquire PTT\n");
-		goto release_terminate;
+		list_add_tail(&buffer->list, &cdev->ll2->list);
 	}
 
-	qed_ptt_release(QED_LEADING_HWFN(cdev), p_ptt);
+	rc = __qed_ll2_start(p_hwfn, params);
 	if (rc) {
-		DP_ERR(cdev, "Failed to allocate LLH filter\n");
-		goto release_terminate_all;
+		DP_NOTICE(cdev, "Failed to start LL2\n");
+		goto err0;
 	}
 
-	ether_addr_copy(cdev->ll2_mac_address, params->ll2_mac_address);
-	return 0;
-
-release_terminate_all:
-
-release_terminate:
-	qed_ll2_terminate_connection(QED_LEADING_HWFN(cdev), cdev->ll2->handle);
-release_fail:
-	qed_ll2_release_connection(QED_LEADING_HWFN(cdev), cdev->ll2->handle);
-fail:
-	qed_ll2_kill_buffers(cdev);
-	cdev->ll2->handle = QED_LL2_UNUSED_HANDLE;
-	return -EINVAL;
-}
-
-static int qed_ll2_stop(struct qed_dev *cdev)
-{
-	struct qed_ptt *p_ptt;
-	int rc;
-
-	if (cdev->ll2->handle == QED_LL2_UNUSED_HANDLE)
-		return 0;
+	/* In CMT mode, always need to start LL2 on engine 0 for a storage PF,
+	 * since broadcast/mutlicast packets are routed to engine 0.
+	 */
+	if (b_is_storage_eng1) {
+		rc = __qed_ll2_start(QED_LEADING_HWFN(cdev), params);
+		if (rc) {
+			DP_NOTICE(QED_LEADING_HWFN(cdev),
+				  "Failed to start LL2 on engine 0\n");
+			goto err1;
+		}
+	}
 
-	p_ptt = qed_ptt_acquire(QED_LEADING_HWFN(cdev));
-	if (!p_ptt) {
-		DP_INFO(cdev, "Failed to acquire PTT\n");
-		goto fail;
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn)) {
+		DP_VERBOSE(cdev, QED_MSG_STORAGE, "Starting OOO LL2 queue\n");
+		rc = qed_ll2_start_ooo(p_hwfn, params);
+		if (rc) {
+			DP_NOTICE(cdev, "Failed to start OOO LL2\n");
+			goto err2;
+		}
 	}
 
-	qed_ptt_release(QED_LEADING_HWFN(cdev), p_ptt);
-	eth_zero_addr(cdev->ll2_mac_address);
+	rc = qed_llh_add_mac_filter(cdev, 0, params->ll2_mac_address);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to add an LLH filter\n");
+		goto err3;
+	}
 
-	if (QED_LEADING_HWFN(cdev)->hw_info.personality == QED_PCI_ISCSI)
-		qed_ll2_stop_ooo(cdev);
+	ether_addr_copy(cdev->ll2_mac_address, params->ll2_mac_address);
 
-	rc = qed_ll2_terminate_connection(QED_LEADING_HWFN(cdev),
-					  cdev->ll2->handle);
-	if (rc)
-		DP_INFO(cdev, "Failed to terminate LL2 connection\n");
+	return 0;
 
+err3:
+	if (QED_IS_ISCSI_PERSONALITY(p_hwfn))
+		qed_ll2_stop_ooo(p_hwfn);
+err2:
+	if (b_is_storage_eng1)
+		__qed_ll2_stop(QED_LEADING_HWFN(cdev));
+err1:
+	__qed_ll2_stop(p_hwfn);
+err0:
 	qed_ll2_kill_buffers(cdev);
-
-	qed_ll2_release_connection(QED_LEADING_HWFN(cdev), cdev->ll2->handle);
 	cdev->ll2->handle = QED_LL2_UNUSED_HANDLE;
-
 	return rc;
-fail:
-	return -EINVAL;
 }
 
 static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 			      unsigned long xmit_flags)
 {
+	struct qed_hwfn *p_hwfn = QED_AFFIN_HWFN(cdev);
 	struct qed_ll2_tx_pkt_info pkt;
 	const skb_frag_t *frag;
 	u8 flags = 0, nr_frags;
@@ -2502,7 +2569,7 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 	 * routine may run and free the SKB, so no dereferencing the SKB
 	 * beyond this point unless skb has any fragments.
 	 */
-	rc = qed_ll2_prepare_tx_packet(&cdev->hwfns[0], cdev->ll2->handle,
+	rc = qed_ll2_prepare_tx_packet(p_hwfn, cdev->ll2->handle,
 				       &pkt, 1);
 	if (rc)
 		goto err;
@@ -2520,13 +2587,13 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 			goto err;
 		}
 
-		rc = qed_ll2_set_fragment_of_tx_packet(QED_LEADING_HWFN(cdev),
+		rc = qed_ll2_set_fragment_of_tx_packet(p_hwfn,
 						       cdev->ll2->handle,
 						       mapping,
 						       skb_frag_size(frag));
 
 		/* if failed not much to do here, partial packet has been posted
-		 * we can't free memory, will need to wait for completion.
+		 * we can't free memory, will need to wait for completion
 		 */
 		if (rc)
 			goto err2;
@@ -2536,18 +2603,37 @@ static int qed_ll2_start_xmit(struct qed_dev *cdev, struct sk_buff *skb,
 
 err:
 	dma_unmap_single(&cdev->pdev->dev, mapping, skb->len, DMA_TO_DEVICE);
-
 err2:
 	return rc;
 }
 
 static int qed_ll2_stats(struct qed_dev *cdev, struct qed_ll2_stats *stats)
 {
+	bool b_is_storage_eng1 = qed_ll2_is_storage_eng1(cdev);
+	struct qed_hwfn *p_hwfn = QED_AFFIN_HWFN(cdev);
+	int rc;
+
 	if (!cdev->ll2)
 		return -EINVAL;
 
-	return qed_ll2_get_stats(QED_LEADING_HWFN(cdev),
-				 cdev->ll2->handle, stats);
+	rc = qed_ll2_get_stats(p_hwfn, cdev->ll2->handle, stats);
+	if (rc) {
+		DP_NOTICE(p_hwfn, "Failed to get LL2 stats\n");
+		return rc;
+	}
+
+	/* In CMT mode, LL2 is always started on engine 0 for a storage PF */
+	if (b_is_storage_eng1) {
+		rc = __qed_ll2_get_stats(QED_LEADING_HWFN(cdev),
+					 cdev->ll2->handle, stats);
+		if (rc) {
+			DP_NOTICE(QED_LEADING_HWFN(cdev),
+				  "Failed to get LL2 stats on engine 0\n");
+			return rc;
+		}
+	}
+
+	return 0;
 }
 
 const struct qed_ll2_ops qed_ll2_ops_pass = {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 7cf9bd8de708..4284374daa4f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -818,14 +818,17 @@ static struct qed_rdma_port *qed_rdma_query_port(void *rdma_cxt)
 {
 	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)rdma_cxt;
 	struct qed_rdma_port *p_port = p_hwfn->p_rdma_info->port;
+	struct qed_mcp_link_state *p_link_output;
 
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "RDMA Query port\n");
 
-	/* Link may have changed */
-	p_port->port_state = p_hwfn->mcp_info->link_output.link_up ?
-			     QED_RDMA_PORT_UP : QED_RDMA_PORT_DOWN;
+	/* The link state is saved only for the leading hwfn */
+	p_link_output = &QED_LEADING_HWFN(p_hwfn->cdev)->mcp_info->link_output;
 
-	p_port->link_speed = p_hwfn->mcp_info->link_output.speed;
+	p_port->port_state = p_link_output->link_up ? QED_RDMA_PORT_UP
+	    : QED_RDMA_PORT_DOWN;
+
+	p_port->link_speed = p_link_output->speed;
 
 	p_port->max_msg_size = RDMA_MAX_DATA_SIZE_IN_WQE;
 
@@ -870,7 +873,7 @@ static void qed_rdma_cnq_prod_update(void *rdma_cxt, u8 qz_offset, u16 prod)
 static int qed_fill_rdma_dev_info(struct qed_dev *cdev,
 				  struct qed_dev_rdma_info *info)
 {
-	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
+	struct qed_hwfn *p_hwfn = QED_AFFIN_HWFN(cdev);
 
 	memset(info, 0, sizeof(*info));
 
@@ -889,9 +892,9 @@ static int qed_rdma_get_sb_start(struct qed_dev *cdev)
 	int feat_num;
 
 	if (cdev->num_hwfns > 1)
-		feat_num = FEAT_NUM(QED_LEADING_HWFN(cdev), QED_PF_L2_QUE);
+		feat_num = FEAT_NUM(QED_AFFIN_HWFN(cdev), QED_PF_L2_QUE);
 	else
-		feat_num = FEAT_NUM(QED_LEADING_HWFN(cdev), QED_PF_L2_QUE) *
+		feat_num = FEAT_NUM(QED_AFFIN_HWFN(cdev), QED_PF_L2_QUE) *
 			   cdev->num_hwfns;
 
 	return feat_num;
@@ -899,7 +902,7 @@ static int qed_rdma_get_sb_start(struct qed_dev *cdev)
 
 static int qed_rdma_get_min_cnq_msix(struct qed_dev *cdev)
 {
-	int n_cnq = FEAT_NUM(QED_LEADING_HWFN(cdev), QED_RDMA_CNQ);
+	int n_cnq = FEAT_NUM(QED_AFFIN_HWFN(cdev), QED_RDMA_CNQ);
 	int n_msix = cdev->int_params.rdma_msix_cnt;
 
 	return min_t(int, n_cnq, n_msix);
@@ -1653,7 +1656,7 @@ static int qed_rdma_deregister_tid(void *rdma_cxt, u32 itid)
 
 static void *qed_rdma_get_rdma_ctx(struct qed_dev *cdev)
 {
-	return QED_LEADING_HWFN(cdev);
+	return QED_AFFIN_HWFN(cdev);
 }
 
 static int qed_rdma_modify_srq(void *rdma_cxt,
@@ -1881,7 +1884,7 @@ static int qed_rdma_start(void *rdma_cxt,
 static int qed_rdma_init(struct qed_dev *cdev,
 			 struct qed_rdma_start_in_params *params)
 {
-	return qed_rdma_start(QED_LEADING_HWFN(cdev), params);
+	return qed_rdma_start(QED_AFFIN_HWFN(cdev), params);
 }
 
 static void qed_rdma_remove_user(void *rdma_cxt, u16 dpi)
-- 
2.14.5

