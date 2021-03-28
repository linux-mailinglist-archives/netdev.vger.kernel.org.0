Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1922D34BECC
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhC1UUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhC1UUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:22 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A02C0613B1;
        Sun, 28 Mar 2021 13:20:21 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id a8so11214102oic.11;
        Sun, 28 Mar 2021 13:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bkt2WplmLy1bOLMwQLt5MnCSbjUaxe7m0LNKG1XmAxE=;
        b=Py7vPw9OuXJ7hXh2eubqB1df0Qnf15H636/6gG/tQpsBuVGItU/qfXxhKx0bAZek8I
         sVABSA/SYmKlO+ZQnpFhZS07brRWTo/3sRv9U6iR4nzBIQTMcRC+OzJ+dRRaffX9bGy9
         H3EVye1ZnkYOOoguLAa8hfbbASyR8AH4hLSA8U9NK6tWif4kMUtxe28jXHafykAR5bz7
         yAQvGbc18IPH357nFQXK5xrf/tOKUSxcqu/THCWEpBuOk/CebAOGmRM10Sdz4NKVCoZ1
         o6X1HkludKpmOVbKBt+Z60TWW2N+tcLmylz89i5XmlEB8jwKdz0pvokiboJ2mQm3y7tJ
         wqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkt2WplmLy1bOLMwQLt5MnCSbjUaxe7m0LNKG1XmAxE=;
        b=pb2VV02G42EDvfMLRm0z8972nxK1qcvqPYwiA3B/AShYc0vD8kqUmnLlR/iK2FJ4XG
         M7FJli7yMta70q6q267M8hwQW5qSpRcm7rc4gk7mjNIiMLY41hWaNHqp9GSLbCNlvHLd
         qGE5zeVDnJNxV2Qx2Ca/wJjuAgs02dc3/2Kx11r08IXdQ2pKvD46DgF83TRqB0X13HfX
         J+iPY8AXw3un0UW/A77c9jTD+ujkd4PTkxYdICX94oIvBMos2YsOay0/guMD31t4kzz4
         TmwF6TisTEkvpFi1r8L9Js+JBl2JD9NEixeO4JWoLOVw9fWX7ta/cTlMF0HMFHBeOFzz
         Fahg==
X-Gm-Message-State: AOAM532rqcU/LrGMn3r3FVT+PjwkJHt+TC02WLSPoalXuLPk+6K5fJEK
        uPqZUzfUeOkhIqzq7cvfMOs7u1CfONMuVw==
X-Google-Smtp-Source: ABdhPJyONoNR1xjtxgqTORv7cOu3pUZPlFwiYjrplcAjO/F3mfSBYL8ew1zDZg8zMk5r1aB5ccDrJA==
X-Received: by 2002:aca:dcc6:: with SMTP id t189mr16290047oig.9.1616962820564;
        Sun, 28 Mar 2021 13:20:20 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:20 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 02/13] skmsg: introduce a spinlock to protect ingress_msg
Date:   Sun, 28 Mar 2021 13:20:02 -0700
Message-Id: <20210328202013.29223-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
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
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 46 +++++++++++++++++++++++++++++++++++++++++++
 net/core/skmsg.c      |  3 +++
 net/ipv4/tcp_bpf.c    | 18 ++++++-----------
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6c09d94be2e9..f2d45a73b2b2 100644
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
+static inline struct sk_msg *sk_psock_dequeue_msg(struct sk_psock *psock)
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
index bebf84ed4e30..305dddc51857 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -592,6 +592,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	INIT_WORK(&psock->work, sk_psock_backlog);
 	INIT_LIST_HEAD(&psock->ingress_msg);
+	spin_lock_init(&psock->ingress_lock);
 	skb_queue_head_init(&psock->ingress_skb);
 
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
@@ -638,7 +639,9 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 	}
+	spin_lock_bh(&psock->ingress_lock);
 	__sk_psock_purge_ingress_msg(psock);
+	spin_unlock_bh(&psock->ingress_lock);
 }
 
 static void sk_psock_link_destroy(struct sk_psock *psock)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 17c322b875fd..ae980716d896 100644
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
+			msg_rx = sk_psock_dequeue_msg(psock);
+			kfree_sk_msg(msg_rx);
 		}
-		msg_rx = list_first_entry_or_null(&psock->ingress_msg,
-						  struct sk_msg, list);
+		msg_rx = sk_psock_peek_msg(psock);
 	}
 
 	return copied;
-- 
2.25.1

