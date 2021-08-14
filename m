Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F573EBF77
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhHNB63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:58:29 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:18426 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbhHNB6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628906279; x=1660442279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/rsRgFGkA/CeOKKIdggUx6+nLiSiUUuMRTxzCpIOdC8=;
  b=LNuL6hMe00IGUk6h9nbNdgCCKXyY2LVIk1HMCwqQ/RRvqFaO/eXaCdxO
   wlpLpOfIgj32MvFvtqhlGkCXmlhZX36F4o4fQd8dc7bTJ3cMriiFFXA6w
   lRn0jC0uw7G7ZmkhV+B/E2GzG0SEs7kjueZO18Llbdb5uySifOiJrm8dD
   Q=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="19223542"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 14 Aug 2021 01:57:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id DEEF2C0620;
        Sat, 14 Aug 2021 01:57:53 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:57:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:57:48 +0000
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
Subject: [PATCH v6 bpf-next 1/4] bpf: af_unix: Implement BPF iterator for UNIX domain socket.
Date:   Sat, 14 Aug 2021 10:57:15 +0900
Message-ID: <20210814015718.42704-2-kuniyu@amazon.co.jp>
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

This patch implements the BPF iterator for the UNIX domain socket.

Currently, the batch optimisation introduced for the TCP iterator in the
commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
used for the UNIX domain socket.  It will require replacing the big lock
for the hash table with small locks for each hash list not to block other
processes.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Yonghong Song <yhs@fb.com>
---
 include/linux/btf_ids.h |  3 +-
 net/unix/af_unix.c      | 93 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 57890b357f85..bed4b9964581 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -172,7 +172,8 @@ extern struct btf_id_set name;
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
 
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 1c2224f05b51..bad8f19174e3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -113,6 +113,7 @@
 #include <linux/security.h>
 #include <linux/freezer.h>
 #include <linux/file.h>
+#include <linux/btf_ids.h>
 
 #include "scm.h"
 
@@ -3143,6 +3144,64 @@ static const struct seq_operations unix_seq_ops = {
 	.stop   = unix_seq_stop,
 	.show   = unix_seq_show,
 };
+
+#if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
+struct bpf_iter__unix {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct unix_sock *, unix_sk);
+	uid_t uid __aligned(8);
+};
+
+static int unix_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
+			      struct unix_sock *unix_sk, uid_t uid)
+{
+	struct bpf_iter__unix ctx;
+
+	meta->seq_num--;  /* skip SEQ_START_TOKEN */
+	ctx.meta = meta;
+	ctx.unix_sk = unix_sk;
+	ctx.uid = uid;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int bpf_iter_unix_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	struct sock *sk = v;
+	uid_t uid;
+
+	if (v == SEQ_START_TOKEN)
+		return 0;
+
+	uid = from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, false);
+	return unix_prog_seq_show(prog, &meta, v, uid);
+}
+
+static void bpf_iter_unix_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		meta.seq = seq;
+		prog = bpf_iter_get_info(&meta, true);
+		if (prog)
+			(void)unix_prog_seq_show(prog, &meta, v, 0);
+	}
+
+	unix_seq_stop(seq, v);
+}
+
+static const struct seq_operations bpf_iter_unix_seq_ops = {
+	.start	= unix_seq_start,
+	.next	= unix_seq_next,
+	.stop	= bpf_iter_unix_seq_stop,
+	.show	= bpf_iter_unix_seq_show,
+};
+#endif
 #endif
 
 static const struct net_proto_family unix_family_ops = {
@@ -3183,6 +3242,35 @@ static struct pernet_operations unix_net_ops = {
 	.exit = unix_net_exit,
 };
 
+#if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
+		     struct unix_sock *unix_sk, uid_t uid)
+
+static const struct bpf_iter_seq_info unix_seq_info = {
+	.seq_ops		= &bpf_iter_unix_seq_ops,
+	.init_seq_private	= bpf_iter_init_seq_net,
+	.fini_seq_private	= bpf_iter_fini_seq_net,
+	.seq_priv_size		= sizeof(struct seq_net_private),
+};
+
+static struct bpf_iter_reg unix_reg_info = {
+	.target			= "unix",
+	.ctx_arg_info_size	= 1,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__unix, unix_sk),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		= &unix_seq_info,
+};
+
+static void __init bpf_iter_register(void)
+{
+	unix_reg_info.ctx_arg_info[0].btf_id = btf_sock_ids[BTF_SOCK_TYPE_UNIX];
+	if (bpf_iter_reg_target(&unix_reg_info))
+		pr_warn("Warning: could not register bpf iterator unix\n");
+}
+#endif
+
 static int __init af_unix_init(void)
 {
 	int rc = -1;
@@ -3198,6 +3286,11 @@ static int __init af_unix_init(void)
 	sock_register(&unix_family_ops);
 	register_pernet_subsys(&unix_net_ops);
 	unix_bpf_build_proto();
+
+#if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	bpf_iter_register();
+#endif
+
 out:
 	return rc;
 }
-- 
2.30.2

