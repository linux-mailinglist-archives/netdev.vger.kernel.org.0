Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910C84FA7D8
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 15:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbiDINCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 09:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiDINCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 09:02:22 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425392126C;
        Sat,  9 Apr 2022 06:00:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q19so10118544pgm.6;
        Sat, 09 Apr 2022 06:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7239TF6ANTVKRpBlSltFjQtOBdo4o6P8bdwFT//swx8=;
        b=Fi1I9rqi8mGfPXdDmCG8agE1zOeURxlH5aT5cZjW0B4hEeOd8iK6fEMFZTxA1MkJtI
         lMDYl3Yhlh5mbtGDc/JVMHDqKkVhBpjQ2+DGDShjlFsRbeCnQmUjQ0njQHb8KNicLZVa
         hv45AzzCYoHQ0a2EPWKymKNC5yPEMwx5+2Z63Velkwf30jo0ViQeT0hW3zvUT8PGCHDC
         j2sPoin3g1UOOWI2B+XQFDBVZIP4scDfRcGQ5J6QtxOwI1g3K4r1AYmfMAXlzQe1t1u/
         VysEUm2tEvvkURCinOg+otx7F/Mi9zcUyhxJmfFLGz3cGOkHZZ3lBb+C1DIwEcblhi37
         antQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7239TF6ANTVKRpBlSltFjQtOBdo4o6P8bdwFT//swx8=;
        b=z4gc/JkYrqnHTwnfdXobYjxZ8tLOZ+16XP8xXLb+gfNXcewWyot50gXGUIpPBmc0Hj
         rD9tDPabMDszU1LKX/DNwW5mh4r9yUaVn+8P6NyjW6uYSVmaWuJjmSiVu37EpjJTIGcF
         gSgJKJYTsiBFJikST+FY0kILmdca8CJFSGQuRuMyZlEKD5Czoa8l8t2AoTtmrITbt2G1
         na9WYgAIlqhYJFh9vTIwFT2wxLYQasJIKlFMyvTUvm6X10TQZdb2tn8JoejIZai72WwJ
         Loh5CZIWP8cCrH905ZohgBLnqWI+uGRyPYUPEwXXOXu56FrIfVM+WySkp3L0HILaRRgQ
         JEeQ==
X-Gm-Message-State: AOAM531GB+Y+zTJxNCF6FvwKq4DxKJEre2puwFF4r8QyTZtYBJbtUuqa
        OhhjnezlX730+VeGLYC+hkRmkFuEetCVBXQq
X-Google-Smtp-Source: ABdhPJwf5ihVbptgKatbYSxSNGTxF9Uu6fUaqSavvkjvqlr8g5g3VOsAvKM+afOkvuMCiOiEQGZe2A==
X-Received: by 2002:a05:6a00:ccf:b0:505:6998:69b0 with SMTP id b15-20020a056a000ccf00b00505699869b0mr12163949pfv.66.1649509214475;
        Sat, 09 Apr 2022 06:00:14 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm24671871pge.44.2022.04.09.06.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:00:14 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v4 2/4] selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
Date:   Sat,  9 Apr 2022 12:59:56 +0000
Message-Id: <20220409125958.92629-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220409125958.92629-1-laoar.shao@gmail.com>
References: <20220409125958.92629-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have switched to memcg-based memory accouting and thus the rlimit is
not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
libbpf for backward compatibility, so we can use it instead now. After
this change, the header tools/testing/selftests/bpf/bpf_rlimit.h can be
removed.

This patch also removes the useless header sys/resource.h from many files
in tools/testing/selftests/bpf/.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/bench.c           |  1 -
 tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
 .../selftests/bpf/flow_dissector_load.c       |  6 ++--
 .../selftests/bpf/get_cgroup_id_user.c        |  4 ++-
 tools/testing/selftests/bpf/prog_tests/btf.c  |  1 -
 .../selftests/bpf/test_cgroup_storage.c       |  4 ++-
 tools/testing/selftests/bpf/test_dev_cgroup.c |  4 ++-
 tools/testing/selftests/bpf/test_lpm_map.c    |  4 ++-
 tools/testing/selftests/bpf/test_lru_map.c    |  4 ++-
 .../selftests/bpf/test_skb_cgroup_id_user.c   |  4 ++-
 tools/testing/selftests/bpf/test_sock.c       |  4 ++-
 tools/testing/selftests/bpf/test_sock_addr.c  |  4 ++-
 tools/testing/selftests/bpf/test_sockmap.c    |  5 ++--
 tools/testing/selftests/bpf/test_sysctl.c     |  4 ++-
 tools/testing/selftests/bpf/test_tag.c        |  4 ++-
 .../bpf/test_tcp_check_syncookie_user.c       |  4 ++-
 .../selftests/bpf/test_tcpnotify_user.c       |  1 -
 .../testing/selftests/bpf/test_verifier_log.c |  5 ++--
 .../selftests/bpf/xdp_redirect_multi.c        |  1 -
 tools/testing/selftests/bpf/xdping.c          |  8 ++----
 tools/testing/selftests/bpf/xdpxceiver.c      |  6 ++--
 21 files changed, 45 insertions(+), 61 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f973320e6dbf..f061cc20e776 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -8,7 +8,6 @@
 #include <fcntl.h>
 #include <pthread.h>
 #include <sys/sysinfo.h>
-#include <sys/resource.h>
 #include <signal.h>
 #include "bench.h"
 #include "testing_helpers.h"
diff --git a/tools/testing/selftests/bpf/bpf_rlimit.h b/tools/testing/selftests/bpf/bpf_rlimit.h
deleted file mode 100644
index 9dac9b30f8ef..000000000000
--- a/tools/testing/selftests/bpf/bpf_rlimit.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#include <sys/resource.h>
-#include <stdio.h>
-
-static  __attribute__((constructor)) void bpf_rlimit_ctor(void)
-{
-	struct rlimit rlim_old, rlim_new = {
-		.rlim_cur	= RLIM_INFINITY,
-		.rlim_max	= RLIM_INFINITY,
-	};
-
-	getrlimit(RLIMIT_MEMLOCK, &rlim_old);
-	/* For the sake of running the test cases, we temporarily
-	 * set rlimit to infinity in order for kernel to focus on
-	 * errors from actual test cases and not getting noise
-	 * from hitting memlock limits. The limit is on per-process
-	 * basis and not a global one, hence destructor not really
-	 * needed here.
-	 */
-	if (setrlimit(RLIMIT_MEMLOCK, &rlim_new) < 0) {
-		perror("Unable to lift memlock rlimit");
-		/* Trying out lower limit, but expect potential test
-		 * case failures from this!
-		 */
-		rlim_new.rlim_cur = rlim_old.rlim_cur + (1UL << 20);
-		rlim_new.rlim_max = rlim_old.rlim_max + (1UL << 20);
-		setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-	}
-}
diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/testing/selftests/bpf/flow_dissector_load.c
index 87fd1aa323a9..c8be6406777f 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "flow_dissector_load.h"
 
 const char *cfg_pin_path = "/sys/fs/bpf/flow_dissector";
@@ -25,9 +24,8 @@ static void load_and_attach_program(void)
 	int prog_fd, ret;
 	struct bpf_object *obj;
 
-	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
-	if (ret)
-		error(1, 0, "failed to enable libbpf strict mode: %d", ret);
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	ret = bpf_flow_load(&obj, cfg_path_name, cfg_prog_name,
 			    cfg_map_name, NULL, &prog_fd, NULL);
diff --git a/tools/testing/selftests/bpf/get_cgroup_id_user.c b/tools/testing/selftests/bpf/get_cgroup_id_user.c
index 3a7b82bd9e94..e021cc67dc02 100644
--- a/tools/testing/selftests/bpf/get_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/get_cgroup_id_user.c
@@ -20,7 +20,6 @@
 
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
-#include "bpf_rlimit.h"
 
 #define CHECK(condition, tag, format...) ({		\
 	int __ret = !!(condition);			\
@@ -67,6 +66,9 @@ int main(int argc, char **argv)
 	if (CHECK(cgroup_fd < 0, "cgroup_setup_and_join", "err %d errno %d\n", cgroup_fd, errno))
 		return 1;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
 	if (CHECK(err, "bpf_prog_test_load", "err %d errno %d\n", err, errno))
 		goto cleanup_cgroup_env;
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index ec823561b912..84aae639ddb5 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -8,7 +8,6 @@
 #include <linux/filter.h>
 #include <linux/unistd.h>
 #include <bpf/bpf.h>
-#include <sys/resource.h>
 #include <libelf.h>
 #include <gelf.h>
 #include <string.h>
diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index 2ffa08198d1c..0861ea60dcdd 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -6,7 +6,6 @@
 #include <stdlib.h>
 #include <sys/sysinfo.h>
 
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
@@ -52,6 +51,9 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	map_fd = bpf_map_create(BPF_MAP_TYPE_CGROUP_STORAGE, NULL, sizeof(key),
 				sizeof(value), 0, NULL);
 	if (map_fd < 0) {
diff --git a/tools/testing/selftests/bpf/test_dev_cgroup.c b/tools/testing/selftests/bpf/test_dev_cgroup.c
index c299d3452695..7886265846a0 100644
--- a/tools/testing/selftests/bpf/test_dev_cgroup.c
+++ b/tools/testing/selftests/bpf/test_dev_cgroup.c
@@ -15,7 +15,6 @@
 
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
-#include "bpf_rlimit.h"
 
 #define DEV_CGROUP_PROG "./dev_cgroup.o"
 
@@ -28,6 +27,9 @@ int main(int argc, char **argv)
 	int prog_fd, cgroup_fd;
 	__u32 prog_cnt;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (bpf_prog_test_load(DEV_CGROUP_PROG, BPF_PROG_TYPE_CGROUP_DEVICE,
 			  &obj, &prog_fd)) {
 		printf("Failed to load DEV_CGROUP program\n");
diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index aa294612e0a7..789c9748d241 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -26,7 +26,6 @@
 #include <bpf/bpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 
 struct tlpm_node {
 	struct tlpm_node *next;
@@ -791,6 +790,9 @@ int main(void)
 	/* we want predictable, pseudo random tests */
 	srand(0xf00ba1);
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	test_lpm_basic();
 	test_lpm_order();
 
diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index 563bbe18c172..a6aa2d121955 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -18,7 +18,6 @@
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "../../../include/linux/filter.h"
 
 #define LOCAL_FREE_TARGET	(128)
@@ -878,6 +877,9 @@ int main(int argc, char **argv)
 	assert(nr_cpus != -1);
 	printf("nr_cpus:%d\n\n", nr_cpus);
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	for (f = 0; f < ARRAY_SIZE(map_flags); f++) {
 		unsigned int tgt_free = (map_flags[f] & BPF_F_NO_COMMON_LRU) ?
 			PERCPU_FREE_TARGET : LOCAL_FREE_TARGET;
diff --git a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
index 4a64306728ab..3256de30f563 100644
--- a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 #define CGROUP_PATH		"/skb_cgroup_test"
@@ -160,6 +159,9 @@ int main(int argc, char **argv)
 		exit(EXIT_FAILURE);
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	cgfd = cgroup_setup_and_join(CGROUP_PATH);
 	if (cgfd < 0)
 		goto err;
diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index fe10f8134278..6c4494076bbf 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -14,7 +14,6 @@
 
 #include "cgroup_helpers.h"
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 
 #define CG_PATH		"/foo"
@@ -541,6 +540,9 @@ int main(int argc, char **argv)
 	if (cgfd < 0)
 		goto err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (run_tests(cgfd))
 		goto err;
 
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index f3d5d7ac6505..458564fcfc82 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -19,7 +19,6 @@
 #include <bpf/libbpf.h>
 
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 
 #ifndef ENOTSUPP
@@ -1418,6 +1417,9 @@ int main(int argc, char **argv)
 	if (cgfd < 0)
 		goto err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (run_tests(cgfd))
 		goto err;
 
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index dfb4f5c0fcb9..0fbaccdc8861 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -18,7 +18,6 @@
 #include <sched.h>
 
 #include <sys/time.h>
-#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/sendfile.h>
 
@@ -37,7 +36,6 @@
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 int running;
@@ -2017,6 +2015,9 @@ int main(int argc, char **argv)
 		cg_created = 1;
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (test == SELFTESTS) {
 		err = test_selftest(cg_fd, &options);
 		goto out;
diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/selftests/bpf/test_sysctl.c
index 4f6cf833b522..5bae25ca19fb 100644
--- a/tools/testing/selftests/bpf/test_sysctl.c
+++ b/tools/testing/selftests/bpf/test_sysctl.c
@@ -14,7 +14,6 @@
 #include <bpf/libbpf.h>
 
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
@@ -1618,6 +1617,9 @@ int main(int argc, char **argv)
 	if (cgfd < 0)
 		goto err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (run_tests(cgfd))
 		goto err;
 
diff --git a/tools/testing/selftests/bpf/test_tag.c b/tools/testing/selftests/bpf/test_tag.c
index 0851c42ee31c..5546b05a0486 100644
--- a/tools/testing/selftests/bpf/test_tag.c
+++ b/tools/testing/selftests/bpf/test_tag.c
@@ -20,7 +20,6 @@
 #include <bpf/bpf.h>
 
 #include "../../../include/linux/filter.h"
-#include "bpf_rlimit.h"
 #include "testing_helpers.h"
 
 static struct bpf_insn prog[BPF_MAXINSNS];
@@ -189,6 +188,9 @@ int main(void)
 	uint32_t tests = 0;
 	int i, fd_map;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	fd_map = bpf_map_create(BPF_MAP_TYPE_HASH, NULL, sizeof(int),
 				sizeof(int), 1, &opts);
 	assert(fd_map > 0);
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index e7775d3bbe08..5c8ef062f760 100644
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 static int start_server(const struct sockaddr *addr, socklen_t len, bool dual)
@@ -235,6 +234,9 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	results = get_map_fd_by_prog_id(atoi(argv[1]), &xdp);
 	if (results < 0) {
 		log_err("Can't get map");
diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/testing/selftests/bpf/test_tcpnotify_user.c
index 4c5114765b23..8284db8b0f13 100644
--- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
+++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
@@ -19,7 +19,6 @@
 #include <linux/perf_event.h>
 #include <linux/err.h>
 
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 
diff --git a/tools/testing/selftests/bpf/test_verifier_log.c b/tools/testing/selftests/bpf/test_verifier_log.c
index 8d6918c3b4a2..70feda97cee5 100644
--- a/tools/testing/selftests/bpf/test_verifier_log.c
+++ b/tools/testing/selftests/bpf/test_verifier_log.c
@@ -11,8 +11,6 @@
 
 #include <bpf/bpf.h>
 
-#include "bpf_rlimit.h"
-
 #define LOG_SIZE (1 << 20)
 
 #define err(str...)	printf("ERROR: " str)
@@ -141,6 +139,9 @@ int main(int argc, char **argv)
 
 	memset(log, 1, LOG_SIZE);
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	/* Test incorrect attr */
 	printf("Test log_level 0...\n");
 	test_log_bad(log, LOG_SIZE, 0);
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
index aaedbf4955c3..c03b3a75991f 100644
--- a/tools/testing/selftests/bpf/xdp_redirect_multi.c
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -10,7 +10,6 @@
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftests/bpf/xdping.c
index c567856fd1bc..5b6f977870f8 100644
--- a/tools/testing/selftests/bpf/xdping.c
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -12,7 +12,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <net/if.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -89,7 +88,6 @@ int main(int argc, char **argv)
 {
 	__u32 mode_flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
 	struct addrinfo *a, hints = { .ai_family = AF_INET };
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	__u16 count = XDPING_DEFAULT_COUNT;
 	struct pinginfo pinginfo = { 0 };
 	const char *optstr = "c:I:NsS";
@@ -167,10 +165,8 @@ int main(int argc, char **argv)
 		freeaddrinfo(a);
 	}
 
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 5f8296d29e77..cfcb031323c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -90,7 +90,6 @@
 #include <string.h>
 #include <stddef.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/queue.h>
 #include <time.h>
@@ -1448,14 +1447,13 @@ static void ifobject_delete(struct ifobject *ifobj)
 
 int main(int argc, char **argv)
 {
-	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	struct pkt_stream *pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
 	struct test_spec test;
 	u32 i, j;
 
-	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
-		exit_with_error(errno);
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	ifobj_tx = ifobject_create();
 	if (!ifobj_tx)
-- 
2.17.1

