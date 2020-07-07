Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0821421770C
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGGStR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgGGStR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:49:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE6AC061755;
        Tue,  7 Jul 2020 11:49:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d4so20413437pgk.4;
        Tue, 07 Jul 2020 11:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eVKwsHiMMaqiXspq4z4arSwLEEyYuOmli2QGE2IxT10=;
        b=FCokl0J7ozNqa6m6OZnmNZya8FAefiDkswuzw3flTEROeN5Lv3hyEqakzusgjwipfT
         UYPxP7NJoqWng9l8GQsL3K2OTH8q4j4qunpJjXAC7yirGcM2+RUUzhy5iC0zowQLJoR1
         PhSt4F2vkKgpgeOKmb162U+kczcPwsLpFrjYpE+Wh2aMQek7EoN1oKs34acjuJIrKyuX
         kZLjJNzR2k6TgyR9z/s5FUCZb+yjKu0b9jmIoMOY9j1D6BSXQaHBxPnFVpw9uUyrJvTS
         hpXLBYKBgxF9RnjNj+T+esD+BMX8mzciVWyu2FIQgquVTPzB/WPPApAWeoCA6VE4hj6z
         4EOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eVKwsHiMMaqiXspq4z4arSwLEEyYuOmli2QGE2IxT10=;
        b=qxWAzIPIM1AZpmykZ2qe8mYs+Wo3bFONIUreX76gnTLu23GO2R1hTB4U9nyaiV4y/S
         NoLb7LXIQ5Rhh+JgFIfT7Y7NIwW3PrZ4e+dwp2/0FnCPew0k2nH9OAqtQlrdhzM8lCOk
         rB9Guu3OSkCnK7KVsj3RZ4MI9RiIovhtqGVslLs9hjZabRcq1UHNUV7dOguqvTnOjgPB
         DnZ5L1Nm0HrpUfUdLUhWOZs0tHeCXcpGspBAjO2MWQSb5/XpDP9K+5UhSvvJwnTThkg+
         RkFUMrOIpZnodzxcjOnF8gbHDiKjo1l60zR1b/djkJIVAzbWqdB1RO9NbYGAQYs5pZQH
         6lGg==
X-Gm-Message-State: AOAM531P7SaolpTmkxleSIDvifwLKzmRcjt5OwyAclStTPaykj+BuD5O
        YatdrLkXu/NqQ1IplIEmbkZf3RZb/aUV
X-Google-Smtp-Source: ABdhPJwGtAop1I4eSXM8oEJSU3//tCizzAulvDqujXP24vgWBWcPlxqIegtjdnXntm8qRY6NGTu1Ag==
X-Received: by 2002:a63:a84d:: with SMTP id i13mr44469077pgp.342.1594147756437;
        Tue, 07 Jul 2020 11:49:16 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id r7sm1625278pgu.51.2020.07.07.11.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 11:49:15 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 2/4] samples: bpf: refactor BPF map in map test with libbpf
Date:   Wed,  8 Jul 2020 03:48:53 +0900
Message-Id: <20200707184855.30968-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707184855.30968-1-danieltimlee@gmail.com>
References: <20200707184855.30968-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
support"), a way to define internal map in BTF-defined map has been
added.

Instead of using previous 'inner_map_idx' definition, the structure to
be used for the inner map can be directly defined using array directive.

    __array(values, struct inner_map)

This commit refactors map in map test program with libbpf by explicitly
defining inner map with BTF-defined format.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in V2:
 - fix wrong error check logic with bpf_program

 samples/bpf/Makefile               |  2 +-
 samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
 samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
 3 files changed, 91 insertions(+), 49 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 8403e4762306..f87ee02073ba 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -93,7 +93,7 @@ sampleip-objs := sampleip_user.o $(TRACE_HELPERS)
 tc_l2_redirect-objs := bpf_load.o tc_l2_redirect_user.o
 lwt_len_hist-objs := bpf_load.o lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
-test_map_in_map-objs := bpf_load.o test_map_in_map_user.o
+test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 36a203e69064..8def45c5b697 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -11,7 +11,6 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/in6.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
 #include "trace_common.h"
@@ -19,60 +18,60 @@
 #define MAX_NR_PORTS 65536
 
 /* map #0 */
-struct bpf_map_def_legacy SEC("maps") port_a = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(int),
-	.max_entries = MAX_NR_PORTS,
-};
+struct inner_a {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, int);
+	__uint(max_entries, MAX_NR_PORTS);
+} port_a SEC(".maps");
 
 /* map #1 */
-struct bpf_map_def_legacy SEC("maps") port_h = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(int),
-	.max_entries = 1,
-};
+struct inner_h {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, int);
+	__uint(max_entries, 1);
+} port_h SEC(".maps");
 
 /* map #2 */
-struct bpf_map_def_legacy SEC("maps") reg_result_h = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(int),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, int);
+	__uint(max_entries, 1);
+} reg_result_h SEC(".maps");
 
 /* map #3 */
-struct bpf_map_def_legacy SEC("maps") inline_result_h = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(int),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, int);
+	__uint(max_entries, 1);
+} inline_result_h SEC(".maps");
 
 /* map #4 */ /* Test case #0 */
-struct bpf_map_def_legacy SEC("maps") a_of_port_a = {
-	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
-	.key_size = sizeof(u32),
-	.inner_map_idx = 0, /* map_fd[0] is port_a */
-	.max_entries = MAX_NR_PORTS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, MAX_NR_PORTS);
+	__uint(key_size, sizeof(u32));
+	__array(values, struct inner_a); /* use inner_a as inner map */
+} a_of_port_a SEC(".maps");
 
 /* map #5 */ /* Test case #1 */
-struct bpf_map_def_legacy SEC("maps") h_of_port_a = {
-	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
-	.key_size = sizeof(u32),
-	.inner_map_idx = 0, /* map_fd[0] is port_a */
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(u32));
+	__array(values, struct inner_a); /* use inner_a as inner map */
+} h_of_port_a SEC(".maps");
 
 /* map #6 */ /* Test case #2 */
-struct bpf_map_def_legacy SEC("maps") h_of_port_h = {
-	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
-	.key_size = sizeof(u32),
-	.inner_map_idx = 1, /* map_fd[1] is port_h */
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(u32));
+	__array(values, struct inner_h); /* use inner_h as inner map */
+} h_of_port_h SEC(".maps");
 
 static __always_inline int do_reg_lookup(void *inner_map, u32 port)
 {
diff --git a/samples/bpf/test_map_in_map_user.c b/samples/bpf/test_map_in_map_user.c
index eb29bcb76f3f..98656de56b83 100644
--- a/samples/bpf/test_map_in_map_user.c
+++ b/samples/bpf/test_map_in_map_user.c
@@ -11,7 +11,9 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
+
+static int map_fd[7];
 
 #define PORT_A		(map_fd[0])
 #define PORT_H		(map_fd[1])
@@ -113,18 +115,59 @@ static void test_map_in_map(void)
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
 
-	assert(!setrlimit(RLIMIT_MEMLOCK, &r));
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
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
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "port_a");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "port_h");
+	map_fd[2] = bpf_object__find_map_fd_by_name(obj, "reg_result_h");
+	map_fd[3] = bpf_object__find_map_fd_by_name(obj, "inline_result_h");
+	map_fd[4] = bpf_object__find_map_fd_by_name(obj, "a_of_port_a");
+	map_fd[5] = bpf_object__find_map_fd_by_name(obj, "h_of_port_a");
+	map_fd[6] = bpf_object__find_map_fd_by_name(obj, "h_of_port_h");
+	if (map_fd[0] < 0 || map_fd[1] < 0 || map_fd[2] < 0 ||
+	    map_fd[3] < 0 || map_fd[4] < 0 || map_fd[5] < 0 || map_fd[6] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	link = bpf_program__attach(prog);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	test_map_in_map();
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return 0;
 }
-- 
2.25.1

