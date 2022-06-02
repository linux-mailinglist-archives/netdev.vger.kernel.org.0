Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F3553BAF1
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiFBOiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbiFBOiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:38:15 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1064920E6F0;
        Thu,  2 Jun 2022 07:38:08 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT9y6C3pz6H6hX;
        Thu,  2 Jun 2022 22:37:10 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:38:06 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 4/9] bpftool: Add flags parameter to *_parse_fd() functions
Date:   Thu, 2 Jun 2022 16:37:43 +0200
Message-ID: <20220602143748.673971-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602143748.673971-1-roberto.sassu@huawei.com>
References: <20220602143748.673971-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the flags parameter to map_parse_fd(), prog_parse_fd(), link_parse_fd()
and btf_parse_fd() at the same time, as those functions are passed to
do_pin_any().

Pass zero to those functions, so that the current behavior does not change,
and adjust permissions in a later patch.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/btf.c    |  6 +++---
 tools/bpf/bpftool/cgroup.c |  4 ++--
 tools/bpf/bpftool/common.c | 10 +++++-----
 tools/bpf/bpftool/iter.c   |  2 +-
 tools/bpf/bpftool/link.c   |  7 ++++---
 tools/bpf/bpftool/main.h   |  7 ++++---
 tools/bpf/bpftool/map.c    |  6 +++---
 tools/bpf/bpftool/net.c    |  2 +-
 tools/bpf/bpftool/prog.c   | 10 +++++-----
 9 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 7e6accb9d9f7..98569252ef4a 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -559,7 +559,7 @@ static int do_dump(int argc, char **argv)
 			return -1;
 		}
 
-		fd = prog_parse_fd(&argc, &argv);
+		fd = prog_parse_fd(&argc, &argv, 0);
 		if (fd < 0)
 			return -1;
 
@@ -661,7 +661,7 @@ static int do_dump(int argc, char **argv)
 	return err;
 }
 
-static int btf_parse_fd(int *argc, char ***argv)
+static int btf_parse_fd(int *argc, char ***argv, __u32 flags)
 {
 	unsigned int id;
 	char *endptr;
@@ -931,7 +931,7 @@ static int do_show(int argc, char **argv)
 	__u32 id = 0;
 
 	if (argc == 2) {
-		fd = btf_parse_fd(&argc, &argv);
+		fd = btf_parse_fd(&argc, &argv, 0);
 		if (fd < 0)
 			return -1;
 	}
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 42421fe47a58..516d410a3218 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -425,7 +425,7 @@ static int do_attach(int argc, char **argv)
 
 	argc -= 2;
 	argv = &argv[2];
-	prog_fd = prog_parse_fd(&argc, &argv);
+	prog_fd = prog_parse_fd(&argc, &argv, 0);
 	if (prog_fd < 0)
 		goto exit_cgroup;
 
@@ -483,7 +483,7 @@ static int do_detach(int argc, char **argv)
 
 	argc -= 2;
 	argv = &argv[2];
-	prog_fd = prog_parse_fd(&argc, &argv);
+	prog_fd = prog_parse_fd(&argc, &argv, 0);
 	if (prog_fd < 0)
 		goto exit_cgroup;
 
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 88e5e1900270..54246109516f 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -223,12 +223,12 @@ int do_pin_fd(int fd, const char *name)
 	return err;
 }
 
-int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
+int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***, __u32))
 {
 	int err;
 	int fd;
 
-	fd = get_fd(&argc, &argv);
+	fd = get_fd(&argc, &argv, 0);
 	if (fd < 0)
 		return fd;
 
@@ -772,7 +772,7 @@ int prog_parse_fds(int *argc, char ***argv, int **fds)
 	return -1;
 }
 
-int prog_parse_fd(int *argc, char ***argv)
+int prog_parse_fd(int *argc, char ***argv, __u32 flags)
 {
 	int *fds = NULL;
 	int nb_fds, fd;
@@ -909,7 +909,7 @@ int map_parse_fds(int *argc, char ***argv, int **fds)
 	return -1;
 }
 
-int map_parse_fd(int *argc, char ***argv)
+int map_parse_fd(int *argc, char ***argv, __u32 flags)
 {
 	int *fds = NULL;
 	int nb_fds, fd;
@@ -941,7 +941,7 @@ int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len)
 	int err;
 	int fd;
 
-	fd = map_parse_fd(argc, argv);
+	fd = map_parse_fd(argc, argv, 0);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index f88fdc820d23..f7a35947f4f6 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -34,7 +34,7 @@ static int do_pin(int argc, char **argv)
 				return -1;
 			}
 
-			map_fd = map_parse_fd(&argc, &argv);
+			map_fd = map_parse_fd(&argc, &argv, 0);
 			if (map_fd < 0)
 				return -1;
 
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 04447ad9b3b3..61bc6f1473ed 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -15,7 +15,7 @@
 
 static struct hashmap *link_table;
 
-static int link_parse_fd(int *argc, char ***argv)
+static int link_parse_fd(int *argc, char ***argv, __u32 flags)
 {
 	int fd;
 
@@ -44,6 +44,7 @@ static int link_parse_fd(int *argc, char ***argv)
 		path = **argv;
 		NEXT_ARGP();
 
+		/* WARNING: flags not passed for links (no security hook). */
 		return open_obj_pinned_any(path, BPF_OBJ_LINK, 0);
 	}
 
@@ -321,7 +322,7 @@ static int do_show(int argc, char **argv)
 	build_obj_refs_table(&refs_table, BPF_OBJ_LINK);
 
 	if (argc == 2) {
-		fd = link_parse_fd(&argc, &argv);
+		fd = link_parse_fd(&argc, &argv, 0);
 		if (fd < 0)
 			return fd;
 		return do_show_link(fd);
@@ -385,7 +386,7 @@ static int do_detach(int argc, char **argv)
 		return 1;
 	}
 
-	fd = link_parse_fd(&argc, &argv);
+	fd = link_parse_fd(&argc, &argv, 0);
 	if (fd < 0)
 		return 1;
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 3f6c03afb2f8..f342b2da4d8d 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -145,7 +145,8 @@ int open_obj_pinned(const char *path, bool quiet, __u32 flags);
 int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type,
 			__u32 flags);
 int mount_bpffs_for_pin(const char *name);
-int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(int *, char ***));
+int do_pin_any(int argc, char **argv,
+	       int (*get_fd_by_id)(int *, char ***, __u32));
 int do_pin_fd(int fd, const char *name);
 
 /* commands available in bootstrap mode */
@@ -166,9 +167,9 @@ int do_struct_ops(int argc, char **argv) __weak;
 int do_iter(int argc, char **argv) __weak;
 
 int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
-int prog_parse_fd(int *argc, char ***argv);
+int prog_parse_fd(int *argc, char ***argv, __u32 flags);
 int prog_parse_fds(int *argc, char ***argv, int **fds);
-int map_parse_fd(int *argc, char ***argv);
+int map_parse_fd(int *argc, char ***argv, __u32 flags);
 int map_parse_fds(int *argc, char ***argv, int **fds);
 int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len);
 
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 800834be1bcb..d1231dce7183 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -381,7 +381,7 @@ static int parse_elem(char **argv, struct bpf_map_info *info,
 				return -1;
 			}
 
-			fd = map_parse_fd(&argc, &argv);
+			fd = map_parse_fd(&argc, &argv, 0);
 			if (fd < 0)
 				return -1;
 
@@ -402,7 +402,7 @@ static int parse_elem(char **argv, struct bpf_map_info *info,
 				p_info("Warning: updating program array via MAP_ID, make sure this map is kept open\n"
 				       "         by some process or pinned otherwise update will be lost");
 
-			fd = prog_parse_fd(&argc, &argv);
+			fd = prog_parse_fd(&argc, &argv, 0);
 			if (fd < 0)
 				return -1;
 
@@ -1397,7 +1397,7 @@ static int do_freeze(int argc, char **argv)
 	if (!REQ_ARGS(2))
 		return -1;
 
-	fd = map_parse_fd(&argc, &argv);
+	fd = map_parse_fd(&argc, &argv, 0);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 526a332c48e6..32360e07a6fa 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -571,7 +571,7 @@ static int do_attach(int argc, char **argv)
 	}
 	NEXT_ARG();
 
-	progfd = prog_parse_fd(&argc, &argv);
+	progfd = prog_parse_fd(&argc, &argv, 0);
 	if (progfd < 0)
 		return -EINVAL;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e71f0b2da50b..05480bf26a00 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1027,7 +1027,7 @@ static int parse_attach_detach_args(int argc, char **argv, int *progfd,
 	if (!REQ_ARGS(3))
 		return -EINVAL;
 
-	*progfd = prog_parse_fd(&argc, &argv);
+	*progfd = prog_parse_fd(&argc, &argv, 0);
 	if (*progfd < 0)
 		return *progfd;
 
@@ -1046,7 +1046,7 @@ static int parse_attach_detach_args(int argc, char **argv, int *progfd,
 	if (!REQ_ARGS(2))
 		return -EINVAL;
 
-	*mapfd = map_parse_fd(&argc, &argv);
+	*mapfd = map_parse_fd(&argc, &argv, 0);
 	if (*mapfd < 0)
 		return *mapfd;
 
@@ -1270,7 +1270,7 @@ static int do_run(int argc, char **argv)
 	if (!REQ_ARGS(4))
 		return -1;
 
-	fd = prog_parse_fd(&argc, &argv);
+	fd = prog_parse_fd(&argc, &argv, 0);
 	if (fd < 0)
 		return -1;
 
@@ -1542,7 +1542,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			}
 			NEXT_ARG();
 
-			fd = map_parse_fd(&argc, &argv);
+			fd = map_parse_fd(&argc, &argv, 0);
 			if (fd < 0)
 				goto err_free_reuse_maps;
 
@@ -2231,7 +2231,7 @@ static int do_profile(int argc, char **argv)
 		return -EINVAL;
 
 	/* parse target fd */
-	profile_tgt_fd = prog_parse_fd(&argc, &argv);
+	profile_tgt_fd = prog_parse_fd(&argc, &argv, 0);
 	if (profile_tgt_fd < 0) {
 		p_err("failed to parse fd");
 		return -1;
-- 
2.25.1

