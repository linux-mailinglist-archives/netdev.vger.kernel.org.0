Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AE71F2DEF
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733145AbgFIAhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbgFHXNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C8321531;
        Mon,  8 Jun 2020 23:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658025;
        bh=8LKkSmb+vl2Qod9UjEFoRnxV0NQLj0PnYzV7F1Rt0VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mp2ki8QheQA4RVefEe177A8fH1b8ZRNKxUDRQiIWp+ryAJDmg6lyvML1Ed8K+DVRS
         kNMIBqClYjYRVxHXsYl/kRLGjXKt3chydNckxLX659Lehejg3qH/IR0BS88/DA5XBd
         gZOBp/McGKG89tWJTTeaQBwg9M8VAhwlV3XHDqA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 077/606] bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier
Date:   Mon,  8 Jun 2020 19:03:22 -0400
Message-Id: <20200608231211.3363633-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit b2a5212fb634561bb734c6356904e37f6665b955 upstream.

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
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Link: https://lore.kernel.org/bpf/20200515101118.6508-4-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
index 68250d433bd7..b899a2d7e900 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -325,17 +325,15 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 
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
@@ -361,40 +359,71 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
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
@@ -405,6 +434,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
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
2.25.1

