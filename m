Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D171C2559
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgEBMgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727029AbgEBMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CViDK130687;
        Sat, 2 May 2020 08:36:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28dg87w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZEPG008291;
        Sat, 2 May 2020 12:36:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5gruj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaAsW45285536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A29AFA405C;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 655E3A4054;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 07/13] net/smc: delete an asymmetric link as SMC server
Date:   Sat,  2 May 2020 14:35:46 +0200
Message-Id: <20200502123552.17204-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=3
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020109
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
index 20ce29b88b50..e6e280a3683d 100644
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

