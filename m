Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84CEE5160
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633101AbfJYQhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:37:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:52466 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633079AbfJYQhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:37:22 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO2aV-0003aq-AA; Fri, 25 Oct 2019 18:37:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 3/5] bpf: Add probe_read_{user,kernel} and probe_read_str_{user,kernel} helpers
Date:   Fri, 25 Oct 2019 18:37:09 +0200
Message-Id: <c4d464c7b06a13b7b8c50fce02ef5e7c76111b33.1572010897.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572010897.git.daniel@iogearbox.net>
References: <cover.1572010897.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current bpf_probe_read() and bpf_probe_read_str() helpers are broken
in that they assume they can be used for probing memory access for kernel
space addresses /as well as/ user space addresses.

However, plain use of probe_kernel_read() for both cases will attempt to
always access kernel space address space given access is performed under
KERNEL_DS and some archs in-fact have overlapping address spaces where a
kernel pointer and user pointer would have the /same/ address value and
therefore accessing application memory via bpf_probe_read{,_str}() would
read garbage values.

Lets fix BPF side by making use of recently added 3d7081822f7f ("uaccess:
Add non-pagefault user-space read functions"). Unfortunately, the only way
to fix this status quo is to add dedicated bpf_probe_read_{user,kernel}()
and bpf_probe_read_str_{user,kernel}() helpers. The bpf_probe_read{,_str}()
helpers are aliased to the *_kernel() variants to retain their current
behavior; for API consistency and ease of use the latter have been added
so that it is immediately *obvious* which address space the memory is being
probed on (user,kernel). The two *_user() variants attempt the access under
USER_DS set.

Fixes: a5e8c07059d0 ("bpf: add bpf_probe_read_str helper")
Fixes: 2541517c32be ("tracing, perf: Implement BPF programs attached to kprobes")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/uapi/linux/bpf.h       | 119 ++++++++++++++++++++---------
 kernel/trace/bpf_trace.c       | 133 ++++++++++++++++++++++-----------
 tools/include/uapi/linux/bpf.h | 119 ++++++++++++++++++++---------
 3 files changed, 253 insertions(+), 118 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..b8ffb419df51 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -564,7 +564,11 @@ union bpf_attr {
  * int bpf_probe_read(void *dst, u32 size, const void *src)
  * 	Description
  * 		For tracing programs, safely attempt to read *size* bytes from
- * 		address *src* and store the data in *dst*.
+ * 		kernel space address *src* and store the data in *dst*.
+ *
+ * 		This helper is an alias to bpf_probe_read_kernel().
+ *
+ * 		Generally, use bpf_probe_read_user() or bpf_probe_read_kernel() instead.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
@@ -1428,43 +1432,14 @@ union bpf_attr {
  *
  * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)
  * 	Description
- * 		Copy a NUL terminated string from an unsafe address
- * 		*unsafe_ptr* to *dst*. The *size* should include the
- * 		terminating NUL byte. In case the string length is smaller than
- * 		*size*, the target is not padded with further NUL bytes. If the
- * 		string length is larger than *size*, just *size*-1 bytes are
- * 		copied and the last byte is set to NUL.
- *
- * 		On success, the length of the copied string is returned. This
- * 		makes this helper useful in tracing programs for reading
- * 		strings, and more importantly to get its length at runtime. See
- * 		the following snippet:
- *
- * 		::
- *
- * 			SEC("kprobe/sys_open")
- * 			void bpf_sys_open(struct pt_regs *ctx)
- * 			{
- * 			        char buf[PATHLEN]; // PATHLEN is defined to 256
- * 			        int res = bpf_probe_read_str(buf, sizeof(buf),
- * 				                             ctx->di);
- *
- * 				// Consume buf, for example push it to
- * 				// userspace via bpf_perf_event_output(); we
- * 				// can use res (the string length) as event
- * 				// size, after checking its boundaries.
- * 			}
+ * 		Copy a NUL terminated string from an unsafe kernel address
+ * 		*unsafe_ptr* to *dst*. See bpf_probe_read_str_kernel() for
+ * 		more details.
  *
- * 		In comparison, using **bpf_probe_read()** helper here instead
- * 		to read the string would require to estimate the length at
- * 		compile time, and would often result in copying more memory
- * 		than necessary.
+ * 		This helper is an alias to bpf_probe_read_str_kernel().
  *
- * 		Another useful use case is when parsing individual process
- * 		arguments or individual environment variables navigating
- * 		*current*\ **->mm->arg_start** and *current*\
- * 		**->mm->env_start**: using this helper and the return value,
- * 		one can quickly iterate at the right offset of the memory area.
+ * 		Generally, use bpf_probe_read_str_user() or bpf_probe_read_str_kernel()
+ * 		instead.
  * 	Return
  * 		On success, the strictly positive length of the string,
  * 		including the trailing NUL character. On error, a negative
@@ -2775,6 +2750,72 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_user(void *dst, u32 size, const void *src)
+ * 	Description
+ * 		Safely attempt to read *size* bytes from user space address
+ * 		*src* and store the data in *dst*.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_kernel(void *dst, u32 size, const void *src)
+ * 	Description
+ * 		Safely attempt to read *size* bytes from kernel space address
+ * 		*src* and store the data in *dst*.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_str_user(void *dst, int size, const void *unsafe_ptr)
+ * 	Description
+ * 		Copy a NUL terminated string from an unsafe user address
+ * 		*unsafe_ptr* to *dst*. The *size* should include the
+ * 		terminating NUL byte. In case the string length is smaller than
+ * 		*size*, the target is not padded with further NUL bytes. If the
+ * 		string length is larger than *size*, just *size*-1 bytes are
+ * 		copied and the last byte is set to NUL.
+ *
+ * 		On success, the length of the copied string is returned. This
+ * 		makes this helper useful in tracing programs for reading
+ * 		strings, and more importantly to get its length at runtime. See
+ * 		the following snippet:
+ *
+ * 		::
+ *
+ * 			SEC("kprobe/sys_open")
+ * 			void bpf_sys_open(struct pt_regs *ctx)
+ * 			{
+ * 			        char buf[PATHLEN]; // PATHLEN is defined to 256
+ * 			        int res = bpf_probe_read_str_user(buf, sizeof(buf),
+ * 				                                  ctx->di);
+ *
+ * 				// Consume buf, for example push it to
+ * 				// userspace via bpf_perf_event_output(); we
+ * 				// can use res (the string length) as event
+ * 				// size, after checking its boundaries.
+ * 			}
+ *
+ * 		In comparison, using **bpf_probe_read_user()** helper here
+ * 		instead to read the string would require to estimate the length
+ * 		at compile time, and would often result in copying more memory
+ * 		than necessary.
+ *
+ * 		Another useful use case is when parsing individual process
+ * 		arguments or individual environment variables navigating
+ * 		*current*\ **->mm->arg_start** and *current*\
+ * 		**->mm->env_start**: using this helper and the return value,
+ * 		one can quickly iterate at the right offset of the memory area.
+ * 	Return
+ * 		On success, the strictly positive length of the string,
+ * 		including the trailing NUL character. On error, a negative
+ * 		value.
+ *
+ * int bpf_probe_read_str_kernel(void *dst, int size, const void *unsafe_ptr)
+ * 	Description
+ * 		Copy a NUL terminated string from an unsafe kernel address *unsafe_ptr*
+ * 		to *dst*. Same semantics as with bpf_probe_read_str_user() apply.
+ * 	Return
+ * 		On success, the strictly positive length of the string,	including
+ * 		the trailing NUL character. On error, a negative value.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2888,7 +2929,11 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(probe_read_user),		\
+	FN(probe_read_kernel),		\
+	FN(probe_read_str_user),	\
+	FN(probe_read_str_kernel),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 79919a26cd59..ff001b766799 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -138,12 +138,52 @@ static const struct bpf_func_proto bpf_override_return_proto = {
 };
 #endif
 
-BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
+BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
+	   const void __user *, unsafe_ptr)
 {
-	int ret;
+	int ret = probe_user_read(dst, unsafe_ptr, size);
 
-	ret = security_locked_down(LOCKDOWN_BPF_READ);
-	if (ret < 0)
+	if (unlikely(ret < 0))
+		memset(dst, 0, size);
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_user_proto = {
+	.func		= bpf_probe_read_user,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_probe_read_str_user, void *, dst, u32, size,
+	   const void __user *, unsafe_ptr)
+{
+	int ret = strncpy_from_unsafe_user(dst, unsafe_ptr, size);
+
+	if (unlikely(ret < 0))
+		memset(dst, 0, size);
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_str_user_proto = {
+	.func		= bpf_probe_read_str_user,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
+	   const void *, unsafe_ptr)
+{
+	int ret = security_locked_down(LOCKDOWN_BPF_READ);
+
+	if (unlikely(ret < 0))
 		goto out;
 
 	ret = probe_kernel_read(dst, unsafe_ptr, size);
@@ -154,8 +194,42 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
 	return ret;
 }
 
-static const struct bpf_func_proto bpf_probe_read_proto = {
-	.func		= bpf_probe_read,
+static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
+	.func		= bpf_probe_read_kernel,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_probe_read_str_kernel, void *, dst, u32, size,
+	   const void *, unsafe_ptr)
+{
+	int ret = security_locked_down(LOCKDOWN_BPF_READ);
+
+	if (unlikely(ret < 0))
+		goto out;
+
+	/*
+	 * The strncpy_from_unsafe() call will likely not fill the entire
+	 * buffer, but that's okay in this circumstance as we're probing
+	 * arbitrary memory anyway similar to bpf_probe_read_*() and might
+	 * as well probe the stack. Thus, memory is explicitly cleared
+	 * only in error case, so that improper users ignoring return
+	 * code altogether don't copy garbage; otherwise length of string
+	 * is returned that can be used for bpf_perf_event_output() et al.
+	 */
+	ret = strncpy_from_unsafe(dst, unsafe_ptr, size);
+	if (unlikely(ret < 0))
+out:
+		memset(dst, 0, size);
+
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_probe_read_str_kernel_proto = {
+	.func		= bpf_probe_read_str_kernel,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
@@ -583,41 +657,6 @@ static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
-	   const void *, unsafe_ptr)
-{
-	int ret;
-
-	ret = security_locked_down(LOCKDOWN_BPF_READ);
-	if (ret < 0)
-		goto out;
-
-	/*
-	 * The strncpy_from_unsafe() call will likely not fill the entire
-	 * buffer, but that's okay in this circumstance as we're probing
-	 * arbitrary memory anyway similar to bpf_probe_read() and might
-	 * as well probe the stack. Thus, memory is explicitly cleared
-	 * only in error case, so that improper users ignoring return
-	 * code altogether don't copy garbage; otherwise length of string
-	 * is returned that can be used for bpf_perf_event_output() et al.
-	 */
-	ret = strncpy_from_unsafe(dst, unsafe_ptr, size);
-	if (unlikely(ret < 0))
-out:
-		memset(dst, 0, size);
-
-	return ret;
-}
-
-static const struct bpf_func_proto bpf_probe_read_str_proto = {
-	.func		= bpf_probe_read_str,
-	.gpl_only	= true,
-	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
-	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
-	.arg3_type	= ARG_ANYTHING,
-};
-
 struct send_signal_irq_work {
 	struct irq_work irq_work;
 	struct task_struct *task;
@@ -697,8 +736,6 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_pop_elem_proto;
 	case BPF_FUNC_map_peek_elem:
 		return &bpf_map_peek_elem_proto;
-	case BPF_FUNC_probe_read:
-		return &bpf_probe_read_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_tail_call:
@@ -725,8 +762,16 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_current_task_under_cgroup_proto;
 	case BPF_FUNC_get_prandom_u32:
 		return &bpf_get_prandom_u32_proto;
+	case BPF_FUNC_probe_read_user:
+		return &bpf_probe_read_user_proto;
+	case BPF_FUNC_probe_read_kernel:
+	case BPF_FUNC_probe_read:
+		return &bpf_probe_read_kernel_proto;
+	case BPF_FUNC_probe_read_str_user:
+		return &bpf_probe_read_str_user_proto;
+	case BPF_FUNC_probe_read_str_kernel:
 	case BPF_FUNC_probe_read_str:
-		return &bpf_probe_read_str_proto;
+		return &bpf_probe_read_str_kernel_proto;
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4af8b0819a32..b8ffb419df51 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -564,7 +564,11 @@ union bpf_attr {
  * int bpf_probe_read(void *dst, u32 size, const void *src)
  * 	Description
  * 		For tracing programs, safely attempt to read *size* bytes from
- * 		address *src* and store the data in *dst*.
+ * 		kernel space address *src* and store the data in *dst*.
+ *
+ * 		This helper is an alias to bpf_probe_read_kernel().
+ *
+ * 		Generally, use bpf_probe_read_user() or bpf_probe_read_kernel() instead.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
@@ -1428,43 +1432,14 @@ union bpf_attr {
  *
  * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)
  * 	Description
- * 		Copy a NUL terminated string from an unsafe address
- * 		*unsafe_ptr* to *dst*. The *size* should include the
- * 		terminating NUL byte. In case the string length is smaller than
- * 		*size*, the target is not padded with further NUL bytes. If the
- * 		string length is larger than *size*, just *size*-1 bytes are
- * 		copied and the last byte is set to NUL.
- *
- * 		On success, the length of the copied string is returned. This
- * 		makes this helper useful in tracing programs for reading
- * 		strings, and more importantly to get its length at runtime. See
- * 		the following snippet:
- *
- * 		::
- *
- * 			SEC("kprobe/sys_open")
- * 			void bpf_sys_open(struct pt_regs *ctx)
- * 			{
- * 			        char buf[PATHLEN]; // PATHLEN is defined to 256
- * 			        int res = bpf_probe_read_str(buf, sizeof(buf),
- * 				                             ctx->di);
- *
- * 				// Consume buf, for example push it to
- * 				// userspace via bpf_perf_event_output(); we
- * 				// can use res (the string length) as event
- * 				// size, after checking its boundaries.
- * 			}
+ * 		Copy a NUL terminated string from an unsafe kernel address
+ * 		*unsafe_ptr* to *dst*. See bpf_probe_read_str_kernel() for
+ * 		more details.
  *
- * 		In comparison, using **bpf_probe_read()** helper here instead
- * 		to read the string would require to estimate the length at
- * 		compile time, and would often result in copying more memory
- * 		than necessary.
+ * 		This helper is an alias to bpf_probe_read_str_kernel().
  *
- * 		Another useful use case is when parsing individual process
- * 		arguments or individual environment variables navigating
- * 		*current*\ **->mm->arg_start** and *current*\
- * 		**->mm->env_start**: using this helper and the return value,
- * 		one can quickly iterate at the right offset of the memory area.
+ * 		Generally, use bpf_probe_read_str_user() or bpf_probe_read_str_kernel()
+ * 		instead.
  * 	Return
  * 		On success, the strictly positive length of the string,
  * 		including the trailing NUL character. On error, a negative
@@ -2775,6 +2750,72 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_user(void *dst, u32 size, const void *src)
+ * 	Description
+ * 		Safely attempt to read *size* bytes from user space address
+ * 		*src* and store the data in *dst*.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_kernel(void *dst, u32 size, const void *src)
+ * 	Description
+ * 		Safely attempt to read *size* bytes from kernel space address
+ * 		*src* and store the data in *dst*.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_probe_read_str_user(void *dst, int size, const void *unsafe_ptr)
+ * 	Description
+ * 		Copy a NUL terminated string from an unsafe user address
+ * 		*unsafe_ptr* to *dst*. The *size* should include the
+ * 		terminating NUL byte. In case the string length is smaller than
+ * 		*size*, the target is not padded with further NUL bytes. If the
+ * 		string length is larger than *size*, just *size*-1 bytes are
+ * 		copied and the last byte is set to NUL.
+ *
+ * 		On success, the length of the copied string is returned. This
+ * 		makes this helper useful in tracing programs for reading
+ * 		strings, and more importantly to get its length at runtime. See
+ * 		the following snippet:
+ *
+ * 		::
+ *
+ * 			SEC("kprobe/sys_open")
+ * 			void bpf_sys_open(struct pt_regs *ctx)
+ * 			{
+ * 			        char buf[PATHLEN]; // PATHLEN is defined to 256
+ * 			        int res = bpf_probe_read_str_user(buf, sizeof(buf),
+ * 				                                  ctx->di);
+ *
+ * 				// Consume buf, for example push it to
+ * 				// userspace via bpf_perf_event_output(); we
+ * 				// can use res (the string length) as event
+ * 				// size, after checking its boundaries.
+ * 			}
+ *
+ * 		In comparison, using **bpf_probe_read_user()** helper here
+ * 		instead to read the string would require to estimate the length
+ * 		at compile time, and would often result in copying more memory
+ * 		than necessary.
+ *
+ * 		Another useful use case is when parsing individual process
+ * 		arguments or individual environment variables navigating
+ * 		*current*\ **->mm->arg_start** and *current*\
+ * 		**->mm->env_start**: using this helper and the return value,
+ * 		one can quickly iterate at the right offset of the memory area.
+ * 	Return
+ * 		On success, the strictly positive length of the string,
+ * 		including the trailing NUL character. On error, a negative
+ * 		value.
+ *
+ * int bpf_probe_read_str_kernel(void *dst, int size, const void *unsafe_ptr)
+ * 	Description
+ * 		Copy a NUL terminated string from an unsafe kernel address *unsafe_ptr*
+ * 		to *dst*. Same semantics as with bpf_probe_read_str_user() apply.
+ * 	Return
+ * 		On success, the strictly positive length of the string,	including
+ * 		the trailing NUL character. On error, a negative value.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2888,7 +2929,11 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(probe_read_user),		\
+	FN(probe_read_kernel),		\
+	FN(probe_read_str_user),	\
+	FN(probe_read_str_kernel),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.21.0

