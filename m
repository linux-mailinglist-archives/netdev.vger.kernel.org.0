Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324403DAFF2
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 01:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhG2Xh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 19:37:56 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:2061 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhG2Xhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 19:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627601872; x=1659137872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV3xX5/6kNrLU/BdVe/5BEuj3hmqkznzAp1eoc+uVuo=;
  b=jR8Tq3sbzYKVtPvbMIQU/k4uNCZ7rQyz3Bv92popvv5fqw9tnyO+l/u2
   3i4UKxIPebAaCTbM5YlypTnR4DAZQmuPqVPOoaErDHQbv1dIyGESa95Xm
   N0/JE7JxE0N46rxMIu8sTcohuT21N7CTPMgxL/ESb0V6Kq7eztI+y7VAg
   Q=;
X-IronPort-AV: E=Sophos;i="5.84,280,1620691200"; 
   d="scan'208";a="130384601"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 29 Jul 2021 23:37:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 0274DA1B2C;
        Thu, 29 Jul 2021 23:37:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 23:37:46 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.164) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 23:37:42 +0000
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
Subject: [PATCH bpf-next 2/2] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Fri, 30 Jul 2021 08:36:45 +0900
Message-ID: <20210729233645.4869-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729233645.4869-1-kuniyu@amazon.co.jp>
References: <20210729233645.4869-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.164]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
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

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 75 +++++++++++++++++++
 2 files changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 1f1aade56504..4746bac68d36 100644
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
@@ -313,6 +314,20 @@ static void test_udp6(void)
 	bpf_iter_udp6__destroy(skel);
 }
 
+static void test_unix(void)
+{
+	struct bpf_iter_unix *skel;
+
+	skel = bpf_iter_unix__open_and_load();
+	if (CHECK(!skel, "bpf_iter_unix__open_and_load",
+		  "skeleton open_and_load failed\n"))
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
@@ -1255,6 +1270,8 @@ void test_bpf_iter(void)
 		test_udp4();
 	if (test__start_subtest("udp6"))
 		test_udp6();
+	if (test__start_subtest("unix"))
+		test_unix();
 	if (test__start_subtest("anon"))
 		test_anon_iter(false);
 	if (test__start_subtest("anon-read-one-char"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
new file mode 100644
index 000000000000..285ec2f7944d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define __SO_ACCEPTCON		(1 << 16)
+#define UNIX_HASH_SIZE		256
+#define UNIX_ABSTRACT(unix_sk)	(unix_sk->addr->hash < UNIX_HASH_SIZE)
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
+		       (sk->sk_state == TCP_ESTABLISHED ?
+			SS_CONNECTED : SS_UNCONNECTED) :
+		       (sk->sk_state == TCP_ESTABLISHED ?
+			SS_CONNECTING : SS_DISCONNECTING),
+		       sock_i_ino(sk));
+
+	if (unix_sk->addr) {
+		if (UNIX_ABSTRACT(unix_sk))
+			/* Abstract UNIX domain socket can contain '\0' in
+			 * the path, and it should be escaped.  However, it
+			 * requires loops and the BPF verifier rejects it.
+			 * So here, print only the escaped first byte to
+			 * indicate it is an abstract UNIX domain socket.
+			 * (See: unix_seq_show() and commit e7947ea770d0d)
+			 */
+			BPF_SEQ_PRINTF(seq, " @");
+		else
+			BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
+	}
+
+	BPF_SEQ_PRINTF(seq, "\n");
+
+	return 0;
+}
-- 
2.30.2

