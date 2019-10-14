Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD6D6C2F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfJNXth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:49:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14038 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfJNXtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 19:49:36 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ENjJSE009549
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=9NiqP/SxrzkTuCPDhTFY1vRREyUPFvxlki5B76Oqaoo=;
 b=cBYmO04ho1WGcIBriUFGpoQTlQKeMOs1MQPezVjvmbgNya1hVe2bQeBE1Lpj3m9hQqC3
 CA9bapY2CoLpDX1f3BAYzxxIsc3WZC2mYQ146rey6Q9/hqiV3RopNzeHy9DLXD6f5bxY
 ENNc0Cyp1H16ZvLULMoPUnp6tMrWYTSzPzU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vkxgeq0xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:35 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 14 Oct 2019 16:49:35 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 90B6E8618F6; Mon, 14 Oct 2019 16:49:34 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/5] libbpf: refactor bpf_object__open APIs to use common opts
Date:   Mon, 14 Oct 2019 16:49:25 -0700
Message-ID: <20191014234928.561043-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191014234928.561043-1-andriin@fb.com>
References: <20191014234928.561043-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_11:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor all the various bpf_object__open variations to ultimately
specify common bpf_object_open_opts struct. This makes it easy to keep
extending this common struct w/ extra parameters without having to
update all the legacy APIs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 71 +++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d6c7699de405..db3308b91806 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1322,9 +1322,9 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, int flags)
+static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps)
 {
-	bool strict = !(flags & MAPS_RELAX_COMPAT);
+	bool strict = !relaxed_maps;
 	int err;
 
 	err = bpf_object__init_user_maps(obj, strict);
@@ -1521,7 +1521,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
+static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps)
 {
 	Elf *elf = obj->efile.elf;
 	GElf_Ehdr *ep = &obj->efile.ehdr;
@@ -1652,7 +1652,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 	}
 	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
 	if (!err)
-		err = bpf_object__init_maps(obj, flags);
+		err = bpf_object__init_maps(obj, relaxed_maps);
 	if (!err)
 		err = bpf_object__sanitize_and_load_btf(obj);
 	if (!err)
@@ -3554,24 +3554,45 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
-		   const char *obj_name, int flags)
+		   struct bpf_object_open_opts *opts)
 {
 	struct bpf_object *obj;
+	const char *obj_name;
+	char tmp_name[64];
+	bool relaxed_maps;
 	int err;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
-		pr_warning("failed to init libelf for %s\n", path);
+		pr_warning("failed to init libelf for %s\n",
+			   path ? : "(mem buf)");
 		return ERR_PTR(-LIBBPF_ERRNO__LIBELF);
 	}
 
+	if (!OPTS_VALID(opts, bpf_object_open_opts))
+		return ERR_PTR(-EINVAL);
+
+	obj_name = OPTS_GET(opts, object_name, path);
+	if (obj_buf) {
+		if (!obj_name) {
+			snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
+				 (unsigned long)obj_buf,
+				 (unsigned long)obj_buf_sz);
+			obj_name = tmp_name;
+		}
+		path = obj_name;
+		pr_debug("loading object '%s' from buffer\n", obj_name);
+	}
+
 	obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
 	if (IS_ERR(obj))
 		return obj;
 
+	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
+
 	CHECK_ERR(bpf_object__elf_init(obj), err, out);
 	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
 	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
-	CHECK_ERR(bpf_object__elf_collect(obj, flags), err, out);
+	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps), err, out);
 	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
 
 	bpf_object__elf_finish(obj);
@@ -3584,13 +3605,16 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 static struct bpf_object *
 __bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags)
 {
+	LIBBPF_OPTS(bpf_object_open_opts, opts,
+		.relaxed_maps = flags & MAPS_RELAX_COMPAT,
+	);
+
 	/* param validation */
 	if (!attr->file)
 		return NULL;
 
 	pr_debug("loading %s\n", attr->file);
-
-	return __bpf_object__open(attr->file, NULL, 0, NULL, flags);
+	return __bpf_object__open(attr->file, NULL, 0, &opts);
 }
 
 struct bpf_object *bpf_object__open_xattr(struct bpf_object_open_attr *attr)
@@ -3611,47 +3635,22 @@ struct bpf_object *bpf_object__open(const char *path)
 struct bpf_object *
 bpf_object__open_file(const char *path, struct bpf_object_open_opts *opts)
 {
-	const char *obj_name;
-	bool relaxed_maps;
-
-	if (!OPTS_VALID(opts, bpf_object_open_opts))
-		return ERR_PTR(-EINVAL);
 	if (!path)
 		return ERR_PTR(-EINVAL);
 
 	pr_debug("loading %s\n", path);
 
-	obj_name = OPTS_GET(opts, object_name, path);
-	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
-	return __bpf_object__open(path, NULL, 0, obj_name,
-				  relaxed_maps ? MAPS_RELAX_COMPAT : 0);
+	return __bpf_object__open(path, NULL, 0, opts);
 }
 
 struct bpf_object *
 bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
 		     struct bpf_object_open_opts *opts)
 {
-	char tmp_name[64];
-	const char *obj_name;
-	bool relaxed_maps;
-
-	if (!OPTS_VALID(opts, bpf_object_open_opts))
-		return ERR_PTR(-EINVAL);
 	if (!obj_buf || obj_buf_sz == 0)
 		return ERR_PTR(-EINVAL);
 
-	obj_name = OPTS_GET(opts, object_name, NULL);
-	if (!obj_name) {
-		snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
-			 (unsigned long)obj_buf,
-			 (unsigned long)obj_buf_sz);
-		obj_name = tmp_name;
-	}
-	pr_debug("loading object '%s' from buffer\n", obj_name);
-
-	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
-	return __bpf_object__open(obj_name, obj_buf, obj_buf_sz, obj_name,
-				  relaxed_maps ? MAPS_RELAX_COMPAT : 0);
+	return __bpf_object__open(NULL, obj_buf, obj_buf_sz, opts);
 }
 
 struct bpf_object *
-- 
2.17.1

