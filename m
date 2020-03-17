Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB7418777E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgCQBdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:33:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26686 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgCQBdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 21:33:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H1E8o0032295
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 18:33:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=D3z2XLCH3QlQ8zXBAzxCR1+8Oa63KPaCbltInxcctBs=;
 b=XZZZ74W4EunMa213qBujoq+zavM7WjHIDwCRyCzNa6LnOVYZu47uyykbvUE9SE0/L7Rd
 qFKx4saUZjz7iMKjfE2wYfAWHtHyxAlg2KVhw8wVxUaNhBefG76OjdfYcIOdmuPhZRld
 D9dL1Wod7aH61wwOGgexFO8rJrAE1YcENaQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yrw0ptdqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 18:33:10 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 18:33:09 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DDCF42942D82; Mon, 16 Mar 2020 18:33:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/4] bpftool: Add struct_ops support
Date:   Mon, 16 Mar 2020 18:33:04 -0700
Message-ID: <20200317013304.4067216-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317013239.4066168-1-kafai@fb.com>
References: <20200317013239.4066168-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_11:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=43 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds struct_ops support to the bpftool.

To recap a bit on the recent bpf_struct_ops feature on the kernel side:
It currently supports "struct tcp_congestion_ops" to be implemented
in bpf.  At a high level, bpf_struct_ops is struct_ops map populated
with a number of bpf progs.  bpf_struct_ops currently supports the
"struct tcp_congestion_ops".  However, the bpf_struct_ops design is
generic enough that other kernel struct ops can be supported in
the future.

Although struct_ops is map+progs at a high lever, there are differences
in details.  For example,
1) After registering a struct_ops, the struct_ops is held by the kernel
   subsystem (e.g. tcp-cc).  Thus, there is no need to pin a
   struct_ops map or its progs in order to keep them around.
2) To iterate all struct_ops in a system, it iterates all maps
   in type BPF_MAP_TYPE_STRUCT_OPS.  BPF_MAP_TYPE_STRUCT_OPS is
   the current usual filter.  In the future, it may need to
   filter by other struct_ops specific properties.  e.g. filter by
   tcp_congestion_ops or other kernel subsystem ops in the future.
3) struct_ops requires the running kernel having BTF info.  That allows
   more flexibility in handling other kernel structs.  e.g. it can
   always dump the latest bpf_map_info.
4) Also, "struct_ops" command is not intended to repeat all features
   already provided by "map" or "prog".  For example, if there really
   is a need to pin the struct_ops map, the user can use the "map" cmd
   to do that.

While the first attempt was to reuse parts from map/prog.c,  it ended up
not a lot to share.  The only obvious item is the map_parse_fds() but
that still requires modifications to accommodate struct_ops map specific
filtering (for the immediate and the future needs).  Together with the
earlier mentioned differences, it is better to part away from map/prog.c.

The initial set of subcmds are, register, unregister, show, and dump.

For register, it registers all struct_ops maps that can be found in an
obj file.  Option can be added in the future to specify a particular
struct_ops map.  Also, the common bpf_tcp_cc is stateless (e.g.
bpf_cubic.c and bpf_dctcp.c).  The "reuse map" feature is not
implemented in this patch and it can be considered later also.

For other subcmds, please see the man doc for details.

A sample output of dump:
[root@arch-fb-vm1 bpf]# bpftool struct_ops dump name cubic
[{
        "bpf_map_info": {
            "type": 26,
            "id": 64,
            "key_size": 4,
            "value_size": 256,
            "max_entries": 1,
            "map_flags": 0,
            "name": "cubic",
            "ifindex": 0,
            "btf_vmlinux_value_type_id": 18452,
            "netns_dev": 0,
            "netns_ino": 0,
            "btf_id": 52,
            "btf_key_type_id": 0,
            "btf_value_type_id": 0
        }
    },{
        "bpf_struct_ops_tcp_congestion_ops": {
            "refcnt": {
                "refs": {
                    "counter": 1
                }
            },
            "state": "BPF_STRUCT_OPS_STATE_INUSE",
            "data": {
                "list": {
                    "next": 0,
                    "prev": 0
                },
                "key": 0,
                "flags": 0,
                "init": "void (struct sock *) bictcp_init/prog_id:138",
                "release": "void (struct sock *) 0",
                "ssthresh": "u32 (struct sock *) bictcp_recalc_ssthresh/prog_id:141",
                "cong_avoid": "void (struct sock *, u32, u32) bictcp_cong_avoid/prog_id:140",
                "set_state": "void (struct sock *, u8) bictcp_state/prog_id:142",
                "cwnd_event": "void (struct sock *, enum tcp_ca_event) bictcp_cwnd_event/prog_id:139",
                "in_ack_event": "void (struct sock *, u32) 0",
                "undo_cwnd": "u32 (struct sock *) tcp_reno_undo_cwnd/prog_id:144",
                "pkts_acked": "void (struct sock *, const struct ack_sample *) bictcp_acked/prog_id:143",
                "min_tso_segs": "u32 (struct sock *) 0",
                "sndbuf_expand": "u32 (struct sock *) 0",
                "cong_control": "void (struct sock *, const struct rate_sample *) 0",
                "get_info": "size_t (struct sock *, u32, int *, union tcp_cc_info *) 0",
                "name": "bpf_cubic",
                "owner": 0
            }
        }
    }
]

Acked-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../Documentation/bpftool-struct_ops.rst      | 116 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  28 +
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/struct_ops.c                | 596 ++++++++++++++++++
 5 files changed, 743 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
 create mode 100644 tools/bpf/bpftool/struct_ops.c

diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
new file mode 100644
index 000000000000..f045cc89dd6d
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -0,0 +1,116 @@
+==================
+bpftool-struct_ops
+==================
+-------------------------------------------------------------------------------
+tool to register/unregister/introspect BPF struct_ops
+-------------------------------------------------------------------------------
+
+:Manual section: 8
+
+SYNOPSIS
+========
+
+	**bpftool** [*OPTIONS*] **struct_ops** *COMMAND*
+
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+
+	*COMMANDS* :=
+	{ **show** | **list** | **dump** | **register** | **unregister** | **help** }
+
+STRUCT_OPS COMMANDS
+===================
+
+|	**bpftool** **struct_ops { show | list }** [*STRUCT_OPS_MAP*]
+|	**bpftool** **struct_ops dump** [*STRUCT_OPS_MAP*]
+|	**bpftool** **struct_ops register** *OBJ*
+|	**bpftool** **struct_ops unregister** *STRUCT_OPS_MAP*
+|	**bpftool** **struct_ops help**
+|
+|	*STRUCT_OPS_MAP* := { **id** *STRUCT_OPS_MAP_ID* | **name** *STRUCT_OPS_MAP_NAME* }
+|	*OBJ* := /a/file/of/bpf_struct_ops.o
+
+
+DESCRIPTION
+===========
+	**bpftool struct_ops { show | list }** [*STRUCT_OPS_MAP*]
+		  Show brief information about the struct_ops in the system.
+		  If *STRUCT_OPS_MAP* is specified, it shows information only
+		  for the given struct_ops.  Otherwise, it lists all struct_ops
+		  currently existing in the system.
+
+		  Output will start with struct_ops map ID, followed by its map
+		  name and its struct_ops's kernel type.
+
+	**bpftool struct_ops dump** [*STRUCT_OPS_MAP*]
+		  Dump details information about the struct_ops in the system.
+		  If *STRUCT_OPS_MAP* is specified, it dumps information only
+		  for the given struct_ops.  Otherwise, it dumps all struct_ops
+		  currently existing in the system.
+
+	**bpftool struct_ops register** *OBJ*
+		  Register bpf struct_ops from *OBJ*.  All struct_ops under
+		  the ELF section ".struct_ops" will be registered to
+		  its kernel subsystem.
+
+	**bpftool struct_ops unregister**  *STRUCT_OPS_MAP*
+		  Unregister the *STRUCT_OPS_MAP* from the kernel subsystem.
+
+	**bpftool struct_ops help**
+		  Print short help message.
+
+OPTIONS
+=======
+	-h, --help
+		  Print short generic help message (similar to **bpftool help**).
+
+	-V, --version
+		  Print version number (similar to **bpftool version**).
+
+	-j, --json
+		  Generate JSON output. For commands that cannot produce JSON, this
+		  option has no effect.
+
+	-p, --pretty
+		  Generate human-readable JSON output. Implies **-j**.
+
+	-d, --debug
+		  Print all logs available, even debug-level information. This
+		  includes logs from libbpf as well as from the verifier, when
+		  attempting to load programs.
+
+EXAMPLES
+========
+**# bpftool struct_ops show**
+
+::
+
+    100: dctcp           tcp_congestion_ops
+    105: cubic           tcp_congestion_ops
+
+**# bpftool struct_ops unregister id 105**
+
+::
+
+   Unregistered tcp_congestion_ops cubic id 105
+
+**# bpftool struct_ops register bpf_cubic.o**
+
+::
+
+   Registered tcp_congestion_ops cubic id 110
+
+
+SEE ALSO
+========
+	**bpf**\ (2),
+	**bpf-helpers**\ (7),
+	**bpftool**\ (8),
+	**bpftool-prog**\ (8),
+	**bpftool-map**\ (8),
+	**bpftool-cgroup**\ (8),
+	**bpftool-feature**\ (8),
+	**bpftool-net**\ (8),
+	**bpftool-perf**\ (8),
+	**bpftool-btf**\ (8)
+	**bpftool-gen**\ (8)
+	
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 9b0534f558f1..45ee99b159e2 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -576,6 +576,34 @@ _bpftool()
                     ;;
             esac
             ;;
+        struct_ops)
+            local STRUCT_OPS_TYPE='id name'
+            case $command in
+                show|list|dump|unregister)
+                    case $prev in
+                        $command)
+                            COMPREPLY=( $( compgen -W "$STRUCT_OPS_TYPE" -- "$cur" ) )
+                            ;;
+                        id)
+                            _bpftool_get_map_ids_for_type struct_ops
+                            ;;
+                        name)
+                            _bpftool_get_map_names_for_type struct_ops
+                            ;;
+                    esac
+                    return 0
+                    ;;
+                register)
+                    _filedir
+                    return 0
+                    ;;
+                *)
+                    [[ $prev == $object ]] && \
+                        COMPREPLY=( $( compgen -W 'register unregister show list dump help' \
+                            -- "$cur" ) )
+                    ;;
+            esac
+            ;;
         map)
             local MAP_TYPE='id pinned name'
             case $command in
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 06449e846e4b..466c269eabdd 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen }\n"
+		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen | struct_ops }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
@@ -221,6 +221,7 @@ static const struct cmd cmds[] = {
 	{ "feature",	do_feature },
 	{ "btf",	do_btf },
 	{ "gen",	do_gen },
+	{ "struct_ops",	do_struct_ops },
 	{ "version",	do_version },
 	{ 0 }
 };
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 6db2398ae7e9..86f14ce26fd7 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -161,6 +161,7 @@ int do_tracelog(int argc, char **arg);
 int do_feature(int argc, char **argv);
 int do_btf(int argc, char **argv);
 int do_gen(int argc, char **argv);
+int do_struct_ops(int argc, char **argv);
 
 int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
 int prog_parse_fd(int *argc, char ***argv);
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
new file mode 100644
index 000000000000..2a7befbd11ad
--- /dev/null
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -0,0 +1,596 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2020 Facebook */
+
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include <linux/err.h>
+
+#include <bpf/bpf.h>
+#include <bpf/btf.h>
+#include <bpf/libbpf.h>
+
+#include "json_writer.h"
+#include "main.h"
+
+#define STRUCT_OPS_VALUE_PREFIX "bpf_struct_ops_"
+
+static const struct btf_type *map_info_type;
+static __u32 map_info_alloc_len;
+static struct btf *btf_vmlinux;
+static __s32 map_info_type_id;
+
+struct res {
+	unsigned int nr_maps;
+	unsigned int nr_errs;
+};
+
+static const struct btf *get_btf_vmlinux(void)
+{
+	if (btf_vmlinux)
+		return btf_vmlinux;
+
+	btf_vmlinux = libbpf_find_kernel_btf();
+	if (IS_ERR(btf_vmlinux))
+		p_err("struct_ops requires kernel CONFIG_DEBUG_INFO_BTF=y");
+
+	return btf_vmlinux;
+}
+
+static const char *get_kern_struct_ops_name(const struct bpf_map_info *info)
+{
+	const struct btf *kern_btf;
+	const struct btf_type *t;
+	const char *st_ops_name;
+
+	kern_btf = get_btf_vmlinux();
+	if (IS_ERR(kern_btf))
+		return "<btf_vmlinux_not_found>";
+
+	t = btf__type_by_id(kern_btf, info->btf_vmlinux_value_type_id);
+	st_ops_name = btf__name_by_offset(kern_btf, t->name_off);
+	st_ops_name += strlen(STRUCT_OPS_VALUE_PREFIX);
+
+	return st_ops_name;
+}
+
+static __s32 get_map_info_type_id(void)
+{
+	const struct btf *kern_btf;
+
+	if (map_info_type_id)
+		return map_info_type_id;
+
+	kern_btf = get_btf_vmlinux();
+	if (IS_ERR(kern_btf)) {
+		map_info_type_id = PTR_ERR(kern_btf);
+		return map_info_type_id;
+	}
+
+	map_info_type_id = btf__find_by_name_kind(kern_btf, "bpf_map_info",
+						  BTF_KIND_STRUCT);
+	if (map_info_type_id < 0) {
+		p_err("can't find bpf_map_info from btf_vmlinux");
+		return map_info_type_id;
+	}
+	map_info_type = btf__type_by_id(kern_btf, map_info_type_id);
+
+	/* Ensure map_info_alloc() has at least what the bpftool needs */
+	map_info_alloc_len = map_info_type->size;
+	if (map_info_alloc_len < sizeof(struct bpf_map_info))
+		map_info_alloc_len = sizeof(struct bpf_map_info);
+
+	return map_info_type_id;
+}
+
+/* If the subcmd needs to print out the bpf_map_info,
+ * it should always call map_info_alloc to allocate
+ * a bpf_map_info object instead of allocating it
+ * on the stack.
+ *
+ * map_info_alloc() will take the running kernel's btf
+ * into account.  i.e. it will consider the
+ * sizeof(struct bpf_map_info) of the running kernel.
+ *
+ * It will enable the "struct_ops" cmd to print the latest
+ * "struct bpf_map_info".
+ *
+ * [ Recall that "struct_ops" requires the kernel's btf to
+ *   be available ]
+ */
+static struct bpf_map_info *map_info_alloc(__u32 *alloc_len)
+{
+	struct bpf_map_info *info;
+
+	if (get_map_info_type_id() < 0)
+		return NULL;
+
+	info = calloc(1, map_info_alloc_len);
+	if (!info)
+		p_err("mem alloc failed");
+	else
+		*alloc_len = map_info_alloc_len;
+
+	return info;
+}
+
+/* It iterates all struct_ops maps of the system.
+ * It returns the fd in "*res_fd" and map_info in "*info".
+ * In the very first iteration, info->id should be 0.
+ * An optional map "*name" filter can be specified.
+ * The filter can be made more flexible in the future.
+ * e.g. filter by kernel-struct-ops-name, regex-name, glob-name, ...etc.
+ *
+ * Return value:
+ *     1: A struct_ops map found.  It is returned in "*res_fd" and "*info".
+ *	  The caller can continue to call get_next in the future.
+ *     0: No struct_ops map is returned.
+ *        All struct_ops map has been found.
+ *    -1: Error and the caller should abort the iteration.
+ */
+static int get_next_struct_ops_map(const char *name, int *res_fd,
+				   struct bpf_map_info *info, __u32 info_len)
+{
+	__u32 id = info->id;
+	int err, fd;
+
+	while (true) {
+		err = bpf_map_get_next_id(id, &id);
+		if (err) {
+			if (errno == ENOENT)
+				return 0;
+			p_err("can't get next map: %s", strerror(errno));
+			return -1;
+		}
+
+		fd = bpf_map_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue;
+			p_err("can't get map by id (%u): %s",
+			      id, strerror(errno));
+			return -1;
+		}
+
+		err = bpf_obj_get_info_by_fd(fd, info, &info_len);
+		if (err) {
+			p_err("can't get map info: %s", strerror(errno));
+			close(fd);
+			return -1;
+		}
+
+		if (info->type == BPF_MAP_TYPE_STRUCT_OPS &&
+		    (!name || !strcmp(name, info->name))) {
+			*res_fd = fd;
+			return 1;
+		}
+		close(fd);
+	}
+}
+
+static int cmd_retval(const struct res *res, bool must_have_one_map)
+{
+	if (res->nr_errs || (!res->nr_maps && must_have_one_map))
+		return -1;
+
+	return 0;
+}
+
+/* "data" is the work_func private storage */
+typedef int (*work_func)(int fd, const struct bpf_map_info *info, void *data,
+			 struct json_writer *wtr);
+
+/* Find all struct_ops map in the system.
+ * Filter out by "name" (if specified).
+ * Then call "func(fd, info, data, wtr)" on each struct_ops map found.
+ */
+static struct res do_search(const char *name, work_func func, void *data,
+			    struct json_writer *wtr)
+{
+	struct bpf_map_info *info;
+	struct res res = {};
+	__u32 info_len;
+	int fd, err;
+
+	info = map_info_alloc(&info_len);
+	if (!info) {
+		res.nr_errs++;
+		return res;
+	}
+
+	if (wtr)
+		jsonw_start_array(wtr);
+	while ((err = get_next_struct_ops_map(name, &fd, info, info_len)) == 1) {
+		res.nr_maps++;
+		err = func(fd, info, data, wtr);
+		if (err)
+			res.nr_errs++;
+		close(fd);
+	}
+	if (wtr)
+		jsonw_end_array(wtr);
+
+	if (err)
+		res.nr_errs++;
+
+	if (!wtr && name && !res.nr_errs && !res.nr_maps)
+		/* It is not printing empty [].
+		 * Thus, needs to specifically say nothing found
+		 * for "name" here.
+		 */
+		p_err("no struct_ops found for %s", name);
+	else if (!wtr && json_output && !res.nr_errs)
+		/* The "func()" above is not writing any json (i.e. !wtr
+		 * test here).
+		 *
+		 * However, "-j" is enabled and there is no errs here,
+		 * so call json_null() as the current convention of
+		 * other cmds.
+		 */
+		jsonw_null(json_wtr);
+
+	free(info);
+	return res;
+}
+
+static struct res do_one_id(const char *id_str, work_func func, void *data,
+			    struct json_writer *wtr)
+{
+	struct bpf_map_info *info;
+	struct res res = {};
+	unsigned long id;
+	__u32 info_len;
+	char *endptr;
+	int fd;
+
+	id = strtoul(id_str, &endptr, 0);
+	if (*endptr || !id || id > UINT32_MAX) {
+		p_err("invalid id %s", id_str);
+		res.nr_errs++;
+		return res;
+	}
+
+	fd = bpf_map_get_fd_by_id(id);
+	if (fd == -1) {
+		p_err("can't get map by id (%lu): %s", id, strerror(errno));
+		res.nr_errs++;
+		return res;
+	}
+
+	info = map_info_alloc(&info_len);
+	if (!info) {
+		res.nr_errs++;
+		goto done;
+	}
+
+	if (bpf_obj_get_info_by_fd(fd, info, &info_len)) {
+		p_err("can't get map info: %s", strerror(errno));
+		res.nr_errs++;
+		goto done;
+	}
+
+	if (info->type != BPF_MAP_TYPE_STRUCT_OPS) {
+		p_err("%s id %u is not a struct_ops map", info->name, info->id);
+		res.nr_errs++;
+		goto done;
+	}
+
+	res.nr_maps++;
+
+	if (func(fd, info, data, wtr))
+		res.nr_errs++;
+	else if (!wtr && json_output)
+		/* The "func()" above is not writing any json (i.e. !wtr
+		 * test here).
+		 *
+		 * However, "-j" is enabled and there is no errs here,
+		 * so call json_null() as the current convention of
+		 * other cmds.
+		 */
+		jsonw_null(json_wtr);
+
+done:
+	free(info);
+	close(fd);
+
+	return res;
+}
+
+static struct res do_work_on_struct_ops(const char *search_type,
+					const char *search_term,
+					work_func func, void *data,
+					struct json_writer *wtr)
+{
+	if (search_type) {
+		if (is_prefix(search_type, "id"))
+			return do_one_id(search_term, func, data, wtr);
+		else if (!is_prefix(search_type, "name"))
+			usage();
+	}
+
+	return do_search(search_term, func, data, wtr);
+}
+
+static int __do_show(int fd, const struct bpf_map_info *info, void *data,
+		     struct json_writer *wtr)
+{
+	if (wtr) {
+		jsonw_start_object(wtr);
+		jsonw_uint_field(wtr, "id", info->id);
+		jsonw_string_field(wtr, "name", info->name);
+		jsonw_string_field(wtr, "kernel_struct_ops",
+				   get_kern_struct_ops_name(info));
+		jsonw_end_object(wtr);
+	} else {
+		printf("%u: %-15s %-32s\n", info->id, info->name,
+		       get_kern_struct_ops_name(info));
+	}
+
+	return 0;
+}
+
+static int do_show(int argc, char **argv)
+{
+	const char *search_type = NULL, *search_term = NULL;
+	struct res res;
+
+	if (argc && argc != 2)
+		usage();
+
+	if (argc == 2) {
+		search_type = GET_ARG();
+		search_term = GET_ARG();
+	}
+
+	res = do_work_on_struct_ops(search_type, search_term, __do_show,
+				    NULL, json_wtr);
+
+	return cmd_retval(&res, !!search_term);
+}
+
+static int __do_dump(int fd, const struct bpf_map_info *info, void *data,
+		     struct json_writer *wtr)
+{
+	struct btf_dumper *d = (struct btf_dumper *)data;
+	const struct btf_type *struct_ops_type;
+	const struct btf *kern_btf = d->btf;
+	const char *struct_ops_name;
+	int zero = 0;
+	void *value;
+
+	/* note: d->jw == wtr */
+
+	kern_btf = d->btf;
+
+	/* The kernel supporting BPF_MAP_TYPE_STRUCT_OPS must have
+	 * btf_vmlinux_value_type_id.
+	 */
+	struct_ops_type = btf__type_by_id(kern_btf,
+					  info->btf_vmlinux_value_type_id);
+	struct_ops_name = btf__name_by_offset(kern_btf,
+					      struct_ops_type->name_off);
+	value = calloc(1, info->value_size);
+	if (!value) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+
+	if (bpf_map_lookup_elem(fd, &zero, value)) {
+		p_err("can't lookup struct_ops map %s id %u",
+		      info->name, info->id);
+		free(value);
+		return -1;
+	}
+
+	jsonw_start_object(wtr);
+	jsonw_name(wtr, "bpf_map_info");
+	btf_dumper_type(d, map_info_type_id, (void *)info);
+	jsonw_end_object(wtr);
+
+	jsonw_start_object(wtr);
+	jsonw_name(wtr, struct_ops_name);
+	btf_dumper_type(d, info->btf_vmlinux_value_type_id, value);
+	jsonw_end_object(wtr);
+
+	free(value);
+
+	return 0;
+}
+
+static int do_dump(int argc, char **argv)
+{
+	const char *search_type = NULL, *search_term = NULL;
+	json_writer_t *wtr = json_wtr;
+	const struct btf *kern_btf;
+	struct btf_dumper d = {};
+	struct res res;
+
+	if (argc && argc != 2)
+		usage();
+
+	if (argc == 2) {
+		search_type = GET_ARG();
+		search_term = GET_ARG();
+	}
+
+	kern_btf = get_btf_vmlinux();
+	if (IS_ERR(kern_btf))
+		return -1;
+
+	if (!json_output) {
+		wtr = jsonw_new(stdout);
+		if (!wtr) {
+			p_err("can't create json writer");
+			return -1;
+		}
+		jsonw_pretty(wtr, true);
+	}
+
+	d.btf = kern_btf;
+	d.jw = wtr;
+	d.is_plain_text = !json_output;
+	d.prog_id_as_func_ptr = true;
+
+	res = do_work_on_struct_ops(search_type, search_term, __do_dump, &d,
+				    wtr);
+
+	if (!json_output)
+		jsonw_destroy(&wtr);
+
+	return cmd_retval(&res, !!search_term);
+}
+
+static int __do_unregister(int fd, const struct bpf_map_info *info, void *data,
+			   struct json_writer *wtr)
+{
+	int zero = 0;
+
+	if (bpf_map_delete_elem(fd, &zero)) {
+		p_err("can't unload %s %s id %u: %s",
+		      get_kern_struct_ops_name(info), info->name,
+		      info->id, strerror(errno));
+		return -1;
+	}
+
+	p_info("Unregistered %s %s id %u",
+	       get_kern_struct_ops_name(info), info->name,
+	       info->id);
+
+	return 0;
+}
+
+static int do_unregister(int argc, char **argv)
+{
+	const char *search_type, *search_term;
+	struct res res;
+
+	if (argc != 2)
+		usage();
+
+	search_type = GET_ARG();
+	search_term = GET_ARG();
+
+	res = do_work_on_struct_ops(search_type, search_term,
+				    __do_unregister, NULL, NULL);
+
+	return cmd_retval(&res, true);
+}
+
+static int do_register(int argc, char **argv)
+{
+	const struct bpf_map_def *def;
+	struct bpf_map_info info = {};
+	__u32 info_len = sizeof(info);
+	int nr_errs = 0, nr_maps = 0;
+	struct bpf_object *obj;
+	struct bpf_link *link;
+	struct bpf_map *map;
+	const char *file;
+
+	if (argc != 1)
+		usage();
+
+	file = GET_ARG();
+
+	obj = bpf_object__open(file);
+	if (IS_ERR_OR_NULL(obj))
+		return -1;
+
+	set_max_rlimit();
+
+	if (bpf_object__load(obj)) {
+		bpf_object__close(obj);
+		return -1;
+	}
+
+	bpf_object__for_each_map(map, obj) {
+		def = bpf_map__def(map);
+		if (def->type != BPF_MAP_TYPE_STRUCT_OPS)
+			continue;
+
+		link = bpf_map__attach_struct_ops(map);
+		if (IS_ERR(link)) {
+			p_err("can't register struct_ops %s: %s",
+			      bpf_map__name(map),
+			      strerror(-PTR_ERR(link)));
+			nr_errs++;
+			continue;
+		}
+		nr_maps++;
+
+		bpf_link__disconnect(link);
+		bpf_link__destroy(link);
+
+		if (!bpf_obj_get_info_by_fd(bpf_map__fd(map), &info,
+					    &info_len))
+			p_info("Registered %s %s id %u",
+			       get_kern_struct_ops_name(&info),
+			       bpf_map__name(map),
+			       info.id);
+		else
+			/* Not p_err.  The struct_ops was attached
+			 * successfully.
+			 */
+			p_info("Registered %s but can't find id: %s",
+			       bpf_map__name(map), strerror(errno));
+	}
+
+	bpf_object__close(obj);
+
+	if (nr_errs)
+		return -1;
+
+	if (!nr_maps) {
+		p_err("no struct_ops found in %s", file);
+		return -1;
+	}
+
+	if (json_output)
+		jsonw_null(json_wtr);
+
+	return 0;
+}
+
+static int do_help(int argc, char **argv)
+{
+	if (json_output) {
+		jsonw_null(json_wtr);
+		return 0;
+	}
+
+	fprintf(stderr,
+		"Usage: %s %s { show | list } [STRUCT_OPS_MAP]\n"
+		"       %s %s dump [STRUCT_OPS_MAP]\n"
+		"       %s %s register OBJ\n"
+		"       %s %s unregister STRUCT_OPS_MAP\n"
+		"       %s %s help\n"
+		"\n"
+		"       OPTIONS := { {-j|--json} [{-p|--pretty}] }\n"
+		"       STRUCT_OPS_MAP := [ id STRUCT_OPS_MAP_ID | name STRUCT_OPS_MAP_NAME ]\n",
+		bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
+
+	return 0;
+}
+
+static const struct cmd cmds[] = {
+	{ "show",	do_show },
+	{ "list",	do_show },
+	{ "register",	do_register },
+	{ "unregister",	do_unregister },
+	{ "dump",	do_dump },
+	{ "help",	do_help },
+	{ 0 }
+};
+
+int do_struct_ops(int argc, char **argv)
+{
+	int err;
+
+	err = cmd_select(cmds, argc, argv, do_help);
+
+	btf__free(btf_vmlinux);
+	return err;
+}
-- 
2.17.1

