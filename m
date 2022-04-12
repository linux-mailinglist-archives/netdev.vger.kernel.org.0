Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8E4FEB1C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiDLXcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiDLXbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:31:55 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498C815AE13
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:27:06 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id o132so33778vko.11
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EHJU0bX552Ws+jez1ticz4oJcjIwpL/pBsuAb1MhPQw=;
        b=SnQKPj2om0katQvYFgE7+kuQZfQ2C5lYrcA2+bwHXyeY//eLa5U0dZXfJMqOKMNtHK
         6450rsOckSMIIzRj3nP8UNqWh9Ada01R++mfnY9lBSczTG3tnmMEqWpShMM65jaNRFUJ
         48Hcz9R56fVt9KG3YbzE3oganG7pD9oZBaj0zlFo5+ZzadQWDwK+C/T3VIetBH+DUNLE
         /op7sfmA6pTQEHyAKgYzQnMRqa0xRbJ3ZyPuWdkejVlKxrUvzNmUARWAS2Jmki7eQDP0
         bRQ2OzX7QIs9G6mPSahz5jOfY1R+6s7DsrdFkHd6yIPV0I9nPefF/aL1Zfms+ZeUtBeJ
         LAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHJU0bX552Ws+jez1ticz4oJcjIwpL/pBsuAb1MhPQw=;
        b=3wHhi5hxp6g+1YtWy18KQkwR5aMAyPDNPM3AoRxnGw5SliQlw9TqC8wdi0PMs7BDKr
         rr+ZYgun/gF+HKTVdG5X/kL+8Q1fTpLCCDtwyZ1oaaD/FAVu9/wnWtPfIY0ptb3ErB1k
         mxuzxARTgQeGB6hjayEPVxihn3g1zlSxlo+uZyerddvh8lVDrDaFI7q2Xj+lzrWoYueF
         ba1t+GzPrBwNu/byByg7MsVcJZDQ+xNiqUQZ9Cwy69IK8Bsh86AUBmMgQH2E7FPDGqIK
         OdqBQXLM5SnvHQJDS37/z6Rd/NqqumNtLO+eFTW58PHY2TrkJpxgy5ih7jYpWrWMCKAq
         TzrQ==
X-Gm-Message-State: AOAM532/Zu/u0r1cPUtr/b0dXsjserDKtrgyQsQfvrW+JEe+oV1mgiqI
        DqEO736GHCA0VRxalQdBRXGiaRW1z8o9uizi
X-Google-Smtp-Source: ABdhPJx1PutKa1NpJ3WKsrvWE5T1tICSKPQcUZPBYDY+AfXpPEIOGMkOq5u+zJ9AlJqSLIVLeG0sjQ==
X-Received: by 2002:a17:903:32c4:b0:156:8fd2:4aae with SMTP id i4-20020a17090332c400b001568fd24aaemr40670112plr.150.1649795178645;
        Tue, 12 Apr 2022 13:26:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm3609084pgf.17.2022.04.12.13.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:26:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] net: add support for socket no-lock
Date:   Tue, 12 Apr 2022 14:26:12 -0600
Message-Id: <20220412202613.234896-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412202613.234896-1-axboe@kernel.dk>
References: <20220412202613.234896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have a guaranteed single user of a socket, then we can optimize
the lock/release of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/net/sock.h | 10 ++++++++--
 net/core/sock.c    | 31 +++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 99fcc4d7eed9..aefc94677c94 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1674,7 +1674,7 @@ do {									\
 
 static inline bool lockdep_sock_is_held(const struct sock *sk)
 {
-	return lockdep_is_held(&sk->sk_lock) ||
+	return sk->sk_no_lock || lockdep_is_held(&sk->sk_lock) ||
 	       lockdep_is_held(&sk->sk_lock.slock);
 }
 
@@ -1774,18 +1774,20 @@ static inline void unlock_sock_fast(struct sock *sk, bool slow)
 static inline void sock_owned_by_me(const struct sock *sk)
 {
 #ifdef CONFIG_LOCKDEP
-	WARN_ON_ONCE(!lockdep_sock_is_held(sk) && debug_locks);
+	WARN_ON_ONCE(!sk->sk_no_lock && !lockdep_sock_is_held(sk) && debug_locks);
 #endif
 }
 
 static inline bool sock_owned_by_user(const struct sock *sk)
 {
 	sock_owned_by_me(sk);
+	smp_rmb();
 	return sk->sk_lock.owned;
 }
 
 static inline bool sock_owned_by_user_nocheck(const struct sock *sk)
 {
+	smp_rmb();
 	return sk->sk_lock.owned;
 }
 
@@ -1794,6 +1796,10 @@ static inline void sock_release_ownership(struct sock *sk)
 	if (sock_owned_by_user_nocheck(sk)) {
 		sk->sk_lock.owned = 0;
 
+		if (sk->sk_no_lock) {
+			smp_wmb();
+			return;
+		}
 		/* The sk_lock has mutex_unlock() semantics: */
 		mutex_release(&sk->sk_lock.dep_map, _RET_IP_);
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index fec892b384a4..d7eea29c5699 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2764,6 +2764,9 @@ void __lock_sock(struct sock *sk)
 {
 	DEFINE_WAIT(wait);
 
+	if (WARN_ON_ONCE(sk->sk_no_lock))
+		return;
+
 	for (;;) {
 		prepare_to_wait_exclusive(&sk->sk_lock.wq, &wait,
 					TASK_UNINTERRUPTIBLE);
@@ -3307,8 +3310,21 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 }
 EXPORT_SYMBOL(sock_init_data);
 
+static inline bool lock_sock_nolock(struct sock *sk)
+{
+	if (sk->sk_no_lock) {
+		sk->sk_lock.owned = 1;
+		smp_wmb();
+		return true;
+	}
+	return false;
+}
+
 void lock_sock_nested(struct sock *sk, int subclass)
 {
+	if (lock_sock_nolock(sk))
+		return;
+
 	/* The sk_lock has mutex_lock() semantics here. */
 	mutex_acquire(&sk->sk_lock.dep_map, subclass, 0, _RET_IP_);
 
@@ -3321,8 +3337,23 @@ void lock_sock_nested(struct sock *sk, int subclass)
 }
 EXPORT_SYMBOL(lock_sock_nested);
 
+static inline bool release_sock_nolock(struct sock *sk)
+{
+	if (!sk->sk_no_lock)
+		return false;
+	if (READ_ONCE(sk->sk_backlog.tail))
+		return false;
+	if (sk->sk_prot->release_cb)
+		sk->sk_prot->release_cb(sk);
+	sock_release_ownership(sk);
+	return true;
+}
+
 void release_sock(struct sock *sk)
 {
+	if (release_sock_nolock(sk))
+		return;
+
 	spin_lock_bh(&sk->sk_lock.slock);
 	if (sk->sk_backlog.tail)
 		__release_sock(sk);
-- 
2.35.1

