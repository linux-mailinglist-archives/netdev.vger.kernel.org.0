Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0DB43018F
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhJPJko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:40:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243954AbhJPJki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:40:38 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19G7CdLs015852;
        Sat, 16 Oct 2021 05:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Eboleo/9ddyptGMiLn8hikZ/9m4UoCV3eaN8hU5Rlz0=;
 b=nP6rMIai7007EVAArkbp0jqDMFmb+zZBrudEL2a7sX69sqaHE2NRNNPoT/i+lMls8nv3
 1q9d7KyBEk8rCxhUKhWo4By5B8vooL1b4sN9y4Yp2Fykg1VTDxi9xVsKDARUHKMpDJ9P
 TLc5KcGd9RizwHgAvHxUDk9s+tlswl6KPGWt2wxXClnatTdJOL4rBCrF7R+W5CrAiVMM
 iX5Hh3wpv07z6KssLSq9CeaR9sHFTTG4w/U7cKcQpn0XmQlGLB7Weel938bxl6y8Cs9T
 2upM68ceJbLsCiQ/VLPX1STIQF0hM91Divcjt4Yn0R/4M52Ut1zl+sLd9Ad84mwFMtEs aw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bqt4pt1k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 05:38:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19G9boGE004131;
        Sat, 16 Oct 2021 09:38:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bqpc919xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Oct 2021 09:38:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19G9cN3B51839298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Oct 2021 09:38:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6267D4C052;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 363D74C046;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 16 Oct 2021 09:38:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 01/10] net/smc: save stack space and allocate smc_init_info
Date:   Sat, 16 Oct 2021 11:37:43 +0200
Message-Id: <20211016093752.3564615-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211016093752.3564615-1-kgraul@linux.ibm.com>
References: <20211016093752.3564615-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xfFK4fNO0aJoFQB1t7QevBznBIZ4vqia
X-Proofpoint-GUID: xfFK4fNO0aJoFQB1t7QevBznBIZ4vqia
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-16_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110160058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct smc_init_info grew over time, its time to save space on stack
and allocate this struct dynamically.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_llc.c | 83 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 30 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 72f4b72eb175..760f5ed7c8f0 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -870,31 +870,37 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	struct smc_llc_msg_add_link *llc = &qentry->msg.add_link;
 	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
 	struct smc_link_group *lgr = smc_get_lgr(link);
+	struct smc_init_info *ini = NULL;
 	struct smc_link *lnk_new = NULL;
-	struct smc_init_info ini;
 	int lnk_idx, rc = 0;
 
 	if (!llc->qp_mtu)
 		goto out_reject;
 
-	ini.vlan_id = lgr->vlan_id;
-	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
+	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
+	if (!ini) {
+		rc = -ENOMEM;
+		goto out_reject;
+	}
+
+	ini->vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, ini, link->smcibdev);
 	if (!memcmp(llc->sender_gid, link->peer_gid, SMC_GID_SIZE) &&
 	    !memcmp(llc->sender_mac, link->peer_mac, ETH_ALEN)) {
-		if (!ini.ib_dev)
+		if (!ini->ib_dev)
 			goto out_reject;
 		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
 	}
-	if (!ini.ib_dev) {
+	if (!ini->ib_dev) {
 		lgr_new_t = SMC_LGR_ASYMMETRIC_LOCAL;
-		ini.ib_dev = link->smcibdev;
-		ini.ib_port = link->ibport;
+		ini->ib_dev = link->smcibdev;
+		ini->ib_port = link->ibport;
 	}
 	lnk_idx = smc_llc_alloc_alt_link(lgr, lgr_new_t);
 	if (lnk_idx < 0)
 		goto out_reject;
 	lnk_new = &lgr->lnk[lnk_idx];
-	rc = smcr_link_init(lgr, lnk_new, lnk_idx, &ini);
+	rc = smcr_link_init(lgr, lnk_new, lnk_idx, ini);
 	if (rc)
 		goto out_reject;
 	smc_llc_save_add_link_info(lnk_new, llc);
@@ -910,7 +916,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 		goto out_clear_lnk;
 
 	rc = smc_llc_send_add_link(link,
-				   lnk_new->smcibdev->mac[ini.ib_port - 1],
+				   lnk_new->smcibdev->mac[ini->ib_port - 1],
 				   lnk_new->gid, lnk_new, SMC_LLC_RESP);
 	if (rc)
 		goto out_clear_lnk;
@@ -919,7 +925,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 		rc = 0;
 		goto out_clear_lnk;
 	}
-	rc = smc_llc_cli_conf_link(link, &ini, lnk_new, lgr_new_t);
+	rc = smc_llc_cli_conf_link(link, ini, lnk_new, lgr_new_t);
 	if (!rc)
 		goto out;
 out_clear_lnk:
@@ -928,6 +934,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 out_reject:
 	smc_llc_cli_add_link_reject(qentry);
 out:
+	kfree(ini);
 	kfree(qentry);
 	return rc;
 }
@@ -937,20 +944,25 @@ static void smc_llc_cli_add_link_invite(struct smc_link *link,
 					struct smc_llc_qentry *qentry)
 {
 	struct smc_link_group *lgr = smc_get_lgr(link);
-	struct smc_init_info ini;
+	struct smc_init_info *ini = NULL;
 
 	if (lgr->type == SMC_LGR_SYMMETRIC ||
 	    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
 		goto out;
 
-	ini.vlan_id = lgr->vlan_id;
-	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
-	if (!ini.ib_dev)
+	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
+	if (!ini)
+		goto out;
+
+	ini->vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, ini, link->smcibdev);
+	if (!ini->ib_dev)
 		goto out;
 
-	smc_llc_send_add_link(link, ini.ib_dev->mac[ini.ib_port - 1],
-			      ini.ib_gid, NULL, SMC_LLC_REQ);
+	smc_llc_send_add_link(link, ini->ib_dev->mac[ini->ib_port - 1],
+			      ini->ib_gid, NULL, SMC_LLC_REQ);
 out:
+	kfree(ini);
 	kfree(qentry);
 }
 
@@ -1158,28 +1170,34 @@ int smc_llc_srv_add_link(struct smc_link *link)
 	struct smc_link_group *lgr = link->lgr;
 	struct smc_llc_msg_add_link *add_llc;
 	struct smc_llc_qentry *qentry = NULL;
-	struct smc_link *link_new;
-	struct smc_init_info ini;
+	struct smc_link *link_new = NULL;
+	struct smc_init_info *ini;
 	int lnk_idx, rc = 0;
 
+	ini = kzalloc(sizeof(*ini), GFP_KERNEL);
+	if (!ini)
+		return -ENOMEM;
+
 	/* ignore client add link recommendation, start new flow */
-	ini.vlan_id = lgr->vlan_id;
-	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
-	if (!ini.ib_dev) {
+	ini->vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, ini, link->smcibdev);
+	if (!ini->ib_dev) {
 		lgr_new_t = SMC_LGR_ASYMMETRIC_LOCAL;
-		ini.ib_dev = link->smcibdev;
-		ini.ib_port = link->ibport;
+		ini->ib_dev = link->smcibdev;
+		ini->ib_port = link->ibport;
 	}
 	lnk_idx = smc_llc_alloc_alt_link(lgr, lgr_new_t);
-	if (lnk_idx < 0)
-		return 0;
+	if (lnk_idx < 0) {
+		rc = 0;
+		goto out;
+	}
 
-	rc = smcr_link_init(lgr, &lgr->lnk[lnk_idx], lnk_idx, &ini);
+	rc = smcr_link_init(lgr, &lgr->lnk[lnk_idx], lnk_idx, ini);
 	if (rc)
-		return rc;
+		goto out;
 	link_new = &lgr->lnk[lnk_idx];
 	rc = smc_llc_send_add_link(link,
-				   link_new->smcibdev->mac[ini.ib_port - 1],
+				   link_new->smcibdev->mac[ini->ib_port - 1],
 				   link_new->gid, link_new, SMC_LLC_REQ);
 	if (rc)
 		goto out_err;
@@ -1218,10 +1236,15 @@ int smc_llc_srv_add_link(struct smc_link *link)
 	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
 	if (rc)
 		goto out_err;
+	kfree(ini);
 	return 0;
 out_err:
-	link_new->state = SMC_LNK_INACTIVE;
-	smcr_link_clear(link_new, false);
+	if (link_new) {
+		link_new->state = SMC_LNK_INACTIVE;
+		smcr_link_clear(link_new, false);
+	}
+out:
+	kfree(ini);
 	return rc;
 }
 
-- 
2.25.1

