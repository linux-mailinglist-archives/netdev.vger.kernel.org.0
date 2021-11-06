Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677D6446D2E
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhKFJWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:22:23 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:49275 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhKFJWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190383; x=1667726383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C4ZC/TpwqI5mkXoU4a9XKNQWJsce3rsMz1wDptle6k4=;
  b=bnGSEjjEKuG5OntfVinFT7Lop2zFDiHK69sV53Vm3lwM4KOkWgaBKJHi
   2tbswpji5wwKkF1fBHFuS94zOjt0/lmonb/ZPFgDVD6WLxzOHfYOhCYbh
   E9hltkJE5KcFSNbmvTfPFd8of+s0rIFvotirTiKCifnsauAlJDn4FpBY3
   8=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="153173236"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-1c682de1.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 06 Nov 2021 09:19:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-1c682de1.us-east-1.amazon.com (Postfix) with ESMTPS id A9630A252B;
        Sat,  6 Nov 2021 09:19:41 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:19:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:19:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 09/13] af_unix: Remove UNIX_ABSTRACT() macro and test sun_path[0] instead.
Date:   Sat, 6 Nov 2021 18:17:08 +0900
Message-ID: <20211106091712.15206-10-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106091712.15206-1-kuniyu@amazon.co.jp>
References: <20211106091712.15206-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
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
 net/unix/af_unix.c                                        | 4 +---
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c         | 2 +-
 tools/testing/selftests/bpf/progs/bpf_tracing_net.h       | 2 --
 tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c | 2 +-
 4 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 75ba642dbcac..ae20f6621239 100644
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
@@ -3287,7 +3285,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 
 			i = 0;
 			len = u->addr->len - offsetof(struct sockaddr_un, sun_path);
-			if (!UNIX_ABSTRACT(s))
+			if (u->addr->name->sun_path[0])
 				len--;
 			else {
 				seq_putc(seq, '@');
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

