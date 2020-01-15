Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDDA13D071
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgAOXAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:00:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729174AbgAOXAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:00:37 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FMxx8n025079
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:00:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wBLX/sBiJIsZ9u48wG4e48le3nyybtOzKtPEBIXUKt4=;
 b=c6fzVOvj8a4OUGTqw4dwfb2piYguiZDmGf7e6EmLfFGecy+7YRDBXz7uDRYbxUrveqgj
 DmentFtwYuubvRtJXGHnSuwTheKCMP5pxk/zU0qXaJjFRBBihcbtQX6qhjqDAnLjcYu5
 eZhzQHpiRJ3+yPJo9fNvYBGsPU8+TRL6KJ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhp0fnkkn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:00:36 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 15:00:32 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B5DB02941680; Wed, 15 Jan 2020 15:00:31 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/5] libbpf: Expose bpf_find_kernel_btf as a LIBBPF_API
Date:   Wed, 15 Jan 2020 15:00:31 -0800
Message-ID: <20200115230031.1102305-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200115230012.1100525-1-kafai@fb.com>
References: <20200115230012.1100525-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 suspectscore=38
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001150173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exposes bpf_find_kernel_btf() as a LIBBPF_API.
It will be used in 'bpftool map dump' in a following patch
to dump a map with btf_vmlinux_value_type_id set.

bpf_find_kernel_btf() is renamed to libbpf_find_kernel_btf()
and moved to btf.c.  As <linux/kernel.h> is included,
some of the max/min type casting needs to be fixed.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/btf.c      | 102 ++++++++++++++++++++++++++++++++++++---
 tools/lib/bpf/btf.h      |   2 +
 tools/lib/bpf/libbpf.c   |  93 ++---------------------------------
 tools/lib/bpf/libbpf.map |   1 +
 4 files changed, 102 insertions(+), 96 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index cfeb6a44480b..3d1c25fc97ae 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -8,6 +8,10 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
+#include <sys/utsname.h>
+#include <sys/param.h>
+#include <sys/stat.h>
+#include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/btf.h>
 #include <gelf.h>
@@ -20,8 +24,8 @@
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
 
-#define BTF_MAX_NR_TYPES 0x7fffffff
-#define BTF_MAX_STR_OFFSET 0x7fffffff
+#define BTF_MAX_NR_TYPES 0x7fffffffU
+#define BTF_MAX_STR_OFFSET 0x7fffffffU
 
 static struct btf_type btf_void;
 
@@ -53,7 +57,7 @@ static int btf_add_type(struct btf *btf, struct btf_type *t)
 		if (btf->types_size == BTF_MAX_NR_TYPES)
 			return -E2BIG;
 
-		expand_by = max(btf->types_size >> 2, 16);
+		expand_by = max(btf->types_size >> 2, 16U);
 		new_size = min(BTF_MAX_NR_TYPES, btf->types_size + expand_by);
 
 		new_types = realloc(btf->types, sizeof(*new_types) * new_size);
@@ -289,7 +293,7 @@ int btf__align_of(const struct btf *btf, __u32 id)
 	switch (kind) {
 	case BTF_KIND_INT:
 	case BTF_KIND_ENUM:
-		return min(sizeof(void *), t->size);
+		return min(sizeof(void *), (size_t)t->size);
 	case BTF_KIND_PTR:
 		return sizeof(void *);
 	case BTF_KIND_TYPEDEF:
@@ -1401,7 +1405,7 @@ static int btf_dedup_hypot_map_add(struct btf_dedup *d,
 	if (d->hypot_cnt == d->hypot_cap) {
 		__u32 *new_list;
 
-		d->hypot_cap += max(16, d->hypot_cap / 2);
+		d->hypot_cap += max((size_t)16, d->hypot_cap / 2);
 		new_list = realloc(d->hypot_list, sizeof(__u32) * d->hypot_cap);
 		if (!new_list)
 			return -ENOMEM;
@@ -1697,7 +1701,7 @@ static int btf_dedup_strings(struct btf_dedup *d)
 		if (strs.cnt + 1 > strs.cap) {
 			struct btf_str_ptr *new_ptrs;
 
-			strs.cap += max(strs.cnt / 2, 16);
+			strs.cap += max(strs.cnt / 2, 16U);
 			new_ptrs = realloc(strs.ptrs,
 					   sizeof(strs.ptrs[0]) * strs.cap);
 			if (!new_ptrs) {
@@ -2931,3 +2935,89 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
 	}
 	return 0;
 }
+
+static struct btf *btf_load_raw(const char *path)
+{
+	struct btf *btf;
+	size_t read_cnt;
+	struct stat st;
+	void *data;
+	FILE *f;
+
+	if (stat(path, &st))
+		return ERR_PTR(-errno);
+
+	data = malloc(st.st_size);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	f = fopen(path, "rb");
+	if (!f) {
+		btf = ERR_PTR(-errno);
+		goto cleanup;
+	}
+
+	read_cnt = fread(data, 1, st.st_size, f);
+	fclose(f);
+	if (read_cnt < st.st_size) {
+		btf = ERR_PTR(-EBADF);
+		goto cleanup;
+	}
+
+	btf = btf__new(data, read_cnt);
+
+cleanup:
+	free(data);
+	return btf;
+}
+
+/*
+ * Probe few well-known locations for vmlinux kernel image and try to load BTF
+ * data out of it to use for target BTF.
+ */
+struct btf *libbpf_find_kernel_btf(void)
+{
+	struct {
+		const char *path_fmt;
+		bool raw_btf;
+	} locations[] = {
+		/* try canonical vmlinux BTF through sysfs first */
+		{ "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
+		/* fall back to trying to find vmlinux ELF on disk otherwise */
+		{ "/boot/vmlinux-%1$s" },
+		{ "/lib/modules/%1$s/vmlinux-%1$s" },
+		{ "/lib/modules/%1$s/build/vmlinux" },
+		{ "/usr/lib/modules/%1$s/kernel/vmlinux" },
+		{ "/usr/lib/debug/boot/vmlinux-%1$s" },
+		{ "/usr/lib/debug/boot/vmlinux-%1$s.debug" },
+		{ "/usr/lib/debug/lib/modules/%1$s/vmlinux" },
+	};
+	char path[PATH_MAX + 1];
+	struct utsname buf;
+	struct btf *btf;
+	int i;
+
+	uname(&buf);
+
+	for (i = 0; i < ARRAY_SIZE(locations); i++) {
+		snprintf(path, PATH_MAX, locations[i].path_fmt, buf.release);
+
+		if (access(path, R_OK))
+			continue;
+
+		if (locations[i].raw_btf)
+			btf = btf_load_raw(path);
+		else
+			btf = btf__parse_elf(path, NULL);
+
+		pr_debug("loading kernel BTF '%s': %ld\n",
+			 path, IS_ERR(btf) ? PTR_ERR(btf) : 0);
+		if (IS_ERR(btf))
+			continue;
+
+		return btf;
+	}
+
+	pr_warn("failed to find valid kernel BTF\n");
+	return ERR_PTR(-ESRCH);
+}
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 8d73f7f5551f..70c1b7ec2bd0 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -102,6 +102,8 @@ LIBBPF_API int btf_ext__reloc_line_info(const struct btf *btf,
 LIBBPF_API __u32 btf_ext__func_info_rec_size(const struct btf_ext *btf_ext);
 LIBBPF_API __u32 btf_ext__line_info_rec_size(const struct btf_ext *btf_ext);
 
+LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
+
 struct btf_dedup_opts {
 	unsigned int dedup_table_size;
 	bool dont_resolve_fwds;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 23868883477f..3afaca9bce1d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -73,7 +73,6 @@
 
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
-static struct btf *bpf_find_kernel_btf(void);
 static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
 static struct bpf_program *bpf_object__find_prog_by_idx(struct bpf_object *obj,
 							int idx);
@@ -848,7 +847,7 @@ static int bpf_object__init_kern_struct_ops_maps(struct bpf_object *obj)
 			continue;
 
 		if (!kern_btf) {
-			kern_btf = bpf_find_kernel_btf();
+			kern_btf = libbpf_find_kernel_btf();
 			if (IS_ERR(kern_btf))
 				return PTR_ERR(kern_btf);
 		}
@@ -4300,92 +4299,6 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 	return 0;
 }
 
-static struct btf *btf_load_raw(const char *path)
-{
-	struct btf *btf;
-	size_t read_cnt;
-	struct stat st;
-	void *data;
-	FILE *f;
-
-	if (stat(path, &st))
-		return ERR_PTR(-errno);
-
-	data = malloc(st.st_size);
-	if (!data)
-		return ERR_PTR(-ENOMEM);
-
-	f = fopen(path, "rb");
-	if (!f) {
-		btf = ERR_PTR(-errno);
-		goto cleanup;
-	}
-
-	read_cnt = fread(data, 1, st.st_size, f);
-	fclose(f);
-	if (read_cnt < st.st_size) {
-		btf = ERR_PTR(-EBADF);
-		goto cleanup;
-	}
-
-	btf = btf__new(data, read_cnt);
-
-cleanup:
-	free(data);
-	return btf;
-}
-
-/*
- * Probe few well-known locations for vmlinux kernel image and try to load BTF
- * data out of it to use for target BTF.
- */
-static struct btf *bpf_find_kernel_btf(void)
-{
-	struct {
-		const char *path_fmt;
-		bool raw_btf;
-	} locations[] = {
-		/* try canonical vmlinux BTF through sysfs first */
-		{ "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
-		/* fall back to trying to find vmlinux ELF on disk otherwise */
-		{ "/boot/vmlinux-%1$s" },
-		{ "/lib/modules/%1$s/vmlinux-%1$s" },
-		{ "/lib/modules/%1$s/build/vmlinux" },
-		{ "/usr/lib/modules/%1$s/kernel/vmlinux" },
-		{ "/usr/lib/debug/boot/vmlinux-%1$s" },
-		{ "/usr/lib/debug/boot/vmlinux-%1$s.debug" },
-		{ "/usr/lib/debug/lib/modules/%1$s/vmlinux" },
-	};
-	char path[PATH_MAX + 1];
-	struct utsname buf;
-	struct btf *btf;
-	int i;
-
-	uname(&buf);
-
-	for (i = 0; i < ARRAY_SIZE(locations); i++) {
-		snprintf(path, PATH_MAX, locations[i].path_fmt, buf.release);
-
-		if (access(path, R_OK))
-			continue;
-
-		if (locations[i].raw_btf)
-			btf = btf_load_raw(path);
-		else
-			btf = btf__parse_elf(path, NULL);
-
-		pr_debug("loading kernel BTF '%s': %ld\n",
-			 path, IS_ERR(btf) ? PTR_ERR(btf) : 0);
-		if (IS_ERR(btf))
-			continue;
-
-		return btf;
-	}
-
-	pr_warn("failed to find valid kernel BTF\n");
-	return ERR_PTR(-ESRCH);
-}
-
 /* Output spec definition in the format:
  * [<type-id>] (<type-name>) + <raw-spec> => <offset>@<spec>,
  * where <spec> is a C-syntax view of recorded field access, e.g.: x.a[3].b
@@ -4620,7 +4533,7 @@ bpf_core_reloc_fields(struct bpf_object *obj, const char *targ_btf_path)
 	if (targ_btf_path)
 		targ_btf = btf__parse_elf(targ_btf_path, NULL);
 	else
-		targ_btf = bpf_find_kernel_btf();
+		targ_btf = libbpf_find_kernel_btf();
 	if (IS_ERR(targ_btf)) {
 		pr_warn("failed to get target BTF: %ld\n", PTR_ERR(targ_btf));
 		return PTR_ERR(targ_btf);
@@ -6595,7 +6508,7 @@ static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *obj,
 int libbpf_find_vmlinux_btf_id(const char *name,
 			       enum bpf_attach_type attach_type)
 {
-	struct btf *btf = bpf_find_kernel_btf();
+	struct btf *btf = libbpf_find_kernel_btf();
 	char raw_tp_btf[128] = BTF_PREFIX;
 	char *dst = raw_tp_btf + sizeof(BTF_PREFIX) - 1;
 	const char *btf_name;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index a19f04e6e3d9..fad8fefacfdb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -227,4 +227,5 @@ LIBBPF_0.0.7 {
 		bpf_program__is_struct_ops;
 		bpf_program__set_struct_ops;
 		btf__align_of;
+		libbpf_find_kernel_btf;
 } LIBBPF_0.0.6;
-- 
2.17.1

