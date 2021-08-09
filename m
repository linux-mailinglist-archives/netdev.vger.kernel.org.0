Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF53E41AD
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhHIIfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:35:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233974AbhHIIfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:35:21 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798YkKb009013;
        Mon, 9 Aug 2021 04:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dur3ZpV+VHPZQCik1YTI74NRInPZ6lBXG9Jc449fkNs=;
 b=Zn0tuCYaa7BOUaBZd0f3bgrFqKStlNJaRJDCpMj4+/Kb2CAgdz7A8uVVYfthZu9S+ZnN
 yeE5LEwWZ4UK3XsfamjVKNK3wmUS8YK4ui/LGgjWov8u+okM223sWhpr2/mqn8ZqAA+8
 pCBMj8mC6mnQEz31aa8aiEXD1yQZkdYxj281oz/HNZwvqcVt+DdlxeWdbG7xxsBqyfq+
 kxQ/DVf4KNm8zSpj7YyDhphe5ZClUquKb1vJbkBfjBjRPL15XBRBQWei2BF1ufmxdeO9
 Rsh6bzLij3W8ucjHe57V47zCuil6MpYgPyPeEw4ZDI229VEbgg+ofKhanvR0V9jj/gs1 8Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7g9g5h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:34:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798SP26021497;
        Mon, 9 Aug 2021 08:31:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3a9hehbnfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:31:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798VRvZ55378328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:31:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 735F2A4072;
        Mon,  9 Aug 2021 08:31:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6CF4A406D;
        Mon,  9 Aug 2021 08:31:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:31:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 1/5] net/af_iucv: support drop monitoring
Date:   Mon,  9 Aug 2021 10:30:46 +0200
Message-Id: <20210809083050.2328336-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809083050.2328336-1-kgraul@linux.ibm.com>
References: <20210809083050.2328336-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ch6gYyGpSpqFTiIWRTsPng6zLA2gWvt2
X-Proofpoint-ORIG-GUID: Ch6gYyGpSpqFTiIWRTsPng6zLA2gWvt2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Change the good paths to use consume_skb() instead of kfree_skb(). This
avoids flooding dropwatch with false-positives.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/af_iucv.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 44453b35c7b7..c8fbfc0be2e5 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1044,7 +1044,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			if (err == 0) {
 				atomic_dec(&iucv->skbs_in_xmit);
 				skb_unlink(skb, &iucv->send_skb_q);
-				kfree_skb(skb);
+				consume_skb(skb);
 			}
 
 			/* this error should never happen since the	*/
@@ -1293,7 +1293,7 @@ static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			}
 		}
 
-		kfree_skb(skb);
+		consume_skb(skb);
 		if (iucv->transport == AF_IUCV_TRANS_HIPER) {
 			atomic_inc(&iucv->msg_recv);
 			if (atomic_read(&iucv->msg_recv) > iucv->msglimit) {
@@ -1756,7 +1756,7 @@ static void iucv_callback_txdone(struct iucv_path *path,
 	spin_unlock_irqrestore(&list->lock, flags);
 
 	if (this) {
-		kfree_skb(this);
+		consume_skb(this);
 		/* wake up any process waiting for sending */
 		iucv_sock_wake_msglim(sk);
 	}
@@ -1903,17 +1903,17 @@ static int afiucv_hs_callback_synack(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
 
-	if (!iucv)
-		goto out;
-	if (sk->sk_state != IUCV_BOUND)
-		goto out;
+	if (!iucv || sk->sk_state != IUCV_BOUND) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
 	bh_lock_sock(sk);
 	iucv->msglimit_peer = iucv_trans_hdr(skb)->window;
 	sk->sk_state = IUCV_CONNECTED;
 	sk->sk_state_change(sk);
 	bh_unlock_sock(sk);
-out:
-	kfree_skb(skb);
+	consume_skb(skb);
 	return NET_RX_SUCCESS;
 }
 
@@ -1924,16 +1924,16 @@ static int afiucv_hs_callback_synfin(struct sock *sk, struct sk_buff *skb)
 {
 	struct iucv_sock *iucv = iucv_sk(sk);
 
-	if (!iucv)
-		goto out;
-	if (sk->sk_state != IUCV_BOUND)
-		goto out;
+	if (!iucv || sk->sk_state != IUCV_BOUND) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
 	bh_lock_sock(sk);
 	sk->sk_state = IUCV_DISCONN;
 	sk->sk_state_change(sk);
 	bh_unlock_sock(sk);
-out:
-	kfree_skb(skb);
+	consume_skb(skb);
 	return NET_RX_SUCCESS;
 }
 
@@ -1945,16 +1945,18 @@ static int afiucv_hs_callback_fin(struct sock *sk, struct sk_buff *skb)
 	struct iucv_sock *iucv = iucv_sk(sk);
 
 	/* other end of connection closed */
-	if (!iucv)
-		goto out;
+	if (!iucv) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
 	bh_lock_sock(sk);
 	if (sk->sk_state == IUCV_CONNECTED) {
 		sk->sk_state = IUCV_DISCONN;
 		sk->sk_state_change(sk);
 	}
 	bh_unlock_sock(sk);
-out:
-	kfree_skb(skb);
+	consume_skb(skb);
 	return NET_RX_SUCCESS;
 }
 
@@ -2107,7 +2109,7 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	case (AF_IUCV_FLAG_WIN):
 		err = afiucv_hs_callback_win(sk, skb);
 		if (skb->len == sizeof(struct af_iucv_trans_hdr)) {
-			kfree_skb(skb);
+			consume_skb(skb);
 			break;
 		}
 		fallthrough;	/* and receive non-zero length data */
-- 
2.25.1

