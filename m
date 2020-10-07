Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4692869BC
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgJGU6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:58:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40372 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbgJGU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:57:59 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097KVsjR065855;
        Wed, 7 Oct 2020 16:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=TE6FbHmsg76AOeiAKZRnIgIco3rxsKrozMVoleeY88g=;
 b=IZoOY8LqDWCjIH+pcFr83b1iMvCJHixa6KZ3CY6/B5jH1xok0En7fLnTQvQi6JIEmvYp
 pelqIOy7CyHoFpN8SnQLg7DwPIuMZ8TDhmzdxD49soNrc0woI5muRjyOjWGp/2XK/Odk
 AmOHSa0Gwal6iCljMiHxVvuLNs10+84i2TvmXV32FNWYu6SlG2i682Nj98u3gSKLe3FL
 Q0LAZo2eppQkiEXxl6YZ3fmEpB7Oa7A4e4VRjauvTqXbnZVjPWgyvEzNu+mhtpYDcMbc
 OqCUodxXA194OXOglsFOHMeXJAGTmRtpa3qNbXIPTPrBgKkKtX+/gptyRo0n1AW6tFef eA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341mj48xcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 16:57:56 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097Kuh7A003679;
        Wed, 7 Oct 2020 20:57:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 33xgx82e8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 20:57:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097Kvp2k23986562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 20:57:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B299EAE045;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75DA6AE051;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 20:57:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/3] net/smc: consolidate unlocking in same function
Date:   Wed,  7 Oct 2020 22:57:41 +0200
Message-Id: <20201007205743.83535-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201007205743.83535-1-kgraul@linux.ibm.com>
References: <20201007205743.83535-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 suspectscore=3 mlxscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static code checkers warn of inconsistent returns because the lgr mutex
is locked in one function and unlocked in a function called by the
locking function:
net/smc/af_smc.c:823 smc_connect_rdma() warn: inconsistent returns 'smc_client_lgr_pending'.
net/smc/af_smc.c:897 smc_connect_ism() warn: inconsistent returns 'smc_server_lgr_pending'.

Make the code consistent by doing the unlock in the same function that
fetches the lock. No functional changes.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c | 77 +++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 670e802a73cb..fbe98bb20299 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -553,23 +553,12 @@ static int smc_connect_decline_fallback(struct smc_sock *smc, int reason_code,
 }
 
 /* abort connecting */
-static int smc_connect_abort(struct smc_sock *smc, int reason_code,
-			     int local_first)
+static void smc_connect_abort(struct smc_sock *smc, int local_first)
 {
-	bool is_smcd = smc->conn.lgr->is_smcd;
-
 	if (local_first)
 		smc_lgr_cleanup_early(&smc->conn);
 	else
 		smc_conn_free(&smc->conn);
-	if (is_smcd)
-		/* there is only one lgr role for SMC-D; use server lock */
-		mutex_unlock(&smc_server_lgr_pending);
-	else
-		mutex_unlock(&smc_client_lgr_pending);
-
-	smc->connect_nonblock = 0;
-	return reason_code;
 }
 
 /* check if there is a rdma device available for this connection. */
@@ -764,43 +753,47 @@ static int smc_connect_rdma(struct smc_sock *smc,
 				break;
 			}
 		}
-		if (!link)
-			return smc_connect_abort(smc, SMC_CLC_DECL_NOSRVLINK,
-						 ini->first_contact_local);
+		if (!link) {
+			reason_code = SMC_CLC_DECL_NOSRVLINK;
+			goto connect_abort;
+		}
 		smc->conn.lnk = link;
 	}
 
 	/* create send buffer and rmb */
-	if (smc_buf_create(smc, false))
-		return smc_connect_abort(smc, SMC_CLC_DECL_MEM,
-					 ini->first_contact_local);
+	if (smc_buf_create(smc, false)) {
+		reason_code = SMC_CLC_DECL_MEM;
+		goto connect_abort;
+	}
 
 	if (ini->first_contact_local)
 		smc_link_save_peer_info(link, aclc);
 
-	if (smc_rmb_rtoken_handling(&smc->conn, link, aclc))
-		return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RTOK,
-					 ini->first_contact_local);
+	if (smc_rmb_rtoken_handling(&smc->conn, link, aclc)) {
+		reason_code = SMC_CLC_DECL_ERR_RTOK;
+		goto connect_abort;
+	}
 
 	smc_close_init(smc);
 	smc_rx_init(smc);
 
 	if (ini->first_contact_local) {
-		if (smc_ib_ready_link(link))
-			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RDYLNK,
-						 ini->first_contact_local);
+		if (smc_ib_ready_link(link)) {
+			reason_code = SMC_CLC_DECL_ERR_RDYLNK;
+			goto connect_abort;
+		}
 	} else {
-		if (smcr_lgr_reg_rmbs(link, smc->conn.rmb_desc))
-			return smc_connect_abort(smc, SMC_CLC_DECL_ERR_REGRMB,
-						 ini->first_contact_local);
+		if (smcr_lgr_reg_rmbs(link, smc->conn.rmb_desc)) {
+			reason_code = SMC_CLC_DECL_ERR_REGRMB;
+			goto connect_abort;
+		}
 	}
 	smc_rmb_sync_sg_for_device(&smc->conn);
 
 	reason_code = smc_clc_send_confirm(smc, ini->first_contact_local,
 					   SMC_V1);
 	if (reason_code)
-		return smc_connect_abort(smc, reason_code,
-					 ini->first_contact_local);
+		goto connect_abort;
 
 	smc_tx_init(smc);
 
@@ -810,8 +803,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		reason_code = smcr_clnt_conf_first_link(smc);
 		smc_llc_flow_stop(link->lgr, &link->lgr->llc_flow_lcl);
 		if (reason_code)
-			return smc_connect_abort(smc, reason_code,
-						 ini->first_contact_local);
+			goto connect_abort;
 	}
 	mutex_unlock(&smc_client_lgr_pending);
 
@@ -821,6 +813,12 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		smc->sk.sk_state = SMC_ACTIVE;
 
 	return 0;
+connect_abort:
+	smc_connect_abort(smc, ini->first_contact_local);
+	mutex_unlock(&smc_client_lgr_pending);
+	smc->connect_nonblock = 0;
+
+	return reason_code;
 }
 
 /* The server has chosen one of the proposed ISM devices for the communication.
@@ -872,11 +870,10 @@ static int smc_connect_ism(struct smc_sock *smc,
 
 	/* Create send and receive buffers */
 	rc = smc_buf_create(smc, true);
-	if (rc)
-		return smc_connect_abort(smc, (rc == -ENOSPC) ?
-					      SMC_CLC_DECL_MAX_DMB :
-					      SMC_CLC_DECL_MEM,
-					 ini->first_contact_local);
+	if (rc) {
+		rc = (rc == -ENOSPC) ? SMC_CLC_DECL_MAX_DMB : SMC_CLC_DECL_MEM;
+		goto connect_abort;
+	}
 
 	smc_conn_save_peer_info(smc, aclc);
 	smc_close_init(smc);
@@ -886,7 +883,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 	rc = smc_clc_send_confirm(smc, ini->first_contact_local,
 				  aclc->hdr.version);
 	if (rc)
-		return smc_connect_abort(smc, rc, ini->first_contact_local);
+		goto connect_abort;
 	mutex_unlock(&smc_server_lgr_pending);
 
 	smc_copy_sock_settings_to_clc(smc);
@@ -895,6 +892,12 @@ static int smc_connect_ism(struct smc_sock *smc,
 		smc->sk.sk_state = SMC_ACTIVE;
 
 	return 0;
+connect_abort:
+	smc_connect_abort(smc, ini->first_contact_local);
+	mutex_unlock(&smc_server_lgr_pending);
+	smc->connect_nonblock = 0;
+
+	return rc;
 }
 
 /* check if received accept type and version matches a proposed one */
-- 
2.17.1

