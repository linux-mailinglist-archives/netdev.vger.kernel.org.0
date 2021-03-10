Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9280B333554
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhCJFdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhCJFcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:32:47 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881F0C061760;
        Tue,  9 Mar 2021 21:32:33 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id b130so15663939qkc.10;
        Tue, 09 Mar 2021 21:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oR8vNPuyYW5ybMkD1YXMVIl84QjFioYi6NOhEadLhCo=;
        b=lyABdKQu1LDAvDr3UpWklQRKFQI6t5Ee5nELXCrlMitgKLT5zlcM8qD5k1in7ZF6gq
         63wB1uAs9BPDl6gASoPnCaFeKbf82pvDHrgvMgDpAsztJZdo6MkqNITsvmwYKPenlRey
         g/ylJ0i7uTCqnMvIHE006sQixrddHb3U2SmYx+VsTp3K0/AjSjSKbA613SW/3EGn3w7k
         GagwAUGXayybeWHD7UKprZypeLu5nCV+BoMNGZ65nRvCjN+ynn/ox7IkEkDP/YJPsFKl
         Ji34SFFeLkJB9vf2iOvZz1MpiuOvIPYr32c4LUV/WXMl/IbC0M3uZ4R+xJxmfzyM5rRk
         yEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oR8vNPuyYW5ybMkD1YXMVIl84QjFioYi6NOhEadLhCo=;
        b=OKXlI4o1/G3YjS27JQnHYZkl3FZucmMikJ01iJZYPYVYuw3GS/fACAQiaGqb2EkaWQ
         obOOIKK6X2rntDGzRiq2v4dt4Dkdsw/H7B9TKMZj8UvASqlmvXvmP6MdZPKhnCGTjNcE
         ucC5NLcG2oJ47GvtaCtHQkTFnmoVD7E+VQSZu/FbnIwMB3i2XnMV0njtoDZXOPcErhFM
         napc4PsOBjf2msomT7rFWR/ZsyEcAyYt6J0gEcrKv5RMUNQUvPckXt4DUOMR+01gGTEP
         /ZphAyjNWTez4UAOTOpEQx4lljM1nKINHRNJmZsUOH3L6vweoVss6EOOAigdYQOSif75
         F9fg==
X-Gm-Message-State: AOAM5338WX7rH6wOII7PSmXkYQp+VtU8UdQsaDBxi3ZhtsIktaqaY5B+
        j7wA9yxjRdfP2J9TkqPoWv6a3DbocPQ6nw==
X-Google-Smtp-Source: ABdhPJwvkQI32wjPgiHEftUwy7GlQS30bzD9r1cx2aHbkJy+8tfDgb/r1CGpuMHBK1yROTosD6kSFg==
X-Received: by 2002:a37:44cc:: with SMTP id r195mr1151267qka.224.1615354352451;
        Tue, 09 Mar 2021 21:32:32 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:31 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 02/11] skmsg: introduce a spinlock to protect ingress_msg
Date:   Tue,  9 Mar 2021 21:32:13 -0800
Message-Id: <20210310053222.41371-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently we rely on lock_sock to protect ingress_msg,
it is too big for this, we can actually just use a spinlock
to protect this list like protecting other skb queues.

__tcp_bpf_recvmsg() is still special because of peeking,
it still has to use lock_sock.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 46 +++++++++++++++++++++++++++++++++++++++++++
 net/core/skmsg.c      |  3 +++
 net/ipv4/tcp_bpf.c    | 18 ++++++-----------
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6c09d94be2e9..7333bf881b81 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -89,6 +89,7 @@ struct sk_psock {
 #endif
 	struct sk_buff_head		ingress_skb;
 	struct list_head		ingress_msg;
+	spinlock_t			ingress_lock;
 	unsigned long			state;
 	struct list_head		link;
 	spinlock_t			link_lock;
@@ -284,7 +285,45 @@ static inline struct sk_psock *sk_psock(const struct sock *sk)
 static inline void sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
+	spin_lock_bh(&psock->ingress_lock);
 	list_add_tail(&msg->list, &psock->ingress_msg);
+	spin_unlock_bh(&psock->ingress_lock);
+}
+
+static inline struct sk_msg *sk_psock_deque_msg(struct sk_psock *psock)
+{
+	struct sk_msg *msg;
+
+	spin_lock_bh(&psock->ingress_lock);
+	msg = list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
+	if (msg)
+		list_del(&msg->list);
+	spin_unlock_bh(&psock->ingress_lock);
+	return msg;
+}
+
+static inline struct sk_msg *sk_psock_peek_msg(struct sk_psock *psock)
+{
+	struct sk_msg *msg;
+
+	spin_lock_bh(&psock->ingress_lock);
+	msg = list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
+	spin_unlock_bh(&psock->ingress_lock);
+	return msg;
+}
+
+static inline struct sk_msg *sk_psock_next_msg(struct sk_psock *psock,
+					       struct sk_msg *msg)
+{
+	struct sk_msg *ret;
+
+	spin_lock_bh(&psock->ingress_lock);
+	if (list_is_last(&msg->list, &psock->ingress_msg))
+		ret = NULL;
+	else
+		ret = list_next_entry(msg, list);
+	spin_unlock_bh(&psock->ingress_lock);
+	return ret;
 }
 
 static inline bool sk_psock_queue_empty(const struct sk_psock *psock)
@@ -292,6 +331,13 @@ static inline bool sk_psock_queue_empty(const struct sk_psock *psock)
 	return psock ? list_empty(&psock->ingress_msg) : true;
 }
 
+static inline void kfree_sk_msg(struct sk_msg *msg)
+{
+	if (msg->skb)
+		consume_skb(msg->skb);
+	kfree(msg);
+}
+
 static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 {
 	struct sock *sk = psock->sk;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index bebf84ed4e30..41a5f82c53e6 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -592,6 +592,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	INIT_WORK(&psock->work, sk_psock_backlog);
 	INIT_LIST_HEAD(&psock->ingress_msg);
+	spin_lock_init(&psock->ingress_lock);
 	skb_queue_head_init(&psock->ingress_skb);
 
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
@@ -623,11 +624,13 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 {
 	struct sk_msg *msg, *tmp;
 
+	spin_lock_bh(&psock->ingress_lock);
 	list_for_each_entry_safe(msg, tmp, &psock->ingress_msg, list) {
 		list_del(&msg->list);
 		sk_msg_free(psock->sk, msg);
 		kfree(msg);
 	}
+	spin_unlock_bh(&psock->ingress_lock);
 }
 
 static void sk_psock_zap_ingress(struct sk_psock *psock)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 17c322b875fd..ad1261cdcdde 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -18,9 +18,7 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 	struct sk_msg *msg_rx;
 	int i, copied = 0;
 
-	msg_rx = list_first_entry_or_null(&psock->ingress_msg,
-					  struct sk_msg, list);
-
+	msg_rx = sk_psock_peek_msg(psock);
 	while (copied != len) {
 		struct scatterlist *sge;
 
@@ -68,22 +66,18 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		} while (i != msg_rx->sg.end);
 
 		if (unlikely(peek)) {
-			if (msg_rx == list_last_entry(&psock->ingress_msg,
-						      struct sk_msg, list))
+			msg_rx = sk_psock_next_msg(psock, msg_rx);
+			if (!msg_rx)
 				break;
-			msg_rx = list_next_entry(msg_rx, list);
 			continue;
 		}
 
 		msg_rx->sg.start = i;
 		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
-			list_del(&msg_rx->list);
-			if (msg_rx->skb)
-				consume_skb(msg_rx->skb);
-			kfree(msg_rx);
+			msg_rx = sk_psock_deque_msg(psock);
+			kfree_sk_msg(msg_rx);
 		}
-		msg_rx = list_first_entry_or_null(&psock->ingress_msg,
-						  struct sk_msg, list);
+		msg_rx = sk_psock_peek_msg(psock);
 	}
 
 	return copied;
-- 
2.25.1

