Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F3E34BED0
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhC1UUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhC1UUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:24 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF62C061756;
        Sun, 28 Mar 2021 13:20:23 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id x2so11264185oiv.2;
        Sun, 28 Mar 2021 13:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chzddpAatZoL7UeA/glB0DgIXQP/ctiwnxswV0zD4Ns=;
        b=Z8bJAGqc9aqxqmmVxOHmcDbKi7jS+gLXh5rPf5Z8r8TAkES1xHJcPhOIvWLx0Tkplk
         gNYI2UTH37I7Tuif3fq3iaM91Cq7S/LbnXJ20ym6jHtl9vc+yhE92GI+9OEvVPvv0o7R
         AoTN6rwLCYzjlyrayyKZ0acgtKKzSMFpRNsoB2Naa1CnD4FjCjDwcf6q8bsJ1wVvbVTx
         dPCzJyTYdTR0TZsWdq+TqN4dvegJI1kY4N3DaUp1ag5+7iFyM50Ev2YYqCq40nsSzkUX
         GycYF9ePQs1LEJZXjm4cebynOFzv635R/0Zq/DL6cb9lidOvXPqUPOUUpTMMsUFOCb2c
         lvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=chzddpAatZoL7UeA/glB0DgIXQP/ctiwnxswV0zD4Ns=;
        b=nFGIVU5MIxWOthm+RPTnT+ipxa+LG+MU5hmFo5DZ+at/exw6C8Skgn7aUeuR141wKq
         9z5z6W7m+MWDvg67ChlbZl/VNaGF9SB1kmlmydY+CA4c/cx8ok3qI0Dmjqz1Qlf5H7LZ
         4x+dBnQg0UcrThL3yx/H6qZqyRGC2XpR+mNjAjjuBLTRxTBMAahmLpnDP5qnGGf2SAXe
         +jbV+TjZgxpOqtrQyImD1BGNbrDYPYR1DzmwYLP5OEGJAc3MpgA2Sy/25FqVvSI9Ys0x
         DGhMbhql2/uD3hMqmx0jJ13+6HBy99v2N+hoTiSCzyDXxT9qiFZUQ/wVM3kZO+RpbdyX
         CUyg==
X-Gm-Message-State: AOAM531x0dnG3iCyb4zXkoFC7Ex9ZW2A/aHLvuqwWYlD8uF0PnEco9sb
        Y/bMwVrepvXM+3uQH+BxOJwks/NsV01V1g==
X-Google-Smtp-Source: ABdhPJxzuZOhXtHfJBnlqbNGcL/JiaPxstVZm5SwYnb7BTdk8aV10Vvzf0qwrPZLMNa0K2BRWZPJbg==
X-Received: by 2002:aca:1c18:: with SMTP id c24mr16112798oic.7.1616962823009;
        Sun, 28 Mar 2021 13:20:23 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:22 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 04/13] skmsg: avoid lock_sock() in sk_psock_backlog()
Date:   Sun, 28 Mar 2021 13:20:04 -0700
Message-Id: <20210328202013.29223-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We do not have to lock the sock to avoid losing sk_socket,
instead we can purge all the ingress queues when we close
the socket. Sending or receiving packets after orphaning
socket makes no sense.

We do purge these queues when psock refcnt reaches zero but
here we want to purge them explicitly in sock_map_close().
There are also some nasty race conditions on testing bit
SK_PSOCK_TX_ENABLED and queuing/canceling the psock work,
we can expand psock->ingress_lock a bit to protect them too.

As noticed by John, we still have to lock the psock->work,
because the same work item could be running concurrently on
different CPU's.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  2 ++
 net/core/skmsg.c      | 50 +++++++++++++++++++++++++++++--------------
 net/core/sock_map.c   |  1 +
 3 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index f2d45a73b2b2..7382c4b518d7 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -99,6 +99,7 @@ struct sk_psock {
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
 	struct proto			*sk_proto;
+	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
 	union {
@@ -347,6 +348,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
+void sk_psock_stop(struct sk_psock *psock, bool wait);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 305dddc51857..9c25020086a9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -497,7 +497,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 	if (!ingress) {
 		if (!sock_writeable(psock->sk))
 			return -EAGAIN;
-		return skb_send_sock_locked(psock->sk, skb, off, len);
+		return skb_send_sock(psock->sk, skb, off, len);
 	}
 	return sk_psock_skb_ingress(psock, skb);
 }
@@ -511,8 +511,7 @@ static void sk_psock_backlog(struct work_struct *work)
 	u32 len, off;
 	int ret;
 
-	/* Lock sock to avoid losing sk_socket during loop. */
-	lock_sock(psock->sk);
+	mutex_lock(&psock->work_mutex);
 	if (state->skb) {
 		skb = state->skb;
 		len = state->len;
@@ -529,7 +528,7 @@ static void sk_psock_backlog(struct work_struct *work)
 		skb_bpf_redirect_clear(skb);
 		do {
 			ret = -EIO;
-			if (likely(psock->sk->sk_socket))
+			if (!sock_flag(psock->sk, SOCK_DEAD))
 				ret = sk_psock_handle_skb(psock, skb, off,
 							  len, ingress);
 			if (ret <= 0) {
@@ -553,7 +552,7 @@ static void sk_psock_backlog(struct work_struct *work)
 			kfree_skb(skb);
 	}
 end:
-	release_sock(psock->sk);
+	mutex_unlock(&psock->work_mutex);
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node)
@@ -591,6 +590,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	spin_lock_init(&psock->link_lock);
 
 	INIT_WORK(&psock->work, sk_psock_backlog);
+	mutex_init(&psock->work_mutex);
 	INIT_LIST_HEAD(&psock->ingress_msg);
 	spin_lock_init(&psock->ingress_lock);
 	skb_queue_head_init(&psock->ingress_skb);
@@ -631,7 +631,7 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 	}
 }
 
-static void sk_psock_zap_ingress(struct sk_psock *psock)
+static void __sk_psock_zap_ingress(struct sk_psock *psock)
 {
 	struct sk_buff *skb;
 
@@ -639,9 +639,7 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 	}
-	spin_lock_bh(&psock->ingress_lock);
 	__sk_psock_purge_ingress_msg(psock);
-	spin_unlock_bh(&psock->ingress_lock);
 }
 
 static void sk_psock_link_destroy(struct sk_psock *psock)
@@ -654,6 +652,18 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
+void sk_psock_stop(struct sk_psock *psock, bool wait)
+{
+	spin_lock_bh(&psock->ingress_lock);
+	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
+	sk_psock_cork_free(psock);
+	__sk_psock_zap_ingress(psock);
+	spin_unlock_bh(&psock->ingress_lock);
+
+	if (wait)
+		cancel_work_sync(&psock->work);
+}
+
 static void sk_psock_done_strp(struct sk_psock *psock);
 
 static void sk_psock_destroy_deferred(struct work_struct *gc)
@@ -665,12 +675,12 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	sk_psock_done_strp(psock);
 
 	cancel_work_sync(&psock->work);
+	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
 
 	sk_psock_link_destroy(psock);
 	sk_psock_cork_free(psock);
-	sk_psock_zap_ingress(psock);
 
 	if (psock->sk_redir)
 		sock_put(psock->sk_redir);
@@ -688,8 +698,7 @@ static void sk_psock_destroy(struct rcu_head *rcu)
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sk_psock_cork_free(psock);
-	sk_psock_zap_ingress(psock);
+	sk_psock_stop(psock, false);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_psock_restore_proto(sk, psock);
@@ -699,7 +708,6 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	else if (psock->progs.stream_verdict)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
-	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 
 	call_rcu(&psock->rcu, sk_psock_destroy);
 }
@@ -770,14 +778,20 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 * error that caused the pipe to break. We can't send a packet on
 	 * a socket that is in this state so we drop the skb.
 	 */
-	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
-	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
+		kfree_skb(skb);
+		return;
+	}
+	spin_lock_bh(&psock_other->ingress_lock);
+	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+		spin_unlock_bh(&psock_other->ingress_lock);
 		kfree_skb(skb);
 		return;
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
 	schedule_work(&psock_other->work);
+	spin_unlock_bh(&psock_other->ingress_lock);
 }
 
 static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
@@ -845,8 +859,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			err = sk_psock_skb_ingress_self(psock, skb);
 		}
 		if (err < 0) {
-			skb_queue_tail(&psock->ingress_skb, skb);
-			schedule_work(&psock->work);
+			spin_lock_bh(&psock->ingress_lock);
+			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
+				skb_queue_tail(&psock->ingress_skb, skb);
+				schedule_work(&psock->work);
+			}
+			spin_unlock_bh(&psock->ingress_lock);
 		}
 		break;
 	case __SK_REDIRECT:
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index dd53a7771d7e..e564fdeaada1 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1540,6 +1540,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
+	sk_psock_stop(psock, true);
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
-- 
2.25.1

