Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD54437BB4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhJVRTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhJVRTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:19:11 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2325C061766
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:53 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u18so5871203wrg.5
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fG1lO4YrDaNaXdkJiQ920tZ/bSWumMS49v8DUjgg1Ac=;
        b=3I5BNg6Qll8NONBAGtCAa1LttVk4WBpeFxoyXf/r6MK+tG6bvATrnWzfJujcNV/UJ0
         Q9AeEsUV+ZVersKLtMwCSuOdqKZPoG3MQrtXsV2f1iR/A5+va+jsmBS4Ovp8JiyfP4US
         D1JyvwOA31vB1dd9EkfmnliJxvHWNUQ0REF9CgK4sUSEornJQ5gHyy3lcOgl3LeMcosz
         Fd5OBSzFTiE63L5PBGlUUBBEp9qshB1eJhqTxNm/Z21tXChb90wUA4KaxClSkG785THX
         d/jFG+Lp0zhJxF2IOUHdO5sSdRWznQWKiBeBuGo11lE3kWOIbY/730bgBbsu7n7amIzo
         0Vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fG1lO4YrDaNaXdkJiQ920tZ/bSWumMS49v8DUjgg1Ac=;
        b=lw2bCBML4kcCOXDeiUnAgwu4U9EMcwi4owiMcikE+tnXgcYrHyrQA9WZJit2OyK6ie
         0sdpqMR5ybt0mp9zf89nQdvbJiQm+M9Jj9JJh3keM4NLrNVSmE6QHVrC3mbs74Fcd52a
         Ohupi2bPE4QfCC6wX1iU3aXLNRs5/utGpbVDwm5whrt2P5ZYP68+cSChGAELFxNkkGjf
         +lG16+2rkJT8cQ4WocCkIIYnIjkPImLwgWRKdQCODtViN5kd+GjjAspyKErlq1tc6TWg
         Scf55q0ToctcZt5gtnjSGq7siuKrpyTxuWJO1JQi9ZtIWOghFj6m6RlcSwaZXbKIPVC4
         bqZg==
X-Gm-Message-State: AOAM5328Wb+wBAwJj/t4BVIQNsZnilMwWjRUZUlc6S68vx3RWLPtIf+e
        RKz+A3TOwWXSW06Qyl1F3jMmsA==
X-Google-Smtp-Source: ABdhPJw4SAZojKYvrdq665BkdHUXz++fO03mWlyEClNYlyVEgV/1XG4qL2lRSqq23IgThJP5f//Rmw==
X-Received: by 2002:a5d:6d8f:: with SMTP id l15mr1427157wrs.350.1634923012420;
        Fri, 22 Oct 2021 10:16:52 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id 6sm4427367wma.48.2021.10.22.10.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:16:52 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/5] bpftool: Do not expose and init hash maps for pinned path in main.c
Date:   Fri, 22 Oct 2021 18:16:44 +0100
Message-Id: <20211022171647.27885-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022171647.27885-1-quentin@isovalent.com>
References: <20211022171647.27885-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF programs, maps, and links, can all be listed with their pinned paths
by bpftool, when the "-f" option is provided. To do so, bpftool builds
hash maps containing all pinned paths for each kind of objects.

These three hash maps are always initialised in main.c, and exposed
through main.h. There appear to be no particular reason to do so: we can
just as well make them static to the files that need them (prog.c,
map.c, and link.c respectively), and initialise them only when we want
to show objects and the "-f" switch is provided.

This may prevent unnecessary memory allocations if the implementation of
the hash maps was to change in the future.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/link.c |  9 ++++++++-
 tools/bpf/bpftool/main.c | 12 ------------
 tools/bpf/bpftool/main.h |  3 ---
 tools/bpf/bpftool/map.c  |  9 ++++++++-
 tools/bpf/bpftool/prog.c |  9 ++++++++-
 5 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 8cc3e36f8cc6..ebf29be747b3 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -20,6 +20,8 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_NETNS]			= "netns",
 };
 
+static struct pinned_obj_table link_table;
+
 static int link_parse_fd(int *argc, char ***argv)
 {
 	int fd;
@@ -302,8 +304,10 @@ static int do_show(int argc, char **argv)
 	__u32 id = 0;
 	int err, fd;
 
-	if (show_pinned)
+	if (show_pinned) {
+		hash_init(link_table.table);
 		build_pinned_obj_table(&link_table, BPF_OBJ_LINK);
+	}
 	build_obj_refs_table(&refs_table, BPF_OBJ_LINK);
 
 	if (argc == 2) {
@@ -384,6 +388,9 @@ static int do_detach(int argc, char **argv)
 	if (json_output)
 		jsonw_null(json_wtr);
 
+	if (show_pinned)
+		delete_pinned_obj_table(&link_table);
+
 	return 0;
 }
 
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 02eaaf065f65..7a33f0e6da28 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -31,9 +31,6 @@ bool verifier_logs;
 bool relaxed_maps;
 bool use_loader;
 struct btf *base_btf;
-struct pinned_obj_table prog_table;
-struct pinned_obj_table map_table;
-struct pinned_obj_table link_table;
 struct obj_refs_table refs_table;
 
 static void __noreturn clean_and_exit(int i)
@@ -409,10 +406,6 @@ int main(int argc, char **argv)
 	block_mount = false;
 	bin_name = argv[0];
 
-	hash_init(prog_table.table);
-	hash_init(map_table.table);
-	hash_init(link_table.table);
-
 	opterr = 0;
 	while ((opt = getopt_long(argc, argv, "VhpjfLmndB:",
 				  options, NULL)) >= 0) {
@@ -479,11 +472,6 @@ int main(int argc, char **argv)
 	if (json_output)
 		jsonw_destroy(&json_wtr);
 
-	if (show_pinned) {
-		delete_pinned_obj_table(&prog_table);
-		delete_pinned_obj_table(&map_table);
-		delete_pinned_obj_table(&link_table);
-	}
 	btf__free(base_btf);
 
 	return ret;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 90caa42aac4c..baf607cd5924 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -91,9 +91,6 @@ extern bool verifier_logs;
 extern bool relaxed_maps;
 extern bool use_loader;
 extern struct btf *base_btf;
-extern struct pinned_obj_table prog_table;
-extern struct pinned_obj_table map_table;
-extern struct pinned_obj_table link_table;
 extern struct obj_refs_table refs_table;
 
 void __printf(1, 2) p_err(const char *fmt, ...);
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 407071d54ab1..0085039d9610 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -56,6 +56,8 @@ const char * const map_type_name[] = {
 
 const size_t map_type_name_size = ARRAY_SIZE(map_type_name);
 
+static struct pinned_obj_table map_table;
+
 static bool map_is_per_cpu(__u32 type)
 {
 	return type == BPF_MAP_TYPE_PERCPU_HASH ||
@@ -694,8 +696,10 @@ static int do_show(int argc, char **argv)
 	int err;
 	int fd;
 
-	if (show_pinned)
+	if (show_pinned) {
+		hash_init(map_table.table);
 		build_pinned_obj_table(&map_table, BPF_OBJ_MAP);
+	}
 	build_obj_refs_table(&refs_table, BPF_OBJ_MAP);
 
 	if (argc == 2)
@@ -742,6 +746,9 @@ static int do_show(int argc, char **argv)
 
 	delete_obj_refs_table(&refs_table);
 
+	if (show_pinned)
+		delete_pinned_obj_table(&map_table);
+
 	return errno == ENOENT ? 0 : -1;
 }
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 277d51c4c5d9..9a10cfebd252 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -84,6 +84,8 @@ static const char * const attach_type_strings[] = {
 	[__MAX_BPF_ATTACH_TYPE] = NULL,
 };
 
+static struct pinned_obj_table prog_table;
+
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
 	enum bpf_attach_type type;
@@ -565,8 +567,10 @@ static int do_show(int argc, char **argv)
 	int err;
 	int fd;
 
-	if (show_pinned)
+	if (show_pinned) {
+		hash_init(prog_table.table);
 		build_pinned_obj_table(&prog_table, BPF_OBJ_PROG);
+	}
 	build_obj_refs_table(&refs_table, BPF_OBJ_PROG);
 
 	if (argc == 2)
@@ -611,6 +615,9 @@ static int do_show(int argc, char **argv)
 
 	delete_obj_refs_table(&refs_table);
 
+	if (show_pinned)
+		delete_pinned_obj_table(&prog_table);
+
 	return err;
 }
 
-- 
2.30.2

