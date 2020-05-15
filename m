Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31171D4A88
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 12:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgEOKLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 06:11:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:48312 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEOKLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 06:11:36 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZXJS-0000Ag-BB; Fri, 15 May 2020 12:11:30 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com,
        yhs@fb.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf v2 3/3] bpf: restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier
Date:   Fri, 15 May 2020 12:11:18 +0200
Message-Id: <20200515101118.6508-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200515101118.6508-1-daniel@iogearbox.net>
References: <20200515101118.6508-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25812/Thu May 14 14:13:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of plain %s conversion specifier in bpf_trace_printk() suffers from the
very same issue as bpf_probe_read{,str}() helpers, that is, it is broken on
archs with overlapping address ranges.

While the helpers have been addressed through work in 6ae08ae3dea2 ("bpf: Add
probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers"), we need
an option for bpf_trace_printk() as well to fix it.

Similarly as with the helpers, force users to make an explicit choice by adding
%pks and %pus specifier to bpf_trace_printk() which will then pick the corresponding
strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.
The %pk* (kernel specifier) and %pu* (user specifier) can later also be extended
for other objects aside strings that are probed and printed under tracing, and
reused out of other facilities like bpf_seq_printf() or BTF based type printing.

Existing behavior of %s for current users is still kept working for archs where it
is not broken and therefore gated through CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.
For archs not having this property we fall-back to pick probing under KERNEL_DS as
a sensible default.

Fixes: 8d3b7dce8622 ("bpf: add support for %s specifier to bpf_trace_printk()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 Documentation/core-api/printk-formats.rst | 14 ++++
 kernel/trace/bpf_trace.c                  | 94 +++++++++++++++--------
 lib/vsprintf.c                            | 12 +++
 3 files changed, 88 insertions(+), 32 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 8ebe46b1af39..5dfcc4592b23 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -112,6 +112,20 @@ used when printing stack backtraces. The specifier takes into
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
+Probed Pointers from BPF / tracing
+----------------------------------
+
+::
+
+	%pks	kernel string
+	%pus	user string
+
+The ``k`` and ``u`` specifiers are used for printing prior probed memory from
+either kernel memory (k) or user memory (u). The subsequent ``s`` specifier
+results in printing a string. For direct use in regular vsnprintf() the (k)
+and (u) annotation is ignored, however, when used out of BPF's bpf_trace_printk(),
+for example, it reads the memory it is pointing to without faulting.
+
 Kernel Pointers
 ---------------
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b83bdaa31c7b..a010edc37ee0 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -323,17 +323,15 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	   u64, arg2, u64, arg3)
 {
+	int i, mod[3] = {}, fmt_cnt = 0;
+	char buf[64], fmt_ptype;
+	void *unsafe_ptr = NULL;
 	bool str_seen = false;
-	int mod[3] = {};
-	int fmt_cnt = 0;
-	u64 unsafe_addr;
-	char buf[64];
-	int i;
 
 	/*
 	 * bpf_check()->check_func_arg()->check_stack_boundary()
@@ -359,40 +357,71 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 		if (fmt[i] == 'l') {
 			mod[fmt_cnt]++;
 			i++;
-		} else if (fmt[i] == 'p' || fmt[i] == 's') {
+		} else if (fmt[i] == 'p') {
 			mod[fmt_cnt]++;
+			if ((fmt[i + 1] == 'k' ||
+			     fmt[i + 1] == 'u') &&
+			    fmt[i + 2] == 's') {
+				fmt_ptype = fmt[i + 1];
+				i += 2;
+				goto fmt_str;
+			}
+
 			/* disallow any further format extensions */
 			if (fmt[i + 1] != 0 &&
 			    !isspace(fmt[i + 1]) &&
 			    !ispunct(fmt[i + 1]))
 				return -EINVAL;
-			fmt_cnt++;
-			if (fmt[i] == 's') {
-				if (str_seen)
-					/* allow only one '%s' per fmt string */
-					return -EINVAL;
-				str_seen = true;
-
-				switch (fmt_cnt) {
-				case 1:
-					unsafe_addr = arg1;
-					arg1 = (long) buf;
-					break;
-				case 2:
-					unsafe_addr = arg2;
-					arg2 = (long) buf;
-					break;
-				case 3:
-					unsafe_addr = arg3;
-					arg3 = (long) buf;
-					break;
-				}
-				buf[0] = 0;
-				strncpy_from_unsafe(buf,
-						    (void *) (long) unsafe_addr,
+
+			goto fmt_next;
+		} else if (fmt[i] == 's') {
+			mod[fmt_cnt]++;
+			fmt_ptype = fmt[i];
+fmt_str:
+			if (str_seen)
+				/* allow only one '%s' per fmt string */
+				return -EINVAL;
+			str_seen = true;
+
+			if (fmt[i + 1] != 0 &&
+			    !isspace(fmt[i + 1]) &&
+			    !ispunct(fmt[i + 1]))
+				return -EINVAL;
+
+			switch (fmt_cnt) {
+			case 0:
+				unsafe_ptr = (void *)(long)arg1;
+				arg1 = (long)buf;
+				break;
+			case 1:
+				unsafe_ptr = (void *)(long)arg2;
+				arg2 = (long)buf;
+				break;
+			case 2:
+				unsafe_ptr = (void *)(long)arg3;
+				arg3 = (long)buf;
+				break;
+			}
+
+			buf[0] = 0;
+			switch (fmt_ptype) {
+			case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+				strncpy_from_unsafe(buf, unsafe_ptr,
 						    sizeof(buf));
+				break;
+#endif
+			case 'k':
+				strncpy_from_unsafe_strict(buf, unsafe_ptr,
+							   sizeof(buf));
+				break;
+			case 'u':
+				strncpy_from_unsafe_user(buf,
+					(__force void __user *)unsafe_ptr,
+							 sizeof(buf));
+				break;
 			}
-			continue;
+			goto fmt_next;
 		}
 
 		if (fmt[i] == 'l') {
@@ -403,6 +432,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 		if (fmt[i] != 'i' && fmt[i] != 'd' &&
 		    fmt[i] != 'u' && fmt[i] != 'x')
 			return -EINVAL;
+fmt_next:
 		fmt_cnt++;
 	}
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7c488a1ce318..532b6606a18a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2168,6 +2168,10 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
  *		f full name
  *		P node name, including a possible unit address
  * - 'x' For printing the address. Equivalent to "%lx".
+ * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
+ *           bpf_trace_printk() where [ku] prefix specifies either kernel (k)
+ *           or user (u) memory to probe, and:
+ *              s a string, equivalent to "%s" on direct vsnprintf() use
  *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
@@ -2251,6 +2255,14 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		if (!IS_ERR(ptr))
 			break;
 		return err_ptr(buf, end, ptr, spec);
+	case 'u':
+	case 'k':
+		switch (fmt[1]) {
+		case 's':
+			return string(buf, end, ptr, spec);
+		default:
+			return error_string(buf, end, "(einval)", spec);
+		}
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
-- 
2.21.0

