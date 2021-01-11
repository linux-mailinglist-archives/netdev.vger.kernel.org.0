Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FEE2F1DDF
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390336AbhAKSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:21:35 -0500
Received: from foss.arm.com ([217.140.110.172]:34224 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390214AbhAKSVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 13:21:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC75011B3;
        Mon, 11 Jan 2021 10:20:48 -0800 (PST)
Received: from e107158-lin.cambridge.arm.com (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 853133F70D;
        Mon, 11 Jan 2021 10:20:47 -0800 (PST)
From:   Qais Yousef <qais.yousef@arm.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH bpf-next 1/2] trace: bpf: Allow bpf to attach to bare tracepoints
Date:   Mon, 11 Jan 2021 18:20:26 +0000
Message-Id: <20210111182027.1448538-2-qais.yousef@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111182027.1448538-1-qais.yousef@arm.com>
References: <20210111182027.1448538-1-qais.yousef@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some subsystems only have bare tracepoints (a tracepoint with no
associated trace event) to avoid the problem of trace events being an
ABI that can't be changed.

From bpf presepective, bare tracepoints are what it calls
RAW_TRACEPOINT().

Since bpf assumed there's 1:1 mapping, it relied on hooking to
DEFINE_EVENT() macro to create bpf mapping of the tracepoints. Since
bare tracepoints use DECLARE_TRACE() to create the tracepoint, bpf had
no knowledge about their existence.

By teaching bpf_probe.h to parse DECLARE_TRACE() in a similar fashion to
DEFINE_EVENT(), bpf can find and attach to the new raw tracepoints.

Enabling that comes with the contract that changes to raw tracepoints
don't constitute a regression if they break existing bpf programs.
We need the ability to continue to morph and modify these raw
tracepoints without worrying about any ABI.

Update Documentation/bpf/bpf_design_QA.rst to document this contract.

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
---
 Documentation/bpf/bpf_design_QA.rst |  6 ++++++
 include/trace/bpf_probe.h           | 12 ++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 2df7b067ab93..0e15f9b05c9d 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -208,6 +208,12 @@ data structures and compile with kernel internal headers. Both of these
 kernel internals are subject to change and can break with newer kernels
 such that the program needs to be adapted accordingly.
 
+Q: Are tracepoints part of the stable ABI?
+------------------------------------------
+A: NO. Tracepoints are tied to internal implementation details hence they are
+subject to change and can break with newer kernels. BPF programs need to change
+accordingly when this happens.
+
 Q: How much stack space a BPF program uses?
 -------------------------------------------
 A: Currently all program types are limited to 512 bytes of stack
diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index cd74bffed5c6..cf1496b162b1 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -55,8 +55,7 @@
 /* tracepoints with more than 12 arguments will hit build error */
 #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#define __BPF_DECLARE_TRACE(call, proto, args)				\
 static notrace void							\
 __bpf_trace_##call(void *__data, proto)					\
 {									\
@@ -64,6 +63,10 @@ __bpf_trace_##call(void *__data, proto)					\
 	CONCATENATE(bpf_trace_run, COUNT_ARGS(args))(prog, CAST_TO_U64(args));	\
 }
 
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+	__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
+
 /*
  * This part is compiled out, it is only here as a build time check
  * to make sure that if the tracepoint handling changes, the
@@ -111,6 +114,11 @@ __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
 
+#undef DECLARE_TRACE
+#define DECLARE_TRACE(call, proto, args)				\
+	(__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))		\
+	 __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 #undef DEFINE_EVENT_WRITABLE
-- 
2.25.1

