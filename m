Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151E7125871
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLSA2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:28:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726536AbfLSA2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:28:45 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBJ0Q7DE024035
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gNdzGSTknkE9hROVJLKMMwsKETfkUB8s8t+Xdpv/h8M=;
 b=eBBA3CoFzs+P/uMVAUEIRcqLmJdjN6tXWJ2XPf/JxRoSuqPOKTlA7OA48ymTdJ6Huy6d
 HXmPEr8BJWX09BdLYp4j9s6h/3FBgOCVdoOH8uXfCxGjAE0wlJxhYB5J6FbIWpKgb4WT
 ZTtl0x7FGPH+5bYKRWRo6P5Y0si8ldLHs8w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wyhy23w3k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:42 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 18 Dec 2019 16:28:41 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1034A2EC18AF; Wed, 18 Dec 2019 16:28:40 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] libbpf: put Kconfig externs into .kconfig section
Date:   Wed, 18 Dec 2019 16:28:34 -0800
Message-ID: <20191219002837.3074619-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219002837.3074619-1-andriin@fb.com>
References: <20191219002837.3074619-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=8 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912190002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move Kconfig-provided externs into custom .kconfig section. Add __kconfig into
bpf_helpers.h for user convenience. Update selftests accordingly.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c                       |  8 +--
 tools/lib/bpf/bpf_helpers.h                   |  2 +
 tools/lib/bpf/libbpf.c                        | 58 +++++++++++--------
 .../selftests/bpf/prog_tests/skeleton.c       | 16 +++--
 .../selftests/bpf/progs/test_core_extern.c    | 20 +++----
 .../selftests/bpf/progs/test_skeleton.c       |  4 +-
 6 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 8d93c8f90f82..87ef7c17c61c 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -83,8 +83,8 @@ static const char *get_map_ident(const struct bpf_map *map)
 		return "rodata";
 	else if (str_has_suffix(name, ".bss"))
 		return "bss";
-	else if (str_has_suffix(name, ".extern"))
-		return "externs"; /* extern is a C keyword */
+	else if (str_has_suffix(name, ".kconfig"))
+		return "kconfig";
 	else
 		return NULL;
 }
@@ -112,8 +112,8 @@ static int codegen_datasec_def(struct bpf_object *obj,
 		sec_ident = "bss";
 	else if (strcmp(sec_name, ".rodata") == 0)
 		sec_ident = "rodata";
-	else if (strcmp(sec_name, ".extern") == 0)
-		sec_ident = "externs"; /* extern is a C keyword */
+	else if (strcmp(sec_name, ".kconfig") == 0)
+		sec_ident = "kconfig";
 	else
 		return 0;
 
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index aa46700075e1..f69cc208778a 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -53,4 +53,6 @@ enum libbpf_tristate {
 	TRI_MODULE = 2,
 };
 
+#define __kconfig __attribute__((section(".kconfig")))
+
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 906bbbf7b2e4..ed54a6a7f6f2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -231,21 +231,21 @@ struct bpf_program {
 #define DATA_SEC ".data"
 #define BSS_SEC ".bss"
 #define RODATA_SEC ".rodata"
-#define EXTERN_SEC ".extern"
+#define KCONFIG_SEC ".kconfig"
 
 enum libbpf_map_type {
 	LIBBPF_MAP_UNSPEC,
 	LIBBPF_MAP_DATA,
 	LIBBPF_MAP_BSS,
 	LIBBPF_MAP_RODATA,
-	LIBBPF_MAP_EXTERN,
+	LIBBPF_MAP_KCONFIG,
 };
 
 static const char * const libbpf_type_to_btf_name[] = {
 	[LIBBPF_MAP_DATA]	= DATA_SEC,
 	[LIBBPF_MAP_BSS]	= BSS_SEC,
 	[LIBBPF_MAP_RODATA]	= RODATA_SEC,
-	[LIBBPF_MAP_EXTERN]	= EXTERN_SEC,
+	[LIBBPF_MAP_KCONFIG]	= KCONFIG_SEC,
 };
 
 struct bpf_map {
@@ -305,7 +305,7 @@ struct bpf_object {
 	char *kconfig_path;
 	struct extern_desc *externs;
 	int nr_extern;
-	int extern_map_idx;
+	int kconfig_map_idx;
 
 	bool loaded;
 	bool has_pseudo_calls;
@@ -606,7 +606,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.data_shndx = -1;
 	obj->efile.rodata_shndx = -1;
 	obj->efile.bss_shndx = -1;
-	obj->extern_map_idx = -1;
+	obj->kconfig_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
@@ -902,11 +902,25 @@ static size_t bpf_map_mmap_sz(const struct bpf_map *map)
 	return map_sz;
 }
 
+static char *internal_map_name(struct bpf_object *obj,
+			       enum libbpf_map_type type)
+{
+	char map_name[BPF_OBJ_NAME_LEN];
+	const char *sfx = libbpf_type_to_btf_name[type];
+	int sfx_len = max((size_t)7, strlen(sfx));
+	int pfx_len = min((size_t)BPF_OBJ_NAME_LEN - sfx_len - 1,
+			  strlen(obj->name));
+
+	snprintf(map_name, sizeof(map_name), "%.*s%.*s", pfx_len, obj->name,
+		 sfx_len, libbpf_type_to_btf_name[type]);
+
+	return strdup(map_name);
+}
+
 static int
 bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 			      int sec_idx, void *data, size_t data_sz)
 {
-	char map_name[BPF_OBJ_NAME_LEN];
 	struct bpf_map_def *def;
 	struct bpf_map *map;
 	int err;
@@ -918,9 +932,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	map->libbpf_type = type;
 	map->sec_idx = sec_idx;
 	map->sec_offset = 0;
-	snprintf(map_name, sizeof(map_name), "%.8s%.7s", obj->name,
-		 libbpf_type_to_btf_name[type]);
-	map->name = strdup(map_name);
+	map->name = internal_map_name(obj, type);
 	if (!map->name) {
 		pr_warn("failed to alloc map name\n");
 		return -ENOMEM;
@@ -931,12 +943,12 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	def->key_size = sizeof(int);
 	def->value_size = data_sz;
 	def->max_entries = 1;
-	def->map_flags = type == LIBBPF_MAP_RODATA || type == LIBBPF_MAP_EXTERN
+	def->map_flags = type == LIBBPF_MAP_RODATA || type == LIBBPF_MAP_KCONFIG
 			 ? BPF_F_RDONLY_PROG : 0;
 	def->map_flags |= BPF_F_MMAPABLE;
 
 	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
-		 map_name, map->sec_idx, map->sec_offset, def->map_flags);
+		 map->name, map->sec_idx, map->sec_offset, def->map_flags);
 
 	map->mmaped = mmap(NULL, bpf_map_mmap_sz(map), PROT_READ | PROT_WRITE,
 			   MAP_SHARED | MAP_ANONYMOUS, -1, 0);
@@ -1232,7 +1244,7 @@ static int bpf_object__read_kernel_config(struct bpf_object *obj,
 	return err;
 }
 
-static int bpf_object__init_extern_map(struct bpf_object *obj)
+static int bpf_object__init_kconfig_map(struct bpf_object *obj)
 {
 	struct extern_desc *last_ext;
 	size_t map_sz;
@@ -1244,13 +1256,13 @@ static int bpf_object__init_extern_map(struct bpf_object *obj)
 	last_ext = &obj->externs[obj->nr_extern - 1];
 	map_sz = last_ext->data_off + last_ext->sz;
 
-	err = bpf_object__init_internal_map(obj, LIBBPF_MAP_EXTERN,
+	err = bpf_object__init_internal_map(obj, LIBBPF_MAP_KCONFIG,
 					    obj->efile.symbols_shndx,
 					    NULL, map_sz);
 	if (err)
 		return err;
 
-	obj->extern_map_idx = obj->nr_maps - 1;
+	obj->kconfig_map_idx = obj->nr_maps - 1;
 
 	return 0;
 }
@@ -1742,7 +1754,7 @@ static int bpf_object__init_maps(struct bpf_object *obj,
 	err = bpf_object__init_user_maps(obj, strict);
 	err = err ?: bpf_object__init_user_btf_maps(obj, strict, pin_root_path);
 	err = err ?: bpf_object__init_global_data_maps(obj);
-	err = err ?: bpf_object__init_extern_map(obj);
+	err = err ?: bpf_object__init_kconfig_map(obj);
 	if (err)
 		return err;
 
@@ -2269,9 +2281,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 			 i, ext->sym_idx, ext->data_off, ext->name);
 	}
 
-	btf_id = btf__find_by_name(obj->btf, EXTERN_SEC);
+	btf_id = btf__find_by_name(obj->btf, KCONFIG_SEC);
 	if (btf_id <= 0) {
-		pr_warn("no BTF info found for '%s' datasec\n", EXTERN_SEC);
+		pr_warn("no BTF info found for '%s' datasec\n", KCONFIG_SEC);
 		return -ESRCH;
 	}
 
@@ -2361,7 +2373,7 @@ bpf_object__section_to_libbpf_map_type(const struct bpf_object *obj, int shndx)
 	else if (shndx == obj->efile.rodata_shndx)
 		return LIBBPF_MAP_RODATA;
 	else if (shndx == obj->efile.symbols_shndx)
-		return LIBBPF_MAP_EXTERN;
+		return LIBBPF_MAP_KCONFIG;
 	else
 		return LIBBPF_MAP_UNSPEC;
 }
@@ -2908,8 +2920,8 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 		return err;
 	}
 
-	/* Freeze .rodata and .extern map as read-only from syscall side. */
-	if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_EXTERN) {
+	/* Freeze .rodata and .kconfig map as read-only from syscall side. */
+	if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_KCONFIG) {
 		err = bpf_map_freeze(map->fd);
 		if (err) {
 			err = -errno;
@@ -4264,7 +4276,7 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 			break;
 		case RELO_EXTERN:
 			insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
-			insn[0].imm = obj->maps[obj->extern_map_idx].fd;
+			insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
 			insn[1].imm = relo->sym_off;
 			break;
 		case RELO_CALL:
@@ -4743,7 +4755,7 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 	if (obj->nr_extern == 0)
 		return 0;
 
-	data = obj->maps[obj->extern_map_idx].mmaped;
+	data = obj->maps[obj->kconfig_map_idx].mmaped;
 
 	for (i = 0; i < obj->nr_extern; i++) {
 		ext = &obj->externs[i];
@@ -7526,7 +7538,7 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 		}
 
 		/* externs shouldn't be pre-setup from user code */
-		if (mmaped && (*map)->libbpf_type != LIBBPF_MAP_EXTERN)
+		if (mmaped && (*map)->libbpf_type != LIBBPF_MAP_KCONFIG)
 			*mmaped = (*map)->mmaped;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
index ec6f2aec3853..9264a2736018 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -15,20 +15,18 @@ void test_skeleton(void)
 	int duration = 0, err;
 	struct test_skeleton* skel;
 	struct test_skeleton__bss *bss;
-	struct test_skeleton__externs *exts;
+	struct test_skeleton__kconfig *kcfg;
 
 	skel = test_skeleton__open();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
 		return;
 
-	printf("EXTERNS BEFORE: %p\n", skel->externs);
-	if (CHECK(skel->externs, "skel_externs", "externs are mmaped()!\n"))
+	if (CHECK(skel->kconfig, "skel_kconfig", "kconfig is mmaped()!\n"))
 		goto cleanup;
 
 	err = test_skeleton__load(skel);
 	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
 		goto cleanup;
-	printf("EXTERNS AFTER: %p\n", skel->externs);
 
 	bss = skel->bss;
 	bss->in1 = 1;
@@ -37,7 +35,7 @@ void test_skeleton(void)
 	bss->in4 = 4;
 	bss->in5.a = 5;
 	bss->in5.b = 6;
-	exts = skel->externs;
+	kcfg = skel->kconfig;
 
 	err = test_skeleton__attach(skel);
 	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
@@ -55,10 +53,10 @@ void test_skeleton(void)
 	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
 	      bss->handler_out5.b, 6);
 
-	CHECK(bss->bpf_syscall != exts->CONFIG_BPF_SYSCALL, "ext1",
-	      "got %d != exp %d\n", bss->bpf_syscall, exts->CONFIG_BPF_SYSCALL);
-	CHECK(bss->kern_ver != exts->LINUX_KERNEL_VERSION, "ext2",
-	      "got %d != exp %d\n", bss->kern_ver, exts->LINUX_KERNEL_VERSION);
+	CHECK(bss->bpf_syscall != kcfg->CONFIG_BPF_SYSCALL, "ext1",
+	      "got %d != exp %d\n", bss->bpf_syscall, kcfg->CONFIG_BPF_SYSCALL);
+	CHECK(bss->kern_ver != kcfg->LINUX_KERNEL_VERSION, "ext2",
+	      "got %d != exp %d\n", bss->kern_ver, kcfg->LINUX_KERNEL_VERSION);
 
 cleanup:
 	test_skeleton__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_core_extern.c b/tools/testing/selftests/bpf/progs/test_core_extern.c
index e12f09f9e881..9bfc91d9d004 100644
--- a/tools/testing/selftests/bpf/progs/test_core_extern.c
+++ b/tools/testing/selftests/bpf/progs/test_core_extern.c
@@ -10,16 +10,16 @@
 /* non-existing BPF helper, to test dead code elimination */
 static int (*bpf_missing_helper)(const void *arg1, int arg2) = (void *) 999;
 
-extern int LINUX_KERNEL_VERSION;
-extern bool CONFIG_BPF_SYSCALL; /* strong */
-extern enum libbpf_tristate CONFIG_TRISTATE __weak;
-extern bool CONFIG_BOOL __weak;
-extern char CONFIG_CHAR __weak;
-extern uint16_t CONFIG_USHORT __weak;
-extern int CONFIG_INT __weak;
-extern uint64_t CONFIG_ULONG __weak;
-extern const char CONFIG_STR[8] __weak;
-extern uint64_t CONFIG_MISSING __weak;
+extern int LINUX_KERNEL_VERSION __kconfig;
+extern bool CONFIG_BPF_SYSCALL __kconfig; /* strong */
+extern enum libbpf_tristate CONFIG_TRISTATE __kconfig __weak;
+extern bool CONFIG_BOOL __kconfig __weak;
+extern char CONFIG_CHAR __kconfig __weak;
+extern uint16_t CONFIG_USHORT __kconfig __weak;
+extern int CONFIG_INT __kconfig __weak;
+extern uint64_t CONFIG_ULONG __kconfig __weak;
+extern const char CONFIG_STR[8] __kconfig __weak;
+extern uint64_t CONFIG_MISSING __kconfig __weak;
 
 uint64_t kern_ver = -1;
 uint64_t bpf_syscall = -1;
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
index 9caa44758ea2..4f69aac5635f 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -21,8 +21,8 @@ char out3 = 0;
 long long out4 = 0;
 int out1 = 0;
 
-extern bool CONFIG_BPF_SYSCALL;
-extern int LINUX_KERNEL_VERSION;
+extern bool CONFIG_BPF_SYSCALL __kconfig;
+extern int LINUX_KERNEL_VERSION __kconfig;
 bool bpf_syscall = 0;
 int kern_ver = 0;
 
-- 
2.17.1

