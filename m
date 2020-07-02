Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F586211A04
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 04:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgGBCRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 22:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgGBCRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 22:17:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8514FC08C5C1;
        Wed,  1 Jul 2020 19:17:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gc9so5259918pjb.2;
        Wed, 01 Jul 2020 19:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWjnj5urweNDXfj9TgpouqBlRlztM4LhGOoTn1UsOnc=;
        b=EBp0K0sacLb4tz40ngFvyUuVBT6v0jpuTMWExnCu6HheTv5ms2rMDrXM6c89yi1iUE
         jF7Oxhe5ifGl58VWmDquOzEdNfsiH9zq2ozusuzvmuLXCdvlR/Cpyrn153Pwg4rEbXk+
         q7gSo0h5mH2ApzvZ5rfY1tfYddG26puZjg8ofhoa/aUw3/Lp98wtQJndO09n57jiQG4Y
         Z4lzihhwWPG/Mcm6P6AS9DPdqF5f5EJyK08nr67CWSIAuvv2wtwdLb4CagKc3BAsxCJL
         ploPlU8Jfum0U5CC43liVX5QTl39MtM+jEmntx1XkrzRjA+ehxdU1e/4Scech6ffJvsm
         Bu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWjnj5urweNDXfj9TgpouqBlRlztM4LhGOoTn1UsOnc=;
        b=rH/ABAWGhbHmX44sm5m9H9qmt1z3dVo9pe6or5PU4cNMhFS52Rr5eH0vNz85mqAphD
         aAWqiaPWpkhnMDJHmNwPKJ5cDzffYo3qHP8I3RTic81ERM5QJtGb0GDc8Ld+PQK7R8nB
         FJpaOkwogyxU+bWdNizMMobcLEn1YHArReIZViurJ9eG9JANpQU0OFgG1QrKeDfWkEcP
         RFjtXh4oyYE/oodqb9F84Dtx1QznyUTPdW0z5MmOAfOroTTSsuqy+q7Rb0LHLBOPcAtr
         Cms1XbAEYxAXAXdTGnzvwuGWNdcUuGoOOlpLLISWY3oloo1/c3Q5LzE15UmfG5TvbSHt
         9RHw==
X-Gm-Message-State: AOAM533KCP8VfNgKns3W1G9A5o/O/HIx+UPUhes0n2iOgIyBMuybZ0AW
        W2Lwb7z2zyU9SjEQMeNaeht2Se2vr8wZ
X-Google-Smtp-Source: ABdhPJw4/DCKwrmE2g0uXfcl0uhVHiM/Pr9P5pd6C+taYj1Wp7hHToYNhuwTQK59rpQVSLqB8aPc+g==
X-Received: by 2002:a17:902:a606:: with SMTP id u6mr24099402plq.94.1593656226058;
        Wed, 01 Jul 2020 19:17:06 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s1sm6428828pjp.14.2020.07.01.19.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 19:17:05 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/4] samples: bpf: refactor BPF map in map test with libbpf
Date:   Thu,  2 Jul 2020 11:16:44 +0900
Message-Id: <20200702021646.90347-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702021646.90347-1-danieltimlee@gmail.com>
References: <20200702021646.90347-1-danieltimlee@gmail.com>
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

