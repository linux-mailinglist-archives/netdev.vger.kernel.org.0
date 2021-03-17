Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04DA33E6BB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhCQCXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCQCWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:22:50 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5671C06175F;
        Tue, 16 Mar 2021 19:22:49 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id f73-20020a9d03cf0000b02901b4d889bce0so367550otf.12;
        Tue, 16 Mar 2021 19:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8xgB3I/bbcUCfo36y9TmthKP+rXIjWuLX4Yzv+5PCxI=;
        b=eKUsyjIgU1b3ZTJR7mzK0DIEvD23CnM1ep4l8c6DHn5DbRafpWFpImCi+t4apXEN5a
         ilU2hRNLK5+RNYU1o3RdGnOoxJRHX1loED//r0WFxNY2pplaN+OJXpcTipfSaJY9Ky2Z
         B9RVkUQzXM0DH+5iJeMys9oVaPTykxMw6+E6dalGAU0Yvj7WxqQcHf+n+dn3azbdFL0G
         EYqSCwWbnRcg+JPDLlCTgTYr3CJoLkLmT2FXKpUXwRgJ5KAWMwBsl6yc5XlojzkUFs/h
         bfvKkXsoywgufwTeMtPcoVfZ+nVqUK271P2Fl+JLjT44JaaJREQrfKP3vwwKU1r65aNL
         koog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8xgB3I/bbcUCfo36y9TmthKP+rXIjWuLX4Yzv+5PCxI=;
        b=DNhk/zCzJlTx1oTuu30iEeHWvHVcEEyBqKHw92Kt+NEly7XAg2AQYmG2TMBc+BYN6a
         9CqlgoCbd0lbMZs0f7MhoqlUv5BrVQsm1HHnc5PTLcVgBjBXRfTRak2TcmzBDNRO8sKt
         T1nYnbrx+XfgaRRwBjVcQjWJ296QZxb3wnp1HV4PcT1gLsKYet0DRBp1DZe+21PIUImP
         RhpLOsivQaWGyFx849xMpORhnhKDUmqSkihg/IMrqeefTC+tPQRyQJtQ4qPxJ4XBNqMl
         rM/N7UJXIOiqKNEbPO5p2hJYuewcGOfOp/8MfWqefnwcogzjmqHQ3mAR66dq2FKPkvff
         uB/A==
X-Gm-Message-State: AOAM530IjkEIU0HU1GOTuHI2sBbs+MgLvdmeNQdOTM4/gIz/Lop6fiU/
        bFqZDY98uEhls5KXJGUhEI4ShILQiy8oxA==
X-Google-Smtp-Source: ABdhPJyWOJqj4ex0ou/4R65iih8uHuX4nHH+q5i1JOWuVG5W4alD+ye3iOCqwBfrMQrMVwqj2uSe7A==
X-Received: by 2002:a9d:4c0a:: with SMTP id l10mr1450337otf.136.1615947769101;
        Tue, 16 Mar 2021 19:22:49 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:48 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v5 04/11] skmsg: avoid lock_sock() in sk_psock_backlog()
Date:   Tue, 16 Mar 2021 19:22:12 -0700
Message-Id: <20210317022219.24934-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
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

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      | 50 +++++++++++++++++++++++++++++++------------
 net/core/sock_map.c   |  1 +
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index f2d45a73b2b2..0f5e663f6c7f 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 305dddc51857..d0a227b0f672 100644
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
@@ -511,8 +511,6 @@ static void sk_psock_backlog(struct work_struct *work)
 	u32 len, off;
 	int ret;
 
-	/* Lock sock to avoid losing sk_socket during loop. */
-	lock_sock(psock->sk);
 	if (state->skb) {
 		skb = state->skb;
 		len = state->len;
@@ -529,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
 		skb_bpf_redirect_clear(skb);
 		do {
 			ret = -EIO;
-			if (likely(psock->sk->sk_socket))
+			if (!sock_flag(psock->sk, SOCK_DEAD))
 				ret = sk_psock_handle_skb(psock, skb, off,
 							  len, ingress);
 			if (ret <= 0) {
@@ -537,13 +535,13 @@ static void sk_psock_backlog(struct work_struct *work)
 					state->skb = skb;
 					state->len = len;
 					state->off = off;
-					goto end;
+					return;
 				}
 				/* Hard errors break pipe and stop xmit. */
 				sk_psock_report_error(psock, ret ? -ret : EPIPE);
 				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 				kfree_skb(skb);
-				goto end;
+				return;
 			}
 			off += ret;
 			len -= ret;
@@ -552,8 +550,6 @@ static void sk_psock_backlog(struct work_struct *work)
 		if (!ingress)
 			kfree_skb(skb);
 	}
-end:
-	release_sock(psock->sk);
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node)
@@ -631,7 +627,7 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 	}
 }
 
-static void sk_psock_zap_ingress(struct sk_psock *psock)
+static void __sk_psock_zap_ingress(struct sk_psock *psock)
 {
 	struct sk_buff *skb;
 
@@ -639,8 +635,13 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 	}
-	spin_lock_bh(&psock->ingress_lock);
 	__sk_psock_purge_ingress_msg(psock);
+}
+
+static void sk_psock_zap_ingress(struct sk_psock *psock)
+{
+	spin_lock_bh(&psock->ingress_lock);
+	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
@@ -654,6 +655,17 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
+void sk_psock_stop(struct sk_psock *psock)
+{
+	spin_lock_bh(&psock->ingress_lock);
+	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
+	sk_psock_cork_free(psock);
+	__sk_psock_zap_ingress(psock);
+	spin_unlock_bh(&psock->ingress_lock);
+
+	cancel_work_sync(&psock->work);
+}
+
 static void sk_psock_done_strp(struct sk_psock *psock);
 
 static void sk_psock_destroy_deferred(struct work_struct *gc)
@@ -770,14 +782,20 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
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
@@ -845,8 +863,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
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
index dd53a7771d7e..7c3589fc13bb 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1540,6 +1540,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
+	sk_psock_stop(psock);
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
-- 
2.25.1

