Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737274DAFAC
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355702AbiCPM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355703AbiCPM1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B7C65D3E;
        Wed, 16 Mar 2022 05:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA3A61734;
        Wed, 16 Mar 2022 12:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE293C340E9;
        Wed, 16 Mar 2022 12:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433534;
        bh=BrrBB00AjFpOImcT9Omy+qZWETclZWrHkpMlz8AwPAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWAzLtT1aHIGsBlAbUXkGMNd95JnAluX8sLI9tSsiiL2UNVJ42PsxlIvf2XxGAcC4
         NpJfaX6ldsWAqw4T66zs2HbXKoabnHInYuPp028FjSnrbjZNyIu97qSCUBQwZSmKHW
         ozAry8cwVSzbDcRtMKEGovoC5OXRlK8/fWo/sFkT58+LImLy/AaUUDyBYn7UmSWU0H
         pJ3xB8P/1TJs1c0e5OFMVOdyjiRmq/CLRg+ysg3YA90XEg/zKnGTqYSOQl8iPDleIv
         ANj6GNdBkAT0SCA+66Gg7LErqaM+u7t8CmNMovhMk/Fr2BluCL+p/xHs5/Qw4cHEZW
         +OqgFbYnRcPVw==
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
Subject: [PATCHv3 bpf-next 06/13] bpf: Add cookie support to programs attached with kprobe multi link
Date:   Wed, 16 Mar 2022 13:24:12 +0100
Message-Id: <20220316122419.933957-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

When cookie array is provided it's sorted together with
addresses (check bpf_kprobe_multi_cookie_swap). This way
we can find cookie based on the address in
bpf_get_attach_cookie helper.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |   1 +
 kernel/bpf/syscall.c           |   2 +-
 kernel/trace/bpf_trace.c       | 114 ++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |   1 +
 4 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d77f47af7752..7604e7d5438f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1487,6 +1487,7 @@ union bpf_attr {
 				__u32		cnt;
 				__aligned_u64	syms;
 				__aligned_u64	addrs;
+				__aligned_u64	cookies;
 			} kprobe_multi;
 		};
 	} link_create;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b8bb67ee6c57..cdaa1152436a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4261,7 +4261,7 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	return -EINVAL;
 }
 
-#define BPF_LINK_CREATE_LAST_FIELD link_create.kprobe_multi.addrs
+#define BPF_LINK_CREATE_LAST_FIELD link_create.kprobe_multi.cookies
 static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type ptype;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 0e7f8c9bc756..9a7b6be655e4 100644
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
+	return bpf_kprobe_multi_cookie(current->bpf_ctx, instruction_pointer(regs));
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
@@ -2203,6 +2220,13 @@ struct bpf_kprobe_multi_link {
 	struct bpf_link link;
 	struct fprobe fp;
 	unsigned long *addrs;
+	/*
+	 * The run_ctx here is used to get struct bpf_kprobe_multi_link in
+	 * get_attach_cookie helper, so it can't be used to store data.
+	 */
+	struct bpf_run_ctx run_ctx;
+	u64 *cookies;
+	u32 cnt;
 };
 
 static void bpf_kprobe_multi_link_release(struct bpf_link *link)
@@ -2219,6 +2243,7 @@ static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
 
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
 	kvfree(kmulti_link->addrs);
+	kvfree(kmulti_link->cookies);
 	kfree(kmulti_link);
 }
 
@@ -2227,10 +2252,60 @@ static const struct bpf_link_ops bpf_kprobe_multi_link_lops = {
 	.dealloc = bpf_kprobe_multi_link_dealloc,
 };
 
+static void bpf_kprobe_multi_cookie_swap(void *a, void *b, int size, const void *priv)
+{
+	const struct bpf_kprobe_multi_link *link = priv;
+	unsigned long *addr_a = a, *addr_b = b;
+	u64 *cookie_a, *cookie_b;
+	unsigned long tmp1;
+	u64 tmp2;
+
+	cookie_a = link->cookies + (addr_a - link->addrs);
+	cookie_b = link->cookies + (addr_b - link->addrs);
+
+	/* swap addr_a/addr_b and cookie_a/cookie_b values */
+	tmp1 = *addr_a; *addr_a = *addr_b; *addr_b = tmp1;
+	tmp2 = *cookie_a; *cookie_a = *cookie_b; *cookie_b = tmp2;
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
@@ -2240,7 +2315,9 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 
 	migrate_disable();
 	rcu_read_lock();
+	old_run_ctx = bpf_set_run_ctx(&link->run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
+	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
 	migrate_enable();
 
@@ -2326,9 +2403,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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
 
@@ -2368,6 +2447,19 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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
@@ -2387,6 +2479,21 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		link->fp.entry_handler = kprobe_multi_link_handler;
 
 	link->addrs = addrs;
+	link->cookies = cookies;
+	link->cnt = cnt;
+
+	if (cookies) {
+		/*
+		 * Sorting addresses will trigger sorting cookies as well
+		 * (check bpf_kprobe_multi_cookie_swap). This way we can
+		 * find cookie based on the address in bpf_get_attach_cookie
+		 * helper.
+		 */
+		sort_r(addrs, cnt, sizeof(*addrs),
+		       bpf_kprobe_multi_cookie_cmp,
+		       bpf_kprobe_multi_cookie_swap,
+		       link);
+	}
 
 	err = register_fprobe_ips(&link->fp, addrs, cnt);
 	if (err) {
@@ -2399,6 +2506,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 error:
 	kfree(link);
 	kvfree(addrs);
+	kvfree(cookies);
 	return err;
 }
 #else /* !CONFIG_FPROBE */
@@ -2406,4 +2514,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 {
 	return -EOPNOTSUPP;
 }
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+{
+	return 0;
+}
 #endif
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d77f47af7752..7604e7d5438f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1487,6 +1487,7 @@ union bpf_attr {
 				__u32		cnt;
 				__aligned_u64	syms;
 				__aligned_u64	addrs;
+				__aligned_u64	cookies;
 			} kprobe_multi;
 		};
 	} link_create;
-- 
2.35.1

