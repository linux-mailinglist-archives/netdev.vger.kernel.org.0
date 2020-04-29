Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50421BE23B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgD2PLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726637AbgD2PLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:38 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF1GkF142794;
        Wed, 29 Apr 2020 11:11:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q80ps2sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFAsuq006674;
        Wed, 29 Apr 2020 15:11:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5rnqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBVVV50856170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3927AAE053;
        Wed, 29 Apr 2020 15:11:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED210AE057;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:30 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 06/13] net/smc: multi-link support for smc_rmb_rtoken_handling()
Date:   Wed, 29 Apr 2020 17:10:42 +0200
Message-Id: <20200429151049.49979-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend smc_rmb_rtoken_handling() and smc_rtoken_delete() to support
multiple links.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   |  4 ++--
 net/smc/smc_core.c | 14 ++++++++------
 net/smc/smc_core.h |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 890dc6422f8c..e39f6aedd3bd 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -640,7 +640,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	if (ini->cln_first_contact == SMC_FIRST_CONTACT)
 		smc_link_save_peer_info(link, aclc);
 
-	if (smc_rmb_rtoken_handling(&smc->conn, aclc))
+	if (smc_rmb_rtoken_handling(&smc->conn, link, aclc))
 		return smc_connect_abort(smc, SMC_CLC_DECL_ERR_RTOK,
 					 ini->cln_first_contact);
 
@@ -1231,7 +1231,7 @@ static int smc_listen_rdma_finish(struct smc_sock *new_smc,
 	if (local_contact == SMC_FIRST_CONTACT)
 		smc_link_save_peer_info(link, cclc);
 
-	if (smc_rmb_rtoken_handling(&new_smc->conn, cclc)) {
+	if (smc_rmb_rtoken_handling(&new_smc->conn, link, cclc)) {
 		reason_code = SMC_CLC_DECL_ERR_RTOK;
 		goto decline;
 	}
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 5df3f8f41d19..e8897d60b27f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1392,19 +1392,20 @@ int smc_rtoken_add(struct smc_link *lnk, __be64 nw_vaddr, __be32 nw_rkey)
 	return i;
 }
 
-/* delete an rtoken */
+/* delete an rtoken from all links */
 int smc_rtoken_delete(struct smc_link *lnk, __be32 nw_rkey)
 {
 	struct smc_link_group *lgr = smc_get_lgr(lnk);
 	u32 rkey = ntohl(nw_rkey);
-	int i;
+	int i, j;
 
 	for (i = 0; i < SMC_RMBS_PER_LGR_MAX; i++) {
 		if (lgr->rtokens[i][lnk->link_idx].rkey == rkey &&
 		    test_bit(i, lgr->rtokens_used_mask)) {
-			lgr->rtokens[i][lnk->link_idx].rkey = 0;
-			lgr->rtokens[i][lnk->link_idx].dma_addr = 0;
-
+			for (j = 0; j < SMC_LINKS_PER_LGR_MAX; j++) {
+				lgr->rtokens[i][j].rkey = 0;
+				lgr->rtokens[i][j].dma_addr = 0;
+			}
 			clear_bit(i, lgr->rtokens_used_mask);
 			return 0;
 		}
@@ -1414,9 +1415,10 @@ int smc_rtoken_delete(struct smc_link *lnk, __be32 nw_rkey)
 
 /* save rkey and dma_addr received from peer during clc handshake */
 int smc_rmb_rtoken_handling(struct smc_connection *conn,
+			    struct smc_link *lnk,
 			    struct smc_clc_msg_accept_confirm *clc)
 {
-	conn->rtoken_idx = smc_rtoken_add(conn->lnk, clc->rmb_dma_addr,
+	conn->rtoken_idx = smc_rtoken_add(lnk, clc->rmb_dma_addr,
 					  clc->rmb_rkey);
 	if (conn->rtoken_idx < 0)
 		return conn->rtoken_idx;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 66753ba23bc6..f68ba187ecf8 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -309,7 +309,7 @@ void smc_smcd_terminate_all(struct smcd_dev *dev);
 void smc_smcr_terminate_all(struct smc_ib_device *smcibdev);
 int smc_buf_create(struct smc_sock *smc, bool is_smcd);
 int smc_uncompress_bufsize(u8 compressed);
-int smc_rmb_rtoken_handling(struct smc_connection *conn,
+int smc_rmb_rtoken_handling(struct smc_connection *conn, struct smc_link *link,
 			    struct smc_clc_msg_accept_confirm *clc);
 int smc_rtoken_add(struct smc_link *lnk, __be64 nw_vaddr, __be32 nw_rkey);
 int smc_rtoken_delete(struct smc_link *lnk, __be32 nw_rkey);
-- 
2.17.1

