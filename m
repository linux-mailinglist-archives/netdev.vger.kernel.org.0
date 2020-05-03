Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB851C2C43
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgECMj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728203AbgECMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:48 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CXWDo090021;
        Sun, 3 May 2020 08:39:47 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s369xxrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:47 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZcQ7004180;
        Sun, 3 May 2020 12:39:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g592d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043Cdf8M22806562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 311CE4C050;
        Sun,  3 May 2020 12:39:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F06334C04E;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 05/11] net/smc: rkey processing for a new link as SMC server
Date:   Sun,  3 May 2020 14:38:44 +0200
Message-Id: <20200503123850.57261-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1015
 malwarescore=0 suspectscore=1 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Part of SMC server new link establishment is the exchange of rkeys for
used buffers.
Loop over all used RMB buffers and send ADD_LINK_CONTINUE LLC messages
to the peer.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e2f254e21759..de73432bd72f 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -863,6 +863,47 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
+static int smc_llc_srv_rkey_exchange(struct smc_link *link,
+				     struct smc_link *link_new)
+{
+	struct smc_llc_msg_add_link_cont *addc_llc;
+	struct smc_link_group *lgr = link->lgr;
+	u8 max, num_rkeys_send, num_rkeys_recv;
+	struct smc_llc_qentry *qentry = NULL;
+	struct smc_buf_desc *buf_pos;
+	int buf_lst;
+	int rc = 0;
+	int i;
+
+	mutex_lock(&lgr->rmbs_lock);
+	num_rkeys_send = lgr->conns_num;
+	buf_pos = smc_llc_get_first_rmb(lgr, &buf_lst);
+	do {
+		smc_llc_add_link_cont(link, link_new, &num_rkeys_send,
+				      &buf_lst, &buf_pos);
+		qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_TIME,
+				      SMC_LLC_ADD_LINK_CONT);
+		if (!qentry) {
+			rc = -ETIMEDOUT;
+			goto out;
+		}
+		addc_llc = &qentry->msg.add_link_cont;
+		num_rkeys_recv = addc_llc->num_rkeys;
+		max = min_t(u8, num_rkeys_recv, SMC_LLC_RKEYS_PER_CONT_MSG);
+		for (i = 0; i < max; i++) {
+			smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
+				       addc_llc->rt[i].rmb_key,
+				       addc_llc->rt[i].rmb_vaddr_new,
+				       addc_llc->rt[i].rmb_key_new);
+			num_rkeys_recv--;
+		}
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+	} while (num_rkeys_send || num_rkeys_recv);
+out:
+	mutex_unlock(&lgr->rmbs_lock);
+	return rc;
+}
+
 int smc_llc_srv_add_link(struct smc_link *link)
 {
 	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
@@ -923,7 +964,7 @@ int smc_llc_srv_add_link(struct smc_link *link)
 	rc = smcr_buf_reg_lgr(link_new);
 	if (rc)
 		goto out_err;
-	/* tbd: rc = smc_llc_srv_rkey_exchange(link, link_new); */
+	rc = smc_llc_srv_rkey_exchange(link, link_new);
 	if (rc)
 		goto out_err;
 	/* tbd: rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t); */
-- 
2.17.1

