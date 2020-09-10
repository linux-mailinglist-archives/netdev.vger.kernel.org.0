Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4113F264A53
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIJQwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:52:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726918AbgIJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:21 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGVlEc114867;
        Thu, 10 Sep 2020 12:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=QA+UjIOSu3j7cqG/Ees6E5UOHPIon8uNF2xOZFN/a2M=;
 b=nQM27FqzMjbIQYpkLwBszlYuY9+k1LmvaIZKkpuqlGAo5r/VlLe5sGy5TXFl9ZggqlSc
 3ff3nLoUgegaQtTg4l39lCP3l9osvb4m+USCp4zmY6RHMoHgWcL464ZpzKYvFcLsKt3s
 uAhmZrjXo3yy5zJl9bc1Qb6IuvRr0zdwJNgmt3TX4VdiksERo0kfxamSAKp4rytxGo0s
 MZ+WKGazFYYfK7/IquxLzm+Ys+AxgTyQdqL6Yt4UDSqldGnylK2fQjyXesrZvQ2PjNSH
 wSAChOHXeBRPpC9KziOYkAElZsaJTFpoKgQuQ16D1DoS0J4yekHMINF1uXgUmfm8XVgk Lw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fp6sv04r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGl1uG021255;
        Thu, 10 Sep 2020 16:49:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 33dxdr3f9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGn06l28770560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:49:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DEFA4C04A;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 477104C050;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/10] net/smc: improve server ISM device determination
Date:   Thu, 10 Sep 2020 18:48:24 +0200
Message-Id: <20200910164829.65426-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_04:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=3 spamscore=0 mlxlogscore=880 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

Move check whether peer can be reached into smc_pnet_find_ism_by_pnetid().
Thus searching continues for another ism device, if check fails.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   | 17 +++--------------
 net/smc/smc_clc.h  |  1 -
 net/smc/smc_pnet.c |  5 ++++-
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index fa97144690e0..f27a596b2624 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1188,26 +1188,12 @@ static int smc_listen_ism_init(struct smc_sock *new_smc,
 			       struct smc_clc_msg_proposal *pclc,
 			       struct smc_init_info *ini)
 {
-	struct smc_clc_msg_smcd *pclc_smcd;
 	int rc;
 
-	pclc_smcd = smc_get_clc_msg_smcd(pclc);
-	ini->ism_peer_gid = pclc_smcd->gid;
 	rc = smc_conn_create(new_smc, ini);
 	if (rc)
 		return rc;
 
-	/* Check if peer can be reached via ISM device */
-	if (smc_ism_cantalk(new_smc->conn.lgr->peer_gid,
-			    new_smc->conn.lgr->vlan_id,
-			    new_smc->conn.lgr->smcd)) {
-		if (ini->first_contact_local)
-			smc_lgr_cleanup_early(&new_smc->conn);
-		else
-			smc_conn_free(&new_smc->conn);
-		return SMC_CLC_DECL_SMCDNOTALK;
-	}
-
 	/* Create send and receive buffers */
 	rc = smc_buf_create(new_smc, true);
 	if (rc) {
@@ -1338,7 +1324,10 @@ static void smc_listen_work(struct work_struct *work)
 
 	/* check if ISM is available */
 	if (pclc->hdr.path == SMC_TYPE_D || pclc->hdr.path == SMC_TYPE_B) {
+		struct smc_clc_msg_smcd *pclc_smcd = smc_get_clc_msg_smcd(pclc);
+
 		ini.is_smcd = true; /* prepare ISM check */
+		ini.ism_peer_gid = pclc_smcd->gid;
 		rc = smc_find_ism_device(new_smc, &ini);
 		if (!rc)
 			rc = smc_listen_ism_init(new_smc, pclc, &ini);
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index fda474e91f95..fcd8521c7737 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -37,7 +37,6 @@
 #define SMC_CLC_DECL_NOSMCDEV	0x03030000  /* no SMC device found (R or D)   */
 #define SMC_CLC_DECL_NOSMCDDEV	0x03030001  /* no SMC-D device found	      */
 #define SMC_CLC_DECL_NOSMCRDEV	0x03030002  /* no SMC-R device found	      */
-#define SMC_CLC_DECL_SMCDNOTALK	0x03030003  /* SMC-D dev can't talk to peer   */
 #define SMC_CLC_DECL_MODEUNSUPP	0x03040000  /* smc modes do not match (R or D)*/
 #define SMC_CLC_DECL_RMBE_EC	0x03050000  /* peer has eyecatcher in RMBE    */
 #define SMC_CLC_DECL_OPTUNSUPP	0x03060000  /* fastopen sockopt not supported */
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 30e5fac7034e..70684c49510e 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -928,7 +928,10 @@ static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
 	mutex_lock(&smcd_dev_list.mutex);
 	list_for_each_entry(ismdev, &smcd_dev_list.list, list) {
 		if (smc_pnet_match(ismdev->pnetid, ndev_pnetid) &&
-		    !ismdev->going_away) {
+		    !ismdev->going_away &&
+		    (!ini->ism_peer_gid ||
+		     !smc_ism_cantalk(ini->ism_peer_gid, ini->vlan_id,
+				      ismdev))) {
 			ini->ism_dev = ismdev;
 			break;
 		}
-- 
2.17.1

