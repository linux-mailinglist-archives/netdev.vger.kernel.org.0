Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC50A53BAEA
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiFBOju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiFBOjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:39:32 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A7E1F5771;
        Thu,  2 Jun 2022 07:39:31 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT7R4bXcz686w8;
        Thu,  2 Jun 2022 22:34:59 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:39:27 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 5/9] bpftool: Add flags parameter to map_parse_fds()
Date:   Thu, 2 Jun 2022 16:37:44 +0200
Message-ID: <20220602143748.673971-6-roberto.sassu@huawei.com>
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

Add the flags parameter to map_parse_fds(), and the static function
map_fd_by_name() called by it. In the latter function, request the read
permission for the map search, and obtain a new file descriptor if the
flags variable has a different value.

Also pass the flags to the new functions bpf_map_get_fd_by_id_flags() and
the modified function open_obj_pinned_any().

At this point, there is still no change in the current behavior, as the
flags argument passed is always zero or the requested permission is a
subset (in map_fd_by_name()).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/common.c | 25 ++++++++++++++++++-------
 tools/bpf/bpftool/main.h   |  2 +-
 tools/bpf/bpftool/map.c    |  4 ++--
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 54246109516f..641810b78581 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -799,7 +799,7 @@ int prog_parse_fd(int *argc, char ***argv, __u32 flags)
 	return fd;
 }
 
-static int map_fd_by_name(char *name, int **fds)
+static int map_fd_by_name(char *name, int **fds, __u32 flags)
 {
 	unsigned int id = 0;
 	int fd, nb_fds = 0;
@@ -819,7 +819,7 @@ static int map_fd_by_name(char *name, int **fds)
 			return nb_fds;
 		}
 
-		fd = bpf_map_get_fd_by_id(id);
+		fd = bpf_map_get_fd_by_id_flags(id, BPF_F_RDONLY);
 		if (fd < 0) {
 			p_err("can't get map by id (%u): %s",
 			      id, strerror(errno));
@@ -838,6 +838,17 @@ static int map_fd_by_name(char *name, int **fds)
 			continue;
 		}
 
+		if (flags != BPF_F_RDONLY) {
+			close(fd);
+
+			fd = bpf_map_get_fd_by_id_flags(id, flags);
+			if (fd < 0) {
+				p_err("can't get map by id (%u): %s",
+				      id, strerror(errno));
+				goto err_close_fds;
+			}
+		}
+
 		if (nb_fds > 0) {
 			tmp = realloc(*fds, (nb_fds + 1) * sizeof(int));
 			if (!tmp) {
@@ -857,7 +868,7 @@ static int map_fd_by_name(char *name, int **fds)
 	return -1;
 }
 
-int map_parse_fds(int *argc, char ***argv, int **fds)
+int map_parse_fds(int *argc, char ***argv, int **fds, __u32 flags)
 {
 	if (is_prefix(**argv, "id")) {
 		unsigned int id;
@@ -872,7 +883,7 @@ int map_parse_fds(int *argc, char ***argv, int **fds)
 		}
 		NEXT_ARGP();
 
-		(*fds)[0] = bpf_map_get_fd_by_id(id);
+		(*fds)[0] = bpf_map_get_fd_by_id_flags(id, flags);
 		if ((*fds)[0] < 0) {
 			p_err("get map by id (%u): %s", id, strerror(errno));
 			return -1;
@@ -890,7 +901,7 @@ int map_parse_fds(int *argc, char ***argv, int **fds)
 		}
 		NEXT_ARGP();
 
-		return map_fd_by_name(name, fds);
+		return map_fd_by_name(name, fds, flags);
 	} else if (is_prefix(**argv, "pinned")) {
 		char *path;
 
@@ -899,7 +910,7 @@ int map_parse_fds(int *argc, char ***argv, int **fds)
 		path = **argv;
 		NEXT_ARGP();
 
-		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_MAP, 0);
+		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_MAP, flags);
 		if ((*fds)[0] < 0)
 			return -1;
 		return 1;
@@ -919,7 +930,7 @@ int map_parse_fd(int *argc, char ***argv, __u32 flags)
 		p_err("mem alloc failed");
 		return -1;
 	}
-	nb_fds = map_parse_fds(argc, argv, &fds);
+	nb_fds = map_parse_fds(argc, argv, &fds, flags);
 	if (nb_fds != 1) {
 		if (nb_fds > 1) {
 			p_err("several maps match this handle");
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index f342b2da4d8d..70b0ad6245b9 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -170,7 +170,7 @@ int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
 int prog_parse_fd(int *argc, char ***argv, __u32 flags);
 int prog_parse_fds(int *argc, char ***argv, int **fds);
 int map_parse_fd(int *argc, char ***argv, __u32 flags);
-int map_parse_fds(int *argc, char ***argv, int **fds);
+int map_parse_fds(int *argc, char ***argv, int **fds, __u32 flags);
 int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len);
 
 struct bpf_prog_linfo;
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index d1231dce7183..9a747918882e 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -634,7 +634,7 @@ static int do_show_subset(int argc, char **argv)
 		p_err("mem alloc failed");
 		return -1;
 	}
-	nb_fds = map_parse_fds(&argc, &argv, &fds);
+	nb_fds = map_parse_fds(&argc, &argv, &fds, 0);
 	if (nb_fds < 1)
 		goto exit_free;
 
@@ -910,7 +910,7 @@ static int do_dump(int argc, char **argv)
 		p_err("mem alloc failed");
 		return -1;
 	}
-	nb_fds = map_parse_fds(&argc, &argv, &fds);
+	nb_fds = map_parse_fds(&argc, &argv, &fds, 0);
 	if (nb_fds < 1)
 		goto exit_free;
 
-- 
2.25.1

