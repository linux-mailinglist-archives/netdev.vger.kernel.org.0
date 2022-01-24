Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AF6498466
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbiAXQLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:11:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59154 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240989AbiAXQLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:11:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB64B8110D;
        Mon, 24 Jan 2022 16:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3CFC340E5;
        Mon, 24 Jan 2022 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040669;
        bh=YP8yR2ULzF4ht0C7ZypYUVFYi3bHtPsRHNq8KOsRvFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jwtc4yFWTOV5UukHdVBAWQIL9ZnaRJWx9h7hHAQ9DNPYnKzUr9WWMBRrNo+6kuBLK
         qny+OOUSmFwVa2dJlhybaHq+4mFB9uSIw6uqjVkpunwK1XoF0jvqq/r/10Y9sYaMVk
         x7S61M6fbYFHdBYoS711220NVf4IjIayLBAYYy7BYN0Ga7rtuHhhtr4V3DAH8ujzC1
         aQ3zAFvyyF1kAyTHP3sehveBLBE7gJEbdq5KmRQxAVkrqoVtn6208I6RXLXDSKFv2V
         GYRwyZcoJ0IGnkaMg4BJrm6I0ZnHlkKPjIMzXUnsepBfaEhwXsu4bcgS0QySw5ZgD5
         snMhPlbOUZ9IQ==
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
Subject: [PATCH v4 9/9] docs: fprobe: Add fprobe description to ftrace-use.rst
Date:   Tue, 25 Jan 2022 01:11:04 +0900
Message-Id: <164304066409.1680787.10858668334057375469.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164304056155.1680787.14081905648619647218.stgit@devnote2>
References: <164304056155.1680787.14081905648619647218.stgit@devnote2>
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
 Documentation/trace/fprobe.rst |  131 ++++++++++++++++++++++++++++++++++++++++
 Documentation/trace/index.rst  |    1 
 2 files changed, 132 insertions(+)
 create mode 100644 Documentation/trace/fprobe.rst

diff --git a/Documentation/trace/fprobe.rst b/Documentation/trace/fprobe.rst
new file mode 100644
index 000000000000..c53950a1f91e
--- /dev/null
+++ b/Documentation/trace/fprobe.rst
@@ -0,0 +1,131 @@
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
+Typically, `fprobe` data structure is initialized with the `syms`, `nentry`
+and `entry_handler` and/or `exit_handler` as below.
+
+.. code-block:: c
+
+ char targets[] = {"func1", "func2", "func3"};
+ struct fprobe fp = {
+        .syms           = targets,
+        .nentry         = ARRAY_SIZE(targets),
+        .entry_handler  = my_entry_callback,
+        .exit_handler   = my_exit_callback,
+ };
+
+The ftrace_ops in the fprobe is automatically set. The FTRACE_OPS_FL_SAVE_REGS
+and FTRACE_OPS_FL_RECURSION
+flag will be set. If you need other flags, please set it by yourself.
+
+.. code-block:: c
+
+ fp.ops.flags |= FTRACE_OPS_FL_RCU;
+
+To enable this fprobe, call::
+
+  register_fprobe(&fp);
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
+
+Use fprobe with raw address list
+================================
+
+Instead of passing the array of symbols, you can pass a array of raw
+function addresses via `fprobe::addrs`. In this case, the value of
+this array will be changed automatically to the dynamic ftrace NOP
+location addresses in the given kernel function. So please take care
+if you share this array with others.
+
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
+Note that `fprobe::nmissed` field is counted up in both case. The former case
+will skip both of entry and exit callback, and the latter case will skip exit
+callback, but in both case the counter is just increased by 1.
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

