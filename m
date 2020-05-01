Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E941C1128
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgEAKss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728620AbgEAKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AXT8H008000;
        Fri, 1 May 2020 06:48:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r7mmxfst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak6bb026486;
        Fri, 1 May 2020 10:48:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5vh5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmPRl18284636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B895A405F;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40020A405C;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/13] net/smc: remove DELETE LINK processing from smc_core.c
Date:   Fri,  1 May 2020 12:48:10 +0200
Message-Id: <20200501104813.76601-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_04:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for multiple links makes the former DELETE LINK processing
obsolete which sent one DELETE_LINK LLC message for each single link.
Remove this processing from smc_core.c.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 849ae3f9b796..60c708f6de51 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -202,20 +202,6 @@ void smc_lgr_cleanup_early(struct smc_connection *conn)
 	smc_lgr_schedule_free_work_fast(lgr);
 }
 
-/* Send delete link, either as client to request the initiation
- * of the DELETE LINK sequence from server; or as server to
- * initiate the delete processing. See smc_llc_rx_delete_link().
- */
-static int smcr_link_send_delete(struct smc_link *lnk, bool orderly)
-{
-	if (lnk->state == SMC_LNK_ACTIVE &&
-	    !smc_llc_send_delete_link(lnk, 0, SMC_LLC_REQ, orderly,
-				      SMC_LLC_DEL_PROG_INIT_TERM)) {
-		return 0;
-	}
-	return -ENOTCONN;
-}
-
 static void smc_lgr_free(struct smc_link_group *lgr);
 
 static void smc_lgr_free_work(struct work_struct *work)
@@ -241,25 +227,6 @@ static void smc_lgr_free_work(struct work_struct *work)
 		return;
 	}
 	list_del_init(&lgr->list); /* remove from smc_lgr_list */
-
-	if (!lgr->is_smcd && !lgr->terminating)	{
-		bool do_wait = false;
-
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			struct smc_link *lnk = &lgr->lnk[i];
-			/* try to send del link msg, on err free immediately */
-			if (lnk->state == SMC_LNK_ACTIVE &&
-			    !smcr_link_send_delete(lnk, true)) {
-				/* reschedule in case we never receive a resp */
-				smc_lgr_schedule_free_work(lgr);
-				do_wait = true;
-			}
-		}
-		if (do_wait) {
-			spin_unlock_bh(lgr_lock);
-			return; /* wait for resp, see smc_llc_rx_delete_link */
-		}
-	}
 	lgr->freeing = 1; /* this instance does the freeing, no new schedule */
 	spin_unlock_bh(lgr_lock);
 	cancel_delayed_work(&lgr->free_work);
-- 
2.17.1

