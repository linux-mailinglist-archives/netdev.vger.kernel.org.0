Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7D1FF831
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfKQHIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfKQHI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:29 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH70Q4d002198
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3dkZHfMXoFI8dpDTi0iLoIYWkEIS/vZswWuQLimVBfE=;
 b=YiGg3ZSsKTj2dp7CxdRh8ipuB76ECVEr8tnjvtX+3S1/kVe85Va50HNlrjXzmEBDjWSY
 TIoBHQWibivq/dTW18snjCOE8UXCBjcMctp+QJt6kJQp34g7UTUeDiDVd9oXFR7Ir9rN
 K4N+QQerYEfCjiz3x30+h2nBtpkKGaEasFQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wafpe0ket-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:27 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 23:08:24 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AAD2B2EC19AE; Sat, 16 Nov 2019 23:08:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern variables
Date:   Sat, 16 Nov 2019 23:08:06 -0800
Message-ID: <20191117070807.251360-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=9 priorityscore=1501 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for extern variables, provided to BPF program by libbpf. Currently
the following extern variables are supported:
  - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
    executing, follows KERNEL_VERSION() macro convention;
  - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
    boolean, and integer values are supported. Strings are not supported at
    the moment.

All values are represented as 64-bit integers, with the follow value encoding:
  - for boolean values, y is 1, n or missing value is 0;
  - for tristate values, y is 1, m is 2, n or missing value is 0;
  - for integers, the values is 64-bit integer, sign-extended, if negative; if
    config value is missing, it's represented as 0, which makes explicit 0 and
    missing config value indistinguishable. If this will turn out to be
    a problem in practice, we'll need to deal with it somehow.

Generally speaking, libbpf is not aware of which CONFIG_XXX values is of which
expected type (bool, tristate, int), so it doesn't enforce any specific set of
values and just parses n/y/m as 0/1/2, respectively. CONFIG_XXX values not
found in config file are set to 0. If any of declared
externs are unrecognized by libbpf, error is returned on bpf_object__open().
In the future it will be possible to extend available set of supported externs
to include new libbpf-provided values, if necessary, or linking against
kernel- or other BPF object-provided global variables/functions.

Config file itself is searched in /boot/config-$(uname -r) location with
fallback to /proc/config.gz, unless config path is specified explicitly
through bpf_object_open_opts' kernel_config_path option. Both gzipped and
plain text formats are supported. Libbpf adds explicit dependency on zlib
because of this, but this shouldn't be a problem, given libelf already depends
on zlib.

All detected extern variables, are put into a separate .extern internal map.
It, similarly to .rodata map, is marked as read-only from BPF program side, as
well as is frozen on load. This allows BPF verifier to track extern values as
constants and performe enhanced branch prediction and dead code elimination.
This can be relied upon for doing kernel version/feature detection and using
potentially unsupported field relocations or BPF helpers in a CO-RE-based BPF
program, while still having a single version of BPF program running on old and
new kernels. Selftests are validating this explicitly for unexisting BPF
helper.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile               |  17 +-
 tools/lib/bpf/libbpf.c               | 471 ++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h               |   8 +-
 tools/testing/selftests/bpf/Makefile |   2 +-
 4 files changed, 409 insertions(+), 89 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 99425d0be6ff..28020b23c4d2 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -56,8 +56,8 @@ ifndef VERBOSE
 endif
 
 FEATURE_USER = .libbpf
-FEATURE_TESTS = libelf libelf-mmap bpf reallocarray
-FEATURE_DISPLAY = libelf bpf
+FEATURE_TESTS = libelf libelf-mmap zlib bpf reallocarray
+FEATURE_DISPLAY = libelf zlib bpf
 
 INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
 FEATURE_CHECK_CFLAGS-bpf = $(INCLUDES)
@@ -159,7 +159,7 @@ all: fixdep
 
 all_cmd: $(CMD_TARGETS) check
 
-$(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
+$(BPF_IN_SHARED): force elfdep zdep bpfdep bpf_helper_defs.h
 	@(test -f ../../include/uapi/linux/bpf.h -a -f ../../../include/uapi/linux/bpf.h && ( \
 	(diff -B ../../include/uapi/linux/bpf.h ../../../include/uapi/linux/bpf.h >/dev/null) || \
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'" >&2 )) || true
@@ -177,7 +177,7 @@ $(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(SHARED_OBJDIR) CFLAGS="$(CFLAGS) $(SHLIB_FLAGS)"
 
-$(BPF_IN_STATIC): force elfdep bpfdep bpf_helper_defs.h
+$(BPF_IN_STATIC): force elfdep zdep bpfdep bpf_helper_defs.h
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
 
 bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
@@ -189,7 +189,7 @@ $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) \
 		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
-		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
+		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -lz -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
@@ -197,7 +197,7 @@ $(OUTPUT)libbpf.a: $(BPF_IN_STATIC)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
 $(OUTPUT)test_libbpf: test_libbpf.c $(OUTPUT)libbpf.a
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -lz -o $@
 
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
@@ -280,12 +280,15 @@ clean:
 
 
 
-PHONY += force elfdep bpfdep cscope tags
+PHONY += force elfdep zdep bpfdep cscope tags
 force:
 
 elfdep:
 	@if [ "$(feature-libelf)" != "1" ]; then echo "No libelf found"; exit 1 ; fi
 
+zdep:
+	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi
+
 bpfdep:
 	@if [ "$(feature-bpf)" != "1" ]; then echo "BPF API too old"; exit 1 ; fi
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 639c2e17df0b..d9b70483a2c7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -44,6 +44,7 @@
 #include <tools/libc_compat.h>
 #include <libelf.h>
 #include <gelf.h>
+#include <zlib.h>
 
 #include "libbpf.h"
 #include "bpf.h"
@@ -146,6 +147,23 @@ struct bpf_capabilities {
 	__u32 array_mmap:1;
 };
 
+enum reloc_type {
+	RELO_LD64,
+	RELO_CALL,
+	RELO_DATA,
+	RELO_EXTERN,
+};
+
+struct reloc_desc {
+	enum reloc_type type;
+	int insn_idx;
+	union {
+		int map_idx;
+		int text_off;
+		int data_off;
+	};
+};
+
 /*
  * bpf_prog should be a better name but it has been used in
  * linux/filter.h.
@@ -164,18 +182,7 @@ struct bpf_program {
 	size_t insns_cnt, main_prog_cnt;
 	enum bpf_prog_type type;
 
-	struct reloc_desc {
-		enum {
-			RELO_LD64,
-			RELO_CALL,
-			RELO_DATA,
-		} type;
-		int insn_idx;
-		union {
-			int map_idx;
-			int text_off;
-		};
-	} *reloc_desc;
+	struct reloc_desc *reloc_desc;
 	int nr_reloc;
 	int log_level;
 
@@ -209,12 +216,14 @@ enum libbpf_map_type {
 	LIBBPF_MAP_DATA,
 	LIBBPF_MAP_BSS,
 	LIBBPF_MAP_RODATA,
+	LIBBPF_MAP_EXTERN,
 };
 
 static const char * const libbpf_type_to_btf_name[] = {
 	[LIBBPF_MAP_DATA]	= ".data",
 	[LIBBPF_MAP_BSS]	= ".bss",
 	[LIBBPF_MAP_RODATA]	= ".rodata",
+	[LIBBPF_MAP_EXTERN]	= ".extern",
 };
 
 struct bpf_map {
@@ -238,6 +247,13 @@ struct bpf_map {
 struct bpf_secdata {
 	void *rodata;
 	void *data;
+	void *extern_data;
+};
+
+struct extern_desc {
+	const char *name;
+	__u32 data_off;
+	int sym_idx;
 };
 
 static LIST_HEAD(bpf_objects_list);
@@ -254,6 +270,10 @@ struct bpf_object {
 	size_t maps_cap;
 	struct bpf_secdata sections;
 
+	struct extern_desc *externs;
+	int nr_extern;
+	int extern_map_idx;
+
 	bool loaded;
 	bool has_pseudo_calls;
 	bool relaxed_core_relocs;
@@ -281,6 +301,7 @@ struct bpf_object {
 		int maps_shndx;
 		int btf_maps_shndx;
 		int text_shndx;
+		int symbols_shndx;
 		int data_shndx;
 		int rodata_shndx;
 		int bss_shndx;
@@ -839,7 +860,8 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
 
 static int
 bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
-			      int sec_idx, Elf_Data *data, void **data_buff)
+			      int sec_idx, void *data, size_t data_sz,
+			      void **data_copy)
 {
 	char map_name[BPF_OBJ_NAME_LEN];
 	struct bpf_map_def *def;
@@ -859,27 +881,30 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 		pr_warn("failed to alloc map name\n");
 		return -ENOMEM;
 	}
+	pr_debug("map '%s' (%s): at sec_idx %d, offset %zu.\n", map_name,
+		 libbpf_type_to_btf_name[type], map->sec_idx, map->sec_offset);
 
 	def = &map->def;
 	def->type = BPF_MAP_TYPE_ARRAY;
 	def->key_size = sizeof(int);
-	def->value_size = data->d_size;
+	def->value_size = data_sz;
 	def->max_entries = 1;
-	def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
+	def->map_flags = type == LIBBPF_MAP_RODATA || type == LIBBPF_MAP_EXTERN
+			 ? BPF_F_RDONLY_PROG : 0;
 	if (obj->caps.array_mmap)
 		def->map_flags |= BPF_F_MMAPABLE;
 
 	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
 		 map_name, map->sec_idx, map->sec_offset, def->map_flags);
 
-	if (data_buff) {
-		*data_buff = malloc(data->d_size);
-		if (!*data_buff) {
+	if (data_copy) {
+		*data_copy = malloc(data_sz);
+		if (!*data_copy) {
 			zfree(&map->name);
 			pr_warn("failed to alloc map content buffer\n");
 			return -ENOMEM;
 		}
-		memcpy(*data_buff, data->d_buf, data->d_size);
+		memcpy(*data_copy, data, data_sz);
 	}
 
 	pr_debug("map %td is \"%s\"\n", map - obj->maps, map->name);
@@ -898,7 +923,8 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 	if (obj->efile.data_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_DATA,
 						    obj->efile.data_shndx,
-						    obj->efile.data,
+						    obj->efile.data->d_buf,
+						    obj->efile.data->d_size,
 						    &obj->sections.data);
 		if (err)
 			return err;
@@ -906,7 +932,8 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 	if (obj->efile.rodata_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_RODATA,
 						    obj->efile.rodata_shndx,
-						    obj->efile.rodata,
+						    obj->efile.rodata->d_buf,
+						    obj->efile.rodata->d_size,
 						    &obj->sections.rodata);
 		if (err)
 			return err;
@@ -914,13 +941,173 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 	if (obj->efile.bss_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_BSS,
 						    obj->efile.bss_shndx,
-						    obj->efile.bss, NULL);
+						    obj->efile.bss->d_buf,
+						    obj->efile.bss->d_size,
+						    NULL);
 		if (err)
 			return err;
 	}
 	return 0;
 }
 
+
+static int find_extern_by_name(const void *name, const void *_ext)
+{
+	const struct extern_desc *ext = _ext;
+
+	return strcmp(name, ext->name);
+}
+
+static int bpf_object__read_kernel_config(struct bpf_object *obj,
+					  const char *config_path)
+{
+	char buf[PATH_MAX], *sep, *value, *value_end;
+	struct extern_desc *ext;
+	int len, err = 0;
+	__u64 *ext_val;
+	gzFile file;
+
+	if (config_path) {
+		file = gzopen(config_path, "r");
+	} else {
+		struct utsname uts;
+
+		uname(&uts);
+		len = snprintf(buf, PATH_MAX, "/boot/config-%s", uts.release);
+		if (len < 0)
+			return -EINVAL;
+		else if (len >= PATH_MAX)
+			return -ENAMETOOLONG;
+		/* gzopen also accepts uncompressed files. */
+		file = gzopen(buf, "r");
+		if (!file)
+			file = gzopen("/proc/config.gz", "r");
+	}
+	if (!file) {
+		pr_warn("failed to read kernel config at '%s'\n", config_path);
+		return -ENOENT;
+	}
+
+	while (gzgets(file, buf, sizeof(buf))) {
+		if (strncmp(buf, "CONFIG_", 7))
+			continue;
+
+		sep = strchr(buf, '=');
+		if (!sep) {
+			err = -EINVAL;
+			pr_warn("failed to parse '%s': no separator\n", buf);
+			goto out;
+		}
+		/* Trim ending '\n' */
+		buf[strlen(buf) - 1] = '\0';
+		/* Split on '=' and ensure that a value is present. */
+		*sep = '\0';
+		if (!sep[1]) {
+			err = -EINVAL;
+			*sep = '=';
+			pr_warn("failed to parse '%s': no value\n", buf);
+			goto out;
+		}
+
+		ext = bsearch(buf, obj->externs, obj->nr_extern, sizeof(*ext),
+			      find_extern_by_name);
+		if (!ext)
+			continue;
+
+		ext_val = (__u64 *)(obj->sections.extern_data + ext->data_off);
+		value = sep + 1;
+
+		switch (*value) {
+		case 'n':
+			*ext_val = 0;
+			break;
+		case 'y':
+			*ext_val = 1;
+			break;
+		case 'm':
+			*ext_val = 2;
+			break;
+		case '"':
+			pr_warn("extern '%s': strings are not supported\n",
+				ext->name);
+			err = -EINVAL;
+			goto out;
+		default:
+			errno = 0;
+			*ext_val = strtoull(value, &value_end, 10);
+			if (errno) {
+				err = -errno;
+				pr_warn("extern '%s': failed to parse value: %d\n",
+					ext->name, err);
+				goto out;
+			}
+			if (*value_end && *value_end != '\n') {
+				err = -EINVAL;
+				pr_warn("extern '%s': failed to parse value\n",
+					ext->name);
+				goto out;
+			}
+			break;
+		}
+		pr_debug("extern '%s' = %llu\n", ext->name, *ext_val);
+	}
+
+out:
+	gzclose(file);
+	return err;
+}
+
+static int bpf_object__init_extern_map(struct bpf_object *obj,
+				       const char *config_path)
+{
+	bool need_config = false;
+	struct extern_desc *ext;
+	__u64 *ext_val;
+	int err, i;
+
+	if (obj->nr_extern == 0)
+		return 0;
+	if (!obj->caps.global_data)
+		return -ENOTSUP;
+
+	obj->sections.extern_data = calloc(obj->nr_extern, sizeof(__u64));
+	if (!obj->sections.extern_data)
+		return -ENOMEM;
+
+	for (i = 0; i < obj->nr_extern; i++) {
+		ext = &obj->externs[i];
+		ext_val = (__u64 *)(obj->sections.extern_data + ext->data_off);
+
+		if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
+			*ext_val = get_kernel_version();
+			if (*ext_val == 0) {
+				pr_warn("failed to get kernel version\n");
+				return -EINVAL;
+			}
+			pr_debug("extern '%s' = 0x%llx\n", ext->name, *ext_val);
+		} else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
+			need_config = true;
+		} else {
+			pr_warn("unrecognized extern: '%s'\n", ext->name);
+			return -EINVAL;
+		}
+	}
+	if (need_config) {
+		err = bpf_object__read_kernel_config(obj, config_path);
+		if (err)
+			return -EINVAL;
+	}
+
+	err = bpf_object__init_internal_map(obj, LIBBPF_MAP_EXTERN,
+					    obj->efile.symbols_shndx,
+					    obj->sections.extern_data,
+					    obj->nr_extern * sizeof(__u64),
+					    NULL);
+	if (!err)
+		obj->extern_map_idx = obj->nr_maps - 1;
+	return err;
+}
+
 static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 {
 	Elf_Data *symbols = obj->efile.symbols;
@@ -1395,12 +1582,17 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 	return 0;
 }
 
-static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps,
-				 const char *pin_root_path)
+static int bpf_object__init_maps(struct bpf_object *obj,
+				 const struct bpf_object_open_opts *opts)
 {
-	bool strict = !relaxed_maps;
+	const char *pin_root_path, *config_path;
+	bool strict;
 	int err;
 
+	strict = !OPTS_GET(opts, relaxed_maps, false);
+	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
+	config_path = OPTS_GET(opts, kernel_config_path, NULL);
+
 	err = bpf_object__init_user_maps(obj, strict);
 	if (err)
 		return err;
@@ -1413,6 +1605,10 @@ static int bpf_object__init_maps(struct bpf_object *obj, bool relaxed_maps,
 	if (err)
 		return err;
 
+	err = bpf_object__init_extern_map(obj, config_path);
+	if (err)
+		return err;
+
 	if (obj->nr_maps) {
 		qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
 		      compare_bpf_map);
@@ -1594,8 +1790,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
-				   const char *pin_root_path)
+static int bpf_object__elf_collect(struct bpf_object *obj)
 {
 	Elf *elf = obj->efile.elf;
 	GElf_Ehdr *ep = &obj->efile.ehdr;
@@ -1667,6 +1862,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 				return -LIBBPF_ERRNO__FORMAT;
 			}
 			obj->efile.symbols = data;
+			obj->efile.symbols_shndx = idx;
 			obj->efile.strtabidx = sh.sh_link;
 		} else if (sh.sh_type == SHT_PROGBITS && data->d_size > 0) {
 			if (sh.sh_flags & SHF_EXECINSTR) {
@@ -1730,14 +1926,81 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 		pr_warn("Corrupted ELF file: index of strtab invalid\n");
 		return -LIBBPF_ERRNO__FORMAT;
 	}
-	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
-	if (!err)
-		err = bpf_object__init_maps(obj, relaxed_maps, pin_root_path);
-	if (!err)
-		err = bpf_object__sanitize_and_load_btf(obj);
-	if (!err)
-		err = bpf_object__init_prog_names(obj);
-	return err;
+	return bpf_object__init_btf(obj, btf_data, btf_ext_data);
+}
+
+static bool sym_is_extern(const GElf_Sym *sym)
+{
+	/* externs are symbols with type=NOTYPE, bind=GLOBAL, section=UND */
+	return sym->st_shndx == SHN_UNDEF &&
+	       GELF_ST_BIND(sym->st_info) == STB_GLOBAL &&
+	       GELF_ST_TYPE(sym->st_info) == STT_NOTYPE;
+}
+
+static int cmp_extern_by_name(const void *_a, const void *_b)
+{
+	const struct extern_desc *a = _a;
+	const struct extern_desc *b = _b;
+
+	return strcmp(a->name, b->name);
+}
+
+static int bpf_object__collect_externs(struct bpf_object *obj)
+{
+	struct extern_desc *ext;
+	Elf_Scn *scn;
+	GElf_Shdr sh;
+	int i, n;
+
+	if (!obj->efile.symbols)
+		return 0;
+
+	scn = elf_getscn(obj->efile.elf, obj->efile.symbols_shndx);
+	if (!scn)
+		return -LIBBPF_ERRNO__FORMAT;
+	if (gelf_getshdr(scn, &sh) != &sh)
+		return -LIBBPF_ERRNO__FORMAT;
+	n = sh.sh_size / sh.sh_entsize;
+
+	pr_debug("looking for externs among %d symbols...\n", n);
+	for (i = 0; i < n; i++) {
+		const char *sym_name;
+		GElf_Sym sym;
+
+		if (!gelf_getsym(obj->efile.symbols, i, &sym))
+			return -LIBBPF_ERRNO__FORMAT;
+		if (!sym_is_extern(&sym))
+			continue;
+		sym_name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
+				      sym.st_name);
+		if (!sym_name || !sym_name[0])
+			continue;
+
+		ext = obj->externs;
+		ext = reallocarray(ext, obj->nr_extern + 1, sizeof(*ext));
+		if (!ext)
+			return -ENOMEM;
+		obj->externs = ext;
+
+		ext = &ext[obj->nr_extern];
+		ext->name = strdup(sym_name);
+		ext->sym_idx = i;
+		if (!ext->name)
+			return -ENOMEM;
+		obj->nr_extern++;
+	}
+	pr_debug("collected %d externs total\n", obj->nr_extern);
+
+	/* sort externs by name and calculate their offsets within a map */
+	qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_extern_by_name);
+	for (i = 0; i < obj->nr_extern; i++) {
+		ext = &obj->externs[i];
+		ext->data_off = i * sizeof(__u64);
+		pr_debug("extern #%d: symbol %d, off %u, name %s\n",
+			 i, ext->sym_idx, ext->data_off, ext->name);
+	}
+
+	return 0;
 }
 
 static struct bpf_program *
@@ -1791,6 +2054,8 @@ bpf_object__section_to_libbpf_map_type(const struct bpf_object *obj, int shndx)
 		return LIBBPF_MAP_BSS;
 	else if (shndx == obj->efile.rodata_shndx)
 		return LIBBPF_MAP_RODATA;
+	else if (shndx == obj->efile.symbols_shndx)
+		return LIBBPF_MAP_EXTERN;
 	else
 		return LIBBPF_MAP_UNSPEC;
 }
@@ -1830,6 +2095,30 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 			insn_idx, insn->code);
 		return -LIBBPF_ERRNO__RELOC;
 	}
+
+	if (sym_is_extern(sym)) {
+		int sym_idx = GELF_R_SYM(rel->r_info);
+		int i, n = obj->nr_extern;
+		struct extern_desc *ext;
+
+		for (i = 0; i < n; i++) {
+			ext = &obj->externs[i];
+			if (ext->sym_idx == sym_idx)
+				break;
+		}
+		if (i >= n) {
+			pr_warn("extern relo failed to find extern for sym %d\n",
+				sym_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		pr_debug("found extern #%d '%s' (sym %d, off %u) for insn %u\n",
+			 i, ext->name, ext->sym_idx, ext->data_off, insn_idx);
+		reloc_desc->type = RELO_EXTERN;
+		reloc_desc->insn_idx = insn_idx;
+		reloc_desc->data_off = ext->data_off;
+		return 0;
+	}
+
 	if (!shdr_idx || shdr_idx >= SHN_LORESERVE) {
 		pr_warn("invalid relo for \'%s\' in special section 0x%x; forgot to initialize global var?..\n",
 			name, shdr_idx);
@@ -2296,23 +2585,41 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero = 0;
 	__u8 *data;
+	bool freeze;
 
-	/* Nothing to do here since kernel already zero-initializes .bss map. */
-	if (map->libbpf_type == LIBBPF_MAP_BSS)
+	switch (map->libbpf_type) {
+	case LIBBPF_MAP_BSS:
+		/* kernel already zero-initializes .bss map. */
 		return 0;
-
-	data = map->libbpf_type == LIBBPF_MAP_DATA ?
-	       obj->sections.data : obj->sections.rodata;
+	case LIBBPF_MAP_DATA:
+		data = obj->sections.data;
+		freeze = false;
+		break;
+	case LIBBPF_MAP_RODATA:
+		data = obj->sections.rodata;
+		freeze = true;
+		break;
+	case LIBBPF_MAP_EXTERN:
+		data = obj->sections.extern_data;
+		freeze = true;
+		break;
+	case LIBBPF_MAP_UNSPEC:
+	default:
+		return -EINVAL;
+	}
 
 	err = bpf_map_update_elem(map->fd, &zero, data, 0);
-	/* Freeze .rodata map as read-only from syscall side. */
-	if (!err && map->libbpf_type == LIBBPF_MAP_RODATA) {
+	if (err)
+		return -errno;
+
+	/* Freeze .rodata or .externs map as read-only from syscall side. */
+	if (freeze) {
 		err = bpf_map_freeze(map->fd);
 		if (err) {
+			err = -errno;
 			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 			pr_warn("Error freezing map(%s) as read-only: %s\n",
 				map->name, cp);
-			err = 0;
 		}
 	}
 	return err;
@@ -3554,9 +3861,6 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 	size_t new_cnt;
 	int err;
 
-	if (relo->type != RELO_CALL)
-		return -LIBBPF_ERRNO__RELOC;
-
 	if (prog->idx == obj->efile.text_shndx) {
 		pr_warn("relo in .text insn %d into off %d\n",
 			relo->insn_idx, relo->text_off);
@@ -3617,33 +3921,38 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 		return 0;
 
 	for (i = 0; i < prog->nr_reloc; i++) {
-		if (prog->reloc_desc[i].type == RELO_LD64 ||
-		    prog->reloc_desc[i].type == RELO_DATA) {
-			bool relo_data = prog->reloc_desc[i].type == RELO_DATA;
-			struct bpf_insn *insns = prog->insns;
-			int insn_idx, map_idx;
+		struct reloc_desc *relo = &prog->reloc_desc[i];
+		struct bpf_insn *insns = prog->insns;
+		int insn_idx = relo->insn_idx;
 
-			insn_idx = prog->reloc_desc[i].insn_idx;
-			map_idx = prog->reloc_desc[i].map_idx;
-
-			if (insn_idx + 1 >= (int)prog->insns_cnt) {
-				pr_warn("relocation out of range: '%s'\n",
-					prog->section_name);
-				return -LIBBPF_ERRNO__RELOC;
-			}
+		if (insn_idx + 1 >= (int)prog->insns_cnt) {
+			pr_warn("relo #%d: insn out of range %d\n", i, insn_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
 
-			if (!relo_data) {
-				insns[insn_idx].src_reg = BPF_PSEUDO_MAP_FD;
-			} else {
-				insns[insn_idx].src_reg = BPF_PSEUDO_MAP_VALUE;
-				insns[insn_idx + 1].imm = insns[insn_idx].imm;
-			}
-			insns[insn_idx].imm = obj->maps[map_idx].fd;
-		} else if (prog->reloc_desc[i].type == RELO_CALL) {
-			err = bpf_program__reloc_text(prog, obj,
-						      &prog->reloc_desc[i]);
+		switch (relo->type) {
+		case RELO_LD64:
+			insns[insn_idx].src_reg = BPF_PSEUDO_MAP_FD;
+			insns[insn_idx].imm = obj->maps[relo->map_idx].fd;
+			break;
+		case RELO_DATA:
+			insns[insn_idx].src_reg = BPF_PSEUDO_MAP_VALUE;
+			insns[insn_idx + 1].imm = insns[insn_idx].imm;
+			insns[insn_idx].imm = obj->maps[relo->map_idx].fd;
+			break;
+		case RELO_EXTERN:
+			insns[insn_idx].src_reg = BPF_PSEUDO_MAP_VALUE;
+			insns[insn_idx].imm = obj->maps[obj->extern_map_idx].fd;
+			insns[insn_idx + 1].imm = relo->data_off;
+			break;
+		case RELO_CALL:
+			err = bpf_program__reloc_text(prog, obj, relo);
 			if (err)
 				return err;
+			break;
+		default:
+			pr_warn("relo #%d: bad relo type %d\n", i, relo->type);
+			return -EINVAL;
 		}
 	}
 
@@ -3917,12 +4226,10 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
 {
-	const char *pin_root_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	const char *obj_name;
 	char tmp_name[64];
-	bool relaxed_maps;
 	__u32 attach_prog_fd;
 	int err;
 
@@ -3952,16 +4259,19 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		return obj;
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
-	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
-	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
 	attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
 
-	CHECK_ERR(bpf_object__elf_init(obj), err, out);
-	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
-	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
-	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps, pin_root_path),
-		  err, out);
-	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
+	err = bpf_object__elf_init(obj);
+	err = err ? : bpf_object__check_endianness(obj);
+	err = err ? : bpf_object__probe_caps(obj);
+	err = err ? : bpf_object__elf_collect(obj);
+	err = err ? : bpf_object__collect_externs(obj);
+	err = err ? : bpf_object__init_maps(obj, opts);
+	err = err ? : bpf_object__sanitize_and_load_btf(obj);
+	err = err ? : bpf_object__init_prog_names(obj);
+	err = err ? : bpf_object__collect_reloc(obj);
+	if (err)
+		goto out;
 	bpf_object__elf_finish(obj);
 
 	bpf_object__for_each_program(prog, obj) {
@@ -4681,6 +4991,9 @@ void bpf_object__close(struct bpf_object *obj)
 
 	zfree(&obj->sections.rodata);
 	zfree(&obj->sections.data);
+	zfree(&obj->sections.extern_data);
+	zfree(&obj->externs);
+	obj->nr_extern = 0;
 	zfree(&obj->maps);
 	obj->nr_maps = 0;
 
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0dbf4bfba0c4..30b920879319 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -103,14 +103,18 @@ struct bpf_object_open_opts {
 	bool relaxed_maps;
 	/* process CO-RE relocations non-strictly, allowing them to fail */
 	bool relaxed_core_relocs;
+	__u32 attach_prog_fd;
 	/* maps that set the 'pinning' attribute in their definition will have
 	 * their pin_path attribute set to a file in this directory, and be
 	 * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
 	 */
 	const char *pin_root_path;
-	__u32 attach_prog_fd;
+	/* kernel config file path override (for CONFIG_ externs); can point
+	 * to either uncompressed text file or .gz file
+	 */
+	const char *kernel_config_path;
 };
-#define bpf_object_open_opts__last_field attach_prog_fd
+#define bpf_object_open_opts__last_field kernel_config_path
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5737888cd6a7..df3f42aa9a1a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -22,7 +22,7 @@ CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR)	\
 	  -I$(GENDIR) -I$(TOOLSDIR) -I$(CURDIR)				\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
-LDLIBS += -lcap -lelf -lrt -lpthread
+LDLIBS += -lcap -lelf -lz -lrt -lpthread
 
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
-- 
2.17.1

