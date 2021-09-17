Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360F340EEC3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 03:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbhIQBdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 21:33:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9889 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242286AbhIQBdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 21:33:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H9bsb5wkCz8yPg;
        Fri, 17 Sep 2021 09:27:15 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Fri, 17 Sep 2021 09:31:43 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Fri, 17
 Sep 2021 09:31:43 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH v2] skmsg: lose offset info in sk_psock_skb_ingress
Date:   Fri, 17 Sep 2021 09:32:22 +0800
Message-ID: <20210917013222.74225-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sockmap enable strparser, there are lose offset info in
sk_psock_skb_ingress. If the length determined by parse_msg function
is not skb->len, the skb will be converted to sk_msg multiple times,
and userspace app will get the data multiple times.

Fix this by get the offset and length from strp_msg.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v1->v2: fix build error when disable CONFIG_BPF_STREAM_PARSER

 net/core/skmsg.c | 51 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..c958e3642cb3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -9,6 +9,10 @@
 #include <net/tcp.h>
 #include <net/tls.h>
 
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+static void sk_psock_strp_data_ready(struct sock *sk);
+#endif
+
 static bool sk_msg_try_coalesce_ok(struct sk_msg *msg, int elem_first_coalesce)
 {
 	if (msg->sg.end > msg->sg.start &&
@@ -494,6 +498,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
+					u32 off, u32 len,
 					struct sk_psock *psock,
 					struct sock *sk,
 					struct sk_msg *msg)
@@ -507,11 +512,11 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	 */
 	if (skb_linearize(skb))
 		return -EAGAIN;
-	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
+	num_sge = skb_to_sgvec(skb, msg->sg.data, off, len);
 	if (unlikely(num_sge < 0))
 		return num_sge;
 
-	copied = skb->len;
+	copied = len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
 	msg->sg.end = num_sge;
@@ -522,9 +527,11 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	return copied;
 }
 
-static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb);
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
+				     u32 off, u32 len);
 
-static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
+static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
+				u32 off, u32 len)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
@@ -535,7 +542,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * correctly.
 	 */
 	if (unlikely(skb->sk == sk))
-		return sk_psock_skb_ingress_self(psock, skb);
+		return sk_psock_skb_ingress_self(psock, skb, off, len);
 	msg = sk_psock_create_ingress_msg(sk, skb);
 	if (!msg)
 		return -EAGAIN;
@@ -547,7 +554,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * into user buffers.
 	 */
 	skb_set_owner_r(skb, sk);
-	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
 		kfree(msg);
 	return err;
@@ -557,7 +564,8 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
  * skb. In this case we do not need to check memory limits or skb_set_owner_r
  * because the skb is already accounted for here.
  */
-static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb)
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
+				     u32 off, u32 len)
 {
 	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	struct sock *sk = psock->sk;
@@ -567,7 +575,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 		return -EAGAIN;
 	sk_msg_init(msg);
 	skb_set_owner_r(skb, sk);
-	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
 		kfree(msg);
 	return err;
@@ -581,7 +589,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			return -EAGAIN;
 		return skb_send_sock(psock->sk, skb, off, len);
 	}
-	return sk_psock_skb_ingress(psock, skb);
+	return sk_psock_skb_ingress(psock, skb, off, len);
 }
 
 static void sk_psock_skb_state(struct sk_psock *psock,
@@ -604,6 +612,9 @@ static void sk_psock_backlog(struct work_struct *work)
 {
 	struct sk_psock *psock = container_of(work, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+	struct strp_msg *stm = NULL;
+#endif
 	struct sk_buff *skb = NULL;
 	bool ingress;
 	u32 len, off;
@@ -624,6 +635,13 @@ static void sk_psock_backlog(struct work_struct *work)
 	while ((skb = skb_dequeue(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+		if (psock->sk->sk_data_ready == sk_psock_strp_data_ready) {
+			stm = strp_msg(skb);
+			off = stm->offset;
+			len = stm->full_len;
+		}
+#endif
 start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
@@ -930,6 +948,10 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 {
 	struct sock *sk_other;
 	int err = 0;
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+	struct strp_msg *stm = NULL;
+#endif
+	u32 len, off;
 
 	switch (verdict) {
 	case __SK_PASS:
@@ -949,7 +971,16 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		 * retrying later from workqueue.
 		 */
 		if (skb_queue_empty(&psock->ingress_skb)) {
-			err = sk_psock_skb_ingress_self(psock, skb);
+			len = skb->len;
+			off = 0;
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+			if (psock->sk->sk_data_ready == sk_psock_strp_data_ready) {
+				stm = strp_msg(skb);
+				off = stm->offset;
+				len = stm->full_len;
+			}
+#endif
+			err = sk_psock_skb_ingress_self(psock, skb, off, len);
 		}
 		if (err < 0) {
 			spin_lock_bh(&psock->ingress_lock);
-- 
2.17.1

