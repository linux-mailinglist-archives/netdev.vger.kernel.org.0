Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BB120A825
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407524AbgFYWOS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:14:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407512AbgFYWOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:14:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-7DgA0WMJP3S9MUTLgc6D0w-1; Thu, 25 Jun 2020 18:14:08 -0400
X-MC-Unique: 7DgA0WMJP3S9MUTLgc6D0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C195C107ACF8;
        Thu, 25 Jun 2020 22:14:06 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D6FC79303;
        Thu, 25 Jun 2020 22:14:03 +0000 (UTC)
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
Subject: [PATCH v4 bpf-next 14/14] selftests/bpf: Add test for resolve_btfids
Date:   Fri, 26 Jun 2020 00:13:04 +0200
Message-Id: <20200625221304.2817194-15-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
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

Adding test to resolve_btfids tool, that:
  - creates binary with BTF IDs list and set
  - process the binary with resolve_btfids tool
  - verifies that correct BTF ID values are in place

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  20 +-
 .../selftests/bpf/test_resolve_btfids.c       | 201 ++++++++++++++++++
 2 files changed, 220 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/test_resolve_btfids.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 22aaec74ea0a..547322a5feff 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -37,7 +37,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
 	test_progs-no_alu32 \
-	test_current_pid_tgid_new_ns
+	test_current_pid_tgid_new_ns \
+	test_resolve_btfids
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
@@ -427,6 +428,23 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
 	$(call msg,BINARY,,$@)
 	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
 
+# test_resolve_btfids
+#
+$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ) FORCE
+	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
+		    OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
+
+$(OUTPUT)/test_resolve_btfids.o: test_resolve_btfids.c
+	$(call msg,CC,,$@)
+	$(CC) $(CFLAGS) -I$(TOOLSINCDIR) -D"BUILD_STR(s)=#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))" -c -o $@ $<
+
+.PHONY: FORCE
+
+$(OUTPUT)/test_resolve_btfids: $(OUTPUT)/test_resolve_btfids.o $(SCRATCH_DIR)/resolve_btfids
+	$(call msg,BINARY,,$@)
+	$(CC) -o $@ $< $(BPFOBJ) -lelf -lz && \
+	$(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) $@
+
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
diff --git a/tools/testing/selftests/bpf/test_resolve_btfids.c b/tools/testing/selftests/bpf/test_resolve_btfids.c
new file mode 100644
index 000000000000..48aeda2ed881
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_resolve_btfids.c
@@ -0,0 +1,201 @@
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
+
+#define __CHECK(condition, format...) ({				\
+	int __ret = !!(condition);					\
+	if (__ret) {							\
+		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
+		fprintf(stderr, format);				\
+	}								\
+	__ret;								\
+})
+
+#define CHECK(condition, format...)					\
+	do {								\
+		if (__CHECK(condition, format))				\
+			return -1;					\
+	} while (0)
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
+BTF_ID(typedef, pid_t)
+BTF_ID(struct,  sk_buff)
+BTF_ID(union,   thread_union)
+BTF_ID(func,    memcpy)
+
+BTF_SET_START(test_set)
+BTF_ID(typedef, pid_t)
+BTF_ID(struct,  sk_buff)
+BTF_ID(union,   thread_union)
+BTF_ID(func,    memcpy)
+BTF_SET_END(test_set)
+
+struct symbol {
+	const char	*name;
+	int		 type;
+	int		 id;
+};
+
+struct symbol test_symbols[] = {
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
+	CHECK(!type, "Failed to get type for ID %d\n", type_id);
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
+			fprintf(stderr, "failed to get name for BTF ID %d\n",
+				type_id);
+			continue;
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
+	int err;
+
+	btf = btf_open(path);
+	CHECK(libbpf_get_error(btf), "Failed to load BTF from %s\n", path);
+
+	nr = btf__get_nr_types(btf);
+
+	for (type_id = 0; type_id < nr; type_id++) {
+		err = __resolve_symbol(btf, type_id);
+		if (__CHECK(err, "Failed to resolve symbols\n"))
+			break;
+	}
+
+	btf__free(btf);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	unsigned int i, j;
+
+	CHECK(resolve_symbols(), "symbol resolve failed\n");
+
+	/* Check BTF_SET_START(test_set) IDs */
+	for (i = 0; i < test_set.cnt; i++) {
+		bool found = false;
+
+		for (j = 0; j < test_set.cnt; j++) {
+			if (test_symbols[j].id != test_set.ids[i])
+				continue;
+			found = true;
+			break;
+		}
+
+		CHECK(!found, "ID %d not found in test_symbols\n",
+		      test_set.ids[i]);
+
+		if (i > 0) {
+			CHECK(test_set.ids[i - 1] > test_set.ids[i],
+			      "test_set is not sorted\n");
+		}
+	}
+
+	/* Check BTF_ID_LIST(test_list) IDs */
+	for (i = 0; i < ARRAY_SIZE(test_symbols); i++) {
+		CHECK(test_list[i] != test_symbols[i].id,
+		      "wrong ID for %s\n", test_symbols[i].name);
+	}
+
+	return 0;
+}
-- 
2.25.4

