Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC112B32A9
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 06:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKOFxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 00:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgKOFxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 00:53:15 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094B6C0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 21:53:11 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 81so1677502pgf.0
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 21:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mmlx-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yisTEGEpuLNf6xZbQr7SAnVyH1VRtVC+ny/LYkg0J4w=;
        b=wyTPMxhtpWvC7Emtna0S2qcY5sK5qWDOSHxY3+fSNmXozOIlIvSeTawBbLP/fE0B9z
         bnqSNdF4xMjcWpyhLdMLzaROeuWISCHDCjqNnPLOwI5DDOArTX/cTMoO7cO4fuhF+TPs
         u9E/bXKDPa0pMtts4zJft9LHHd+H2GEgVnz9f+Ks990HQlC9nIVd8fnVAfrk4OwhwMpa
         YyJW+tN33rF7Ucmdv3tYCW7ml6qhrJb+rufB9jWvb/yY/LAG6oO8mpR+ylOBON12h9Fd
         5d0iAotc0wwpIRGDK9nbtY1Hqs16Mff92kpyY/uvvUyRZJMJejXQD2J3ITcZKh63g6FI
         Ki3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yisTEGEpuLNf6xZbQr7SAnVyH1VRtVC+ny/LYkg0J4w=;
        b=S1RFLEBhJ/HtYggYBzscp7zDGPFhGegwKPRuDUTfgbc/F0fUK4iDf2mOod6X96eTea
         Oj8+IpJ0+k1yKLU0hEc0cXr07VvVAyr7fmvnAR4uVTWN4Q6Bs1SBZgsMNnHjDTsbt0pL
         MbqTovSevNo/d8LoI0YoVTc0tFWuJVg6pNo9bLzFaBHfBiCwrPnsDPtm7/dtORI+OHpc
         fwjmKHlJjt544nIoy20PR7R7o1JBdTu7WhevVyZkpm0HPUMJs59d6JBbOzCy/zCxdnz4
         0EQqYH7sw2SeddTBrunsM7HQrwh/C7Tzr8BEx+XXzm4N6huDRmBi9M3qELD1qPzeUs7D
         l72w==
X-Gm-Message-State: AOAM532p+hL3aqxZCsO2TWZmXki+C8IlToBh70E1XME2o9jkA+Ey1DNQ
        oQNNHWCJFgc9MYM5A/UwqTvABA==
X-Google-Smtp-Source: ABdhPJyVX2qor+e2s977UOIgORSIhDzuZDMpdmOTus8acp40c5R5B5E4m3t9HwqdqJ/zMkX48rRqCg==
X-Received: by 2002:a63:d46:: with SMTP id 6mr8342237pgn.227.1605419591244;
        Sat, 14 Nov 2020 21:53:11 -0800 (PST)
Received: from nitrogen.local.mmlx.us ([199.231.240.229])
        by smtp.gmail.com with ESMTPSA id c28sm15840255pfj.108.2020.11.14.21.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 21:53:10 -0800 (PST)
From:   Matt Mullins <mmullins@mmlx.us>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     dvyukov@google.com, Matt Mullins <mmullins@mmlx.us>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Date:   Sat, 14 Nov 2020 21:52:55 -0800
Message-Id: <20201115055256.65625-1-mmullins@mmlx.us>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <00000000000004500b05b31e68ce@google.com>
References: <00000000000004500b05b31e68ce@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_link_free is always called in process context, including from a
workqueue and from __fput.  Neither of these have the ability to
propagate an -ENOMEM to the caller.

Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
Signed-off-by: Matt Mullins <mmullins@mmlx.us>
---
I previously referenced a "pretty ugly" patch.  This is not that one,
because I don't think there's any way I can make the caller of
->release() actually handle errors like ENOMEM.

It also looks like most of the other ways tracepoint_probe_unregister is
called also don't check the error code (e.g. just a quick grep found
blk_unregister_tracepoints).  Should this just be upgraded to GFP_NOFAIL
across the board instead of passing around a gfp_t?

 include/linux/trace_events.h |  6 ++++--
 include/linux/tracepoint.h   |  7 +++++--
 kernel/bpf/syscall.c         |  2 +-
 kernel/trace/bpf_trace.c     |  6 ++++--
 kernel/trace/trace_events.c  |  6 ++++--
 kernel/tracepoint.c          | 20 ++++++++++----------
 6 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 5c6943354049..166ad7646a98 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -625,7 +625,8 @@ int perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog);
 void perf_event_detach_bpf_prog(struct perf_event *event);
 int perf_event_query_prog_array(struct perf_event *event, void __user *info);
 int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog);
-int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog);
+int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog,
+			 gfp_t flags);
 struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name);
 void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp);
 int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
@@ -654,7 +655,8 @@ static inline int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_p
 {
 	return -EOPNOTSUPP;
 }
-static inline int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *p)
+static inline int bpf_probe_unregister(struct bpf_raw_event_map *btp,
+				       struct bpf_prog *p, gfp_t flags)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 598fec9f9dbf..7b02f92f3b8f 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -12,6 +12,7 @@
  * Heavily inspired from the Linux Kernel Markers.
  */
 
+#include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/srcu.h>
 #include <linux/errno.h>
@@ -40,7 +41,8 @@ extern int
 tracepoint_probe_register_prio(struct tracepoint *tp, void *probe, void *data,
 			       int prio);
 extern int
-tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
+tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data,
+			    gfp_t flags);
 extern void
 for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
 		void *priv);
@@ -260,7 +262,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
 		return tracepoint_probe_unregister(&__tracepoint_##name,\
-						(void *)probe, data);	\
+						(void *)probe, data,	\
+						GFP_KERNEL);		\
 	}								\
 	static inline void						\
 	check_trace_callback_type_##name(void (*cb)(data_proto))	\
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b999e7ff2583..f6876681c4ab 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2601,7 +2601,7 @@ static void bpf_raw_tp_link_release(struct bpf_link *link)
 	struct bpf_raw_tp_link *raw_tp =
 		container_of(link, struct bpf_raw_tp_link, link);
 
-	bpf_probe_unregister(raw_tp->btp, raw_tp->link.prog);
+	bpf_probe_unregister(raw_tp->btp, raw_tp->link.prog, GFP_KERNEL | __GFP_NOFAIL);
 	bpf_put_raw_tracepoint(raw_tp->btp);
 }
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a8d4f253ed77..a4ea58c7506d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1955,9 +1955,11 @@ int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
 	return __bpf_probe_register(btp, prog);
 }
 
-int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
+int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog,
+			 gfp_t flags)
 {
-	return tracepoint_probe_unregister(btp->tp, (void *)btp->bpf_func, prog);
+	return tracepoint_probe_unregister(btp->tp, (void *)btp->bpf_func, prog,
+					   flags);
 }
 
 int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a85effb2373b..ab1ac89caed2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -296,7 +296,8 @@ int trace_event_reg(struct trace_event_call *call,
 	case TRACE_REG_UNREGISTER:
 		tracepoint_probe_unregister(call->tp,
 					    call->class->probe,
-					    file);
+					    file,
+					    GFP_KERNEL);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
@@ -307,7 +308,8 @@ int trace_event_reg(struct trace_event_call *call,
 	case TRACE_REG_PERF_UNREGISTER:
 		tracepoint_probe_unregister(call->tp,
 					    call->class->perf_probe,
-					    call);
+					    call,
+					    GFP_KERNEL);
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 73956eaff8a9..619666a43c9f 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -53,10 +53,9 @@ struct tp_probes {
 	struct tracepoint_func probes[0];
 };
 
-static inline void *allocate_probes(int count)
+static inline void *allocate_probes(int count, gfp_t flags)
 {
-	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
-				       GFP_KERNEL);
+	struct tp_probes *p  = kmalloc(struct_size(p, probes, count), flags);
 	return p == NULL ? NULL : p->probes;
 }
 
@@ -150,7 +149,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 		}
 	}
 	/* + 2 : one for new probe, one for NULL func */
-	new = allocate_probes(nr_probes + 2);
+	new = allocate_probes(nr_probes + 2, GFP_KERNEL);
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old) {
@@ -174,7 +173,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 }
 
 static void *func_remove(struct tracepoint_func **funcs,
-		struct tracepoint_func *tp_func)
+		struct tracepoint_func *tp_func, gfp_t flags)
 {
 	int nr_probes = 0, nr_del = 0, i;
 	struct tracepoint_func *old, *new;
@@ -207,7 +206,7 @@ static void *func_remove(struct tracepoint_func **funcs,
 		int j = 0;
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
-		new = allocate_probes(nr_probes - nr_del + 1);
+		new = allocate_probes(nr_probes - nr_del + 1, flags);
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
 		for (i = 0; old[i].func; i++)
@@ -264,13 +263,13 @@ static int tracepoint_add_func(struct tracepoint *tp,
  * by preempt_disable around the call site.
  */
 static int tracepoint_remove_func(struct tracepoint *tp,
-		struct tracepoint_func *func)
+		struct tracepoint_func *func, gfp_t flags)
 {
 	struct tracepoint_func *old, *tp_funcs;
 
 	tp_funcs = rcu_dereference_protected(tp->funcs,
 			lockdep_is_held(&tracepoints_mutex));
-	old = func_remove(&tp_funcs, func);
+	old = func_remove(&tp_funcs, func, flags);
 	if (IS_ERR(old)) {
 		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
 		return PTR_ERR(old);
@@ -344,7 +343,8 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register);
  *
  * Returns 0 if ok, error value on error.
  */
-int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data)
+int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data,
+				gfp_t flags)
 {
 	struct tracepoint_func tp_func;
 	int ret;
@@ -352,7 +352,7 @@ int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data)
 	mutex_lock(&tracepoints_mutex);
 	tp_func.func = probe;
 	tp_func.data = data;
-	ret = tracepoint_remove_func(tp, &tp_func);
+	ret = tracepoint_remove_func(tp, &tp_func, flags);
 	mutex_unlock(&tracepoints_mutex);
 	return ret;
 }
-- 
2.17.1

