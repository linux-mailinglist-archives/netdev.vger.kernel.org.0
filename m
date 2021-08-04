Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911B83DFBD0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhHDHJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:09:55 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:25029 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbhHDHJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 03:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628060983; x=1659596983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YSz6x+/jphmi/E4a5rE24coJoAxfEMyOsOndR22fCC0=;
  b=Q9qXy/S9WaiZYO3ee9QWCf2HgXoICh/JUz3Jva7x7Eok5FnkEw7a15Gs
   OAzdRvEpJcwaAo00lsYNSKrN5YF71pfWeJ+icxyTfylHQVQBYIMCdt06y
   BZEk1mwym2cWtygcOQvf2Mpjr3uBeu/FSrIFqXAPkSlQe8StJf1S69OaP
   0=;
X-IronPort-AV: E=Sophos;i="5.84,293,1620691200"; 
   d="scan'208";a="127034811"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 04 Aug 2021 07:09:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id 27798C09E7;
        Wed,  4 Aug 2021 07:09:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 4 Aug 2021 07:09:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.175) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 4 Aug 2021 07:09:32 +0000
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
Subject: [PATCH v3 bpf-next 1/2] bpf: af_unix: Implement BPF iterator for UNIX domain socket.
Date:   Wed, 4 Aug 2021 16:08:50 +0900
Message-ID: <20210804070851.97834-2-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804070851.97834-1-kuniyu@amazon.co.jp>
References: <20210804070851.97834-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D17UWB001.ant.amazon.com (10.43.161.252) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the BPF iterator for the UNIX domain socket and
exports some functions under GPL for the CONFIG_UNIX=m case.

Currently, the batch optimization introduced for the TCP iterator in the
commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
applied.  It will require replacing the big lock for the hash table with
small locks for each hash list not to block other processes.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 fs/proc/proc_net.c      |  2 +
 include/linux/btf_ids.h |  3 +-
 kernel/bpf/bpf_iter.c   |  3 ++
 net/core/filter.c       |  1 +
 net/unix/af_unix.c      | 93 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 15c2e55d2ed2..887a8102da9f 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -91,6 +91,7 @@ int bpf_iter_init_seq_net(void *priv_data, struct bpf_iter_aux_info *aux)
 #endif
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bpf_iter_init_seq_net);
 
 void bpf_iter_fini_seq_net(void *priv_data)
 {
@@ -100,6 +101,7 @@ void bpf_iter_fini_seq_net(void *priv_data)
 	put_net(p->net);
 #endif
 }
+EXPORT_SYMBOL_GPL(bpf_iter_fini_seq_net);
 
 struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
 		struct proc_dir_entry *parent, const struct seq_operations *ops,
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
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 2e9d47bb40ff..cb77dcb7a7dc 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -300,6 +300,7 @@ int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bpf_iter_reg_target);
 
 void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info)
 {
@@ -679,6 +680,7 @@ struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_stop)
 
 	return iter_priv->prog;
 }
+EXPORT_SYMBOL_GPL(bpf_iter_get_info);
 
 int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
 {
@@ -698,6 +700,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
 	 */
 	return ret == 0 ? 0 : -EAGAIN;
 }
+EXPORT_SYMBOL_GPL(bpf_iter_run_prog);
 
 BPF_CALL_4(bpf_for_each_map_elem, struct bpf_map *, map, void *, callback_fn,
 	   void *, callback_ctx, u64, flags)
diff --git a/net/core/filter.c b/net/core/filter.c
index faf29fd82276..640734e8d61b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10549,6 +10549,7 @@ BTF_SOCK_TYPE_xxx
 #else
 u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
 #endif
+EXPORT_SYMBOL_GPL(btf_sock_ids);
 
 BPF_CALL_1(bpf_skc_to_tcp6_sock, struct sock *, sk)
 {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 256c4e31132e..675ed1f3107e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -113,6 +113,7 @@
 #include <linux/security.h>
 #include <linux/freezer.h>
 #include <linux/file.h>
+#include <linux/btf_ids.h>
 
 #include "scm.h"
 
@@ -2982,6 +2983,64 @@ static const struct seq_operations unix_seq_ops = {
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
@@ -3022,6 +3081,35 @@ static struct pernet_operations unix_net_ops = {
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
@@ -3037,6 +3125,11 @@ static int __init af_unix_init(void)
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

