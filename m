Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECF546CD36
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhLHFnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:43:09 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:60383 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhLHFnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1638941978; x=1670477978;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=42XjcpyFwTA2jloUEROnoQKN/iX/+LeRP8ejTQ17Xlg=;
  b=D+8upmi8wrSulcTVwQ7gvD9JNmaZoRVyudU6HfeZA3be+LCS5LmwgkM7
   ceKMecoLcgrfY4IYCzZPlt5u+qokKwXRiU8e71omhrA8dax0cHQ4B796T
   1U6TGPEruBy+t5jhIddpzirYaxknDBaGfRJB1ZG3MUT8FDkwonwtQ+A0J
   A=;
X-IronPort-AV: E=Sophos;i="5.87,296,1631577600"; 
   d="scan'208";a="163457319"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Dec 2021 05:39:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id A97C642306;
        Wed,  8 Dec 2021 05:39:36 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 05:39:35 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.165) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 8 Dec 2021 05:39:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next] sock: Use sock_owned_by_user_nocheck() instead of sk_lock.owned.
Date:   Wed, 8 Dec 2021 14:39:24 +0900
Message-ID: <20211208053924.51254-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.165]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace sk_lock.owned tests with sock_owned_by_user_nocheck().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/sock.h | 5 +++--
 net/core/sock.c    | 4 ++--
 net/llc/llc_proc.c | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index e7c231373875..6b4f818dd594 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1635,7 +1635,7 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 
 static inline void sock_release_ownership(struct sock *sk)
 {
-	if (sk->sk_lock.owned) {
+	if (sock_owned_by_user_nocheck(sk) {
 		sk->sk_lock.owned = 0;
 
 		/* The sk_lock has mutex_unlock() semantics: */
@@ -1774,7 +1774,8 @@ static inline bool sock_allow_reclassification(const struct sock *csk)
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

