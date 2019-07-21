Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229E16F5F0
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 23:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGUVdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 17:33:13 -0400
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:39075 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfGUVcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 17:32:55 -0400
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id x6LLVr1b000408
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 23:31:53 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x6LLVpu8070763;
        Sun, 21 Jul 2019 23:31:52 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v10 08/10] bpf: Add a Landlock sandbox example
Date:   Sun, 21 Jul 2019 23:31:14 +0200
Message-Id: <20190721213116.23476-9-mic@digikod.net>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190721213116.23476-1-mic@digikod.net>
References: <20190721213116.23476-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a basic sandbox tool to launch a command which is denied access to a
list of files and directories.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

Changes since v9:
* replace subtype with expected_attach_type and expected_attach_triggers
* add the ability to parse Landlock programs and triggers to libbpf
* use the new bpf_inode_map_lookup_elem()
* use read-only inode map for Landlock programs
* remove bpf_load.c modifications

Changes since v8:
* rewrite the landlock1 sample which deny access to a set of files or
  directories (i.e. simple blacklist) to fit with the previous patches
* add "landlock1" to .gitignore
* in bpf_load.c, pass the subtype with a call to
  bpf_load_program_xattr()

Changes since v7:
* rewrite the example using an inode map
* add to bpf_load the ability to handle subtypes per program type

Changes since v6:
* check return value of load_and_attach()
* allow to write on pipes
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
* rename Landlock version to ABI to better reflect its purpose
* use const variable (suggested by Kees Cook)
* remove useless definitions (suggested by Kees Cook)
* add detailed explanations (suggested by Kees Cook)

Changes since v5:
* cosmetic fixes
* rebase

Changes since v4:
* write Landlock rule in C and compiled it with LLVM
* remove cgroup handling
* remove path handling: only handle a read-only environment
* remove errno return codes

Changes since v3:
* remove seccomp and origin field: completely free from seccomp programs
* handle more FS-related hooks
* handle inode hooks and directory traversal
* add faked but consistent view thanks to ENOENT
* add /lib64 in the example
* fix spelling
* rename some types and definitions (e.g. SECCOMP_ADD_LANDLOCK_RULE)

Changes since v2:
* use BPF_PROG_ATTACH for cgroup handling
---
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   3 +
 samples/bpf/landlock1.h                       |   8 +
 samples/bpf/landlock1_kern.c                  |  55 ++++
 samples/bpf/landlock1_user.c                  | 250 ++++++++++++++++++
 tools/lib/bpf/libbpf.c                        |  43 ++-
 tools/lib/bpf/libbpf.h                        |   7 +-
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h     |   2 +
 .../selftests/bpf/test_section_names.c        |   2 +-
 .../selftests/bpf/test_sockopt_multi.c        |   4 +-
 tools/testing/selftests/bpf/test_sockopt_sk.c |   2 +-
 12 files changed, 364 insertions(+), 14 deletions(-)
 create mode 100644 samples/bpf/landlock1.h
 create mode 100644 samples/bpf/landlock1_kern.c
 create mode 100644 samples/bpf/landlock1_user.c

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 74d31fd3c99c..a4c9c806f739 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -2,6 +2,7 @@ cpustat
 fds_example
 hbm
 ibumad
+landlock1
 lathist
 lwt_len_hist
 map_perf_test
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f90daadfbc89..b0309ed7c1c9 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ hostprogs-y += task_fd_query
 hostprogs-y += xdp_sample_pkts
 hostprogs-y += ibumad
 hostprogs-y += hbm
+hostprogs-y += landlock1
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+landlock1-objs := bpf_load.o landlock1_user.o
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
@@ -170,6 +172,7 @@ always += xdp_sample_pkts_kern.o
 always += ibumad_kern.o
 always += hbm_out_kern.o
 always += hbm_edt_kern.o
+always += landlock1_kern.o
 
 KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
diff --git a/samples/bpf/landlock1.h b/samples/bpf/landlock1.h
new file mode 100644
index 000000000000..53b0a9447855
--- /dev/null
+++ b/samples/bpf/landlock1.h
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock sample 1 - common header
+ *
+ * Copyright © 2018-2019 Mickaël Salaün <mic@digikod.net>
+ */
+
+#define MAP_FLAG_DENY		(1ULL << 0)
diff --git a/samples/bpf/landlock1_kern.c b/samples/bpf/landlock1_kern.c
new file mode 100644
index 000000000000..d6946659f891
--- /dev/null
+++ b/samples/bpf/landlock1_kern.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock sample 1 - whitelist of read only or read-write file hierarchy
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ */
+
+/*
+ * This file contains a function that will be compiled to eBPF bytecode thanks
+ * to LLVM/Clang.
+ *
+ * Each SEC() means that the following function or variable will be part of a
+ * custom ELF section. This sections are then processed by the userspace part
+ * (see landlock1_user.c) to extract eBPF bytecode and metadata.
+ */
+
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/landlock.h>
+
+#include "bpf_helpers.h"
+#include "landlock1.h" /* MAP_FLAG_DENY */
+
+#define MAP_MAX_ENTRIES		20
+
+struct bpf_map_def SEC("maps") inode_map = {
+	.type = BPF_MAP_TYPE_INODE,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u64),
+	.max_entries = MAP_MAX_ENTRIES,
+	.map_flags = BPF_F_RDONLY_PROG,
+};
+
+static __always_inline __u64 get_access(void *inode)
+{
+	u64 *flags;
+
+	flags = bpf_inode_map_lookup_elem(&inode_map, inode);
+	if (flags && (*flags & MAP_FLAG_DENY))
+		return LANDLOCK_RET_DENY;
+	return LANDLOCK_RET_ALLOW;
+}
+
+SEC("landlock/fs_walk")
+int fs_walk(struct landlock_ctx_fs_walk *ctx)
+{
+	return get_access((void *)ctx->inode);
+}
+
+SEC("landlock/fs_pick")
+int fs_pick_ro(struct landlock_ctx_fs_pick *ctx)
+{
+	return get_access((void *)ctx->inode);
+}
+
+static const char SEC("license") _license[] = "GPL";
diff --git a/samples/bpf/landlock1_user.c b/samples/bpf/landlock1_user.c
new file mode 100644
index 000000000000..2082ca367f94
--- /dev/null
+++ b/samples/bpf/landlock1_user.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock sample 1 - deny access to a set of directories (blacklisting)
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ */
+
+#include "bpf/libbpf.h"
+#include "bpf_load.h"
+#include "landlock1.h" /* MAP_FLAG_DENY */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h> /* open() */
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/landlock.h>
+#include <linux/prctl.h>
+#include <linux/seccomp.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#ifndef seccomp
+static int seccomp(unsigned int op, unsigned int flags, void *args)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, args);
+}
+#endif
+
+static int apply_sandbox(int prog_fd)
+{
+	int ret = 0;
+
+	/* set up the test sandbox */
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		perror("prctl(no_new_priv)");
+		return 1;
+	}
+	if (seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog_fd)) {
+		perror("seccomp(set_hook)");
+		ret = 1;
+	}
+	close(prog_fd);
+
+	return ret;
+}
+
+#define ENV_FS_PATH_DENY_NAME "LL_PATH_DENY"
+#define ENV_PATH_TOKEN ":"
+
+static int parse_path(char *env_path, const char ***path_list)
+{
+	int i, path_nb = 0;
+
+	if (env_path) {
+		path_nb++;
+		for (i = 0; env_path[i]; i++) {
+			if (env_path[i] == ENV_PATH_TOKEN[0])
+				path_nb++;
+		}
+	}
+	*path_list = malloc(path_nb * sizeof(**path_list));
+	for (i = 0; i < path_nb; i++)
+		(*path_list)[i] = strsep(&env_path, ENV_PATH_TOKEN);
+
+	return path_nb;
+}
+
+static int populate_map(const char *env_var, unsigned long long value,
+		int map_fd)
+{
+	int path_nb, ref_fd, i;
+	char *env_path_name;
+	const char **path_list = NULL;
+
+	env_path_name = getenv(env_var);
+	if (!env_path_name)
+		return 0;
+	env_path_name = strdup(env_path_name);
+	path_nb = parse_path(env_path_name, &path_list);
+
+	for (i = 0; i < path_nb; i++) {
+		ref_fd = open(path_list[i], O_RDONLY | O_CLOEXEC);
+		if (ref_fd < 0) {
+			fprintf(stderr, "Failed to open \"%s\": %s\n",
+					path_list[i],
+					strerror(errno));
+			return 1;
+		}
+		if (bpf_map_update_elem(map_fd, &ref_fd, &value, BPF_ANY)) {
+			fprintf(stderr, "Failed to update the map with"
+					" \"%s\": %s\n", path_list[i],
+					strerror(errno));
+			return 1;
+		}
+		close(ref_fd);
+	}
+	free(env_path_name);
+	return 0;
+}
+
+/* need to call bpf_object__close(obj) once every FD is used */
+static int ll_load_file(const char *filename, struct bpf_object **obj,
+		int *ll_map, int *ll_prog_walk, int *ll_prog_pick)
+{
+	int first_bpf_prog, map_fd, prog_walk_fd, prog_pick_fd, err;
+	struct bpf_map *map;
+	struct bpf_program *prog;
+	struct bpf_object *tmp_obj;
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type = BPF_PROG_TYPE_UNSPEC,
+		.file = filename,
+	};
+
+	/*
+	 * allowed:
+	 * - LANDLOCK_TRIGGER_FS_PICK_LINK
+	 * - LANDLOCK_TRIGGER_FS_PICK_LINKTO
+	 * - LANDLOCK_TRIGGER_FS_PICK_RECEIVE
+	 * - LANDLOCK_TRIGGER_FS_PICK_MOUNTON
+	 */
+	prog_load_attr.expected_attach_triggers =
+		LANDLOCK_TRIGGER_FS_PICK_APPEND |
+		LANDLOCK_TRIGGER_FS_PICK_CHDIR |
+		LANDLOCK_TRIGGER_FS_PICK_CHROOT |
+		LANDLOCK_TRIGGER_FS_PICK_CREATE |
+		LANDLOCK_TRIGGER_FS_PICK_EXECUTE |
+		LANDLOCK_TRIGGER_FS_PICK_FCNTL |
+		LANDLOCK_TRIGGER_FS_PICK_GETATTR |
+		LANDLOCK_TRIGGER_FS_PICK_IOCTL |
+		LANDLOCK_TRIGGER_FS_PICK_LOCK |
+		LANDLOCK_TRIGGER_FS_PICK_MAP |
+		LANDLOCK_TRIGGER_FS_PICK_OPEN |
+		LANDLOCK_TRIGGER_FS_PICK_READ |
+		LANDLOCK_TRIGGER_FS_PICK_READDIR |
+		LANDLOCK_TRIGGER_FS_PICK_RENAME |
+		LANDLOCK_TRIGGER_FS_PICK_RENAMETO |
+		LANDLOCK_TRIGGER_FS_PICK_RMDIR |
+		LANDLOCK_TRIGGER_FS_PICK_SETATTR |
+		LANDLOCK_TRIGGER_FS_PICK_TRANSFER |
+		LANDLOCK_TRIGGER_FS_PICK_UNLINK |
+		LANDLOCK_TRIGGER_FS_PICK_WRITE;
+
+	if (access(filename, O_RDONLY) < 0) {
+		printf("Failed to access file %s: %s\n", filename,
+				strerror(errno));
+		return 1;
+	}
+	err = bpf_prog_load_xattr(&prog_load_attr, &tmp_obj, &first_bpf_prog);
+	if (err) {
+		printf("Failed to parse file %s: %s\n", filename, strerror(err));
+		goto error_load;
+	}
+
+	map = bpf_object__find_map_by_name(tmp_obj, "inode_map");
+	map_fd = bpf_map__fd(map);
+	if (map_fd < 0) {
+		printf("Map not found: %s\n", strerror(map_fd));
+		goto put_obj;
+	}
+
+	prog = bpf_object__find_program_by_title(tmp_obj, "landlock/fs_walk");
+	if (!prog) {
+		printf("Program for FS_WALK not found in file %s\n", filename);
+		goto put_obj;
+	}
+	prog_walk_fd = bpf_program__fd(prog);
+	if (prog_walk_fd < 0) {
+		printf("Failed to load the FS_WALK program from file %s\n",
+				strerror(prog_walk_fd));
+		goto put_obj;
+	}
+
+	prog = bpf_object__find_program_by_title(tmp_obj, "landlock/fs_pick");
+	if (!prog) {
+		printf("Failed to get a file descriptor for program %s from file %s\n",
+				bpf_program__title(prog, false), filename);
+		goto put_obj;
+	}
+	prog_pick_fd = bpf_program__fd(prog);
+	if (prog_pick_fd < 0) {
+		printf("Failed to get a file descriptor for program %s from file %s\n",
+				bpf_program__title(prog, false), filename);
+		goto put_obj;
+	}
+
+	*obj = tmp_obj;
+	*ll_prog_walk = prog_walk_fd;
+	*ll_prog_pick = prog_pick_fd;
+	*ll_map = map_fd;
+	return 0;
+
+put_obj:
+	/* All FDs are closed with bpf_object__close() */
+	bpf_object__close(tmp_obj);
+error_load:
+	printf("ERROR: load_bpf_file failed for: %s\n", filename);
+	printf("  Output from verifier:\n%s\n------\n", bpf_log_buf);
+	return 1;
+}
+
+int main(int argc, char * const argv[], char * const *envp)
+{
+	char filename[256];
+	char *cmd_path;
+	char * const *cmd_argv;
+	struct bpf_object *obj;
+	int ll_map, ll_prog_walk, ll_prog_pick;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <cmd> [args]...\n\n", argv[0]);
+		fprintf(stderr, "Launch a command in a restricted environment.\n\n");
+		fprintf(stderr, "Environment variables containing paths, each separated by a colon:\n");
+		fprintf(stderr, "* %s: list of files and directories which are denied\n",
+				ENV_FS_PATH_DENY_NAME);
+		fprintf(stderr, "\nexample:\n"
+				"%s=\"${HOME}/.ssh:${HOME}/Images\" "
+				"%s /bin/sh -i\n",
+				ENV_FS_PATH_DENY_NAME, argv[0]);
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	if (ll_load_file(filename, &obj, &ll_map, &ll_prog_walk, &ll_prog_pick))
+		return 1;
+
+	if (populate_map(ENV_FS_PATH_DENY_NAME, MAP_FLAG_DENY, ll_map))
+		return 1;
+	//close(ll_map);
+
+	fprintf(stderr, "Launching a new sandboxed process\n");
+	if (apply_sandbox(ll_prog_walk))
+		return 1;
+	//close(ll_prog_walk);
+	if (apply_sandbox(ll_prog_pick))
+		return 1;
+	//close(ll_prog_pick);
+	//bpf_object__close(obj);
+	cmd_path = argv[1];
+	cmd_argv = argv + 1;
+	execve(cmd_path, cmd_argv, envp);
+	perror("Failed to call execve");
+	return 1;
+}
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ab3b8b510b8a..f043e97bca0c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -181,6 +181,7 @@ struct bpf_program {
 	bpf_program_clear_priv_t clear_priv;
 
 	enum bpf_attach_type expected_attach_type;
+	__u64 expected_attach_triggers;
 	int btf_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
@@ -2459,6 +2460,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type = prog->type;
 	load_attr.expected_attach_type = prog->expected_attach_type;
+	load_attr.expected_attach_triggers = prog->expected_attach_triggers;
 	if (prog->caps->name)
 		load_attr.name = prog->name;
 	load_attr.insns = insns;
@@ -3540,19 +3542,29 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
 	prog->expected_attach_type = type;
 }
 
-#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, atype) \
-	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, atype }
+void bpf_program__set_expected_attach_triggers(struct bpf_program *prog,
+					       __u64 triggers)
+{
+	prog->expected_attach_triggers = triggers;
+}
+
+#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, atype, has_triggers) \
+	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, atype, has_triggers }
 
 /* Programs that can NOT be attached. */
-#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0)
+#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, false)
 
 /* Programs that can be attached. */
 #define BPF_APROG_SEC(string, ptype, atype) \
-	BPF_PROG_SEC_IMPL(string, ptype, 0, 1, atype)
+	BPF_PROG_SEC_IMPL(string, ptype, 0, 1, atype, false)
 
 /* Programs that must specify expected attach type at load time. */
 #define BPF_EAPROG_SEC(string, ptype, eatype) \
-	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, eatype)
+	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, eatype, false)
+
+/* Programs that must specify expected attach type at load time and has triggers. */
+#define BPF_TEAPROG_SEC(string, ptype, eatype) \
+	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, eatype, true)
 
 /* Programs that can be attached but attach type can't be identified by section
  * name. Kept for backward compatibility.
@@ -3566,6 +3578,7 @@ static const struct {
 	enum bpf_attach_type expected_attach_type;
 	int is_attachable;
 	enum bpf_attach_type attach_type;
+	bool has_triggers;
 } section_names[] = {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
 	BPF_PROG_SEC("kprobe/",			BPF_PROG_TYPE_KPROBE),
@@ -3628,6 +3641,10 @@ static const struct {
 						BPF_CGROUP_GETSOCKOPT),
 	BPF_EAPROG_SEC("cgroup/setsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 						BPF_CGROUP_SETSOCKOPT),
+	BPF_EAPROG_SEC("landlock/fs_walk",	BPF_PROG_TYPE_LANDLOCK_HOOK,
+						BPF_LANDLOCK_FS_WALK),
+	BPF_TEAPROG_SEC("landlock/fs_pick",	BPF_PROG_TYPE_LANDLOCK_HOOK,
+						BPF_LANDLOCK_FS_PICK),
 };
 
 #undef BPF_PROG_SEC_IMPL
@@ -3665,7 +3682,8 @@ static char *libbpf_get_type_names(bool attach_type)
 }
 
 int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
-			     enum bpf_attach_type *expected_attach_type)
+			     enum bpf_attach_type *expected_attach_type,
+			     bool *has_triggers)
 {
 	char *type_names;
 	int i;
@@ -3678,6 +3696,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			continue;
 		*prog_type = section_names[i].prog_type;
 		*expected_attach_type = section_names[i].expected_attach_type;
+		*has_triggers = section_names[i].has_triggers;
 		return 0;
 	}
 	pr_warning("failed to guess program type based on ELF section name '%s'\n", name);
@@ -3720,10 +3739,11 @@ int libbpf_attach_type_by_name(const char *name,
 static int
 bpf_program__identify_section(struct bpf_program *prog,
 			      enum bpf_prog_type *prog_type,
-			      enum bpf_attach_type *expected_attach_type)
+			      enum bpf_attach_type *expected_attach_type,
+			      bool *has_triggers)
 {
 	return libbpf_prog_type_by_name(prog->section_name, prog_type,
-					expected_attach_type);
+					expected_attach_type, has_triggers);
 }
 
 int bpf_map__fd(const struct bpf_map *map)
@@ -3898,6 +3918,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	struct bpf_object *obj;
 	struct bpf_map *map;
 	int err;
+	bool has_triggers = false;
 
 	if (!attr)
 		return -EINVAL;
@@ -3921,7 +3942,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 		expected_attach_type = attr->expected_attach_type;
 		if (prog_type == BPF_PROG_TYPE_UNSPEC) {
 			err = bpf_program__identify_section(prog, &prog_type,
-							    &expected_attach_type);
+							    &expected_attach_type,
+							    &has_triggers);
 			if (err < 0) {
 				bpf_object__close(obj);
 				return -EINVAL;
@@ -3931,6 +3953,9 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog,
 						      expected_attach_type);
+		if (has_triggers)
+			bpf_program__set_expected_attach_triggers(prog,
+					attr->expected_attach_triggers);
 
 		prog->log_level = attr->log_level;
 		prog->prog_flags = attr->prog_flags;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5cbf459ece0b..07e153cebd5d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -123,7 +123,8 @@ LIBBPF_API void *bpf_object__priv(const struct bpf_object *prog);
 
 LIBBPF_API int
 libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
-			 enum bpf_attach_type *expected_attach_type);
+			 enum bpf_attach_type *expected_attach_type,
+			 bool *has_triggers);
 LIBBPF_API int libbpf_attach_type_by_name(const char *name,
 					  enum bpf_attach_type *attach_type);
 
@@ -266,6 +267,9 @@ LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
 LIBBPF_API void
 bpf_program__set_expected_attach_type(struct bpf_program *prog,
 				      enum bpf_attach_type type);
+LIBBPF_API void
+bpf_program__set_expected_attach_triggers(struct bpf_program *prog,
+					  __u64 triggers);
 
 LIBBPF_API bool bpf_program__is_socket_filter(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program *prog);
@@ -345,6 +349,7 @@ struct bpf_prog_load_attr {
 	const char *file;
 	enum bpf_prog_type prog_type;
 	enum bpf_attach_type expected_attach_type;
+	__u64 expected_attach_triggers;
 	int ifindex;
 	int log_level;
 	int prog_flags;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 36ac26bdfda0..4eb930bfc1d8 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -83,6 +83,7 @@ LIBBPF_0.0.1 {
 		bpf_program__prev;
 		bpf_program__priv;
 		bpf_program__set_expected_attach_type;
+		bpf_program__set_expected_attach_triggers;
 		bpf_program__set_ifindex;
 		bpf_program__set_kprobe;
 		bpf_program__set_perf_event;
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 5a3d92c8bec8..db2a84a88f5c 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -228,6 +228,8 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
 static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
+static void *(*bpf_inode_map_lookup_elem)(void *map, const void *key) =
+	(void *) BPF_FUNC_inode_map_lookup_elem;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/test_section_names.c b/tools/testing/selftests/bpf/test_section_names.c
index 29833aeaf0de..2d08df9156bd 100644
--- a/tools/testing/selftests/bpf/test_section_names.c
+++ b/tools/testing/selftests/bpf/test_section_names.c
@@ -153,7 +153,7 @@ static int test_prog_type_by_name(const struct sec_name_test *test)
 	int rc;
 
 	rc = libbpf_prog_type_by_name(test->sec_name, &prog_type,
-				      &expected_attach_type);
+				      &expected_attach_type, false);
 
 	if (rc != test->expected_load.rc) {
 		warnx("prog: unexpected rc=%d for %s", rc, test->sec_name);
diff --git a/tools/testing/selftests/bpf/test_sockopt_multi.c b/tools/testing/selftests/bpf/test_sockopt_multi.c
index 4be3441db867..e499c91f2953 100644
--- a/tools/testing/selftests/bpf/test_sockopt_multi.c
+++ b/tools/testing/selftests/bpf/test_sockopt_multi.c
@@ -23,7 +23,7 @@ static int prog_attach(struct bpf_object *obj, int cgroup_fd, const char *title)
 	struct bpf_program *prog;
 	int err;
 
-	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type);
+	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type, false);
 	if (err) {
 		log_err("Failed to deduct types for %s BPF program", title);
 		return -1;
@@ -52,7 +52,7 @@ static int prog_detach(struct bpf_object *obj, int cgroup_fd, const char *title)
 	struct bpf_program *prog;
 	int err;
 
-	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type);
+	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type, false);
 	if (err)
 		return -1;
 
diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testing/selftests/bpf/test_sockopt_sk.c
index 036b652e5ca9..2d1ff616b139 100644
--- a/tools/testing/selftests/bpf/test_sockopt_sk.c
+++ b/tools/testing/selftests/bpf/test_sockopt_sk.c
@@ -129,7 +129,7 @@ static int prog_attach(struct bpf_object *obj, int cgroup_fd, const char *title)
 	struct bpf_program *prog;
 	int err;
 
-	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type);
+	err = libbpf_prog_type_by_name(title, &prog_type, &attach_type, false);
 	if (err) {
 		log_err("Failed to deduct types for %s BPF program", title);
 		return -1;
-- 
2.22.0

