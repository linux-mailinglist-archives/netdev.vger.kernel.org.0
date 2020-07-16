Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6154C22272F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgGPPiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37002 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbgGPPiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:38:07 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFX4WZ110583;
        Thu, 16 Jul 2020 11:38:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 327u1kt431-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:38:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GFa1Le016247;
        Thu, 16 Jul 2020 15:38:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 329nmyhy97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 15:37:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFbt4R29032482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:37:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF32C42054;
        Thu, 16 Jul 2020 15:37:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A414942041;
        Thu, 16 Jul 2020 15:37:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:37:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 01/10] net/smc: handle unexpected response types for confirm link
Date:   Thu, 16 Jul 2020 17:37:37 +0200
Message-Id: <20200716153746.77303-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716153746.77303-1-kgraul@linux.ibm.com>
References: <20200716153746.77303-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 suspectscore=1 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160114
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

