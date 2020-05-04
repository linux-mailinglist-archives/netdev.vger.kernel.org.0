Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE91C3933
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgEDMTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728748AbgEDMTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CCgKH157080;
        Mon, 4 May 2020 08:19:15 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4r2sheu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9o49004037;
        Mon, 4 May 2020 12:19:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g59x8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJAJh60358682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62F5CA4055;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33ADDA4057;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 11/12] net/smc: create improved SMC-R link_uid
Date:   Mon,  4 May 2020 14:18:47 +0200
Message-Id: <20200504121848.46585-12-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_07:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=1 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link_uid of an SMC-R link is exchanged between SMC peers and its
value can be used for debugging purposes. Create a unique link_uid
during link initialization and use it in communication with SMC-R peers.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  1 +
 net/smc/smc_core.h |  4 +++-
 net/smc/smc_llc.c  | 18 ++++++++++++++----
 net/smc/smc_llc.h  |  1 +
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fb391bc6781e..fb5f685ff494 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -331,6 +331,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->smcibdev = ini->ib_dev;
 	lnk->ibport = ini->ib_port;
 	lnk->path_mtu = ini->ib_dev->pattr[ini->ib_port - 1].active_mtu;
+	smc_llc_link_set_uid(lnk);
 	INIT_WORK(&lnk->link_down_wrk, smc_link_down_work);
 	if (!ini->ib_dev->initialized) {
 		rc = (int)smc_ib_setup_per_ibdev(ini->ib_dev);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 32bc45af9a1a..e2ace20db7fd 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -70,6 +70,8 @@ struct smc_rdma_wr {				/* work requests per message
 	struct ib_rdma_wr	wr_tx_rdma[SMC_MAX_RDMA_WRITES];
 };
 
+#define SMC_LGR_ID_SIZE		4
+
 struct smc_link {
 	struct smc_ib_device	*smcibdev;	/* ib-device */
 	u8			ibport;		/* port - values 1 | 2 */
@@ -116,6 +118,7 @@ struct smc_link {
 	u8			peer_mac[ETH_ALEN];	/* = gid[8:10||13:15] */
 	u8			peer_gid[SMC_GID_SIZE];	/* gid of peer*/
 	u8			link_id;	/* unique # within link group */
+	u8			link_uid[SMC_LGR_ID_SIZE]; /* unique lnk id */
 	u8			link_idx;	/* index in lgr link array */
 	u8			link_is_asym;	/* is link asymmetric? */
 	struct smc_link_group	*lgr;		/* parent link group */
@@ -178,7 +181,6 @@ struct smc_rtoken {				/* address/key of remote RMB */
 	u32			rkey;
 };
 
-#define SMC_LGR_ID_SIZE		4
 #define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
 #define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
 /* theoretically, the RFC states that largest size would be 512K,
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 482acf80e26e..afb889d60881 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -361,7 +361,6 @@ static int smc_llc_add_pending_send(struct smc_link *link,
 int smc_llc_send_confirm_link(struct smc_link *link,
 			      enum smc_llc_reqresp reqresp)
 {
-	struct smc_link_group *lgr = smc_get_lgr(link);
 	struct smc_llc_msg_confirm_link *confllc;
 	struct smc_wr_tx_pend_priv *pend;
 	struct smc_wr_buf *wr_buf;
@@ -382,7 +381,7 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	memcpy(confllc->sender_gid, link->gid, SMC_GID_SIZE);
 	hton24(confllc->sender_qp_num, link->roce_qp->qp_num);
 	confllc->link_num = link->link_id;
-	memcpy(confllc->link_uid, lgr->id, SMC_LGR_ID_SIZE);
+	memcpy(confllc->link_uid, link->link_uid, SMC_LGR_ID_SIZE);
 	confllc->max_links = SMC_LLC_ADD_LNK_MAX_LINKS;
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
@@ -845,7 +844,8 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	if (rc)
 		goto out_reject;
 	smc_llc_save_add_link_info(lnk_new, llc);
-	lnk_new->link_id = llc->link_num;
+	lnk_new->link_id = llc->link_num;	/* SMC server assigns link id */
+	smc_llc_link_set_uid(lnk_new);
 
 	rc = smc_ib_ready_link(lnk_new);
 	if (rc)
@@ -1775,12 +1775,22 @@ int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
 	return rc;
 }
 
+void smc_llc_link_set_uid(struct smc_link *link)
+{
+	__be32 link_uid;
+
+	link_uid = htonl(*((u32 *)link->lgr->id) + link->link_id);
+	memcpy(link->link_uid, &link_uid, SMC_LGR_ID_SIZE);
+}
+
 /* evaluate confirm link request or response */
 int smc_llc_eval_conf_link(struct smc_llc_qentry *qentry,
 			   enum smc_llc_reqresp type)
 {
-	if (type == SMC_LLC_REQ)	/* SMC server assigns link_id */
+	if (type == SMC_LLC_REQ) {	/* SMC server assigns link_id */
 		qentry->link->link_id = qentry->msg.confirm_link.link_num;
+		smc_llc_link_set_uid(qentry->link);
+	}
 	if (!(qentry->msg.raw.hdr.flags & SMC_LLC_FLAG_NO_RMBE_EYEC))
 		return -ENOTSUPP;
 	return 0;
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index f5882ebf357b..1b68f229cb99 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -92,6 +92,7 @@ int smc_llc_flow_initiate(struct smc_link_group *lgr,
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow);
 int smc_llc_eval_conf_link(struct smc_llc_qentry *qentry,
 			   enum smc_llc_reqresp type);
+void smc_llc_link_set_uid(struct smc_link *link);
 struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 				    struct smc_link *lnk,
 				    int time_out, u8 exp_msg);
-- 
2.17.1

