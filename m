Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE875125872
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLSA2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:28:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbfLSA2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:28:48 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ0Pgfj010546
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xQmhQVN+6uTCrBp2bhLNi4ge5LOqL9Y8ZJCTGrWVN7A=;
 b=h5OCjdtD455nNifX1MXXM/b4+H/hIPFHFdOOcBSqN44uoQyXKuQFM3jJcgrrBLYhq7Sa
 l++fGS/riQX3MZW5Tp2l0oq47/w1DOOmu21rGRu4v0HoWxlJtpt4FlHysdDrM7zo7G63
 grdE7u7cobI9L15CZuoeZctP3zTVnF8r4P4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy61t6rks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:46 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 16:28:44 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1CE152EC18AF; Wed, 18 Dec 2019 16:28:43 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] libbpf: allow to augment system Kconfig through extra optional config
Date:   Wed, 18 Dec 2019 16:28:35 -0800
Message-ID: <20191219002837.3074619-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219002837.3074619-1-andriin@fb.com>
References: <20191219002837.3074619-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=8
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of all or nothing approach of overriding Kconfig file location, allow
to extend it with extra values and override chosen subset of values though
optional user-provided extra config, passed as a string through open options'
.kconfig option. If same config key is present in both user-supplied config
and Kconfig, user-supplied one wins. This allows applications to more easily
test various conditions despite host kernel's real configuration. If all of
BPF object's __kconfig externs are satisfied from user-supplied config, system
Kconfig won't be read at all.

Simplify selftests by not needing to create temporary Kconfig files.

Suggested-by: Alexei Starovoitov <ast@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 204 +++++++++++-------
 tools/lib/bpf/libbpf.h                        |   8 +-
 .../selftests/bpf/prog_tests/core_extern.c    |  32 +--
 3 files changed, 132 insertions(+), 112 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ed54a6a7f6f2..f90db2b18e4b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -302,7 +302,7 @@ struct bpf_object {
 	size_t nr_maps;
 	size_t maps_cap;
 
-	char *kconfig_path;
+	char *kconfig;
 	struct extern_desc *externs;
 	int nr_extern;
 	int kconfig_map_idx;
@@ -1149,98 +1149,129 @@ static int set_ext_value_num(struct extern_desc *ext, void *ext_val,
 	return 0;
 }
 
-static int bpf_object__read_kernel_config(struct bpf_object *obj,
-					  const char *config_path,
-					  void *data)
+static int bpf_object__process_kconfig_line(struct bpf_object *obj,
+					    char *buf, void *data)
 {
-	char buf[PATH_MAX], *sep, *value;
 	struct extern_desc *ext;
+	char *sep, *value;
 	int len, err = 0;
 	void *ext_val;
 	__u64 num;
-	gzFile file;
 
-	if (config_path) {
-		file = gzopen(config_path, "r");
-	} else {
-		struct utsname uts;
+	if (strncmp(buf, "CONFIG_", 7))
+		return 0;
 
-		uname(&uts);
-		len = snprintf(buf, PATH_MAX, "/boot/config-%s", uts.release);
-		if (len < 0)
-			return -EINVAL;
-		else if (len >= PATH_MAX)
-			return -ENAMETOOLONG;
-		/* gzopen also accepts uncompressed files. */
-		file = gzopen(buf, "r");
-		if (!file)
-			file = gzopen("/proc/config.gz", "r");
+	sep = strchr(buf, '=');
+	if (!sep) {
+		pr_warn("failed to parse '%s': no separator\n", buf);
+		return -EINVAL;
+	}
+
+	/* Trim ending '\n' */
+	len = strlen(buf);
+	if (buf[len - 1] == '\n')
+		buf[len - 1] = '\0';
+	/* Split on '=' and ensure that a value is present. */
+	*sep = '\0';
+	if (!sep[1]) {
+		*sep = '=';
+		pr_warn("failed to parse '%s': no value\n", buf);
+		return -EINVAL;
+	}
+
+	ext = find_extern_by_name(obj, buf);
+	if (!ext || ext->is_set)
+		return 0;
+
+	ext_val = data + ext->data_off;
+	value = sep + 1;
+
+	switch (*value) {
+	case 'y': case 'n': case 'm':
+		err = set_ext_value_tri(ext, ext_val, *value);
+		break;
+	case '"':
+		err = set_ext_value_str(ext, ext_val, value);
+		break;
+	default:
+		/* assume integer */
+		err = parse_u64(value, &num);
+		if (err) {
+			pr_warn("extern %s=%s should be integer\n",
+				ext->name, value);
+			return err;
+		}
+		err = set_ext_value_num(ext, ext_val, num);
+		break;
 	}
+	if (err)
+		return err;
+	pr_debug("extern %s=%s\n", ext->name, value);
+	return 0;
+}
+
+static int bpf_object__read_kconfig_file(struct bpf_object *obj, void *data)
+{
+	char buf[PATH_MAX];
+	struct utsname uts;
+	int len, err = 0;
+	gzFile file;
+
+	uname(&uts);
+	len = snprintf(buf, PATH_MAX, "/boot/config-%s", uts.release);
+	if (len < 0)
+		return -EINVAL;
+	else if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	/* gzopen also accepts uncompressed files. */
+	file = gzopen(buf, "r");
+	if (!file)
+		file = gzopen("/proc/config.gz", "r");
+
 	if (!file) {
-		pr_warn("failed to read kernel config at '%s'\n", config_path);
+		pr_warn("failed to open system Kconfig\n");
 		return -ENOENT;
 	}
 
 	while (gzgets(file, buf, sizeof(buf))) {
-		if (strncmp(buf, "CONFIG_", 7))
-			continue;
-
-		sep = strchr(buf, '=');
-		if (!sep) {
-			err = -EINVAL;
-			pr_warn("failed to parse '%s': no separator\n", buf);
-			goto out;
-		}
-		/* Trim ending '\n' */
-		len = strlen(buf);
-		if (buf[len - 1] == '\n')
-			buf[len - 1] = '\0';
-		/* Split on '=' and ensure that a value is present. */
-		*sep = '\0';
-		if (!sep[1]) {
-			err = -EINVAL;
-			*sep = '=';
-			pr_warn("failed to parse '%s': no value\n", buf);
+		err = bpf_object__process_kconfig_line(obj, buf, data);
+		if (err) {
+			pr_warn("error parsing system Kconfig line '%s': %d\n",
+				buf, err);
 			goto out;
 		}
+	}
 
-		ext = find_extern_by_name(obj, buf);
-		if (!ext)
-			continue;
-		if (ext->is_set) {
-			err = -EINVAL;
-			pr_warn("re-defining extern '%s' not allowed\n", buf);
-			goto out;
-		}
+out:
+	gzclose(file);
+	return err;
+}
 
-		ext_val = data + ext->data_off;
-		value = sep + 1;
+static int bpf_object__read_kconfig_mem(struct bpf_object *obj,
+					const char *config, void *data)
+{
+	char buf[PATH_MAX];
+	int err = 0;
+	FILE *file;
 
-		switch (*value) {
-		case 'y': case 'n': case 'm':
-			err = set_ext_value_tri(ext, ext_val, *value);
-			break;
-		case '"':
-			err = set_ext_value_str(ext, ext_val, value);
-			break;
-		default:
-			/* assume integer */
-			err = parse_u64(value, &num);
-			if (err) {
-				pr_warn("extern %s=%s should be integer\n",
-					ext->name, value);
-				goto out;
-			}
-			err = set_ext_value_num(ext, ext_val, num);
+	file = fmemopen((void *)config, strlen(config), "r");
+	if (!file) {
+		err = -errno;
+		pr_warn("failed to open in-memory Kconfig: %d\n", err);
+		return err;
+	}
+
+	while (fgets(buf, sizeof(buf), file)) {
+		err = bpf_object__process_kconfig_line(obj, buf, data);
+		if (err) {
+			pr_warn("error parsing in-memory Kconfig line '%s': %d\n",
+				buf, err);
 			break;
 		}
-		if (err)
-			goto out;
-		pr_debug("extern %s=%s\n", ext->name, value);
 	}
 
-out:
-	gzclose(file);
+	fclose(file);
 	return err;
 }
 
@@ -4567,7 +4598,7 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
 {
-	const char *obj_name, *kconfig_path;
+	const char *obj_name, *kconfig;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char tmp_name[64];
@@ -4599,10 +4630,10 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		return obj;
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
-	kconfig_path = OPTS_GET(opts, kconfig_path, NULL);
-	if (kconfig_path) {
-		obj->kconfig_path = strdup(kconfig_path);
-		if (!obj->kconfig_path)
+	kconfig = OPTS_GET(opts, kconfig, NULL);
+	if (kconfig) {
+		obj->kconfig = strdup(kconfig);
+		if (!obj->kconfig)
 			return ERR_PTR(-ENOMEM);
 	}
 
@@ -4745,7 +4776,7 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 }
 
 static int bpf_object__resolve_externs(struct bpf_object *obj,
-				       const char *config_path)
+				       const char *extra_kconfig)
 {
 	bool need_config = false;
 	struct extern_desc *ext;
@@ -4779,8 +4810,21 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 			return -EINVAL;
 		}
 	}
+	if (need_config && extra_kconfig) {
+		err = bpf_object__read_kconfig_mem(obj, extra_kconfig, data);
+		if (err)
+			return -EINVAL;
+		need_config = false;
+		for (i = 0; i < obj->nr_extern; i++) {
+			ext = &obj->externs[i];
+			if (!ext->is_set) {
+				need_config = true;
+				break;
+			}
+		}
+	}
 	if (need_config) {
-		err = bpf_object__read_kernel_config(obj, config_path, data);
+		err = bpf_object__read_kconfig_file(obj, data);
 		if (err)
 			return -EINVAL;
 	}
@@ -4818,7 +4862,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	obj->loaded = true;
 
 	err = bpf_object__probe_caps(obj);
-	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig_path);
+	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
@@ -5412,7 +5456,7 @@ void bpf_object__close(struct bpf_object *obj)
 		zfree(&map->pin_path);
 	}
 
-	zfree(&obj->kconfig_path);
+	zfree(&obj->kconfig);
 	zfree(&obj->externs);
 	obj->nr_extern = 0;
 
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f7084235bae9..ffe62e3baffd 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -85,12 +85,12 @@ struct bpf_object_open_opts {
 	 */
 	const char *pin_root_path;
 	__u32 attach_prog_fd;
-	/* kernel config file path override (for CONFIG_ externs); can point
-	 * to either uncompressed text file or .gz file
+	/* Additional kernel config content that augments and overrides
+	 * system Kconfig for CONFIG_xxx externs.
 	 */
-	const char *kconfig_path;
+	const char *kconfig;
 };
-#define bpf_object_open_opts__last_field kconfig_path
+#define bpf_object_open_opts__last_field kconfig
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
diff --git a/tools/testing/selftests/bpf/prog_tests/core_extern.c b/tools/testing/selftests/bpf/prog_tests/core_extern.c
index 5f03dc1de29e..b093787e9448 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_extern.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_extern.c
@@ -23,19 +23,13 @@ static uint32_t get_kernel_version(void)
 static struct test_case {
 	const char *name;
 	const char *cfg;
-	const char *cfg_path;
 	bool fails;
 	struct test_core_extern__data data;
 } test_cases[] = {
-	{ .name = "default search path", .cfg_path = NULL,
-	  .data = { .bpf_syscall = true } },
-	{ .name = "/proc/config.gz", .cfg_path = "/proc/config.gz",
-	  .data = { .bpf_syscall = true } },
-	{ .name = "missing config", .fails = true,
-	  .cfg_path = "/proc/invalid-config.gz" },
+	{ .name = "default search path", .data = { .bpf_syscall = true } },
 	{
 		.name = "custom values",
-		.cfg = "CONFIG_BPF_SYSCALL=y\n"
+		.cfg = "CONFIG_BPF_SYSCALL=n\n"
 		       "CONFIG_TRISTATE=m\n"
 		       "CONFIG_BOOL=y\n"
 		       "CONFIG_CHAR=100\n"
@@ -45,7 +39,7 @@ static struct test_case {
 		       "CONFIG_STR=\"abracad\"\n"
 		       "CONFIG_MISSING=0",
 		.data = {
-			.bpf_syscall = true,
+			.bpf_syscall = false,
 			.tristate_val = TRI_MODULE,
 			.bool_val = true,
 			.char_val = 100,
@@ -133,30 +127,14 @@ void test_core_extern(void)
 	int n = sizeof(*skel->data) / sizeof(uint64_t);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
-		char tmp_cfg_path[] = "/tmp/test_core_extern_cfg.XXXXXX";
 		struct test_case *t = &test_cases[i];
 		DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
-			.kconfig_path = t->cfg_path,
+			.kconfig = t->cfg,
 		);
 
 		if (!test__start_subtest(t->name))
 			continue;
 
-		if (t->cfg) {
-			size_t n = strlen(t->cfg) + 1;
-			int fd = mkstemp(tmp_cfg_path);
-			int written;
-
-			if (CHECK(fd < 0, "mkstemp", "errno: %d\n", errno))
-				continue;
-			printf("using '%s' as config file\n", tmp_cfg_path);
-			written = write(fd, t->cfg, n);
-			close(fd);
-			if (CHECK_FAIL(written != n))
-				goto cleanup;
-			opts.kconfig_path = tmp_cfg_path;
-		}
-
 		skel = test_core_extern__open_opts(&opts);
 		if (CHECK(!skel, "skel_open", "skeleton open failed\n"))
 			goto cleanup;
@@ -185,8 +163,6 @@ void test_core_extern(void)
 			       j, exp[j], got[j]);
 		}
 cleanup:
-		if (t->cfg)
-			unlink(tmp_cfg_path);
 		test_core_extern__destroy(skel);
 		skel = NULL;
 	}
-- 
2.17.1

