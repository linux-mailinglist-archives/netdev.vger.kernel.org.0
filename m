Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D0C1C1131
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgEAKs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728607AbgEAKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:31 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AX8JM014754;
        Fri, 1 May 2020 06:48:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r7m2eyag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041Ak62C026480;
        Fri, 1 May 2020 10:48:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5vh5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmNBV64094714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DBA4A405C;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58019A4060;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 04/13] net/smc: extend smc_llc_send_add_link() and smc_llc_send_delete_link()
Date:   Fri,  1 May 2020 12:48:04 +0200
Message-Id: <20200501104813.76601-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=1
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All LLC sends are done from worker context only, so remove the prep
functions which were used to build the message before it was sent, and
add the function content into the respective send function
smc_llc_send_add_link() and smc_llc_send_delete_link().
Extend smc_llc_send_add_link() to include the qp_mtu value in the LLC
message, which is needed to establish a link after the initial link was
created. Extend smc_llc_send_delete_link() to contain a link_id and a
reason code for the link deletion in the LLC message, which is needed
when a specific link should be deleted.
And add the list of existing DELETE_LINK reason codes.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  3 +-
 net/smc/smc_llc.c  | 89 ++++++++++++++++++++++++----------------------
 net/smc/smc_llc.h  | 16 +++++++--
 3 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 0e87f652caea..c905675017c7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -199,7 +199,8 @@ void smc_lgr_cleanup_early(struct smc_connection *conn)
 static int smcr_link_send_delete(struct smc_link *lnk, bool orderly)
 {
 	if (lnk->state == SMC_LNK_ACTIVE &&
-	    !smc_llc_send_delete_link(lnk, SMC_LLC_REQ, orderly)) {
+	    !smc_llc_send_delete_link(lnk, 0, SMC_LLC_REQ, orderly,
+				      SMC_LLC_DEL_PROG_INIT_TERM)) {
 		return 0;
 	}
 	return -ENOTCONN;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 327cf30b98cc..171835926db6 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -58,7 +58,13 @@ struct smc_llc_msg_add_link {		/* type 0x02 */
 	u8 sender_gid[SMC_GID_SIZE];
 	u8 sender_qp_num[3];
 	u8 link_num;
-	u8 flags2;	/* QP mtu */
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8 reserved3 : 4,
+	   qp_mtu   : 4;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 qp_mtu   : 4,
+	   reserved3 : 4;
+#endif
 	u8 initial_psn[3];
 	u8 reserved[8];
 };
@@ -427,26 +433,9 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	return rc;
 }
 
-/* prepare an add link message */
-static void smc_llc_prep_add_link(struct smc_llc_msg_add_link *addllc,
-				  struct smc_link *link, u8 mac[], u8 gid[],
-				  enum smc_llc_reqresp reqresp)
-{
-	memset(addllc, 0, sizeof(*addllc));
-	addllc->hd.common.type = SMC_LLC_ADD_LINK;
-	addllc->hd.length = sizeof(struct smc_llc_msg_add_link);
-	if (reqresp == SMC_LLC_RESP) {
-		addllc->hd.flags |= SMC_LLC_FLAG_RESP;
-		/* always reject more links for now */
-		addllc->hd.flags |= SMC_LLC_FLAG_ADD_LNK_REJ;
-		addllc->hd.add_link_rej_rsn = SMC_LLC_REJ_RSN_NO_ALT_PATH;
-	}
-	memcpy(addllc->sender_mac, mac, ETH_ALEN);
-	memcpy(addllc->sender_gid, gid, SMC_GID_SIZE);
-}
-
 /* send ADD LINK request or response */
 int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
+			  struct smc_link *link_new,
 			  enum smc_llc_reqresp reqresp)
 {
 	struct smc_llc_msg_add_link *addllc;
@@ -458,32 +447,33 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 	if (rc)
 		return rc;
 	addllc = (struct smc_llc_msg_add_link *)wr_buf;
-	smc_llc_prep_add_link(addllc, link, mac, gid, reqresp);
+
+	memset(addllc, 0, sizeof(*addllc));
+	addllc->hd.common.type = SMC_LLC_ADD_LINK;
+	addllc->hd.length = sizeof(struct smc_llc_msg_add_link);
+	if (reqresp == SMC_LLC_RESP)
+		addllc->hd.flags |= SMC_LLC_FLAG_RESP;
+	memcpy(addllc->sender_mac, mac, ETH_ALEN);
+	memcpy(addllc->sender_gid, gid, SMC_GID_SIZE);
+	if (link_new) {
+		addllc->link_num = link_new->link_id;
+		hton24(addllc->sender_qp_num, link_new->roce_qp->qp_num);
+		hton24(addllc->initial_psn, link_new->psn_initial);
+		if (reqresp == SMC_LLC_REQ)
+			addllc->qp_mtu = link_new->path_mtu;
+		else
+			addllc->qp_mtu = min(link_new->path_mtu,
+					     link_new->peer_mtu);
+	}
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
 	return rc;
 }
 
-/* prepare a delete link message */
-static void smc_llc_prep_delete_link(struct smc_llc_msg_del_link *delllc,
-				     struct smc_link *link,
-				     enum smc_llc_reqresp reqresp, bool orderly)
-{
-	memset(delllc, 0, sizeof(*delllc));
-	delllc->hd.common.type = SMC_LLC_DELETE_LINK;
-	delllc->hd.length = sizeof(struct smc_llc_msg_add_link);
-	if (reqresp == SMC_LLC_RESP)
-		delllc->hd.flags |= SMC_LLC_FLAG_RESP;
-	/* DEL_LINK_ALL because only 1 link supported */
-	delllc->hd.flags |= SMC_LLC_FLAG_DEL_LINK_ALL;
-	if (orderly)
-		delllc->hd.flags |= SMC_LLC_FLAG_DEL_LINK_ORDERLY;
-	delllc->link_num = link->link_id;
-}
-
 /* send DELETE LINK request or response */
-int smc_llc_send_delete_link(struct smc_link *link,
-			     enum smc_llc_reqresp reqresp, bool orderly)
+int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
+			     enum smc_llc_reqresp reqresp, bool orderly,
+			     u32 reason)
 {
 	struct smc_llc_msg_del_link *delllc;
 	struct smc_wr_tx_pend_priv *pend;
@@ -494,7 +484,19 @@ int smc_llc_send_delete_link(struct smc_link *link,
 	if (rc)
 		return rc;
 	delllc = (struct smc_llc_msg_del_link *)wr_buf;
-	smc_llc_prep_delete_link(delllc, link, reqresp, orderly);
+
+	memset(delllc, 0, sizeof(*delllc));
+	delllc->hd.common.type = SMC_LLC_DELETE_LINK;
+	delllc->hd.length = sizeof(struct smc_llc_msg_del_link);
+	if (reqresp == SMC_LLC_RESP)
+		delllc->hd.flags |= SMC_LLC_FLAG_RESP;
+	if (orderly)
+		delllc->hd.flags |= SMC_LLC_FLAG_DEL_LINK_ORDERLY;
+	if (link_del_id)
+		delllc->link_num = link_del_id;
+	else
+		delllc->hd.flags |= SMC_LLC_FLAG_DEL_LINK_ALL;
+	delllc->reason = htonl(reason);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
 	return rc;
@@ -547,12 +549,13 @@ static void smc_llc_rx_delete_link(struct smc_link *link,
 	smc_lgr_forget(lgr);
 	if (lgr->role == SMC_SERV) {
 		/* client asks to delete this link, send request */
-		smc_llc_prep_delete_link(llc, link, SMC_LLC_REQ, true);
+		smc_llc_send_delete_link(link, 0, SMC_LLC_REQ, true,
+					 SMC_LLC_DEL_PROG_INIT_TERM);
 	} else {
 		/* server requests to delete this link, send response */
-		smc_llc_prep_delete_link(llc, link, SMC_LLC_RESP, true);
+		smc_llc_send_delete_link(link, 0, SMC_LLC_RESP, true,
+					 SMC_LLC_DEL_PROG_INIT_TERM);
 	}
-	smc_llc_send_message(link, llc);
 	smc_lgr_terminate_sched(lgr);
 }
 
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 48029a5e14c3..d2c50d3e43a6 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -35,6 +35,16 @@ enum smc_llc_msg_type {
 	SMC_LLC_DELETE_RKEY		= 0x09,
 };
 
+/* LLC DELETE LINK Request Reason Codes */
+#define SMC_LLC_DEL_LOST_PATH		0x00010000
+#define SMC_LLC_DEL_OP_INIT_TERM	0x00020000
+#define SMC_LLC_DEL_PROG_INIT_TERM	0x00030000
+#define SMC_LLC_DEL_PROT_VIOL		0x00040000
+#define SMC_LLC_DEL_NO_ASYM_NEEDED	0x00050000
+/* LLC DELETE LINK Response Reason Codes */
+#define SMC_LLC_DEL_NOLNK	0x00100000  /* Unknown Link ID (no link) */
+#define SMC_LLC_DEL_NOLGR	0x00200000  /* Unknown Link Group */
+
 /* returns a usable link of the link group, or NULL */
 static inline struct smc_link *smc_llc_usable_link(struct smc_link_group *lgr)
 {
@@ -50,9 +60,11 @@ static inline struct smc_link *smc_llc_usable_link(struct smc_link_group *lgr)
 int smc_llc_send_confirm_link(struct smc_link *lnk,
 			      enum smc_llc_reqresp reqresp);
 int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
+			  struct smc_link *link_new,
 			  enum smc_llc_reqresp reqresp);
-int smc_llc_send_delete_link(struct smc_link *link,
-			     enum smc_llc_reqresp reqresp, bool orderly);
+int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
+			     enum smc_llc_reqresp reqresp, bool orderly,
+			     u32 reason);
 void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc);
 void smc_llc_lgr_clear(struct smc_link_group *lgr);
 int smc_llc_link_init(struct smc_link *link);
-- 
2.17.1

