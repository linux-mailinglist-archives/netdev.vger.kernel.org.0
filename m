Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2617AEE3
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 20:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCETVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 14:21:53 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41277 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgCETVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 14:21:53 -0500
Received: by mail-ot1-f68.google.com with SMTP id v19so6864407ote.8
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 11:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sage.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B232Xfl8pPUXhEXTSFr9l2F0YfxzCUYT6YQTqFiZ9d4=;
        b=Dy5ky1HLo+rC4+F3wFsg6eB2LrdhsnMs/ZBoEAVqYoZCqllz4gI4+lb++qA6MDCPj+
         NKxQ9MEog5lGquTKwVMQcNr1quwsdBq1aVWQzJl5h+z9yFPGvrzUOjbGIyJ/GyPV/MDJ
         RNpHWKTNtEDjdyJkasua5HJ/I9adVIVAWVD+VRFXTIpcxEH9fpdb44pgLV+tvVVn4Pxg
         JgJqPlCis398/OSqKlUVBJFWTenHtigpoMytpFFtFObIwRwNyrMglQ9B3XQepAB8zjOX
         nKjHHwFM4kf5ggXnS89VXQJo6UFbPl94b7tuM4LlAu6HFyki2AD3HTbHdjmms6ziofWI
         9qUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B232Xfl8pPUXhEXTSFr9l2F0YfxzCUYT6YQTqFiZ9d4=;
        b=lPaHE8nSBhC6r455uw5x670sAVbv+u+Cf9+WAJT3VtEJWRN5k+WEw8VJEI9FHKsKpT
         XlxC+Se06lQou40aBC9UqMioXlVzWFtf28SdOlHZgIB1uym7L7tFVcbwL+loFzVk2DC+
         TZpCgsxQ5gAIVQrnGkk+syj040RHQoGgx8DTLIegrG/t3/71v24VpFhEV1YsTtWbzPNy
         t+FwLhlBzbSsfG0+PInWGf5N3n/i78qBPMSCHtYn9Yb1VIe7xvCAGk7CtocVPmdzJ5iO
         vhn74/KAsTWJItCiH2gUt0ZAyIVYnjEBXkMykG0zYYaoUgj9C0Xu0I2Gp8T5fXkk9VQZ
         t5Sg==
X-Gm-Message-State: ANhLgQ0CdoDfeuTuVZ36EYVdKM13zloIm+J5wLHZHHjL67BiOf/m/f+N
        tp/0zkcl+xutmt0FxsYtj/j+LA==
X-Google-Smtp-Source: ADFU+vuEVfjFLGoyGPZRpvnh1SMZVlmsqYP+GdVm72kHUi2zVXdwSRXgCLbHOEKdf6ZRlncegOgzaQ==
X-Received: by 2002:a9d:443:: with SMTP id 61mr7246120otc.357.1583436112243;
        Thu, 05 Mar 2020 11:21:52 -0800 (PST)
Received: from tower.attlocal.net ([2600:1700:4a30:fd70::24])
        by smtp.googlemail.com with ESMTPSA id p65sm10281689oif.47.2020.03.05.11.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 11:21:51 -0800 (PST)
From:   Eric Sage <eric@sage.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andriin@fb.com, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, Eric Sage <eric@sage.org>
Subject: [PATCH] [bpf] Make bpf program autoloading optional
Date:   Thu,  5 Mar 2020 11:21:46 -0800
Message-Id: <20200305192146.589093-1-eric@sage.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds bpf_program__set_autoload which can be used to disable loading
a bpf_prog when loading the bpf_object that contains it after the
bpf_object has been opened. This behavior affect calling load directly
and loading through BPF skel. A single flag is added to bpf_prog
to make this work.

Signed-off-by: Eric Sage <eric@sage.org>
---
 tools/lib/bpf/libbpf.c                        |   9 +
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/progs/test_autoload_kern.c  |  24 +++
 tools/testing/selftests/bpf/test_autoload.c   | 158 ++++++++++++++++++
 6 files changed, 199 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_autoload_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_autoload.c

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..fe156ca10d16 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -222,6 +222,7 @@ struct bpf_program {
 	bpf_program_prep_t preprocessor;
 
 	struct bpf_object *obj;
+	bool autoload;
 	void *priv;
 	bpf_program_clear_priv_t clear_priv;
 
@@ -499,6 +500,7 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
 	prog->instances.fds = NULL;
 	prog->instances.nr = -1;
 	prog->type = BPF_PROG_TYPE_UNSPEC;
+	prog->autoload = true;
 
 	return 0;
 errout:
@@ -4933,6 +4935,11 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	return ret;
 }
 
+void bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
+{
+	prog->autoload = autoload;
+}
+
 static int libbpf_find_attach_btf_id(struct bpf_program *prog);
 
 int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
@@ -5030,6 +5037,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	int err;
 
 	for (i = 0; i < obj->nr_programs; i++) {
+		if (!obj->programs[i].autoload)
+			continue;
 		if (bpf_program__is_function_storage(&obj->programs[i], obj))
 			continue;
 		obj->programs[i].log_level |= log_level;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3fe12c9d1f92..e5f30f70bac1 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -204,6 +204,8 @@ LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog,
 /* returns program size in bytes */
 LIBBPF_API size_t bpf_program__size(const struct bpf_program *prog);
 
+LIBBPF_API void bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
+
 LIBBPF_API int bpf_program__load(struct bpf_program *prog, char *license,
 				 __u32 kern_version);
 LIBBPF_API int bpf_program__fd(const struct bpf_program *prog);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b035122142bb..1d7572806981 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -235,3 +235,8 @@ LIBBPF_0.0.7 {
 		btf__align_of;
 		libbpf_find_kernel_btf;
 } LIBBPF_0.0.6;
+
+LIBBPF_0.0.8 {
+  global:
+    bpf_program__set_autoload;
+} LIBBPF_0.0.7;
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 257a1aaaa37d..1ee62911992d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ LDLIBS += -lcap -lelf -lz -lrt -lpthread
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
-	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
+	test_sock test_btf test_sockmap test_autoload get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_progs-no_alu32
diff --git a/tools/testing/selftests/bpf/progs/test_autoload_kern.c b/tools/testing/selftests/bpf/progs/test_autoload_kern.c
new file mode 100644
index 000000000000..e4cfe9b90606
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_autoload_kern.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("xdp_prog_0")
+int prog_0(struct xdp_md *xdp)
+{
+	return XDP_PASS;
+}
+
+SEC("xdp_prog_1")
+int prog_1(struct xdp_md *xdp)
+{
+	return XDP_PASS;
+}
+
+SEC("xdp_prog_2")
+int prog_2(struct xdp_md *xdp)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_autoload.c b/tools/testing/selftests/bpf/test_autoload.c
new file mode 100644
index 000000000000..3294c167bbfd
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_autoload.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <sys/resource.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "test_autoload_kern.skel.h"
+
+#define AUTOLOAD_KERN "test_autoload_kern.o"
+#define TEST_NO_AUTOLOAD_PROG "prog_2"
+
+int print_libbpf_log(enum libbpf_print_level lvl, const char *fmt, va_list args)
+{
+	return 0;
+}
+
+int test_libbpf(void)
+{
+	struct bpf_object *obj;
+	struct bpf_program *unloaded_prog, *prog;
+	struct bpf_prog_info *info;
+	__u32 info_len;
+	int prog_fd;
+
+	obj = bpf_object__open(AUTOLOAD_KERN);
+	if (obj == NULL) {
+		fprintf(stderr, "failed to load %s\n", AUTOLOAD_KERN);
+		return -1;
+	}
+
+	unloaded_prog =
+		bpf_object__find_program_by_name(obj, TEST_NO_AUTOLOAD_PROG);
+	if (unloaded_prog == NULL) {
+		fprintf(stderr, "failed to find test xdp prog %s\n",
+			TEST_NO_AUTOLOAD_PROG);
+		goto fail;
+	}
+
+	bpf_program__set_autoload(unloaded_prog, false);
+
+	bpf_object__load(obj);
+
+	bpf_object__for_each_program(prog, obj) {
+		prog_fd = bpf_program__fd(prog);
+
+		if (unloaded_prog == prog) {
+			if (-prog_fd != EINVAL) {
+				fprintf(stderr,
+					"non-autoloaded prog should not be loaded\n");
+				goto fail;
+			}
+			continue;
+		}
+
+		info_len = sizeof(struct bpf_prog_info);
+		info = calloc(1, info_len);
+
+		if (bpf_obj_get_info_by_fd(prog_fd, info, &info_len) < 0) {
+			fprintf(stderr, "could not get bpf prog info\n");
+			goto fail;
+		}
+
+		if (info->id == 0) {
+			fprintf(stderr, "expected valid prog id\n");
+			goto fail;
+		}
+	}
+
+	bpf_object__close(obj);
+	return 0;
+fail:
+	bpf_object__close(obj);
+	return -1;
+}
+
+int test_skel(void)
+{
+	struct test_autoload_kern *kern;
+	struct bpf_object *obj;
+	struct bpf_program *unloaded_prog, *prog;
+	struct bpf_prog_info *info;
+	__u32 info_len;
+	int prog_fd;
+
+	kern = test_autoload_kern__open();
+	if (kern == NULL) {
+		fprintf(stderr, "failed to autoload skel\n");
+		return -1;
+	}
+
+	obj = kern->obj;
+
+	unloaded_prog =
+		bpf_object__find_program_by_name(obj, TEST_NO_AUTOLOAD_PROG);
+	if (unloaded_prog == NULL) {
+		fprintf(stderr, "failed to find test xdp prog %s\n",
+			TEST_NO_AUTOLOAD_PROG);
+		goto fail;
+	}
+
+	bpf_program__set_autoload(unloaded_prog, false);
+
+	bpf_object__load(obj);
+
+	bpf_object__for_each_program(prog, obj) {
+		prog_fd = bpf_program__fd(prog);
+
+		if (unloaded_prog == prog) {
+			if (-prog_fd != EINVAL) {
+				fprintf(stderr,
+					"non-autoloaded prog should not be loaded\n");
+				goto fail;
+			}
+			continue;
+		}
+
+		info_len = sizeof(struct bpf_prog_info);
+		info = calloc(1, info_len);
+
+		if (bpf_obj_get_info_by_fd(prog_fd, info, &info_len) < 0) {
+			fprintf(stderr, "could not get bpf prog info\n");
+			goto fail;
+		}
+
+		if (info->id == 0) {
+			fprintf(stderr, "expected valid prog id\n");
+			goto fail;
+		}
+	}
+
+	test_autoload_kern__destroy(kern);
+	return 0;
+fail:
+	test_autoload_kern__destroy(kern);
+	return -1;
+}
+
+int main(void)
+{
+	struct rlimit r = { RLIM_INFINITY, RLIM_INFINITY };
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return EXIT_FAILURE;
+	}
+
+	libbpf_set_print(print_libbpf_log);
+
+	if (test_libbpf() < 0)
+		return EXIT_FAILURE;
+
+	if (test_skel() < 0)
+		return EXIT_FAILURE;
+}
-- 
2.24.1

