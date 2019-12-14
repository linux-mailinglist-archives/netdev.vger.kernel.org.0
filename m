Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961FD11EFC6
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLNBrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:47:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30870 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfLNBrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:47:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE1hpof003445
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:47:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=vLL/Cdj6cvaM62y9+0f0nlw8K8zcNUULLc/g/6sqYfw=;
 b=nHGFhLl8lxkU2Mrk7sCNjbVmgWL/u2poYvdK0QZbyjnLCJc0el/NqjLsvKyTQv797BKQ
 oaMAuD63B0OpQ46tTQ5KaRfChZ6R1wPQnH1btsia2D6rkEEPuuVbWdEc0VG6t4lgx8+5
 pAUzKKf5gBVq0aTEHmXaPYd4XJyWXXUHLlw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvjpr0xdw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:47:18 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 13 Dec 2019 17:47:17 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9D6C12EC1D1F; Fri, 13 Dec 2019 17:47:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern variables
Date:   Fri, 13 Dec 2019 17:47:08 -0800
Message-ID: <20191214014710.3449601-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014710.3449601-1-andriin@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 suspectscore=29 phishscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for extern variables, provided to BPF program by libbpf. Currently
the following extern variables are supported:
  - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
    executing, follows KERNEL_VERSION() macro convention, can be 4- and 8-byte
    long;
  - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
    boolean, strings, and integer values are supported.

Set of possible values is determined by declared type of extern variable.
Supported types of variables are:
- Tristate values. Are represented as `enum libbpf_tristate`. Accepted values
  are **strictly** 'y', 'n', or 'm', which are represented as TRI_YES, TRI_NO,
  or TRI_MODULE, respectively.
- Boolean values. Are represented as bool (_Bool) types. Accepted values are
  'y' and 'n' only, turning into true/false values, respectively.
- Single-character values. Can be used both as a substritute for
  bool/tristate, or as a small-range integer:
  - 'y'/'n'/'m' are represented as is, as characters 'y', 'n', or 'm';
  - integers in a range [-128, 127] or [0, 255] (depending on signedness of
    char in target architecture) are recognized and represented with
    respective values of char type.
- Strings. String values are declared as fixed-length char arrays. String of
  up to that length will be accepted and put in first N bytes of char array,
  with the rest of bytes zeroed out. If config string value is longer than
  space alloted, it will be truncated and warning message emitted. Char array
  is always zero terminated. String literals in config have to be enclosed in
  double quotes, just like C-style string literals.
- Integers. 8-, 16-, 32-, and 64-bit integers are supported, both signed and
  unsigned variants. Libbpf enforces parsed config value to be in the
  supported range of corresponding integer type. Integers values in config can
  be:
  - decimal integers, with optional + and - signs;
  - hexadecimal integers, prefixed with 0x or 0X;
  - octal integers, starting with 0.

Config file itself is searched in /boot/config-$(uname -r) location with
fallback to /proc/config.gz, unless config path is specified explicitly
through bpf_object_open_opts' kernel_config_path option. Both gzipped and
plain text formats are supported. Libbpf adds explicit dependency on zlib
because of this, but this shouldn't be a problem, given libelf already depends
on zlib.

All detected extern variables, are put into a separate .extern internal map.
It, similarly to .rodata map, is marked as read-only from BPF program side, as
well as is frozen on load. This allows BPF verifier to track extern values as
constants and perform enhanced branch prediction and dead code elimination.
This can be relied upon for doing kernel version/feature detection and using
potentially unsupported field relocations or BPF helpers in a CO-RE-based BPF
program, while still having a single version of BPF program running on old and
new kernels. Selftests are validating this explicitly for unexisting BPF
helper.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/btf.h             |   3 +-
 tools/include/uapi/linux/btf.h       |   7 +-
 tools/lib/bpf/Makefile               |  15 +-
 tools/lib/bpf/bpf_helpers.h          |   9 +
 tools/lib/bpf/btf.c                  |   9 +-
 tools/lib/bpf/libbpf.c               | 738 +++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h               |  12 +-
 tools/testing/selftests/bpf/Makefile |   2 +-
 8 files changed, 729 insertions(+), 66 deletions(-)

diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index c02dec97e1ce..1a2898c482ee 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -142,7 +142,8 @@ struct btf_param {
 
 enum {
 	BTF_VAR_STATIC = 0,
-	BTF_VAR_GLOBAL_ALLOCATED,
+	BTF_VAR_GLOBAL_ALLOCATED = 1,
+	BTF_VAR_GLOBAL_EXTERN = 2,
 };
 
 /* BTF_KIND_VAR is followed by a single "struct btf_var" to describe
diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index 63ae4a39e58b..1a2898c482ee 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -22,9 +22,9 @@ struct btf_header {
 };
 
 /* Max # of type identifier */
-#define BTF_MAX_TYPE	0x0000ffff
+#define BTF_MAX_TYPE	0x000fffff
 /* Max offset into the string section */
-#define BTF_MAX_NAME_OFFSET	0x0000ffff
+#define BTF_MAX_NAME_OFFSET	0x00ffffff
 /* Max # of struct/union/enum members or func args */
 #define BTF_MAX_VLEN	0xffff
 
@@ -142,7 +142,8 @@ struct btf_param {
 
 enum {
 	BTF_VAR_STATIC = 0,
-	BTF_VAR_GLOBAL_ALLOCATED,
+	BTF_VAR_GLOBAL_ALLOCATED = 1,
+	BTF_VAR_GLOBAL_EXTERN = 2,
 };
 
 /* BTF_KIND_VAR is followed by a single "struct btf_var" to describe
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index defae23a0169..c3fdb2907b96 100644
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
 
 bpf_helper_defs.h: $(srctree)/tools/include/uapi/linux/bpf.h
@@ -189,7 +189,7 @@ $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) \
 		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
-		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -o $@
+		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -lz -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
@@ -277,12 +277,15 @@ clean:
 
 
 
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
 
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 0c7d28292898..aa46700075e1 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -25,6 +25,9 @@
 #ifndef __always_inline
 #define __always_inline __attribute__((always_inline))
 #endif
+#ifndef __weak
+#define __weak __attribute__((weak))
+#endif
 
 /*
  * Helper structure used by eBPF C program
@@ -44,4 +47,10 @@ enum libbpf_pin_type {
 	LIBBPF_PIN_BY_NAME,
 };
 
+enum libbpf_tristate {
+	TRI_NO = 0,
+	TRI_YES = 1,
+	TRI_MODULE = 2,
+};
+
 #endif
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 84fe82f27bef..520021939d81 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -578,6 +578,12 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 		return -ENOENT;
 	}
 
+	/* .extern datasec size and var offsets were set correctly during
+	 * extern collection step, so just skip straight to sorting variables
+	 */
+	if (t->size)
+		goto sort_vars;
+
 	ret = bpf_object__section_size(obj, name, &size);
 	if (ret || !size || (t->size && t->size != size)) {
 		pr_debug("Invalid size for section %s: %u bytes\n", name, size);
@@ -614,7 +620,8 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 		vsi->offset = off;
 	}
 
-	qsort(t + 1, vars, sizeof(*vsi), compare_vsi_off);
+sort_vars:
+	qsort(btf_var_secinfos(t), vars, sizeof(*vsi), compare_vsi_off);
 	return 0;
 }
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f6c135869701..26144706ba0b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -44,6 +44,7 @@
 #include <tools/libc_compat.h>
 #include <libelf.h>
 #include <gelf.h>
+#include <zlib.h>
 
 #include "libbpf.h"
 #include "bpf.h"
@@ -139,6 +140,20 @@ struct bpf_capabilities {
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
+	int map_idx;
+	int sym_off;
+};
+
 /*
  * bpf_prog should be a better name but it has been used in
  * linux/filter.h.
@@ -157,16 +172,7 @@ struct bpf_program {
 	size_t insns_cnt, main_prog_cnt;
 	enum bpf_prog_type type;
 
-	struct reloc_desc {
-		enum {
-			RELO_LD64,
-			RELO_CALL,
-			RELO_DATA,
-		} type;
-		int insn_idx;
-		int map_idx;
-		int sym_off;
-	} *reloc_desc;
+	struct reloc_desc *reloc_desc;
 	int nr_reloc;
 	int log_level;
 
@@ -198,18 +204,21 @@ struct bpf_program {
 #define DATA_SEC ".data"
 #define BSS_SEC ".bss"
 #define RODATA_SEC ".rodata"
+#define EXTERN_SEC ".extern"
 
 enum libbpf_map_type {
 	LIBBPF_MAP_UNSPEC,
 	LIBBPF_MAP_DATA,
 	LIBBPF_MAP_BSS,
 	LIBBPF_MAP_RODATA,
+	LIBBPF_MAP_EXTERN,
 };
 
 static const char * const libbpf_type_to_btf_name[] = {
 	[LIBBPF_MAP_DATA]	= DATA_SEC,
 	[LIBBPF_MAP_BSS]	= BSS_SEC,
 	[LIBBPF_MAP_RODATA]	= RODATA_SEC,
+	[LIBBPF_MAP_EXTERN]	= EXTERN_SEC,
 };
 
 struct bpf_map {
@@ -231,6 +240,28 @@ struct bpf_map {
 	bool reused;
 };
 
+enum extern_type {
+	EXT_UNKNOWN,
+	EXT_CHAR,
+	EXT_BOOL,
+	EXT_INT,
+	EXT_TRISTATE,
+	EXT_CHAR_ARR,
+};
+
+struct extern_desc {
+	const char *name;
+	int sym_idx;
+	int btf_id;
+	enum extern_type type;
+	int sz;
+	int align;
+	int data_off;
+	bool is_signed;
+	bool is_weak;
+	bool is_set;
+};
+
 static LIST_HEAD(bpf_objects_list);
 
 struct bpf_object {
@@ -244,6 +275,11 @@ struct bpf_object {
 	size_t nr_maps;
 	size_t maps_cap;
 
+	char *kconfig_path;
+	struct extern_desc *externs;
+	int nr_extern;
+	int extern_map_idx;
+
 	bool loaded;
 	bool has_pseudo_calls;
 	bool relaxed_core_relocs;
@@ -271,6 +307,7 @@ struct bpf_object {
 		int maps_shndx;
 		int btf_maps_shndx;
 		int text_shndx;
+		int symbols_shndx;
 		int data_shndx;
 		int rodata_shndx;
 		int bss_shndx;
@@ -542,6 +579,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.data_shndx = -1;
 	obj->efile.rodata_shndx = -1;
 	obj->efile.bss_shndx = -1;
+	obj->extern_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
@@ -866,7 +904,8 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	def->key_size = sizeof(int);
 	def->value_size = data_sz;
 	def->max_entries = 1;
-	def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
+	def->map_flags = type == LIBBPF_MAP_RODATA || type == LIBBPF_MAP_EXTERN
+			 ? BPF_F_RDONLY_PROG : 0;
 	def->map_flags |= BPF_F_MMAPABLE;
 
 	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
@@ -883,7 +922,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 		return err;
 	}
 
-	if (type != LIBBPF_MAP_BSS)
+	if (data)
 		memcpy(map->mmaped, data, data_sz);
 
 	pr_debug("map %td is \"%s\"\n", map - obj->maps, map->name);
@@ -924,6 +963,271 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 	return 0;
 }
 
+
+static struct extern_desc *find_extern_by_name(const struct bpf_object *obj,
+					       const void *name)
+{
+	int i;
+
+	for (i = 0; i < obj->nr_extern; i++) {
+		if (strcmp(obj->externs[i].name, name) == 0)
+			return &obj->externs[i];
+	}
+	return NULL;
+}
+
+static int set_ext_value_tri(struct extern_desc *ext, void *ext_val,
+			     char value)
+{
+	switch (ext->type) {
+	case EXT_BOOL:
+		if (value == 'm') {
+			pr_warn("extern %s=%c should be tristate or char\n",
+				ext->name, value);
+			return -EINVAL;
+		}
+		*(bool *)ext_val = value == 'y' ? true : false;
+		break;
+	case EXT_TRISTATE:
+		if (value == 'y')
+			*(enum libbpf_tristate *)ext_val = TRI_YES;
+		else if (value == 'm')
+			*(enum libbpf_tristate *)ext_val = TRI_MODULE;
+		else /* value == 'n' */
+			*(enum libbpf_tristate *)ext_val = TRI_NO;
+		break;
+	case EXT_CHAR:
+		*(char *)ext_val = value;
+		break;
+	case EXT_UNKNOWN:
+	case EXT_INT:
+	case EXT_CHAR_ARR:
+	default:
+		pr_warn("extern %s=%c should be bool, tristate, or char\n",
+			ext->name, value);
+		return -EINVAL;
+	}
+	ext->is_set = true;
+	return 0;
+}
+
+static int set_ext_value_str(struct extern_desc *ext, char *ext_val,
+			     const char *value)
+{
+	size_t len;
+
+	if (ext->type != EXT_CHAR_ARR) {
+		pr_warn("extern %s=%s should char array\n", ext->name, value);
+		return -EINVAL;
+	}
+
+	len = strlen(value);
+	if (value[len - 1] != '"') {
+		pr_warn("extern '%s': invalid string config '%s'\n",
+			ext->name, value);
+		return -EINVAL;
+	}
+
+	/* strip quotes */
+	len -= 2;
+	if (len >= ext->sz) {
+		pr_warn("extern '%s': long string config %s of (%zu bytes) truncated to %d bytes\n",
+			ext->name, value, len, ext->sz - 1);
+		len = ext->sz - 1;
+	}
+	memcpy(ext_val, value + 1, len);
+	ext_val[len] = '\0';
+	ext->is_set = true;
+	return 0;
+}
+
+static int parse_u64(const char *value, __u64 *res)
+{
+	char *value_end;
+	int err;
+
+	errno = 0;
+	*res = strtoull(value, &value_end, 0);
+	if (errno) {
+		err = -errno;
+		pr_warn("failed to parse '%s' as integer: %d\n", value, err);
+		return err;
+	}
+	if (*value_end) {
+		pr_warn("failed to parse '%s' as integer completely\n", value);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static bool is_ext_value_in_range(const struct extern_desc *ext, __u64 v)
+{
+	int bit_sz = ext->sz * 8;
+
+	if (ext->sz == 8)
+		return true;
+
+	/* Validate that value stored in u64 fits in integer of `ext->sz`
+	 * bytes size without any loss of information. If the target integer
+	 * is signed, we rely on the following limits of integer type of
+	 * Y bits and subsequent transformation:
+	 *
+	 *     -2^(Y-1) <= X           <= 2^(Y-1) - 1
+	 *            0 <= X + 2^(Y-1) <= 2^Y - 1
+	 *            0 <= X + 2^(Y-1) <  2^Y
+	 *
+	 *  For unsigned target integer, check that all the (64 - Y) bits are
+	 *  zero.
+	 */
+	if (ext->is_signed)
+		return v + (1ULL << (bit_sz - 1)) < (1ULL << bit_sz);
+	else
+		return (v >> bit_sz) == 0;
+}
+
+static int set_ext_value_num(struct extern_desc *ext, void *ext_val,
+			     __u64 value)
+{
+	if (ext->type != EXT_INT && ext->type != EXT_CHAR) {
+		pr_warn("extern %s=%llu should be integer\n",
+			ext->name, value);
+		return -EINVAL;
+	}
+	if (!is_ext_value_in_range(ext, value)) {
+		pr_warn("extern %s=%llu value doesn't fit in %d bytes\n",
+			ext->name, value, ext->sz);
+		return -ERANGE;
+	}
+	switch (ext->sz) {
+		case 1: *(__u8 *)ext_val = value; break;
+		case 2: *(__u16 *)ext_val = value; break;
+		case 4: *(__u32 *)ext_val = value; break;
+		case 8: *(__u64 *)ext_val = value; break;
+		default:
+			return -EINVAL;
+	}
+	ext->is_set = true;
+	return 0;
+}
+
+static int bpf_object__read_kernel_config(struct bpf_object *obj,
+					  const char *config_path,
+					  void *data)
+{
+	char buf[PATH_MAX], *sep, *value;
+	struct extern_desc *ext;
+	int len, err = 0;
+	void *ext_val;
+	__u64 num;
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
+		len = strlen(buf);
+		if (buf[len - 1] == '\n')
+			buf[len - 1] = '\0';
+		/* Split on '=' and ensure that a value is present. */
+		*sep = '\0';
+		if (!sep[1]) {
+			err = -EINVAL;
+			*sep = '=';
+			pr_warn("failed to parse '%s': no value\n", buf);
+			goto out;
+		}
+
+		ext = find_extern_by_name(obj, buf);
+		if (!ext)
+			continue;
+		if (ext->is_set) {
+			err = -EINVAL;
+			pr_warn("re-defining extern '%s' not allowed\n", buf);
+			goto out;
+		}
+
+		ext_val = data + ext->data_off;
+		value = sep + 1;
+
+		switch (*value) {
+		case 'y': case 'n': case 'm':
+			err = set_ext_value_tri(ext, ext_val, *value);
+			break;
+		case '"':
+			err = set_ext_value_str(ext, ext_val, value);
+			break;
+		default:
+			/* assume integer */
+			err = parse_u64(value, &num);
+			if (err) {
+				pr_warn("extern %s=%s should be integer\n",
+					ext->name, value);
+				goto out;
+			}
+			err = set_ext_value_num(ext, ext_val, num);
+			break;
+		}
+		if (err)
+			goto out;
+		pr_debug("extern %s=%s\n", ext->name, value);
+	}
+
+out:
+	gzclose(file);
+	return err;
+}
+
+static int bpf_object__init_extern_map(struct bpf_object *obj)
+{
+	struct extern_desc *last_ext;
+	size_t map_sz;
+	int err;
+
+	if (obj->nr_extern == 0)
+		return 0;
+
+	last_ext = &obj->externs[obj->nr_extern - 1];
+	map_sz = last_ext->data_off + last_ext->sz;
+
+	err = bpf_object__init_internal_map(obj, LIBBPF_MAP_EXTERN,
+					    obj->efile.symbols_shndx,
+					    NULL, map_sz);
+	if (err)
+		return err;
+
+	obj->extern_map_idx = obj->nr_maps - 1;
+
+	return 0;
+}
+
 static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 {
 	Elf_Data *symbols = obj->efile.symbols;
@@ -1401,19 +1705,17 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 static int bpf_object__init_maps(struct bpf_object *obj,
 				 const struct bpf_object_open_opts *opts)
 {
-	const char *pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
-	bool strict = !OPTS_GET(opts, relaxed_maps, false);
+	const char *pin_root_path;
+	bool strict;
 	int err;
 
-	err = bpf_object__init_user_maps(obj, strict);
-	if (err)
-		return err;
+	strict = !OPTS_GET(opts, relaxed_maps, false);
+	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
 
-	err = bpf_object__init_user_btf_maps(obj, strict, pin_root_path);
-	if (err)
-		return err;
-
-	err = bpf_object__init_global_data_maps(obj);
+	err = bpf_object__init_user_maps(obj, strict);
+	err = err ?: bpf_object__init_user_btf_maps(obj, strict, pin_root_path);
+	err = err ?: bpf_object__init_global_data_maps(obj);
+	err = err ?: bpf_object__init_extern_map(obj);
 	if (err)
 		return err;
 
@@ -1532,11 +1834,6 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 				BTF_ELF_SEC, err);
 			goto out;
 		}
-		err = btf__finalize_data(obj, obj->btf);
-		if (err) {
-			pr_warn("Error finalizing %s: %d.\n", BTF_ELF_SEC, err);
-			goto out;
-		}
 	}
 	if (btf_ext_data) {
 		if (!obj->btf) {
@@ -1570,6 +1867,30 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 	return 0;
 }
 
+static int bpf_object__finalize_btf(struct bpf_object *obj)
+{
+	int err;
+
+	if (!obj->btf)
+		return 0;
+
+	err = btf__finalize_data(obj, obj->btf);
+	if (!err)
+		return 0;
+
+	pr_warn("Error finalizing %s: %d.\n", BTF_ELF_SEC, err);
+	btf__free(obj->btf);
+	obj->btf = NULL;
+	btf_ext__free(obj->btf_ext);
+	obj->btf_ext = NULL;
+
+	if (bpf_object__is_btf_mandatory(obj)) {
+		pr_warn("BTF is required, but is missing or corrupted.\n");
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 {
 	int err = 0;
@@ -1670,6 +1991,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 				return -LIBBPF_ERRNO__FORMAT;
 			}
 			obj->efile.symbols = data;
+			obj->efile.symbols_shndx = idx;
 			obj->efile.strtabidx = sh.sh_link;
 		} else if (sh.sh_type == SHT_PROGBITS && data->d_size > 0) {
 			if (sh.sh_flags & SHF_EXECINSTR) {
@@ -1737,6 +2059,216 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 	return bpf_object__init_btf(obj, btf_data, btf_ext_data);
 }
 
+static bool sym_is_extern(const GElf_Sym *sym)
+{
+	int bind = GELF_ST_BIND(sym->st_info);
+	/* externs are symbols w/ type=NOTYPE, bind=GLOBAL|WEAK, section=UND */
+	return sym->st_shndx == SHN_UNDEF &&
+	       (bind == STB_GLOBAL || bind == STB_WEAK) &&
+	       GELF_ST_TYPE(sym->st_info) == STT_NOTYPE;
+}
+
+static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
+{
+	const struct btf_type *t;
+	const char *var_name;
+	int i, n;
+
+	if (!btf)
+		return -ESRCH;
+
+	n = btf__get_nr_types(btf);
+	for (i = 1; i <= n; i++) {
+		t = btf__type_by_id(btf, i);
+
+		if (!btf_is_var(t))
+			continue;
+
+		var_name = btf__name_by_offset(btf, t->name_off);
+		if (strcmp(var_name, ext_name))
+			continue;
+
+		if (btf_var(t)->linkage != BTF_VAR_GLOBAL_EXTERN)
+			return -EINVAL;
+
+		return i;
+	}
+
+	return -ENOENT;
+}
+
+static enum extern_type find_extern_type(const struct btf *btf, int id,
+					 bool *is_signed)
+{
+	const struct btf_type *t;
+	const char *name;
+
+	t = skip_mods_and_typedefs(btf, id, NULL);
+	name = btf__name_by_offset(btf, t->name_off);
+
+	if (is_signed)
+		*is_signed = false;
+	switch (btf_kind(t)) {
+	case BTF_KIND_INT: {
+		int enc = btf_int_encoding(t);
+
+		if (enc & BTF_INT_BOOL)
+			return t->size == 1 ? EXT_BOOL : EXT_UNKNOWN;
+		if (is_signed)
+			*is_signed = enc & BTF_INT_SIGNED;
+		if (t->size == 1)
+			return EXT_CHAR;
+		if (t->size < 1 || t->size > 8 || (t->size & (t->size - 1)))
+			return EXT_UNKNOWN;
+		return EXT_INT;
+	}
+	case BTF_KIND_ENUM:
+		if (t->size != 4)
+			return EXT_UNKNOWN;
+		if (strcmp(name, "libbpf_tristate"))
+			return EXT_UNKNOWN;
+		return EXT_TRISTATE;
+	case BTF_KIND_ARRAY:
+		if (btf_array(t)->nelems == 0)
+			return EXT_UNKNOWN;
+		if (find_extern_type(btf, btf_array(t)->type, NULL) != EXT_CHAR)
+			return EXT_UNKNOWN;
+		return EXT_CHAR_ARR;
+	default:
+		return EXT_UNKNOWN;
+	}
+}
+
+static int cmp_externs(const void *_a, const void *_b)
+{
+	const struct extern_desc *a = _a;
+	const struct extern_desc *b = _b;
+
+	/* descending order by alignment requirements */
+	if (a->align != b->align)
+		return a->align > b->align ? -1 : 1;
+	/* ascending order by size, within same alignment class */
+	if (a->sz != b->sz)
+		return a->sz < b->sz ? -1 : 1;
+	/* resolve ties by name */
+	return strcmp(a->name, b->name);
+}
+
+static int bpf_object__collect_externs(struct bpf_object *obj)
+{
+	const struct btf_type *t;
+	struct extern_desc *ext;
+	int i, n, off, btf_id;
+	struct btf_type *sec;
+	const char *ext_name;
+	Elf_Scn *scn;
+	GElf_Shdr sh;
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
+		GElf_Sym sym;
+
+		if (!gelf_getsym(obj->efile.symbols, i, &sym))
+			return -LIBBPF_ERRNO__FORMAT;
+		if (!sym_is_extern(&sym))
+			continue;
+		ext_name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
+				      sym.st_name);
+		if (!ext_name || !ext_name[0])
+			continue;
+
+		ext = obj->externs;
+		ext = reallocarray(ext, obj->nr_extern + 1, sizeof(*ext));
+		if (!ext)
+			return -ENOMEM;
+		obj->externs = ext;
+		ext = &ext[obj->nr_extern];
+		memset(ext, 0, sizeof(*ext));
+		obj->nr_extern++;
+
+		ext->btf_id = find_extern_btf_id(obj->btf, ext_name);
+		if (ext->btf_id <= 0) {
+			pr_warn("failed to find BTF for extern '%s': %d\n",
+				ext_name, ext->btf_id);
+			return ext->btf_id;
+		}
+		t = btf__type_by_id(obj->btf, ext->btf_id);
+		ext->name = btf__name_by_offset(obj->btf, t->name_off);
+		ext->sym_idx = i;
+		ext->is_weak = GELF_ST_BIND(sym.st_info) == STB_WEAK;
+		ext->sz = btf__resolve_size(obj->btf, t->type);
+		if (ext->sz <= 0) {
+			pr_warn("failed to resolve size of extern '%s': %d\n",
+				ext_name, ext->sz);
+			return ext->sz;
+		}
+		ext->align = btf__align_of(obj->btf, t->type);
+		if (ext->align <= 0) {
+			pr_warn("failed to determine alignment of extern '%s': %d\n",
+				ext_name, ext->align);
+			return -EINVAL;
+		}
+		ext->type = find_extern_type(obj->btf, t->type,
+					     &ext->is_signed);
+		if (ext->type == EXT_UNKNOWN) {
+			pr_warn("extern '%s' type is unsupported\n", ext_name);
+			return -ENOTSUP;
+		}
+	}
+	pr_debug("collected %d externs total\n", obj->nr_extern);
+
+	if (!obj->nr_extern)
+		return 0;
+
+	/* sort externs by (alignment, size, name) and calculate their offsets
+	 * within a map */
+	qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_externs);
+	off = 0;
+	for (i = 0; i < obj->nr_extern; i++) {
+		ext = &obj->externs[i];
+		ext->data_off = roundup(off, ext->align);
+		off = ext->data_off + ext->sz;
+		pr_debug("extern #%d: symbol %d, off %u, name %s\n",
+			 i, ext->sym_idx, ext->data_off, ext->name);
+	}
+
+	btf_id = btf__find_by_name(obj->btf, EXTERN_SEC);
+	if (btf_id <= 0) {
+		pr_warn("no BTF info found for '%s' datasec\n", EXTERN_SEC);
+		return -ESRCH;
+	}
+
+	sec = (struct btf_type *)btf__type_by_id(obj->btf, btf_id);
+	sec->size = off;
+	n = btf_vlen(sec);
+	for (i = 0; i < n; i++) {
+		struct btf_var_secinfo *vs = btf_var_secinfos(sec) + i;
+
+		t = btf__type_by_id(obj->btf, vs->type);
+		ext_name = btf__name_by_offset(obj->btf, t->name_off);
+		ext = find_extern_by_name(obj, ext_name);
+		if (!ext) {
+			pr_warn("failed to find extern definition for BTF var '%s'\n",
+				ext_name);
+			return -ESRCH;
+		}
+		vs->offset = ext->data_off;
+		btf_var(t)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
+	}
+
+	return 0;
+}
+
 static struct bpf_program *
 bpf_object__find_prog_by_idx(struct bpf_object *obj, int idx)
 {
@@ -1801,6 +2333,8 @@ bpf_object__section_to_libbpf_map_type(const struct bpf_object *obj, int shndx)
 		return LIBBPF_MAP_BSS;
 	else if (shndx == obj->efile.rodata_shndx)
 		return LIBBPF_MAP_RODATA;
+	else if (shndx == obj->efile.symbols_shndx)
+		return LIBBPF_MAP_EXTERN;
 	else
 		return LIBBPF_MAP_UNSPEC;
 }
@@ -1845,6 +2379,30 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
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
+		reloc_desc->sym_off = ext->data_off;
+		return 0;
+	}
+
 	if (!shdr_idx || shdr_idx >= SHN_LORESERVE) {
 		pr_warn("invalid relo for \'%s\' in special section 0x%x; forgot to initialize global var?..\n",
 			name, shdr_idx);
@@ -2306,11 +2864,12 @@ bpf_object__reuse_map(struct bpf_map *map)
 static int
 bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 {
+	enum libbpf_map_type map_type = map->libbpf_type;
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero = 0;
 
-	/* Nothing to do here since kernel already zero-initializes .bss map. */
-	if (map->libbpf_type == LIBBPF_MAP_BSS)
+	/* kernel already zero-initializes .bss map. */
+	if (map_type == LIBBPF_MAP_BSS)
 		return 0;
 
 	err = bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
@@ -2322,8 +2881,8 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 		return err;
 	}
 
-	/* Freeze .rodata map as read-only from syscall side. */
-	if (map->libbpf_type == LIBBPF_MAP_RODATA) {
+	/* Freeze .rodata and .extern map as read-only from syscall side. */
+	if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_EXTERN) {
 		err = bpf_map_freeze(map->fd);
 		if (err) {
 			err = -errno;
@@ -3572,9 +4131,6 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 	size_t new_cnt;
 	int err;
 
-	if (relo->type != RELO_CALL)
-		return -LIBBPF_ERRNO__RELOC;
-
 	if (prog->idx == obj->efile.text_shndx) {
 		pr_warn("relo in .text insn %d into off %d (insn #%d)\n",
 			relo->insn_idx, relo->sym_off, relo->sym_off / 8);
@@ -3636,27 +4192,37 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 
 	for (i = 0; i < prog->nr_reloc; i++) {
 		struct reloc_desc *relo = &prog->reloc_desc[i];
+		struct bpf_insn *insn = &prog->insns[relo->insn_idx];
 
-		if (relo->type == RELO_LD64 || relo->type == RELO_DATA) {
-			struct bpf_insn *insn = &prog->insns[relo->insn_idx];
-
-			if (relo->insn_idx + 1 >= (int)prog->insns_cnt) {
-				pr_warn("relocation out of range: '%s'\n",
-					prog->section_name);
-				return -LIBBPF_ERRNO__RELOC;
-			}
+		if (relo->insn_idx + 1 >= (int)prog->insns_cnt) {
+			pr_warn("relocation out of range: '%s'\n",
+				prog->section_name);
+			return -LIBBPF_ERRNO__RELOC;
+		}
 
-			if (relo->type != RELO_DATA) {
-				insn[0].src_reg = BPF_PSEUDO_MAP_FD;
-			} else {
-				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
-				insn[1].imm = insn[0].imm + relo->sym_off;
-			}
+		switch (relo->type) {
+		case RELO_LD64:
+			insn[0].src_reg = BPF_PSEUDO_MAP_FD;
+			insn[0].imm = obj->maps[relo->map_idx].fd;
+			break;
+		case RELO_DATA:
+			insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+			insn[1].imm = insn[0].imm + relo->sym_off;
 			insn[0].imm = obj->maps[relo->map_idx].fd;
-		} else if (relo->type == RELO_CALL) {
+			break;
+		case RELO_EXTERN:
+			insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+			insn[0].imm = obj->maps[obj->extern_map_idx].fd;
+			insn[1].imm = relo->sym_off;
+			break;
+		case RELO_CALL:
 			err = bpf_program__reloc_text(prog, obj, relo);
 			if (err)
 				return err;
+			break;
+		default:
+			pr_warn("relo #%d: bad relo type %d\n", i, relo->type);
+			return -EINVAL;
 		}
 	}
 
@@ -3936,11 +4502,10 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
 {
+	const char *obj_name, *kconfig_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
-	const char *obj_name;
 	char tmp_name[64];
-	__u32 attach_prog_fd;
 	int err;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
@@ -3969,11 +4534,18 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		return obj;
 
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
-	attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
+	kconfig_path = OPTS_GET(opts, kconfig_path, NULL);
+	if (kconfig_path) {
+		obj->kconfig_path = strdup(kconfig_path);
+		if (!obj->kconfig_path)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	err = bpf_object__elf_init(obj);
 	err = err ? : bpf_object__check_endianness(obj);
 	err = err ? : bpf_object__elf_collect(obj);
+	err = err ? : bpf_object__collect_externs(obj);
+	err = err ? : bpf_object__finalize_btf(obj);
 	err = err ? : bpf_object__init_maps(obj, opts);
 	err = err ? : bpf_object__init_prog_names(obj);
 	err = err ? : bpf_object__collect_reloc(obj);
@@ -3996,7 +4568,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
 		if (prog_type == BPF_PROG_TYPE_TRACING)
-			prog->attach_prog_fd = attach_prog_fd;
+			prog->attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
 	}
 
 	return obj;
@@ -4107,6 +4679,61 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__resolve_externs(struct bpf_object *obj,
+				       const char *config_path)
+{
+	bool need_config = false;
+	struct extern_desc *ext;
+	int err, i;
+	void *data;
+
+	if (obj->nr_extern == 0)
+		return 0;
+
+	data = obj->maps[obj->extern_map_idx].mmaped;
+
+	for (i = 0; i < obj->nr_extern; i++) {
+		ext = &obj->externs[i];
+
+		if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
+			void *ext_val = data + ext->data_off;
+			__u32 kver = get_kernel_version();
+
+			if (!kver) {
+				pr_warn("failed to get kernel version\n");
+				return -EINVAL;
+			}
+			err = set_ext_value_num(ext, ext_val, kver);
+			if (err)
+				return err;
+			pr_debug("extern %s=0x%x\n", ext->name, kver);
+		} else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
+			need_config = true;
+		} else {
+			pr_warn("unrecognized extern '%s'\n", ext->name);
+			return -EINVAL;
+		}
+	}
+	if (need_config) {
+		err = bpf_object__read_kernel_config(obj, config_path, data);
+		if (err)
+			return -EINVAL;
+	}
+	for (i = 0; i < obj->nr_extern; i++) {
+		ext = &obj->externs[i];
+
+		if (!ext->is_set && !ext->is_weak) {
+			pr_warn("extern %s (strong) not resolved\n", ext->name);
+			return -ESRCH;
+		} else if (!ext->is_set) {
+			pr_debug("extern %s (weak) not resolved, defaulting to zero\n",
+				 ext->name);
+		}
+	}
+
+	return 0;
+}
+
 int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
 	struct bpf_object *obj;
@@ -4126,6 +4753,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	obj->loaded = true;
 
 	err = bpf_object__probe_caps(obj);
+	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig_path);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
@@ -4719,6 +5347,10 @@ void bpf_object__close(struct bpf_object *obj)
 		zfree(&map->pin_path);
 	}
 
+	zfree(&obj->kconfig_path);
+	zfree(&obj->externs);
+	obj->nr_extern = 0;
+
 	zfree(&obj->maps);
 	obj->nr_maps = 0;
 
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 623191e71415..6340823871e2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -85,8 +85,12 @@ struct bpf_object_open_opts {
 	 */
 	const char *pin_root_path;
 	__u32 attach_prog_fd;
+	/* kernel config file path override (for CONFIG_ externs); can point
+	 * to either uncompressed text file or .gz file
+	 */
+	const char *kconfig_path;
 };
-#define bpf_object_open_opts__last_field attach_prog_fd
+#define bpf_object_open_opts__last_field kconfig_path
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
@@ -669,6 +673,12 @@ LIBBPF_API int bpf_object__attach_skeleton(struct bpf_object_skeleton *s);
 LIBBPF_API void bpf_object__detach_skeleton(struct bpf_object_skeleton *s);
 LIBBPF_API void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s);
 
+enum libbpf_tristate {
+	TRI_NO = 0,
+	TRI_YES = 1,
+	TRI_MODULE = 2,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f70c8e735120..ba90621617a8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -24,7 +24,7 @@ CFLAGS += -g -Wall -O2 $(GENFLAGS) -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR)	\
 	  -I$(GENDIR) -I$(TOOLSINCDIR) -I$(CURDIR)			\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
 	  -Dbpf_load_program=bpf_test_load_program
-LDLIBS += -lcap -lelf -lrt -lpthread
+LDLIBS += -lcap -lelf -lz -lrt -lpthread
 
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
-- 
2.17.1

