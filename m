Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B0253BB01
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiFBOjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiFBOjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:39:33 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2582326D356;
        Thu,  2 Jun 2022 07:39:32 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT8k1lX6z67M3B;
        Thu,  2 Jun 2022 22:36:06 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:39:29 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 8/9] bpftool: Adjust map permissions
Date:   Thu, 2 Jun 2022 16:37:47 +0200
Message-ID: <20220602143748.673971-9-roberto.sassu@huawei.com>
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

Request a read file descriptor for:
- map subcommands: show_subset, show, dump, lookup, getnext and pin;
- btf subcommand: dump;
- prog subcommand: show (metadata);
- struct_ops subcommands: show and dump;
- do_build_table_cb(), to show the path of a pinned map.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/btf.c        |  5 +++--
 tools/bpf/bpftool/common.c     |  5 +++--
 tools/bpf/bpftool/map.c        | 10 +++++-----
 tools/bpf/bpftool/prog.c       |  2 +-
 tools/bpf/bpftool/struct_ops.c |  4 ++--
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 69a7695030f9..a36710903549 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -529,7 +529,8 @@ static int do_dump(int argc, char **argv)
 			return -1;
 		}
 
-		fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
+		fd = map_parse_fd_and_info(&argc, &argv, &info, &len,
+					   BPF_F_RDONLY);
 		if (fd < 0)
 			return -1;
 
@@ -730,7 +731,7 @@ build_btf_type_table(struct hashmap *tab, enum bpf_obj_type type,
 			fd = bpf_prog_get_fd_by_id(id);
 			break;
 		case BPF_OBJ_MAP:
-			fd = bpf_map_get_fd_by_id(id);
+			fd = bpf_map_get_fd_by_id_flags(id, BPF_F_RDONLY);
 			break;
 		default:
 			err = -1;
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 0816ea2f0be1..d20e1fa8a5fd 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -228,7 +228,7 @@ int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***, __u32))
 	int err;
 	int fd;
 
-	fd = get_fd(&argc, &argv, 0);
+	fd = get_fd(&argc, &argv, BPF_F_RDONLY);
 	if (fd < 0)
 		return fd;
 
@@ -401,7 +401,8 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
 	if (typeflag != FTW_F)
 		goto out_ret;
 
-	fd = open_obj_pinned(fpath, true, 0);
+	/* WARNING: setting flags to BPF_F_RDONLY has effect only for maps. */
+	fd = open_obj_pinned(fpath, true, BPF_F_RDONLY);
 	if (fd < 0)
 		goto out_ret;
 
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index f253f69879a9..e4346c834e07 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -634,7 +634,7 @@ static int do_show_subset(int argc, char **argv)
 		p_err("mem alloc failed");
 		return -1;
 	}
-	nb_fds = map_parse_fds(&argc, &argv, &fds, 0);
+	nb_fds = map_parse_fds(&argc, &argv, &fds, BPF_F_RDONLY);
 	if (nb_fds < 1)
 		goto exit_free;
 
@@ -702,7 +702,7 @@ static int do_show(int argc, char **argv)
 			break;
 		}
 
-		fd = bpf_map_get_fd_by_id(id);
+		fd = bpf_map_get_fd_by_id_flags(id, BPF_F_RDONLY);
 		if (fd < 0) {
 			if (errno == ENOENT)
 				continue;
@@ -910,7 +910,7 @@ static int do_dump(int argc, char **argv)
 		p_err("mem alloc failed");
 		return -1;
 	}
-	nb_fds = map_parse_fds(&argc, &argv, &fds, 0);
+	nb_fds = map_parse_fds(&argc, &argv, &fds, BPF_F_RDONLY);
 	if (nb_fds < 1)
 		goto exit_free;
 
@@ -1077,7 +1077,7 @@ static int do_lookup(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, BPF_F_RDONLY);
 	if (fd < 0)
 		return -1;
 
@@ -1128,7 +1128,7 @@ static int do_getnext(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, BPF_F_RDONLY);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 05480bf26a00..58d573badcb4 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -251,7 +251,7 @@ static void *find_metadata(int prog_fd, struct bpf_map_info *map_info)
 		goto free_map_ids;
 
 	for (i = 0; i < prog_info.nr_map_ids; i++) {
-		map_fd = bpf_map_get_fd_by_id(map_ids[i]);
+		map_fd = bpf_map_get_fd_by_id_flags(map_ids[i], BPF_F_RDONLY);
 		if (map_fd < 0)
 			goto free_map_ids;
 
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index e8252a76e115..ced5fe62b1d7 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -359,7 +359,7 @@ static int do_show(int argc, char **argv)
 	}
 
 	res = do_work_on_struct_ops(search_type, search_term, __do_show,
-				    NULL, json_wtr, 0);
+				    NULL, json_wtr, BPF_F_RDONLY);
 
 	return cmd_retval(&res, !!search_term);
 }
@@ -448,7 +448,7 @@ static int do_dump(int argc, char **argv)
 	d.prog_id_as_func_ptr = true;
 
 	res = do_work_on_struct_ops(search_type, search_term, __do_dump, &d,
-				    wtr, 0);
+				    wtr, BPF_F_RDONLY);
 
 	if (!json_output)
 		jsonw_destroy(&wtr);
-- 
2.25.1

