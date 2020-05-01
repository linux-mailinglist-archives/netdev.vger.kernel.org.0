Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1E11C1127
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgEAKsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728614AbgEAKsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:32 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AWOo3014885;
        Fri, 1 May 2020 06:48:29 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r84me1rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:29 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041AjtRI028243;
        Fri, 1 May 2020 10:48:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu5bfbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmPXR18284634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33834A405B;
        Fri,  1 May 2020 10:48:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC1DAA4065;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 09/13] net/smc: take link down instead of terminating the link group
Date:   Fri,  1 May 2020 12:48:09 +0200
Message-Id: <20200501104813.76601-10-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=3
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the introduced link down processing in all places where the link
group is terminated and take down the affected link only.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |  7 ++-----
 net/smc/smc_llc.c  |  4 ++--
 net/smc/smc_tx.c   |  2 +-
 net/smc/smc_wr.c   | 19 ++++++++-----------
 4 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 62108e0cd529..849ae3f9b796 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -884,11 +884,8 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 	} else {
 		list_for_each_entry_safe(lgr, lg, &smc_lgr_list.list, list) {
 			for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-				if (lgr->lnk[i].smcibdev == smcibdev) {
-					list_move(&lgr->list, &lgr_free_list);
-					lgr->freeing = 1;
-					break;
-				}
+				if (lgr->lnk[i].smcibdev == smcibdev)
+					smcr_link_down_cond_sched(&lgr->lnk[i]);
 			}
 		}
 	}
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index ceed3c89926f..e478a4c11877 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -556,7 +556,7 @@ static void smc_llc_rx_delete_link(struct smc_link *link,
 		smc_llc_send_delete_link(link, 0, SMC_LLC_RESP, true,
 					 SMC_LLC_DEL_PROG_INIT_TERM);
 	}
-	smc_lgr_terminate_sched(lgr);
+	smcr_link_down_cond(link);
 }
 
 /* process a confirm_rkey request from peer, remote flow */
@@ -831,7 +831,7 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	if (link->state != SMC_LNK_ACTIVE)
 		return;		/* link state changed */
 	if (rc <= 0) {
-		smc_lgr_terminate_sched(smc_get_lgr(link));
+		smcr_link_down_cond_sched(link);
 		return;
 	}
 	next_interval = link->llc_testlink_time;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index d74bfe6a90f1..417204572a69 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -283,7 +283,7 @@ static int smc_tx_rdma_write(struct smc_connection *conn, int peer_rmbe_offset,
 	rdma_wr->rkey = lgr->rtokens[conn->rtoken_idx][link->link_idx].rkey;
 	rc = ib_post_send(link->roce_qp, &rdma_wr->wr, NULL);
 	if (rc)
-		smc_lgr_terminate_sched(lgr);
+		smcr_link_down_cond_sched(link);
 	return rc;
 }
 
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 93223628c002..031e6c9561b1 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -120,8 +120,8 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 			       sizeof(link->wr_tx_bufs[i]));
 			clear_bit(i, link->wr_tx_mask);
 		}
-		/* terminate connections of this link group abnormally */
-		smc_lgr_terminate_sched(smc_get_lgr(link));
+		/* terminate link */
+		smcr_link_down_cond_sched(link);
 	}
 	if (pnd_snd.handler)
 		pnd_snd.handler(&pnd_snd.priv, link, wc->status);
@@ -212,8 +212,8 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
 			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
 		if (!rc) {
-			/* timeout - terminate connections */
-			smc_lgr_terminate_sched(lgr);
+			/* timeout - terminate link */
+			smcr_link_down_cond_sched(link);
 			return -EPIPE;
 		}
 		if (idx == link->wr_tx_cnt)
@@ -270,7 +270,7 @@ int smc_wr_tx_send(struct smc_link *link, struct smc_wr_tx_pend_priv *priv)
 	rc = ib_post_send(link->roce_qp, &link->wr_tx_ibs[pend->idx], NULL);
 	if (rc) {
 		smc_wr_tx_put_slot(link, priv);
-		smc_lgr_terminate_sched(smc_get_lgr(link));
+		smcr_link_down_cond_sched(link);
 	}
 	return rc;
 }
@@ -294,8 +294,8 @@ int smc_wr_reg_send(struct smc_link *link, struct ib_mr *mr)
 					      (link->wr_reg_state != POSTED),
 					      SMC_WR_REG_MR_WAIT_TIME);
 	if (!rc) {
-		/* timeout - terminate connections */
-		smc_lgr_terminate_sched(smc_get_lgr(link));
+		/* timeout - terminate link */
+		smcr_link_down_cond_sched(link);
 		return -EPIPE;
 	}
 	if (rc == -ERESTARTSYS)
@@ -393,10 +393,7 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 			case IB_WC_RETRY_EXC_ERR:
 			case IB_WC_RNR_RETRY_EXC_ERR:
 			case IB_WC_WR_FLUSH_ERR:
-				/* terminate connections of this link group
-				 * abnormally
-				 */
-				smc_lgr_terminate_sched(smc_get_lgr(link));
+				smcr_link_down_cond_sched(link);
 				break;
 			default:
 				smc_wr_rx_post(link); /* refill WR RX */
-- 
2.17.1

