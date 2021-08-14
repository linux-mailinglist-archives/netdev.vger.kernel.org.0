Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220713EBF7B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhHNB6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:58:55 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:6947 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbhHNB6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628906307; x=1660442307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=deyNDYB1dOop2Laf4MWaioCg8CEQv0PtNhyWPMzjDjk=;
  b=kp47kHfKK2YiDbK4hJQzSrNxn/FKA2J6LYWyFURovzPIyOUlj6C+EgYK
   zwWTFjqwQdRVNhDHBE0WDTk3FtfR1lqi3tgQ1rE8Eerwk+YFTHY7tuSqq
   udjNtzNCs5PZVsFAlC5z6ZpdjcnJdAa8b1YKgKczy4I5pjNQ7V+YIqnQv
   c=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="141726988"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-28209b7b.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 14 Aug 2021 01:58:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-28209b7b.us-east-1.amazon.com (Postfix) with ESMTPS id 61D7CC2D46;
        Sat, 14 Aug 2021 01:58:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:58:23 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:58:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 bpf-next 3/4] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Sat, 14 Aug 2021 10:57:17 +0900
Message-ID: <20210814015718.42704-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210814015718.42704-1-kuniyu@amazon.co.jp>
References: <20210814015718.42704-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iterator can output almost the same result compared to /proc/net/unix.
The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
can be easily overflown.

  # cat /sys/fs/bpf/unix
  Num               RefCount Protocol Flags    Type St    Inode Path
  ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
  ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@

  # cat /proc/net/unix
  Num       RefCount Protocol Flags    Type St Inode Path
  ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
  ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 80 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 4 files changed, 108 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 1f1aade56504..77ac24b191d4 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -13,6 +13,7 @@
 #include "bpf_iter_tcp6.skel.h"
 #include "bpf_iter_udp4.skel.h"
 #include "bpf_iter_udp6.skel.h"
+#include "bpf_iter_unix.skel.h"
 #include "bpf_iter_test_kern1.skel.h"
 #include "bpf_iter_test_kern2.skel.h"
 #include "bpf_iter_test_kern3.skel.h"
@@ -313,6 +314,19 @@ static void test_udp6(void)
 	bpf_iter_udp6__destroy(skel);
 }
 
+static void test_unix(void)
+{
+	struct bpf_iter_unix *skel;
+
+	skel = bpf_iter_unix__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_unix__open_and_load"))
+		return;
+
+	do_dummy_read(skel->progs.dump_unix);
+
+	bpf_iter_unix__destroy(skel);
+}
+
 /* The expected string is less than 16 bytes */
 static int do_read_with_fd(int iter_fd, const char *expected,
 			   bool read_one_char)
@@ -1255,6 +1269,8 @@ void test_bpf_iter(void)
 		test_udp4();
 	if (test__start_subtest("udp6"))
 		test_udp6();
+	if (test__start_subtest("unix"))
+		test_unix();
 	if (test__start_subtest("anon"))
 		test_anon_iter(false);
 	if (test__start_subtest("anon-read-one-char"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index 3d83b185c4bc..8cfaeba1ddbf 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -12,6 +12,7 @@
 #define tcp6_sock tcp6_sock___not_used
 #define bpf_iter__udp bpf_iter__udp___not_used
 #define udp6_sock udp6_sock___not_used
+#define bpf_iter__unix bpf_iter__unix___not_used
 #define bpf_iter__bpf_map_elem bpf_iter__bpf_map_elem___not_used
 #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
 #define bpf_iter__sockmap bpf_iter__sockmap___not_used
@@ -32,6 +33,7 @@
 #undef tcp6_sock
 #undef bpf_iter__udp
 #undef udp6_sock
+#undef bpf_iter__unix
 #undef bpf_iter__bpf_map_elem
 #undef bpf_iter__bpf_sk_storage_map
 #undef bpf_iter__sockmap
@@ -103,6 +105,12 @@ struct udp6_sock {
 	struct ipv6_pinfo inet6;
 } __attribute__((preserve_access_index));
 
+struct bpf_iter__unix {
+	struct bpf_iter_meta *meta;
+	struct unix_sock *unix_sk;
+	uid_t uid;
+} __attribute__((preserve_access_index));
+
 struct bpf_iter__bpf_map_elem {
 	struct bpf_iter_meta *meta;
 	struct bpf_map *map;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
new file mode 100644
index 000000000000..58f2a2f4c4fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") = "GPL";
+
+static long sock_i_ino(const struct sock *sk)
+{
+	const struct socket *sk_socket = sk->sk_socket;
+	const struct inode *inode;
+	unsigned long ino;
+
+	if (!sk_socket)
+		return 0;
+
+	inode = &container_of(sk_socket, struct socket_alloc, socket)->vfs_inode;
+	bpf_probe_read_kernel(&ino, sizeof(ino), &inode->i_ino);
+	return ino;
+}
+
+SEC("iter/unix")
+int dump_unix(struct bpf_iter__unix *ctx)
+{
+	struct unix_sock *unix_sk = ctx->unix_sk;
+	struct sock *sk = (struct sock *)unix_sk;
+	struct seq_file *seq;
+	__u32 seq_num;
+
+	if (!unix_sk)
+		return 0;
+
+	seq = ctx->meta->seq;
+	seq_num = ctx->meta->seq_num;
+	if (seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "Num               RefCount Protocol Flags    Type St    Inode Path\n");
+
+	BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %8lu",
+		       unix_sk,
+		       sk->sk_refcnt.refs.counter,
+		       0,
+		       sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
+		       sk->sk_type,
+		       sk->sk_socket ?
+		       (sk->sk_state == TCP_ESTABLISHED ? SS_CONNECTED : SS_UNCONNECTED) :
+		       (sk->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
+		       sock_i_ino(sk));
+
+	if (unix_sk->addr) {
+		if (!UNIX_ABSTRACT(unix_sk)) {
+			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
+		} else {
+			/* The name of the abstract UNIX domain socket starts
+			 * with '\0' and can contain '\0'.  The null bytes
+			 * should be escaped as done in unix_seq_show().
+			 */
+			__u64 i, len;
+
+			len = unix_sk->addr->len - sizeof(short);
+
+			BPF_SEQ_PRINTF(seq, " @");
+
+			for (i = 1; i < len; i++) {
+				/* unix_mkname() tests this upper bound. */
+				if (len >= sizeof(struct sockaddr_un))
+					break;
+
+				BPF_SEQ_PRINTF(seq, "%c",
+					       unix_sk->addr->name->sun_path[i] ?:
+					       '@');
+			}
+		}
+	}
+
+	BPF_SEQ_PRINTF(seq, "\n");
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
index 3af0998a0623..eef5646ddb19 100644
--- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
+++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
@@ -5,6 +5,10 @@
 #define AF_INET			2
 #define AF_INET6		10
 
+#define __SO_ACCEPTCON		(1 << 16)
+#define UNIX_HASH_SIZE		256
+#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)
+
 #define SOL_TCP			6
 #define TCP_CONGESTION		13
 #define TCP_CA_NAME_MAX		16
-- 
2.30.2

