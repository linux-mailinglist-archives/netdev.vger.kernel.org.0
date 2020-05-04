Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0153B1C393A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgEDMTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728743AbgEDMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:16 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044C2AhU063356;
        Mon, 4 May 2020 08:19:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28f4f92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9rSX011619;
        Mon, 4 May 2020 12:19:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5mr17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ9fk11338050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD404A4053;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D0E2A4055;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 09/12] net/smc: add termination reason and handle LLC protocol violation
Date:   Mon,  4 May 2020 14:18:45 +0200
Message-Id: <20200504121848.46585-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_06:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=3
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to set the reason code for the link group termination, and set
meaningful values before termination processing is triggered. This
reason code is sent to the peer in the final delete link message.
When the LLC request or response layer receives a message type that was
not handled, drop a warning and terminate the link group.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  8 ++++++--
 net/smc/smc_core.h |  2 ++
 net/smc/smc_llc.c  | 14 ++++++++++++++
 net/smc/smc_llc.h  |  8 ++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index be15b30a1234..b6f93b44f9c7 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -878,8 +878,11 @@ static void smc_lgr_cleanup(struct smc_link_group *lgr)
 		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
 		put_device(&lgr->smcd->dev);
 	} else {
-		smc_llc_send_link_delete_all(lgr, false,
-					     SMC_LLC_DEL_OP_INIT_TERM);
+		u32 rsn = lgr->llc_termination_rsn;
+
+		if (!rsn)
+			rsn = SMC_LLC_DEL_PROG_INIT_TERM;
+		smc_llc_send_link_delete_all(lgr, false, rsn);
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			struct smc_link *lnk = &lgr->lnk[i];
 
@@ -1018,6 +1021,7 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 
 	list_for_each_entry_safe(lgr, lg, &lgr_free_list, list) {
 		list_del_init(&lgr->list);
+		smc_llc_set_termination_rsn(lgr, SMC_LLC_DEL_OP_INIT_TERM);
 		__smc_lgr_terminate(lgr, false);
 	}
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 6ed7ab6d89d5..32bc45af9a1a 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -271,6 +271,8 @@ struct smc_link_group {
 						/* protects llc flow */
 			int			llc_testlink_time;
 						/* link keep alive time */
+			u32			llc_termination_rsn;
+						/* rsn code for termination */
 		};
 		struct { /* SMC-D */
 			u64			peer_gid;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index f65b2aac6b52..482acf80e26e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1420,6 +1420,14 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
 }
 
+static void smc_llc_protocol_violation(struct smc_link_group *lgr, u8 type)
+{
+	pr_warn_ratelimited("smc: SMC-R lg %*phN LLC protocol violation: "
+			    "llc_type %d\n", SMC_LGR_ID_SIZE, &lgr->id, type);
+	smc_llc_set_termination_rsn(lgr, SMC_LLC_DEL_PROT_VIOL);
+	smc_lgr_terminate_sched(lgr);
+}
+
 /* flush the llc event queue */
 static void smc_llc_event_flush(struct smc_link_group *lgr)
 {
@@ -1520,6 +1528,9 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_rmt);
 		}
 		return;
+	default:
+		smc_llc_protocol_violation(lgr, llc->raw.hdr.common.type);
+		break;
 	}
 out:
 	kfree(qentry);
@@ -1579,6 +1590,9 @@ static void smc_llc_rx_response(struct smc_link *link,
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* not used because max links is 3 */
 		break;
+	default:
+		smc_llc_protocol_violation(link->lgr, llc_type);
+		break;
 	}
 	kfree(qentry);
 }
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 6d2a5d943b83..f5882ebf357b 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -60,6 +60,14 @@ static inline struct smc_link *smc_llc_usable_link(struct smc_link_group *lgr)
 	return NULL;
 }
 
+/* set the termination reason code for the link group */
+static inline void smc_llc_set_termination_rsn(struct smc_link_group *lgr,
+					       u32 rsn)
+{
+	if (!lgr->llc_termination_rsn)
+		lgr->llc_termination_rsn = rsn;
+}
+
 /* transmit */
 int smc_llc_send_confirm_link(struct smc_link *lnk,
 			      enum smc_llc_reqresp reqresp);
-- 
2.17.1

