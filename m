Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992BB307502
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhA1LmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:42:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231465AbhA1Ll7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:41:59 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SBVniQ061520;
        Thu, 28 Jan 2021 06:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=qzQSQajU0jxL9B6LREGujSE6vW3tSQ+LA/5slbXMe5E=;
 b=fu8lkRYpcZE6c+Nsui5Se8xcg2/Nqmn1M00MH5avqLMV9OZEMcIgwCTOWTbnKSjx4ZqJ
 Quv+c0n5qiuy+2VEtw4qzSqW/FryOwcJZXbQcuJqILeiZh+B3VnVCwWJiqG7UAJc086K
 GgezWyTfhITrZQNtR2KaPvnen6lA+M/sh1ApEPBHwL48i/zIKT/yHnUE0ikt+KvSXdmt
 fprkLstUq8edDAs8Ijds+nhI1TizGCbdSABV3G4iR7gQUiBRbNIOhcz+JU34jD/GzV5G
 CyIdUDJK0XEzaxVpeNqIYEwsgZrhxc6KgW+g/UH2BpF+SD5zaAeFL7vYbkC+DfvZgkwg BA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bqx3rg1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:41:16 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBcGH5023791;
        Thu, 28 Jan 2021 11:41:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 368be8crv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:41:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBfBsZ17695136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:41:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9BF94C04A;
        Thu, 28 Jan 2021 11:41:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C4874C040;
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
Subject: [PATCH net-next 3/5] net/af_iucv: count packets in the xmit path
Date:   Thu, 28 Jan 2021 12:41:06 +0100
Message-Id: <20210128114108.39409-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128114108.39409-1-jwi@linux.ibm.com>
References: <20210128114108.39409-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX code keeps track of all skbs that are in-flight but haven't
actually been sent out yet. For native IUCV sockets that's not a huge
deal, but with TRANS_HIPER sockets it would be much better if we
didn't need to maintain a list of skb clones.

Note that we actually only care about the _count_ of skbs in this stage
of the TX pipeline. So as prep work for removing the skb tracking on
TRANS_HIPER sockets, keep track of the skb count in a separate variable
and pair any list {enqueue, unlink} with a count {increment, decrement}.

Then replace all occurences where we currently look at the skb list's
fill level.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 include/net/iucv/af_iucv.h |  1 +
 net/iucv/af_iucv.c         | 30 ++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/iucv/af_iucv.h b/include/net/iucv/af_iucv.h
index 9259ce2b22f3..0816bcd44dd1 100644
--- a/include/net/iucv/af_iucv.h
+++ b/include/net/iucv/af_iucv.h
@@ -128,6 +128,7 @@ struct iucv_sock {
 	u8			flags;
 	u16			msglimit;
 	u16			msglimit_peer;
+	atomic_t		skbs_in_xmit;
 	atomic_t		msg_sent;
 	atomic_t		msg_recv;
 	atomic_t		pendings;
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 8683b6939f45..e487f472027a 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -182,7 +182,7 @@ static inline int iucv_below_msglim(struct sock *sk)
 	if (sk->sk_state != IUCV_CONNECTED)
 		return 1;
 	if (iucv->transport == AF_IUCV_TRANS_IUCV)
-		return (skb_queue_len(&iucv->send_skb_q) < iucv->path->msglim);
+		return (atomic_read(&iucv->skbs_in_xmit) < iucv->path->msglim);
 	else
 		return ((atomic_read(&iucv->msg_sent) < iucv->msglimit_peer) &&
 			(atomic_read(&iucv->pendings) <= 0));
@@ -269,8 +269,10 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 	}
 
 	skb_queue_tail(&iucv->send_skb_q, nskb);
+	atomic_inc(&iucv->skbs_in_xmit);
 	err = dev_queue_xmit(skb);
 	if (net_xmit_eval(err)) {
+		atomic_dec(&iucv->skbs_in_xmit);
 		skb_unlink(nskb, &iucv->send_skb_q);
 		kfree_skb(nskb);
 	} else {
@@ -424,7 +426,7 @@ static void iucv_sock_close(struct sock *sk)
 		sk->sk_state = IUCV_CLOSING;
 		sk->sk_state_change(sk);
 
-		if (!err && !skb_queue_empty(&iucv->send_skb_q)) {
+		if (!err && atomic_read(&iucv->skbs_in_xmit) > 0) {
 			if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
 				timeo = sk->sk_lingertime;
 			else
@@ -491,6 +493,7 @@ static struct sock *iucv_sock_alloc(struct socket *sock, int proto, gfp_t prio,
 	atomic_set(&iucv->pendings, 0);
 	iucv->flags = 0;
 	iucv->msglimit = 0;
+	atomic_set(&iucv->skbs_in_xmit, 0);
 	atomic_set(&iucv->msg_sent, 0);
 	atomic_set(&iucv->msg_recv, 0);
 	iucv->path = NULL;
@@ -1055,6 +1058,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		}
 	} else { /* Classic VM IUCV transport */
 		skb_queue_tail(&iucv->send_skb_q, skb);
+		atomic_inc(&iucv->skbs_in_xmit);
 
 		if (((iucv->path->flags & IUCV_IPRMDATA) & iucv->flags) &&
 		    skb->len <= 7) {
@@ -1063,6 +1067,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			/* on success: there is no message_complete callback */
 			/* for an IPRMDATA msg; remove skb from send queue   */
 			if (err == 0) {
+				atomic_dec(&iucv->skbs_in_xmit);
 				skb_unlink(skb, &iucv->send_skb_q);
 				kfree_skb(skb);
 			}
@@ -1071,6 +1076,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			/* IUCV_IPRMDATA path flag is set... sever path */
 			if (err == 0x15) {
 				pr_iucv->path_sever(iucv->path, NULL);
+				atomic_dec(&iucv->skbs_in_xmit);
 				skb_unlink(skb, &iucv->send_skb_q);
 				err = -EPIPE;
 				goto fail;
@@ -1109,6 +1115,8 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			} else {
 				err = -EPIPE;
 			}
+
+			atomic_dec(&iucv->skbs_in_xmit);
 			skb_unlink(skb, &iucv->send_skb_q);
 			goto fail;
 		}
@@ -1748,10 +1756,14 @@ static void iucv_callback_txdone(struct iucv_path *path,
 {
 	struct sock *sk = path->private;
 	struct sk_buff *this = NULL;
-	struct sk_buff_head *list = &iucv_sk(sk)->send_skb_q;
+	struct sk_buff_head *list;
 	struct sk_buff *list_skb;
+	struct iucv_sock *iucv;
 	unsigned long flags;
 
+	iucv = iucv_sk(sk);
+	list = &iucv->send_skb_q;
+
 	bh_lock_sock(sk);
 
 	spin_lock_irqsave(&list->lock, flags);
@@ -1761,8 +1773,11 @@ static void iucv_callback_txdone(struct iucv_path *path,
 			break;
 		}
 	}
-	if (this)
+	if (this) {
+		atomic_dec(&iucv->skbs_in_xmit);
 		__skb_unlink(this, list);
+	}
+
 	spin_unlock_irqrestore(&list->lock, flags);
 
 	if (this) {
@@ -1772,7 +1787,7 @@ static void iucv_callback_txdone(struct iucv_path *path,
 	}
 
 	if (sk->sk_state == IUCV_CLOSING) {
-		if (skb_queue_empty(&iucv_sk(sk)->send_skb_q)) {
+		if (atomic_read(&iucv->skbs_in_xmit) == 0) {
 			sk->sk_state = IUCV_CLOSED;
 			sk->sk_state_change(sk);
 		}
@@ -2150,6 +2165,7 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 		if (skb_shinfo(list_skb) == skb_shinfo(skb)) {
 			switch (n) {
 			case TX_NOTIFY_OK:
+				atomic_dec(&iucv->skbs_in_xmit);
 				__skb_unlink(list_skb, list);
 				kfree_skb(list_skb);
 				iucv_sock_wake_msglim(sk);
@@ -2158,6 +2174,7 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 				atomic_inc(&iucv->pendings);
 				break;
 			case TX_NOTIFY_DELAYED_OK:
+				atomic_dec(&iucv->skbs_in_xmit);
 				__skb_unlink(list_skb, list);
 				atomic_dec(&iucv->pendings);
 				if (atomic_read(&iucv->pendings) <= 0)
@@ -2169,6 +2186,7 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 			case TX_NOTIFY_TPQFULL: /* not yet used */
 			case TX_NOTIFY_GENERALERROR:
 			case TX_NOTIFY_DELAYED_GENERALERROR:
+				atomic_dec(&iucv->skbs_in_xmit);
 				__skb_unlink(list_skb, list);
 				kfree_skb(list_skb);
 				if (sk->sk_state == IUCV_CONNECTED) {
@@ -2183,7 +2201,7 @@ static void afiucv_hs_callback_txnotify(struct sk_buff *skb,
 	spin_unlock_irqrestore(&list->lock, flags);
 
 	if (sk->sk_state == IUCV_CLOSING) {
-		if (skb_queue_empty(&iucv_sk(sk)->send_skb_q)) {
+		if (atomic_read(&iucv->skbs_in_xmit) == 0) {
 			sk->sk_state = IUCV_CLOSED;
 			sk->sk_state_change(sk);
 		}
-- 
2.17.1

