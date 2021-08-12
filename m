Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA0C3EA8B9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhHLQrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:47:25 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:21622 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhHLQrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628786819; x=1660322819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LIfKxG02NSerHDnSXBbWeslkuJ+evzSAiL6zV6uyBB4=;
  b=okaWKN0ovlo6EMYPMC4lTA5yITouTNBUYJtt1EWZnYUyw3zjuCoisW8o
   UGciEb9kv4sloCNaHHkcbY2/wtSR20O6UPtqQR36jvUnEz3bpFZZRprJQ
   umoP776CHkJe00j0PP42Cgza28b8+a9Jkq74hBS8+2RI9EP4zDL0jHwS9
   s=;
X-IronPort-AV: E=Sophos;i="5.84,316,1620691200"; 
   d="scan'208";a="950110082"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 12 Aug 2021 16:46:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 2C736A0674;
        Thu, 12 Aug 2021 16:46:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:46:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:46:52 +0000
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
Subject: [PATCH v5 bpf-next 3/4] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Fri, 13 Aug 2021 01:45:56 +0900
Message-ID: <20210812164557.79046-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812164557.79046-1-kuniyu@amazon.co.jp>
References: <20210812164557.79046-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13d09UWA003.ant.amazon.com (10.43.160.227) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iterator can output almost the same result compared to /proc/net/unix.
The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
can be easily overflown.

  # cat /sys/fs/bpf/unix
  Num               RefCount Protocol Flags    Type St Inode    Path
  ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
  ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@

  # cat /proc/net/unix
  Num       RefCount Protocol Flags    Type St Inode Path
  ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
  ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@

Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
Yonghong Song for analysing and fixing.

[0] https://reviews.llvm.org/D107483

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/README.rst        | 38 +++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 5 files changed, 143 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index 9b17f2867488..314a63b69399 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -228,3 +228,41 @@ To fix this issue, user newer libbpf.
 .. Links
 .. _clang reloc patch: https://reviews.llvm.org/D102712
 .. _kernel llvm reloc: /Documentation/bpf/llvm_reloc.rst
+
+bpf_iter_unix.o test failure and LLVM optimisation
+==================================================
+
+The ``bpf_iter/unix`` subtest requires `the fix`__ to prevent the LLVM compiler
+from transforming the loop exit condition.
+
+Without the fix, the compiler generates the following code:
+
+.. code-block:: c
+
+  ; 				 for (i = 1; i < len; i++)
+       110:	07 09 00 00 01 00 00 00	r9 += 1
+       111:	5d 98 09 00 00 00 00 00	if r8 != r9 goto +9 <LBB0_18>
+
+The loop exit condition, where the upper bound is not a constant, is
+changed from ``<`` to ``!=``.  Thus, the verifier always evaluates it as true,
+misleading to an infinite loop.
+
+.. code-block:: c
+
+  The sequence of 8193 jumps is too complex.
+  processed 196506 insns (limit 1000000) max_states_per_insn 4 total_states 1830 peak_states 1830 mark_read 3
+
+The fix prevents the optimisation by estimating its cost higher in such a
+case:
+
+.. code-block:: c
+
+  ; 				 for (i = 1; i < len; i++)
+       110:	07 09 00 00 01 00 00 00	r9 += 1
+       111:	ad 89 09 00 00 00 00 00	if r9 < r8 goto +9 <LBB0_18>
+
+The patch is available in LLVM 14 trunk and has been `backported`__ to the LLVM
+13.x release branch.
+
+__ https://reviews.llvm.org/D107483
+__ https://bugs.llvm.org/show_bug.cgi?id=51363
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
index 000000000000..0a50b610f6f3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -0,0 +1,77 @@
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
+		BPF_SEQ_PRINTF(seq, "Num               RefCount Protocol Flags    Type St Inode    Path\n");
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
+			int i, len;
+
+			len = unix_sk->addr->len - sizeof(short);
+
+			BPF_SEQ_PRINTF(seq, " @");
+
+			/* unix_mkname() tests this upper bound. */
+			if (len < sizeof(struct sockaddr_un))
+				for (i = 1; i < len; i++)
+					BPF_SEQ_PRINTF(seq, "%c",
+						       unix_sk->addr->name->sun_path[i] ?:
+						       '@');
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

