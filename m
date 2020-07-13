Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55CA21BDCB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGJTiX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 15:38:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35288 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728356AbgGJTiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:38:10 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-BGC3ty29O8KEaG180GppVA-1; Fri, 10 Jul 2020 15:38:00 -0400
X-MC-Unique: BGC3ty29O8KEaG180GppVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42375100CCCB;
        Fri, 10 Jul 2020 19:37:59 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AA4E1002391;
        Fri, 10 Jul 2020 19:37:57 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v6 bpf-next 1/9] bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
Date:   Fri, 10 Jul 2020 21:37:46 +0200
Message-Id: <20200710193754.3821104-2-jolsa@kernel.org>
In-Reply-To: <20200710193754.3821104-1-jolsa@kernel.org>
References: <20200710193754.3821104-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The resolve_btfids tool scans elf object for .BTF_ids section
and resolves its symbols with BTF ID values.

It will be used to during linking time to resolve arrays of BTF
ID values used in verifier, so these IDs do not need to be
resolved in runtime.

The expected layout of .BTF_ids section is described in main.c
header. Related kernel changes are coming in following changes.

Build issue reported by 0-DAY CI Kernel Test Service.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/resolve_btfids/Build    |  10 +
 tools/bpf/resolve_btfids/Makefile |  77 ++++
 tools/bpf/resolve_btfids/main.c   | 721 ++++++++++++++++++++++++++++++
 3 files changed, 808 insertions(+)
 create mode 100644 tools/bpf/resolve_btfids/Build
 create mode 100644 tools/bpf/resolve_btfids/Makefile
 create mode 100644 tools/bpf/resolve_btfids/main.c

diff --git a/tools/bpf/resolve_btfids/Build b/tools/bpf/resolve_btfids/Build
new file mode 100644
index 000000000000..ae82da03f9bf
--- /dev/null
+++ b/tools/bpf/resolve_btfids/Build
@@ -0,0 +1,10 @@
+resolve_btfids-y += main.o
+resolve_btfids-y += rbtree.o
+resolve_btfids-y += zalloc.o
+resolve_btfids-y += string.o
+resolve_btfids-y += ctype.o
+resolve_btfids-y += str_error_r.o
+
+$(OUTPUT)%.o: ../../lib/%.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
new file mode 100644
index 000000000000..948378ca73d4
--- /dev/null
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -0,0 +1,77 @@
+# SPDX-License-Identifier: GPL-2.0-only
+include ../../scripts/Makefile.include
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(CURDIR)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+endif
+
+ifeq ($(V),1)
+  Q =
+  msg =
+else
+  Q = @
+  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  MAKEFLAGS=--no-print-directory
+endif
+
+OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
+
+LIBBPF_SRC := $(srctree)/tools/lib/bpf/
+SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
+
+BPFOBJ     := $(OUTPUT)/libbpf.a
+SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
+
+BINARY     := $(OUTPUT)/resolve_btfids
+BINARY_IN  := $(BINARY)-in.o
+
+all: $(BINARY)
+
+$(OUTPUT):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $(OUTPUT)
+
+$(SUBCMDOBJ): fixdep FORCE
+	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
+
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
+
+CFLAGS := -g \
+          -I$(srctree)/tools/include \
+          -I$(srctree)/tools/include/uapi \
+          -I$(LIBBPF_SRC) \
+          -I$(SUBCMD_SRC)
+
+LIBS = -lelf -lz
+
+export srctree OUTPUT CFLAGS Q
+include $(srctree)/tools/build/Makefile.include
+
+$(BINARY_IN): fixdep FORCE
+	$(Q)$(MAKE) $(build)=resolve_btfids
+
+$(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
+	$(call msg,LINK,$@)
+	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
+
+libsubcmd-clean:
+	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
+
+libbpf-clean:
+	$(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
+
+clean: libsubcmd-clean libbpf-clean fixdep-clean
+	$(call msg,CLEAN,$(BINARY))
+	$(Q)$(RM) -f $(BINARY); \
+	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
+
+tags:
+	$(call msg,GEN,,tags)
+	$(Q)ctags -R . $(LIBBPF_SRC) $(SUBCMD_SRC)
+
+FORCE:
+
+.PHONY: all FORCE clean tags
diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
new file mode 100644
index 000000000000..91f44ae1c814
--- /dev/null
+++ b/tools/bpf/resolve_btfids/main.c
@@ -0,0 +1,721 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * resolve_btfids scans Elf object for .BTF_ids section and resolves
+ * its symbols with BTF ID values.
+ *
+ * Each symbol points to 4 bytes data and is expected to have
+ * following name syntax:
+ *
+ * __BTF_ID__<type>__<symbol>[__<id>]
+ *
+ * type is:
+ *
+ *   func    - lookup BTF_KIND_FUNC symbol with <symbol> name
+ *             and store its ID into the data:
+ *
+ *             __BTF_ID__func__vfs_close__1:
+ *             .zero 4
+ *
+ *   struct  - lookup BTF_KIND_STRUCT symbol with <symbol> name
+ *             and store its ID into the data:
+ *
+ *             __BTF_ID__struct__sk_buff__1:
+ *             .zero 4
+ *
+ *   union   - lookup BTF_KIND_UNION symbol with <symbol> name
+ *             and store its ID into the data:
+ *
+ *             __BTF_ID__union__thread_union__1:
+ *             .zero 4
+ *
+ *   typedef - lookup BTF_KIND_TYPEDEF symbol with <symbol> name
+ *             and store its ID into the data:
+ *
+ *             __BTF_ID__typedef__pid_t__1:
+ *             .zero 4
+ *
+ *   set     - store symbol size into first 4 bytes and sort following
+ *             ID list
+ *
+ *             __BTF_ID__set__list:
+ *             .zero 4
+ *             list:
+ *             __BTF_ID__func__vfs_getattr__3:
+ *             .zero 4
+ *             __BTF_ID__func__vfs_fallocate__4:
+ *             .zero 4
+ */
+
+#define  _GNU_SOURCE
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <libelf.h>
+#include <gelf.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <linux/rbtree.h>
+#include <linux/zalloc.h>
+#include <linux/err.h>
+#include <btf.h>
+#include <libbpf.h>
+#include <parse-options.h>
+
+#define BTF_IDS_SECTION	".BTF_ids"
+#define BTF_ID		"__BTF_ID__"
+
+#define BTF_STRUCT	"struct"
+#define BTF_UNION	"union"
+#define BTF_TYPEDEF	"typedef"
+#define BTF_FUNC	"func"
+#define BTF_SET		"set"
+
+#define ADDR_CNT	100
+
+struct btf_id {
+	struct rb_node	 rb_node;
+	char		*name;
+	union {
+		int	 id;
+		int	 cnt;
+	};
+	int		 addr_cnt;
+	Elf64_Addr	 addr[ADDR_CNT];
+};
+
+struct object {
+	const char *path;
+	const char *btf;
+
+	struct {
+		int		 fd;
+		Elf		*elf;
+		Elf_Data	*symbols;
+		Elf_Data	*idlist;
+		int		 symbols_shndx;
+		int		 idlist_shndx;
+		size_t		 strtabidx;
+		unsigned long	 idlist_addr;
+	} efile;
+
+	struct rb_root	sets;
+	struct rb_root	symbols;
+
+	int nr_funcs;
+	int nr_structs;
+	int nr_unions;
+	int nr_typedefs;
+};
+
+static int verbose;
+
+int eprintf(int level, int var, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	if (var >= level) {
+		va_start(args, fmt);
+		ret = vfprintf(stderr, fmt, args);
+		va_end(args);
+	}
+	return ret;
+}
+
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_debug(fmt, ...) \
+	eprintf(1, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debugN(n, fmt, ...) \
+	eprintf(n, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...) \
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+
+static bool is_btf_id(const char *name)
+{
+	return name && !strncmp(name, BTF_ID, sizeof(BTF_ID) - 1);
+}
+
+static struct btf_id *btf_id__find(struct rb_root *root, const char *name)
+{
+	struct rb_node *p = root->rb_node;
+	struct btf_id *id;
+	int cmp;
+
+	while (p) {
+		id = rb_entry(p, struct btf_id, rb_node);
+		cmp = strcmp(id->name, name);
+		if (cmp < 0)
+			p = p->rb_left;
+		else if (cmp > 0)
+			p = p->rb_right;
+		else
+			return id;
+	}
+	return NULL;
+}
+
+static struct btf_id*
+btf_id__add(struct rb_root *root, char *name, bool unique)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btf_id *id;
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		id = rb_entry(parent, struct btf_id, rb_node);
+		cmp = strcmp(id->name, name);
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else if (cmp > 0)
+			p = &(*p)->rb_right;
+		else
+			return unique ? NULL : id;
+	}
+
+	id = zalloc(sizeof(*id));
+	if (id) {
+		pr_debug("adding symbol %s\n", name);
+		id->name = name;
+		rb_link_node(&id->rb_node, parent, p);
+		rb_insert_color(&id->rb_node, root);
+	}
+	return id;
+}
+
+static char *get_id(const char *prefix_end)
+{
+	/*
+	 * __BTF_ID__func__vfs_truncate__0
+	 * prefix_end =  ^
+	 */
+	char *p, *id = strdup(prefix_end + sizeof("__") - 1);
+
+	if (id) {
+		/*
+		 * __BTF_ID__func__vfs_truncate__0
+		 * id =            ^
+		 *
+		 * cut the unique id part
+		 */
+		p = strrchr(id, '_');
+		p--;
+		if (*p != '_') {
+			free(id);
+			return NULL;
+		}
+		*p = '\0';
+	}
+	return id;
+}
+
+static struct btf_id *add_set(struct object *obj, char *name)
+{
+	char *id;
+
+	id = strdup(name + sizeof(BTF_SET) + sizeof("__") - 2);
+	if (!id) {
+		pr_err("FAILED to parse cnt name: %s\n", name);
+		return NULL;
+	}
+
+	return btf_id__add(&obj->sets, id, true);
+}
+
+static struct btf_id *add_symbol(struct object *obj, char *name, size_t size)
+{
+	char *id;
+
+	id = get_id(name + size);
+	if (!id) {
+		pr_err("FAILED to parse symbol name: %s\n", name);
+		return NULL;
+	}
+
+	return btf_id__add(&obj->symbols, id, false);
+}
+
+static int elf_collect(struct object *obj)
+{
+	Elf_Scn *scn = NULL;
+	size_t shdrstrndx;
+	int idx = 0;
+	Elf *elf;
+	int fd;
+
+	fd = open(obj->path, O_RDWR, 0666);
+	if (fd == -1) {
+		pr_err("FAILED cannot open %s: %s\n",
+			obj->path, strerror(errno));
+		return -1;
+	}
+
+	elf_version(EV_CURRENT);
+
+	elf = elf_begin(fd, ELF_C_RDWR_MMAP, NULL);
+	if (!elf) {
+		pr_err("FAILED cannot create ELF descriptor: %s\n",
+			elf_errmsg(-1));
+		return -1;
+	}
+
+	obj->efile.fd  = fd;
+	obj->efile.elf = elf;
+
+	elf_flagelf(elf, ELF_C_SET, ELF_F_LAYOUT);
+
+	if (elf_getshdrstrndx(elf, &shdrstrndx) != 0) {
+		pr_err("FAILED cannot get shdr str ndx\n");
+		return -1;
+	}
+
+	/*
+	 * Scan all the elf sections and look for save data
+	 * from .BTF_ids section and symbols.
+	 */
+	while ((scn = elf_nextscn(elf, scn)) != NULL) {
+		Elf_Data *data;
+		GElf_Shdr sh;
+		char *name;
+
+		idx++;
+		if (gelf_getshdr(scn, &sh) != &sh) {
+			pr_err("FAILED get section(%d) header\n", idx);
+			return -1;
+		}
+
+		name = elf_strptr(elf, shdrstrndx, sh.sh_name);
+		if (!name) {
+			pr_err("FAILED get section(%d) name\n", idx);
+			return -1;
+		}
+
+		data = elf_getdata(scn, 0);
+		if (!data) {
+			pr_err("FAILED to get section(%d) data from %s\n",
+				idx, name);
+			return -1;
+		}
+
+		pr_debug2("section(%d) %s, size %ld, link %d, flags %lx, type=%d\n",
+			  idx, name, (unsigned long) data->d_size,
+			  (int) sh.sh_link, (unsigned long) sh.sh_flags,
+			  (int) sh.sh_type);
+
+		if (sh.sh_type == SHT_SYMTAB) {
+			obj->efile.symbols       = data;
+			obj->efile.symbols_shndx = idx;
+			obj->efile.strtabidx     = sh.sh_link;
+		} else if (!strcmp(name, BTF_IDS_SECTION)) {
+			obj->efile.idlist       = data;
+			obj->efile.idlist_shndx = idx;
+			obj->efile.idlist_addr  = sh.sh_addr;
+		}
+	}
+
+	return 0;
+}
+
+static int symbols_collect(struct object *obj)
+{
+	Elf_Scn *scn = NULL;
+	int n, i, err = 0;
+	GElf_Shdr sh;
+	char *name;
+
+	scn = elf_getscn(obj->efile.elf, obj->efile.symbols_shndx);
+	if (!scn)
+		return -1;
+
+	if (gelf_getshdr(scn, &sh) != &sh)
+		return -1;
+
+	n = sh.sh_size / sh.sh_entsize;
+
+	/*
+	 * Scan symbols and look for the ones starting with
+	 * __BTF_ID__* over .BTF_ids section.
+	 */
+	for (i = 0; !err && i < n; i++) {
+		char *tmp, *prefix;
+		struct btf_id *id;
+		GElf_Sym sym;
+		int err = -1;
+
+		if (!gelf_getsym(obj->efile.symbols, i, &sym))
+			return -1;
+
+		if (sym.st_shndx != obj->efile.idlist_shndx)
+			continue;
+
+		name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
+				  sym.st_name);
+
+		if (!is_btf_id(name))
+			continue;
+
+		/*
+		 * __BTF_ID__TYPE__vfs_truncate__0
+		 * prefix =  ^
+		 */
+		prefix = name + sizeof(BTF_ID) - 1;
+
+		/* struct */
+		if (!strncmp(prefix, BTF_STRUCT, sizeof(BTF_STRUCT) - 1)) {
+			obj->nr_structs++;
+			id = add_symbol(obj, prefix, sizeof(BTF_STRUCT) - 1);
+		/* union  */
+		} else if (!strncmp(prefix, BTF_UNION, sizeof(BTF_UNION) - 1)) {
+			obj->nr_unions++;
+			id = add_symbol(obj, prefix, sizeof(BTF_UNION) - 1);
+		/* typedef */
+		} else if (!strncmp(prefix, BTF_TYPEDEF, sizeof(BTF_TYPEDEF) - 1)) {
+			obj->nr_typedefs++;
+			id = add_symbol(obj, prefix, sizeof(BTF_TYPEDEF) - 1);
+		/* func */
+		} else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
+			obj->nr_funcs++;
+			id = add_symbol(obj, prefix, sizeof(BTF_FUNC) - 1);
+		/* set */
+		} else if (!strncmp(prefix, BTF_SET, sizeof(BTF_SET) - 1)) {
+			id = add_set(obj, prefix);
+			/*
+			 * SET objects store list's count, which is encoded
+			 * in symbol's size, together with 'cnt' field hence
+			 * that - 1.
+			 */
+			if (id)
+				id->cnt = sym.st_size / sizeof(int) - 1;
+		} else {
+			pr_err("FAILED unsupported prefix %s\n", prefix);
+			return -1;
+		}
+
+		if (!id)
+			return -ENOMEM;
+
+		if (id->addr_cnt >= ADDR_CNT) {
+			pr_err("FAILED symbol %s crossed the number of allowed lists",
+				id->name);
+			return -1;
+		}
+		id->addr[id->addr_cnt++] = sym.st_value;
+	}
+
+	return 0;
+}
+
+static struct btf *btf__parse_raw(const char *file)
+{
+	struct btf *btf;
+	struct stat st;
+	__u8 *buf;
+	FILE *f;
+
+	if (stat(file, &st))
+		return NULL;
+
+	f = fopen(file, "rb");
+	if (!f)
+		return NULL;
+
+	buf = malloc(st.st_size);
+	if (!buf) {
+		btf = ERR_PTR(-ENOMEM);
+		goto exit_close;
+	}
+
+	if ((size_t) st.st_size != fread(buf, 1, st.st_size, f)) {
+		btf = ERR_PTR(-EINVAL);
+		goto exit_free;
+	}
+
+	btf = btf__new(buf, st.st_size);
+
+exit_free:
+	free(buf);
+exit_close:
+	fclose(f);
+	return btf;
+}
+
+static bool is_btf_raw(const char *file)
+{
+	__u16 magic = 0;
+	int fd, nb_read;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	nb_read = read(fd, &magic, sizeof(magic));
+	close(fd);
+	return nb_read == sizeof(magic) && magic == BTF_MAGIC;
+}
+
+static struct btf *btf_open(const char *path)
+{
+	if (is_btf_raw(path))
+		return btf__parse_raw(path);
+	else
+		return btf__parse_elf(path, NULL);
+}
+
+static int symbols_resolve(struct object *obj)
+{
+	int nr_typedefs = obj->nr_typedefs;
+	int nr_structs  = obj->nr_structs;
+	int nr_unions   = obj->nr_unions;
+	int nr_funcs    = obj->nr_funcs;
+	int err, type_id;
+	struct btf *btf;
+	__u32 nr;
+
+	btf = btf_open(obj->btf ?: obj->path);
+	err = libbpf_get_error(btf);
+	if (err) {
+		pr_err("FAILED: load BTF from %s: %s",
+			obj->path, strerror(err));
+		return -1;
+	}
+
+	err = -1;
+	nr  = btf__get_nr_types(btf);
+
+	/*
+	 * Iterate all the BTF types and search for collected symbol IDs.
+	 */
+	for (type_id = 1; type_id <= nr; type_id++) {
+		const struct btf_type *type;
+		struct rb_root *root = NULL;
+		struct btf_id *id;
+		const char *str;
+		int *nr;
+
+		type = btf__type_by_id(btf, type_id);
+		if (!type) {
+			pr_err("FAILED: malformed BTF, can't resolve type for ID %d\n",
+				type_id);
+			goto out;
+		}
+
+		if (btf_is_func(type) && nr_funcs)
+			nr = &nr_funcs;
+		else if (btf_is_struct(type) && nr_structs)
+			nr = &nr_structs;
+		else if (btf_is_union(type) && nr_unions)
+			nr = &nr_unions;
+		else if (btf_is_typedef(type) && nr_typedefs)
+			nr = &nr_typedefs;
+		else
+			continue;
+
+		str = btf__name_by_offset(btf, type->name_off);
+		if (!str) {
+			pr_err("FAILED: malformed BTF, can't resolve name for ID %d\n",
+				type_id);
+			goto out;
+		}
+
+		id = btf_id__find(&obj->symbols, str);
+		if (id) {
+			id->id = type_id;
+			(*nr)--;
+		}
+	}
+
+	err = 0;
+out:
+	btf__free(btf);
+	return err;
+}
+
+static int id_patch(struct object *obj, struct btf_id *id)
+{
+	Elf_Data *data = obj->efile.idlist;
+	int *ptr = data->d_buf;
+	int i;
+
+	if (!id->id) {
+		pr_err("FAILED unresolved symbol %s\n", id->name);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < id->addr_cnt; i++) {
+		unsigned long addr = id->addr[i];
+		unsigned long idx = addr - obj->efile.idlist_addr;
+
+		pr_debug("patching addr %5lu: ID %7d [%s]\n",
+			 idx, id->id, id->name);
+
+		if (idx >= data->d_size) {
+			pr_err("FAILED patching index %lu out of bounds %lu\n",
+				idx, data->d_size);
+			return -1;
+		}
+
+		idx = idx / sizeof(int);
+		ptr[idx] = id->id;
+	}
+
+	return 0;
+}
+
+static int __symbols_patch(struct object *obj, struct rb_root *root)
+{
+	struct rb_node *next;
+	struct btf_id *id;
+
+	next = rb_first(root);
+	while (next) {
+		id = rb_entry(next, struct btf_id, rb_node);
+
+		if (id_patch(obj, id))
+			return -1;
+
+		next = rb_next(next);
+	}
+	return 0;
+}
+
+static int cmp_id(const void *pa, const void *pb)
+{
+	const int *a = pa, *b = pb;
+
+	return *a - *b;
+}
+
+static int sets_patch(struct object *obj)
+{
+	Elf_Data *data = obj->efile.idlist;
+	int *ptr = data->d_buf;
+	struct rb_node *next;
+
+	next = rb_first(&obj->sets);
+	while (next) {
+		unsigned long addr, idx;
+		struct btf_id *id;
+		int *base;
+		int cnt;
+
+		id   = rb_entry(next, struct btf_id, rb_node);
+		addr = id->addr[0];
+		idx  = addr - obj->efile.idlist_addr;
+
+		/* sets are unique */
+		if (id->addr_cnt != 1) {
+			pr_err("FAILED malformed data for set '%s'\n",
+				id->name);
+			return -1;
+		}
+
+		idx = idx / sizeof(int);
+		base = &ptr[idx] + 1;
+		cnt = ptr[idx];
+
+		pr_debug("sorting  addr %5lu: cnt %6d [%s]\n",
+			 (idx + 1) * sizeof(int), cnt, id->name);
+
+		qsort(base, cnt, sizeof(int), cmp_id);
+
+		next = rb_next(next);
+	}
+}
+
+static int symbols_patch(struct object *obj)
+{
+	int err;
+
+	if (__symbols_patch(obj, &obj->symbols) ||
+	    __symbols_patch(obj, &obj->sets))
+		return -1;
+
+	if (sets_patch(obj))
+		return -1;
+
+	elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
+
+	err = elf_update(obj->efile.elf, ELF_C_WRITE);
+	if (err < 0) {
+		pr_err("FAILED elf_update(WRITE): %s\n",
+			elf_errmsg(-1));
+	}
+
+	pr_debug("update %s for %s\n",
+		 err >= 0 ? "ok" : "failed", obj->path);
+	return err < 0 ? -1 : 0;
+}
+
+static const char * const resolve_btfids_usage[] = {
+	"resolve_btfids [<options>] <ELF object>",
+	NULL
+};
+
+int main(int argc, const char **argv)
+{
+	bool no_fail = false;
+	struct object obj = {
+		.efile = {
+			.idlist_shndx  = -1,
+			.symbols_shndx = -1,
+		},
+		.symbols = RB_ROOT,
+		.sets    = RB_ROOT,
+	};
+	struct option btfid_options[] = {
+		OPT_INCR('v', "verbose", &verbose,
+			 "be more verbose (show errors, etc)"),
+		OPT_STRING(0, "btf", &obj.btf, "BTF data",
+			   "BTF data"),
+		OPT_BOOLEAN(0, "no-fail", &no_fail,
+			   "do not fail if " BTF_IDS_SECTION " section is not found"),
+		OPT_END()
+	};
+	int err = -1;
+
+	argc = parse_options(argc, argv, btfid_options, resolve_btfids_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (argc != 1)
+		usage_with_options(resolve_btfids_usage, btfid_options);
+
+	obj.path = argv[0];
+
+	if (elf_collect(&obj))
+		goto out;
+
+	/*
+	 * We did not find .BTF_ids section or symbols section,
+	 * nothing to do..
+	 */
+	if (obj.efile.idlist_shndx == -1 ||
+	    obj.efile.symbols_shndx == -1) {
+		if (no_fail)
+			return 0;
+		pr_err("FAILED to find needed sections\n");
+		return -1;
+	}
+
+	if (symbols_collect(&obj))
+		goto out;
+
+	if (symbols_resolve(&obj))
+		goto out;
+
+	if (symbols_patch(&obj))
+		goto out;
+
+	err = 0;
+out:
+	if (obj.efile.elf)
+		elf_end(obj.efile.elf);
+	close(obj.efile.fd);
+	return err;
+}
-- 
2.25.4

