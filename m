Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E941307505
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhA1LmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:42:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231466AbhA1Ll7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:41:59 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SBWjoi144930;
        Thu, 28 Jan 2021 06:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=nyce8RiW0A0dduPinWgXGwz44bMrmY2VVPVjrAa2lNs=;
 b=am95ZhRjaDAxeg3lXuu8Ko2WXXok7nY+c61GG6iavhnxX2K81EyRJBMAi7ksssdC1ZES
 nirVjoqeOiO5JKE3NW3AYQ2d5S1AOZF1Kw95OHWKzS0Siaz4rwlqRTmTs1jN+yJzZdbI
 mYl8VM7MTmXD/+BqKhIJSObs++24WtSMtX9Jc89k5GbfhQMiJ/+aTHjm4HbrUv29PzE7
 Wp7HSgKL9Cuw5PSMGYJgaYVpQ5/nFFSr3RhPEYejo9fdsPntAvjvp4pSUn0miTX5b2Sq
 Varb4fvtuug+COp/KS9cyznbS0+eM9detIotwAc1yWFlpgtv7yRgJ77VpMvqz8Rbpqg+ 8A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bvg6g5jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:41:17 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBcJ6p027928;
        Thu, 28 Jan 2021 11:41:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 368be7vs8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:41:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBfCjZ33948126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:41:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B38E4C046;
        Thu, 28 Jan 2021 11:41:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC8124C040;
        Thu, 28 Jan 2021 11:41:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:41:11 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/5] net/af_iucv: don't track individual TX skbs for TRANS_HIPER sockets
Date:   Thu, 28 Jan 2021 12:41:07 +0100
Message-Id: <20210128114108.39409-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128114108.39409-1-jwi@linux.ibm.com>
References: <20210128114108.39409-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=761
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop maintaining the skb_send_q list for TRANS_HIPER sockets.

Not only is it extra overhead, but keeping around a list of skb clones
means that we later also have to match the ->sk_txnotify() calls
against these clones and free them accordingly.
The current matching logic (comparing the skbs' shinfo location) is
frustratingly fragile, and breaks if the skb's head is mangled in any
sort of way while passing from dev_queue_xmit() to the device's
HW queue.

Also adjust the interface for ->sk_txnotify(), to make clear that we
don't actually care about any skb internals.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c |  6 ++-
 include/net/iucv/af_iucv.h        |  2 +-
 net/iucv/af_iucv.c                | 80 ++++++++-----------------------
 3 files changed, 26 insertions(+), 62 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index cf18d87da41e..c6e93abf8635 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1407,10 +1407,12 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
 	struct sk_buff *skb;
 
 	skb_queue_walk(&buf->skb_list, skb) {
+		struct sock *sk = skb->sk;
+
 		QETH_CARD_TEXT_(q->card, 5, "skbn%d", notification);
 		QETH_CARD_TEXT_(q->card, 5, "%lx", (long) skb);
-		if (skb->sk && skb->sk->sk_family == PF_IUCV)
-			iucv_sk(skb->sk)->sk_txnotify(skb, notification);
+		if (sk && sk->sk_family == PF_IUCV)
+			iucv_sk(sk)->sk_txnotify(sk, notification);
 	}
 }
 
diff --git a/include/net/iucv/af_iucv.h b/include/net/iucv/af_iucv.h
index 0816bcd44dd1..ff06246dbbb9 100644
--- a/include/net/iucv/af_iucv.h
+++ b/include/net/iucv/af_iucv.h
@@ -133,7 +133,7 @@ struct iucv_sock {
 	atomic_t		msg_recv;
 	atomic_t		pendings;
 	int			transport;
-	void                    (*sk_txnotify)(struct sk_buff *skb,
+	void			(*sk_txnotify)(struct sock *sk,
 					       enum iucv_tx_notify n);
 };
 
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index e487f472027a..0e0656db4ae7 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -89,7 +89,7 @@ static struct sock *iucv_accept_dequeue(struct sock *parent,
 static void iucv_sock_kill(struct sock *sk);
 static void iucv_sock_close(struct sock *sk);
 
-static void afiucv_hs_callback_txnotify(struct sk_buff *, enum iucv_tx_notify);
+static void afiucv_hs_callback_txnotify(struct sock *sk, enum iucv_tx_notify);
 
 /* Call Back functions */
 static void iucv_callback_rx(struct iucv_path *, struct iucv_message *);
@@ -211,7 +211,6 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 {
 	struct iucv_sock *iucv = iucv_sk(sock);
 	struct af_iucv_trans_hdr *phs_hdr;
-	struct sk_buff *nskb;
 	int err, confirm_recv = 0;
 
 	phs_hdr = skb_push(skb, sizeof(*phs_hdr));
@@ -261,20 +260,10 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
 
-	__skb_header_release(skb);
-	nskb = skb_clone(skb, GFP_ATOMIC);
-	if (!nskb) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
-	skb_queue_tail(&iucv->send_skb_q, nskb);
 	atomic_inc(&iucv->skbs_in_xmit);
 	err = dev_queue_xmit(skb);
 	if (net_xmit_eval(err)) {
 		atomic_dec(&iucv->skbs_in_xmit);
-		skb_unlink(nskb, &iucv->send_skb_q);
-		kfree_skb(nskb);
 	} else {
 		atomic_sub(confirm_recv, &iucv->msg_recv);
 		WARN_ON(atomic_read(&iucv->msg_recv) < 0);
@@ -2146,59 +2135,33 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
  * afiucv_hs_callback_txnotify() - handle send notifcations from HiperSockets
  *                                 transport
  **/
-static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
-					enum iucv_tx_notify n)
+static void afiucv_hs_callback_txnotify(struct sock *sk, enum iucv_tx_notify n)
 {
-	struct iucv_sock *iucv = iucv_sk(skb->sk);
-	struct sock *sk = skb->sk;
-	struct sk_buff_head *list;
-	struct sk_buff *list_skb;
-	struct sk_buff *nskb;
-	unsigned long flags;
+	struct iucv_sock *iucv = iucv_sk(sk);
 
 	if (sock_flag(sk, SOCK_ZAPPED))
 		return;
 
-	list = &iucv->send_skb_q;
-	spin_lock_irqsave(&list->lock, flags);
-	skb_queue_walk_safe(list, list_skb, nskb) {
-		if (skb_shinfo(list_skb) == skb_shinfo(skb)) {
-			switch (n) {
-			case TX_NOTIFY_OK:
-				atomic_dec(&iucv->skbs_in_xmit);
-				__skb_unlink(list_skb, list);
-				kfree_skb(list_skb);
-				iucv_sock_wake_msglim(sk);
-				break;
-			case TX_NOTIFY_PENDING:
-				atomic_inc(&iucv->pendings);
-				break;
-			case TX_NOTIFY_DELAYED_OK:
-				atomic_dec(&iucv->skbs_in_xmit);
-				__skb_unlink(list_skb, list);
-				atomic_dec(&iucv->pendings);
-				if (atomic_read(&iucv->pendings) <= 0)
-					iucv_sock_wake_msglim(sk);
-				kfree_skb(list_skb);
-				break;
-			case TX_NOTIFY_UNREACHABLE:
-			case TX_NOTIFY_DELAYED_UNREACHABLE:
-			case TX_NOTIFY_TPQFULL: /* not yet used */
-			case TX_NOTIFY_GENERALERROR:
-			case TX_NOTIFY_DELAYED_GENERALERROR:
-				atomic_dec(&iucv->skbs_in_xmit);
-				__skb_unlink(list_skb, list);
-				kfree_skb(list_skb);
-				if (sk->sk_state == IUCV_CONNECTED) {
-					sk->sk_state = IUCV_DISCONN;
-					sk->sk_state_change(sk);
-				}
-				break;
-			}
-			break;
+	switch (n) {
+	case TX_NOTIFY_OK:
+		atomic_dec(&iucv->skbs_in_xmit);
+		iucv_sock_wake_msglim(sk);
+		break;
+	case TX_NOTIFY_PENDING:
+		atomic_inc(&iucv->pendings);
+		break;
+	case TX_NOTIFY_DELAYED_OK:
+		atomic_dec(&iucv->skbs_in_xmit);
+		if (atomic_dec_return(&iucv->pendings) <= 0)
+			iucv_sock_wake_msglim(sk);
+		break;
+	default:
+		atomic_dec(&iucv->skbs_in_xmit);
+		if (sk->sk_state == IUCV_CONNECTED) {
+			sk->sk_state = IUCV_DISCONN;
+			sk->sk_state_change(sk);
 		}
 	}
-	spin_unlock_irqrestore(&list->lock, flags);
 
 	if (sk->sk_state == IUCV_CLOSING) {
 		if (atomic_read(&iucv->skbs_in_xmit) == 0) {
@@ -2206,7 +2169,6 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 			sk->sk_state_change(sk);
 		}
 	}
-
 }
 
 /*
-- 
2.17.1

