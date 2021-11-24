Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3396745B1F6
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbhKXCUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:20:17 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:47780 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbhKXCUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720228; x=1669256228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KyXfKM8qel7yK4y9upI91pjDKoeDoIsa+X9E7gPgVgk=;
  b=nUdbbcT9PLZpRyI48ZcMCoU6gX5Xe7mP8ScdazG4w9TOm1Bsu51u4rp2
   zeigLwW5tD7ymcfoguylUnz4z6LLYzGYvw2DqevxFgv6a2nwKBBiGfKag
   4+/wa9F0f5qHw1dWBa9c09M2PwRZGVsqEczEjn4EaqcSAW3vANW6yvSDs
   k=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="158852430"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-05e8af15.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 24 Nov 2021 02:17:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-05e8af15.us-west-2.amazon.com (Postfix) with ESMTPS id C27C4A2B82;
        Wed, 24 Nov 2021 02:17:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:17:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:17:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 09/13] af_unix: Remove UNIX_ABSTRACT() macro and test sun_path[0] instead.
Date:   Wed, 24 Nov 2021 11:14:27 +0900
Message-ID: <20211124021431.48956-10-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211124021431.48956-1-kuniyu@amazon.co.jp>
References: <20211124021431.48956-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D03UWA004.ant.amazon.com (10.43.160.250) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In BSD and abstract address cases, we store sockets in the hash table with
keys between 0 and UNIX_HASH_SIZE - 1.  However, the hash saved in a socket
varies depending on its address type; sockets with BSD addresses always
have UNIX_HASH_SIZE in their unix_sk(sk)->addr->hash.

This is just for the UNIX_ABSTRACT() macro used to check the address type.
The difference of the saved hashes comes from the first byte of the address
in the first place.  So, we can test it directly.

Then we can keep a real hash in each socket and replace unix_table_lock
with per-hash locks in the later patch.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c                                        | 6 ++----
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c         | 2 +-
 tools/testing/selftests/bpf/progs/bpf_tracing_net.h       | 2 --
 tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c | 2 +-
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 34d8f38d2cec..884d69219297 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -134,8 +134,6 @@ static struct hlist_head *unix_sockets_unbound(void *addr)
 	return &unix_socket_table[UNIX_HASH_SIZE + hash];
 }
 
-#define UNIX_ABSTRACT(sk)	(unix_sk(sk)->addr->hash < UNIX_HASH_SIZE)
-
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
@@ -3295,9 +3293,9 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 			i = 0;
 			len = u->addr->len -
 				offsetof(struct sockaddr_un, sun_path);
-			if (!UNIX_ABSTRACT(s))
+			if (u->addr->name->sun_path[0]) {
 				len--;
-			else {
+			} else {
 				seq_putc(seq, '@');
 				i++;
 			}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
index 94423902685d..c21e3f545371 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -49,7 +49,7 @@ int dump_unix(struct bpf_iter__unix *ctx)
 		       sock_i_ino(sk));
 
 	if (unix_sk->addr) {
-		if (!UNIX_ABSTRACT(unix_sk)) {
+		if (unix_sk->addr->name->sun_path[0]) {
 			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
 		} else {
 			/* The name of the abstract UNIX domain socket starts
diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
index eef5646ddb19..e0f42601be9b 100644
--- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
+++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
@@ -6,8 +6,6 @@
 #define AF_INET6		10
 
 #define __SO_ACCEPTCON		(1 << 16)
-#define UNIX_HASH_SIZE		256
-#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)
 
 #define SOL_TCP			6
 #define TCP_CONGESTION		13
diff --git a/tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c b/tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c
index a408ec95cba4..eacda9fe07eb 100644
--- a/tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c
+++ b/tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c
@@ -23,7 +23,7 @@ int BPF_PROG(unix_listen, struct socket *sock, int backlog)
 	if (!unix_sk)
 		return 0;
 
-	if (!UNIX_ABSTRACT(unix_sk))
+	if (unix_sk->addr->name->sun_path[0])
 		return 0;
 
 	len = unix_sk->addr->len - sizeof(short);
-- 
2.30.2

