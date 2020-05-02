Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713951C2570
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgEBMgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727778AbgEBMgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:17 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CWxPk049893;
        Sat, 2 May 2020 08:36:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4gs5cu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZEPF008291;
        Sat, 2 May 2020 12:36:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5gruh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042CaAJ646661788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58613A405C;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B043A4054;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 06/13] net/smc: final part of add link processing as SMC server
Date:   Sat,  2 May 2020 14:35:45 +0200
Message-Id: <20200502123552.17204-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch finalizes the ADD_LINK processing of new links. Send the
CONFIRM_LINK request to the peer, receive the response and set link
state to ACTIVE.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e1d61b6b083b..20ce29b88b50 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -904,6 +904,33 @@ static int smc_llc_srv_rkey_exchange(struct smc_link *link,
 	return rc;
 }
 
+static int smc_llc_srv_conf_link(struct smc_link *link,
+				 struct smc_link *link_new,
+				 enum smc_lgr_type lgr_new_t)
+{
+	struct smc_link_group *lgr = link->lgr;
+	struct smc_llc_qentry *qentry = NULL;
+	int rc;
+
+	/* send CONFIRM LINK request over the RoCE fabric */
+	rc = smc_llc_send_confirm_link(link_new, SMC_LLC_REQ);
+	if (rc)
+		return -ENOLINK;
+	/* receive CONFIRM LINK response over the RoCE fabric */
+	qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_FIRST_TIME,
+			      SMC_LLC_CONFIRM_LINK);
+	if (!qentry) {
+		/* send DELETE LINK */
+		smc_llc_send_delete_link(link, link_new->link_id, SMC_LLC_REQ,
+					 false, SMC_LLC_DEL_LOST_PATH);
+		return -ENOLINK;
+	}
+	smc_llc_link_active(link_new);
+	lgr->type = lgr_new_t;
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+	return 0;
+}
+
 int smc_llc_srv_add_link(struct smc_link *link)
 {
 	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
@@ -967,7 +994,7 @@ int smc_llc_srv_add_link(struct smc_link *link)
 	rc = smc_llc_srv_rkey_exchange(link, link_new);
 	if (rc)
 		goto out_err;
-	/* tbd: rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t); */
+	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
 	if (rc)
 		goto out_err;
 	return 0;
-- 
2.17.1

