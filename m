Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2FF33E6B6
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhCQCWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhCQCWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:22:47 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537C1C06175F;
        Tue, 16 Mar 2021 19:22:47 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so375677otn.10;
        Tue, 16 Mar 2021 19:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bkt2WplmLy1bOLMwQLt5MnCSbjUaxe7m0LNKG1XmAxE=;
        b=tabE2+z3CHadQK542X9/arazbYy3ePTZP2LucsjUBSb+kMZw7v4Wg0MfJeQZlcU5Gi
         5M/bGIHAvad5hNG/8U4lutDFBTufpdFMtCGyKPA49aL8UJoRsh4eN/Hl5wAqf7zIIUUC
         MsSURdP5nrGBG9UStgyDm2MshomcVB3/Em1uXBTOpnQQONjpC5y0dg69SqpfOAtwfPTK
         QF1HM3PE9f1NJLmSvs08/YIRhzSwnVeDjzJ0c4OybZdzq7DVU0iP5xTb5Q0Hh2isrRfX
         Vme46sBdcSFSFyICpgKemZU71V9oxkBEl8LOXvL/MEG5k/FekPPbbu1GuRqDtz7B+jVW
         Zz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkt2WplmLy1bOLMwQLt5MnCSbjUaxe7m0LNKG1XmAxE=;
        b=lyQfFnIOjcVP0VrdbbS2yUXiRUhtvFGSBuve0IGnN5/ra54ft/z058POq66VpYR84x
         CMvVbcb2od09qWuRTaeaE6F8elPmdEje2kFevcjHfObBGVkSOuf5WIKyIavDHMH531Yv
         aVHryWXcjoh/mIDwPjTdx3XnP6hohXcv6TsS7wNRPXmUa9A40Fe+eRitfFhgoiXdH+DX
         Zz9qLSO/zG2c3zQwTVb33KQfADKflrvxO0uILtVS5Tmo0u3qFOjSI8R/mwzXtv8i8JR/
         jlyFaMl8I3bq4C6R3lL5EOb9WR6WCARxGzf0YgvtJ1sHNR12o9musq5uI7G3/rcGYnD1
         l/KA==
X-Gm-Message-State: AOAM532/DIYchXL83xBNLHtn2hEIl6GxrWqHwII90oGPUI/tMQ3J4t7Q
        NP63Y0Avs0KFj21oqkHv51QTDfAXGEQOgA==
X-Google-Smtp-Source: ABdhPJyFByzejsWqCD6OBsABwnGwDPTuQub7gXWUpDT+VhyXPSaT2ABotZBPlSnpcxZdN1Lhdqa+Xg==
X-Received: by 2002:a05:6830:1de9:: with SMTP id b9mr1431743otj.137.1615947766612;
        Tue, 16 Mar 2021 19:22:46 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:46 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v5 02/11] skmsg: introduce a spinlock to protect ingress_msg
Date:   Tue, 16 Mar 2021 19:22:10 -0700
Message-Id: <20210317022219.24934-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
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

