Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A304212D8E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgGBUDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBUDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:03:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019B0C08C5C1;
        Thu,  2 Jul 2020 13:03:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f2so11714785plr.8;
        Thu, 02 Jul 2020 13:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Uj3JVQPT5ImQBYlZmtU7snI9bbyjYz0Is0HPxYH7B4o=;
        b=o8AdM7Qe7wCApbFldHIQ5jO9JitLNYZF3Xapm30ZksxZnEtxCXVLcVQ6ZA9MgcZT5e
         EV1ZlJDUZOrTIHEAtGA52kwSDFYpaVrwTq6PmS98nhCGRTOWZFEWxaXEzSTGQi2e1Wcw
         dPYKeCojhfEpzDElIqtbB7uEqCWtrdzijcZUhXQesqMvFEWC7/KkbkBUogMsC83dYajQ
         TlxlHTNTFjgsMAAFLmO2fBxfiWdsUocu/YrV8FF8NHJ6NHs4SsU9ToWBsVOrB63REqqc
         vDfU7bYMru6jeJhaTqwgpCJgkhL9IEdi71srxRKSm2HUoKJY29umADjr6ynL2tWK0dkn
         OG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Uj3JVQPT5ImQBYlZmtU7snI9bbyjYz0Is0HPxYH7B4o=;
        b=k4j9d9lfFDsgTQG9ksqpZsqPp0QIrB0C+XkKErw7N2am1l5tFHWB4WvWTutIeBCzCd
         eiUzYwh6MPCbej0BrUN9Wh6gYmsPdkqHvMtFNYa3dJMggD2KFdnz9P/TjJ/CSk88HREj
         di+NPqIwuv8ZUU9/IcXPD5KMD+KQgrWDOuW0FHpoyhIy4vZgog4ICivUhV1CTKq4aCdw
         W8IFdNItHIIyg6BhWTQbRO0hc4VQvARa+Ie17zrb94PXgaEtmJnDduoh4Rrhnf1HkuZZ
         qHSrXevzfFeStGVuzi0QxRz67LG61MeNwMQLBqkLp08VAJMHimgOBb+5cZafaQic2dbo
         vKNA==
X-Gm-Message-State: AOAM530063E9w70u2eK9WZh/XLvBzoZMgrD7zfZmhqJSzegn3Uf6yx1O
        /zJ5BQ1TtWMXBnqr2v/yEnnBZbd1
X-Google-Smtp-Source: ABdhPJxJfWt0GaC16w22MBCBCPKJXVbqFiG7CgCWCcv24uzH/gqtZeOFuMkYRedQ5exxXCuCXJl9YA==
X-Received: by 2002:a17:902:fe0d:: with SMTP id g13mr28036579plj.326.1593720216573;
        Thu, 02 Jul 2020 13:03:36 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 83sm9663466pfu.60.2020.07.02.13.03.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2020 13:03:35 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, daniel@iogearbox.net, ebiederm@xmission.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 2/3] bpf: Add BPF program and map iterators as built-in BPF programs.
Date:   Thu,  2 Jul 2020 13:03:28 -0700
Message-Id: <20200702200329.83224-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The program and map iterators work similar to seq_file-s.
Once the program is pinned in bpffs it can be read with "cat" tool
to print human readable output. In this case about BPF programs and maps.
For example:
$ cat /sys/fs/bpf/progs
  id name            pages attached
   5    dump_bpf_map     1 bpf_iter_bpf_map
   6   dump_bpf_prog     1 bpf_iter_bpf_prog
$ cat /sys/fs/bpf/maps
  id name            pages
   3 iterator.rodata     2

To avoid kernel build dependency on clang 10 separate bpf skeleton generation
into manual "make" step and instead check-in generated .skel.h into git.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/preload/iterators/.gitignore       |   2 +
 kernel/bpf/preload/iterators/Makefile         |  57 +++
 kernel/bpf/preload/iterators/README           |   4 +
 kernel/bpf/preload/iterators/iterators.bpf.c  |  81 ++++
 kernel/bpf/preload/iterators/iterators.skel.h | 359 ++++++++++++++++++
 5 files changed, 503 insertions(+)
 create mode 100644 kernel/bpf/preload/iterators/.gitignore
 create mode 100644 kernel/bpf/preload/iterators/Makefile
 create mode 100644 kernel/bpf/preload/iterators/README
 create mode 100644 kernel/bpf/preload/iterators/iterators.bpf.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.skel.h

diff --git a/kernel/bpf/preload/iterators/.gitignore b/kernel/bpf/preload/iterators/.gitignore
new file mode 100644
index 000000000000..ffdb70230c8b
--- /dev/null
+++ b/kernel/bpf/preload/iterators/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+/.output
diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
new file mode 100644
index 000000000000..28fa8c1440f4
--- /dev/null
+++ b/kernel/bpf/preload/iterators/Makefile
@@ -0,0 +1,57 @@
+# SPDX-License-Identifier: GPL-2.0
+OUTPUT := .output
+CLANG ?= clang
+LLC ?= llc
+LLVM_STRIP ?= llvm-strip
+DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+LIBBPF_SRC := $(abspath ../../../../tools/lib/bpf)
+BPFOBJ := $(OUTPUT)/libbpf.a
+BPF_INCLUDE := $(OUTPUT)
+INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../../../tools/lib)        \
+       -I$(abspath ../../../../tools/include/uapi)
+CFLAGS := -g -Wall
+
+abs_out := $(abspath $(OUTPUT))
+ifeq ($(V),1)
+Q =
+msg =
+else
+Q = @
+msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+MAKEFLAGS += --no-print-directory
+submake_extras := feature_display=0
+endif
+
+.DELETE_ON_ERROR:
+
+.PHONY: all clean
+
+all: iterators.skel.h
+
+clean:
+	$(call msg,CLEAN)
+	$(Q)rm -rf $(OUTPUT) iterators
+
+iterators.skel.h: $(OUTPUT)/iterators.bpf.o | $(BPFTOOL)
+	$(call msg,GEN-SKEL,$@)
+	$(Q)$(BPFTOOL) gen skeleton $< > $@
+
+
+$(OUTPUT)/iterators.bpf.o: iterators.bpf.c $(BPFOBJ) | $(OUTPUT)
+	$(call msg,BPF,$@)
+	$(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)			      \
+		 -c $(filter %.c,$^) -o $@ &&				      \
+	$(LLVM_STRIP) -g $@
+
+$(OUTPUT):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $(OUTPUT)
+
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
+		    OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
+
+$(DEFAULT_BPFTOOL):
+	$(Q)$(MAKE) $(submake_extras) -C ../../../../tools/bpf/bpftool			      \
+		    prefix= OUTPUT=$(abs_out)/ DESTDIR=$(abs_out) install
diff --git a/kernel/bpf/preload/iterators/README b/kernel/bpf/preload/iterators/README
new file mode 100644
index 000000000000..7fd6d39a9ad2
--- /dev/null
+++ b/kernel/bpf/preload/iterators/README
@@ -0,0 +1,4 @@
+WARNING:
+If you change "iterators.bpf.c" do "make -j" in this directory to rebuild "iterators.skel.h".
+Make sure to have clang 10 installed.
+See Documentation/bpf/bpf_devel_QA.rst
diff --git a/kernel/bpf/preload/iterators/iterators.bpf.c b/kernel/bpf/preload/iterators/iterators.bpf.c
new file mode 100644
index 000000000000..bea214b0e354
--- /dev/null
+++ b/kernel/bpf/preload/iterators/iterators.bpf.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct seq_file;
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_map_memory {
+	__u32 pages;
+};
+struct bpf_map {
+	__u32 id;
+	struct bpf_map_memory memory;
+	char name[16];
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__bpf_map {
+	struct bpf_iter_meta *meta;
+	struct bpf_map *map;
+} __attribute__((preserve_access_index));
+
+struct bpf_prog_aux {
+	__u32 id;
+	char name[16];
+	const char *attach_func_name;
+	struct bpf_prog *linked_prog;
+} __attribute__((preserve_access_index));
+
+struct bpf_prog {
+	struct bpf_prog_aux *aux;
+	__u16 pages;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__bpf_prog {
+	struct bpf_iter_meta *meta;
+	struct bpf_prog *prog;
+} __attribute__((preserve_access_index));
+
+SEC("iter/bpf_map")
+int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	__u64 seq_num = ctx->meta->seq_num;
+	struct bpf_map *map = ctx->map;
+
+	if (!map)
+		return 0;
+
+	if (seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "  id name            pages\n");
+
+	BPF_SEQ_PRINTF(seq, "%4u%16s%6d\n", map->id, map->name, map->memory.pages);
+	return 0;
+}
+
+SEC("iter/bpf_prog")
+int dump_bpf_prog(struct bpf_iter__bpf_prog *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	__u64 seq_num = ctx->meta->seq_num;
+	struct bpf_prog *prog = ctx->prog;
+	struct bpf_prog_aux *aux;
+
+	if (!prog)
+		return 0;
+
+	aux = prog->aux;
+	if (seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "  id name            pages attached\n");
+
+	BPF_SEQ_PRINTF(seq, "%4u%16s%6d %s %s\n", aux->id, aux->name, prog->pages,
+		       aux->attach_func_name, aux->linked_prog->aux->name);
+	return 0;
+}
+char LICENSE[] SEC("license") = "GPL";
diff --git a/kernel/bpf/preload/iterators/iterators.skel.h b/kernel/bpf/preload/iterators/iterators.skel.h
new file mode 100644
index 000000000000..bbee5a1f346c
--- /dev/null
+++ b/kernel/bpf/preload/iterators/iterators.skel.h
@@ -0,0 +1,359 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+
+/* THIS FILE IS AUTOGENERATED! */
+#ifndef __ITERATORS_BPF_SKEL_H__
+#define __ITERATORS_BPF_SKEL_H__
+
+#include <stdlib.h>
+#include <bpf/libbpf.h>
+
+struct iterators_bpf {
+	struct bpf_object_skeleton *skeleton;
+	struct bpf_object *obj;
+	struct {
+		struct bpf_map *rodata;
+	} maps;
+	struct {
+		struct bpf_program *dump_bpf_map;
+		struct bpf_program *dump_bpf_prog;
+	} progs;
+	struct {
+		struct bpf_link *dump_bpf_map;
+		struct bpf_link *dump_bpf_prog;
+	} links;
+	struct iterators_bpf__rodata {
+		const char dump_bpf_map____fmt[28];
+		const char dump_bpf_map____fmt_1[12];
+		const char dump_bpf_prog____fmt[37];
+		const char dump_bpf_prog____fmt_2[18];
+	} *rodata;
+};
+
+static void
+iterators_bpf__destroy(struct iterators_bpf *obj)
+{
+	if (!obj)
+		return;
+	if (obj->skeleton)
+		bpf_object__destroy_skeleton(obj->skeleton);
+	free(obj);
+}
+
+static inline int
+iterators_bpf__create_skeleton(struct iterators_bpf *obj);
+
+static inline struct iterators_bpf *
+iterators_bpf__open_opts(const struct bpf_object_open_opts *opts)
+{
+	struct iterators_bpf *obj;
+
+	obj = (typeof(obj))calloc(1, sizeof(*obj));
+	if (!obj)
+		return NULL;
+	if (iterators_bpf__create_skeleton(obj))
+		goto err;
+	if (bpf_object__open_skeleton(obj->skeleton, opts))
+		goto err;
+
+	return obj;
+err:
+	iterators_bpf__destroy(obj);
+	return NULL;
+}
+
+static inline struct iterators_bpf *
+iterators_bpf__open(void)
+{
+	return iterators_bpf__open_opts(NULL);
+}
+
+static inline int
+iterators_bpf__load(struct iterators_bpf *obj)
+{
+	return bpf_object__load_skeleton(obj->skeleton);
+}
+
+static inline struct iterators_bpf *
+iterators_bpf__open_and_load(void)
+{
+	struct iterators_bpf *obj;
+
+	obj = iterators_bpf__open();
+	if (!obj)
+		return NULL;
+	if (iterators_bpf__load(obj)) {
+		iterators_bpf__destroy(obj);
+		return NULL;
+	}
+	return obj;
+}
+
+static inline int
+iterators_bpf__attach(struct iterators_bpf *obj)
+{
+	return bpf_object__attach_skeleton(obj->skeleton);
+}
+
+static inline void
+iterators_bpf__detach(struct iterators_bpf *obj)
+{
+	return bpf_object__detach_skeleton(obj->skeleton);
+}
+
+static inline int
+iterators_bpf__create_skeleton(struct iterators_bpf *obj)
+{
+	struct bpf_object_skeleton *s;
+
+	s = (typeof(s))calloc(1, sizeof(*s));
+	if (!s)
+		return -1;
+	obj->skeleton = s;
+
+	s->sz = sizeof(*s);
+	s->name = "iterators_bpf";
+	s->obj = &obj->obj;
+
+	/* maps */
+	s->map_cnt = 1;
+	s->map_skel_sz = sizeof(*s->maps);
+	s->maps = (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);
+	if (!s->maps)
+		goto err;
+
+	s->maps[0].name = "iterator.rodata";
+	s->maps[0].map = &obj->maps.rodata;
+	s->maps[0].mmaped = (void **)&obj->rodata;
+
+	/* programs */
+	s->prog_cnt = 2;
+	s->prog_skel_sz = sizeof(*s->progs);
+	s->progs = (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);
+	if (!s->progs)
+		goto err;
+
+	s->progs[0].name = "dump_bpf_map";
+	s->progs[0].prog = &obj->progs.dump_bpf_map;
+	s->progs[0].link = &obj->links.dump_bpf_map;
+
+	s->progs[1].name = "dump_bpf_prog";
+	s->progs[1].prog = &obj->progs.dump_bpf_prog;
+	s->progs[1].link = &obj->links.dump_bpf_prog;
+
+	s->data_sz = 5744;
+	s->data = (void *)"\
+\x7f\x45\x4c\x46\x02\x01\x01\0\0\0\0\0\0\0\0\0\x01\0\xf7\0\x01\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\xb0\x12\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\x40\0\x0f\0\
+\x0e\0\x79\x12\0\0\0\0\0\0\x79\x26\0\0\0\0\0\0\x79\x17\x08\0\0\0\0\0\x15\x07\
+\x1a\0\0\0\0\0\x79\x21\x10\0\0\0\0\0\x55\x01\x08\0\0\0\0\0\xbf\xa4\0\0\0\0\0\0\
+\x07\x04\0\0\xe8\xff\xff\xff\xbf\x61\0\0\0\0\0\0\x18\x02\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\xb7\x03\0\0\x1c\0\0\0\xb7\x05\0\0\0\0\0\0\x85\0\0\0\x7e\0\0\0\x61\x71\0\
+\0\0\0\0\0\x7b\x1a\xe8\xff\0\0\0\0\xb7\x01\0\0\x08\0\0\0\xbf\x72\0\0\0\0\0\0\
+\x0f\x12\0\0\0\0\0\0\x7b\x2a\xf0\xff\0\0\0\0\x61\x71\x04\0\0\0\0\0\x7b\x1a\xf8\
+\xff\0\0\0\0\xbf\xa4\0\0\0\0\0\0\x07\x04\0\0\xe8\xff\xff\xff\xbf\x61\0\0\0\0\0\
+\0\x18\x02\0\0\x1c\0\0\0\0\0\0\0\0\0\0\0\xb7\x03\0\0\x0c\0\0\0\xb7\x05\0\0\x18\
+\0\0\0\x85\0\0\0\x7e\0\0\0\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\x79\x12\0\0\0\0\
+\0\0\x79\x26\0\0\0\0\0\0\x79\x17\x08\0\0\0\0\0\x15\x07\x21\0\0\0\0\0\x79\x78\0\
+\0\0\0\0\0\x79\x21\x10\0\0\0\0\0\x55\x01\x08\0\0\0\0\0\xbf\xa4\0\0\0\0\0\0\x07\
+\x04\0\0\xd8\xff\xff\xff\xbf\x61\0\0\0\0\0\0\x18\x02\0\0\x28\0\0\0\0\0\0\0\0\0\
+\0\0\xb7\x03\0\0\x25\0\0\0\xb7\x05\0\0\0\0\0\0\x85\0\0\0\x7e\0\0\0\x61\x81\0\0\
+\0\0\0\0\x7b\x1a\xd8\xff\0\0\0\0\xb7\x01\0\0\x04\0\0\0\xbf\x82\0\0\0\0\0\0\x0f\
+\x12\0\0\0\0\0\0\x7b\x2a\xe0\xff\0\0\0\0\x69\x72\x08\0\0\0\0\0\x7b\x2a\xe8\xff\
+\0\0\0\0\x79\x82\x18\0\0\0\0\0\x7b\x2a\xf0\xff\0\0\0\0\x79\x82\x20\0\0\0\0\0\
+\x79\x22\0\0\0\0\0\0\x0f\x12\0\0\0\0\0\0\x7b\x2a\xf8\xff\0\0\0\0\xbf\xa4\0\0\0\
+\0\0\0\x07\x04\0\0\xd8\xff\xff\xff\xbf\x61\0\0\0\0\0\0\x18\x02\0\0\x4d\0\0\0\0\
+\0\0\0\0\0\0\0\xb7\x03\0\0\x12\0\0\0\xb7\x05\0\0\x28\0\0\0\x85\0\0\0\x7e\0\0\0\
+\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\x20\
+\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x70\x61\x67\x65\x73\x0a\0\x25\x34\
+\x75\x25\x31\x36\x73\x25\x36\x64\x0a\0\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\x20\
+\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x70\x61\x67\x65\x73\x20\x61\x74\
+\x74\x61\x63\x68\x65\x64\x0a\0\x25\x34\x75\x25\x31\x36\x73\x25\x36\x64\x20\x25\
+\x73\x20\x25\x73\x0a\0\x47\x50\x4c\0\x9f\xeb\x01\0\x18\0\0\0\0\0\0\0\x90\x03\0\
+\0\x90\x03\0\0\xf8\x03\0\0\0\0\0\0\0\0\0\x02\x02\0\0\0\x01\0\0\0\x02\0\0\x04\
+\x10\0\0\0\x13\0\0\0\x03\0\0\0\0\0\0\0\x18\0\0\0\x04\0\0\0\x40\0\0\0\0\0\0\0\0\
+\0\0\x02\x08\0\0\0\0\0\0\0\0\0\0\x02\x0d\0\0\0\0\0\0\0\x01\0\0\x0d\x06\0\0\0\
+\x1c\0\0\0\x01\0\0\0\x20\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\x01\x24\0\0\0\x01\0\
+\0\x0c\x05\0\0\0\xa3\0\0\0\x03\0\0\x04\x18\0\0\0\xb1\0\0\0\x09\0\0\0\0\0\0\0\
+\xb5\0\0\0\x0b\0\0\0\x40\0\0\0\xc0\0\0\0\x0b\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\x02\
+\x0a\0\0\0\xc8\0\0\0\0\0\0\x07\0\0\0\0\xd1\0\0\0\0\0\0\x08\x0c\0\0\0\xd7\0\0\0\
+\0\0\0\x01\x08\0\0\0\x40\0\0\0\x91\x01\0\0\x03\0\0\x04\x18\0\0\0\x99\x01\0\0\
+\x0e\0\0\0\0\0\0\0\x9c\x01\0\0\x10\0\0\0\x20\0\0\0\xa3\x01\0\0\x12\0\0\0\x40\0\
+\0\0\xa8\x01\0\0\0\0\0\x08\x0f\0\0\0\xae\x01\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\
+\xbb\x01\0\0\x01\0\0\x04\x04\0\0\0\xca\x01\0\0\x0e\0\0\0\0\0\0\0\xd0\x01\0\0\0\
+\0\0\x01\x01\0\0\0\x08\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\x11\0\0\0\x13\0\0\0\
+\x10\0\0\0\xd5\x01\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\x02\x15\0\0\
+\0\x38\x02\0\0\x02\0\0\x04\x10\0\0\0\x13\0\0\0\x03\0\0\0\0\0\0\0\x4b\x02\0\0\
+\x16\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\x19\0\0\0\0\0\0\0\x01\0\0\x0d\x06\0\0\0\
+\x1c\0\0\0\x14\0\0\0\x50\x02\0\0\x01\0\0\x0c\x17\0\0\0\x9c\x02\0\0\x02\0\0\x04\
+\x10\0\0\0\xa5\x02\0\0\x1a\0\0\0\0\0\0\0\xca\x01\0\0\x1b\0\0\0\x40\0\0\0\0\0\0\
+\0\0\0\0\x02\x1d\0\0\0\xa9\x02\0\0\0\0\0\x08\x1c\0\0\0\xaf\x02\0\0\0\0\0\x01\
+\x02\0\0\0\x10\0\0\0\x10\x03\0\0\x04\0\0\x04\x28\0\0\0\x99\x01\0\0\x0e\0\0\0\0\
+\0\0\0\xa3\x01\0\0\x12\0\0\0\x20\0\0\0\x1d\x03\0\0\x1e\0\0\0\xc0\0\0\0\x2e\x03\
+\0\0\x16\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\x02\x1f\0\0\0\0\0\0\0\0\0\0\x0a\x11\0\0\
+\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1f\0\0\0\x13\0\0\0\x1c\0\0\0\x8a\x03\0\0\0\0\0\
+\x0e\x20\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1f\0\0\0\x13\0\0\0\x0c\0\0\0\
+\x9e\x03\0\0\0\0\0\x0e\x22\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x1f\0\0\0\
+\x13\0\0\0\x25\0\0\0\xb4\x03\0\0\0\0\0\x0e\x24\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\
+\0\0\0\0\x1f\0\0\0\x13\0\0\0\x12\0\0\0\xc9\x03\0\0\0\0\0\x0e\x26\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x03\0\0\0\0\x11\0\0\0\x13\0\0\0\x04\0\0\0\xe0\x03\0\0\0\0\0\x0e\
+\x28\0\0\0\x01\0\0\0\xe8\x03\0\0\x04\0\0\x0f\0\0\0\0\x21\0\0\0\0\0\0\0\x1c\0\0\
+\0\x23\0\0\0\x1c\0\0\0\x0c\0\0\0\x25\0\0\0\x28\0\0\0\x25\0\0\0\x27\0\0\0\x4d\0\
+\0\0\x12\0\0\0\xf0\x03\0\0\x01\0\0\x0f\0\0\0\0\x29\0\0\0\0\0\0\0\x04\0\0\0\0\
+\x62\x70\x66\x5f\x69\x74\x65\x72\x5f\x5f\x62\x70\x66\x5f\x6d\x61\x70\0\x6d\x65\
+\x74\x61\0\x6d\x61\x70\0\x63\x74\x78\0\x69\x6e\x74\0\x64\x75\x6d\x70\x5f\x62\
+\x70\x66\x5f\x6d\x61\x70\0\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x6d\x61\x70\0\
+\x30\x3a\x30\0\x2f\x77\x2f\x6e\x65\x74\x2d\x6e\x65\x78\x74\x2f\x6b\x65\x72\x6e\
+\x65\x6c\x2f\x62\x70\x66\x2f\x70\x72\x65\x6c\x6f\x61\x64\x2f\x69\x74\x65\x72\
+\x61\x74\x6f\x72\x73\x2f\x69\x74\x65\x72\x61\x74\x6f\x72\x73\x2e\x62\x70\x66\
+\x2e\x63\0\x09\x73\x74\x72\x75\x63\x74\x20\x73\x65\x71\x5f\x66\x69\x6c\x65\x20\
+\x2a\x73\x65\x71\x20\x3d\x20\x63\x74\x78\x2d\x3e\x6d\x65\x74\x61\x2d\x3e\x73\
+\x65\x71\x3b\0\x62\x70\x66\x5f\x69\x74\x65\x72\x5f\x6d\x65\x74\x61\0\x73\x65\
+\x71\0\x73\x65\x73\x73\x69\x6f\x6e\x5f\x69\x64\0\x73\x65\x71\x5f\x6e\x75\x6d\0\
+\x73\x65\x71\x5f\x66\x69\x6c\x65\0\x5f\x5f\x75\x36\x34\0\x6c\x6f\x6e\x67\x20\
+\x6c\x6f\x6e\x67\x20\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x69\x6e\x74\0\x30\x3a\
+\x31\0\x09\x73\x74\x72\x75\x63\x74\x20\x62\x70\x66\x5f\x6d\x61\x70\x20\x2a\x6d\
+\x61\x70\x20\x3d\x20\x63\x74\x78\x2d\x3e\x6d\x61\x70\x3b\0\x09\x69\x66\x20\x28\
+\x21\x6d\x61\x70\x29\0\x30\x3a\x32\0\x09\x5f\x5f\x75\x36\x34\x20\x73\x65\x71\
+\x5f\x6e\x75\x6d\x20\x3d\x20\x63\x74\x78\x2d\x3e\x6d\x65\x74\x61\x2d\x3e\x73\
+\x65\x71\x5f\x6e\x75\x6d\x3b\0\x09\x69\x66\x20\x28\x73\x65\x71\x5f\x6e\x75\x6d\
+\x20\x3d\x3d\x20\x30\x29\0\x09\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\
+\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\
+\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x70\x61\x67\x65\x73\x5c\x6e\
+\x22\x29\x3b\0\x62\x70\x66\x5f\x6d\x61\x70\0\x69\x64\0\x6d\x65\x6d\x6f\x72\x79\
+\0\x6e\x61\x6d\x65\0\x5f\x5f\x75\x33\x32\0\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\
+\x69\x6e\x74\0\x62\x70\x66\x5f\x6d\x61\x70\x5f\x6d\x65\x6d\x6f\x72\x79\0\x70\
+\x61\x67\x65\x73\0\x63\x68\x61\x72\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\x49\
+\x5a\x45\x5f\x54\x59\x50\x45\x5f\x5f\0\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\
+\x52\x49\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x25\x34\x75\x25\x31\x36\x73\
+\x25\x36\x64\x5c\x6e\x22\x2c\x20\x6d\x61\x70\x2d\x3e\x69\x64\x2c\x20\x6d\x61\
+\x70\x2d\x3e\x6e\x61\x6d\x65\x2c\x20\x6d\x61\x70\x2d\x3e\x6d\x65\x6d\x6f\x72\
+\x79\x2e\x70\x61\x67\x65\x73\x29\x3b\0\x7d\0\x62\x70\x66\x5f\x69\x74\x65\x72\
+\x5f\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x70\x72\x6f\x67\0\x64\x75\x6d\x70\
+\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\0\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x70\
+\x72\x6f\x67\0\x09\x73\x74\x72\x75\x63\x74\x20\x62\x70\x66\x5f\x70\x72\x6f\x67\
+\x20\x2a\x70\x72\x6f\x67\x20\x3d\x20\x63\x74\x78\x2d\x3e\x70\x72\x6f\x67\x3b\0\
+\x09\x69\x66\x20\x28\x21\x70\x72\x6f\x67\x29\0\x62\x70\x66\x5f\x70\x72\x6f\x67\
+\0\x61\x75\x78\0\x5f\x5f\x75\x31\x36\0\x75\x6e\x73\x69\x67\x6e\x65\x64\x20\x73\
+\x68\x6f\x72\x74\0\x09\x61\x75\x78\x20\x3d\x20\x70\x72\x6f\x67\x2d\x3e\x61\x75\
+\x78\x3b\0\x09\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\x50\x52\x49\x4e\x54\x46\x28\
+\x73\x65\x71\x2c\x20\x22\x20\x20\x69\x64\x20\x6e\x61\x6d\x65\x20\x20\x20\x20\
+\x20\x20\x20\x20\x20\x20\x20\x20\x70\x61\x67\x65\x73\x20\x61\x74\x74\x61\x63\
+\x68\x65\x64\x5c\x6e\x22\x29\x3b\0\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x61\x75\
+\x78\0\x61\x74\x74\x61\x63\x68\x5f\x66\x75\x6e\x63\x5f\x6e\x61\x6d\x65\0\x6c\
+\x69\x6e\x6b\x65\x64\x5f\x70\x72\x6f\x67\0\x09\x42\x50\x46\x5f\x53\x45\x51\x5f\
+\x50\x52\x49\x4e\x54\x46\x28\x73\x65\x71\x2c\x20\x22\x25\x34\x75\x25\x31\x36\
+\x73\x25\x36\x64\x20\x25\x73\x20\x25\x73\x5c\x6e\x22\x2c\x20\x61\x75\x78\x2d\
+\x3e\x69\x64\x2c\x20\x61\x75\x78\x2d\x3e\x6e\x61\x6d\x65\x2c\x20\x70\x72\x6f\
+\x67\x2d\x3e\x70\x61\x67\x65\x73\x2c\0\x30\x3a\x33\0\x64\x75\x6d\x70\x5f\x62\
+\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\x75\x6d\x70\x5f\x62\
+\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x31\0\x64\x75\x6d\x70\
+\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\x75\x6d\
+\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x32\0\
+\x4c\x49\x43\x45\x4e\x53\x45\0\x2e\x72\x6f\x64\x61\x74\x61\0\x6c\x69\x63\x65\
+\x6e\x73\x65\0\x9f\xeb\x01\0\x20\0\0\0\0\0\0\0\x24\0\0\0\x24\0\0\0\x44\x01\0\0\
+\x68\x01\0\0\x34\x01\0\0\x08\0\0\0\x31\0\0\0\x01\0\0\0\0\0\0\0\x07\0\0\0\x5e\
+\x02\0\0\x01\0\0\0\0\0\0\0\x18\0\0\0\x10\0\0\0\x31\0\0\0\x09\0\0\0\0\0\0\0\x42\
+\0\0\0\x7b\0\0\0\x1e\xc0\0\0\x08\0\0\0\x42\0\0\0\x7b\0\0\0\x24\xc0\0\0\x10\0\0\
+\0\x42\0\0\0\xf2\0\0\0\x1d\xc8\0\0\x18\0\0\0\x42\0\0\0\x13\x01\0\0\x06\xd0\0\0\
+\x20\0\0\0\x42\0\0\0\x22\x01\0\0\x1d\xc4\0\0\x28\0\0\0\x42\0\0\0\x47\x01\0\0\
+\x06\xdc\0\0\x38\0\0\0\x42\0\0\0\x5a\x01\0\0\x03\xe0\0\0\x70\0\0\0\x42\0\0\0\
+\xe9\x01\0\0\x02\xe8\0\0\xf0\0\0\0\x42\0\0\0\x36\x02\0\0\x01\xf0\0\0\x5e\x02\0\
+\0\x0a\0\0\0\0\0\0\0\x42\0\0\0\x7b\0\0\0\x1e\x04\x01\0\x08\0\0\0\x42\0\0\0\x7b\
+\0\0\0\x24\x04\x01\0\x10\0\0\0\x42\0\0\0\x6c\x02\0\0\x1f\x0c\x01\0\x18\0\0\0\
+\x42\0\0\0\x90\x02\0\0\x06\x18\x01\0\x20\0\0\0\x42\0\0\0\xbe\x02\0\0\x0e\x24\
+\x01\0\x28\0\0\0\x42\0\0\0\x22\x01\0\0\x1d\x08\x01\0\x30\0\0\0\x42\0\0\0\x47\
+\x01\0\0\x06\x28\x01\0\x40\0\0\0\x42\0\0\0\xd0\x02\0\0\x03\x2c\x01\0\x78\0\0\0\
+\x42\0\0\0\x3a\x03\0\0\x02\x34\x01\0\x28\x01\0\0\x42\0\0\0\x36\x02\0\0\x01\x40\
+\x01\0\x10\0\0\0\x31\0\0\0\x07\0\0\0\0\0\0\0\x02\0\0\0\x3e\0\0\0\0\0\0\0\x08\0\
+\0\0\x08\0\0\0\x3e\0\0\0\0\0\0\0\x10\0\0\0\x02\0\0\0\xee\0\0\0\0\0\0\0\x20\0\0\
+\0\x08\0\0\0\x1e\x01\0\0\0\0\0\0\x70\0\0\0\x0d\0\0\0\x3e\0\0\0\0\0\0\0\x80\0\0\
+\0\x0d\0\0\0\x1e\x01\0\0\0\0\0\0\xa0\0\0\0\x0d\0\0\0\xee\0\0\0\0\0\0\0\x5e\x02\
+\0\0\x0b\0\0\0\0\0\0\0\x15\0\0\0\x3e\0\0\0\0\0\0\0\x08\0\0\0\x08\0\0\0\x3e\0\0\
+\0\0\0\0\0\x10\0\0\0\x15\0\0\0\xee\0\0\0\0\0\0\0\x20\0\0\0\x19\0\0\0\x3e\0\0\0\
+\0\0\0\0\x28\0\0\0\x08\0\0\0\x1e\x01\0\0\0\0\0\0\x78\0\0\0\x1d\0\0\0\x3e\0\0\0\
+\0\0\0\0\x88\0\0\0\x1d\0\0\0\xee\0\0\0\0\0\0\0\xa8\0\0\0\x19\0\0\0\xee\0\0\0\0\
+\0\0\0\xb8\0\0\0\x1d\0\0\0\x1e\x01\0\0\0\0\0\0\xc8\0\0\0\x1d\0\0\0\x86\x03\0\0\
+\0\0\0\0\xd0\0\0\0\x19\0\0\0\x3e\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\xcf\0\0\0\0\0\x02\0\x70\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xc1\0\
+\0\0\0\0\x02\0\xf0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xc8\0\0\0\0\0\x03\0\x78\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\xba\0\0\0\0\0\x03\0\x28\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x14\0\0\0\x01\0\x04\0\0\0\0\0\0\0\0\0\x1c\0\0\0\0\0\0\0\xed\0\0\0\x01\0\x04\
+\0\x1c\0\0\0\0\0\0\0\x0c\0\0\0\0\0\0\0\x28\0\0\0\x01\0\x04\0\x28\0\0\0\0\0\0\0\
+\x25\0\0\0\0\0\0\0\xd6\0\0\0\x01\0\x04\0\x4d\0\0\0\0\0\0\0\x12\0\0\0\0\0\0\0\0\
+\0\0\0\x03\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x03\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\xb2\0\0\0\x11\0\x05\0\0\0\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\x3d\0\0\0\x12\0\x02\0\
+\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\x5b\0\0\0\x12\0\x03\0\0\0\0\0\0\0\0\0\x38\
+\x01\0\0\0\0\0\0\x48\0\0\0\0\0\0\0\x01\0\0\0\x0b\0\0\0\xc8\0\0\0\0\0\0\0\x01\0\
+\0\0\x0b\0\0\0\x50\0\0\0\0\0\0\0\x01\0\0\0\x0b\0\0\0\0\x01\0\0\0\0\0\0\x01\0\0\
+\0\x0b\0\0\0\x64\x03\0\0\0\0\0\0\x0a\0\0\0\x0b\0\0\0\x70\x03\0\0\0\0\0\0\x0a\0\
+\0\0\x0b\0\0\0\x7c\x03\0\0\0\0\0\0\x0a\0\0\0\x0b\0\0\0\x88\x03\0\0\0\0\0\0\x0a\
+\0\0\0\x0b\0\0\0\xa0\x03\0\0\0\0\0\0\0\0\0\0\x0c\0\0\0\x2c\0\0\0\0\0\0\0\0\0\0\
+\0\x09\0\0\0\x3c\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x50\0\0\0\0\0\0\0\0\0\0\0\x09\
+\0\0\0\x60\0\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\x70\0\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\
+\x80\0\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\x90\0\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xa0\0\
+\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xb0\0\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xc0\0\0\0\0\
+\0\0\0\0\0\0\0\x09\0\0\0\xd0\0\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xe8\0\0\0\0\0\0\0\
+\0\0\0\0\x0a\0\0\0\xf8\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x08\x01\0\0\0\0\0\0\0\0\
+\0\0\x0a\0\0\0\x18\x01\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x28\x01\0\0\0\0\0\0\0\0\0\
+\0\x0a\0\0\0\x38\x01\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x48\x01\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\x58\x01\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x68\x01\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\x78\x01\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x94\x01\0\0\0\0\0\0\0\0\0\0\
+\x09\0\0\0\xa4\x01\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xb4\x01\0\0\0\0\0\0\0\0\0\0\
+\x09\0\0\0\xc4\x01\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xd4\x01\0\0\0\0\0\0\0\0\0\0\
+\x09\0\0\0\xe4\x01\0\0\0\0\0\0\0\0\0\0\x09\0\0\0\xf4\x01\0\0\0\0\0\0\0\0\0\0\
+\x09\0\0\0\x0c\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x1c\x02\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\x2c\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x3c\x02\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\x4c\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x5c\x02\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\x6c\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x7c\x02\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\x8c\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x9c\x02\0\0\0\0\0\0\0\0\0\0\
+\x0a\0\0\0\xac\x02\0\0\0\0\0\0\0\0\0\0\x0a\0\0\0\x3d\x3e\x30\x31\x32\x33\x3c\0\
+\x2e\x74\x65\x78\x74\0\x2e\x72\x65\x6c\x2e\x42\x54\x46\x2e\x65\x78\x74\0\x64\
+\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\0\x64\
+\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\0\
+\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x6d\x61\x70\0\x2e\x72\x65\x6c\x69\x74\x65\
+\x72\x2f\x62\x70\x66\x5f\x6d\x61\x70\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\x70\
+\x72\x6f\x67\0\x2e\x72\x65\x6c\x69\x74\x65\x72\x2f\x62\x70\x66\x5f\x70\x72\x6f\
+\x67\0\x2e\x6c\x6c\x76\x6d\x5f\x61\x64\x64\x72\x73\x69\x67\0\x6c\x69\x63\x65\
+\x6e\x73\x65\0\x2e\x73\x74\x72\x74\x61\x62\0\x2e\x73\x79\x6d\x74\x61\x62\0\x2e\
+\x72\x6f\x64\x61\x74\x61\0\x2e\x72\x65\x6c\x2e\x42\x54\x46\0\x4c\x49\x43\x45\
+\x4e\x53\x45\0\x4c\x42\x42\x31\x5f\x34\0\x4c\x42\x42\x30\x5f\x34\0\x4c\x42\x42\
+\x31\x5f\x33\0\x4c\x42\x42\x30\x5f\x33\0\x64\x75\x6d\x70\x5f\x62\x70\x66\x5f\
+\x70\x72\x6f\x67\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x32\0\x64\x75\x6d\x70\x5f\x62\
+\x70\x66\x5f\x6d\x61\x70\x2e\x5f\x5f\x5f\x66\x6d\x74\x2e\x31\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x01\0\0\0\x06\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x04\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x4e\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\x40\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\x6d\0\0\0\x01\0\0\0\x06\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x40\x01\0\0\
+\0\0\0\0\x38\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\xa1\0\0\0\x01\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x78\x02\0\0\0\0\0\0\x5f\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x89\0\0\0\x01\
+\0\0\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xd7\x02\0\0\0\0\0\0\x04\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xad\0\0\0\x01\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\xdb\x02\0\0\0\0\0\0\xa0\x07\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x0b\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\x7b\x0a\0\0\0\0\0\0\xbc\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\x99\0\0\0\x02\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x38\
+\x0d\0\0\0\0\0\0\x68\x01\0\0\0\0\0\0\x0e\0\0\0\x0c\0\0\0\x08\0\0\0\0\0\0\0\x18\
+\0\0\0\0\0\0\0\x4a\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xa0\x0e\0\0\
+\0\0\0\0\x20\0\0\0\0\0\0\0\x08\0\0\0\x02\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\
+\0\0\x69\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xc0\x0e\0\0\0\0\0\0\
+\x20\0\0\0\0\0\0\0\x08\0\0\0\x03\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\xa9\
+\0\0\0\x09\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xe0\x0e\0\0\0\0\0\0\x50\0\0\0\
+\0\0\0\0\x08\0\0\0\x06\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x07\0\0\0\x09\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x30\x0f\0\0\0\0\0\0\x70\x02\0\0\0\0\0\0\
+\x08\0\0\0\x07\0\0\0\x08\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x7b\0\0\0\x03\x4c\xff\
+\x6f\0\0\0\x80\0\0\0\0\0\0\0\0\0\0\0\0\xa0\x11\0\0\0\0\0\0\x07\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x91\0\0\0\x03\0\0\0\0\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\xa7\x11\0\0\0\0\0\0\x03\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
+
+	return 0;
+err:
+	bpf_object__destroy_skeleton(s);
+	return -1;
+}
+
+#endif /* __ITERATORS_BPF_SKEL_H__ */
-- 
2.23.0

