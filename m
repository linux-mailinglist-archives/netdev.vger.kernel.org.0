Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570BF38CD3D
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbhEUSYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:24:00 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45648 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhEUSX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621621355; x=1653157355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ktGOu+h6uAAVBSHn2akQ04CsRvHOKKKIdXwuzOYaYIE=;
  b=sB/ACFEeo309kiNg0XEl7ZU69g5IvFNCgXqBrobvupHNAIHO0aINEfBz
   LDk7kjAeVFS0uiCOetkN0XKo9zmect17nax7+xY5iUKFZMG/THPshhFf2
   BsY9YzRejKsLcKOkH3loIiO66tUhhsAa7fbsMdiwbtzOmUv2BISjmdp2L
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,319,1613433600"; 
   d="scan'208";a="109418185"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 21 May 2021 18:22:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 94175A288D;
        Fri, 21 May 2021 18:22:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 18:22:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.224) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 18:22:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 bpf-next 04/11] tcp: Add reuseport_migrate_sock() to select a new listener.
Date:   Sat, 22 May 2021 03:20:57 +0900
Message-ID: <20210521182104.18273-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521182104.18273-1-kuniyu@amazon.co.jp>
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.224]
X-ClientProxiedBy: EX13D17UWB003.ant.amazon.com (10.43.161.42) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reuseport_migrate_sock() does the same check done in
reuseport_listen_stop_sock(). If the reuseport group is capable of
migration, reuseport_migrate_sock() selects a new listener by the child
socket hash and increments the listener's sk_refcnt beforehand. Thus, if we
fail in the migration, we have to decrement it later.

We will support migration by eBPF in the later commits.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/sock_reuseport.h |  3 ++
 net/core/sock_reuseport.c    | 78 +++++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 1333d0cddfbc..473b0b0fa4ab 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -37,6 +37,9 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
 					  u32 hash,
 					  struct sk_buff *skb,
 					  int hdr_len);
+struct sock *reuseport_migrate_sock(struct sock *sk,
+				    struct sock *migrating_sk,
+				    struct sk_buff *skb);
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index ea0e900d3e97..193a3281ddda 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -44,7 +44,7 @@ static void __reuseport_add_sock(struct sock *sk,
 				 struct sock_reuseport *reuse)
 {
 	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_select_sock() */
+	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
 	smp_wmb();
 	reuse->num_socks++;
 }
@@ -435,6 +435,23 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
 	return reuse->socks[index];
 }
 
+static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
+						  u32 hash, u16 num_socks)
+{
+	int i, j;
+
+	i = j = reciprocal_scale(hash, num_socks);
+	while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
+		i++;
+		if (i >= num_socks)
+			i = 0;
+		if (i == j)
+			return NULL;
+	}
+
+	return reuse->socks[i];
+}
+
 /**
  *  reuseport_select_sock - Select a socket from an SO_REUSEPORT group.
  *  @sk: First socket in the group.
@@ -478,19 +495,8 @@ struct sock *reuseport_select_sock(struct sock *sk,
 
 select_by_hash:
 		/* no bpf or invalid bpf result: fall back to hash usage */
-		if (!sk2) {
-			int i, j;
-
-			i = j = reciprocal_scale(hash, socks);
-			while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
-				i++;
-				if (i >= socks)
-					i = 0;
-				if (i == j)
-					goto out;
-			}
-			sk2 = reuse->socks[i];
-		}
+		if (!sk2)
+			sk2 = reuseport_select_sock_by_hash(reuse, hash, socks);
 	}
 
 out:
@@ -499,6 +505,50 @@ struct sock *reuseport_select_sock(struct sock *sk,
 }
 EXPORT_SYMBOL(reuseport_select_sock);
 
+/**
+ *  reuseport_migrate_sock - Select a socket from an SO_REUSEPORT group.
+ *  @sk: close()ed or shutdown()ed socket in the group.
+ *  @migrating_sk: ESTABLISHED/SYN_RECV full socket in the accept queue or
+ *    NEW_SYN_RECV request socket during 3WHS.
+ *  @skb: skb to run through BPF filter.
+ *  Returns a socket (with sk_refcnt +1) that should accept the child socket
+ *  (or NULL on error).
+ */
+struct sock *reuseport_migrate_sock(struct sock *sk,
+				    struct sock *migrating_sk,
+				    struct sk_buff *skb)
+{
+	struct sock_reuseport *reuse;
+	struct sock *nsk = NULL;
+	u16 socks;
+	u32 hash;
+
+	rcu_read_lock();
+
+	reuse = rcu_dereference(sk->sk_reuseport_cb);
+	if (!reuse)
+		goto out;
+
+	socks = READ_ONCE(reuse->num_socks);
+	if (unlikely(!socks))
+		goto out;
+
+	/* paired with smp_wmb() in __reuseport_add_sock() */
+	smp_rmb();
+
+	hash = migrating_sk->sk_hash;
+	if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
+		nsk = reuseport_select_sock_by_hash(reuse, hash, socks);
+
+	if (nsk && unlikely(!refcount_inc_not_zero(&nsk->sk_refcnt)))
+		nsk = NULL;
+
+out:
+	rcu_read_unlock();
+	return nsk;
+}
+EXPORT_SYMBOL(reuseport_migrate_sock);
+
 int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 {
 	struct sock_reuseport *reuse;
-- 
2.30.2

