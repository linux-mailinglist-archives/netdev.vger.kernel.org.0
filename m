Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7175E1C2C42
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgECMkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:40:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728224AbgECMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:48 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CXWJi015464;
        Sun, 3 May 2020 08:39:46 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4r1w0rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:46 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZhlT012255;
        Sun, 3 May 2020 12:39:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5jn9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdfYw55574732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7A564C04E;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BCBF4C052;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 07/11] net/smc: delete an asymmetric link as SMC server
Date:   Sun,  3 May 2020 14:38:46 +0200
Message-Id: <20200503123850.57261-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=3 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a link group moved from asymmetric to symmetric state then the
dangling asymmetric link can be deleted. Add smc_llc_find_asym_link() to
find the respective link and add smc_llc_delete_asym_link() to delete
it.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_wr.c  |  2 +-
 net/smc/smc_wr.h  |  1 +
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 1fefee55e293..9d102c912be9 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -863,6 +863,85 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
+/* find the asymmetric link when 3 links are established  */
+static struct smc_link *smc_llc_find_asym_link(struct smc_link_group *lgr)
+{
+	int asym_idx = -ENOENT;
+	int i, j, k;
+	bool found;
+
+	/* determine asymmetric link */
+	found = false;
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		for (j = i + 1; j < SMC_LINKS_PER_LGR_MAX; j++) {
+			if (!smc_link_usable(&lgr->lnk[i]) ||
+			    !smc_link_usable(&lgr->lnk[j]))
+				continue;
+			if (!memcmp(lgr->lnk[i].gid, lgr->lnk[j].gid,
+				    SMC_GID_SIZE)) {
+				found = true;	/* asym_lnk is i or j */
+				break;
+			}
+		}
+		if (found)
+			break;
+	}
+	if (!found)
+		goto out; /* no asymmetric link */
+	for (k = 0; k < SMC_LINKS_PER_LGR_MAX; k++) {
+		if (!smc_link_usable(&lgr->lnk[k]))
+			continue;
+		if (k != i &&
+		    !memcmp(lgr->lnk[i].peer_gid, lgr->lnk[k].peer_gid,
+			    SMC_GID_SIZE)) {
+			asym_idx = i;
+			break;
+		}
+		if (k != j &&
+		    !memcmp(lgr->lnk[j].peer_gid, lgr->lnk[k].peer_gid,
+			    SMC_GID_SIZE)) {
+			asym_idx = j;
+			break;
+		}
+	}
+out:
+	return (asym_idx < 0) ? NULL : &lgr->lnk[asym_idx];
+}
+
+static void smc_llc_delete_asym_link(struct smc_link_group *lgr)
+{
+	struct smc_link *lnk_new = NULL, *lnk_asym;
+	struct smc_llc_qentry *qentry;
+	int rc;
+
+	lnk_asym = smc_llc_find_asym_link(lgr);
+	if (!lnk_asym)
+		return; /* no asymmetric link */
+	if (!smc_link_downing(&lnk_asym->state))
+		return;
+	/* tbd: lnk_new = smc_switch_conns(lgr, lnk_asym, false); */
+	smc_wr_tx_wait_no_pending_sends(lnk_asym);
+	if (!lnk_new)
+		goto out_free;
+	/* change flow type from ADD_LINK into DEL_LINK */
+	lgr->llc_flow_lcl.type = SMC_LLC_FLOW_DEL_LINK;
+	rc = smc_llc_send_delete_link(lnk_new, lnk_asym->link_id, SMC_LLC_REQ,
+				      true, SMC_LLC_DEL_NO_ASYM_NEEDED);
+	if (rc) {
+		smcr_link_down_cond(lnk_new);
+		goto out_free;
+	}
+	qentry = smc_llc_wait(lgr, lnk_new, SMC_LLC_WAIT_TIME,
+			      SMC_LLC_DELETE_LINK);
+	if (!qentry) {
+		smcr_link_down_cond(lnk_new);
+		goto out_free;
+	}
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+out_free:
+	smcr_link_clear(lnk_asym);
+}
+
 static int smc_llc_srv_rkey_exchange(struct smc_link *link,
 				     struct smc_link *link_new)
 {
@@ -1014,7 +1093,7 @@ static void smc_llc_process_srv_add_link(struct smc_link_group *lgr)
 	rc = smc_llc_srv_add_link(link);
 	if (!rc && lgr->type == SMC_LGR_SYMMETRIC) {
 		/* delete any asymmetric link */
-		/* tbd: smc_llc_delete_asym_link(lgr); */
+		smc_llc_delete_asym_link(lgr);
 	}
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 031e6c9561b1..3fd27bea4f7a 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -61,7 +61,7 @@ static inline bool smc_wr_is_tx_pend(struct smc_link *link)
 }
 
 /* wait till all pending tx work requests on the given link are completed */
-static inline int smc_wr_tx_wait_no_pending_sends(struct smc_link *link)
+int smc_wr_tx_wait_no_pending_sends(struct smc_link *link)
 {
 	if (wait_event_timeout(link->wr_tx_wait, !smc_wr_is_tx_pend(link),
 			       SMC_WR_TX_WAIT_PENDING_TIME))
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 3ac99c898418..f7eaeb3391f3 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -106,6 +106,7 @@ void smc_wr_tx_dismiss_slots(struct smc_link *lnk, u8 wr_rx_hdr_type,
 			     smc_wr_tx_filter filter,
 			     smc_wr_tx_dismisser dismisser,
 			     unsigned long data);
+int smc_wr_tx_wait_no_pending_sends(struct smc_link *link);
 
 int smc_wr_rx_register_handler(struct smc_wr_rx_handler *handler);
 int smc_wr_rx_post_init(struct smc_link *link);
-- 
2.17.1

