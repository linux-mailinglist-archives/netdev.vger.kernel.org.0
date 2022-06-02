Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E1A53BADB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiFBOjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbiFBOjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:39:33 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836FE20E6F0;
        Thu,  2 Jun 2022 07:39:31 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT7T0DS0z688Mj;
        Thu,  2 Jun 2022 22:35:01 +0800 (CST)
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
Subject: [PATCH v2 7/9] bpftool: Add flags parameter in struct_ops functions
Date:   Thu, 2 Jun 2022 16:37:46 +0200
Message-ID: <20220602143748.673971-8-roberto.sassu@huawei.com>
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

Add the flags parameter to struct_ops functions, to distinguish between
read-like and write-like operations on struct_ops maps.

Also, always perform the search with read-only permission, and eventually
obtain a new file descriptor if the requested permission is different.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/struct_ops.c | 39 +++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index 2535f079ed67..e8252a76e115 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -130,7 +130,8 @@ static struct bpf_map_info *map_info_alloc(__u32 *alloc_len)
  *    -1: Error and the caller should abort the iteration.
  */
 static int get_next_struct_ops_map(const char *name, int *res_fd,
-				   struct bpf_map_info *info, __u32 info_len)
+				   struct bpf_map_info *info, __u32 info_len,
+				   __u32 flags)
 {
 	__u32 id = info->id;
 	int err, fd;
@@ -144,7 +145,7 @@ static int get_next_struct_ops_map(const char *name, int *res_fd,
 			return -1;
 		}
 
-		fd = bpf_map_get_fd_by_id(id);
+		fd = bpf_map_get_fd_by_id_flags(id, BPF_F_RDONLY);
 		if (fd < 0) {
 			if (errno == ENOENT)
 				continue;
@@ -162,6 +163,19 @@ static int get_next_struct_ops_map(const char *name, int *res_fd,
 
 		if (info->type == BPF_MAP_TYPE_STRUCT_OPS &&
 		    (!name || !strcmp(name, info->name))) {
+			if (flags != BPF_F_RDONLY) {
+				close(fd);
+
+				fd = bpf_map_get_fd_by_id_flags(id, flags);
+				if (fd < 0) {
+					if (errno == ENOENT)
+						continue;
+					p_err("can't get map by id (%u): %s",
+					      id, strerror(errno));
+					return -1;
+				}
+			}
+
 			*res_fd = fd;
 			return 1;
 		}
@@ -186,7 +200,7 @@ typedef int (*work_func)(int fd, const struct bpf_map_info *info, void *data,
  * Then call "func(fd, info, data, wtr)" on each struct_ops map found.
  */
 static struct res do_search(const char *name, work_func func, void *data,
-			    struct json_writer *wtr)
+			    struct json_writer *wtr, __u32 flags)
 {
 	struct bpf_map_info *info;
 	struct res res = {};
@@ -201,7 +215,8 @@ static struct res do_search(const char *name, work_func func, void *data,
 
 	if (wtr)
 		jsonw_start_array(wtr);
-	while ((err = get_next_struct_ops_map(name, &fd, info, info_len)) == 1) {
+	while ((err = get_next_struct_ops_map(name, &fd, info, info_len,
+					      flags)) == 1) {
 		res.nr_maps++;
 		err = func(fd, info, data, wtr);
 		if (err)
@@ -235,7 +250,7 @@ static struct res do_search(const char *name, work_func func, void *data,
 }
 
 static struct res do_one_id(const char *id_str, work_func func, void *data,
-			    struct json_writer *wtr)
+			    struct json_writer *wtr, __u32 flags)
 {
 	struct bpf_map_info *info;
 	struct res res = {};
@@ -251,7 +266,7 @@ static struct res do_one_id(const char *id_str, work_func func, void *data,
 		return res;
 	}
 
-	fd = bpf_map_get_fd_by_id(id);
+	fd = bpf_map_get_fd_by_id_flags(id, flags);
 	if (fd < 0) {
 		p_err("can't get map by id (%lu): %s", id, strerror(errno));
 		res.nr_errs++;
@@ -300,16 +315,16 @@ static struct res do_one_id(const char *id_str, work_func func, void *data,
 static struct res do_work_on_struct_ops(const char *search_type,
 					const char *search_term,
 					work_func func, void *data,
-					struct json_writer *wtr)
+					struct json_writer *wtr, __u32 flags)
 {
 	if (search_type) {
 		if (is_prefix(search_type, "id"))
-			return do_one_id(search_term, func, data, wtr);
+			return do_one_id(search_term, func, data, wtr, flags);
 		else if (!is_prefix(search_type, "name"))
 			usage();
 	}
 
-	return do_search(search_term, func, data, wtr);
+	return do_search(search_term, func, data, wtr, flags);
 }
 
 static int __do_show(int fd, const struct bpf_map_info *info, void *data,
@@ -344,7 +359,7 @@ static int do_show(int argc, char **argv)
 	}
 
 	res = do_work_on_struct_ops(search_type, search_term, __do_show,
-				    NULL, json_wtr);
+				    NULL, json_wtr, 0);
 
 	return cmd_retval(&res, !!search_term);
 }
@@ -433,7 +448,7 @@ static int do_dump(int argc, char **argv)
 	d.prog_id_as_func_ptr = true;
 
 	res = do_work_on_struct_ops(search_type, search_term, __do_dump, &d,
-				    wtr);
+				    wtr, 0);
 
 	if (!json_output)
 		jsonw_destroy(&wtr);
@@ -472,7 +487,7 @@ static int do_unregister(int argc, char **argv)
 	search_term = GET_ARG();
 
 	res = do_work_on_struct_ops(search_type, search_term,
-				    __do_unregister, NULL, NULL);
+				    __do_unregister, NULL, NULL, 0);
 
 	return cmd_retval(&res, true);
 }
-- 
2.25.1

