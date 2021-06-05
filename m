Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FD339C7D9
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhFELNh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:37 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:48054 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230403AbhFELNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:31 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-iW_eKBkEOEmHtfj0-I_cIg-1; Sat, 05 Jun 2021 07:11:41 -0400
X-MC-Unique: iW_eKBkEOEmHtfj0-I_cIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74AA4803622;
        Sat,  5 Jun 2021 11:11:39 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA2D6614FD;
        Sat,  5 Jun 2021 11:11:36 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 19/19] selftests/bpf: Temporary fix for fentry_fexit_multi_test
Date:   Sat,  5 Jun 2021 13:10:34 +0200
Message-Id: <20210605111034.1810858-20-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multi_arg_check is used from 2 different places I'm getting
compilation fail, which I did not deciphered yet:

  $ CLANG=/opt/clang/bin/clang LLC=/opt/clang/bin/llc make
    CLNG-BPF [test_maps] fentry_fexit_multi_test.o
  progs/fentry_fexit_multi_test.c:18:2: error: too many args to t24: i64 = \
  GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
  progs/fentry_fexit_multi_test.c:18:2 @[ progs/fentry_fexit_multi_test.c:16:5 ]
          multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
          ^
  progs/fentry_fexit_multi_test.c:25:2: error: too many args to t32: i64 = \
  GlobalAddress<void (i64, i64, i64, i64, i64, i64, i64, i64*)* @multi_arg_check> 0, \
  progs/fentry_fexit_multi_test.c:25:2 @[ progs/fentry_fexit_multi_test.c:23:5 ]
          multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
          ^
  In file included from progs/fentry_fexit_multi_test.c:5:
  /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
  void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
       ^
  /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
  /home/jolsa/linux-qemu/tools/testing/selftests/bpf/multi_check.h:9:6: error: defined with too many args
  5 errors generated.
  make: *** [Makefile:470: /home/jolsa/linux-qemu/tools/testing/selftests/bpf/fentry_fexit_multi_test.o] Error 1

As a temporary fix adding 2 instaces of multi_arg_check
function, one for each caller.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/multi_check.h     | 41 ++++++++++---------
 .../bpf/progs/fentry_fexit_multi_test.c       |  7 +++-
 .../selftests/bpf/progs/fentry_multi_test.c   |  4 +-
 .../selftests/bpf/progs/fexit_multi_test.c    |  4 +-
 4 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/bpf/multi_check.h b/tools/testing/selftests/bpf/multi_check.h
index 36c2a93f9be3..f720a6f9c6e4 100644
--- a/tools/testing/selftests/bpf/multi_check.h
+++ b/tools/testing/selftests/bpf/multi_check.h
@@ -5,26 +5,27 @@
 
 extern unsigned long long bpf_fentry_test[8];
 
-static __attribute__((unused)) inline
-void multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)
-{
-	if (ip == bpf_fentry_test[0]) {
-		*test_result += (int) a == 1;
-	} else if (ip == bpf_fentry_test[1]) {
-		*test_result += (int) a == 2 && (__u64) b == 3;
-	} else if (ip == bpf_fentry_test[2]) {
-		*test_result += (char) a == 4 && (int) b == 5 && (__u64) c == 6;
-	} else if (ip == bpf_fentry_test[3]) {
-		*test_result += (void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;
-	} else if (ip == bpf_fentry_test[4]) {
-		*test_result += (__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;
-	} else if (ip == bpf_fentry_test[5]) {
-		*test_result += (__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;
-	} else if (ip == bpf_fentry_test[6]) {
-		*test_result += 1;
-	} else if (ip == bpf_fentry_test[7]) {
-		*test_result += 1;
-	}
+#define MULTI_ARG_CHECK(_name) \
+static __attribute__((unused)) inline \
+void _name ## _multi_arg_check(unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, __u64 *test_result)						\
+{																					\
+	if (ip == bpf_fentry_test[0]) {																	\
+		*test_result +=	(int) a == 1;																\
+	} else if (ip == bpf_fentry_test[1]) {																\
+		*test_result +=	(int) a == 2 && (__u64) b == 3;														\
+	} else if (ip == bpf_fentry_test[2]) {																\
+		*test_result +=	(char) a == 4 && (int) b == 5 && (__u64) c == 6;											\
+	} else if (ip == bpf_fentry_test[3]) {																\
+		*test_result +=	(void *) a == (void *) 7 && (char) b == 8 && (int) c == 9 && (__u64) d == 10;								\
+	} else if (ip == bpf_fentry_test[4]) {																\
+		*test_result +=	(__u64) a == 11 && (void *) b == (void *) 12 && (short) c == 13 && (int) d == 14 && (__u64) e == 15;					\
+	} else if (ip == bpf_fentry_test[5]) {																\
+		*test_result +=	(__u64) a == 16 && (void *) b == (void *) 17 && (short) c == 18 && (int) d == 19 && (void *) e == (void *) 20 && (__u64) f == 21;	\
+	} else if (ip == bpf_fentry_test[6]) {																\
+		*test_result += 1;																	\
+	} else if (ip == bpf_fentry_test[7]) {																\
+		*test_result += 1;																	\
+	}																				\
 }
 
 static __attribute__((unused)) inline
diff --git a/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
index e25ab0085399..dc5b51f20b84 100644
--- a/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_fexit_multi_test.c
@@ -6,6 +6,9 @@
 
 char _license[] SEC("license") = "GPL";
 
+MULTI_ARG_CHECK(fentry)
+MULTI_ARG_CHECK(fexit)
+
 unsigned long long bpf_fentry_test[8];
 
 __u64 test1_arg_result = 0;
@@ -15,14 +18,14 @@ __u64 test2_ret_result = 0;
 SEC("fentry.multi/bpf_fentry_test*")
 int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
 {
-	multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
+	fentry_multi_arg_check(ip, a, b, c, d, e, f, &test1_arg_result);
 	return 0;
 }
 
 SEC("fexit.multi/")
 int BPF_PROG(test2, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
 {
-	multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
+	fexit_multi_arg_check(ip, a, b, c, d, e, f, &test2_arg_result);
 	multi_ret_check(ip, ret, &test2_ret_result);
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/fentry_multi_test.c b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
index a443fc958e5a..b3a025632e77 100644
--- a/tools/testing/selftests/bpf/progs/fentry_multi_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_multi_test.c
@@ -6,6 +6,8 @@
 
 char _license[] SEC("license") = "GPL";
 
+MULTI_ARG_CHECK(fentry)
+
 unsigned long long bpf_fentry_test[8];
 
 __u64 test_result = 0;
@@ -13,6 +15,6 @@ __u64 test_result = 0;
 SEC("fentry.multi/bpf_fentry_test*")
 int BPF_PROG(test, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
 {
-	multi_arg_check(ip, a, b, c, d, e, f, &test_result);
+	fentry_multi_arg_check(ip, a, b, c, d, e, f, &test_result);
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/fexit_multi_test.c b/tools/testing/selftests/bpf/progs/fexit_multi_test.c
index 365575cf05a0..8af0d65128d6 100644
--- a/tools/testing/selftests/bpf/progs/fexit_multi_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_multi_test.c
@@ -6,6 +6,8 @@
 
 char _license[] SEC("license") = "GPL";
 
+MULTI_ARG_CHECK(fexit)
+
 unsigned long long bpf_fentry_test[8];
 
 __u64 test_arg_result = 0;
@@ -14,7 +16,7 @@ __u64 test_ret_result = 0;
 SEC("fexit.multi/bpf_fentry_test*")
 int BPF_PROG(test, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
 {
-	multi_arg_check(ip, a, b, c, d, e, f, &test_arg_result);
+	fexit_multi_arg_check(ip, a, b, c, d, e, f, &test_arg_result);
 	multi_ret_check(ip, ret, &test_ret_result);
 	return 0;
 }
-- 
2.31.1

