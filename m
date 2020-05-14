Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDFB1D3645
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgENQSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:18:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:36500 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgENQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:18:15 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZGYh-00017u-1Z; Thu, 14 May 2020 18:18:07 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com,
        yhs@fb.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 3/3] bpf: restrict bpf_trace_printk()'s %s usage and add %psK, %psU specifier
Date:   Thu, 14 May 2020 18:16:07 +0200
Message-Id: <20200514161607.9212-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514161607.9212-1-daniel@iogearbox.net>
References: <20200514161607.9212-1-daniel@iogearbox.net>
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
%psK and %psU specifier to bpf_trace_printk() which will then pick the corresponding
strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.

Existing %s for legacy users is still kept working for archs where it is not
broken and therefore gated through CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.

Fixes: 8d3b7dce8622 ("bpf: add support for %s specifier to bpf_trace_printk()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 Documentation/core-api/printk-formats.rst | 14 ++++
 kernel/trace/bpf_trace.c                  | 92 +++++++++++++++--------
 lib/vsprintf.c                            |  7 +-
 3 files changed, 81 insertions(+), 32 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 8ebe46b1af39..76b5f4f265cb 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -112,6 +112,20 @@ used when printing stack backtraces. The specifier takes into
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
+Probed Strings from BPF
+-----------------------
+
+::
+
+	%psK	kernel_string
+	%psU	user_string
+
+The ``sK`` and ``sU`` specifiers are used for printing a string from probed
+memory. From regular vsnprintf(), they are equivalent to ``%s``, however,
+when used out of BPF's bpf_trace_printk() it reads a string of up to 64 bytes
+in memory without faulting. For ``K`` specifier, the string is probed out of
+kernel memory whereas for ``U`` specifier, it is probed out of user memory.
+
 Kernel Pointers
 ---------------
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b83bdaa31c7b..9eef2075ea18 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -323,17 +323,15 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %psK %psU %s
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	   u64, arg2, u64, arg3)
 {
+	int i, mod[3] = {}, fmt_cnt = 0;
+	void *unsafe_ptr = NULL;
 	bool str_seen = false;
-	int mod[3] = {};
-	int fmt_cnt = 0;
-	u64 unsafe_addr;
 	char buf[64];
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
+			if (fmt[i + 1] == 's' &&
+			    (fmt[i + 2] == 'K' ||
+			     fmt[i + 2] == 'U')) {
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
+			case 1:
+				unsafe_ptr = (void *)(long)arg1;
+				arg1 = (long)buf;
+				break;
+			case 2:
+				unsafe_ptr = (void *)(long)arg2;
+				arg2 = (long)buf;
+				break;
+			case 3:
+				unsafe_ptr = (void *)(long)arg3;
+				arg3 = (long)buf;
+				break;
+			}
+
+			buf[0] = 0;
+
+			switch (fmt[i]) {
+			default:
+				return -EOPNOTSUPP;
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+			case 's':
+				/* Fallthrough */
+#endif
+			case 'K':
+				strncpy_from_unsafe(buf, unsafe_ptr,
 						    sizeof(buf));
+				break;
+			case 'U':
+				strncpy_from_unsafe_user(buf,
+						(__force void __user *)unsafe_ptr,
+						sizeof(buf));
+				break;
 			}
-			continue;
+
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
index 7c488a1ce318..06161925225b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2168,6 +2168,8 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
  *		f full name
  *		P node name, including a possible unit address
  * - 'x' For printing the address. Equivalent to "%lx".
+ * - 's[KU]' For printing a string, used in bpf_trace_printk(). For non-BPF
+ *           context this is equivalent to "%s".
  *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
@@ -2180,8 +2182,11 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
 	switch (*fmt) {
-	case 'S':
 	case 's':
+		if (fmt[1] == 'K' || fmt[1] == 'U')
+			return string(buf, end, ptr, spec);
+		/* Fallthrough */
+	case 'S':
 		ptr = dereference_symbol_descriptor(ptr);
 		/* Fallthrough */
 	case 'B':
-- 
2.21.0

