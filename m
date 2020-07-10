Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF221BDCE
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgGJTia convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 15:38:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44816 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728444AbgGJTiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:38:23 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-pXsXF9x0MgqWVx4crsZIeg-1; Fri, 10 Jul 2020 15:38:15 -0400
X-MC-Unique: pXsXF9x0MgqWVx4crsZIeg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FBB98015F7;
        Fri, 10 Jul 2020 19:38:14 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C42D610016E8;
        Fri, 10 Jul 2020 19:38:12 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v6 bpf-next 9/9] selftests/bpf: Add test for resolve_btfids
Date:   Fri, 10 Jul 2020 21:37:54 +0200
Message-Id: <20200710193754.3821104-10-jolsa@kernel.org>
In-Reply-To: <20200710193754.3821104-1-jolsa@kernel.org>
References: <20200710193754.3821104-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
tool, which resolves BTF IDs in .BTF_ids section. The BTF
data are taken from btf_data.o object rceated from
progs/btf_data.c.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  14 ++-
 .../selftests/bpf/prog_tests/resolve_btfids.c | 107 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/btf_data.c  |  26 +++++
 3 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_data.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1f9c696b3edf..2eae482b2713 100644
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
+		OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
+
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
 # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
@@ -355,6 +365,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
+	$(SCRATCH_DIR)/resolve_btfids --no-fail --btf btf_data.o $$@
 
 endef
 
@@ -365,7 +376,8 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 flow_dissector_load.h
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
-		       $(wildcard progs/btf_dump_test_case_*.c)
+		       $(wildcard progs/btf_dump_test_case_*.c)		\
+		       $(SCRATCH_DIR)/resolve_btfids
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
 TRUNNER_BPF_LDFLAGS := -mattr=+alu32
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
new file mode 100644
index 000000000000..060264c96601
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/err.h>
+#include <string.h>
+#include <bpf/btf.h>
+#include <bpf/libbpf.h>
+#include <linux/btf.h>
+#include <linux/kernel.h>
+#include <linux/btf_ids.h>
+#include "test_progs.h"
+
+static int duration;
+
+struct symbol {
+	const char	*name;
+	int		 type;
+	int		 id;
+};
+
+struct symbol test_symbols[] = {
+	{ "unused",  BTF_KIND_UNKN,     0 },
+	{ "T",       BTF_KIND_TYPEDEF, -1 },
+	{ "S",       BTF_KIND_STRUCT,  -1 },
+	{ "U",       BTF_KIND_UNION,   -1 },
+	{ "func",    BTF_KIND_FUNC,    -1 },
+};
+
+BTF_ID_LIST(test_list)
+BTF_ID_UNUSED
+BTF_ID(typedef, T)
+BTF_ID(struct,  S)
+BTF_ID(union,   U)
+BTF_ID(func,    func)
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
+	struct btf *btf;
+	int type_id;
+	__u32 nr;
+
+	btf = btf__parse_elf("btf_data.o", NULL);
+	if (CHECK(libbpf_get_error(btf), "resolve",
+		  "Failed to load BTF from btf_data.o\n"))
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
+	return ret;
+}
diff --git a/tools/testing/selftests/bpf/progs/btf_data.c b/tools/testing/selftests/bpf/progs/btf_data.c
new file mode 100644
index 000000000000..26b85f45e584
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_data.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+struct S {
+	int	a;
+	int	b;
+	int	c;
+};
+
+union U {
+	int	a;
+	int	b;
+	int	c;
+};
+
+typedef int T;
+
+struct root_struct {
+	T		m_1;
+	struct S	m_2;
+	union U		m_3;
+};
+
+int func(struct root_struct *root)
+{
+	return 0;
+}
-- 
2.25.4

