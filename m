Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60E741BC96
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243736AbhI2CIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:08:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:22382 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242761AbhI2CIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:08:13 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HK04R154lzRZrg;
        Wed, 29 Sep 2021 10:02:15 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:06:32 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Wed, 29
 Sep 2021 10:06:31 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <xiyou.wangcong@gmail.com>
CC:     <liujian56@huawei.com>
Subject: [PATCH v4] skmsg: lose offset info in sk_psock_skb_ingress
Date:   Wed, 29 Sep 2021 10:06:42 +0800
Message-ID: <20210929020642.206454-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
And as Cong suggestion, add one bit in skb->_sk_redir to distinguish
enable or disable strparser.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v1->v2: fix build error when disable CONFIG_BPF_STREAM_PARSER
v2->v3: Add one bit in skb->_sk_redir to distinguish enable or disable strparser
v3->v4: Remove "#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)" code;
	and let "stm" have a more precise scope.

 include/linux/skmsg.h | 18 ++++++++++++++++--
 net/core/skmsg.c      | 40 ++++++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14ab0c0bc924..94e2a1f6e58d 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -508,8 +508,22 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 
 #if IS_ENABLED(CONFIG_NET_SOCK_MSG)
 
-/* We only have one bit so far. */
-#define BPF_F_PTR_MASK ~(BPF_F_INGRESS)
+#define BPF_F_STRPARSER	(1UL << 1)
+
+/* We only have two bits so far. */
+#define BPF_F_PTR_MASK ~(BPF_F_INGRESS | BPF_F_STRPARSER)
+
+static inline bool skb_bpf_strparser(const struct sk_buff *skb)
+{
+	unsigned long sk_redir = skb->_sk_redir;
+
+	return sk_redir & BPF_F_STRPARSER;
+}
+
+static inline void skb_bpf_set_strparser(struct sk_buff *skb)
+{
+	skb->_sk_redir |= BPF_F_STRPARSER;
+}
 
 static inline bool skb_bpf_ingress(const struct sk_buff *skb)
 {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..e85b7f8491b9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -494,6 +494,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
+					u32 off, u32 len,
 					struct sk_psock *psock,
 					struct sock *sk,
 					struct sk_msg *msg)
@@ -507,11 +508,11 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
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
@@ -522,9 +523,11 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
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
@@ -535,7 +538,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * correctly.
 	 */
 	if (unlikely(skb->sk == sk))
-		return sk_psock_skb_ingress_self(psock, skb);
+		return sk_psock_skb_ingress_self(psock, skb, off, len);
 	msg = sk_psock_create_ingress_msg(sk, skb);
 	if (!msg)
 		return -EAGAIN;
@@ -547,7 +550,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * into user buffers.
 	 */
 	skb_set_owner_r(skb, sk);
-	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
 		kfree(msg);
 	return err;
@@ -557,7 +560,8 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
  * skb. In this case we do not need to check memory limits or skb_set_owner_r
  * because the skb is already accounted for here.
  */
-static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb)
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
+				     u32 off, u32 len)
 {
 	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	struct sock *sk = psock->sk;
@@ -567,7 +571,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 		return -EAGAIN;
 	sk_msg_init(msg);
 	skb_set_owner_r(skb, sk);
-	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
 		kfree(msg);
 	return err;
@@ -581,7 +585,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			return -EAGAIN;
 		return skb_send_sock(psock->sk, skb, off, len);
 	}
-	return sk_psock_skb_ingress(psock, skb);
+	return sk_psock_skb_ingress(psock, skb, off, len);
 }
 
 static void sk_psock_skb_state(struct sk_psock *psock,
@@ -624,6 +628,12 @@ static void sk_psock_backlog(struct work_struct *work)
 	while ((skb = skb_dequeue(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
+		if (skb_bpf_strparser(skb)) {
+			struct strp_msg *stm = strp_msg(skb);
+
+			off = stm->offset;
+			len = stm->full_len;
+		}
 start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
@@ -930,6 +940,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 {
 	struct sock *sk_other;
 	int err = 0;
+	u32 len, off;
 
 	switch (verdict) {
 	case __SK_PASS:
@@ -949,7 +960,15 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		 * retrying later from workqueue.
 		 */
 		if (skb_queue_empty(&psock->ingress_skb)) {
-			err = sk_psock_skb_ingress_self(psock, skb);
+			len = skb->len;
+			off = 0;
+			if (skb_bpf_strparser(skb)) {
+				struct strp_msg *stm = strp_msg(skb);
+
+				off = stm->offset;
+				len = stm->full_len;
+			}
+			err = sk_psock_skb_ingress_self(psock, skb, off, len);
 		}
 		if (err < 0) {
 			spin_lock_bh(&psock->ingress_lock);
@@ -1018,6 +1037,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
+	skb_bpf_set_strparser(skb);
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
 	rcu_read_unlock();
-- 
2.17.1

