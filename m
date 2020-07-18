Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED1B224B57
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgGRNG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:06:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbgGRNGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:06:53 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ID2N7P162630;
        Sat, 18 Jul 2020 09:06:51 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32bw7xmftd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 09:06:51 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06ID1x5U022386;
        Sat, 18 Jul 2020 13:06:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 32brbh0cp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 13:06:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06ID5Ntb64487832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jul 2020 13:05:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7FDAE045;
        Sat, 18 Jul 2020 13:06:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8DF3AE051;
        Sat, 18 Jul 2020 13:06:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 18 Jul 2020 13:06:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net v2 01/10] net/smc: handle unexpected response types for confirm link
Date:   Sat, 18 Jul 2020 15:06:09 +0200
Message-Id: <20200718130618.16724-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718130618.16724-1-kgraul@linux.ibm.com>
References: <20200718130618.16724-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-18_05:2020-07-17,2020-07-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=1
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A delete link could arrive during confirm link processing. Handle this
situation directly in smc_llc_srv_conf_link() rather than using the
logic in smc_llc_wait() to avoid the unexpected message handling there.

Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Fixes: 1551c95b6124 ("net/smc: final part of add link processing as SMC server")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index c1a038689c63..58f4da2e0cc7 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1051,12 +1051,14 @@ static int smc_llc_srv_conf_link(struct smc_link *link,
 	if (rc)
 		return -ENOLINK;
 	/* receive CONFIRM LINK response over the RoCE fabric */
-	qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_FIRST_TIME,
-			      SMC_LLC_CONFIRM_LINK);
-	if (!qentry) {
+	qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_FIRST_TIME, 0);
+	if (!qentry ||
+	    qentry->msg.raw.hdr.common.type != SMC_LLC_CONFIRM_LINK) {
 		/* send DELETE LINK */
 		smc_llc_send_delete_link(link, link_new->link_id, SMC_LLC_REQ,
 					 false, SMC_LLC_DEL_LOST_PATH);
+		if (qentry)
+			smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 		return -ENOLINK;
 	}
 	smc_llc_save_peer_uid(qentry);
-- 
2.17.1

