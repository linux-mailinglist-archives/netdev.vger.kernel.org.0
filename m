Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3C942DF81
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhJNQuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:50:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231255AbhJNQut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:50:49 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EGLG5Z030811;
        Thu, 14 Oct 2021 12:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1UxyJGpNjoV6fggfbhGauZKTMB4VXC+Kve8T4Pb1+Is=;
 b=K/Ut90tIkE4Oc/yfH8AO4YVcSfDYoo84YP7WwlNuGMEy/mnEw/SDsExB5UmRgx5amaBg
 Wivt1sZcN8/j2dW/ZP0It/l0cuBzv3IkZmbHYp+lIggxqi3YawcQtU/7MZsLR//pNB0S
 3/w8J0rMrB8/hljwjPmAo7RMnx0xLk3ZLUb0SBW4HQoQOjhkCD5/fyalLFh3Tn4AwCy1
 Zl+ypCNPzflVvVTgXnIDvkWbkCi3f2ZcHQT+u0UCVQWwlW9HqsjTF8iKVoKexk6AGKcE
 W/OHONsFzBM37jz4xhXh3SSZNP36HwyxIWLGD8E/hmCTepBcfMMQoTFAEsTTxTYb+tkT BA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnmnaq3a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:48:43 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EGbfG3012978;
        Thu, 14 Oct 2021 16:48:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3bk2qacgv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 16:48:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EGmbDJ66912582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 16:48:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EC25A405C;
        Thu, 14 Oct 2021 16:48:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F154AA406A;
        Thu, 14 Oct 2021 16:48:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 16:48:36 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 01/11] net/smc: improved fix wait on already cleared link
Date:   Thu, 14 Oct 2021 18:47:42 +0200
Message-Id: <20211014164752.3647027-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211014164752.3647027-1-kgraul@linux.ibm.com>
References: <20211014164752.3647027-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RqlafseXHGxBUq8c8LcMDNwQ4AGLtaHD
X-Proofpoint-ORIG-GUID: RqlafseXHGxBUq8c8LcMDNwQ4AGLtaHD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8f3d65c16679 ("net/smc: fix wait on already cleared link")
introduced link refcounting to avoid waits on already cleared links.
This patch extents and improves the refcounting to cover all
remaining possible cases for this kind of error situation.

Fixes: 15e1b99aadfb ("net/smc: no WR buffer wait for terminating link group")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_cdc.c  |  7 +++++-
 net/smc/smc_core.c | 20 ++++++++-------
 net/smc/smc_llc.c  | 63 +++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_tx.c   | 22 ++++------------
 net/smc/smc_wr.h   | 14 +++++++++++
 5 files changed, 85 insertions(+), 41 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index f23f558054a7..99acd337ba90 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -150,9 +150,11 @@ static int smcr_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 
 again:
 	link = conn->lnk;
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, NULL, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 
 	spin_lock_bh(&conn->send_lock);
 	if (link != conn->lnk) {
@@ -160,6 +162,7 @@ static int smcr_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 		spin_unlock_bh(&conn->send_lock);
 		smc_wr_tx_put_slot(link,
 				   (struct smc_wr_tx_pend_priv *)pend);
+		smc_wr_tx_link_put(link);
 		if (again)
 			return -ENOLINK;
 		again = true;
@@ -167,6 +170,8 @@ static int smcr_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 	}
 	rc = smc_cdc_msg_send(conn, wr_buf, pend);
 	spin_unlock_bh(&conn->send_lock);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index f57449089a16..4d463701a759 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -943,7 +943,7 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		to_lnk = &lgr->lnk[i];
 		break;
 	}
-	if (!to_lnk) {
+	if (!to_lnk || !smc_wr_tx_link_hold(to_lnk)) {
 		smc_lgr_terminate_sched(lgr);
 		return NULL;
 	}
@@ -975,24 +975,26 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		read_unlock_bh(&lgr->conns_lock);
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
-		if (rc) {
-			smcr_link_down_cond_sched(to_lnk);
-			return NULL;
-		}
+		if (rc)
+			goto err_out;
 		/* avoid race with smcr_tx_sndbuf_nonempty() */
 		spin_lock_bh(&conn->send_lock);
 		smc_switch_link_and_count(conn, to_lnk);
 		rc = smc_switch_cursor(smc, pend, wr_buf);
 		spin_unlock_bh(&conn->send_lock);
 		sock_put(&smc->sk);
-		if (rc) {
-			smcr_link_down_cond_sched(to_lnk);
-			return NULL;
-		}
+		if (rc)
+			goto err_out;
 		goto again;
 	}
 	read_unlock_bh(&lgr->conns_lock);
+	smc_wr_tx_link_put(to_lnk);
 	return to_lnk;
+
+err_out:
+	smcr_link_down_cond_sched(to_lnk);
+	smc_wr_tx_link_put(to_lnk);
+	return NULL;
 }
 
 static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 2e7560eba981..72f4b72eb175 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -383,9 +383,11 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	confllc = (struct smc_llc_msg_confirm_link *)wr_buf;
 	memset(confllc, 0, sizeof(*confllc));
 	confllc->hd.common.type = SMC_LLC_CONFIRM_LINK;
@@ -402,6 +404,8 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	confllc->max_links = SMC_LLC_ADD_LNK_MAX_LINKS;
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -415,9 +419,11 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 	struct smc_link *link;
 	int i, rc, rtok_ix;
 
+	if (!smc_wr_tx_link_hold(send_link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(send_link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	rkeyllc = (struct smc_llc_msg_confirm_rkey *)wr_buf;
 	memset(rkeyllc, 0, sizeof(*rkeyllc));
 	rkeyllc->hd.common.type = SMC_LLC_CONFIRM_RKEY;
@@ -444,6 +450,8 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 		(u64)sg_dma_address(rmb_desc->sgt[send_link->link_idx].sgl));
 	/* send llc message */
 	rc = smc_wr_tx_send(send_link, pend);
+put_out:
+	smc_wr_tx_link_put(send_link);
 	return rc;
 }
 
@@ -456,9 +464,11 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	rkeyllc = (struct smc_llc_msg_delete_rkey *)wr_buf;
 	memset(rkeyllc, 0, sizeof(*rkeyllc));
 	rkeyllc->hd.common.type = SMC_LLC_DELETE_RKEY;
@@ -467,6 +477,8 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	rkeyllc->rkey[0] = htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -480,9 +492,11 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	addllc = (struct smc_llc_msg_add_link *)wr_buf;
 
 	memset(addllc, 0, sizeof(*addllc));
@@ -504,6 +518,8 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 	}
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -517,9 +533,11 @@ int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	delllc = (struct smc_llc_msg_del_link *)wr_buf;
 
 	memset(delllc, 0, sizeof(*delllc));
@@ -536,6 +554,8 @@ int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
 	delllc->reason = htonl(reason);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -547,9 +567,11 @@ static int smc_llc_send_test_link(struct smc_link *link, u8 user_data[16])
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	testllc = (struct smc_llc_msg_test_link *)wr_buf;
 	memset(testllc, 0, sizeof(*testllc));
 	testllc->hd.common.type = SMC_LLC_TEST_LINK;
@@ -557,6 +579,8 @@ static int smc_llc_send_test_link(struct smc_link *link, u8 user_data[16])
 	memcpy(testllc->user_data, user_data, sizeof(testllc->user_data));
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -567,13 +591,16 @@ static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (!smc_link_usable(link))
+	if (!smc_wr_tx_link_hold(link))
 		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	memcpy(wr_buf, llcbuf, sizeof(union smc_llc_msg));
-	return smc_wr_tx_send(link, pend);
+	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
+	return rc;
 }
 
 /* schedule an llc send on link, may wait for buffers,
@@ -586,13 +613,16 @@ static int smc_llc_send_message_wait(struct smc_link *link, void *llcbuf)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (!smc_link_usable(link))
+	if (!smc_wr_tx_link_hold(link))
 		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	memcpy(wr_buf, llcbuf, sizeof(union smc_llc_msg));
-	return smc_wr_tx_send_wait(link, pend, SMC_LLC_WAIT_TIME);
+	rc = smc_wr_tx_send_wait(link, pend, SMC_LLC_WAIT_TIME);
+put_out:
+	smc_wr_tx_link_put(link);
+	return rc;
 }
 
 /********************************* receive ***********************************/
@@ -672,9 +702,11 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 	struct smc_buf_desc *rmb;
 	u8 n;
 
+	if (!smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		return rc;
+		goto put_out;
 	addc_llc = (struct smc_llc_msg_add_link_cont *)wr_buf;
 	memset(addc_llc, 0, sizeof(*addc_llc));
 
@@ -706,7 +738,10 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 	addc_llc->hd.length = sizeof(struct smc_llc_msg_add_link_cont);
 	if (lgr->role == SMC_CLNT)
 		addc_llc->hd.flags |= SMC_LLC_FLAG_RESP;
-	return smc_wr_tx_send(link, pend);
+	rc = smc_wr_tx_send(link, pend);
+put_out:
+	smc_wr_tx_link_put(link);
+	return rc;
 }
 
 static int smc_llc_cli_rkey_exchange(struct smc_link *link,
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index c79361dfcdfb..738a4a99c827 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -496,7 +496,7 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 /* Wakeup sndbuf consumers from any context (IRQ or process)
  * since there is more data to transmit; usable snd_wnd as max transmit
  */
-static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
+static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 {
 	struct smc_cdc_producer_flags *pflags = &conn->local_tx_ctrl.prod_flags;
 	struct smc_link *link = conn->lnk;
@@ -505,8 +505,11 @@ static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
+	if (!link || !smc_wr_tx_link_hold(link))
+		return -ENOLINK;
 	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, &wr_rdma_buf, &pend);
 	if (rc < 0) {
+		smc_wr_tx_link_put(link);
 		if (rc == -EBUSY) {
 			struct smc_sock *smc =
 				container_of(conn, struct smc_sock, conn);
@@ -547,22 +550,7 @@ static int _smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
 
 out_unlock:
 	spin_unlock_bh(&conn->send_lock);
-	return rc;
-}
-
-static int smcr_tx_sndbuf_nonempty(struct smc_connection *conn)
-{
-	struct smc_link *link = conn->lnk;
-	int rc = -ENOLINK;
-
-	if (!link)
-		return rc;
-
-	atomic_inc(&link->wr_tx_refcnt);
-	if (smc_link_usable(link))
-		rc = _smcr_tx_sndbuf_nonempty(conn);
-	if (atomic_dec_and_test(&link->wr_tx_refcnt))
-		wake_up_all(&link->wr_tx_wait);
+	smc_wr_tx_link_put(link);
 	return rc;
 }
 
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 423b8709f1c9..2bc626f230a5 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -60,6 +60,20 @@ static inline void smc_wr_tx_set_wr_id(atomic_long_t *wr_tx_id, long val)
 	atomic_long_set(wr_tx_id, val);
 }
 
+static inline bool smc_wr_tx_link_hold(struct smc_link *link)
+{
+	if (!smc_link_usable(link))
+		return false;
+	atomic_inc(&link->wr_tx_refcnt);
+	return true;
+}
+
+static inline void smc_wr_tx_link_put(struct smc_link *link)
+{
+	if (atomic_dec_and_test(&link->wr_tx_refcnt))
+		wake_up_all(&link->wr_tx_wait);
+}
+
 static inline void smc_wr_wakeup_tx_wait(struct smc_link *lnk)
 {
 	wake_up_all(&lnk->wr_tx_wait);
-- 
2.25.1

