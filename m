Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDDF345402
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhCWAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhCWAiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:23 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CBBC061574;
        Mon, 22 Mar 2021 17:38:22 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id o5so12692691qkb.0;
        Mon, 22 Mar 2021 17:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sUw/wwXeIFJjpvMM2bx490PBJI5xdu8qJvmZO6V0IWw=;
        b=mfI6O9fB1WPFFVbN0LFKUX3IadnsIwSIzzJtQi/huMuYcOgt8eHGPChBQMmxILMiaY
         bmFhVu3thpPSy5OGxkZYOIfW1R6ZKKBc5+94DnEH+fv1Zj+7aWrnpPsOV905tTFAIxKN
         x3JRKcvY35OBWPffmWdzQRxuCRp9gGMZ1n1JrGSNOFk+hzcN6xqS9n33X64Ih1LQDCJK
         af+sAwr5QHVyRknq0yOOSKJo79Vw0KTCdsjOxbKIsvYr84UTcIM7cPbF7shPGyuCcNYz
         KDg5KhtDJRQsXvdXmUGit8nqMwe84Avo8PblOUSrGnqUJRgUgmwe+n9kz6Ia8uYNgCbW
         DqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUw/wwXeIFJjpvMM2bx490PBJI5xdu8qJvmZO6V0IWw=;
        b=sNr7BH1LeUPseo3KuhOsp8E2+tkNPnYwIqPsZHfqRvMlyMcNWAYOa4GEqlakii87l0
         cS003Nf93hRsVM0akBEjAiNoy5efwI/01LNfOBATFmb8oJPLz2oQKr83Hqu90OswbmdI
         KZ8jHoqqQ8lqjWPQLRcLiZk+GVjoRBveUkgeAV/umGVj+7WbHWETPOtAfASHN8Yw2mwX
         7Y9lSfJlS/JTBMQWqErdtt0dNJ+I0B1kzMIH6PFIvhBnqOepf484I7MCo2tAKN6PtZ8f
         G4wOTZE9atDfXrFRqBPvsPqCnarNLIq4PnBFg60b83Bs6mYGoZCuubwEHsCPqC91NoNc
         hRCQ==
X-Gm-Message-State: AOAM532iRs9s7AB4E0YgDfZlT7LFFPN8uDHu/vVE32KjOE7GjIK6AAkZ
        E0hyLLf4ySjWmnF1GsLbQIAL9hPr3qBjsA==
X-Google-Smtp-Source: ABdhPJxpHIJNeRMd1pSx9rSiIpUCTZnHyp7jFWeI37GmiwgovWgtCsK259+1cmFgNZ7/8H2RPbA4tA==
X-Received: by 2002:a37:9fce:: with SMTP id i197mr2833061qke.155.1616459901767;
        Mon, 22 Mar 2021 17:38:21 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:21 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 04/12] skmsg: avoid lock_sock() in sk_psock_backlog()
Date:   Mon, 22 Mar 2021 17:38:00 -0700
Message-Id: <20210323003808.16074-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
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
 net/core/skmsg.c      | 51 +++++++++++++++++++++++++++----------------
 net/core/sock_map.c   |  1 +
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index f2d45a73b2b2..cf23e6e2cf54 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
+void sk_psock_stop(struct sk_psock *psock, bool wait);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 305dddc51857..9176add87643 100644
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
 
@@ -639,9 +635,7 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 	}
-	spin_lock_bh(&psock->ingress_lock);
 	__sk_psock_purge_ingress_msg(psock);
-	spin_unlock_bh(&psock->ingress_lock);
 }
 
 static void sk_psock_link_destroy(struct sk_psock *psock)
@@ -654,6 +648,18 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
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
@@ -670,7 +676,6 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 
 	sk_psock_link_destroy(psock);
 	sk_psock_cork_free(psock);
-	sk_psock_zap_ingress(psock);
 
 	if (psock->sk_redir)
 		sock_put(psock->sk_redir);
@@ -688,8 +693,7 @@ static void sk_psock_destroy(struct rcu_head *rcu)
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sk_psock_cork_free(psock);
-	sk_psock_zap_ingress(psock);
+	sk_psock_stop(psock, false);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_psock_restore_proto(sk, psock);
@@ -699,7 +703,6 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 	else if (psock->progs.stream_verdict)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
-	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 
 	call_rcu(&psock->rcu, sk_psock_destroy);
 }
@@ -770,14 +773,20 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
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
@@ -845,8 +854,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
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

