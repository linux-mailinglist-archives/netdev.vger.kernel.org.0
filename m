Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC75BC15A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 04:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiISC2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 22:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiISC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 22:28:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667B914D32;
        Sun, 18 Sep 2022 19:28:08 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MW7nz05FqzHntN;
        Mon, 19 Sep 2022 10:25:59 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 10:28:05 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <nathan@kernel.org>, <ndesaulniers@google.com>,
        <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
Subject: [bpf-next v3 1/2] libbpf: Add pathname_concat() helper
Date:   Mon, 19 Sep 2022 10:48:44 +0800
Message-ID: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move snprintf and len check to common helper pathname_concat() to make the
code simpler.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 47 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3ad1392..43a530d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2096,19 +2096,30 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
 	return true;
 }
 
+static int pathname_concat(const char *path, const char *name, char *buf, size_t buflen)
+{
+	int len;
+
+	len = snprintf(buf, buflen, "%s/%s", path, name);
+	if (len < 0)
+		return -EINVAL;
+	if (len >= buflen)
+		return -ENAMETOOLONG;
+
+	return 0;
+}
+
 static int build_map_pin_path(struct bpf_map *map, const char *path)
 {
 	char buf[PATH_MAX];
-	int len;
+	int err;
 
 	if (!path)
 		path = "/sys/fs/bpf";
 
-	len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
-	if (len < 0)
-		return -EINVAL;
-	else if (len >= PATH_MAX)
-		return -ENAMETOOLONG;
+	err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);
+	if (err)
+		return err;
 
 	return bpf_map__set_pin_path(map, buf);
 }
@@ -7961,17 +7972,9 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
 			continue;
 
 		if (path) {
-			int len;
-
-			len = snprintf(buf, PATH_MAX, "%s/%s", path,
-				       bpf_map__name(map));
-			if (len < 0) {
-				err = -EINVAL;
-				goto err_unpin_maps;
-			} else if (len >= PATH_MAX) {
-				err = -ENAMETOOLONG;
+			err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);
+			if (err)
 				goto err_unpin_maps;
-			}
 			sanitize_pin_path(buf);
 			pin_path = buf;
 		} else if (!map->pin_path) {
@@ -8009,14 +8012,9 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 		char buf[PATH_MAX];
 
 		if (path) {
-			int len;
-
-			len = snprintf(buf, PATH_MAX, "%s/%s", path,
-				       bpf_map__name(map));
-			if (len < 0)
-				return libbpf_err(-EINVAL);
-			else if (len >= PATH_MAX)
-				return libbpf_err(-ENAMETOOLONG);
+			err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);
+			if (err)
+				return err;
 			sanitize_pin_path(buf);
 			pin_path = buf;
 		} else if (!map->pin_path) {
@@ -8034,6 +8032,7 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
 int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 {
 	struct bpf_program *prog;
+	char buf[PATH_MAX];
 	int err;
 
 	if (!obj)
@@ -8045,17 +8044,9 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 	}
 
 	bpf_object__for_each_program(prog, obj) {
-		char buf[PATH_MAX];
-		int len;
-
-		len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
-		if (len < 0) {
-			err = -EINVAL;
-			goto err_unpin_programs;
-		} else if (len >= PATH_MAX) {
-			err = -ENAMETOOLONG;
+		err = pathname_concat(path, prog->name, buf, PATH_MAX);
+		if (err)
 			goto err_unpin_programs;
-		}
 
 		err = bpf_program__pin(prog, buf);
 		if (err)
@@ -8066,13 +8057,7 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
 
 err_unpin_programs:
 	while ((prog = bpf_object__prev_program(obj, prog))) {
-		char buf[PATH_MAX];
-		int len;
-
-		len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
-		if (len < 0)
-			continue;
-		else if (len >= PATH_MAX)
+		if (pathname_concat(path, prog->name, buf, PATH_MAX))
 			continue;
 
 		bpf_program__unpin(prog, buf);
@@ -8091,13 +8076,10 @@ int bpf_object__unpin_programs(struct bpf_object *obj, const char *path)
 
 	bpf_object__for_each_program(prog, obj) {
 		char buf[PATH_MAX];
-		int len;
 
-		len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
-		if (len < 0)
-			return libbpf_err(-EINVAL);
-		else if (len >= PATH_MAX)
-			return libbpf_err(-ENAMETOOLONG);
+		err = pathname_concat(path, prog->name, buf, PATH_MAX);
+		if (err)
+			return libbpf_err(err);
 
 		err = bpf_program__unpin(prog, buf);
 		if (err)
-- 
1.8.3.1

