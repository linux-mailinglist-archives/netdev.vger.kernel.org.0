Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593D3180C50
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCJX1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:27:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45320 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCJX1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:27:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id b22so143559pls.12;
        Tue, 10 Mar 2020 16:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peXRszGQ9ub4EllYL7YFPHJ6/2kzb3lV1zgfrv0MSRs=;
        b=vdu6R9ZpL7xpJzaChn4ZndEqZAPSoC6lQG9wSXzRd+YkV34lU1LrbQvsJq/obmS+Ex
         cAYLFImp6LaIaqt/TlM4mjHQAxLy3uUouWwbLDi2dN1zfwSL62nXsVl79b7qVamwnpLs
         L03vx9/qC4gxmk5B698YU1xLCsX6UlCCB7zkHY3hKldD67+r1FS/FAi3X8xfdn7osppK
         XBFx54qeJQQbIX6xCCQlT+4uZqAAZyqPpkQyJFK+qaTV845A3r4bR3RtVm+ZDHlg5GOU
         pghOxOrQzhrsh89Wvx4mHAF6V/ASvHYt+mwq4Ec709hkqLkv6xpUUHKLI3v+f8nOKwwi
         mNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peXRszGQ9ub4EllYL7YFPHJ6/2kzb3lV1zgfrv0MSRs=;
        b=j2fxpCnkDFbLh70k6CVoEHO/2nBI5jWcmpDWag+n/BHkIY4P/w9NIT0+gzntgJVqKs
         2rEsxmSd5rgITy13gkIuIO19SWqeXr8//56wdP4+XLC1FDbGoVkMOSTZ+5JD4BevWNia
         RXS2dYsA9u8Crrw9S569bZBE/wHvrekd1tbaRhzGoPL8Y1QX/xuyWvj4ia1CewC9oC+e
         wgg8VFtCmC2WPB9d/a3SW9ssomtCR4KsO1/85MVNf4m+FP3gnPiBud6jV2x8rhQ3ep08
         7mCN0BDxFUSK7pj3zNipWKstC1C5lCyICIaiGkm3IKAZTa1qk3PlgqECXoLvMfJbIHIv
         KKFg==
X-Gm-Message-State: ANhLgQ0xg7gtHlVNPNi5CXrC8Gy6mQsgPRi0LJ7t29wJ+b6xB8Lni0MT
        OXk/rsM+ji5+DkKseV6g5g==
X-Google-Smtp-Source: ADFU+vuoToAtDboZLGBbrb3IraG3v8bqhrcr+ih+pRspGdkJth/fOSmzdNcupiyF52+8Vgvp29D7RA==
X-Received: by 2002:a17:90a:f487:: with SMTP id bx7mr341142pjb.107.1583882826630;
        Tue, 10 Mar 2020 16:27:06 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id x6sm48263668pfi.83.2020.03.10.16.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 16:27:06 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] samples: bpf: move read_trace_pipe to trace_helpers
Date:   Wed, 11 Mar 2020 08:26:46 +0900
Message-Id: <20200310232647.27777-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310232647.27777-1-danieltimlee@gmail.com>
References: <20200310232647.27777-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reduce the reliance of trace samples (trace*_user) on bpf_load,
move read_trace_pipe to trace_helpers. By moving this bpf_loader helper
elsewhere, trace functions can be easily migrated to libbbpf.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile                        |  4 ++--
 samples/bpf/bpf_load.c                      | 20 ------------------
 samples/bpf/bpf_load.h                      |  1 -
 samples/bpf/tracex1_user.c                  |  1 +
 samples/bpf/tracex5_user.c                  |  1 +
 tools/testing/selftests/bpf/trace_helpers.c | 23 +++++++++++++++++++++
 tools/testing/selftests/bpf/trace_helpers.h |  1 +
 7 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 79b0fee6943b..ff0061467dd3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -64,11 +64,11 @@ fds_example-objs := fds_example.o
 sockex1-objs := sockex1_user.o
 sockex2-objs := sockex2_user.o
 sockex3-objs := bpf_load.o sockex3_user.o
-tracex1-objs := bpf_load.o tracex1_user.o
+tracex1-objs := bpf_load.o tracex1_user.o $(TRACE_HELPERS)
 tracex2-objs := bpf_load.o tracex2_user.o
 tracex3-objs := bpf_load.o tracex3_user.o
 tracex4-objs := bpf_load.o tracex4_user.o
-tracex5-objs := bpf_load.o tracex5_user.o
+tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
 tracex6-objs := bpf_load.o tracex6_user.o
 tracex7-objs := bpf_load.o tracex7_user.o
 test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 4574b1939e49..c5ad528f046e 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -665,23 +665,3 @@ int load_bpf_file_fixup_map(const char *path, fixup_map_cb fixup_map)
 {
 	return do_load_bpf_file(path, fixup_map);
 }
-
-void read_trace_pipe(void)
-{
-	int trace_fd;
-
-	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
-	if (trace_fd < 0)
-		return;
-
-	while (1) {
-		static char buf[4096];
-		ssize_t sz;
-
-		sz = read(trace_fd, buf, sizeof(buf) - 1);
-		if (sz > 0) {
-			buf[sz] = 0;
-			puts(buf);
-		}
-	}
-}
diff --git a/samples/bpf/bpf_load.h b/samples/bpf/bpf_load.h
index 814894a12974..4fcd258c616f 100644
--- a/samples/bpf/bpf_load.h
+++ b/samples/bpf/bpf_load.h
@@ -53,6 +53,5 @@ extern int map_data_count;
 int load_bpf_file(char *path);
 int load_bpf_file_fixup_map(const char *path, fixup_map_cb fixup_map);
 
-void read_trace_pipe(void);
 int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 #endif
diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
index af8c20608ab5..55fddbd08702 100644
--- a/samples/bpf/tracex1_user.c
+++ b/samples/bpf/tracex1_user.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <bpf/bpf.h>
 #include "bpf_load.h"
+#include "trace_helpers.h"
 
 int main(int ac, char **argv)
 {
diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index c4ab91c89494..c2317b39e0d2 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -8,6 +8,7 @@
 #include <bpf/bpf.h>
 #include "bpf_load.h"
 #include <sys/resource.h>
+#include "trace_helpers.h"
 
 /* install fake seccomp program to enable seccomp code path inside the kernel,
  * so that our kprobe attached to seccomp_phase1() can be triggered
diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 7f989b3e4e22..4d0e913bbb22 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -4,12 +4,15 @@
 #include <string.h>
 #include <assert.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <poll.h>
 #include <unistd.h>
 #include <linux/perf_event.h>
 #include <sys/mman.h>
 #include "trace_helpers.h"
 
+#define DEBUGFS "/sys/kernel/debug/tracing/"
+
 #define MAX_SYMS 300000
 static struct ksym syms[MAX_SYMS];
 static int sym_cnt;
@@ -86,3 +89,23 @@ long ksym_get_addr(const char *name)
 
 	return 0;
 }
+
+void read_trace_pipe(void)
+{
+	int trace_fd;
+
+	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
+	if (trace_fd < 0)
+		return;
+
+	while (1) {
+		static char buf[4096];
+		ssize_t sz;
+
+		sz = read(trace_fd, buf, sizeof(buf) - 1);
+		if (sz > 0) {
+			buf[sz] = 0;
+			puts(buf);
+		}
+	}
+}
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 0383c9b8adc1..25ef597dd03f 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -12,5 +12,6 @@ struct ksym {
 int load_kallsyms(void);
 struct ksym *ksym_search(long key);
 long ksym_get_addr(const char *name);
+void read_trace_pipe(void);
 
 #endif
-- 
2.25.1

