Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F74634F6C3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhCaCdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhCaCcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:52 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4944C061574;
        Tue, 30 Mar 2021 19:32:52 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id j20-20020a4ad6d40000b02901b66fe8acd6so4259203oot.7;
        Tue, 30 Mar 2021 19:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZvA8CFNzThNTsW5v98MoXpze0rMZogre745UZc6yQ9M=;
        b=Qe3RKQW7aUk8/pZP4tsx3BPI9VOUnq/bfcWfEsG0pQjpyfyX3PuTGl2KK2ZEmZvFW9
         NfSZsaxggGLw69r3+xd7cKUdwfzO/sF/NwQVVTKcGBsv9I3QZSJX4e9/EiTTecAdD09E
         YzVSX5Y8M7TBh2QVUqEoR2nsVfBXxuusPmFs4YwObLjJRK6ZlfbTEUkDKlBqejzheDAo
         ajH7I0W4WrzI3HMDkndFvxUSbhGjMZD6oMVICkv+z3cHkbuqGCzdAWHffdsBNsQ2h8pO
         ZnIMM5ZUD1WT6U768PA07zCqbiTQypYn5zBxYFm7cTKZi3VkZgYZEjJ8Sl13IXeH7HlU
         3oFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZvA8CFNzThNTsW5v98MoXpze0rMZogre745UZc6yQ9M=;
        b=t2cL0QsoQcWO2Zp9X1H8XOlXw3WfNnEaHlTgP3b1vSktEb1KELt+XqhaorooFu4IuW
         evQSVciaK8D4CMHyJ4EB5cyuzr6WBPNlquL3XkOI2b5DW4YbWYGU7DPfrGpni4N+yVjq
         mQBc1dJ4dnhjkaZgXDd8Bb2eIJVDHoTNMVwsjHQkmwIdXbtCIKj/fCQNWUFt3GjhfO6o
         7qH5jAZHXU3dSRGVkxXFtYeQxvQEJQOlBX4PiVff72hYDAyNsRH0gmFtzTbpzK7tarRi
         gsoYzA/JooACi9h0JQQnKG7RVbGypvv/mxu27i/zsz4PMmuOloDeP2eVmwWrpDyfIS4h
         rB9A==
X-Gm-Message-State: AOAM5318R8j9keSQbH4f/jCeg68YAzWDMNj2XP2/PDdvHnL5imu6mVAZ
        g8FhstQfB94HjQggGWxVqMrFUbi8Ezi5Vg==
X-Google-Smtp-Source: ABdhPJyvGV4B4CPWCrLxsJuhVsQNBTfwalnuzK3bGzpC17ipe73C0eD/BIEzLFu0qHzl8tQBJt8BfA==
X-Received: by 2002:a4a:7615:: with SMTP id t21mr853554ooc.72.1617157971947;
        Tue, 30 Mar 2021 19:32:51 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:51 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v8 04/16] skmsg: avoid lock_sock() in sk_psock_backlog()
Date:   Tue, 30 Mar 2021 19:32:25 -0700
Message-Id: <20210331023237.41094-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
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

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
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

