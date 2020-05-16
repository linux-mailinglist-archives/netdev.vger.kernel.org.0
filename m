Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C711D5E67
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgEPEGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbgEPEGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:06:24 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A964C061A0C;
        Fri, 15 May 2020 21:06:24 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so1746527plt.5;
        Fri, 15 May 2020 21:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=69tjF3a4OFKCsc0Suj1Ize0A/9vk7YvpZYxYpPATVNs=;
        b=A+ygEkPloDrKoJCbM8DKJgnCFvm9fajsnVBtAWe6Rz8rR2EhInvupAHU5JqD1e2u6k
         26gp8ZTeH8CuyDDbouJhGdJOcGGnkBAMSQtjzMd1bSIs52HktBhrEaA9nRejTh6I6N5J
         pmmGW/zK9L6P7qth8JMuAIP2SmqBhZrfXDrmyJnPQF6q2unYybJrFKJSvzbAwff5h+0A
         vEd9aAXky4CHRMXxYMqC6tt/Kn20GckLjLmr4ToX5B5zHHsUo0sUEAPdy7hEZC2r6Ldq
         W3zIvdogKJsF3EAeBC7erFJegn8oYTaRm/KBMi3/DvM2XmPFZGlh6+aLgG+YfQOgQxNE
         ZPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=69tjF3a4OFKCsc0Suj1Ize0A/9vk7YvpZYxYpPATVNs=;
        b=jaw/E8kYGd5VjUp1C4RwAw/b24zu882ovJRnJ6IAY8bEzbXu9bVmLIRIsI/KMO+BxZ
         qMm9LX0yK8vbS3p7Vd7FTLwewWBMJVp+zKraiKrFXpkA14+/H/WOrZj+C4fmvQt0XIER
         ab5RVOpQhauTca7n0lrAT4ZHcCWQ8ECmEL0nwOHUQonsCxoa1Xg3Lg2Su01iApk5AfnG
         cm+xJCpSYQOJJ+/KdGt7Bg44+f163BwOaK3jUcSzl1Nz1Jb8DXZ353SbIjlOQiVSza7e
         CQys5uFcghmfqi8uu4Gdj3bft50PHIvFEAGjmq7l3qTB2Z81uN/zzuOFpwV3D3vd5Gyq
         oDEg==
X-Gm-Message-State: AOAM5331vr8STKSF9zXxcqgnOqRl9JBEl/Uvq4nQ1+yPPJEHMkLP3Gpo
        oyHomlCzeGYs9joeKmhFNA==
X-Google-Smtp-Source: ABdhPJxKqIaVXSk0PawNtkWfsQ7uHPGxZwQJeJ83CRxcqvqLtIt/lWeg8vP6x1SBFukAK0lhPc+nQw==
X-Received: by 2002:a17:90a:7f83:: with SMTP id m3mr7301561pjl.147.1589601983761;
        Fri, 15 May 2020 21:06:23 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id b11sm98663pjz.54.2020.05.15.21.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 21:06:23 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 3/5] samples: bpf: refactor tail call user progs with libbpf
Date:   Sat, 16 May 2020 13:06:06 +0900
Message-Id: <20200516040608.1377876-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516040608.1377876-1-danieltimlee@gmail.com>
References: <20200516040608.1377876-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF tail call uses the BPF_MAP_TYPE_PROG_ARRAY type map for calling
into other BPF programs and this PROG_ARRAY should be filled prior to
use. Currently, samples with the PROG_ARRAY type MAP fill this program
array with bpf_load. For bpf_load to fill this map, kernel BPF program
must specify the section with specific format of <prog_type>/<array_idx>
(e.g. SEC("socket/0"))

But by using libbpf instead of bpf_load, user program can specify which
programs should be added to PROG_ARRAY. The advantage of this approach
is that you can selectively add only the programs you want, rather than
adding all of them to PROG_ARRAY, and it's much more intuitive than the
traditional approach.

This commit refactors user programs with the PROG_ARRAY type MAP with
libbpf instead of using bpf_load.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in V2:
 - refactor pointer error check with libbpf_get_error
 - on bpf object open failure, return instead jump to cleanup

 samples/bpf/Makefile       |  4 +--
 samples/bpf/sockex3_user.c | 64 ++++++++++++++++++++++++------------
 samples/bpf/tracex5_user.c | 66 +++++++++++++++++++++++++++++++++-----
 3 files changed, 103 insertions(+), 31 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4c91e5914329..8403e4762306 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -63,12 +63,12 @@ TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
 fds_example-objs := fds_example.o
 sockex1-objs := sockex1_user.o
 sockex2-objs := sockex2_user.o
-sockex3-objs := bpf_load.o sockex3_user.o
+sockex3-objs := sockex3_user.o
 tracex1-objs := tracex1_user.o $(TRACE_HELPERS)
 tracex2-objs := tracex2_user.o
 tracex3-objs := tracex3_user.o
 tracex4-objs := tracex4_user.o
-tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
+tracex5-objs := tracex5_user.o $(TRACE_HELPERS)
 tracex6-objs := tracex6_user.o
 tracex7-objs := tracex7_user.o
 test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
diff --git a/samples/bpf/sockex3_user.c b/samples/bpf/sockex3_user.c
index bbb1cd0666a9..4dbee7427d47 100644
--- a/samples/bpf/sockex3_user.c
+++ b/samples/bpf/sockex3_user.c
@@ -1,18 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
 #include <assert.h>
-#include <linux/bpf.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <sys/resource.h>
 
-#define PARSE_IP 3
-#define PARSE_IP_PROG_FD (prog_fd[0])
-#define PROG_ARRAY_FD (map_fd[0])
-
 struct flow_key_record {
 	__be32 src;
 	__be32 dst;
@@ -30,31 +25,55 @@ struct pair {
 
 int main(int argc, char **argv)
 {
+	int i, sock, key, fd, main_prog_fd, jmp_table_fd, hash_map_fd;
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
+	const char *title;
 	FILE *f;
-	int i, sock, err, id, key = PARSE_IP;
-	struct bpf_prog_info info = {};
-	uint32_t info_len = sizeof(info);
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	setrlimit(RLIMIT_MEMLOCK, &r);
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	jmp_table_fd = bpf_object__find_map_fd_by_name(obj, "jmp_table");
+	hash_map_fd = bpf_object__find_map_fd_by_name(obj, "hash_map");
+	if (jmp_table_fd < 0 || hash_map_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
 	}
 
-	/* Test fd array lookup which returns the id of the bpf_prog */
-	err = bpf_obj_get_info_by_fd(PARSE_IP_PROG_FD, &info, &info_len);
-	assert(!err);
-	err = bpf_map_lookup_elem(PROG_ARRAY_FD, &key, &id);
-	assert(!err);
-	assert(id == info.id);
+	bpf_object__for_each_program(prog, obj) {
+		fd = bpf_program__fd(prog);
+
+		title = bpf_program__title(prog, false);
+		if (sscanf(title, "socket/%d", &key) != 1) {
+			fprintf(stderr, "ERROR: finding prog failed\n");
+			goto cleanup;
+		}
+
+		if (key == 0)
+			main_prog_fd = fd;
+		else
+			bpf_map_update_elem(jmp_table_fd, &key, &fd, BPF_ANY);
+	}
 
 	sock = open_raw_sock("lo");
 
-	assert(setsockopt(sock, SOL_SOCKET, SO_ATTACH_BPF, &prog_fd[4],
+	/* attach BPF program to socket */
+	assert(setsockopt(sock, SOL_SOCKET, SO_ATTACH_BPF, &main_prog_fd,
 			  sizeof(__u32)) == 0);
 
 	if (argc > 1)
@@ -69,8 +88,8 @@ int main(int argc, char **argv)
 
 		sleep(1);
 		printf("IP     src.port -> dst.port               bytes      packets\n");
-		while (bpf_map_get_next_key(map_fd[2], &key, &next_key) == 0) {
-			bpf_map_lookup_elem(map_fd[2], &next_key, &value);
+		while (bpf_map_get_next_key(hash_map_fd, &key, &next_key) == 0) {
+			bpf_map_lookup_elem(hash_map_fd, &next_key, &value);
 			printf("%s.%05d -> %s.%05d %12lld %12lld\n",
 			       inet_ntoa((struct in_addr){htonl(next_key.src)}),
 			       next_key.port16[0],
@@ -80,5 +99,8 @@ int main(int argc, char **argv)
 			key = next_key;
 		}
 	}
+
+cleanup:
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index c2317b39e0d2..98dad57a96c4 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -1,15 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdio.h>
-#include <linux/bpf.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <linux/filter.h>
 #include <linux/seccomp.h>
 #include <sys/prctl.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include <sys/resource.h>
 #include "trace_helpers.h"
 
+#ifdef __mips__
+#define	MAX_ENTRIES  6000 /* MIPS n64 syscalls start at 5000 */
+#else
+#define	MAX_ENTRIES  1024
+#endif
+
 /* install fake seccomp program to enable seccomp code path inside the kernel,
  * so that our kprobe attached to seccomp_phase1() can be triggered
  */
@@ -28,16 +34,57 @@ static void install_accept_all_seccomp(void)
 
 int main(int ac, char **argv)
 {
-	FILE *f;
-	char filename[256];
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int key, fd, progs_fd;
+	char filename[256];
+	const char *title;
+	FILE *f;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	setrlimit(RLIMIT_MEMLOCK, &r);
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
+
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (!prog) {
+		printf("finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	link = bpf_program__attach(prog);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
+	}
+
+	progs_fd = bpf_object__find_map_fd_by_name(obj, "progs");
+	if (progs_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		title = bpf_program__title(prog, false);
+		/* register only syscalls to PROG_ARRAY */
+		if (sscanf(title, "kprobe/%d", &key) != 1)
+			continue;
+
+		fd = bpf_program__fd(prog);
+		bpf_map_update_elem(progs_fd, &key, &fd, BPF_ANY);
 	}
 
 	install_accept_all_seccomp();
@@ -47,5 +94,8 @@ int main(int ac, char **argv)
 
 	read_trace_pipe();
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return 0;
 }
-- 
2.25.1

