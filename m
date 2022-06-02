Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8353BAFC
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiFBOjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiFBOjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:39:32 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD581DAF2E;
        Thu,  2 Jun 2022 07:39:30 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT8h64Z9z686LZ;
        Thu,  2 Jun 2022 22:36:04 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:39:28 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 6/9] bpftool: Add flags parameter to map_parse_fd_and_info()
Date:   Thu, 2 Jun 2022 16:37:45 +0200
Message-ID: <20220602143748.673971-7-roberto.sassu@huawei.com>
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

Add the flags parameter to map_parse_fd_and_info(), as this function is
called directly by the functions implementing bpftool subcommands, so that
it is possible to specify the right permissions for accessing a map.

Still pass zero as value for flags, and adjust permissions in a later
patch.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/btf.c           |  2 +-
 tools/bpf/bpftool/common.c        |  5 +++--
 tools/bpf/bpftool/main.h          |  3 ++-
 tools/bpf/bpftool/map.c           | 12 ++++++------
 tools/bpf/bpftool/map_perf_ring.c |  3 ++-
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 98569252ef4a..69a7695030f9 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -529,7 +529,7 @@ static int do_dump(int argc, char **argv)
 			return -1;
 		}
 
-		fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+		fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
 		if (fd < 0)
 			return -1;
 
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 641810b78581..0816ea2f0be1 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -947,12 +947,13 @@ int map_parse_fd(int *argc, char ***argv, __u32 flags)
 	return fd;
 }
 
-int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len)
+int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len,
+			  __u32 flags)
 {
 	int err;
 	int fd;
 
-	fd = map_parse_fd(argc, argv, 0);
+	fd = map_parse_fd(argc, argv, flags);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 70b0ad6245b9..46c2f24f66fd 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -171,7 +171,8 @@ int prog_parse_fd(int *argc, char ***argv, __u32 flags);
 int prog_parse_fds(int *argc, char ***argv, int **fds);
 int map_parse_fd(int *argc, char ***argv, __u32 flags);
 int map_parse_fds(int *argc, char ***argv, int **fds, __u32 flags);
-int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len);
+int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len,
+			  __u32 flags);
 
 struct bpf_prog_linfo;
 #ifdef HAVE_LIBBFD_SUPPORT
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 9a747918882e..f253f69879a9 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -998,7 +998,7 @@ static int do_update(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
 	if (fd < 0)
 		return -1;
 
@@ -1077,7 +1077,7 @@ static int do_lookup(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
 	if (fd < 0)
 		return -1;
 
@@ -1128,7 +1128,7 @@ static int do_getnext(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
 	if (fd < 0)
 		return -1;
 
@@ -1199,7 +1199,7 @@ static int do_delete(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
 	if (fd < 0)
 		return -1;
 
@@ -1311,7 +1311,7 @@ static int do_create(int argc, char **argv)
 			if (!REQ_ARGS(2))
 				usage();
 			inner_map_fd = map_parse_fd_and_info(&argc, &argv,
-							     &info, &len);
+							     &info, &len, 0);
 			if (inner_map_fd < 0)
 				return -1;
 			attr.inner_map_fd = inner_map_fd;
@@ -1358,7 +1358,7 @@ static int do_pop_dequeue(int argc, char **argv)
 	if (argc < 2)
 		usage();
 
-	fd = map_parse_fd_and_info(&argc, &argv, &info, &len);
+	fd = map_parse_fd_and_info(&argc, &argv, &info, &len, 0);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index 6b0c410152de..dcfc4724cd8d 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -135,7 +135,8 @@ int do_event_pipe(int argc, char **argv)
 	int err, map_fd;
 
 	map_info_len = sizeof(map_info);
-	map_fd = map_parse_fd_and_info(&argc, &argv, &map_info, &map_info_len);
+	map_fd = map_parse_fd_and_info(&argc, &argv, &map_info, &map_info_len,
+				       0);
 	if (map_fd < 0)
 		return -1;
 
-- 
2.25.1

