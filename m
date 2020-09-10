Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF529264A60
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgIJQyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:54:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbgIJQtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:49:22 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AGXUc8186350;
        Thu, 10 Sep 2020 12:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=QXAcR+sWj4t+TBxsDBVmZctriyZiUTjwysXNIws0kWU=;
 b=IdB15Tkm0AjuLy7kyOsp2e7YLrkagYcao5EQMKdXiMwWJIlKr00PeBSn9E70eb5SMdro
 7RfyftNMZaSGbW+EAM7hstrBHWwkiVfSEFE3nRRCkTl4veXJwB7UBZ8Fz6jzYfCiQP/i
 k/Txt/bCPtA4VVmKa3kDDUDz7nZEoTD/VFllN+19MLLfSB76nM/SOW5EoCBCC+AoSClD
 UsDgrQPmWyHkbRC5iN7G37YX8fiSsHf9m7yTW+jQtt169/3D/8EvM58mvTJMKSAhe2Xz
 TBEBo1dMy1f9O+VAL0II1pPnkjTgBAIz2yKdrkpwgusSJRpZJ+A+y9uzHNTnS8lXOle/ Rw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fqm2rxft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:49:05 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AGn34h027014;
        Thu, 10 Sep 2020 16:49:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 33c2a81hn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 16:49:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AGn0Dj35324404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 16:49:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CAB54C04E;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 017F34C04A;
        Thu, 10 Sep 2020 16:49:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 16:48:59 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 04/10] net/smc: common routine for CLC accept and confirm
Date:   Thu, 10 Sep 2020 18:48:23 +0200
Message-Id: <20200910164829.65426-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910164829.65426-1-kgraul@linux.ibm.com>
References: <20200910164829.65426-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 spamscore=0 suspectscore=1 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

smc_clc_send_accept() and smc_clc_send_confirm() are quite similar.
Move common code into a separate function smc_clc_send_confirm_accept().
And introduce separate SMCD and SMCR struct definitions for CLC accept
resp. confirm.
No functional change.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/af_smc.c   |  36 +++++------
 net/smc/smc_clc.c  | 147 ++++++++++++++++++---------------------------
 net/smc/smc_clc.h  |  74 ++++++++++++-----------
 net/smc/smc_core.c |   4 +-
 4 files changed, 118 insertions(+), 143 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 00e2a4ce0131..fa97144690e0 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -436,10 +436,10 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 static void smcr_conn_save_peer_info(struct smc_sock *smc,
 				     struct smc_clc_msg_accept_confirm *clc)
 {
-	int bufsize = smc_uncompress_bufsize(clc->rmbe_size);
+	int bufsize = smc_uncompress_bufsize(clc->r0.rmbe_size);
 
-	smc->conn.peer_rmbe_idx = clc->rmbe_idx;
-	smc->conn.local_tx_ctrl.token = ntohl(clc->rmbe_alert_token);
+	smc->conn.peer_rmbe_idx = clc->r0.rmbe_idx;
+	smc->conn.local_tx_ctrl.token = ntohl(clc->r0.rmbe_alert_token);
 	smc->conn.peer_rmbe_size = bufsize;
 	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
 	smc->conn.tx_off = bufsize * (smc->conn.peer_rmbe_idx - 1);
@@ -448,10 +448,10 @@ static void smcr_conn_save_peer_info(struct smc_sock *smc,
 static void smcd_conn_save_peer_info(struct smc_sock *smc,
 				     struct smc_clc_msg_accept_confirm *clc)
 {
-	int bufsize = smc_uncompress_bufsize(clc->dmbe_size);
+	int bufsize = smc_uncompress_bufsize(clc->d0.dmbe_size);
 
-	smc->conn.peer_rmbe_idx = clc->dmbe_idx;
-	smc->conn.peer_token = clc->token;
+	smc->conn.peer_rmbe_idx = clc->d0.dmbe_idx;
+	smc->conn.peer_token = clc->d0.token;
 	/* msg header takes up space in the buffer */
 	smc->conn.peer_rmbe_size = bufsize - sizeof(struct smcd_cdc_msg);
 	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
@@ -470,11 +470,11 @@ static void smc_conn_save_peer_info(struct smc_sock *smc,
 static void smc_link_save_peer_info(struct smc_link *link,
 				    struct smc_clc_msg_accept_confirm *clc)
 {
-	link->peer_qpn = ntoh24(clc->qpn);
-	memcpy(link->peer_gid, clc->lcl.gid, SMC_GID_SIZE);
-	memcpy(link->peer_mac, clc->lcl.mac, sizeof(link->peer_mac));
-	link->peer_psn = ntoh24(clc->psn);
-	link->peer_mtu = clc->qp_mtu;
+	link->peer_qpn = ntoh24(clc->r0.qpn);
+	memcpy(link->peer_gid, clc->r0.lcl.gid, SMC_GID_SIZE);
+	memcpy(link->peer_mac, clc->r0.lcl.mac, sizeof(link->peer_mac));
+	link->peer_psn = ntoh24(clc->r0.psn);
+	link->peer_mtu = clc->r0.qp_mtu;
 }
 
 static void smc_switch_to_fallback(struct smc_sock *smc)
@@ -613,8 +613,8 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	struct smc_link *link;
 
 	ini->is_smcd = false;
-	ini->ib_lcl = &aclc->lcl;
-	ini->ib_clcqpn = ntoh24(aclc->qpn);
+	ini->ib_lcl = &aclc->r0.lcl;
+	ini->ib_clcqpn = ntoh24(aclc->r0.qpn);
 	ini->first_contact_peer = aclc->hdr.flag;
 
 	mutex_lock(&smc_client_lgr_pending);
@@ -634,9 +634,11 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			struct smc_link *l = &smc->conn.lgr->lnk[i];
 
-			if (l->peer_qpn == ntoh24(aclc->qpn) &&
-			    !memcmp(l->peer_gid, &aclc->lcl.gid, SMC_GID_SIZE) &&
-			    !memcmp(l->peer_mac, &aclc->lcl.mac, sizeof(l->peer_mac))) {
+			if (l->peer_qpn == ntoh24(aclc->r0.qpn) &&
+			    !memcmp(l->peer_gid, &aclc->r0.lcl.gid,
+				    SMC_GID_SIZE) &&
+			    !memcmp(l->peer_mac, &aclc->r0.lcl.mac,
+				    sizeof(l->peer_mac))) {
 				link = l;
 				break;
 			}
@@ -707,7 +709,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 	int rc = 0;
 
 	ini->is_smcd = true;
-	ini->ism_peer_gid = aclc->gid;
+	ini->ism_peer_gid = aclc->d0.gid;
 	ini->first_contact_peer = aclc->hdr.flag;
 
 	/* there is only one lgr role for SMC-D; use server lock */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 0c8e74faf5ca..bd116e1949b9 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -497,65 +497,85 @@ int smc_clc_send_proposal(struct smc_sock *smc, int smc_type,
 	return reason_code;
 }
 
-/* send CLC CONFIRM message across internal TCP socket */
-int smc_clc_send_confirm(struct smc_sock *smc)
+/* build and send CLC CONFIRM / ACCEPT message */
+static int smc_clc_send_confirm_accept(struct smc_sock *smc,
+				       struct smc_clc_msg_accept_confirm *clc,
+				       int first_contact)
 {
 	struct smc_connection *conn = &smc->conn;
-	struct smc_clc_msg_accept_confirm cclc;
-	struct smc_link *link;
-	int reason_code = 0;
 	struct msghdr msg;
 	struct kvec vec;
-	int len;
 
 	/* send SMC Confirm CLC msg */
-	memset(&cclc, 0, sizeof(cclc));
-	cclc.hdr.type = SMC_CLC_CONFIRM;
-	cclc.hdr.version = SMC_V1;		/* SMC version */
+	clc->hdr.version = SMC_V1;		/* SMC version */
+	if (first_contact)
+		clc->hdr.flag = 1;
 	if (conn->lgr->is_smcd) {
 		/* SMC-D specific settings */
-		memcpy(cclc.hdr.eyecatcher, SMCD_EYECATCHER,
+		memcpy(clc->hdr.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
-		cclc.hdr.path = SMC_TYPE_D;
-		cclc.hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
-		cclc.gid = conn->lgr->smcd->local_gid;
-		cclc.token = conn->rmb_desc->token;
-		cclc.dmbe_size = conn->rmbe_size_short;
-		cclc.dmbe_idx = 0;
-		memcpy(&cclc.linkid, conn->lgr->id, SMC_LGR_ID_SIZE);
-		memcpy(cclc.smcd_trl.eyecatcher, SMCD_EYECATCHER,
+		clc->hdr.path = SMC_TYPE_D;
+		clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
+		clc->d0.gid = conn->lgr->smcd->local_gid;
+		clc->d0.token = conn->rmb_desc->token;
+		clc->d0.dmbe_size = conn->rmbe_size_short;
+		clc->d0.dmbe_idx = 0;
+		memcpy(&clc->d0.linkid, conn->lgr->id, SMC_LGR_ID_SIZE);
+		memcpy(clc->d0.smcd_trl.eyecatcher, SMCD_EYECATCHER,
 		       sizeof(SMCD_EYECATCHER));
 	} else {
+		struct smc_link *link = conn->lnk;
+
 		/* SMC-R specific settings */
 		link = conn->lnk;
-		memcpy(cclc.hdr.eyecatcher, SMC_EYECATCHER,
+		memcpy(clc->hdr.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
-		cclc.hdr.path = SMC_TYPE_R;
-		cclc.hdr.length = htons(SMCR_CLC_ACCEPT_CONFIRM_LEN);
-		memcpy(cclc.lcl.id_for_peer, local_systemid,
+		clc->hdr.path = SMC_TYPE_R;
+		clc->hdr.length = htons(SMCR_CLC_ACCEPT_CONFIRM_LEN);
+		memcpy(clc->r0.lcl.id_for_peer, local_systemid,
 		       sizeof(local_systemid));
-		memcpy(&cclc.lcl.gid, link->gid, SMC_GID_SIZE);
-		memcpy(&cclc.lcl.mac, &link->smcibdev->mac[link->ibport - 1],
+		memcpy(&clc->r0.lcl.gid, link->gid, SMC_GID_SIZE);
+		memcpy(&clc->r0.lcl.mac, &link->smcibdev->mac[link->ibport - 1],
 		       ETH_ALEN);
-		hton24(cclc.qpn, link->roce_qp->qp_num);
-		cclc.rmb_rkey =
+		hton24(clc->r0.qpn, link->roce_qp->qp_num);
+		clc->r0.rmb_rkey =
 			htonl(conn->rmb_desc->mr_rx[link->link_idx]->rkey);
-		cclc.rmbe_idx = 1; /* for now: 1 RMB = 1 RMBE */
-		cclc.rmbe_alert_token = htonl(conn->alert_token_local);
-		cclc.qp_mtu = min(link->path_mtu, link->peer_mtu);
-		cclc.rmbe_size = conn->rmbe_size_short;
-		cclc.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
+		clc->r0.rmbe_idx = 1; /* for now: 1 RMB = 1 RMBE */
+		clc->r0.rmbe_alert_token = htonl(conn->alert_token_local);
+		switch (clc->hdr.type) {
+		case SMC_CLC_ACCEPT:
+			clc->r0.qp_mtu = link->path_mtu;
+			break;
+		case SMC_CLC_CONFIRM:
+			clc->r0.qp_mtu = min(link->path_mtu, link->peer_mtu);
+			break;
+		}
+		clc->r0.rmbe_size = conn->rmbe_size_short;
+		clc->r0.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
 				(conn->rmb_desc->sgt[link->link_idx].sgl));
-		hton24(cclc.psn, link->psn_initial);
-		memcpy(cclc.smcr_trl.eyecatcher, SMC_EYECATCHER,
+		hton24(clc->r0.psn, link->psn_initial);
+		memcpy(clc->r0.smcr_trl.eyecatcher, SMC_EYECATCHER,
 		       sizeof(SMC_EYECATCHER));
 	}
 
 	memset(&msg, 0, sizeof(msg));
-	vec.iov_base = &cclc;
-	vec.iov_len = ntohs(cclc.hdr.length);
-	len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
-			     ntohs(cclc.hdr.length));
+	vec.iov_base = clc;
+	vec.iov_len = ntohs(clc->hdr.length);
+	return kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
+			      ntohs(clc->hdr.length));
+}
+
+/* send CLC CONFIRM message across internal TCP socket */
+int smc_clc_send_confirm(struct smc_sock *smc)
+{
+	struct smc_clc_msg_accept_confirm cclc;
+	int reason_code = 0;
+	int len;
+
+	/* send SMC Confirm CLC msg */
+	memset(&cclc, 0, sizeof(cclc));
+	cclc.hdr.type = SMC_CLC_CONFIRM;
+	len = smc_clc_send_confirm_accept(smc, &cclc, 0);
 	if (len < ntohs(cclc.hdr.length)) {
 		if (len >= 0) {
 			reason_code = -ENETUNREACH;
@@ -571,63 +591,12 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 /* send CLC ACCEPT message across internal TCP socket */
 int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact)
 {
-	struct smc_connection *conn = &new_smc->conn;
 	struct smc_clc_msg_accept_confirm aclc;
-	struct smc_link *link;
-	struct msghdr msg;
-	struct kvec vec;
 	int len;
 
 	memset(&aclc, 0, sizeof(aclc));
 	aclc.hdr.type = SMC_CLC_ACCEPT;
-	aclc.hdr.version = SMC_V1;		/* SMC version */
-	if (srv_first_contact)
-		aclc.hdr.flag = 1;
-
-	if (conn->lgr->is_smcd) {
-		/* SMC-D specific settings */
-		aclc.hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
-		memcpy(aclc.hdr.eyecatcher, SMCD_EYECATCHER,
-		       sizeof(SMCD_EYECATCHER));
-		aclc.hdr.path = SMC_TYPE_D;
-		aclc.gid = conn->lgr->smcd->local_gid;
-		aclc.token = conn->rmb_desc->token;
-		aclc.dmbe_size = conn->rmbe_size_short;
-		aclc.dmbe_idx = 0;
-		memcpy(&aclc.linkid, conn->lgr->id, SMC_LGR_ID_SIZE);
-		memcpy(aclc.smcd_trl.eyecatcher, SMCD_EYECATCHER,
-		       sizeof(SMCD_EYECATCHER));
-	} else {
-		/* SMC-R specific settings */
-		aclc.hdr.length = htons(SMCR_CLC_ACCEPT_CONFIRM_LEN);
-		memcpy(aclc.hdr.eyecatcher, SMC_EYECATCHER,
-		       sizeof(SMC_EYECATCHER));
-		aclc.hdr.path = SMC_TYPE_R;
-		link = conn->lnk;
-		memcpy(aclc.lcl.id_for_peer, local_systemid,
-		       sizeof(local_systemid));
-		memcpy(&aclc.lcl.gid, link->gid, SMC_GID_SIZE);
-		memcpy(&aclc.lcl.mac, link->smcibdev->mac[link->ibport - 1],
-		       ETH_ALEN);
-		hton24(aclc.qpn, link->roce_qp->qp_num);
-		aclc.rmb_rkey =
-			htonl(conn->rmb_desc->mr_rx[link->link_idx]->rkey);
-		aclc.rmbe_idx = 1;		/* as long as 1 RMB = 1 RMBE */
-		aclc.rmbe_alert_token = htonl(conn->alert_token_local);
-		aclc.qp_mtu = link->path_mtu;
-		aclc.rmbe_size = conn->rmbe_size_short,
-		aclc.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
-				(conn->rmb_desc->sgt[link->link_idx].sgl));
-		hton24(aclc.psn, link->psn_initial);
-		memcpy(aclc.smcr_trl.eyecatcher, SMC_EYECATCHER,
-		       sizeof(SMC_EYECATCHER));
-	}
-
-	memset(&msg, 0, sizeof(msg));
-	vec.iov_base = &aclc;
-	vec.iov_len = ntohs(aclc.hdr.length);
-	len = kernel_sendmsg(new_smc->clcsock, &msg, &vec, 1,
-			     ntohs(aclc.hdr.length));
+	len = smc_clc_send_confirm_accept(new_smc, &aclc, srv_first_contact);
 	if (len < ntohs(aclc.hdr.length))
 		len = len >= 0 ? -EPROTO : -new_smc->clcsock->sk->sk_err;
 
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 7f7c55ff0476..fda474e91f95 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -118,46 +118,50 @@ struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_trail		pclc_trl;
 };
 
-struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
-	struct smc_clc_msg_hdr hdr;
-	union {
-		struct { /* SMC-R */
-			struct smc_clc_msg_local lcl;
-			u8 qpn[3];		/* QP number */
-			__be32 rmb_rkey;	/* RMB rkey */
-			u8 rmbe_idx;		/* Index of RMBE in RMB */
-			__be32 rmbe_alert_token;/* unique connection id */
-#if defined(__BIG_ENDIAN_BITFIELD)
-			u8 rmbe_size : 4,	/* buf size (compressed) */
-			   qp_mtu   : 4;	/* QP mtu */
+struct smcr_clc_msg_accept_confirm {	/* SMCR accept/confirm */
+	struct smc_clc_msg_local lcl;
+	u8 qpn[3];			/* QP number */
+	__be32 rmb_rkey;		/* RMB rkey */
+	u8 rmbe_idx;			/* Index of RMBE in RMB */
+	__be32 rmbe_alert_token;	/* unique connection id */
+ #if defined(__BIG_ENDIAN_BITFIELD)
+	u8 rmbe_size : 4,		/* buf size (compressed) */
+	   qp_mtu   : 4;		/* QP mtu */
 #elif defined(__LITTLE_ENDIAN_BITFIELD)
-			u8 qp_mtu   : 4,
-			   rmbe_size : 4;
+	u8 qp_mtu   : 4,
+	   rmbe_size : 4;
 #endif
-			u8 reserved;
-			__be64 rmb_dma_addr;	/* RMB virtual address */
-			u8 reserved2;
-			u8 psn[3];		/* packet sequence number */
-			struct smc_clc_msg_trail smcr_trl;
-						/* eye catcher "SMCR" EBCDIC */
-		} __packed;
-		struct { /* SMC-D */
-			u64 gid;		/* Sender GID */
-			u64 token;		/* DMB token */
-			u8 dmbe_idx;		/* DMBE index */
+	u8 reserved;
+	__be64 rmb_dma_addr;	/* RMB virtual address */
+	u8 reserved2;
+	u8 psn[3];		/* packet sequence number */
+	struct smc_clc_msg_trail smcr_trl;
+				/* eye catcher "SMCR" EBCDIC */
+} __packed;
+
+struct smcd_clc_msg_accept_confirm {	/* SMCD accept/confirm */
+	u64 gid;		/* Sender GID */
+	u64 token;		/* DMB token */
+	u8 dmbe_idx;		/* DMBE index */
 #if defined(__BIG_ENDIAN_BITFIELD)
-			u8 dmbe_size : 4,	/* buf size (compressed) */
-			   reserved3 : 4;
+	u8 dmbe_size : 4,	/* buf size (compressed) */
+	   reserved3 : 4;
 #elif defined(__LITTLE_ENDIAN_BITFIELD)
-			u8 reserved3 : 4,
-			   dmbe_size : 4;
+	u8 reserved3 : 4,
+	   dmbe_size : 4;
 #endif
-			u16 reserved4;
-			u32 linkid;		/* Link identifier */
-			u32 reserved5[3];
-			struct smc_clc_msg_trail smcd_trl;
-						/* eye catcher "SMCD" EBCDIC */
-		} __packed;
+	u16 reserved4;
+	u32 linkid;		/* Link identifier */
+	u32 reserved5[3];
+	struct smc_clc_msg_trail smcd_trl;
+				/* eye catcher "SMCD" EBCDIC */
+} __packed;
+
+struct smc_clc_msg_accept_confirm {	/* clc accept / confirm message */
+	struct smc_clc_msg_hdr hdr;
+	union {
+		struct smcr_clc_msg_accept_confirm r0; /* SMC-R */
+		struct smcd_clc_msg_accept_confirm d0; /* SMC-D */
 	};
 } __packed;			/* format defined in RFC7609 */
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c02e58002782..0c6dfca7f0c7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1892,8 +1892,8 @@ int smc_rmb_rtoken_handling(struct smc_connection *conn,
 			    struct smc_link *lnk,
 			    struct smc_clc_msg_accept_confirm *clc)
 {
-	conn->rtoken_idx = smc_rtoken_add(lnk, clc->rmb_dma_addr,
-					  clc->rmb_rkey);
+	conn->rtoken_idx = smc_rtoken_add(lnk, clc->r0.rmb_dma_addr,
+					  clc->r0.rmb_rkey);
 	if (conn->rtoken_idx < 0)
 		return conn->rtoken_idx;
 	return 0;
-- 
2.17.1

