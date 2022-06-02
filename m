Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F91E53BAFB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiFBOi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbiFBOiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:38:14 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AFE1A8E29;
        Thu,  2 Jun 2022 07:38:08 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT761sbfz67sRl;
        Thu,  2 Jun 2022 22:34:42 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:38:05 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 3/9] bpftool: Add flags parameter to open_obj_pinned_any() and open_obj_pinned()
Date:   Thu, 2 Jun 2022 16:37:42 +0200
Message-ID: <20220602143748.673971-4-roberto.sassu@huawei.com>
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

Add the flags parameter to open_obj_pinned_any() and open_obj_pinned(), so
that it is possible to specify the right permissions when obtaining a file
descriptor from a pinned object.

By default, the value passed to those functions is zero, so that there is
no change in the current behavior.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/common.c | 15 ++++++++-------
 tools/bpf/bpftool/link.c   |  2 +-
 tools/bpf/bpftool/main.h   |  5 +++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index a45b42ee8ab0..88e5e1900270 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -118,7 +118,7 @@ int mount_tracefs(const char *target)
 	return err;
 }
 
-int open_obj_pinned(const char *path, bool quiet)
+int open_obj_pinned(const char *path, bool quiet, __u32 flags)
 {
 	char *pname;
 	int fd = -1;
@@ -130,7 +130,7 @@ int open_obj_pinned(const char *path, bool quiet)
 		goto out_ret;
 	}
 
-	fd = bpf_obj_get(pname);
+	fd = bpf_obj_get_flags(pname, flags);
 	if (fd < 0) {
 		if (!quiet)
 			p_err("bpf obj get (%s): %s", pname,
@@ -146,12 +146,13 @@ int open_obj_pinned(const char *path, bool quiet)
 	return fd;
 }
 
-int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type)
+int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type,
+			__u32 flags)
 {
 	enum bpf_obj_type type;
 	int fd;
 
-	fd = open_obj_pinned(path, false);
+	fd = open_obj_pinned(path, false, flags);
 	if (fd < 0)
 		return -1;
 
@@ -400,7 +401,7 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
 	if (typeflag != FTW_F)
 		goto out_ret;
 
-	fd = open_obj_pinned(fpath, true);
+	fd = open_obj_pinned(fpath, true, 0);
 	if (fd < 0)
 		goto out_ret;
 
@@ -761,7 +762,7 @@ int prog_parse_fds(int *argc, char ***argv, int **fds)
 		path = **argv;
 		NEXT_ARGP();
 
-		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_PROG);
+		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_PROG, 0);
 		if ((*fds)[0] < 0)
 			return -1;
 		return 1;
@@ -898,7 +899,7 @@ int map_parse_fds(int *argc, char ***argv, int **fds)
 		path = **argv;
 		NEXT_ARGP();
 
-		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_MAP);
+		(*fds)[0] = open_obj_pinned_any(path, BPF_OBJ_MAP, 0);
 		if ((*fds)[0] < 0)
 			return -1;
 		return 1;
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 7a20931c3250..04447ad9b3b3 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -44,7 +44,7 @@ static int link_parse_fd(int *argc, char ***argv)
 		path = **argv;
 		NEXT_ARGP();
 
-		return open_obj_pinned_any(path, BPF_OBJ_LINK);
+		return open_obj_pinned_any(path, BPF_OBJ_LINK, 0);
 	}
 
 	p_err("expected 'id' or 'pinned', got: '%s'?", **argv);
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 6c311f47147e..3f6c03afb2f8 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -141,8 +141,9 @@ void get_prog_full_name(const struct bpf_prog_info *prog_info, int prog_fd,
 int get_fd_type(int fd);
 const char *get_fd_type_name(enum bpf_obj_type type);
 char *get_fdinfo(int fd, const char *key);
-int open_obj_pinned(const char *path, bool quiet);
-int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type);
+int open_obj_pinned(const char *path, bool quiet, __u32 flags);
+int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type,
+			__u32 flags);
 int mount_bpffs_for_pin(const char *name);
 int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(int *, char ***));
 int do_pin_fd(int fd, const char *name);
-- 
2.25.1

