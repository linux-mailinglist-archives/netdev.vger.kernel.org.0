Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF01216B649
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYAJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:09:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45518 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728316AbgBYAJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:09:00 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01P04V6O005386
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 16:08:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PXmrFmdduNTeIAvS5jq1Y+6K8sKhpZ6nQsDc9FUuiG0=;
 b=bNnMRzt9Jg1/UzbfZaLvK6UA52ZlcNyC0KSYW5d5BkEd5vW1S4MWIU2puKxnGZfxwuAi
 42FkOPVQntxWepnyY5q/XGP+VfQCDjRgjfu5jHgLiSLpy2H89akvPtFq5OqOYLDyaEEv
 GCzfIxbrscsMe2w3tax+8fQZImFgQfbPb2k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2yb0p5k4t1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 16:08:58 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 24 Feb 2020 16:08:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1FC2C2EC2ED2; Mon, 24 Feb 2020 16:08:52 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] selftests/bpf: print backtrace on SIGSEGV in test_progs
Date:   Mon, 24 Feb 2020 16:08:47 -0800
Message-ID: <20200225000847.3965188-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_12:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 mlxlogscore=939 suspectscore=8
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to various bugs in tests clean up code (usually), if host system is
misconfigured, it happens that test_progs will just crash in the middle of
running a test with little to no indication of where and why the crash
happened. For cases where coredump is not readily available (e.g., inside
a CI), it's very helpful to have a stack trace, which lead to crash, to be
printed out. This change adds a signal handler that will capture and print out
symbolized backtrace:

  $ sudo ./test_progs -t mmap
  test_mmap:PASS:skel_open_and_load 0 nsec
  test_mmap:PASS:bss_mmap 0 nsec
  test_mmap:PASS:data_mmap 0 nsec
  Caught signal #11!
  Stack trace:
  ./test_progs(crash_handler+0x18)[0x42a888]
  /lib64/libpthread.so.0(+0xf5d0)[0x7f2aab5175d0]
  ./test_progs(test_mmap+0x3c0)[0x41f0a0]
  ./test_progs(main+0x160)[0x407d10]
  /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2aab15d3d5]
  ./test_progs[0x407ebc]
  [1]    1988412 segmentation fault (core dumped)  sudo ./test_progs -t mmap

Unfortunately, glibc's symbolization support is unable to symbolize static
functions, only global ones will be present in stack trace. But it's still a
step forward without adding extra libraries to get a better symbolization.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile     |  2 +-
 tools/testing/selftests/bpf/test_progs.c | 25 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2a583196fa51..50c63c21e6fd 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -20,7 +20,7 @@ CLANG		?= clang
 LLC		?= llc
 LLVM_OBJCOPY	?= llvm-objcopy
 BPF_GCC		?= $(shell command -v bpf-gcc;)
-CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)		\
+CFLAGS += -g -rdynamic -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)	\
 	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)	\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index bab1e6f1d8f1..a969c77e9456 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -6,6 +6,8 @@
 #include "bpf_rlimit.h"
 #include <argp.h>
 #include <string.h>
+#include <signal.h>
+#include <execinfo.h> /* backtrace */
 
 /* defined in test_progs.h */
 struct test_env env = {};
@@ -617,6 +619,23 @@ int cd_flavor_subdir(const char *exec_name)
 	return chdir(flavor);
 }
 
+#define MAX_BACKTRACE_SZ 128
+void crash_handler(int signum)
+{
+	void *bt[MAX_BACKTRACE_SZ];
+	size_t sz;
+
+	sz = backtrace(bt, ARRAY_SIZE(bt));
+
+	if (env.test)
+		dump_test_log(env.test, true);
+	if (env.stdout)
+		stdio_restore();
+
+	fprintf(stderr, "Caught signal #%d!\nStack trace:\n", signum);
+	backtrace_symbols_fd(bt, sz, STDERR_FILENO);
+}
+
 int main(int argc, char **argv)
 {
 	static const struct argp argp = {
@@ -624,8 +643,14 @@ int main(int argc, char **argv)
 		.parser = parse_arg,
 		.doc = argp_program_doc,
 	};
+	struct sigaction sigact = {
+		.sa_handler = crash_handler,
+		.sa_flags = SA_RESETHAND,
+	};
 	int err, i;
 
+	sigaction(SIGSEGV, &sigact, NULL);
+
 	err = argp_parse(&argp, argc, argv, 0, NULL, &env);
 	if (err)
 		return err;
-- 
2.17.1

