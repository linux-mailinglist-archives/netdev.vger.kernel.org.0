Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE31C3931
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgEDMT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728754AbgEDMTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CAOBQ065387;
        Mon, 4 May 2020 08:19:15 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g1m329-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:15 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9pp4005720;
        Mon, 4 May 2020 12:19:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5hwny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJA3D2621768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B18A3A404D;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7893EA4040;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:10 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 12/12] net/smc: save SMC-R peer link_uid
Date:   Mon,  4 May 2020 14:18:48 +0200
Message-Id: <20200504121848.46585-13-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_06:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=1 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During SMC-R link establishment the peers exchange the link_uid that
is used for debugging purposes. Save the peer link_uid in smc_link so it
can be retrieved by the smc_diag netlink interface.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   | 2 ++
 net/smc/smc_core.h | 1 +
 net/smc/smc_llc.c  | 9 +++++++++
 net/smc/smc_llc.h  | 1 +
 4 files changed, 13 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c67272007f41..4e4421c95ca1 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -390,6 +390,7 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 				      SMC_CLC_DECLINE, CLC_WAIT_TIME_SHORT);
 		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_CL : rc;
 	}
+	smc_llc_save_peer_uid(qentry);
 	rc = smc_llc_eval_conf_link(qentry, SMC_LLC_REQ);
 	smc_llc_flow_qentry_del(&link->lgr->llc_flow_lcl);
 	if (rc)
@@ -1056,6 +1057,7 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 				      SMC_CLC_DECLINE, CLC_WAIT_TIME_SHORT);
 		return rc == -EAGAIN ? SMC_CLC_DECL_TIMEOUT_CL : rc;
 	}
+	smc_llc_save_peer_uid(qentry);
 	rc = smc_llc_eval_conf_link(qentry, SMC_LLC_RESP);
 	smc_llc_flow_qentry_del(&link->lgr->llc_flow_lcl);
 	if (rc)
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index e2ace20db7fd..4ae76802214f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -119,6 +119,7 @@ struct smc_link {
 	u8			peer_gid[SMC_GID_SIZE];	/* gid of peer*/
 	u8			link_id;	/* unique # within link group */
 	u8			link_uid[SMC_LGR_ID_SIZE]; /* unique lnk id */
+	u8			peer_link_uid[SMC_LGR_ID_SIZE]; /* peer uid */
 	u8			link_idx;	/* index in lgr link array */
 	u8			link_is_asym;	/* is link asymmetric? */
 	struct smc_link_group	*lgr;		/* parent link group */
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index afb889d60881..66ddc9cf5e2f 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -770,6 +770,7 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 		return -ENOLINK;
 	}
+	smc_llc_save_peer_uid(qentry);
 	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 
 	rc = smc_ib_modify_qp_rts(link_new);
@@ -1041,6 +1042,7 @@ static int smc_llc_srv_conf_link(struct smc_link *link,
 					 false, SMC_LLC_DEL_LOST_PATH);
 		return -ENOLINK;
 	}
+	smc_llc_save_peer_uid(qentry);
 	smc_llc_link_active(link_new);
 	if (lgr_new_t == SMC_LGR_ASYMMETRIC_LOCAL ||
 	    lgr_new_t == SMC_LGR_ASYMMETRIC_PEER)
@@ -1783,6 +1785,13 @@ void smc_llc_link_set_uid(struct smc_link *link)
 	memcpy(link->link_uid, &link_uid, SMC_LGR_ID_SIZE);
 }
 
+/* save peers link user id, used for debug purposes */
+void smc_llc_save_peer_uid(struct smc_llc_qentry *qentry)
+{
+	memcpy(qentry->link->peer_link_uid, qentry->msg.confirm_link.link_uid,
+	       SMC_LGR_ID_SIZE);
+}
+
 /* evaluate confirm link request or response */
 int smc_llc_eval_conf_link(struct smc_llc_qentry *qentry,
 			   enum smc_llc_reqresp type)
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 1b68f229cb99..55287376112d 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -93,6 +93,7 @@ void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow);
 int smc_llc_eval_conf_link(struct smc_llc_qentry *qentry,
 			   enum smc_llc_reqresp type);
 void smc_llc_link_set_uid(struct smc_link *link);
+void smc_llc_save_peer_uid(struct smc_llc_qentry *qentry);
 struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 				    struct smc_link *lnk,
 				    int time_out, u8 exp_msg);
-- 
2.17.1

