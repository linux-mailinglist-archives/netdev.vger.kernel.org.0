Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D541FAD66
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgFPKFd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:05:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728153AbgFPKFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:05:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-JC-_LeQ_PpeTAkIEyuO_Gg-1; Tue, 16 Jun 2020 06:05:25 -0400
X-MC-Unique: JC-_LeQ_PpeTAkIEyuO_Gg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E470710108B6;
        Tue, 16 Jun 2020 10:05:22 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECB025D98B;
        Tue, 16 Jun 2020 10:05:17 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 01/11] bpf: Add btfid tool to resolve BTF IDs in ELF object
Date:   Tue, 16 Jun 2020 12:05:02 +0200
Message-Id: <20200616100512.2168860-2-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The btfid tool scans Elf object for .BTF_ids section and
resolves its symbols with BTF IDs.

It will be used to during linking time to resolve arrays
of BTF IDs used in verifier, so these IDs do not need to
be resolved in runtime.

The expected layout of .BTF_ids section is described
in btfid.c header. Related kernel changes are coming in
following changes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/btfid/Build    |  26 ++
 tools/bpf/btfid/Makefile |  71 +++++
 tools/bpf/btfid/btfid.c  | 627 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 724 insertions(+)
 create mode 100644 tools/bpf/btfid/Build
 create mode 100644 tools/bpf/btfid/Makefile
 create mode 100644 tools/bpf/btfid/btfid.c

diff --git a/tools/bpf/btfid/Build b/tools/bpf/btfid/Build
new file mode 100644
index 000000000000..12d43396d2a0
--- /dev/null
+++ b/tools/bpf/btfid/Build
@@ -0,0 +1,26 @@
+btfid-y += btfid.o
+btfid-y += rbtree.o
+btfid-y += zalloc.o
+btfid-y += string.o
+btfid-y += ctype.o
+btfid-y += str_error_r.o
+
+$(OUTPUT)rbtree.o: ../../lib/rbtree.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)zalloc.o: ../../lib/zalloc.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)string.o: ../../lib/string.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)ctype.o: ../../lib/ctype.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)str_error_r.o: ../../lib/str_error_r.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
diff --git a/tools/bpf/btfid/Makefile b/tools/bpf/btfid/Makefile
new file mode 100644
index 000000000000..30b721cf0a21
--- /dev/null
+++ b/tools/bpf/btfid/Makefile
@@ -0,0 +1,71 @@
+# SPDX-License-Identifier: GPL-2.0-only
+include ../../scripts/Makefile.include
+
+MAKEFLAGS=--no-print-directory
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(CURDIR)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+endif
+
+ifeq ($(V),1)
+  Q =
+else
+  Q = @
+endif
+
+BPF_DIR       = $(srctree)/tools/lib/bpf/
+SUBCMD_DIR    = $(srctree)/tools/lib/subcmd/
+SUBCMD_OUTPUT = $(if $(OUTPUT),$(OUTPUT),$(CURDIR)/)
+
+ifneq ($(OUTPUT),)
+  LIBBPF_PATH = $(OUTPUT)/libbpf/
+  SUBCMD_PATH = $(OUTPUT)/subcmd/
+else
+  LIBBPF_PATH = $(BPF_DIR)
+  SUBCMD_PATH = $(SUBCMD_DIR)
+endif
+
+LIBSUBCMD = $(SUBCMD_OUTPUT)libsubcmd.a
+LIBBPF    = $(LIBBPF_PATH)libbpf.a
+BPFWL     = $(OUTPUT)btfid
+BPFWL_IN  = $(BPFWL)-in.o
+
+all: $(OUTPUT)btfid
+
+$(LIBSUBCMD): fixdep FORCE
+	$(Q)$(MAKE) -C $(SUBCMD_DIR) OUTPUT=$(SUBCMD_OUTPUT)
+
+$(LIBSUBCMD)-clean:
+	$(Q)$(MAKE) -C $(SUBCMD_DIR) O=$(OUTPUT) clean
+
+$(LIBBPF): FORCE
+	$(if $(LIBBPF_PATH),@mkdir -p $(LIBBPF_PATH))
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_PATH) $(LIBBPF_PATH)libbpf.a
+
+$(LIBBPF)-clean:
+	$(call QUIET_CLEAN, libbpf)
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_PATH) clean >/dev/null
+
+CFLAGS := -g -I$(srctree)/tools/include -I$(BPF_DIR) -I$(SUBCMD_DIR)
+
+LIBS = -lelf -lz
+
+export srctree OUTPUT CFLAGS
+include $(srctree)/tools/build/Makefile.include
+
+$(BPFWL_IN): fixdep FORCE
+	$(Q)$(MAKE) $(build)=btfid
+
+$(BPFWL): $(LIBBPF) $(LIBSUBCMD) $(BPFWL_IN)
+	$(QUIET_LINK)$(CC) $(BPFWL_IN) $(LDFLAGS) -o $@ $(LIBBPF) $(LIBSUBCMD) $(LIBS)
+
+clean: $(LIBBPF)-clean $(LIBSUBCMD)-clean
+	$(call QUIET_CLEAN, btfid)
+	$(Q)$(RM) -f $(BPFWL)
+	$(Q)find $(if $(OUTPUT),$(OUTPUT),.) -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
+
+FORCE:
+
+.PHONY: all FORCE clean
diff --git a/tools/bpf/btfid/btfid.c b/tools/bpf/btfid/btfid.c
new file mode 100644
index 000000000000..7cdf39bfb150
--- /dev/null
+++ b/tools/bpf/btfid/btfid.c
@@ -0,0 +1,627 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+#define  _GNU_SOURCE
+
+/*
+ * btfid scans Elf object for .BTF_ids section and resolves
+ * its symbols with BTF IDs.
+ *
+ * Each symbol points to 4 bytes data and is expected to have
+ * following name syntax:
+ *
+ * __BTF_ID__<type>__<symbol>[__<id>]
+ *
+ * type is:
+ *
+ *   func   - lookup BTF_KIND_FUNC symbol with <symbol> name
+ *            and put its ID into its data
+ *
+ *             __BTF_ID__func__vfs_close__1:
+ *             .zero 4
+ *
+ *   struct - lookup BTF_KIND_STRUCT symbol with <symbol> name
+ *            and put its ID into its data
+ *
+ *             __BTF_ID__struct__sk_buff__1:
+ *             .zero 4
+ *
+ *   sort   - put symbol size into data area and sort following
+ *            ID list
+ *
+ *             __BTF_ID__sort__list:
+ *             list_cnt:
+ *             .zero 4
+ *             list:
+ *             __BTF_ID__func__vfs_getattr__3:
+ *             .zero 4
+ *             __BTF_ID__func__vfs_fallocate__4:
+ *             .zero 4
+ */
+
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
+#include <btf.h>
+#include <libbpf.h>
+#include <parse-options.h>
+
+#define ADDR_CNT	100
+#define SECTION		".BTF_ids"
+#define BTF_STRUCT	"struct"
+#define BTF_FUNC	"func"
+#define BTF_SORT	"sort"
+#define BTF_ID		"__BTF_ID__"
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
+	struct rb_root	sorts;
+	struct rb_root	funcs;
+	struct rb_root	structs;
+
+	int nr_funcs;
+	int nr_structs;
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
+static struct btf_id *add_sort(struct object *obj, char *name)
+{
+	char *id;
+
+	id = strdup(name + sizeof(BTF_SORT) + sizeof("__") - 2);
+	if (!id) {
+		pr_err("FAILED to parse cnt name: %s\n", name);
+		return NULL;
+	}
+
+	return btf_id__add(&obj->sorts, id, true);
+}
+
+static struct btf_id *add_func(struct object *obj, char *name)
+{
+	char *id;
+
+	id = get_id(name + sizeof(BTF_FUNC) - 1);
+	if (!id) {
+		pr_err("FAILED to parse func name: %s\n", name);
+		return NULL;
+	}
+
+	obj->nr_funcs++;
+	return btf_id__add(&obj->funcs, id, false);
+}
+
+static struct btf_id *add_struct(struct object *obj, char *name)
+{
+	char *id;
+
+	id = get_id(name + sizeof(BTF_STRUCT) - 1);
+	if (!id) {
+		pr_err("FAILED to parse struct name: %s\n", name);
+		return NULL;
+	}
+
+	obj->nr_structs++;
+	return btf_id__add(&obj->structs, id, false);
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
+			pr_err("failed to get section(%d) data from %s\n",
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
+		} else if (!strcmp(name, SECTION)) {
+			obj->efile.idlist       = data;
+			obj->efile.idlist_shndx = idx;
+			obj->efile.idlist_addr  = sh.sh_addr;
+		}
+	}
+
+	/*
+	 * We did not find .BTF_ids section or
+	 * symbols section, nothing to do..
+	 */
+	if (obj->efile.idlist_shndx == -1 ||
+	    obj->efile.symbols_shndx == -1) {
+		pr_err("FAILED to find needed sections\n");
+		return -1;
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
+		if (!strncmp(prefix, BTF_STRUCT, sizeof(BTF_STRUCT) - 1)) {
+			id = add_struct(obj, prefix);
+		} else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
+			id = add_func(obj, prefix);
+		} else if (!strncmp(prefix, BTF_SORT, sizeof(BTF_SORT) - 1)) {
+			id = add_sort(obj, prefix);
+
+			/*
+			 * SORT objects store list's count, which is encoded
+			 * in symbol's size.
+			 */
+			if (id)
+				id->cnt = sym.st_size / sizeof(int);
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
+static int symbols_resolve(struct object *obj)
+{
+	int nr_structs = obj->nr_structs;
+	int nr_funcs   = obj->nr_funcs;
+	struct btf *btf;
+	int err, type_id;
+	__u32 nr;
+
+	btf = btf__parse_elf(obj->path, NULL);
+	err = libbpf_get_error(btf);
+	if (err) {
+		pr_err("FAILED: load BTF from %s: %s",
+			obj->path, strerror(err));
+		return -1;
+	}
+
+	nr = btf__get_nr_types(btf);
+
+	/*
+	 * Iterate all the BTF types and search for collected symbol IDs.
+	 */
+	for (type_id = 0; type_id < nr; type_id++) {
+		const struct btf_type *type;
+		struct rb_root *root = NULL;
+		struct btf_id *id;
+		const char *str;
+		int *nr;
+
+		type = btf__type_by_id(btf, type_id);
+		if (!type)
+			continue;
+
+		/* We support func/struct types. */
+		if (BTF_INFO_KIND(type->info) == BTF_KIND_FUNC && nr_funcs) {
+			root = &obj->funcs;
+			nr = &nr_funcs;
+		} else if (BTF_INFO_KIND(type->info) == BTF_KIND_STRUCT && nr_structs) {
+			root = &obj->structs;
+			nr = &nr_structs;
+		} else {
+			continue;
+		}
+
+		str = btf__name_by_offset(btf, type->name_off);
+		if (!str)
+			continue;
+
+		id = btf_id__find(root, str);
+		if (id) {
+			id->id = type_id;
+			(*nr)--;
+		}
+	}
+
+	return 0;
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
+		pr_debug("patching addr %5lu: ID %7d [%s]\n", idx, id->id, id->name);
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
+static int sorts_patch(struct object *obj)
+{
+	Elf_Data *data = obj->efile.idlist;
+	int *ptr = data->d_buf;
+	struct rb_node *next;
+	struct btf_id *id;
+
+	next = rb_first(&obj->sorts);
+	while (next) {
+		unsigned long addr = id->addr[0];
+		unsigned long idx = addr - obj->efile.idlist_addr;
+		int *base;
+		int cnt;
+
+		id = rb_entry(next, struct btf_id, rb_node);
+
+		if (id->addr_cnt != 1)
+			return -1;
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
+	if (__symbols_patch(obj, &obj->funcs) ||
+	    __symbols_patch(obj, &obj->structs) ||
+	    __symbols_patch(obj, &obj->sorts))
+		return -1;
+
+	if (sorts_patch(obj))
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
+static const char * const btfid_usage[] = {
+	"btfid [<options>] <ELF object>",
+	NULL
+};
+
+static struct option btfid_options[] = {
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show errors, etc)"),
+	OPT_END()
+};
+
+int main(int argc, const char **argv)
+{
+	struct object obj = {
+		.efile = {
+			.idlist_shndx  = -1,
+			.symbols_shndx = -1,
+		},
+		.funcs   = RB_ROOT,
+		.structs = RB_ROOT,
+		.sorts   = RB_ROOT,
+	};
+
+	argc = parse_options(argc, argv, btfid_options, btfid_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (argc != 1)
+		usage_with_options(btfid_usage, btfid_options);
+
+	obj.path = argv[0];
+
+	/*
+	 * We do proper cleanup and file close
+	 * intentionally only on success.
+	 */
+	if (elf_collect(&obj))
+		return -1;
+
+	if (symbols_collect(&obj))
+		return -1;
+
+	if (symbols_resolve(&obj))
+		return -1;
+
+	if (symbols_patch(&obj))
+		return -1;
+
+	elf_end(obj.efile.elf);
+	close(obj.efile.fd);
+	return 0;
+}
-- 
2.25.4

