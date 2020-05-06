Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9201C71B6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgEFNaO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 09:30:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728455AbgEFNaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 09:30:14 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-85sW6dPPP623OAL4XT9ypg-1; Wed, 06 May 2020 09:30:05 -0400
X-MC-Unique: 85sW6dPPP623OAL4XT9ypg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B19428015D2;
        Wed,  6 May 2020 13:30:02 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B43664430;
        Wed,  6 May 2020 13:29:58 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3/9] bpf: Add bpfwl tool to construct bpf whitelists
Date:   Wed,  6 May 2020 15:29:40 +0200
Message-Id: <20200506132946.2164578-4-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-1-jolsa@kernel.org>
References: <20200506132946.2164578-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tool takes vmlinux object and whitelist directory on input
and produces C source object with BPF whitelist data.

The vmlinux object needs to have a BTF information compiled in.

The whitelist directory is expected to contain files with helper
names, where each file contains list of functions/probes that
helper is allowed to be called from - whitelist.

The bpfwl tool has following output:

  $ bpfwl vmlinux dir
  unsigned long d_path[] __attribute__((section(".BTF_whitelist_d_path"))) = \
  { 24507, 24511, 24537, 24539, 24545, 24588, 24602, 24920 };

Each array are sorted BTF ids of the functions provided in the
helper file.

Each array will be compiled into kernel and used during the helper
check in verifier.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpfwl/Build    |  11 ++
 tools/bpf/bpfwl/Makefile |  60 +++++++++
 tools/bpf/bpfwl/bpfwl.c  | 285 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 356 insertions(+)
 create mode 100644 tools/bpf/bpfwl/Build
 create mode 100644 tools/bpf/bpfwl/Makefile
 create mode 100644 tools/bpf/bpfwl/bpfwl.c

diff --git a/tools/bpf/bpfwl/Build b/tools/bpf/bpfwl/Build
new file mode 100644
index 000000000000..667e30d6ce79
--- /dev/null
+++ b/tools/bpf/bpfwl/Build
@@ -0,0 +1,11 @@
+bpfwl-y += bpfwl.o
+bpfwl-y += rbtree.o
+bpfwl-y += zalloc.o
+
+$(OUTPUT)rbtree.o: ../../lib/rbtree.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)zalloc.o: ../../lib/zalloc.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
diff --git a/tools/bpf/bpfwl/Makefile b/tools/bpf/bpfwl/Makefile
new file mode 100644
index 000000000000..8174eeb7eea6
--- /dev/null
+++ b/tools/bpf/bpfwl/Makefile
@@ -0,0 +1,60 @@
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
+BPF_DIR = $(srctree)/tools/lib/bpf/
+
+ifneq ($(OUTPUT),)
+  LIBBPF_PATH = $(OUTPUT)/libbpf/
+else
+  LIBBPF_PATH = $(BPF_DIR)
+endif
+
+LIBBPF    = $(LIBBPF_PATH)libbpf.a
+BPFWL     = $(OUTPUT)bpfwl
+BPFWL_IN  = $(BPFWL)-in.o
+
+all: $(OUTPUT)bpfwl
+
+$(LIBBPF): FORCE
+	$(if $(LIBBPF_PATH),@mkdir -p $(LIBBPF_PATH))
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_PATH) $(LIBBPF_PATH)libbpf.a
+
+$(LIBBPF)-clean:
+	$(call QUIET_CLEAN, libbpf)
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_PATH) clean >/dev/null
+
+CFLAGS := -g -I$(srctree)/tools/include -I$(BPF_DIR)
+
+LIBS = -lelf -lz
+
+export srctree OUTPUT CFLAGS
+include $(srctree)/tools/build/Makefile.include
+
+$(BPFWL_IN): fixdep FORCE
+	$(Q)$(MAKE) $(build)=bpfwl
+
+$(BPFWL): $(LIBBPF) $(BPFWL_IN)
+	$(QUIET_LINK)$(CC) $(BPFWL_IN) $(LDFLAGS) -o $@ $(LIBBPF) $(LIBS)
+
+clean: $(LIBBPF)-clean
+	$(call QUIET_CLEAN, bpfwl)
+	$(Q)$(RM) -f $(BPFWL)
+	$(Q)find $(if $(OUTPUT),$(OUTPUT),.) -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
+
+FORCE:
+
+.PHONY: all FORCE clean
diff --git a/tools/bpf/bpfwl/bpfwl.c b/tools/bpf/bpfwl/bpfwl.c
new file mode 100644
index 000000000000..495c2bcf620a
--- /dev/null
+++ b/tools/bpf/bpfwl/bpfwl.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+#define  _GNU_SOURCE
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <stdlib.h>
+#include <linux/rbtree.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/zalloc.h>
+#include <linux/limits.h>
+#include <btf.h>
+#include <libbpf.h>
+
+struct func {
+	char			*name;
+	unsigned long		 id;
+	struct rb_node		 rb_node;
+	struct list_head	 list[];
+};
+
+struct helper {
+	char			*name;
+	int			 idx;
+	int			 count;
+	struct list_head	 node;
+	struct list_head	 funcs;
+};
+
+static struct rb_root funcs;
+static LIST_HEAD(helpers);
+static int idxs;
+
+static struct func *func__new(const char *name)
+{
+	size_t size = idxs * sizeof(struct list_head);
+	struct func *func;
+	int i;
+
+	func = zalloc(sizeof(*func) + size);
+	if (func) {
+		func->name = strdup(name);
+		for (i = 0; i < idxs; i++)
+			INIT_LIST_HEAD(&func->list[i]);
+	}
+	return func;
+}
+
+static struct helper *helper__new(const char *name)
+{
+	struct helper *helper = zalloc(sizeof(*helper));
+
+	if (helper) {
+		helper->idx = idxs++;
+		helper->name = strdup(name);
+		INIT_LIST_HEAD(&helper->funcs);
+		list_add_tail(&helper->node, &helpers);
+	}
+	return helper;
+}
+
+static struct func *func__add(char *name)
+{
+	struct rb_node **p = &funcs.rb_node;
+	struct rb_node *parent = NULL;
+	struct func *func;
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		func = rb_entry(parent, struct func, rb_node);
+		cmp = strcmp(func->name, name);
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else if (cmp > 0)
+			p = &(*p)->rb_right;
+		else
+			return func;
+	}
+
+	func = func__new(name);
+	if (func) {
+		rb_link_node(&func->rb_node, parent, p);
+		rb_insert_color(&func->rb_node, &funcs);
+	}
+	return func;
+}
+
+static struct func *func__find(const char *name)
+{
+	struct rb_node *p = funcs.rb_node;
+	struct func *func;
+	int cmp;
+
+	while (p != NULL) {
+		func = rb_entry(p, struct func, rb_node);
+		cmp = strcmp(func->name, name);
+		if (cmp < 0)
+			p = p->rb_left;
+		else if (cmp > 0)
+			p = p->rb_right;
+		else
+			return func;
+	}
+	return NULL;
+}
+
+static int helper__read(struct helper *helper, const char *base)
+{
+	char path[PATH_MAX];
+	char *line = NULL;
+	size_t len = 0;
+	ssize_t nread;
+	int err = -1;
+	FILE *file;
+
+	snprintf(path, sizeof(path), "%s/%s", base, helper->name);
+
+	file = fopen(path, "r");
+	if (file == NULL) {
+		perror("FAILED fopen whitelist");
+		return -1;
+	}
+
+	while ((nread = getline(&line, &len, file)) != -1) {
+		struct func *func;
+		char *p;
+
+		p = strchr(line, '\n');
+		if (p)
+			*p = 0;
+
+		func = func__add(line);
+		if (!func)
+			goto err;
+
+		list_add_tail(&func->list[helper->idx], &helper->funcs);
+		helper->count++;
+	}
+
+	err = 0;
+err:
+	free(line);
+	fclose(file);
+	return err;
+}
+
+static int comp(const void *a, const void *b)
+{
+	const unsigned long *pa = a;
+	const unsigned long *pb = b;
+
+	return *pa - *pb;
+}
+
+int main(int argc, char **argv)
+{
+	struct helper *helper;
+	const char *wl_path;
+	const char *vmlinux;
+	struct dirent *d;
+	struct btf *btf;
+	int id, err;
+	DIR *dir;
+	__u32 nr;
+
+	if (argc != 3) {
+		fprintf(stderr, "%s <vmlinux> <dir>", argv[0]);
+		return -1;
+	}
+
+	vmlinux = argv[1];
+	wl_path = argv[2];
+
+	dir = opendir(wl_path);
+	if (dir == NULL) {
+		perror("FAILED: open directory");
+		return -1;
+	}
+
+	/*
+	 * Scan the whitelist directory and create 'struct helper'
+	 * object for every file. Read and put all the functions
+	 * into funcs rb tree and link them to each helper.
+	 */
+	while ((d = readdir(dir)) != NULL) {
+		if (!strcmp(d->d_name, ".") ||
+		    !strcmp(d->d_name, ".."))
+			continue;
+
+		helper = helper__new(d->d_name);
+		if (!helper) {
+			fprintf(stderr, "FAILED: not enough memory\n");
+			return -1;
+		}
+
+		if (helper__read(helper, wl_path))
+			return -1;
+	}
+
+	closedir(dir);
+
+	btf = btf__parse_elf(vmlinux, NULL);
+	err = libbpf_get_error(btf);
+	if (err) {
+		fprintf(stderr, "FAILED: load BTF from %s: %s",
+			vmlinux, strerror(err));
+		return -1;
+	}
+
+	nr = btf__get_nr_types(btf);
+
+	/* Iterate all the BTF types and resolve all the function IDs. */
+	for (id = 0; id < nr; id++) {
+		const struct btf_type *type;
+		struct func *func;
+		const char *str;
+
+		type = btf__type_by_id(btf, id);
+		if (!type)
+			continue;
+
+		if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC)
+			continue;
+
+		str = btf__name_by_offset(btf, type->name_off);
+		if (!str)
+			continue;
+
+		func = func__find(str);
+		if (func)
+			func->id = id;
+	}
+
+	/*
+	 * Load BTF IDs for each helper into array, sort it,
+	 * and dump the C code for the helper array.
+	 */
+	list_for_each_entry(helper, &helpers, node) {
+		unsigned long *ids;
+		bool first = true;
+		struct func *func;
+		int idx = 0;
+
+		ids = malloc(helper->count * sizeof(unsigned long));
+		if (!ids) {
+			fprintf(stderr, "FAILED: not enough memory\n");
+			return -1;
+		}
+
+		list_for_each_entry(func, &helper->funcs, list[helper->idx]) {
+			if (!func->id) {
+				fprintf(stderr, "FAILED: '%s' function not found in BTF data\n",
+					func->name);
+				return -1;
+			}
+
+			ids[idx++] = func->id;
+		}
+
+		qsort(ids, helper->count, sizeof(unsigned long), comp);
+
+		fprintf(stdout,
+			"unsigned long %s[] __attribute__((section(\".BTF_whitelist_%s\"))) = { ",
+			helper->name, helper->name);
+
+		for (idx = 0; idx < helper->count; idx++, first = false)
+			fprintf(stdout, "%s%lu", first ? "" : ", ", ids[idx]);
+
+		fprintf(stdout, " };\n");
+
+		free(ids);
+	}
+
+	/*
+	 * Not releasing anything intentionaly..
+	 *
+	 * btf__free(btf)
+	 * free helpers/funcs
+	 */
+	return 0;
+}
-- 
2.25.4

