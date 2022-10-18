Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F17D6020D6
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJRCFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiJRCEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:04:10 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0108B2D6;
        Mon, 17 Oct 2022 19:03:22 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id s17so6682134qkj.12;
        Mon, 17 Oct 2022 19:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aoirGKg4gTrRqB4P2/n3tq5slBjolNc0D3yNCMd0cPs=;
        b=n3vISoi4pRYBlrgO4l3NVwh5Z6FyDxXzPrHxMRT/5c6IvGaW9rJBGItTE/+VZU+aHj
         sbjVfaJooDOH5iupqtcKezPK4c5CuNFcmlwOv9hWDVqfDguT5gCWZF0+68VgH9Ofcl22
         fMSe1lBmSJyFMya0r7X8PsbBlVay3+/8HaeobsWn9d2N3igFNwe/EOsjw64phOdlS8Q/
         gNi5xGSOZ6CMsBcYkjNzj/5s9/Ud5IgTZmP2AtyQKvOcbF1Zxio4v4SEsCuWLw4UARQ6
         0vtF0EqV1eBswX2lT0lWwgcFzFUtNCzMt+9NFiPfqcQxzpbMuWGJ7kesOs6cXgsTBCxj
         RzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aoirGKg4gTrRqB4P2/n3tq5slBjolNc0D3yNCMd0cPs=;
        b=56eVVdZe/oRu8siNnQJEHqPrhqqRT5EvR/Jk44REpZLVvxw20e8BownrJuDSBgxUIC
         8EbtLjnY4a9BEfAnLMulHtKN+46DY2a9cq1vwQoR55EeDQ8mW5wO32B0wJCEXGLxl9TV
         +NLtfPSVr/m8YHJVyZcGJ7lpa0Rzin2jbR0V72Ib9WxxyoouofV/2n1xtKVCuJ/MDgRW
         hYDH/wCEnQEIsIVDxsdq+9U+w3Vig178BqIIZ1CFDYeC7TsLrM7jvUzY/Ldsth2OpffP
         kgo8awl+Sjg7AFwhKuCL/c092PVjDdHtHS/Q+7UY4RQJR3MGCxCikuyzGdi7eNhBO/HR
         sbNQ==
X-Gm-Message-State: ACrzQf3krCpqX4RsPloXzU0q2A/qORJTQzzi06mXxgLOLzjtMbdVn4Ee
        LhR7EkQBv+cStHWxBjErq5G/Epw6ZMA=
X-Google-Smtp-Source: AMsMyM7dcypVvE9tudTsxJyzN2r68C8a6cGWb8UizJ1ryk57Ce+OJuDData2m3cmTwBWRNWrwVOynw==
X-Received: by 2002:a05:620a:40cd:b0:6da:7a25:5920 with SMTP id g13-20020a05620a40cd00b006da7a255920mr361582qko.721.1666058600507;
        Mon, 17 Oct 2022 19:03:20 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2223:bd39:9204:a41d])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a288c00b006b640efe6dasm1243762qkp.132.2022.10.17.19.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 19:03:19 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
Date:   Mon, 17 Oct 2022 19:02:58 -0700
Message-Id: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Technically we don't need lock the sock in the psock work, but we
need to prevent this work running in parallel with sock_map_close().

With this, we no longer need to wait for the psock->work synchronously,
because when we reach here, either this work is still pending, or
blocking on the lock_sock(), or it is completed. We only need to cancel
the first case asynchronously, and we need to bail out the second case
quickly by checking SK_PSOCK_TX_ENABLED bit.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Reported-by: Stanislav Fomichev <sdf@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  2 +-
 net/core/skmsg.c      | 19 +++++++++++++------
 net/core/sock_map.c   |  4 ++--
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 48f4b645193b..70d6cb94e580 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -376,7 +376,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
-void sk_psock_stop(struct sk_psock *psock, bool wait);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ca70525621c7..c329e71ea924 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -647,6 +647,11 @@ static void sk_psock_backlog(struct work_struct *work)
 	int ret;
 
 	mutex_lock(&psock->work_mutex);
+	lock_sock(psock->sk);
+
+	if (!sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+		goto end;
+
 	if (unlikely(state->skb)) {
 		spin_lock_bh(&psock->ingress_lock);
 		skb = state->skb;
@@ -672,9 +677,12 @@ static void sk_psock_backlog(struct work_struct *work)
 		skb_bpf_redirect_clear(skb);
 		do {
 			ret = -EIO;
-			if (!sock_flag(psock->sk, SOCK_DEAD))
+			if (!sock_flag(psock->sk, SOCK_DEAD)) {
+				release_sock(psock->sk);
 				ret = sk_psock_handle_skb(psock, skb, off,
 							  len, ingress);
+				lock_sock(psock->sk);
+			}
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
 					sk_psock_skb_state(psock, state, skb,
@@ -695,6 +703,7 @@ static void sk_psock_backlog(struct work_struct *work)
 			kfree_skb(skb);
 	}
 end:
+	release_sock(psock->sk);
 	mutex_unlock(&psock->work_mutex);
 }
 
@@ -803,16 +812,14 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
-void sk_psock_stop(struct sk_psock *psock, bool wait)
+void sk_psock_stop(struct sk_psock *psock)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
 	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
-
-	if (wait)
-		cancel_work_sync(&psock->work);
+	cancel_work(&psock->work);
 }
 
 static void sk_psock_done_strp(struct sk_psock *psock);
@@ -850,7 +857,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a660baedd9e7..d4e11d7f459c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
@@ -1619,7 +1619,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
+	sk_psock_stop(psock);
 	sk_psock_put(sk, psock);
 	release_sock(sk);
 	saved_close(sk, timeout);
-- 
2.34.1

