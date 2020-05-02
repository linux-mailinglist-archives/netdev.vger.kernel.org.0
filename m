Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9947B1C256C
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgEBMgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727839AbgEBMgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CXAUL101800;
        Sat, 2 May 2020 08:36:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45qws8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZFwk008295;
        Sat, 2 May 2020 12:36:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5grug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaAXU46661782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DAA0A405F;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C491FA4060;
        Sat,  2 May 2020 12:36:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/13] net/smc: rkey processing for a new link as SMC server
Date:   Sat,  2 May 2020 14:35:44 +0200
Message-Id: <20200502123552.17204-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=1 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020114
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
index 954eda708c91..e1d61b6b083b 100644
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

