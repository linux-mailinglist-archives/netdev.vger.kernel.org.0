Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983462B680D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgKQO5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQO5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:57:54 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BA8C0613CF;
        Tue, 17 Nov 2020 06:57:55 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t21so9901117pgl.3;
        Tue, 17 Nov 2020 06:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PeoKjE8j2dFMR1kqxaR6xNCamdYb7FZPc33+GS2rYtg=;
        b=jiR8iPn0UyL9pgHx2VQogZDXZcd5l7Dsdkn+sa597/wnFtBbtRAUWLOk+eUNAf7WGe
         fVRIPk03oTsHgph7rRcQzYOUPvo/ZrqN2u2fojsc7x5OtfFc0ZCysQVwogMhYruWNNR2
         srxWfwnIn3hV/7J9kZ3bnEisro6XZGa/v740iftKJ2sNk9Djn/huIq1QPqb/X0s4+0wD
         T0KEiWEscSyeZJ/VDHHxM1D6Gaj489EbkWjgQKBka2seKUdj3RNJSU/FSzenaFKlc6Tq
         LnxsgDYkPlERZ62pXRrCtbEmPlsMWE1lxn76RoVDQmuEGN/IoJY6Be0PXWdq3uX5+dZN
         FUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PeoKjE8j2dFMR1kqxaR6xNCamdYb7FZPc33+GS2rYtg=;
        b=ML9/7K4AsBrcNok7HTqf0sGGu3wcGgHi/hxAdLTqBTN+x079pvW4NrSIoxQeXRxO/s
         oligL3Dj64ThXpb7iPMV9UzuZ9TVeYCscwneFeeRvpjMw6Z5jfmJKprircngrrYzZN+D
         wSSTjhsbz7IvUMmEIYSvkasTtmoqh0gezxbCWZtaXxdiqifzco+9F3vdY7RC3RAUi/JG
         KnfcTkb6798AWYHT4YHi71BFEbw3guTrgKtwRnGoYQuY61uOFIt4CcT2ovLiH6uyEJjB
         Lj8XMIg+Rq2+Zt6rWOM+kMrpPnLVsdodnK8lzLoLvHJh/ZyoGoVReCFCXDtNP08HbJku
         gKCg==
X-Gm-Message-State: AOAM530yuejbvASXGXd5yYFEgdLY5KMOGq1rzi2KKUHE4F/fOf//VPfP
        DUhpLf3K9khQ+HmOIP4s2A==
X-Google-Smtp-Source: ABdhPJzDcYQajCn7UHoOFr2GrBgy2Cxbo6nWoOL7bUPxg0bu1rEGM/NFyMHbZICSmqgnHJ9MZOyNHA==
X-Received: by 2002:a63:1514:: with SMTP id v20mr3983735pgl.203.1605625074602;
        Tue, 17 Nov 2020 06:57:54 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:54 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 6/9] samples: bpf: refactor test_overhead program with libbpf
Date:   Tue, 17 Nov 2020 14:56:41 +0000
Message-Id: <20201117145644.1166255-7-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the existing program with libbpf bpf loader.
Since the kprobe, tracepoint and raw_tracepoint bpf program can be
attached with single bpf_program__attach() interface, so the
corresponding function of libbpf is used here.

Rather than specifying the number of cpus inside the code, this commit
uses the number of available cpus with _SC_NPROCESSORS_ONLN.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile             |  2 +-
 samples/bpf/test_overhead_user.c | 82 +++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index bfa595379493..16d9d68e1e01 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -78,7 +78,7 @@ lathist-objs := lathist_user.o
 offwaketime-objs := offwaketime_user.o $(TRACE_HELPERS)
 spintest-objs := spintest_user.o $(TRACE_HELPERS)
 map_perf_test-objs := map_perf_test_user.o
-test_overhead-objs := bpf_load.o test_overhead_user.o
+test_overhead-objs := test_overhead_user.o
 test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
 test_cgrp2_attach-objs := test_cgrp2_attach.o
 test_cgrp2_sock-objs := test_cgrp2_sock.o
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead_user.c
index 94f74112a20e..e4de268d5c9e 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -18,10 +18,14 @@
 #include <time.h>
 #include <sys/resource.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 
 #define MAX_CNT 1000000
 
+struct bpf_link *links[2] = {};
+struct bpf_object *obj;
+static int cnt;
+
 static __u64 time_get_ns(void)
 {
 	struct timespec ts;
@@ -115,20 +119,54 @@ static void run_perf_test(int tasks, int flags)
 	}
 }
 
+static int load_progs(char *filename)
+{
+	struct bpf_program *prog;
+	int err = 0;
+
+	obj = bpf_object__open_file(filename, NULL);
+	err = libbpf_get_error(obj);
+	if (err < 0) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return err;
+	}
+
+	/* load BPF program */
+	err = bpf_object__load(obj);
+	if (err < 0) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		return err;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		links[cnt] = bpf_program__attach(prog);
+		err = libbpf_get_error(links[cnt]);
+		if (err < 0) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[cnt] = NULL;
+			return err;
+		}
+		cnt++;
+	}
+
+	return err;
+}
+
 static void unload_progs(void)
 {
-	close(prog_fd[0]);
-	close(prog_fd[1]);
-	close(event_fd[0]);
-	close(event_fd[1]);
+	while (cnt)
+		bpf_link__destroy(links[--cnt]);
+
+	bpf_object__close(obj);
 }
 
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
-	char filename[256];
-	int num_cpu = 8;
+	int num_cpu = sysconf(_SC_NPROCESSORS_ONLN);
 	int test_flags = ~0;
+	char filename[256];
+	int err = 0;
 
 	setrlimit(RLIMIT_MEMLOCK, &r);
 
@@ -145,38 +183,36 @@ int main(int argc, char **argv)
 	if (test_flags & 0xC) {
 		snprintf(filename, sizeof(filename),
 			 "%s_kprobe_kern.o", argv[0]);
-		if (load_bpf_file(filename)) {
-			printf("%s", bpf_log_buf);
-			return 1;
-		}
+
 		printf("w/KPROBE\n");
-		run_perf_test(num_cpu, test_flags >> 2);
+		err = load_progs(filename);
+		if (!err)
+			run_perf_test(num_cpu, test_flags >> 2);
+
 		unload_progs();
 	}
 
 	if (test_flags & 0x30) {
 		snprintf(filename, sizeof(filename),
 			 "%s_tp_kern.o", argv[0]);
-		if (load_bpf_file(filename)) {
-			printf("%s", bpf_log_buf);
-			return 1;
-		}
 		printf("w/TRACEPOINT\n");
-		run_perf_test(num_cpu, test_flags >> 4);
+		err = load_progs(filename);
+		if (!err)
+			run_perf_test(num_cpu, test_flags >> 4);
+
 		unload_progs();
 	}
 
 	if (test_flags & 0xC0) {
 		snprintf(filename, sizeof(filename),
 			 "%s_raw_tp_kern.o", argv[0]);
-		if (load_bpf_file(filename)) {
-			printf("%s", bpf_log_buf);
-			return 1;
-		}
 		printf("w/RAW_TRACEPOINT\n");
-		run_perf_test(num_cpu, test_flags >> 6);
+		err = load_progs(filename);
+		if (!err)
+			run_perf_test(num_cpu, test_flags >> 6);
+
 		unload_progs();
 	}
 
-	return 0;
+	return err;
 }
-- 
2.25.1

