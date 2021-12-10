Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D314702D3
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242169AbhLJObT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:31:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234548AbhLJObR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639146461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7L1aRInSygSy2cpyAvLZjsWAZuRrUvTAPAgpV6Ya4o=;
        b=B3wXyOiJPpK/FQfWNXAGpB6f2pDWnkixS/mKb7cbWFCW0zEfSayTyCwXFQKrKNTOiDpJZF
        GawbqiJ1g6Qai0tBYolixK72TNfc3bbtiyfyUZdNIzgYbHFSJSX3KhxnCcWagt4FaFJJLJ
        bAnhBoCjCCPXCVJn2UlQAnc0o6eI7Rc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-238-QxFYxAjqMXW6q8dhVVCFCQ-1; Fri, 10 Dec 2021 09:27:38 -0500
X-MC-Unique: QxFYxAjqMXW6q8dhVVCFCQ-1
Received: by mail-ed1-f72.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so8340219edo.5
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:27:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H7L1aRInSygSy2cpyAvLZjsWAZuRrUvTAPAgpV6Ya4o=;
        b=vsMK3BKY43GHBvtcxpELrQ7L+NrEhMawDe/qTtYaJiasRxyNuTSN9lK5Nh0xRbkRvs
         Rg8+QYzg93o0M1ClZskZkOaryHH5yXH+p8SYyBGNTjJOO7XEnEPorSPMLRNY3dNcU4ps
         3vtVpxPQZOfGPxYXdv11mnqSdvC+ZwJfz7BquOLi54QdnpvBDhPMVrBRMKFZgdetbbAc
         uxAFLlRLDCCVz+tWijZuDoyt+IfPIcQXryIMEVR/u3dY/2T8dsYbvLt68YAhUu+SLt1m
         VjoOyCbT3JL64HC1jPxIayryRsCsDD348gsrd5GiCznZXlk57U9QugU/FhGrRrojIWaR
         KuOw==
X-Gm-Message-State: AOAM530t28uLj0fjpNS4OfK3RgNqTjajIwTmMf1IdMA1TCqqbM01NKmN
        wbg0uuhklEyk/rTRurH3l9d2cmrahAeXxC/PDO4uicP5YP/hXxNKLI/ob2dHSgxRpTykpG8RGk6
        T4gbsCLdb98X2KZT0
X-Received: by 2002:aa7:d5d6:: with SMTP id d22mr39251107eds.364.1639146455938;
        Fri, 10 Dec 2021 06:27:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4E0vMgDvOSvc27/ro0Og+2rb22wS+VLHnzPfNtHxouT84/KHxjWVi9N7mW17XQV9exDrEQA==
X-Received: by 2002:aa7:d5d6:: with SMTP id d22mr39250999eds.364.1639146454916;
        Fri, 10 Dec 2021 06:27:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qf9sm1610256ejc.18.2021.12.10.06.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:27:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5FA76180496; Fri, 10 Dec 2021 15:20:48 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 6/8] bpf: Add XDP_REDIRECT support to XDP for bpf_prog_run()
Date:   Fri, 10 Dec 2021 15:20:06 +0100
Message-Id: <20211210142008.76981-7-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211210142008.76981-1-toke@redhat.com>
References: <20211210142008.76981-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for doing real redirects when an XDP program returns
XDP_REDIRECT in bpf_prog_run(). To achieve this, we create a page pool
instance while setting up the test run, and feed pages from that into the
XDP program. The setup cost of this is amortised over the number of
repetitions specified by userspace.

To support performance testing use case, we further optimise the setup step
so that all pages in the pool are pre-initialised with the packet data, and
pre-computed context and xdp_frame objects stored at the start of each
page. This makes it possible to entirely avoid touching the page content on
each XDP program invocation, and enables sending up to 11.5 Mpps/core on my
test box.

Because the data pages are recycled by the page pool, and the test runner
doesn't re-initialise them for each run, subsequent invocations of the XDP
program will see the packet data in the state it was after the last time it
ran on that particular page. This means that an XDP program that modifies
the packet before redirecting it has to be careful about which assumptions
it makes about the packet content, but that is only an issue for the most
naively written programs.

Previous uses of bpf_prog_run() for XDP returned the modified packet data
and return code to userspace, which is a different semantic then this new
redirect mode. For this reason, the caller has to set the new
BPF_F_TEST_XDP_DO_REDIRECT flag when calling bpf_prog_run() to opt in to
the different semantics. Enabling this flag is only allowed if not setting
ctx_out and data_out in the test specification, since it means frames will
be redirected somewhere else, so they can't be returned.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h       |   2 +
 kernel/bpf/Kconfig             |   1 +
 net/bpf/test_run.c             | 218 +++++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |   2 +
 4 files changed, 211 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c26871263f1f..224a6e3261f5 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1225,6 +1225,8 @@ enum {
 
 /* If set, run the test on the cpu specified by bpf_attr.test.cpu */
 #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
+/* If set, support performing redirection of XDP frames */
+#define BPF_F_TEST_XDP_DO_REDIRECT	(1U << 1)
 
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index d24d518ddd63..c8c920020d11 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -30,6 +30,7 @@ config BPF_SYSCALL
 	select TASKS_TRACE_RCU
 	select BINARY_PRINTF
 	select NET_SOCK_MSG if NET
+	select PAGE_POOL if NET
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate BPF programs
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..a16734578d85 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <net/net_namespace.h>
+#include <net/page_pool.h>
 #include <linux/error-injection.h>
 #include <linux/smp.h>
 #include <linux/sock_diag.h>
@@ -23,19 +24,34 @@
 #include <trace/events/bpf_test_run.h>
 
 struct bpf_test_timer {
-	enum { NO_PREEMPT, NO_MIGRATE } mode;
+	enum { NO_PREEMPT, NO_MIGRATE, XDP } mode;
 	u32 i;
 	u64 time_start, time_spent;
+	struct {
+		struct xdp_buff *orig_ctx;
+		struct xdp_rxq_info rxq;
+		struct page_pool *pp;
+		u16 frame_cnt;
+	} xdp;
 };
 
 static void bpf_test_timer_enter(struct bpf_test_timer *t)
 	__acquires(rcu)
 {
 	rcu_read_lock();
-	if (t->mode == NO_PREEMPT)
+	switch (t->mode) {
+	case NO_PREEMPT:
 		preempt_disable();
-	else
+		break;
+	case XDP:
+		migrate_disable();
+		xdp_set_return_frame_no_direct();
+		t->xdp.frame_cnt = 0;
+		break;
+	case NO_MIGRATE:
 		migrate_disable();
+		break;
+	}
 
 	t->time_start = ktime_get_ns();
 }
@@ -45,10 +61,18 @@ static void bpf_test_timer_leave(struct bpf_test_timer *t)
 {
 	t->time_start = 0;
 
-	if (t->mode == NO_PREEMPT)
+	switch (t->mode) {
+	case NO_PREEMPT:
 		preempt_enable();
-	else
+		break;
+	case XDP:
+		xdp_do_flush();
+		xdp_clear_return_frame_no_direct();
+		fallthrough;
+	case NO_MIGRATE:
 		migrate_enable();
+		break;
+	}
 	rcu_read_unlock();
 }
 
@@ -87,13 +111,162 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *e
 	return false;
 }
 
+/* We put this struct at the head of each page with a context and frame
+ * initialised when the page is allocated, so we don't have to do this on each
+ * repetition of the test run.
+ */
+struct xdp_page_head {
+	struct xdp_buff orig_ctx;
+	struct xdp_buff ctx;
+	struct xdp_frame frm;
+	u8 data[];
+};
+
+#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head)	\
+			     - sizeof(struct skb_shared_info))
+
+static void bpf_test_run_xdp_init_page(struct page *page, void *arg)
+{
+	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
+	struct xdp_buff *new_ctx, *orig_ctx;
+	u32 headroom = XDP_PACKET_HEADROOM;
+	struct bpf_test_timer *t = arg;
+	size_t frm_len, meta_len;
+	struct xdp_frame *frm;
+	void *data;
+
+	orig_ctx = t->xdp.orig_ctx;
+	frm_len = orig_ctx->data_end - orig_ctx->data_meta;
+	meta_len = orig_ctx->data - orig_ctx->data_meta;
+	headroom -= meta_len;
+
+	new_ctx = &head->ctx;
+	frm = &head->frm;
+	data = &head->data;
+	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
+
+	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &t->xdp.rxq);
+	xdp_prepare_buff(new_ctx, data, headroom, frm_len, true);
+	new_ctx->data_meta = new_ctx->data + meta_len;
+
+	xdp_update_frame_from_buff(new_ctx, frm);
+	frm->mem = new_ctx->rxq->mem;
+
+	memcpy(&head->orig_ctx, new_ctx, sizeof(head->orig_ctx));
+}
+
+static int bpf_test_run_xdp_setup(struct bpf_test_timer *t, struct xdp_buff *orig_ctx)
+{
+	struct xdp_mem_info mem = {};
+	struct page_pool *pp;
+	int err;
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = 0,
+		.pool_size = NAPI_POLL_WEIGHT * 2,
+		.nid = NUMA_NO_NODE,
+		.max_len = TEST_XDP_FRAME_SIZE,
+		.init_callback = bpf_test_run_xdp_init_page,
+		.init_arg = t,
+	};
+
+	pp = page_pool_create(&pp_params);
+	if (IS_ERR(pp))
+		return PTR_ERR(pp);
+
+	/* will copy 'mem->id' into pp->xdp_mem_id */
+	err = xdp_reg_mem_model(&mem, MEM_TYPE_PAGE_POOL, pp);
+	if (err) {
+		page_pool_destroy(pp);
+		return err;
+	}
+	t->xdp.pp = pp;
+
+	/* We create a 'fake' RXQ referencing the original dev, but with an
+	 * xdp_mem_info pointing to our page_pool
+	 */
+	xdp_rxq_info_reg(&t->xdp.rxq, orig_ctx->rxq->dev, 0, 0);
+	t->xdp.rxq.mem.type = MEM_TYPE_PAGE_POOL;
+	t->xdp.rxq.mem.id = pp->xdp_mem_id;
+	t->xdp.orig_ctx = orig_ctx;
+
+	return 0;
+}
+
+static void bpf_test_run_xdp_teardown(struct bpf_test_timer *t)
+{
+	struct xdp_mem_info mem = {
+		.id = t->xdp.pp->xdp_mem_id,
+		.type = MEM_TYPE_PAGE_POOL,
+	};
+	xdp_unreg_mem_model(&mem);
+}
+
+static bool ctx_was_changed(struct xdp_page_head *head)
+{
+	return (head->orig_ctx.data != head->ctx.data ||
+		head->orig_ctx.data_meta != head->ctx.data_meta ||
+		head->orig_ctx.data_end != head->ctx.data_end);
+}
+
+static void reset_ctx(struct xdp_page_head *head)
+{
+	if (likely(!ctx_was_changed(head)))
+		return;
+
+	head->ctx.data = head->orig_ctx.data;
+	head->ctx.data_meta = head->orig_ctx.data_meta;
+	head->ctx.data_end = head->orig_ctx.data_end;
+	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+}
+
+static int bpf_test_run_xdp_redirect(struct bpf_test_timer *t,
+				     struct bpf_prog *prog, struct xdp_buff *orig_ctx)
+{
+	void *data, *data_end, *data_meta;
+	struct xdp_page_head *head;
+	struct xdp_buff *ctx;
+	struct page *page;
+	int ret, err = 0;
+
+	page = page_pool_dev_alloc_pages(t->xdp.pp);
+	if (!page)
+		return -ENOMEM;
+
+	head = phys_to_virt(page_to_phys(page));
+	reset_ctx(head);
+	ctx = &head->ctx;
+
+	ret = bpf_prog_run_xdp(prog, ctx);
+	if (ret == XDP_REDIRECT) {
+		struct xdp_frame *frm = &head->frm;
+
+		/* if program changed pkt bounds we need to update the xdp_frame */
+		if (unlikely(ctx_was_changed(head)))
+			xdp_update_frame_from_buff(ctx, frm);
+
+		err = xdp_do_redirect_frame(ctx->rxq->dev, ctx, frm, prog);
+		if (err)
+			ret = err;
+	}
+	if (ret != XDP_REDIRECT)
+		xdp_return_buff(ctx);
+
+	if (++t->xdp.frame_cnt >= NAPI_POLL_WEIGHT) {
+		xdp_do_flush();
+		t->xdp.frame_cnt = 0;
+	}
+
+	return ret;
+}
+
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
-			u32 *retval, u32 *time, bool xdp)
+			u32 *retval, u32 *time, bool xdp, bool xdp_redirect)
 {
 	struct bpf_prog_array_item item = {.prog = prog};
 	struct bpf_run_ctx *old_ctx;
 	struct bpf_cg_run_ctx run_ctx;
-	struct bpf_test_timer t = { NO_MIGRATE };
+	struct bpf_test_timer t = { .mode = (xdp && xdp_redirect) ? XDP : NO_MIGRATE };
 	enum bpf_cgroup_storage_type stype;
 	int ret;
 
@@ -110,14 +283,26 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	if (!repeat)
 		repeat = 1;
 
+	if (t.mode == XDP) {
+		ret = bpf_test_run_xdp_setup(&t, ctx);
+		if (ret)
+			return ret;
+	}
+
 	bpf_test_timer_enter(&t);
 	old_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	do {
 		run_ctx.prog_item = &item;
-		if (xdp)
+		if (xdp && xdp_redirect) {
+			ret = bpf_test_run_xdp_redirect(&t, prog, ctx);
+			if (unlikely(ret < 0))
+				break;
+			*retval = ret;
+		} else if (xdp) {
 			*retval = bpf_prog_run_xdp(prog, ctx);
-		else
+		} else {
 			*retval = bpf_prog_run(prog, ctx);
+		}
 	} while (bpf_test_timer_continue(&t, repeat, &ret, time));
 	bpf_reset_run_ctx(old_ctx);
 	bpf_test_timer_leave(&t);
@@ -125,6 +310,9 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	for_each_cgroup_storage_type(stype)
 		bpf_cgroup_storage_free(item.cgroup_storage[stype]);
 
+	if (t.mode == XDP)
+		bpf_test_run_xdp_teardown(&t);
+
 	return ret;
 }
 
@@ -663,7 +851,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	ret = convert___skb_to_skb(skb, ctx);
 	if (ret)
 		goto out;
-	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
+	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false, false);
 	if (ret)
 		goto out;
 	if (!is_l2) {
@@ -757,6 +945,7 @@ static void xdp_convert_buff_to_md(struct xdp_buff *xdp, struct xdp_md *xdp_md)
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
+	bool do_redirect = (kattr->test.flags & BPF_F_TEST_XDP_DO_REDIRECT);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 size = kattr->test.data_size_in;
@@ -773,6 +962,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	    prog->expected_attach_type == BPF_XDP_CPUMAP)
 		return -EINVAL;
 
+	if (kattr->test.flags & ~BPF_F_TEST_XDP_DO_REDIRECT)
+		return -EINVAL;
+
 	ctx = bpf_ctx_init(kattr, sizeof(struct xdp_md));
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
@@ -781,7 +973,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		/* There can't be user provided data before the meta data */
 		if (ctx->data_meta || ctx->data_end != size ||
 		    ctx->data > ctx->data_end ||
-		    unlikely(xdp_metalen_invalid(ctx->data)))
+		    unlikely(xdp_metalen_invalid(ctx->data)) ||
+		    (do_redirect && (kattr->test.data_out || kattr->test.ctx_out)))
 			goto free_ctx;
 		/* Meta data is allocated from the headroom */
 		headroom -= ctx->data;
@@ -807,7 +1000,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	if (repeat > 1)
 		bpf_prog_change_xdp(NULL, prog);
-	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
+	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration,
+			   true, do_redirect);
 	/* We convert the xdp_buff back to an xdp_md before checking the return
 	 * code so the reference count of any held netdevice will be decremented
 	 * even if the test run failed.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c26871263f1f..224a6e3261f5 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1225,6 +1225,8 @@ enum {
 
 /* If set, run the test on the cpu specified by bpf_attr.test.cpu */
 #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
+/* If set, support performing redirection of XDP frames */
+#define BPF_F_TEST_XDP_DO_REDIRECT	(1U << 1)
 
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
-- 
2.34.0

