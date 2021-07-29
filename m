Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED0F3DAFF0
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhG2Xhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 19:37:39 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64617 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbhG2Xhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 19:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627601855; x=1659137855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ty0noPyc9zK4YWeOiZkJWu+HO4/YosPOuBWXAaeZEmA=;
  b=mX61g7vWH+R0SXRP3CGY/lborMrl2KI+HWEBrDKimxY60l8ts8TTu181
   P7B5htHCw5+IsS6ge3Jdtiu6ByulKX8F8vPxDamBocx8Zr7i8OWjpYipY
   kPFW4UsgdUMQr0/ZL7sTcuFjGUYGIjhERSSrN2NIP9o55nEbWdyxRkQMF
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,280,1620691200"; 
   d="scan'208";a="149159677"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-94ef7264.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 29 Jul 2021 23:37:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-94ef7264.us-east-1.amazon.com (Postfix) with ESMTPS id 10694A264F;
        Thu, 29 Jul 2021 23:37:32 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 23:37:31 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.164) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 23:37:26 +0000
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
Subject: [PATCH bpf-next 1/2] bpf: af_unix: Implement BPF iterator for UNIX domain socket.
Date:   Fri, 30 Jul 2021 08:36:44 +0900
Message-ID: <20210729233645.4869-2-kuniyu@amazon.co.jp>
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

This patch implements the BPF iterator for the UNIX domain socket.

Currently, the batch optimization introduced for the TCP iterator in the
commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
applied.  It will require replacing the big lock for the hash table with
small locks for each hash list not to block other processes.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/linux/btf_ids.h |  3 +-
 net/unix/af_unix.c      | 78 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 1 deletion(-)

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
index 89927678c0dc..d45ad87e3a49 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -113,6 +113,7 @@
 #include <linux/security.h>
 #include <linux/freezer.h>
 #include <linux/file.h>
+#include <linux/btf_ids.h>
 
 #include "scm.h"
 
@@ -2935,6 +2936,49 @@ static const struct seq_operations unix_seq_ops = {
 	.stop   = unix_seq_stop,
 	.show   = unix_seq_show,
 };
+
+#ifdef CONFIG_BPF_SYSCALL
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
+static const struct seq_operations bpf_iter_unix_seq_ops = {
+	.start	= unix_seq_start,
+	.next	= unix_seq_next,
+	.stop	= unix_seq_stop,
+	.show	= bpf_iter_unix_seq_show,
+};
+#endif
 #endif
 
 static const struct net_proto_family unix_family_ops = {
@@ -2975,6 +3019,35 @@ static struct pernet_operations unix_net_ops = {
 	.exit = unix_net_exit,
 };
 
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
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
@@ -2990,6 +3063,11 @@ static int __init af_unix_init(void)
 	sock_register(&unix_family_ops);
 	register_pernet_subsys(&unix_net_ops);
 	unix_bpf_build_proto();
+
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	bpf_iter_register();
+#endif
+
 out:
 	return rc;
 }
-- 
2.30.2

