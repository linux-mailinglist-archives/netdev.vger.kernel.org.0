Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1F25B2E21
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 07:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiIIFea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 01:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIIFe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 01:34:28 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1458BD7A;
        Thu,  8 Sep 2022 22:34:26 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MP4MX5w1mzlVr2;
        Fri,  9 Sep 2022 13:30:32 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 13:34:22 +0800
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
Subject: [bpf-next 1/2] libbpf: Add make_path_and_pin() helper for bpf_xxx__pin()
Date:   Fri, 9 Sep 2022 13:45:45 +0800
Message-ID: <1662702346-29665-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move make path, check path and pin to the common helper make_path_and_pin() to make
the code simpler.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 tools/lib/bpf/libbpf.c | 56 ++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3ad1392..5854b92 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7755,16 +7755,11 @@ static int check_path(const char *path)
 	return err;
 }
 
-int bpf_program__pin(struct bpf_program *prog, const char *path)
+static int make_path_and_pin(int fd, const char *path)
 {
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err;
 
-	if (prog->fd < 0) {
-		pr_warn("prog '%s': can't pin program that wasn't loaded\n", prog->name);
-		return libbpf_err(-EINVAL);
-	}
-
 	err = make_parent_dir(path);
 	if (err)
 		return libbpf_err(err);
@@ -7773,12 +7768,27 @@ int bpf_program__pin(struct bpf_program *prog, const char *path)
 	if (err)
 		return libbpf_err(err);
 
-	if (bpf_obj_pin(prog->fd, path)) {
+	if (bpf_obj_pin(fd, path)) {
 		err = -errno;
 		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-		pr_warn("prog '%s': failed to pin at '%s': %s\n", prog->name, path, cp);
+		pr_warn("failed to pin at '%s': %s\n", path, cp);
 		return libbpf_err(err);
 	}
+	return 0;
+}
+
+int bpf_program__pin(struct bpf_program *prog, const char *path)
+{
+	int err;
+
+	if (prog->fd < 0) {
+		pr_warn("prog '%s': can't pin program that wasn't loaded\n", prog->name);
+		return libbpf_err(-EINVAL);
+	}
+
+	err = make_path_and_pin(prog->fd, path);
+	if (err)
+		return libbpf_err(err);
 
 	pr_debug("prog '%s': pinned at '%s'\n", prog->name, path);
 	return 0;
@@ -7838,32 +7848,20 @@ int bpf_map__pin(struct bpf_map *map, const char *path)
 		map->pin_path = strdup(path);
 		if (!map->pin_path) {
 			err = -errno;
-			goto out_err;
+			cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
+			pr_warn("failed to pin map: %s\n", cp);
+			return libbpf_err(err);
 		}
 	}
 
-	err = make_parent_dir(map->pin_path);
-	if (err)
-		return libbpf_err(err);
-
-	err = check_path(map->pin_path);
+	err = make_path_and_pin(map->fd, map->pin_path);
 	if (err)
 		return libbpf_err(err);
 
-	if (bpf_obj_pin(map->fd, map->pin_path)) {
-		err = -errno;
-		goto out_err;
-	}
-
 	map->pinned = true;
 	pr_debug("pinned map '%s'\n", map->pin_path);
 
 	return 0;
-
-out_err:
-	cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
-	pr_warn("failed to pin map: %s\n", cp);
-	return libbpf_err(err);
 }
 
 int bpf_map__unpin(struct bpf_map *map, const char *path)
@@ -9611,19 +9609,13 @@ int bpf_link__pin(struct bpf_link *link, const char *path)
 
 	if (link->pin_path)
 		return libbpf_err(-EBUSY);
-	err = make_parent_dir(path);
-	if (err)
-		return libbpf_err(err);
-	err = check_path(path);
-	if (err)
-		return libbpf_err(err);
 
 	link->pin_path = strdup(path);
 	if (!link->pin_path)
 		return libbpf_err(-ENOMEM);
 
-	if (bpf_obj_pin(link->fd, link->pin_path)) {
-		err = -errno;
+	err = make_path_and_pin(link->fd, path);
+	if (err) {
 		zfree(&link->pin_path);
 		return libbpf_err(err);
 	}
-- 
1.8.3.1

