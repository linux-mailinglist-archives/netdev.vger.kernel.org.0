Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5061F4865B0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiAFN7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbiAFN7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:59:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9E1C061245;
        Thu,  6 Jan 2022 05:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C3DB82187;
        Thu,  6 Jan 2022 13:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B013C36AE3;
        Thu,  6 Jan 2022 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641477589;
        bh=fgSR1LFi3kuUftxv03WEvsxMpqnrcirA/Nh4Dp9V+U0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DDZfG4D8o37J/ebD5pINOeQ2s7juuqHVETVLOLAbCR1B1Xe++wXRdHpBVgFG2Cm9F
         3/2ksbE4iCxK4/AqfRUOOZzz4zaYwzPweBuD0XHpDE5p7SnI9MGIFEXWI5G6KSGkBx
         +CiTsAHnPoqqq3FRTRrQtUE4DpIWYRHGs5SbLxuLl3hgqs9FNbZ9PeTptOkNb34fu1
         n/ndBhvfkgrtZy7ZhNvOshsmULgM01NFXopq1LumqzAPSPQb5JCW0MBA1BVS1CPweZ
         vqomihJCjyEPNK5w6R+QDjdj0kcQorkWoxOBxISuZGt5KDmRkq0RFJCooQr8bAWHfT
         MP+lmCmFCfPuA==
Date:   Thu, 6 Jan 2022 22:59:43 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-Id: <20220106225943.87701fcc674202dc3e172289@kernel.org>
In-Reply-To: <YdaoTuWjEeT33Zzm@krava>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
        <YdaoTuWjEeT33Zzm@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__6_Jan_2022_22_59_43_+0900_xoXUXmLlhl=d1Yqq"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__6_Jan_2022_22_59_43_+0900_xoXUXmLlhl=d1Yqq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 6 Jan 2022 09:29:02 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Jan 06, 2022 at 12:24:35AM +0900, Masami Hiramatsu wrote:
> > On Tue,  4 Jan 2022 09:09:30 +0100
> > Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > hi,
> > > adding support to attach multiple kprobes within single syscall
> > > and speed up attachment of many kprobes.
> > > 
> > > The previous attempt [1] wasn't fast enough, so coming with new
> > > approach that adds new kprobe interface.
> > 
> > Yes, since register_kprobes() just registers multiple kprobes on
> > array. This is designed for dozens of kprobes.
> > 
> > > The attachment speed of of this approach (tested in bpftrace)
> > > is now comparable to ftrace tracer attachment speed.. fast ;-)
> > 
> > Yes, because that if ftrace, not kprobes.
> > 
> > > The limit of this approach is forced by using ftrace as attach
> > > layer, so it allows only kprobes on function's entry (plus
> > > return probes).
> > 
> > Note that you also need to multiply the number of instances.
> > 
> > > 
> > > This patchset contains:
> > >   - kprobes support to register multiple kprobes with current
> > >     kprobe API (patches 1 - 8)
> > >   - bpf support ot create new kprobe link allowing to attach
> > >     multiple addresses (patches 9 - 14)
> > > 
> > > We don't need to care about multiple probes on same functions
> > > because it's taken care on the ftrace_ops layer.
> > 
> > Hmm, I think there may be a time to split the "kprobe as an 
> > interface for the software breakpoint" and "kprobe as a wrapper
> > interface for the callbacks of various instrumentations", like
> > 'raw_kprobe'(or kswbp) and 'kprobes'.
> > And this may be called as 'fprobe' as ftrace_ops wrapper.
> > (But if the bpf is enough flexible, this kind of intermediate layer
> >  may not be needed, it can use ftrace_ops directly, eventually)
> > 
> > Jiri, have you already considered to use ftrace_ops from the
> > bpf directly? Are there any issues?
> > (bpf depends on 'kprobe' widely?)
> 
> at the moment there's not ftrace public interface for the return
> probe merged in, so to get the kretprobe working I had to use
> kprobe interface

Yeah, I found that too. We have to ask Steve to salvage it ;)

> but.. there are patches Steven shared some time ago, that do that
> and make graph_ops available as kernel interface
> 
> I recall we considered graph_ops interface before as common attach
> layer for trampolines, which was bad, but it might actually make
> sense for kprobes

I started working on making 'fprobe' which will provide multiple
function probe with similar interface of kprobes. See attached
patch. Then you can use it in bpf, maybe with an union like

union {
	struct kprobe kp;	// for function body
	struct fprobe fp;	// for function entry and return
};

At this moment, fprobe only support entry_handler, but when we
re-start the generic graph_ops interface, it is easy to expand
to support exit_handler.
If this works, I think kretprobe can be phased out, since at that
moment, kprobe_event can replace it with the fprobe exit_handler.
(This is a benefit of decoupling the instrumentation layer from
the event layer. It can choose the best way without changing
user interface.)

> I'll need to check it in more details but I think both graph_ops and
> kprobe do about similar thing wrt hooking return probe, so it should
> be comparable.. and they are already doing the same for the entry hook,
> because kprobe is mostly using ftrace for that
> 
> we would not need to introduce new program type - kprobe programs
> should be able to run from ftrace callbacks just fine

That seems to bind your mind. The program type is just a programing
'model' of the bpf. You can choose the best implementation to provide
equal functionality. 'kprobe' in bpf is just a name that you call some
instrumentations which can probe kernel code.

Thank you,

> 
> so we would have:
>   - kprobe type programs attaching to:
>   - new BPF_LINK_TYPE_FPROBE link using the graph_ops as attachment layer
> 
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>

--Multipart=_Thu__6_Jan_2022_22_59_43_+0900_xoXUXmLlhl=d1Yqq
Content-Type: text/x-diff;
 name="0001-fprobe-Add-ftrace-based-probe-APIs.patch"
Content-Disposition: attachment;
 filename="0001-fprobe-Add-ftrace-based-probe-APIs.patch"
Content-Transfer-Encoding: 7bit

From 269b86597c166d6d4c5dd564168237603533165a Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 6 Jan 2022 15:40:36 +0900
Subject: [PATCH] fprobe: Add ftrace based probe APIs

The fprobe is a wrapper API for ftrace function tracer.
Unlike kprobes, this probes only supports the function entry, but
it can probe multiple functions by one fprobe. The usage is almost
same as the kprobe, user will specify the function names by
fprobe::syms, the number of syms by fprobe::nsyms, and the user
handler by fprobe::handler.

struct fprobe = { 0 };
const char *targets[] = {"func1", "func2", "func3"};

fprobe.handler = user_handler;
fprobe.nsyms = ARRAY_SIZE(targets);
fprobe.syms = targets;

ret = register_fprobe(&fprobe);
...


Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 include/linux/fprobes.h |  52 ++++++++++++++++
 kernel/trace/Kconfig    |  10 ++++
 kernel/trace/Makefile   |   1 +
 kernel/trace/fprobes.c  | 128 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 191 insertions(+)
 create mode 100644 include/linux/fprobes.h
 create mode 100644 kernel/trace/fprobes.c

diff --git a/include/linux/fprobes.h b/include/linux/fprobes.h
new file mode 100644
index 000000000000..22db748bf491
--- /dev/null
+++ b/include/linux/fprobes.h
@@ -0,0 +1,52 @@
+#ifndef _LINUX_FPROBES_H
+#define _LINUX_FPROBES_H
+/* Simple ftrace probe wrapper */
+
+#include <linux/compiler.h>
+#include <linux/ftrace.h>
+
+struct fprobe {
+	const char		**syms;
+	unsigned long		*addrs;
+	unsigned int		nsyms;
+
+	struct ftrace_ops	ftrace;
+	unsigned long		nmissed;
+	unsigned int		flags;
+	void (*handler) (struct fprobe *, struct pt_regs *);
+};
+
+#define FPROBE_FL_DISABLED	1
+
+static inline bool fprobe_disabled(struct fprobe *fp)
+{
+	return (fp) ? fp->flags & FPROBE_FL_DISABLED : false;
+}
+
+#ifdef CONFIG_FPROBES
+int register_fprobe(struct fprobe *fp);
+int unregister_fprobe(struct fprobe *fp);
+#else
+static inline int register_fprobe(struct fprobe *fp)
+{
+	return -ENOTSUPP;
+}
+static inline int unregister_fprobe(struct fprobe *fp)
+{
+	return -ENOTSUPP;
+}
+#endif
+
+static inline void disable_fprobe(struct fprobe *fp)
+{
+	if (fp)
+		fp->flags |= FPROBE_FL_DISABLED;
+}
+
+static inline void enable_fprobe(struct fprobe *fp)
+{
+	if (fp)
+		fp->flags &= ~FPROBE_FL_DISABLED;
+}
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 420ff4bc67fd..45a3618a20a7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -223,6 +223,16 @@ config DYNAMIC_FTRACE_WITH_ARGS
 	depends on DYNAMIC_FTRACE
 	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
+config FPROBES
+	bool "Kernel Function Probe (fprobe)"
+	depends on FUNCTION_TRACER
+	depends on DYNAMIC_FTRACE_WITH_REGS
+	default n
+	help
+	  This option enables kernel function probe feature, which is
+	  similar to kprobes, but probes only for kernel function entries
+	  and it can probe multiple functions by one fprobe.
+
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index bedc5caceec7..47a37a3bb974 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
 obj-$(CONFIG_BOOTTIME_TRACING) += trace_boot.o
 obj-$(CONFIG_FTRACE_RECORD_RECURSION) += trace_recursion_record.o
+obj-$(CONFIG_FPROBES) += fprobes.o
 
 obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 
diff --git a/kernel/trace/fprobes.c b/kernel/trace/fprobes.c
new file mode 100644
index 000000000000..2ea118462afb
--- /dev/null
+++ b/kernel/trace/fprobes.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "fprobes: " fmt
+
+#include <linux/fprobes.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/slab.h>
+
+static void fprobe_handler(unsigned long ip, unsigned long parent_ip,
+			struct ftrace_ops *ops, struct ftrace_regs *fregs)
+{
+	struct fprobe *fp;
+	int bit;
+
+	fp = container_of(ops, struct fprobe, ftrace);
+	if (fprobe_disabled(fp))
+		return;
+
+	bit = ftrace_test_recursion_trylock(ip, parent_ip);
+	if (bit < 0) {
+		fp->nmissed++;
+		return;
+	}
+
+	if (fp->handler)
+		fp->handler(fp, ftrace_get_regs(fregs));
+
+	ftrace_test_recursion_unlock(bit);
+}
+NOKPROBE_SYMBOL(fprobe_handler);
+
+/*
+ * Populate fp::addrs array from fp::syms. Whether the functions are
+ * ftrace-able or not will be checked afterwards by ftrace_set_filter_ip().
+ */
+static int populate_func_addresses(struct fprobe *fp)
+{
+	unsigned int i;
+
+	fp->addrs = kmalloc(sizeof(void *) * fp->nsyms, GFP_KERNEL);
+	if (!fp->addrs)
+		return -ENOMEM;
+
+	for (i = 0; i < fp->nsyms; i++) {
+		fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
+		if (!fp->addrs[i]) {
+			kfree(fp->addrs);
+			fp->addrs = NULL;
+			return -ENOENT;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * register_fprobe - Register fprobe to ftrace
+ * @fp: A fprobe data structure to be registered.
+ *
+ * This expects the user set @fp::syms or @fp::addrs (not both),
+ * @fp::nsyms (number of entries of @fp::syms or @fp::addrs) and
+ * @fp::handler. Other fields are initialized by this function.
+ */
+int register_fprobe(struct fprobe *fp)
+{
+	unsigned int i;
+	int ret;
+
+	if (!fp)
+		return -EINVAL;
+
+	if (!fp->nsyms || (!fp->syms && !fp->addrs) || (fp->syms && fp->addrs))
+		return -EINVAL;
+
+	if (fp->syms) {
+		ret = populate_func_addresses(fp);
+		if (ret < 0)
+			return ret;
+	}
+
+	fp->ftrace.func = fprobe_handler;
+	fp->ftrace.flags = FTRACE_OPS_FL_SAVE_REGS;
+
+	for (i = 0; i < fp->nsyms; i++) {
+		ret = ftrace_set_filter_ip(&fp->ftrace, fp->addrs[i], 0, 0);
+		if (ret < 0)
+			goto error;
+	}
+
+	fp->nmissed = 0;
+	ret = register_ftrace_function(&fp->ftrace);
+	if (!ret)
+		return ret;
+
+error:
+	if (fp->syms) {
+		kfree(fp->addrs);
+		fp->addrs = NULL;
+	}
+
+	return ret;
+}
+
+/**
+ * unregister_fprobe - Unregister fprobe from ftrace
+ * @fp: A fprobe data structure to be unregistered.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	int ret;
+
+	if (!fp)
+		return -EINVAL;
+
+	if (!fp->nsyms || !fp->addrs)
+		return -EINVAL;
+
+	ret = unregister_ftrace_function(&fp->ftrace);
+
+	if (fp->syms) {
+		/* fp->addrs is allocated by register_fprobe() */
+		kfree(fp->addrs);
+		fp->addrs = NULL;
+	}
+
+	return ret;
+}
-- 
2.25.1


--Multipart=_Thu__6_Jan_2022_22_59_43_+0900_xoXUXmLlhl=d1Yqq--
