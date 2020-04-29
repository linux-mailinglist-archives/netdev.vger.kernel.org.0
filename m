Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E871B1BE239
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgD2PLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16752 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727100AbgD2PLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:51 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF3w20096603;
        Wed, 29 Apr 2020 11:11:49 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q802r1gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:44 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFAuod021574;
        Wed, 29 Apr 2020 15:11:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7wu94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBXab55967878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF059AE070;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E87BAE05D;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 08/13] net/smc: move testlink work to system work queue
Date:   Wed, 29 Apr 2020 17:10:44 +0200
Message-Id: <20200429151049.49979-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=1 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The testlink work waits for a response to the testlink request and
blocks the single threaded llc_wq. This type of work does not have to be
serialized and can be moved to the system work queue.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index c267f5006faa..69cc0d65b437 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -613,14 +613,15 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	/* receive TEST LINK response over RoCE fabric */
 	rc = wait_for_completion_interruptible_timeout(&link->llc_testlink_resp,
 						       SMC_LLC_WAIT_TIME);
+	if (link->state != SMC_LNK_ACTIVE)
+		return;		/* link state changed */
 	if (rc <= 0) {
 		smc_lgr_terminate_sched(smc_get_lgr(link));
 		return;
 	}
 	next_interval = link->llc_testlink_time;
 out:
-	queue_delayed_work(link->llc_wq, &link->llc_testlink_wrk,
-			   next_interval);
+	schedule_delayed_work(&link->llc_testlink_wrk, next_interval);
 }
 
 int smc_llc_link_init(struct smc_link *link)
@@ -648,8 +649,8 @@ void smc_llc_link_active(struct smc_link *link, int testlink_time)
 	link->state = SMC_LNK_ACTIVE;
 	if (testlink_time) {
 		link->llc_testlink_time = testlink_time * HZ;
-		queue_delayed_work(link->llc_wq, &link->llc_testlink_wrk,
-				   link->llc_testlink_time);
+		schedule_delayed_work(&link->llc_testlink_wrk,
+				      link->llc_testlink_time);
 	}
 }
 
@@ -665,7 +666,7 @@ void smc_llc_link_inactive(struct smc_link *link)
 	if (link->state == SMC_LNK_INACTIVE)
 		return;
 	link->state = SMC_LNK_INACTIVE;
-	cancel_delayed_work(&link->llc_testlink_wrk);
+	cancel_delayed_work_sync(&link->llc_testlink_wrk);
 	smc_wr_wakeup_reg_wait(link);
 	smc_wr_wakeup_tx_wait(link);
 }
-- 
2.17.1

