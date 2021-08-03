Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE53DE3DF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 03:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhHCBMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 21:12:12 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:43218 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhHCBMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 21:12:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627953122; x=1659489122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jcOT3MnkiOinEtltaakvUqZEPAPtSvTwMvPGxUOtKRM=;
  b=v8s3yaL4LTiGFDYAHv4uNIb93czJlP5LRQIj1O4TLS6iSHSnHke9X2r4
   zSIsGzsZpcSGOBHPrqsytO06mSDhUkTNuh+U1fANiM3j4NH3K6AZwNDqs
   UBWu5YNAeFbK/RVCiiG4xzi96tG+FXA0HMzuAbZda1KP2kCMzLVEEhHdW
   A=;
X-IronPort-AV: E=Sophos;i="5.84,290,1620691200"; 
   d="scan'208";a="131122481"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 03 Aug 2021 01:12:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 27D66C019C;
        Tue,  3 Aug 2021 01:11:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 3 Aug 2021 01:11:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.186) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 3 Aug 2021 01:11:52 +0000
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
Subject: [PATCH v2 bpf-next 2/2] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Tue, 3 Aug 2021 10:11:10 +0900
Message-ID: <20210803011110.21205-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803011110.21205-1-kuniyu@amazon.co.jp>
References: <20210803011110.21205-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.186]
X-ClientProxiedBy: EX13D44UWC001.ant.amazon.com (10.43.162.26) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there are no abstract sockets, this prog can output the same result
compared to /proc/net/unix.

  # cat /sys/fs/bpf/unix | head -n 2
  Num       RefCount Protocol Flags    Type St Inode Path
  ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer

  # cat /proc/net/unix | head -n 2
  Num       RefCount Protocol Flags    Type St Inode Path
  ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer

According to the analysis by Yonghong Song (See the link), the BPF verifier
cannot load the code in the comment to print the name of the abstract UNIX
domain socket due to LLVM optimisation.  It can be uncommented once the
LLVM code gen is improved.

Link: https://lore.kernel.org/netdev/1994df05-8f01-371f-3c3b-d33d7836878c@fb.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 86 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 4 files changed, 114 insertions(+)
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
index 3d83b185c4bc..d92648621bcb 100644
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
+	uid_t uid __attribute__((aligned(8)));
+} __attribute__((preserve_access_index));
+
 struct bpf_iter__bpf_map_elem {
 	struct bpf_iter_meta *meta;
 	struct bpf_map *map;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
new file mode 100644
index 000000000000..048844ee4f32
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -0,0 +1,86 @@
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
+		BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
+			       "Type St Inode Path\n");
+
+	BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
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
+			BPF_SEQ_PRINTF(seq, " @");
+
+			/* The name of the abstract UNIX domain socket starts
+			 * with '\0' and can contain '\0'.  The null bytes
+			 * should be escaped as done in unix_seq_show().
+			 * However, the BPF verifier cannot load the code below
+			 * because of the optimisation by LLVM.  So, print only
+			 * the first escaped byte here for now.  Once LLVM code
+			 * gen is improved, remove the BPF_SEQ_PRINTF() above
+			 * and uncomment the code below.
+			 *
+			 * int i, len;
+			 *
+			 * len = unix_sk->addr->len - sizeof(short);
+			 *
+			 * BPF_SEQ_PRINTF(seq, " @");
+			 *
+			 * // unix_mkname() tests this upper bound.
+			 * if (len < sizeof(struct sockaddr_un))
+			 *	for (i = 1 ; i < len; i++)
+			 *		BPF_SEQ_PRINTF(seq, "%c",
+			 *			       unix_sk->addr->name->sun_path[i] ?:
+			 *			       '@');
+			 */
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

