Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD8D49FBCE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349290AbiA1Od6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:33:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56042 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349303AbiA1Od4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:33:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B818261E03;
        Fri, 28 Jan 2022 14:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D63C340E0;
        Fri, 28 Jan 2022 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380435;
        bh=OE0e9W2TNZyYtg1Q6DeCOmzfjccu07UGpYBN1R/FO4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIRWVo9Rgre2t+DYBwdCyLQO05SZD33jMypxBuNurgsm0wz1hyZDMlo3dB57Y1l12
         IPJM8BVJy2HybIhBd/G71vY+ogYkEW1Li/P02rJtjzoJVSgPuMnP/FlXz7HqU7lGsi
         2OeunI89KiX3U1hTtCRTgE/5vPqsHJn55KFQgJa0DZCs0Sqk9HY99i20icHozJpIa5
         8xhAQQR22Xqht2KGhxfWdvyC542ROCh5vd+GFFo0P+CpD7GNq/yeltvpLY90HUrI4U
         clgtYxhT4iTaZN3qpOspg1x3mWGPtgGCpVoI36LcobNnQNM3GW82U3MIlWzmvnDqjO
         dP1V7PoNjxnnA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v6 10/10] docs: fprobe: Add fprobe description to ftrace-use.rst
Date:   Fri, 28 Jan 2022 23:33:49 +0900
Message-Id: <164338042933.2429999.11098425631444822675.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164338031590.2429999.6203979005944292576.stgit@devnote2>
References: <164338031590.2429999.6203979005944292576.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a documentation of fprobe for the user who needs
this interface.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v6:
  - Update document according to the latest spec.
---
 Documentation/trace/fprobe.rst |  161 ++++++++++++++++++++++++++++++++++++++++
 Documentation/trace/index.rst  |    1 
 2 files changed, 162 insertions(+)
 create mode 100644 Documentation/trace/fprobe.rst

diff --git a/Documentation/trace/fprobe.rst b/Documentation/trace/fprobe.rst
new file mode 100644
index 000000000000..477eed7ab5ce
--- /dev/null
+++ b/Documentation/trace/fprobe.rst
@@ -0,0 +1,161 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Fprobe - Function entry/exit probe
+==================================
+
+.. Author: Masami Hiramatsu <mhiramat@kernel.org>
+
+Introduction
+============
+
+Instead of using ftrace full feature, if you only want to attach callbacks
+on function entry and exit, similar to the kprobes and kretprobes, you can
+use fprobe. Compared with kprobes and kretprobes, fprobe gives faster
+instrumentation for multiple functions with single handler. This document
+describes how to use fprobe.
+
+The usage of fprobe
+===================
+
+The fprobe is a wrapper of ftrace (+ kretprobe-like return callback) to
+attach callbacks to multiple function entry and exit. User needs to set up
+the `struct fprobe` and pass it to `register_fprobe()`.
+
+Typically, `fprobe` data structure is initialized with the `entry_handler`
+and/or `exit_handler` as below.
+
+.. code-block:: c
+
+ struct fprobe fp = {
+        .entry_handler  = my_entry_callback,
+        .exit_handler   = my_exit_callback,
+ };
+
+To enable the fprobe, call one of register_fprobe(), register_fprobe_ips(), and
+register_fprobe_syms(). These register the fprobe with different type of
+parameters.
+
+The register_fprobe() enables a fprobe by function-name filters.
+E.g. this enables @fp on "func*()" function except "func2()".::
+
+  register_fprobe(&fp, "func*", "func2");
+
+The register_fprobe_ips() enables a fprobe by ftrace-location addresses.
+E.g.::
+
+  unsigned long ips[] = { 0x.... };
+
+  register_fprobe_ips(&fp, ips, ARRAY_SIZE(ips));
+
+And the register_fprobe_syms() enables a fprobe by symbol names.
+E.g.::
+
+  char syms[] = {"func1", "func2", "func3"};
+
+  register_fprobe_syms(&fp, syms, ARRAY_SIZE(syms));
+
+To disable (remove from functions) this fprobe, call::
+
+  unregister_fprobe(&fp);
+
+You can temporally (soft) disable the fprobe by::
+
+  disable_fprobe(&fp);
+
+and resume by::
+
+  enable_fprobe(&fp);
+
+The above is defined by including the header::
+
+  #include <linux/fprobe.h>
+
+Same as ftrace, the registered callback will start being called some time
+after the register_fprobe() is called and before it returns. See
+:file:`Documentation/trace/ftrace.rst`.
+
+The fprobe entry/exit handler
+=============================
+
+The prototype of the entry/exit callback function is as follows:
+
+.. code-block:: c
+
+ void callback_func(struct fprobe *fp, unsigned long entry_ip, struct pt_regs *regs);
+
+Note that both entry and exit callback has same ptototype. The @entry_ip is
+saved at function entry and passed to exit handler.
+
+@fp
+        This is the address of `fprobe` data structure related to this handler.
+        You can embed the `fprobe` to your data structure and get it by
+        container_of() macro from @fp. The @fp must not be NULL.
+
+@entry_ip
+        This is the entry address of the traced function (both entry and exit).
+
+@regs
+        This is the `pt_regs` data structure at the entry and exit. Note that
+        the instruction pointer of @regs may be different from the @entry_ip
+        in the entry_handler. If you need traced instruction pointer, you need
+        to use @entry_ip. On the other hand, in the exit_handler, the instruction
+        pointer of @regs is set to the currect return address.
+
+Use callback with kprobes
+=========================
+
+Since the recursion safety of the fprobe (and ftrace) is a bit different
+from the kprobes, this may cause an issue if user wants to run the same
+code from the fprobe and the kprobes.
+
+The kprobes has per-cpu 'current_kprobe' variable which protects the
+kprobe handler from recursion in any case. On the other hand, the fprobe
+uses only ftrace_test_recursion_trylock(), which will allow interrupt
+context calls another (or same) fprobe during the fprobe user handler is
+running.
+
+This is not a matter in cases if the common callback shared among the
+kprobes and the fprobe has its own recursion detection, or it can handle
+the recursion in the different contexts (normal/interrupt/NMI.)
+But if it relies on the 'current_kprobe' recursion lock, it has to check
+kprobe_running() and use kprobe_busy_*() APIs.
+
+Fprobe has FPROBE_FL_KPROBE_SHARED flag to do this. If your common callback
+code will be shared with kprobes, please set FPROBE_FL_KPROBE_SHARED
+*before* registering the fprobe, like::
+
+ fprobe.flags = FPROBE_FL_KPROBE_SHARED;
+
+ register_fprobe(&fprobe, "func*", NULL);
+
+This will protect your common callback from the nested call.
+
+The missed counter
+==================
+
+The `fprobe` data structure has `fprobe::nmissed` counter field as same as
+kprobes.
+This counter counts up when;
+
+ - fprobe fails to take ftrace_recursion lock. This usually means that a function
+   which is traced by other ftrace users is called from the entry_handler.
+
+ - fprobe fails to setup the function exit because of the shortage of rethook
+   (the shadow stack for hooking the function return.)
+
+Since `fprobe::nmissed` field is counted up in both case, the former case
+will skip both of entry and exit callback, and the latter case will skip exit
+callback, but in both case the counter is just increased by 1.
+
+Note that if you set the FTRACE_OPS_FL_RECURSION and/or FTRACE_OPS_FL_RCU to
+`fprobe::ops::flags` (ftrace_ops::flags) when registering the fprobe, this
+counter may not work correctly, because those will skip fprobe's callback.
+
+
+Functions and structures
+========================
+
+.. kernel-doc:: include/linux/fprobe.h
+.. kernel-doc:: kernel/trace/fprobe.c
+
diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 3769b9b7aed8..b9f3757f8269 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -9,6 +9,7 @@ Linux Tracing Technologies
    tracepoint-analysis
    ftrace
    ftrace-uses
+   fprobe
    kprobes
    kprobetrace
    uprobetracer

