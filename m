Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C521381F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 11:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgGCJwI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jul 2020 05:52:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgGCJwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 05:52:07 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-Tz0clC4DMHm8R-5KXzlMHQ-1; Fri, 03 Jul 2020 05:52:01 -0400
X-MC-Unique: Tz0clC4DMHm8R-5KXzlMHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CBA9800C64;
        Fri,  3 Jul 2020 09:51:59 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E58B7275E31;
        Fri,  3 Jul 2020 09:51:55 +0000 (UTC)
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
Subject: [PATCH v5 bpf-next 9/9] selftests/bpf: Add test for resolve_btfids
Date:   Fri,  3 Jul 2020 11:51:11 +0200
Message-Id: <20200703095111.3268961-10-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-1-jolsa@kernel.org>
References: <20200703095111.3268961-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Adding resolve_btfids test under test_progs suite.

It's possible to use btf_ids.h header and its logic in
user space application, so we can add easy test for it.

The test defines BTF_ID_LIST and checks it gets properly
resolved.

For this reason the test_progs binary (and other binaries
that use TRUNNER* macros) is processed with resolve_btfids
tool, which resolves BTF IDs in .BTF.ids section.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  22 ++-
 .../selftests/bpf/prog_tests/resolve_btfids.c | 170 ++++++++++++++++++
 2 files changed, 190 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1f9c696b3edf..b47a685d12bd 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -190,6 +190,16 @@ else
 	cp "$(VMLINUX_H)" $@
 endif
 
+$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ)				\
+			       $(TOOLSDIR)/bpf/resolve_btfids/main.c	\
+			       $(TOOLSDIR)/lib/rbtree.c			\
+			       $(TOOLSDIR)/lib/zalloc.c			\
+			       $(TOOLSDIR)/lib/string.c			\
+			       $(TOOLSDIR)/lib/ctype.c			\
+			       $(TOOLSDIR)/lib/str_error_r.c
+	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
+	OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
+
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
 # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
@@ -333,7 +343,8 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
-	cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
+	cd $$(@D) && $$(CC) -I. $$(CFLAGS) $(TRUNNER_EXTRA_CFLAGS)	\
+	-c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       %.c						\
@@ -355,6 +366,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
+	$(TRUNNER_BINARY_EXTRA_CMD)
 
 endef
 
@@ -365,7 +377,10 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 flow_dissector_load.h
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
-		       $(wildcard progs/btf_dump_test_case_*.c)
+		       $(wildcard progs/btf_dump_test_case_*.c)		\
+		       $(SCRATCH_DIR)/resolve_btfids
+TRUNNER_EXTRA_CFLAGS := -D"BUILD_STR(s)=\#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))"
+TRUNNER_BINARY_EXTRA_CMD := $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) test_progs
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
 TRUNNER_BPF_LDFLAGS := -mattr=+alu32
@@ -373,6 +388,7 @@ $(eval $(call DEFINE_TEST_RUNNER,test_progs))
 
 # Define test_progs-no_alu32 test runner.
 TRUNNER_BPF_BUILD_RULE := CLANG_NOALU32_BPF_BUILD_RULE
+TRUNNER_BINARY_EXTRA_CMD := $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) test_progs-no_alu32
 TRUNNER_BPF_LDFLAGS :=
 $(eval $(call DEFINE_TEST_RUNNER,test_progs,no_alu32))
 
@@ -392,6 +408,8 @@ TRUNNER_EXTRA_FILES :=
 TRUNNER_BPF_BUILD_RULE := $$(error no BPF objects should be built)
 TRUNNER_BPF_CFLAGS :=
 TRUNNER_BPF_LDFLAGS :=
+TRUNNER_EXTRA_CFLAGS :=
+TRUNNER_BINARY_EXTRA_CMD :=
 $(eval $(call DEFINE_TEST_RUNNER,test_maps))
 
 # Define test_verifier test runner.
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
new file mode 100644
index 000000000000..6b7b5f736181
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <string.h>
+#include <stdio.h>
+#include <sys/stat.h>
+#include <stdio.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/err.h>
+#include <stdlib.h>
+#include <bpf/btf.h>
+#include <bpf/libbpf.h>
+#include <linux/btf.h>
+#include <linux/kernel.h>
+#include <linux/btf_ids.h>
+#include "test_progs.h"
+
+static int duration;
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
+BTF_ID_LIST(test_list)
+BTF_ID_UNUSED
+BTF_ID(typedef, pid_t)
+BTF_ID(struct,  sk_buff)
+BTF_ID(union,   thread_union)
+BTF_ID(func,    memcpy)
+
+struct symbol {
+	const char	*name;
+	int		 type;
+	int		 id;
+};
+
+struct symbol test_symbols[] = {
+	{ "unused",       -1,                0 },
+	{ "pid_t",        BTF_KIND_TYPEDEF, -1 },
+	{ "sk_buff",      BTF_KIND_STRUCT,  -1 },
+	{ "thread_union", BTF_KIND_UNION,   -1 },
+	{ "memcpy",       BTF_KIND_FUNC,    -1 },
+};
+
+static int
+__resolve_symbol(struct btf *btf, int type_id)
+{
+	const struct btf_type *type;
+	const char *str;
+	unsigned int i;
+
+	type = btf__type_by_id(btf, type_id);
+	if (!type) {
+		PRINT_FAIL("Failed to get type for ID %d\n", type_id);
+		return -1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(test_symbols); i++) {
+		if (test_symbols[i].id != -1)
+			continue;
+
+		if (BTF_INFO_KIND(type->info) != test_symbols[i].type)
+			continue;
+
+		str = btf__name_by_offset(btf, type->name_off);
+		if (!str) {
+			PRINT_FAIL("Failed to get name for BTF ID %d\n", type_id);
+			return -1;
+		}
+
+		if (!strcmp(str, test_symbols[i].name))
+			test_symbols[i].id = type_id;
+	}
+
+	return 0;
+}
+
+static int resolve_symbols(void)
+{
+	const char *path = VMLINUX_BTF;
+	struct btf *btf;
+	int type_id;
+	__u32 nr;
+
+	btf = btf_open(path);
+	if (CHECK(libbpf_get_error(btf), "resolve",
+		  "Failed to load BTF from %s\n", path))
+		return -1;
+
+	nr = btf__get_nr_types(btf);
+
+	for (type_id = 1; type_id <= nr; type_id++) {
+		if (__resolve_symbol(btf, type_id))
+			break;
+	}
+
+	btf__free(btf);
+	return 0;
+}
+
+int test_resolve_btfids(void)
+{
+	unsigned int i;
+	int ret = 0;
+
+	if (resolve_symbols())
+		return -1;
+
+	/* Check BTF_ID_LIST(test_list) IDs */
+	for (i = 0; i < ARRAY_SIZE(test_symbols) && !ret; i++) {
+		ret = CHECK(test_list[i] != test_symbols[i].id,
+			    "id_check",
+			    "wrong ID for %s (%d != %d)\n", test_symbols[i].name,
+			    test_list[i], test_symbols[i].id);
+	}
+
+	return 0;
+}
-- 
2.25.4

