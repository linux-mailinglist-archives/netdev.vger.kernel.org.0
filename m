Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AAA18463A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCMLwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:52:49 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34375 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgCMLws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 07:52:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id a23so4162667plm.1;
        Fri, 13 Mar 2020 04:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peXRszGQ9ub4EllYL7YFPHJ6/2kzb3lV1zgfrv0MSRs=;
        b=XTtCLYmBjHJZnr21HNDiLbYTClCG44cED09uNRsZGyhP2Hjdd3Kd5SY+c7VUz9+ImF
         /2mHjYFzZVQtpDm+P7ieti6U8WBkz+1ko0UwQb+t1Oy5NY8Z7l3rTCzowY2W0L00z9Td
         iSe4IR+6EsHeZ8oeLlO+7fSadaTDDWtpGU3U/9k7lW1idfnVKMzLURn3rsij/Z7UQMbT
         TSAV/kAJOWYkjCtkU14JNHjW9YpdRKlTKXoWP1VkS71OgHbp7D29iFcz/7AjpmzTFzIY
         wAsghhYM5mYwL9B0cVvFNa00+ummKFs2mY3pOO91Pa9bVMM9We+dhZe6+NeDA4adJ3Wm
         sMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peXRszGQ9ub4EllYL7YFPHJ6/2kzb3lV1zgfrv0MSRs=;
        b=jwiEUu9ShpviRdQsK0mahmPV80UWldpEMrRKVogtljyUmhd83h0iH47Q6m1TkN05up
         um/WiaE4xCZGZUI+5GP0Qbfs4GcMEw/dnOFU/wnrzhp33ubBHIS7dLw388ubftkZ1E/C
         hktQEbLP/ZHL65Pi/rz0K4tBfxUjIjCw/o0fLV7ItyWm5n7zoIGLDvuwV+UQEihjCsLk
         te+OLQe4C01c6FSPsr19pj8FO9xBpOhkTeKR1Wx59h2txhEWj5UVBXpYyHRs8LixFHC+
         RvLcp0ue1VhhgbhRK/CU8wmSX8EUspGEeuDmgyrMAWRiN8vS6F2VNM0UQB865f/S/kB6
         KKeg==
X-Gm-Message-State: ANhLgQ34llZih+KoUIZjM/GJtDGZlk20zKhKhgQwwfkWXp6xpWSCRVyv
        sFMBS5Zz7syWLTKS5d6N2qpBcIHwuk+y
X-Google-Smtp-Source: ADFU+vtLkbLJQOFV5WdFlErAFLlEI7AMicmBru1FjdIIzJe2WOVNSN5IEQrDsZbeoRseju+sFNiPTA==
X-Received: by 2002:a17:90b:1b02:: with SMTP id nu2mr2914435pjb.95.1584100367614;
        Fri, 13 Mar 2020 04:52:47 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id r14sm2095151pjj.48.2020.03.13.04.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 04:52:47 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 1/2] samples: bpf: move read_trace_pipe to trace_helpers
Date:   Fri, 13 Mar 2020 20:52:19 +0900
Message-Id: <20200313115220.29073-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313115220.29073-1-danieltimlee@gmail.com>
References: <20200313115220.29073-1-danieltimlee@gmail.com>
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

