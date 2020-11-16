Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C84C2B5359
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgKPVCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgKPVCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:02:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D22207BC;
        Mon, 16 Nov 2020 21:02:20 +0000 (UTC)
Date:   Mon, 16 Nov 2020 16:02:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201116160218.3b705345@gandalf.local.home>
In-Reply-To: <20201116154437.254a8b97@gandalf.local.home>
References: <00000000000004500b05b31e68ce@google.com>
        <20201115055256.65625-1-mmullins@mmlx.us>
        <20201116121929.1a7aeb16@gandalf.local.home>
        <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com>
        <20201116154437.254a8b97@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 15:44:37 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> If you use a stub function, it shouldn't affect anything. And the worse
> that would happen is that you have a slight overhead of calling the stub
> until you can properly remove the callback.

Something like this:

(haven't compiled it yet, I'm about to though).

-- Steve

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3f659f855074..8eab40f9d388 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -53,10 +53,16 @@ struct tp_probes {
 	struct tracepoint_func probes[];
 };
 
-static inline void *allocate_probes(int count)
+/* Called in removal of a func but failed to allocate a new tp_funcs */
+static void tp_stub_func(void)
+{
+	return;
+}
+
+static inline void *allocate_probes(int count, gfp_t extra_flags)
 {
 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
-				       GFP_KERNEL);
+				       GFP_KERNEL | extra_flags);
 	return p == NULL ? NULL : p->probes;
 }
 
@@ -150,7 +156,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 		}
 	}
 	/* + 2 : one for new probe, one for NULL func */
-	new = allocate_probes(nr_probes + 2);
+	new = allocate_probes(nr_probes + 2, 0);
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old) {
@@ -188,8 +194,9 @@ static void *func_remove(struct tracepoint_func **funcs,
 	/* (N -> M), (N > 1, M >= 0) probes */
 	if (tp_func->func) {
 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-			if (old[nr_probes].func == tp_func->func &&
-			     old[nr_probes].data == tp_func->data)
+			if ((old[nr_probes].func == tp_func->func &&
+			     old[nr_probes].data == tp_func->data) ||
+			    old[nr_probes].func == tp_stub_func)
 				nr_del++;
 		}
 	}
@@ -207,15 +214,20 @@ static void *func_remove(struct tracepoint_func **funcs,
 		int j = 0;
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
-		new = allocate_probes(nr_probes - nr_del + 1);
-		if (new == NULL)
-			return ERR_PTR(-ENOMEM);
-		for (i = 0; old[i].func; i++)
-			if (old[i].func != tp_func->func
-					|| old[i].data != tp_func->data)
-				new[j++] = old[i];
-		new[nr_probes - nr_del].func = NULL;
-		*funcs = new;
+		new = allocate_probes(nr_probes - nr_del + 1, __GFP_NOFAIL);
+		if (new) {
+			for (i = 0; old[i].func; i++)
+				if (old[i].func != tp_func->func
+				    || old[i].data != tp_func->data)
+					new[j++] = old[i];
+			new[nr_probes - nr_del].func = NULL;
+		} else {
+			for (i = 0; old[i].func; i++)
+				if (old[i].func == tp_func->func &&
+				    old[i].data == tp_func->data)
+					old[i].func = tp_stub_func;
+		}
+		*funcs = old;
 	}
 	debug_print_probes(*funcs);
 	return old;
@@ -300,6 +312,10 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 		return PTR_ERR(old);
 	}
 
+	if (tp_funcs == old)
+		/* Failed allocating new tp_funcs, replaced func with stub */
+		return 0;
+
 	if (!tp_funcs) {
 		/* Removed last function */
 		if (tp->unregfunc && static_key_enabled(&tp->key))
