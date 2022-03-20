Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E4B4E1A53
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 07:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbiCTGJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 02:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiCTGJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 02:09:42 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB86260E4;
        Sat, 19 Mar 2022 23:08:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c2so8084646pga.10;
        Sat, 19 Mar 2022 23:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B/DE4olHzqEmItKB/QKgw7+ZrZ3h5mTpyjerJIyekdg=;
        b=S8DXix/01L9Oktrx4DREL8vKCifMp+5NYeTIdMdZNEgeCTHK9xzTSIxLGEaeldn8DH
         Z4wfHTZwBSCcWWUoYDsPO3hBKcHuOQ0j9lR0OAEJ37RLNhZr6zMYl3RWBGn8tsNRlYQq
         yXsIdsnOnMW/hz9okOK4OygXnbXdK2ZUliUNVAz/rtY4txGkLZHGOViXPQ3bYnngBqDO
         t98pWLuMb+w+8KLLvd7BjyAb9Y2iNoJUNcNKc3wmOHspGIQtL/V+D61o+1u8lN2epl4q
         KfJ0NNWtvi5YdFsUDjHblUjSoKFbM3O2n2+Apc964lgO5C+FJ5pQK5rgJ8MGYQkEz+cJ
         dimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B/DE4olHzqEmItKB/QKgw7+ZrZ3h5mTpyjerJIyekdg=;
        b=OcTJREjaDTAwkvI/QS7fYK0UvZgnCmz4JEYT5kVnYK29KiNI1ss6wUJPgN/7K+HtFQ
         YPrV0bOi2ZL09QdPdMS+Gds7/QPxnIEGaVTQRas7cjHpf+H9kyLBnGUaqozLpZ8yo9hc
         Wzxfvs+8YQAmuuw68aj6Cj/dSGIF9l6dogcVByCwU6Sej6s/LnI2bFVXoePZvzMCz7MZ
         bTXOtMuFMEeQZPCLSioisbR9kEJEnEmEvLTVEsvFy22EOtNfHdXnVsYo8hHTnSqBU9b6
         repVRra9WQiNFh0gBZvZaoRyjJJRJAAOvE12PxbixkDf6RTbAXDcdzfwgYDZ8LDlIOig
         fWcA==
X-Gm-Message-State: AOAM531rDTBhEQz7izkK5C1jEudi0stgMMq87ckv8MeuZlsY7IN+KbrT
        ECZu8vBDrC0CR4ZmiYb/AbY=
X-Google-Smtp-Source: ABdhPJykSR3BASzg2eUq2fCI5vHP/zjfuZ/qbRDlDRWL9RqSz2J4u/R0MSSpf2E93W7qHfcNxVav7A==
X-Received: by 2002:a05:6a00:234f:b0:4f6:f0c0:ec68 with SMTP id j15-20020a056a00234f00b004f6f0c0ec68mr18285801pfj.14.1647756499148;
        Sat, 19 Mar 2022 23:08:19 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:3dea:5400:3ff:fee9:c745])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a00191500b004f78813b2d6sm15541662pfi.178.2022.03.19.23.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 23:08:18 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH] bpf: selftests: cleanup RLIMIT_MEMLOCK
Date:   Sun, 20 Mar 2022 06:08:15 +0000
Message-Id: <20220320060815.7716-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220320060815.7716-1-laoar.shao@gmail.com>
References: <20220320060815.7716-1-laoar.shao@gmail.com>
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

Since we have alread switched to memcg-based memory accouting and control,
we don't need RLIMIT_MEMLOCK any more.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>

---
RLIMIT_MEMLOCK is still used in bpftool and libbpf, but it may be useful
for backward compatibility, so I don't cleanup them.

---
 tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
 .../selftests/bpf/flow_dissector_load.c       |  1 -
 .../selftests/bpf/get_cgroup_id_user.c        |  1 -
 .../selftests/bpf/map_tests/sk_storage_map.c  | 15 ----------
 .../selftests/bpf/test_cgroup_storage.c       |  1 -
 tools/testing/selftests/bpf/test_dev_cgroup.c |  1 -
 tools/testing/selftests/bpf/test_lpm_map.c    |  1 -
 tools/testing/selftests/bpf/test_lru_map.c    |  1 -
 .../selftests/bpf/test_skb_cgroup_id_user.c   |  1 -
 tools/testing/selftests/bpf/test_sock.c       |  1 -
 tools/testing/selftests/bpf/test_sock_addr.c  |  1 -
 tools/testing/selftests/bpf/test_sockmap.c    |  1 -
 tools/testing/selftests/bpf/test_sysctl.c     |  1 -
 tools/testing/selftests/bpf/test_tag.c        |  1 -
 .../bpf/test_tcp_check_syncookie_user.c       |  1 -
 .../selftests/bpf/test_tcpnotify_user.c       |  1 -
 .../testing/selftests/bpf/test_verifier_log.c |  2 --
 tools/testing/selftests/bpf/xdping.c          |  7 -----
 tools/testing/selftests/bpf/xdpxceiver.c      |  5 ----
 19 files changed, 71 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h

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
index 87fd1aa323a9..e9df470e3253 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "flow_dissector_load.h"
 
 const char *cfg_pin_path = "/sys/fs/bpf/flow_dissector";
diff --git a/tools/testing/selftests/bpf/get_cgroup_id_user.c b/tools/testing/selftests/bpf/get_cgroup_id_user.c
index 3a7b82bd9e94..2c027c7ef49d 100644
--- a/tools/testing/selftests/bpf/get_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/get_cgroup_id_user.c
@@ -20,7 +20,6 @@
 
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
-#include "bpf_rlimit.h"
 
 #define CHECK(condition, tag, format...) ({		\
 	int __ret = !!(condition);			\
diff --git a/tools/testing/selftests/bpf/map_tests/sk_storage_map.c b/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
index 099eb4dfd4f7..864422241960 100644
--- a/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
+++ b/tools/testing/selftests/bpf/map_tests/sk_storage_map.c
@@ -3,7 +3,6 @@
 #include <linux/compiler.h>
 #include <linux/err.h>
 
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <linux/btf.h>
@@ -395,11 +394,8 @@ static void stop_handler(int signum)
 
 static void test_sk_storage_map_stress_free(void)
 {
-	struct rlimit rlim_old, rlim_new = {};
 	int err;
 
-	getrlimit(RLIMIT_NOFILE, &rlim_old);
-
 	signal(SIGTERM, stop_handler);
 	signal(SIGINT, stop_handler);
 	if (runtime_s > 0) {
@@ -407,14 +403,6 @@ static void test_sk_storage_map_stress_free(void)
 		alarm(runtime_s);
 	}
 
-	if (rlim_old.rlim_cur < nr_sk_threads * nr_sk_per_thread) {
-		rlim_new.rlim_cur = nr_sk_threads * nr_sk_per_thread + 128;
-		rlim_new.rlim_max = rlim_new.rlim_cur + 128;
-		err = setrlimit(RLIMIT_NOFILE, &rlim_new);
-		CHECK(err, "setrlimit(RLIMIT_NOFILE)", "rlim_new:%lu errno:%d",
-		      rlim_new.rlim_cur, errno);
-	}
-
 	err = do_sk_storage_map_stress_free();
 
 	signal(SIGTERM, SIG_DFL);
@@ -424,9 +412,6 @@ static void test_sk_storage_map_stress_free(void)
 		alarm(0);
 	}
 
-	if (rlim_new.rlim_cur)
-		setrlimit(RLIMIT_NOFILE, &rlim_old);
-
 	CHECK(err, "test_sk_storage_map_stress_free", "err:%d\n", err);
 }
 
diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index d6a1be4d8020..d8bea0439ec9 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -6,7 +6,6 @@
 #include <stdlib.h>
 #include <sys/sysinfo.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
 
diff --git a/tools/testing/selftests/bpf/test_dev_cgroup.c b/tools/testing/selftests/bpf/test_dev_cgroup.c
index c299d3452695..5ac8279f3f93 100644
--- a/tools/testing/selftests/bpf/test_dev_cgroup.c
+++ b/tools/testing/selftests/bpf/test_dev_cgroup.c
@@ -15,7 +15,6 @@
 
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
-#include "bpf_rlimit.h"
 
 #define DEV_CGROUP_PROG "./dev_cgroup.o"
 
diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index baa3e3ecae82..790ff32c735a 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -26,7 +26,6 @@
 #include <bpf/bpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 
 struct tlpm_node {
 	struct tlpm_node *next;
diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index 563bbe18c172..41cea43cd6d5 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -18,7 +18,6 @@
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "../../../include/linux/filter.h"
 
 #define LOCAL_FREE_TARGET	(128)
diff --git a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
index 4a64306728ab..de7b230023a2 100644
--- a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 #define CGROUP_PATH		"/skb_cgroup_test"
diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index fe10f8134278..c83e1872d2a6 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -14,7 +14,6 @@
 
 #include "cgroup_helpers.h"
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 
 #define CG_PATH		"/foo"
diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index f3d5d7ac6505..fd047567ee63 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -19,7 +19,6 @@
 #include <bpf/libbpf.h>
 
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 
 #ifndef ENOTSUPP
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index dfb4f5c0fcb9..3eeebe915903 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -37,7 +37,6 @@
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 int running;
diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/selftests/bpf/test_sysctl.c
index 4f6cf833b522..dd6fd170b11a 100644
--- a/tools/testing/selftests/bpf/test_sysctl.c
+++ b/tools/testing/selftests/bpf/test_sysctl.c
@@ -14,7 +14,6 @@
 #include <bpf/libbpf.h>
 
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
diff --git a/tools/testing/selftests/bpf/test_tag.c b/tools/testing/selftests/bpf/test_tag.c
index 0851c42ee31c..4f745de802cf 100644
--- a/tools/testing/selftests/bpf/test_tag.c
+++ b/tools/testing/selftests/bpf/test_tag.c
@@ -20,7 +20,6 @@
 #include <bpf/bpf.h>
 
 #include "../../../include/linux/filter.h"
-#include "bpf_rlimit.h"
 #include "testing_helpers.h"
 
 static struct bpf_insn prog[BPF_MAXINSNS];
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index b9e991d43155..894eb0710d6f 100644
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 static int start_server(const struct sockaddr *addr, socklen_t len)
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
index 8d6918c3b4a2..4bca0a7344cc 100644
--- a/tools/testing/selftests/bpf/test_verifier_log.c
+++ b/tools/testing/selftests/bpf/test_verifier_log.c
@@ -11,8 +11,6 @@
 
 #include <bpf/bpf.h>
 
-#include "bpf_rlimit.h"
-
 #define LOG_SIZE (1 << 20)
 
 #define err(str...)	printf("ERROR: " str)
diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftests/bpf/xdping.c
index c567856fd1bc..bc5eadf2d0f8 100644
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
@@ -167,11 +165,6 @@ int main(int argc, char **argv)
 		freeaddrinfo(a);
 	}
 
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
 	if (bpf_prog_test_load(filename, BPF_PROG_TYPE_XDP, &obj, &prog_fd)) {
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 5f8296d29e77..5fbaebe89e14 100644
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
@@ -1448,15 +1447,11 @@ static void ifobject_delete(struct ifobject *ifobj)
 
 int main(int argc, char **argv)
 {
-	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	struct pkt_stream *pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
 	struct test_spec test;
 	u32 i, j;
 
-	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
-		exit_with_error(errno);
-
 	ifobj_tx = ifobject_create();
 	if (!ifobj_tx)
 		exit_with_error(ENOMEM);
-- 
2.17.1

