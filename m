Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AEE471571
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhLKSpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230468AbhLKSpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:45:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639248301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdMxzx7I2MAUur0tmnvlLpmfmk4PoaCzyw+nRZOCrHE=;
        b=PrELVSHYQ1jVZMFeCaQmDpk7n+kwIKPK6xbcdRjlkldQl/rmDoch0Nep21VcdAXdRrESGC
        y1Mz9PMnc/E63dhhUCB5UviNO4HAdNhg5B39AteJrd28aLYLlZj03oVcPajvu97fOXaENf
        5KF1q01T6AnzFDWLo7R4C/R/eM0igxU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-BV9RU7-WNByD7njDG3MGKA-1; Sat, 11 Dec 2021 13:43:32 -0500
X-MC-Unique: BV9RU7-WNByD7njDG3MGKA-1
Received: by mail-ed1-f69.google.com with SMTP id n11-20020aa7c68b000000b003e7d68e9874so10792824edq.8
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:43:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OdMxzx7I2MAUur0tmnvlLpmfmk4PoaCzyw+nRZOCrHE=;
        b=ETrt+qP4sJgmazNGGFBtMiF8ZXfeABib18jwsen2bHr3lLbpb6qG19pAx9t0GW20xx
         hD2uMsaV9TVEU0qm7ND0y2ChDhELnVJlGqQ+p62G3hlpd8iyHz7kRHQxSMxKxUeOGZhr
         NN+3ppoENOO8XDSMRojZcrwCve5ThbmPuZHQA1YLF+nWmEA0D/y27fPF20qNNqzCYyuo
         idPnIDfda2/p1LuYe+y1AdYoy4bPiUrI7w8aImt5X8TGtWGhE/fbDrtQJ22cu9YS0EwK
         /nS036/m/dcieEfsbhdW7amA1USEau79tcLzZaUdc7wOgJWnl1Yz8VMYndDA3QYkvmnu
         KGxw==
X-Gm-Message-State: AOAM531B3FkhuZC5xje2MNFGpJD2YY8xQl8488TATt8HniqEXhEq0/Dh
        PqZ9iXwlxaCnkI1+rS6uNYln9J8rIpSRA+xzxRcQw793zh2x4rS2Vhj1/4upy25y1m2ctz/ElEO
        eOIVD7/dfbTpP42oU
X-Received: by 2002:a17:906:4fcd:: with SMTP id i13mr33437451ejw.472.1639248207982;
        Sat, 11 Dec 2021 10:43:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwe1vHJYjWZYfxgNLoLPIow8QHPtewP77sDqwSx/384AL0kgfZul+AkATUWtD3/hkweSedzfQ==
X-Received: by 2002:a17:906:4fcd:: with SMTP id i13mr33437364ejw.472.1639248207131;
        Sat, 11 Dec 2021 10:43:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id nc24sm3660126ejc.94.2021.12.11.10.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:43:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B55D8180471; Sat, 11 Dec 2021 19:43:25 +0100 (CET)
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
Subject: [PATCH bpf-next v3 6/8] bpf: Add XDP_REDIRECT support to XDP for bpf_prog_run()
Date:   Sat, 11 Dec 2021 19:41:40 +0100
Message-Id: <20211211184143.142003-7-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211211184143.142003-1-toke@redhat.com>
References: <20211211184143.142003-1-toke@redhat.com>
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
 net/bpf/test_run.c             | 217 +++++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |   2 +
 4 files changed, 210 insertions(+), 12 deletions(-)

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
index 46dd95755967..02bd0616e64d 100644
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
 
@@ -87,13 +111,161 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, u32 repeat, int *e
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
 
@@ -110,14 +282,26 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
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
@@ -125,6 +309,9 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	for_each_cgroup_storage_type(stype)
 		bpf_cgroup_storage_free(item.cgroup_storage[stype]);
 
+	if (t.mode == XDP)
+		bpf_test_run_xdp_teardown(&t);
+
 	return ret;
 }
 
@@ -663,7 +850,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	ret = convert___skb_to_skb(skb, ctx);
 	if (ret)
 		goto out;
-	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
+	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false, false);
 	if (ret)
 		goto out;
 	if (!is_l2) {
@@ -757,6 +944,7 @@ static void xdp_convert_buff_to_md(struct xdp_buff *xdp, struct xdp_md *xdp_md)
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
+	bool do_redirect = (kattr->test.flags & BPF_F_TEST_XDP_DO_REDIRECT);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 size = kattr->test.data_size_in;
@@ -773,6 +961,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	    prog->expected_attach_type == BPF_XDP_CPUMAP)
 		return -EINVAL;
 
+	if (kattr->test.flags & ~BPF_F_TEST_XDP_DO_REDIRECT)
+		return -EINVAL;
+
 	ctx = bpf_ctx_init(kattr, sizeof(struct xdp_md));
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
@@ -781,7 +972,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		/* There can't be user provided data before the meta data */
 		if (ctx->data_meta || ctx->data_end != size ||
 		    ctx->data > ctx->data_end ||
-		    unlikely(xdp_metalen_invalid(ctx->data)))
+		    unlikely(xdp_metalen_invalid(ctx->data)) ||
+		    (do_redirect && (kattr->test.data_out || kattr->test.ctx_out)))
 			goto free_ctx;
 		/* Meta data is allocated from the headroom */
 		headroom -= ctx->data;
@@ -807,7 +999,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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

