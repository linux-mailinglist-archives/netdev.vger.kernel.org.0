Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F77E1C2561
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgEBMgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727854AbgEBMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CXECO042273;
        Sat, 2 May 2020 08:36:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4r154yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:13 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZFI8027072;
        Sat, 2 May 2020 12:36:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5gs7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042Ca8og39190618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0C2EA405C;
        Sat,  2 May 2020 12:36:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 833CDA405B;
        Sat,  2 May 2020 12:36:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 01/13] net/smc: first part of add link processing as SMC client
Date:   Sat,  2 May 2020 14:35:40 +0200
Message-Id: <20200502123552.17204-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=3 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First set of functions to process an ADD_LINK LLC request as an SMC
client. Find an alternate IB device, determine the new link group type
and get the index for the new link. Then ready the link, map the buffers
and send an ADD_LINK LLC response. If any error occurs, send a reject
LLC message and terminate the processing.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  4 +-
 net/smc/smc_core.h |  2 +
 net/smc/smc_llc.c  | 94 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 60c708f6de51..2f8faa9c9e8e 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -273,8 +273,8 @@ static u8 smcr_next_link_id(struct smc_link_group *lgr)
 	return link_id;
 }
 
-static int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
-			  u8 link_idx, struct smc_init_info *ini)
+int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
+		   u8 link_idx, struct smc_init_info *ini)
 {
 	u8 rndvec[3];
 	int rc;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 555ada9d2423..4e00819e2db7 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -374,6 +374,8 @@ void smc_lgr_schedule_free_work_fast(struct smc_link_group *lgr);
 int smc_core_init(void);
 void smc_core_exit(void);
 
+int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
+		   u8 link_idx, struct smc_init_info *ini);
 void smcr_link_clear(struct smc_link *lnk);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 50f59746bdf9..e0c85fe90bdf 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -17,6 +17,7 @@
 #include "smc_core.h"
 #include "smc_clc.h"
 #include "smc_llc.h"
+#include "smc_pnet.h"
 
 #define SMC_LLC_DATA_LEN		40
 
@@ -565,6 +566,99 @@ static int smc_llc_alloc_alt_link(struct smc_link_group *lgr,
 	return -EMLINK;
 }
 
+/* prepare and send an add link reject response */
+static int smc_llc_cli_add_link_reject(struct smc_llc_qentry *qentry)
+{
+	qentry->msg.raw.hdr.flags |= SMC_LLC_FLAG_RESP;
+	qentry->msg.raw.hdr.flags |= SMC_LLC_FLAG_ADD_LNK_REJ;
+	qentry->msg.raw.hdr.add_link_rej_rsn = SMC_LLC_REJ_RSN_NO_ALT_PATH;
+	return smc_llc_send_message(qentry->link, &qentry->msg);
+}
+
+static void smc_llc_save_add_link_info(struct smc_link *link,
+				       struct smc_llc_msg_add_link *add_llc)
+{
+	link->peer_qpn = ntoh24(add_llc->sender_qp_num);
+	memcpy(link->peer_gid, add_llc->sender_gid, SMC_GID_SIZE);
+	memcpy(link->peer_mac, add_llc->sender_mac, ETH_ALEN);
+	link->peer_psn = ntoh24(add_llc->initial_psn);
+	link->peer_mtu = add_llc->qp_mtu;
+}
+
+/* as an SMC client, process an add link request */
+int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
+{
+	struct smc_llc_msg_add_link *llc = &qentry->msg.add_link;
+	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
+	struct smc_link_group *lgr = smc_get_lgr(link);
+	struct smc_link *lnk_new = NULL;
+	struct smc_init_info ini;
+	int lnk_idx, rc = 0;
+
+	ini.vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
+	if (!memcmp(llc->sender_gid, link->peer_gid, SMC_GID_SIZE) &&
+	    !memcmp(llc->sender_mac, link->peer_mac, ETH_ALEN)) {
+		if (!ini.ib_dev)
+			goto out_reject;
+		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
+	}
+	if (!ini.ib_dev) {
+		lgr_new_t = SMC_LGR_ASYMMETRIC_LOCAL;
+		ini.ib_dev = link->smcibdev;
+		ini.ib_port = link->ibport;
+	}
+	lnk_idx = smc_llc_alloc_alt_link(lgr, lgr_new_t);
+	if (lnk_idx < 0)
+		goto out_reject;
+	lnk_new = &lgr->lnk[lnk_idx];
+	rc = smcr_link_init(lgr, lnk_new, lnk_idx, &ini);
+	if (rc)
+		goto out_reject;
+	smc_llc_save_add_link_info(lnk_new, llc);
+	lnk_new->link_id = llc->link_num;
+
+	rc = smc_ib_ready_link(lnk_new);
+	if (rc)
+		goto out_clear_lnk;
+
+	rc = smcr_buf_map_lgr(lnk_new);
+	if (rc)
+		goto out_clear_lnk;
+
+	rc = smc_llc_send_add_link(link,
+				   lnk_new->smcibdev->mac[ini.ib_port - 1],
+				   lnk_new->gid, lnk_new, SMC_LLC_RESP);
+	if (rc)
+		goto out_clear_lnk;
+	/* tbd: rc = smc_llc_cli_rkey_exchange(link, lnk_new); */
+	if (rc) {
+		rc = 0;
+		goto out_clear_lnk;
+	}
+	/* tbd: rc = smc_llc_cli_conf_link(link, &ini, lnk_new, lgr_new_t); */
+	if (!rc)
+		goto out;
+out_clear_lnk:
+	smcr_link_clear(lnk_new);
+out_reject:
+	smc_llc_cli_add_link_reject(qentry);
+out:
+	kfree(qentry);
+	return rc;
+}
+
+static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
+{
+	struct smc_llc_qentry *qentry;
+
+	qentry = smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
+
+	mutex_lock(&lgr->llc_conf_mutex);
+	smc_llc_cli_add_link(qentry->link, qentry);
+	mutex_unlock(&lgr->llc_conf_mutex);
+}
+
 /* worker to process an add link message */
 static void smc_llc_add_link_work(struct work_struct *work)
 {
-- 
2.17.1

