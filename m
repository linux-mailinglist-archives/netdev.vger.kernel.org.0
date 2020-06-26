Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96C20AE58
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgFZIRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729026AbgFZIRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:17:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F125C08C5C1;
        Fri, 26 Jun 2020 01:17:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 35so4018897ple.0;
        Fri, 26 Jun 2020 01:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWjnj5urweNDXfj9TgpouqBlRlztM4LhGOoTn1UsOnc=;
        b=SS5ZsFBc2beqagie3eppyfwlio4WcUltevULAcskOdoox8UQ+EaeMkhLI74GU18VEq
         4gSnfM/pxKg6LhS3A0CMPxiRtoj6GdibU35feT7bZgzmppDXXTvR5WUI9gYcHCo2UEkp
         +QpXg36xpyuWrSDFa5JC3tucTpmHlYNBZFgix5Yi9qtZK282Lmc4NStsN2Ykuuvq1nZg
         +x+8ZNsb027OdHlVgZeBdHEYw/6B8NXL2z4iY2Jpm1F9I7PqjHem27AYjjpWin6RcO16
         1kY+0NIcl13pH7rdJzYx6Bv4QNLH4b5qYT+QzpOHb3DnpBFHl0g+T7RAgS+O2dapy8iT
         W8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWjnj5urweNDXfj9TgpouqBlRlztM4LhGOoTn1UsOnc=;
        b=QyXvBjk/i+1ZtFRHnplLlnWtO2I64RVqTMIMNE+AnsisW6nwrXJ2yCg9ML3zkiZvjk
         kLtsnOhs8bS6tKgZxlW8YAJ9Ay4AQG8VvnIHA88xEmq29FuXEv5+sK//gFFPLfRhzOWZ
         s3G+Kne16/HTRywomdPVVTRLJ6pVNIoReWQR6TCjMo2y1wASi4Z3CF7Kh2bduTKiNckZ
         wfzS8zdtxRRe4CfiVj2aHouSey+Ppgdshs0uwFqAikLGswHOmMszBac1SC+58yJAK9Bg
         /b1Eb72UM8YFWwkt5BUyqglB5qJnwFT+wpNI7IBXbvdlzCI000kMVvEGrzJGhjbsMY3H
         vwVQ==
X-Gm-Message-State: AOAM5322ihJ/RgRKmtPO7lsgB5TCubPtnDJY0BbMpMqjyiCAbHViajB+
        DOCozJ6HACTd9tU+kanfoQ==
X-Google-Smtp-Source: ABdhPJyrNBiPQRrnoKQ7f5HY3Y2JSzkjR9AO/DwS0YPkm65Q5iF3nAjel1GPtvvP9VcjVTuqzPryOw==
X-Received: by 2002:a17:902:9b97:: with SMTP id y23mr1562334plp.54.1593159455110;
        Fri, 26 Jun 2020 01:17:35 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s22sm16514023pgv.43.2020.06.26.01.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 01:17:34 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 3/3] samples: bpf: refactor BPF map in map test with libbpf
Date:   Fri, 26 Jun 2020 17:17:20 +0900
Message-Id: <20200626081720.5546-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200626081720.5546-1-danieltimlee@gmail.com>
References: <20200626081720.5546-1-danieltimlee@gmail.com>
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
 samples/bpf/Makefile               |  2 +-
 samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
 samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
 3 files changed, 91 insertions(+), 49 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index ffd0fda536da..78678d4e6842 100644
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
index b1562ba2f025..d3f56ed78541 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -11,66 +11,65 @@
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/in6.h>
 #include <bpf/bpf_helpers.h>
-#include "bpf_legacy.h"
 #include <bpf/bpf_tracing.h>
 
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
index eb29bcb76f3f..e5bddfff696f 100644
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
+	if (libbpf_get_error(prog)) {
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

