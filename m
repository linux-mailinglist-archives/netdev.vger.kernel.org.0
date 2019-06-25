Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2651455A90
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfFYWEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:04:30 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:36296 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYWE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:04:29 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrPqj019890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:25 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrO5b038876;
        Tue, 25 Jun 2019 23:53:24 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>,
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
Subject: [PATCH bpf-next v9 08/10] bpf: Add a Landlock sandbox example
Date:   Tue, 25 Jun 2019 23:52:37 +0200
Message-Id: <20190625215239.11136-9-mic@digikod.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625215239.11136-1-mic@digikod.net>
References: <20190625215239.11136-1-mic@digikod.net>
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

Add to the bpf_load library the ability to handle a BPF program subtype.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

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
 samples/bpf/.gitignore       |   1 +
 samples/bpf/Makefile         |   3 +
 samples/bpf/bpf_load.c       |  76 ++++++++++++++++-
 samples/bpf/bpf_load.h       |   7 ++
 samples/bpf/landlock1.h      |   8 ++
 samples/bpf/landlock1_kern.c | 104 +++++++++++++++++++++++
 samples/bpf/landlock1_user.c | 157 +++++++++++++++++++++++++++++++++++
 7 files changed, 352 insertions(+), 4 deletions(-)
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
index 0917f8cf4fab..da246eaa8bf8 100644
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
@@ -168,6 +170,7 @@ always += task_fd_query_kern.o
 always += xdp_sample_pkts_kern.o
 always += ibumad_kern.o
 always += hbm_out_kern.o
+always += landlock1_kern.o
 
 KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 4574b1939e49..bf62d965f606 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/landlock.h>
 #include <linux/perf_event.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
@@ -42,6 +43,9 @@ int prog_array_fd = -1;
 struct bpf_map_data map_data[MAX_MAPS];
 int map_data_count;
 
+struct bpf_subtype_data subtype_data[MAX_PROGS];
+int subtype_data_count;
+
 static int populate_prog_array(const char *event, int prog_fd)
 {
 	int ind = atoi(event), err;
@@ -87,11 +91,15 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	bool is_sockops = strncmp(event, "sockops", 7) == 0;
 	bool is_sk_skb = strncmp(event, "sk_skb", 6) == 0;
 	bool is_sk_msg = strncmp(event, "sk_msg", 6) == 0;
+	bool is_landlock = strncmp(event, "landlock", 8) == 0;
 	size_t insns_cnt = size / sizeof(struct bpf_insn);
 	enum bpf_prog_type prog_type;
 	char buf[256];
 	int fd, efd, err, id;
 	struct perf_event_attr attr = {};
+	union bpf_prog_subtype *st = NULL;
+	struct bpf_subtype_data *sd = NULL;
+	struct bpf_load_program_attr load_attr;
 
 	attr.type = PERF_TYPE_TRACEPOINT;
 	attr.sample_type = PERF_SAMPLE_RAW;
@@ -120,6 +128,32 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 		prog_type = BPF_PROG_TYPE_SK_SKB;
 	} else if (is_sk_msg) {
 		prog_type = BPF_PROG_TYPE_SK_MSG;
+	} else if (is_landlock) {
+		int i, prog_id;
+		const char *event_id = (event + 8);
+
+		if (!isdigit(*event_id)) {
+			printf("invalid prog number\n");
+			return -1;
+		}
+		prog_id = atoi(event_id);
+		for (i = 0; i < subtype_data_count; i++) {
+			if (subtype_data[i].name && strcmp(event,
+						subtype_data[i].name) == 0) {
+				/* save the prog_id for a next program */
+				sd = &subtype_data[i];
+				sd->prog_id = prog_id;
+				st = &sd->subtype;
+				free(sd->name);
+				sd->name = NULL;
+				break;
+			}
+		}
+		if (!st) {
+			printf("missing subtype\n");
+			return -1;
+		}
+		prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK;
 	} else {
 		printf("Unknown event '%s'\n", event);
 		return -1;
@@ -128,16 +162,25 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	if (prog_cnt == MAX_PROGS)
 		return -1;
 
-	fd = bpf_load_program(prog_type, prog, insns_cnt, license, kern_version,
-			      bpf_log_buf, BPF_LOG_BUF_SIZE);
+	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
+	load_attr.prog_type = prog_type;
+	load_attr.prog_subtype = st;
+	load_attr.insns = prog;
+	load_attr.insns_cnt = insns_cnt;
+	load_attr.license = license;
+	load_attr.kern_version = kern_version;
+	fd = bpf_load_program_xattr(&load_attr, bpf_log_buf, BPF_LOG_BUF_SIZE);
 	if (fd < 0) {
 		printf("bpf_load_program() err=%d\n%s", errno, bpf_log_buf);
 		return -1;
 	}
+	if (sd)
+		sd->prog_fd = fd;
 
 	prog_fd[prog_cnt++] = fd;
 
-	if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk)
+	if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk ||
+	    is_landlock)
 		return 0;
 
 	if (is_socket || is_sockops || is_sk_skb || is_sk_msg) {
@@ -519,6 +562,7 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 	kern_version = 0;
 	memset(license, 0, sizeof(license));
 	memset(processed_sec, 0, sizeof(processed_sec));
+	subtype_data_count = 0;
 
 	if (elf_version(EV_CURRENT) == EV_NONE)
 		return 1;
@@ -567,6 +611,29 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 			data_maps = data;
 			for (j = 0; j < MAX_MAPS; j++)
 				map_data[j].fd = -1;
+		} else if (strncmp(shname, "subtype", 7) == 0) {
+			processed_sec[i] = true;
+			if (*(shname + 7) != '/') {
+				printf("invalid name of subtype section");
+				return 1;
+			}
+			if (data->d_size != sizeof(union bpf_prog_subtype)) {
+				printf("invalid size of subtype section: %zd\n",
+				       data->d_size);
+				printf("ref: %zd\n",
+				       sizeof(union bpf_prog_subtype));
+				return 1;
+			}
+			if (subtype_data_count >= MAX_PROGS) {
+				printf("too many subtype sections");
+				return 1;
+			}
+			memcpy(&subtype_data[subtype_data_count].subtype,
+					data->d_buf,
+					sizeof(union bpf_prog_subtype));
+			subtype_data[subtype_data_count].name =
+				strdup((shname + 8));
+			subtype_data_count++;
 		} else if (shdr.sh_type == SHT_SYMTAB) {
 			strtabidx = shdr.sh_link;
 			symbols = data;
@@ -643,7 +710,8 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 		    memcmp(shname, "cgroup/", 7) == 0 ||
 		    memcmp(shname, "sockops", 7) == 0 ||
 		    memcmp(shname, "sk_skb", 6) == 0 ||
-		    memcmp(shname, "sk_msg", 6) == 0) {
+		    memcmp(shname, "sk_msg", 6) == 0 ||
+		    memcmp(shname, "landlock", 8) == 0) {
 			ret = load_and_attach(shname, data->d_buf,
 					      data->d_size);
 			if (ret != 0)
diff --git a/samples/bpf/bpf_load.h b/samples/bpf/bpf_load.h
index 814894a12974..e210b5fdf8ee 100644
--- a/samples/bpf/bpf_load.h
+++ b/samples/bpf/bpf_load.h
@@ -24,6 +24,13 @@ struct bpf_map_data {
 	struct bpf_load_map_def def;
 };
 
+struct bpf_subtype_data {
+	char *name;
+	int prog_id;
+	int prog_fd;
+	union bpf_prog_subtype subtype;
+};
+
 typedef void (*fixup_map_cb)(struct bpf_map_data *map, int idx);
 
 extern int prog_fd[MAX_PROGS];
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
index 000000000000..0298d98dd06a
--- /dev/null
+++ b/samples/bpf/landlock1_kern.c
@@ -0,0 +1,104 @@
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
+ * (see landlock1_user.c) to extract eBPF bytecode and take into account
+ * variables describing the eBPF program subtype or its license.
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
+SEC("maps")
+struct bpf_map_def inode_map = {
+	.type = BPF_MAP_TYPE_INODE,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u64),
+	.max_entries = MAP_MAX_ENTRIES,
+};
+
+static __always_inline __u64 get_access(void *inode)
+{
+	if (bpf_inode_map_lookup(&inode_map, inode) & MAP_FLAG_DENY)
+		return LANDLOCK_RET_DENY;
+	return LANDLOCK_RET_ALLOW;
+}
+
+SEC("subtype/landlock1")
+static union bpf_prog_subtype _subtype1 = {
+	.landlock_hook = {
+		.type = LANDLOCK_HOOK_FS_WALK,
+	}
+};
+
+/*
+ * The function fs_walk() is a simple Landlock program enforced on a set of
+ * processes. This program will be run for each walk through a file path.
+ *
+ * The argument ctx contains the context of the program when it is run, which
+ * enable to evaluate the file path.  This context can change for each run of
+ * the program.
+ */
+SEC("landlock1")
+int fs_walk(struct landlock_ctx_fs_walk *ctx)
+{
+	return get_access((void *)ctx->inode);
+}
+
+SEC("subtype/landlock2")
+static union bpf_prog_subtype _subtype2 = {
+	.landlock_hook = {
+		.type = LANDLOCK_HOOK_FS_PICK,
+		/*
+		 * allowed:
+		 * - LANDLOCK_TRIGGER_FS_PICK_LINK
+		 * - LANDLOCK_TRIGGER_FS_PICK_LINKTO
+		 * - LANDLOCK_TRIGGER_FS_PICK_RECEIVE
+		 * - LANDLOCK_TRIGGER_FS_PICK_MOUNTON
+		 */
+		.triggers =
+			    LANDLOCK_TRIGGER_FS_PICK_APPEND |
+			    LANDLOCK_TRIGGER_FS_PICK_CHDIR |
+			    LANDLOCK_TRIGGER_FS_PICK_CHROOT |
+			    LANDLOCK_TRIGGER_FS_PICK_CREATE |
+			    LANDLOCK_TRIGGER_FS_PICK_EXECUTE |
+			    LANDLOCK_TRIGGER_FS_PICK_FCNTL |
+			    LANDLOCK_TRIGGER_FS_PICK_GETATTR |
+			    LANDLOCK_TRIGGER_FS_PICK_IOCTL |
+			    LANDLOCK_TRIGGER_FS_PICK_LOCK |
+			    LANDLOCK_TRIGGER_FS_PICK_MAP |
+			    LANDLOCK_TRIGGER_FS_PICK_OPEN |
+			    LANDLOCK_TRIGGER_FS_PICK_READ |
+			    LANDLOCK_TRIGGER_FS_PICK_READDIR |
+			    LANDLOCK_TRIGGER_FS_PICK_RENAME |
+			    LANDLOCK_TRIGGER_FS_PICK_RENAMETO |
+			    LANDLOCK_TRIGGER_FS_PICK_RMDIR |
+			    LANDLOCK_TRIGGER_FS_PICK_SETATTR |
+			    LANDLOCK_TRIGGER_FS_PICK_TRANSFER |
+			    LANDLOCK_TRIGGER_FS_PICK_UNLINK |
+			    LANDLOCK_TRIGGER_FS_PICK_WRITE,
+	}
+};
+
+SEC("landlock2")
+int fs_pick_ro(struct landlock_ctx_fs_pick *ctx)
+{
+	return get_access((void *)ctx->inode);
+}
+
+SEC("license")
+static const char _license[] = "GPL";
diff --git a/samples/bpf/landlock1_user.c b/samples/bpf/landlock1_user.c
new file mode 100644
index 000000000000..aa45932d36a8
--- /dev/null
+++ b/samples/bpf/landlock1_user.c
@@ -0,0 +1,157 @@
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
+int main(int argc, char * const argv[], char * const *envp)
+{
+	char filename[256];
+	char *cmd_path;
+	char * const *cmd_argv;
+	int ll_prog_walk, ll_prog_pick;
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
+	if (load_bpf_file(filename)) {
+		printf("%s", bpf_log_buf);
+		return 1;
+	}
+	ll_prog_walk = prog_fd[0]; /* fs_walk */
+	ll_prog_pick = prog_fd[1]; /* fs_pick */
+	if (!ll_prog_walk || !ll_prog_pick) {
+		if (errno)
+			printf("load_bpf_file: %s\n", strerror(errno));
+		else
+			printf("load_bpf_file: Error\n");
+		return 1;
+	}
+
+	if (populate_map(ENV_FS_PATH_DENY_NAME, MAP_FLAG_DENY, map_fd[0]))
+		return 1;
+	close(map_fd[0]);
+
+	fprintf(stderr, "Launching a new sandboxed process\n");
+	if (apply_sandbox(ll_prog_walk))
+		return 1;
+	if (apply_sandbox(ll_prog_pick))
+		return 1;
+	cmd_path = argv[1];
+	cmd_argv = argv + 1;
+	execve(cmd_path, cmd_argv, envp);
+	perror("Failed to call execve");
+	return 1;
+}
-- 
2.20.1

