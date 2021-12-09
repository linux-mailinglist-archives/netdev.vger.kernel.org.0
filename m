Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B5B46F130
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbhLIRNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242596AbhLIRNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:31 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38C9C061A72;
        Thu,  9 Dec 2021 09:09:57 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so5347445pjq.4;
        Thu, 09 Dec 2021 09:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aI1nGou3Nc0FoFgo0ANOkn7CZWEGUiq9qzL72YqOolY=;
        b=V0c9APP6bMUDpR3j6gxvHoBh5UJEwAYx3H4Jftw4Mdo7VbfE1MaIww3dreN8ZmORks
         oZU0kNnDrx0nZzCGWXl5FZvahiY6FD6n9mc5Te1pn0QslFMHuwmrYCRs1cq+KIsI7P1J
         vOxGzx3KO0F/vozjcj+s7JD087a8cKJ6eqTeM+kFDZaiAidL3jFnVPAvioHoVvDeLe84
         g1cwQlzsU2mrJjl9CRN+6eyYhmQdVKYNIEf8RMgiV81U37T2qNQnx+ospB6F61roFTzN
         Unc18H70YlT34s5rONsnZOmNsgTP6+t6MqqiC4iSDyS14oU8PgM7MaXq4At2jgdt1x8V
         ZWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aI1nGou3Nc0FoFgo0ANOkn7CZWEGUiq9qzL72YqOolY=;
        b=MjcucLlQprDRhgjBrct1QlxBaPgZPsCViUlkKrvOpP2nAb2FBwQ/Pm3jG9OuZmILMO
         CWPnx40gnbEDkHoig0fMS/7cZXPu3c+9X4m/XndCw/42LHh/Xo7kRdIL9hq68VCzBoCt
         /VqdaoaYWC+O++vvqw6vZSSDUesqJkeJMpmSvKHZ7b0LzZ8FlLoOxHpKfsrQqi/r92yj
         JIjnbJxKJ3Dbu0cyyo6At7989HYSwVPqfzjyCDEUL1IkPeenQkqXhxAKCOcjVwr2soon
         mtGxs7yXYU4JJBJ6D1fw01jbBBfXpHSJIxTrf1Lu3P1XFtJ5Iluwjif89w7ZtoerUbjf
         eyJg==
X-Gm-Message-State: AOAM531UsfG+R37cmebtT9p7QeCiIoKxBx7xcEffRxgdXMuUuGjVUa+P
        FxmwHprJr3vhUBzQQmAcBhDNrnvB1Es=
X-Google-Smtp-Source: ABdhPJz4naH3vRAXK1UivP93k1jNz3BUABvSpC9fCwRlMpJM/9JE8zOgie3iHk/L5xqT31QMYPnSoQ==
X-Received: by 2002:a17:90a:d48f:: with SMTP id s15mr17143580pju.64.1639069797123;
        Thu, 09 Dec 2021 09:09:57 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id j38sm183694pgb.84.2021.12.09.09.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:56 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v2 8/9] selftests/bpf: Extend kfunc selftests
Date:   Thu,  9 Dec 2021 22:39:28 +0530
Message-Id: <20211209170929.3485242-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12528; h=from:subject; bh=55KFim4ne0RHMM1nfAOqStqfVDWbySP87cnaUnDiO6k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgI93QMIBa/AUbCL9cdPn+fNjlUKo/O5oRU65mC 1RhxVNOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4CAAKCRBM4MiGSL8RymZzEA CsnLPg4UhmYYAtDKqpye3Hc+rWq4CtiCCZjxsXGUmhwUM8NMv68vUC0D3cBcGrABWPHzfLY35noj6M yisOjXLWdnZhtabuyMSgNjC+cTaZoiGliJ+DUG3CNBPCYkiR3CsPmmKNOb+DgR84QwIXGNBVxUc0Fm 7f4ezCRFJ4Fd+utfrRQHE/V7pu5T7L6N91nP3O26jzNYTzDa4uvYR3aYu0mkPxhGBx7F2UaFDqzgLF K47LWMtsyCwZWlENrpvjq7hYfBdVAMEre6ENjjedIQ+xZKd4PDhIctS0bzh+BWB87HtSGPCxDyVrk9 3cxVTM8DhkHajp6RUcYjzFIvxCb07Au/Gm+eemlW2U8k0ZILUzanz9mUYl2S6IsI4J+tf8jxafpK/h gz419WlOm+pJLah4O5RRPkHGUAY/UaL29eJAJdit/B+o9kR9GoQT7Iwc4NudnAFYciNoWoDdC7vefp 8ikWfSgAU8Lyy/JkhTcCT3KDZuN2eTzKebje3GbplwL21DTmm0xyMh4UFO8nJKJy9yqKcMla2xT0wc qcE/TEfIo0+Qejki1eeFFDbMxMMf8k5MrQaiytkrjFR4nmnKptl14w7kSgG/nHtvX2/EC5EzIC+7wQ Nn0k+lA1LjC99ZT3PuyGPn2fOn6taT6UVPQ+s2jl7l+GYcW+xYKLD4pMx5Bw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the prog_test kfuncs to test the referenced PTR_TO_BTF_ID kfunc
support, and PTR_TO_CTX, PTR_TO_MEM argument passing support. Also
testing the various failure cases.

The failure selftests will test the following cases for kfunc:
kfunc_call_test_fail1 - Argument struct type has non-scalar member
kfunc_call_test_fail2 - Nesting depth of type > 8
kfunc_call_test_fail3 - Struct type has trailing zero-sized FAM
kfunc_call_test_fail4 - Trying to pass reg->type != PTR_TO_CTX when
			argument struct type is a ctx type
kfunc_call_test_fail5 - void * not part of mem, len pair
kfunc_call_test_fail6 - u64 * not part of mem, len pair
kfunc_call_test_fail7 - mark_btf_ld_reg copies ref_obj_id
kfunc_call_test_fail8 - Same type btf_struct_walk reference copy handled
			correctly during release (i.e. only parent
			object can be released)

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/kfunc_call.c     | 28 ++++++++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 52 ++++++++++++++++++-
 .../bpf/progs/kfunc_call_test_fail1.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail2.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail3.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail4.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail5.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail6.c         | 16 ++++++
 .../bpf/progs/kfunc_call_test_fail7.c         | 24 +++++++++
 .../bpf/progs/kfunc_call_test_fail8.c         | 22 ++++++++
 10 files changed, 220 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 7d7445ccc141..b6630b9427d0 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -5,11 +5,33 @@
 #include "kfunc_call_test.lskel.h"
 #include "kfunc_call_test_subprog.skel.h"
 #include "kfunc_call_test_subprog.lskel.h"
+#include "kfunc_call_test_fail1.skel.h"
+#include "kfunc_call_test_fail2.skel.h"
+#include "kfunc_call_test_fail3.skel.h"
+#include "kfunc_call_test_fail4.skel.h"
+#include "kfunc_call_test_fail5.skel.h"
+#include "kfunc_call_test_fail6.skel.h"
+#include "kfunc_call_test_fail7.skel.h"
+#include "kfunc_call_test_fail8.skel.h"
 
 static void test_main(void)
 {
 	struct kfunc_call_test_lskel *skel;
 	int prog_fd, retval, err;
+	void *fskel;
+
+#define FAIL(nr)                                                               \
+	({                                                                     \
+		fskel = kfunc_call_test_fail##nr##__open_and_load();           \
+		if (!ASSERT_EQ(fskel, NULL,                                    \
+			       "kfunc_call_test_fail" #nr                      \
+			       "__open_and_load")) {                           \
+			kfunc_call_test_fail##nr##__destroy(fskel);            \
+			return;                                                \
+		}                                                              \
+	})
+
+	FAIL(1); FAIL(2); FAIL(3); FAIL(4); FAIL(5); FAIL(6); FAIL(7); FAIL(8);
 
 	skel = kfunc_call_test_lskel__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel"))
@@ -27,6 +49,12 @@ static void test_main(void)
 	ASSERT_OK(err, "bpf_prog_test_run(test2)");
 	ASSERT_EQ(retval, 3, "test2-retval");
 
+	prog_fd = skel->progs.kfunc_call_test_ref_btf_id.prog_fd;
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	ASSERT_OK(err, "bpf_prog_test_run(test_ref_btf_id)");
+	ASSERT_EQ(retval, 0, "test_ref_btf_id-retval");
+
 	kfunc_call_test_lskel__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index 8a8cf59017aa..5aecbb9fdc68 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -1,13 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2021 Facebook */
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_tcp_helpers.h"
 
 extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksym;
 extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
 				  __u32 c, __u64 d) __ksym;
 
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+extern void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb) __ksym;
+extern void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p) __ksym;
+extern void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p) __ksym;
+extern void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len) __ksym;
+extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
+
 SEC("tc")
 int kfunc_call_test2(struct __sk_buff *skb)
 {
@@ -44,4 +51,45 @@ int kfunc_call_test1(struct __sk_buff *skb)
 	return ret;
 }
 
+SEC("tc")
+int kfunc_call_test_ref_btf_id(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *pt;
+	unsigned long s = 0;
+	int ret = 0;
+
+	pt = bpf_kfunc_call_test_acquire(&s);
+	if (pt) {
+		if (pt->a != 42 || pt->b != 108)
+			ret = -1;
+		bpf_kfunc_call_test_release(pt);
+	}
+	return ret;
+}
+
+SEC("tc")
+int kfunc_call_test_pass(struct __sk_buff *skb)
+{
+	struct prog_test_pass1 p1 = {};
+	struct prog_test_pass2 p2 = {};
+	short a = 0;
+	__u64 b = 0;
+	long c = 0;
+	char d = 0;
+	int e = 0;
+
+	bpf_kfunc_call_test_pass_ctx(skb);
+	bpf_kfunc_call_test_pass1(&p1);
+	bpf_kfunc_call_test_pass2(&p2);
+
+	bpf_kfunc_call_test_mem_len_pass1(&a, sizeof(a));
+	bpf_kfunc_call_test_mem_len_pass1(&b, sizeof(b));
+	bpf_kfunc_call_test_mem_len_pass1(&c, sizeof(c));
+	bpf_kfunc_call_test_mem_len_pass1(&d, sizeof(d));
+	bpf_kfunc_call_test_mem_len_pass1(&e, sizeof(e));
+	bpf_kfunc_call_test_mem_len_fail2(&b, -1);
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
new file mode 100644
index 000000000000..4088000dcfc0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail1.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_fail1(struct prog_test_fail1 *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail1(struct __sk_buff *skb)
+{
+	struct prog_test_fail1 s = {};
+
+	bpf_kfunc_call_test_fail1(&s);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
new file mode 100644
index 000000000000..0c9779693576
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail2.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_fail2(struct prog_test_fail2 *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail2(struct __sk_buff *skb)
+{
+	struct prog_test_fail2 s = {};
+
+	bpf_kfunc_call_test_fail2(&s);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
new file mode 100644
index 000000000000..4e5a7493cdf7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail3.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_fail3(struct prog_test_fail3 *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail3(struct __sk_buff *skb)
+{
+	struct prog_test_fail3 s = {};
+
+	bpf_kfunc_call_test_fail3(&s);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
new file mode 100644
index 000000000000..01c3523c7c50
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail4.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail4(struct __sk_buff *skb)
+{
+	struct __sk_buff local_skb = {};
+
+	bpf_kfunc_call_test_pass_ctx(&local_skb);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
new file mode 100644
index 000000000000..e32f13709357
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail5.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail5(struct __sk_buff *skb)
+{
+	int a = 0;
+
+	bpf_kfunc_call_test_mem_len_fail1(&a, sizeof(a));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
new file mode 100644
index 000000000000..998626aaca35
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail6.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail6(struct __sk_buff *skb)
+{
+	int a = 0;
+
+	bpf_kfunc_call_test_mem_len_fail2((void *)&a, sizeof(a));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
new file mode 100644
index 000000000000..05d4914b0533
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail7.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail7(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *p, *p2;
+	unsigned long sp = 0;
+
+	p = bpf_kfunc_call_test_acquire(&sp);
+	if (p) {
+		p2 = p->next->next;
+		bpf_kfunc_call_test_release(p);
+		if (p2->a == 42)
+			return 1;
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c
new file mode 100644
index 000000000000..eac8637ce841
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test_fail8.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+
+SEC("tc")
+int kfunc_call_test_fail8(struct __sk_buff *skb)
+{
+	struct prog_test_ref_kfunc *p, *p2;
+	unsigned long sp = 0;
+
+	p = bpf_kfunc_call_test_acquire(&sp);
+	if (p) {
+		p2 = p->next->next;
+		bpf_kfunc_call_test_release(p2);
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

