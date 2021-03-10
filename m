Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DCF33354E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhCJFdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCJFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:33:03 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A340C061762;
        Tue,  9 Mar 2021 21:32:36 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id l7so3704268qtq.7;
        Tue, 09 Mar 2021 21:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KytboVyhhl6Gmf2upv0pcKByMVhcWe4p37EfgN7ElTc=;
        b=kYO0bbVyP+HTx0BdMQV40Atr4R/ERxNROHn0owu8dCqIGX6nSEj0kDC7xy1rl8KMnD
         zbecGtGjTWEgDVpP5gfr5DXn8ceXoPgijZuNhuw9r2jsuWvoEzeRNx3o4QjTEP1kq5VB
         lPWzL6E23MKFrED76pUbVHr91aXCtNV8sDxHi99q2ETxZdho0DYQwxSJH9ZEZoxCdjlr
         IHAkzXZ+XOfjqjhYKDniUcg7zeJnVmDNpWU+8pZ5h7HAG1zXIyxkcEpUQPKBPWkewdt5
         gRD2VuwgTXFM/LssuFh0XcmVAIvrUKbH4k1MZgx8bZDvpFTIQ0Gu2Ao0Ke6lRInp6Jpv
         86Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KytboVyhhl6Gmf2upv0pcKByMVhcWe4p37EfgN7ElTc=;
        b=UEigbJPPyvTySJCSENY2br1bPzWIVPh7S4ATOAFdlvJHhGODRb7VgatXLS6jz3yxrS
         BiZXMTKc14sbRVit9yAyQZD6XxAh3WUZi6YmJO/u2ZmJfXnZ+efo1XlqzlldAAfW06rd
         1uUsZPzWHoe0iFnnizWpmaYu95Tehg6t7OZL4YRIbTnixgGAdad14ZfH/Xfx41mJUGYZ
         f15j0OQmUK2IHagtkdzQd05WHMYLrRgwwPbkIl6U73Z1eE/VqOMk8/Lw4RoI/gqxi5rY
         6M+I5/AhN9FDphZuik4l3MwHhKTZmgAycW4fKUfk6JeGr+MRWsJ+x6/SenieuwCvO7Ub
         1xCg==
X-Gm-Message-State: AOAM531onRGRM9IjDOkRiMIs2AC8nZwC5DX/p6gIGPrxcP2tbpquZ8Mq
        oS7CAP1lXMZ9F3+meoSES47YirxIzYzRYw==
X-Google-Smtp-Source: ABdhPJyXJK9aH5XYWxySyqp66IHsfuqvwzVUqSLih96LOQKIaVsd5eNNP5mTZvJRhpPLhWOQD8h2mw==
X-Received: by 2002:aed:2fa3:: with SMTP id m32mr1335835qtd.359.1615354355768;
        Tue, 09 Mar 2021 21:32:35 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:35 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 04/11] skmsg: avoid lock_sock() in sk_psock_backlog()
Date:   Tue,  9 Mar 2021 21:32:15 -0800
Message-Id: <20210310053222.41371-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
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

We do purge these queues when psock refcnt reaches 0 but
here we want to purge them explicitly in sock_map_close().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  1 +
 net/core/skmsg.c      | 22 ++++++++++++++--------
 net/core/sock_map.c   |  1 +
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 7333bf881b81..91b357817bb8 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
+void sk_psock_purge(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 41a5f82c53e6..bf0f874780c1 100644
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
@@ -654,6 +650,16 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
+void sk_psock_purge(struct sk_psock *psock)
+{
+	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
+
+	cancel_work_sync(&psock->work);
+
+	sk_psock_cork_free(psock);
+	sk_psock_zap_ingress(psock);
+}
+
 static void sk_psock_done_strp(struct sk_psock *psock);
 
 static void sk_psock_destroy_deferred(struct work_struct *gc)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index dd53a7771d7e..26ba47b099f1 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1540,6 +1540,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
+	sk_psock_purge(psock);
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
-- 
2.25.1

