Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE17A4BFFB6
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiBVRIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiBVRHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:07:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B4812AFF;
        Tue, 22 Feb 2022 09:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC3F6127C;
        Tue, 22 Feb 2022 17:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523FCC340E8;
        Tue, 22 Feb 2022 17:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549637;
        bh=oXjlXQXwqtN4x8CxyZS9B2rULSIIpPWOGZrCph6jhdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LP0VHGw/tHxFqZd31lpvhaMUWowfAlISUD36R3QTQpMwvP91eBNeb2IHGTOfJ89QK
         28ZajsmPx2W1Z7i44kx1J6huph53/1iuwUAo8XhK7r4dL0WFF15LtfGudpJQMaRDlo
         FsYBXyZ2L84fRlkD84JMI7cSJ1KzRxMZhI9q9WuCshu2Hk0V8kh+2bo81peVU2LbeN
         OI1pTx6G5tVxWu0Ea/mSwq3dlYiDRnQez3ZCad4ML4lwwpD0VZGqpQjiY1TIBzPgOr
         fsWjpiyPGzjlaF/pwwoXNHgGmF1Q/vmpuH2CbtS9ppYe2LuK4L7OpIb+wfjiy8S5OS
         SLoFsTbYJnH4A==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 05/10] bpf: Add cookie support to programs attached with kprobe multi link
Date:   Tue, 22 Feb 2022 18:05:55 +0100
Message-Id: <20220222170600.611515-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222170600.611515-1-jolsa@kernel.org>
References: <20220222170600.611515-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to call bpf_get_attach_cookie helper from
kprobe programs attached with kprobe multi link.

The cookie is provided by array of u64 values, where each
value is paired with provided function address or symbol
with the same array index.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/sort.h           |   2 +
 include/uapi/linux/bpf.h       |   1 +
 kernel/trace/bpf_trace.c       | 103 ++++++++++++++++++++++++++++++++-
 lib/sort.c                     |   2 +-
 tools/include/uapi/linux/bpf.h |   1 +
 5 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/include/linux/sort.h b/include/linux/sort.h
index e163287ac6c1..2dbf30a32143 100644
--- a/include/linux/sort.h
+++ b/include/linux/sort.h
@@ -13,4 +13,6 @@ void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func);
 
+void swap_words_64(void *a, void *b, size_t n);
+
 #endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6c66138c1b9b..d18996502aac 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1482,6 +1482,7 @@ union bpf_attr {
 			struct {
 				__aligned_u64	syms;
 				__aligned_u64	addrs;
+				__aligned_u64	cookies;
 				__u32		cnt;
 				__u32		flags;
 			} kprobe_multi;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c1998b9d5531..8d85bd97cb45 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -18,6 +18,8 @@
 #include <linux/btf_ids.h>
 #include <linux/bpf_lsm.h>
 #include <linux/fprobe.h>
+#include <linux/bsearch.h>
+#include <linux/sort.h>
 
 #include <net/bpf_sk_storage.h>
 
@@ -78,6 +80,7 @@ u64 bpf_get_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 				  u64 flags, const struct btf **btf,
 				  s32 *btf_id);
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip);
 
 /**
  * trace_call_bpf - invoke BPF program
@@ -1050,6 +1053,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_attach_cookie_kprobe_multi, struct pt_regs *, regs)
+{
+	return bpf_kprobe_multi_cookie(current->bpf_ctx, regs->ip);
+}
+
+static const struct bpf_func_proto bpf_get_attach_cookie_proto_kmulti = {
+	.func		= bpf_get_attach_cookie_kprobe_multi,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
 {
 	struct bpf_trace_run_ctx *run_ctx;
@@ -1297,7 +1312,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 			&bpf_get_func_ip_proto_kprobe_multi :
 			&bpf_get_func_ip_proto_kprobe;
 	case BPF_FUNC_get_attach_cookie:
-		return &bpf_get_attach_cookie_proto_trace;
+		return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
+			&bpf_get_attach_cookie_proto_kmulti :
+			&bpf_get_attach_cookie_proto_trace;
 	default:
 		return bpf_tracing_func_proto(func_id, prog);
 	}
@@ -2203,6 +2220,9 @@ struct bpf_kprobe_multi_link {
 	struct bpf_link link;
 	struct fprobe fp;
 	unsigned long *addrs;
+	struct bpf_run_ctx run_ctx;
+	u64 *cookies;
+	u32 cnt;
 };
 
 static void bpf_kprobe_multi_link_release(struct bpf_link *link)
@@ -2219,6 +2239,7 @@ static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
 
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
 	kvfree(kmulti_link->addrs);
+	kvfree(kmulti_link->cookies);
 	kfree(kmulti_link);
 }
 
@@ -2227,10 +2248,57 @@ static const struct bpf_link_ops bpf_kprobe_multi_link_lops = {
 	.dealloc = bpf_kprobe_multi_link_dealloc,
 };
 
+static void bpf_kprobe_multi_cookie_swap(void *a, void *b, int size, const void *priv)
+{
+	const struct bpf_kprobe_multi_link *link = priv;
+	unsigned long *addr_a = a, *addr_b = b;
+	u64 *cookie_a, *cookie_b;
+
+	cookie_a = link->cookies + (addr_a - link->addrs);
+	cookie_b = link->cookies + (addr_b - link->addrs);
+
+	swap_words_64(addr_a, addr_b, size);
+	swap_words_64(cookie_a, cookie_b, size);
+}
+
+static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
+{
+	const unsigned long *addr_a = a, *addr_b = b;
+
+	if (*addr_a == *addr_b)
+		return 0;
+	return *addr_a < *addr_b ? -1 : 1;
+}
+
+static int bpf_kprobe_multi_cookie_cmp(const void *a, const void *b, const void *priv)
+{
+	return __bpf_kprobe_multi_cookie_cmp(a, b);
+}
+
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+{
+	struct bpf_kprobe_multi_link *link;
+	unsigned long *addr;
+	u64 *cookie;
+
+	if (WARN_ON_ONCE(!ctx))
+		return 0;
+	link = container_of(ctx, struct bpf_kprobe_multi_link, run_ctx);
+	if (!link->cookies)
+		return 0;
+	addr = bsearch(&ip, link->addrs, link->cnt, sizeof(ip),
+		       __bpf_kprobe_multi_cookie_cmp);
+	if (!addr)
+		return 0;
+	cookie = link->cookies + (addr - link->addrs);
+	return *cookie;
+}
+
 static int
 kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 			   struct pt_regs *regs)
 {
+	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
@@ -2238,12 +2306,16 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 		goto out;
 	}
 
+	old_run_ctx = bpf_set_run_ctx(&link->run_ctx);
+
 	rcu_read_lock();
 	migrate_disable();
 	err = bpf_prog_run(link->link.prog, regs);
 	migrate_enable();
 	rcu_read_unlock();
 
+	bpf_reset_run_ctx(old_run_ctx);
+
  out:
 	__this_cpu_dec(bpf_prog_active);
 	return err;
@@ -2326,9 +2398,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 {
 	struct bpf_kprobe_multi_link *link = NULL;
 	struct bpf_link_primer link_primer;
+	void __user *ucookies;
 	unsigned long *addrs;
 	u32 flags, cnt, size;
 	void __user *uaddrs;
+	u64 *cookies = NULL;
 	void __user *usyms;
 	int err;
 
@@ -2368,6 +2442,19 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 			goto error;
 	}
 
+	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
+	if (ucookies) {
+		cookies = kvmalloc(size, GFP_KERNEL);
+		if (!cookies) {
+			err = -ENOMEM;
+			goto error;
+		}
+		if (copy_from_user(cookies, ucookies, size)) {
+			err = -EFAULT;
+			goto error;
+		}
+	}
+
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (!link) {
 		err = -ENOMEM;
@@ -2387,6 +2474,15 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		link->fp.entry_handler = kprobe_multi_link_handler;
 
 	link->addrs = addrs;
+	link->cookies = cookies;
+	link->cnt = cnt;
+
+	if (cookies) {
+		sort_r(addrs, cnt, sizeof(*addrs),
+		       bpf_kprobe_multi_cookie_cmp,
+		       bpf_kprobe_multi_cookie_swap,
+		       link);
+	}
 
 	err = register_fprobe_ips(&link->fp, addrs, cnt);
 	if (err) {
@@ -2399,6 +2495,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 error:
 	kfree(link);
 	kvfree(addrs);
+	kvfree(cookies);
 	return err;
 }
 #else /* !CONFIG_FPROBE */
@@ -2406,4 +2503,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 {
 	return -EOPNOTSUPP;
 }
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+{
+	return 0;
+}
 #endif
diff --git a/lib/sort.c b/lib/sort.c
index b399bf10d675..91f7ce701cf4 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -80,7 +80,7 @@ static void swap_words_32(void *a, void *b, size_t n)
  * but it's possible to have 64-bit loads without 64-bit pointers (e.g.
  * x32 ABI).  Are there any cases the kernel needs to worry about?
  */
-static void swap_words_64(void *a, void *b, size_t n)
+void swap_words_64(void *a, void *b, size_t n)
 {
 	do {
 #ifdef CONFIG_64BIT
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6c66138c1b9b..d18996502aac 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1482,6 +1482,7 @@ union bpf_attr {
 			struct {
 				__aligned_u64	syms;
 				__aligned_u64	addrs;
+				__aligned_u64	cookies;
 				__u32		cnt;
 				__u32		flags;
 			} kprobe_multi;
-- 
2.35.1

