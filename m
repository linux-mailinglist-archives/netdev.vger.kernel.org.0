Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31C73A4EB1
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhFLMfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:35:15 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:2771 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhFLMfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623501195; x=1655037195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uT6Co2uKv3LlfdvftofxNS11yzsJS/XcuhqyECpyEYU=;
  b=qGsMtCdUhVQBGfQz4YJbtUHH4M7qhqXN6tqfN09UeVDhnnLY4GHq+WPU
   zj1CM6sxsS0zivudUpbZA0P/3xBtGj+c0dDVLW+HRDQTideFnD3lAVZJ5
   EqLlW880pZmBCqm+/YY1Lss8MgwOK8Tya6v8PPs2Tkk5F0IU62uSuW25I
   A=;
X-IronPort-AV: E=Sophos;i="5.83,268,1616457600"; 
   d="scan'208";a="115428265"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 12 Jun 2021 12:33:14 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 9551CA1E97;
        Sat, 12 Jun 2021 12:33:10 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:33:09 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:33:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 bpf-next 02/11] tcp: Add num_closed_socks to struct sock_reuseport.
Date:   Sat, 12 Jun 2021 21:32:15 +0900
Message-ID: <20210612123224.12525-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210612123224.12525-1-kuniyu@amazon.co.jp>
References: <20210612123224.12525-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the following commit, a closed listener has to hold the
reference to the reuseport group for socket migration. This patch adds a
field (num_closed_socks) to struct sock_reuseport to manage closed sockets
within the same reuseport group. Moreover, this and the following commits
introduce some helper functions to split socks[] into two sections and keep
TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
sockets from the end.

  TCP_LISTEN---------->       <-------TCP_CLOSE
  +---+---+  ---  +---+  ---  +---+  ---  +---+
  | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
  +---+---+  ---  +---+  ---  +---+  ---  +---+

  i = num_socks - 1
  j = max_socks - num_closed_socks
  k = max_socks - 1

This patch also extends reuseport_add_sock() and reuseport_grow() to
support num_closed_socks.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/sock_reuseport.h |  5 ++-
 net/core/sock_reuseport.c    | 75 +++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 505f1e18e9bf..0e558ca7afbf 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -13,8 +13,9 @@ extern spinlock_t reuseport_lock;
 struct sock_reuseport {
 	struct rcu_head		rcu;
 
-	u16			max_socks;	/* length of socks */
-	u16			num_socks;	/* elements in socks */
+	u16			max_socks;		/* length of socks */
+	u16			num_socks;		/* elements in socks */
+	u16			num_closed_socks;	/* closed elements in socks */
 	/* The last synq overflow event timestamp of this
 	 * reuse->socks[] group.
 	 */
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index b065f0a103ed..f478c65a281b 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -18,6 +18,49 @@ DEFINE_SPINLOCK(reuseport_lock);
 
 static DEFINE_IDA(reuseport_ida);
 
+static int reuseport_sock_index(struct sock *sk,
+				const struct sock_reuseport *reuse,
+				bool closed)
+{
+	int left, right;
+
+	if (!closed) {
+		left = 0;
+		right = reuse->num_socks;
+	} else {
+		left = reuse->max_socks - reuse->num_closed_socks;
+		right = reuse->max_socks;
+	}
+
+	for (; left < right; left++)
+		if (reuse->socks[left] == sk)
+			return left;
+	return -1;
+}
+
+static void __reuseport_add_sock(struct sock *sk,
+				 struct sock_reuseport *reuse)
+{
+	reuse->socks[reuse->num_socks] = sk;
+	/* paired with smp_rmb() in reuseport_select_sock() */
+	smp_wmb();
+	reuse->num_socks++;
+}
+
+static bool __reuseport_detach_sock(struct sock *sk,
+				    struct sock_reuseport *reuse)
+{
+	int i = reuseport_sock_index(sk, reuse, false);
+
+	if (i == -1)
+		return false;
+
+	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
+	reuse->num_socks--;
+
+	return true;
+}
+
 static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 {
 	unsigned int size = sizeof(struct sock_reuseport) +
@@ -72,9 +115,9 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 	}
 
 	reuse->reuseport_id = id;
+	reuse->bind_inany = bind_inany;
 	reuse->socks[0] = sk;
 	reuse->num_socks = 1;
-	reuse->bind_inany = bind_inany;
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
 
 out:
@@ -98,6 +141,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 		return NULL;
 
 	more_reuse->num_socks = reuse->num_socks;
+	more_reuse->num_closed_socks = reuse->num_closed_socks;
 	more_reuse->prog = reuse->prog;
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
@@ -105,9 +149,13 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));
+	memcpy(more_reuse->socks +
+	       (more_reuse->max_socks - more_reuse->num_closed_socks),
+	       reuse->socks + (reuse->max_socks - reuse->num_closed_socks),
+	       reuse->num_closed_socks * sizeof(struct sock *));
 	more_reuse->synq_overflow_ts = READ_ONCE(reuse->synq_overflow_ts);
 
-	for (i = 0; i < reuse->num_socks; ++i)
+	for (i = 0; i < reuse->max_socks; ++i)
 		rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
 				   more_reuse);
 
@@ -158,7 +206,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 		return -EBUSY;
 	}
 
-	if (reuse->num_socks == reuse->max_socks) {
+	if (reuse->num_socks + reuse->num_closed_socks == reuse->max_socks) {
 		reuse = reuseport_grow(reuse);
 		if (!reuse) {
 			spin_unlock_bh(&reuseport_lock);
@@ -166,10 +214,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 		}
 	}
 
-	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_select_sock() */
-	smp_wmb();
-	reuse->num_socks++;
+	__reuseport_add_sock(sk, reuse);
 	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
 
 	spin_unlock_bh(&reuseport_lock);
@@ -183,7 +228,6 @@ EXPORT_SYMBOL(reuseport_add_sock);
 void reuseport_detach_sock(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
-	int i;
 
 	spin_lock_bh(&reuseport_lock);
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
@@ -200,16 +244,11 @@ void reuseport_detach_sock(struct sock *sk)
 	bpf_sk_reuseport_detach(sk);
 
 	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
+	__reuseport_detach_sock(sk, reuse);
+
+	if (reuse->num_socks + reuse->num_closed_socks == 0)
+		call_rcu(&reuse->rcu, reuseport_free_rcu);
 
-	for (i = 0; i < reuse->num_socks; i++) {
-		if (reuse->socks[i] == sk) {
-			reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-			reuse->num_socks--;
-			if (reuse->num_socks == 0)
-				call_rcu(&reuse->rcu, reuseport_free_rcu);
-			break;
-		}
-	}
 	spin_unlock_bh(&reuseport_lock);
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
@@ -274,7 +313,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
 	prog = rcu_dereference(reuse->prog);
 	socks = READ_ONCE(reuse->num_socks);
 	if (likely(socks)) {
-		/* paired with smp_wmb() in reuseport_add_sock() */
+		/* paired with smp_wmb() in __reuseport_add_sock() */
 		smp_rmb();
 
 		if (!prog || !skb)
-- 
2.30.2

