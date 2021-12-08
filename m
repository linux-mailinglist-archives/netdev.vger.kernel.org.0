Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D355F46CDB0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhLHGZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:25:41 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:53639 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbhLHGZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1638944529; x=1670480529;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RlkFfG+rXcMBPqIjzAnSFdcKootl39FjWpUXiqUbPyc=;
  b=rY+/TASWWa2gfSKJMGOAhBVCclTPQO+jlGpqVJaRlgDZhE0iFC8MEss4
   xCog1dvlnCjsrft3qCTDZoe6Q6Lnupq6OFffDhTTPfpwBVV+MSimy+B7b
   wRJBLWjQuDZ4QCI4gpRzCOyJ7/J7unGETqTDaZPn/YrNJVZ3sIh0/kGYo
   c=;
X-IronPort-AV: E=Sophos;i="5.87,296,1631577600"; 
   d="scan'208";a="46970326"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-d-0230bc7b.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 08 Dec 2021 06:22:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-0230bc7b.us-east-1.amazon.com (Postfix) with ESMTPS id D8FF7C0AE2;
        Wed,  8 Dec 2021 06:22:07 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 06:22:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.159) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 06:22:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next] sock: Use sock_owned_by_user_nocheck() instead of sk_lock.owned.
Date:   Wed, 8 Dec 2021 15:21:58 +0900
Message-ID: <20211208062158.54132-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.159]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves sock_release_ownership() down in include/net/sock.h and
replaces some sk_lock.owned tests with sock_owned_by_user_nocheck().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/sock.h | 23 ++++++++++++-----------
 net/core/sock.c    |  4 ++--
 net/llc/llc_proc.c |  2 +-
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ae61cd0b650d..923864791c87 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1633,16 +1633,6 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 		__sk_mem_reclaim(sk, SK_RECLAIM_CHUNK);
 }
 
-static inline void sock_release_ownership(struct sock *sk)
-{
-	if (sk->sk_lock.owned) {
-		sk->sk_lock.owned = 0;
-
-		/* The sk_lock has mutex_unlock() semantics: */
-		mutex_release(&sk->sk_lock.dep_map, _RET_IP_);
-	}
-}
-
 /*
  * Macro so as to not evaluate some arguments when
  * lockdep is not enabled.
@@ -1769,12 +1759,23 @@ static inline bool sock_owned_by_user_nocheck(const struct sock *sk)
 	return sk->sk_lock.owned;
 }
 
+static inline void sock_release_ownership(struct sock *sk)
+{
+	if (sock_owned_by_user_nocheck(sk)) {
+		sk->sk_lock.owned = 0;
+
+		/* The sk_lock has mutex_unlock() semantics: */
+		mutex_release(&sk->sk_lock.dep_map, _RET_IP_);
+	}
+}
+
 /* no reclassification while locks are held */
 static inline bool sock_allow_reclassification(const struct sock *csk)
 {
 	struct sock *sk = (struct sock *)csk;
 
-	return !sk->sk_lock.owned && !spin_is_locked(&sk->sk_lock.slock);
+	return !sock_owned_by_user_nocheck(sk) &&
+		!spin_is_locked(&sk->sk_lock.slock);
 }
 
 struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
diff --git a/net/core/sock.c b/net/core/sock.c
index 4a499d255f40..764205a4d8c8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3292,7 +3292,7 @@ void lock_sock_nested(struct sock *sk, int subclass)
 
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
-	if (sk->sk_lock.owned)
+	if (sock_owned_by_user_nocheck(sk))
 		__lock_sock(sk);
 	sk->sk_lock.owned = 1;
 	spin_unlock_bh(&sk->sk_lock.slock);
@@ -3323,7 +3323,7 @@ bool __lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock)
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
 
-	if (!sk->sk_lock.owned) {
+	if (!sock_owned_by_user_nocheck(sk)) {
 		/*
 		 * Fast path return with bottom halves disabled and
 		 * sock::sk_lock.slock held.
diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
index 0ff490a73fae..07e9abb5978a 100644
--- a/net/llc/llc_proc.c
+++ b/net/llc/llc_proc.c
@@ -195,7 +195,7 @@ static int llc_seq_core_show(struct seq_file *seq, void *v)
 		   timer_pending(&llc->pf_cycle_timer.timer),
 		   timer_pending(&llc->rej_sent_timer.timer),
 		   timer_pending(&llc->busy_state_timer.timer),
-		   !!sk->sk_backlog.tail, !!sk->sk_lock.owned);
+		   !!sk->sk_backlog.tail, sock_owned_by_user_nocheck(sk));
 out:
 	return 0;
 }
-- 
2.30.2

