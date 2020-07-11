Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501E221C68E
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgGKVx7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 11 Jul 2020 17:53:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35903 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgGKVx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:53:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-bOoJLG2dPdSJqtdIZL_9_Q-1; Sat, 11 Jul 2020 17:53:50 -0400
X-MC-Unique: bOoJLG2dPdSJqtdIZL_9_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA8211081;
        Sat, 11 Jul 2020 21:53:48 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B3CD60BEC;
        Sat, 11 Jul 2020 21:53:47 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v7 bpf-next 9/9] selftests/bpf: Add test for resolve_btfids
Date:   Sat, 11 Jul 2020 23:53:29 +0200
Message-Id: <20200711215329.41165-10-jolsa@kernel.org>
In-Reply-To: <20200711215329.41165-1-jolsa@kernel.org>
References: <20200711215329.41165-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  15 ++-
 .../selftests/bpf/prog_tests/resolve_btfids.c | 111 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/btf_data.c  |  50 ++++++++
 3 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_data.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1f9c696b3edf..e7a8cf83ba48 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -111,6 +111,7 @@ SCRATCH_DIR := $(OUTPUT)/tools
 BUILD_DIR := $(SCRATCH_DIR)/build
 INCLUDE_DIR := $(SCRATCH_DIR)/include
 BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
+RESOLVE_BTFIDS := $(BUILD_DIR)/resolve_btfids/resolve_btfids
 
 # Define simple and short `make test_progs`, `make test_sysctl`, etc targets
 # to build individual tests.
@@ -177,7 +178,7 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
 		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
 
-$(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_DIR):
+$(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(BUILD_DIR)/resolve_btfids $(INCLUDE_DIR):
 	$(call msg,MKDIR,,$@)
 	mkdir -p $@
 
@@ -190,6 +191,16 @@ else
 	cp "$(VMLINUX_H)" $@
 endif
 
+$(RESOLVE_BTFIDS): $(BPFOBJ) | $(BUILD_DIR)/resolve_btfids	\
+		       $(TOOLSDIR)/bpf/resolve_btfids/main.c	\
+		       $(TOOLSDIR)/lib/rbtree.c			\
+		       $(TOOLSDIR)/lib/zalloc.c			\
+		       $(TOOLSDIR)/lib/string.c			\
+		       $(TOOLSDIR)/lib/ctype.c			\
+		       $(TOOLSDIR)/lib/str_error_r.c
+	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
+		OUTPUT=$(BUILD_DIR)/resolve_btfids/ BPFOBJ=$(BPFOBJ)
+
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
 # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
@@ -352,9 +363,11 @@ endif
 
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
+			     $(RESOLVE_BTFIDS)				\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
+	$(RESOLVE_BTFIDS) --no-fail --btf btf_data.o $$@
 
 endef
 
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
new file mode 100644
index 000000000000..403be6f36cba
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -0,0 +1,111 @@
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
+	{ "S",       BTF_KIND_TYPEDEF, -1 },
+	{ "T",       BTF_KIND_TYPEDEF, -1 },
+	{ "U",       BTF_KIND_TYPEDEF, -1 },
+	{ "S",       BTF_KIND_STRUCT,  -1 },
+	{ "U",       BTF_KIND_UNION,   -1 },
+	{ "func",    BTF_KIND_FUNC,    -1 },
+};
+
+BTF_ID_LIST(test_list)
+BTF_ID_UNUSED
+BTF_ID(typedef, S)
+BTF_ID(typedef, T)
+BTF_ID(typedef, U)
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
index 000000000000..baa525275bde
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf_data.c
@@ -0,0 +1,50 @@
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
+struct S1 {
+	int	a;
+	int	b;
+	int	c;
+};
+
+union U1 {
+	int	a;
+	int	b;
+	int	c;
+};
+
+typedef int T;
+typedef int S;
+typedef int U;
+typedef int T1;
+typedef int S1;
+typedef int U1;
+
+struct root_struct {
+	S		m_1;
+	T		m_2;
+	U		m_3;
+	S1		m_4;
+	T1		m_5;
+	U1		m_6;
+	struct S	m_7;
+	struct S1	m_8;
+	union  U	m_9;
+	union  U1	m_10;
+};
+
+int func(struct root_struct *root)
+{
+	return 0;
+}
-- 
2.25.4

