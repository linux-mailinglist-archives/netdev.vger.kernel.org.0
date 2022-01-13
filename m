Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C245A48CFAE
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiAMA31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:29:27 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:58672 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiAMA3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:29:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1642033763; x=1673569763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x7+RtK2UWEIljYZ4ANMCFG/WOf+/cR85I+8Cs+zoou4=;
  b=MSiNqIbv9GkqiGiWfsmkrwJb1LYo4ly9uxhqJnz+AIQlD/tQykb87Rc2
   2U2EkFovMwQfoRs4MupBURGQ/QYo6yllr/qOFVueJ0+O7A6i9rQx/mf3p
   YYUL/8N+0q6TH+jgGHYQG4KSs09ihNd8sJFDncdoxvMTlEI0nt4BL9sCj
   A=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208";a="165463196"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 13 Jan 2022 00:29:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id A1A5C1A007D;
        Thu, 13 Jan 2022 00:29:21 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 13 Jan 2022 00:29:20 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.142) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 13 Jan 2022 00:29:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 1/5] af_unix: Refactor unix_next_socket().
Date:   Thu, 13 Jan 2022 09:28:45 +0900
Message-ID: <20220113002849.4384-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220113002849.4384-1-kuniyu@amazon.co.jp>
References: <20220113002849.4384-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.142]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, unix_next_socket() is overloaded depending on the 2nd argument.
If it is NULL, unix_next_socket() returns the first socket in the hash.  If
not NULL, it returns the next socket in the same hash list or the first
socket in the next non-empty hash list.

This patch refactors unix_next_socket() into two functions unix_get_first()
and unix_get_next().  unix_get_first() newly acquires a lock and returns
the first socket in the list.  unix_get_next() returns the next socket in a
list or releases a lock and falls back to unix_get_first().

In the following patch, bpf iter holds entire sockets in a list and always
releases the lock before .show().  It always calls unix_get_first() to
acquire a lock in each iteration.  So, this patch makes the change easier
to follow.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 51 +++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c19569819866..e1c4082accdb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3240,49 +3240,58 @@ static struct sock *unix_from_bucket(struct seq_file *seq, loff_t *pos)
 	return sk;
 }
 
-static struct sock *unix_next_socket(struct seq_file *seq,
-				     struct sock *sk,
-				     loff_t *pos)
+static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 {
 	unsigned long bucket = get_bucket(*pos);
+	struct sock *sk;
 
-	while (sk > (struct sock *)SEQ_START_TOKEN) {
-		sk = sk_next(sk);
-		if (!sk)
-			goto next_bucket;
-		if (sock_net(sk) == seq_file_net(seq))
-			return sk;
-	}
-
-	do {
+	while (bucket < ARRAY_SIZE(unix_socket_table)) {
 		spin_lock(&unix_table_locks[bucket]);
+
 		sk = unix_from_bucket(seq, pos);
 		if (sk)
 			return sk;
 
-next_bucket:
-		spin_unlock(&unix_table_locks[bucket++]);
-		*pos = set_bucket_offset(bucket, 1);
-	} while (bucket < ARRAY_SIZE(unix_socket_table));
+		spin_unlock(&unix_table_locks[bucket]);
+
+		*pos = set_bucket_offset(++bucket, 1);
+	}
 
 	return NULL;
 }
 
+static struct sock *unix_get_next(struct seq_file *seq, struct sock *sk,
+				  loff_t *pos)
+{
+	unsigned long bucket = get_bucket(*pos);
+
+	for (sk = sk_next(sk); sk; sk = sk_next(sk))
+		if (sock_net(sk) == seq_file_net(seq))
+			return sk;
+
+	spin_unlock(&unix_table_locks[bucket]);
+
+	*pos = set_bucket_offset(++bucket, 1);
+
+	return unix_get_first(seq, pos);
+}
+
 static void *unix_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
-	if (get_bucket(*pos) >= ARRAY_SIZE(unix_socket_table))
-		return NULL;
-
-	return unix_next_socket(seq, NULL, pos);
+	return unix_get_first(seq, pos);
 }
 
 static void *unix_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	++*pos;
-	return unix_next_socket(seq, v, pos);
+
+	if (v == SEQ_START_TOKEN)
+		return unix_get_first(seq, pos);
+
+	return unix_get_next(seq, v, pos);
 }
 
 static void unix_seq_stop(struct seq_file *seq, void *v)
-- 
2.30.2

