Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D76A1C81B2
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEGFjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:39:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgEGFjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0475dk1K007958
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yaLG9Ih9YPJv9XlGxg+r7kgfGJErtmeLXdk1DWR6b38=;
 b=WiPBrzdIABtoBiQKqQQCqvgFzOhNzm8pJQdX8lcHZMrWe1yXKs4xRMmFG40EB0XoP+yj
 6YLCaykJ+rmMZ5YDkKL77ExiDZsTzRWY3p/YO9tdZYE65F65bmSVB70smN4xsOfST/s2
 KL+2bkXSvURUWQ8KBPUtZwESK63WZYfYVcI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30v0hp3gwd-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:50 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:37 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B73AC3701B99; Wed,  6 May 2020 22:39:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 18/21] tools/bpftool: add bpf_iter support for bptool
Date:   Wed, 6 May 2020 22:39:36 -0700
Message-ID: <20200507053936.1545284-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, only one command is supported
  bpftool iter pin <bpf_prog.o> <path>

It will pin the trace/iter bpf program in
the object file <bpf_prog.o> to the <path>
where <path> should be on a bpffs mount.

For example,
  $ bpftool iter pin ./bpf_iter_ipv6_route.o \
    /sys/fs/bpf/my_route
User can then do a `cat` to print out the results:
  $ cat /sys/fs/bpf/my_route
    fe800000000000000000000000000000 40 00000000000000000000000000000000 =
...
    00000000000000000000000000000000 00 00000000000000000000000000000000 =
...
    00000000000000000000000000000001 80 00000000000000000000000000000000 =
...
    fe800000000000008c0162fffebdfd57 80 00000000000000000000000000000000 =
...
    ff000000000000000000000000000000 08 00000000000000000000000000000000 =
...
    00000000000000000000000000000000 00 00000000000000000000000000000000 =
...

The implementation for ipv6_route iterator is in one of subsequent
patches.

This patch also added BPF_LINK_TYPE_ITER to link query.

In the future, we may add additional parameters to pin command
by parameterizing the bpf iterator. For example, a map_id or pid
may be added to let bpf program only traverses a single map or task,
similar to kernel seq_file single_open().

We may also add introspection command for targets/iterators by
leveraging the bpf_iter itself.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpftool/Documentation/bpftool-iter.rst    | 83 ++++++++++++++++++
 tools/bpf/bpftool/bash-completion/bpftool     | 13 +++
 tools/bpf/bpftool/iter.c                      | 84 +++++++++++++++++++
 tools/bpf/bpftool/link.c                      |  1 +
 tools/bpf/bpftool/main.c                      |  3 +-
 tools/bpf/bpftool/main.h                      |  1 +
 6 files changed, 184 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
 create mode 100644 tools/bpf/bpftool/iter.c

diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf=
/bpftool/Documentation/bpftool-iter.rst
new file mode 100644
index 000000000000..13b173d93890
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -0,0 +1,83 @@
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+bpftool-iter
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+------------------------------------------------------------------------=
-------
+tool to create BPF iterators
+------------------------------------------------------------------------=
-------
+
+:Manual section: 8
+
+SYNOPSIS
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+	**bpftool** [*OPTIONS*] **iter** *COMMAND*
+
+	*COMMANDS* :=3D { **pin** | **help** }
+
+ITER COMMANDS
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+|	**bpftool** **iter pin** *OBJ* *PATH*
+|	**bpftool** **iter help**
+|
+|	*OBJ* :=3D /a/file/of/bpf_iter_target.o
+
+
+DESCRIPTION
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	**bpftool iter pin** *OBJ* *PATH*
+		  A bpf iterator combines a kernel iterating of
+		  particular kernel data (e.g., tasks, bpf_maps, etc.)
+		  and a bpf program called for each kernel data object
+		  (e.g., one task, one bpf_map, etc.). User space can
+		  *read* kernel iterator output through *read()* syscall.
+
+		  The *pin* command creates a bpf iterator from *OBJ*,
+		  and pin it to *PATH*. The *PATH* should be located
+		  in *bpffs* mount. It must not contain a dot
+		  character ('.'), which is reserved for future extensions
+		  of *bpffs*.
+
+		  User can then *cat PATH* to see the bpf iterator output.
+
+	**bpftool iter help**
+		  Print short help message.
+
+OPTIONS
+=3D=3D=3D=3D=3D=3D=3D
+	-h, --help
+		  Print short generic help message (similar to **bpftool help**).
+
+	-V, --version
+		  Print version number (similar to **bpftool version**).
+
+	-d, --debug
+		  Print all logs available, even debug-level information. This
+		  includes logs from libbpf as well as from the verifier, when
+		  attempting to load programs.
+
+EXAMPLES
+=3D=3D=3D=3D=3D=3D=3D=3D
+**# bpftool iter pin bpf_iter_netlink.o /sys/fs/bpf/my_netlink**
+
+::
+
+   Create a file-based bpf iterator from bpf_iter_netlink.o and pin it
+   to /sys/fs/bpf/my_netlink
+
+
+SEE ALSO
+=3D=3D=3D=3D=3D=3D=3D=3D
+	**bpf**\ (2),
+	**bpf-helpers**\ (7),
+	**bpftool**\ (8),
+	**bpftool-prog**\ (8),
+	**bpftool-map**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-cgroup**\ (8),
+	**bpftool-feature**\ (8),
+	**bpftool-net**\ (8),
+	**bpftool-perf**\ (8),
+	**bpftool-btf**\ (8)
+	**bpftool-gen**\ (8)
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
index fc989ead7313..9f0f20e73b87 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -610,6 +610,19 @@ _bpftool()
                     ;;
             esac
             ;;
+        iter)
+            case $command in
+                pin)
+                    _filedir
+                    return 0
+                    ;;
+                *)
+                    [[ $prev =3D=3D $object ]] && \
+                        COMPREPLY=3D( $( compgen -W 'pin help' \
+                            -- "$cur" ) )
+                    ;;
+            esac
+            ;;
         map)
             local MAP_TYPE=3D'id pinned name'
             case $command in
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
new file mode 100644
index 000000000000..a8fb1349c103
--- /dev/null
+++ b/tools/bpf/bpftool/iter.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+// Copyright (C) 2020 Facebook
+
+#define _GNU_SOURCE
+#include <linux/err.h>
+#include <bpf/libbpf.h>
+
+#include "main.h"
+
+static int do_pin(int argc, char **argv)
+{
+	const char *objfile, *path;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_link *link;
+	int err;
+
+	if (!REQ_ARGS(2))
+		usage();
+
+	objfile =3D GET_ARG();
+	path =3D GET_ARG();
+
+	obj =3D bpf_object__open(objfile);
+	if (IS_ERR_OR_NULL(obj)) {
+		p_err("can't open objfile %s", objfile);
+		return -1;
+	}
+
+	err =3D bpf_object__load(obj);
+	if (err) {
+		p_err("can't load objfile %s", objfile);
+		goto close_obj;
+	}
+
+	prog =3D bpf_program__next(NULL, obj);
+	link =3D bpf_program__attach_iter(prog, NULL);
+	if (IS_ERR(link)) {
+		err =3D PTR_ERR(link);
+		p_err("attach_iter failed for program %s",
+		      bpf_program__name(prog));
+		goto close_obj;
+	}
+
+	err =3D mount_bpffs_for_pin(path);
+	if (err)
+		goto close_link;
+
+	err =3D bpf_link__pin(link, path);
+	if (err) {
+		p_err("pin_iter failed for program %s to path %s",
+		      bpf_program__name(prog), path);
+		goto close_link;
+	}
+
+close_link:
+	bpf_link__disconnect(link);
+	bpf_link__destroy(link);
+close_obj:
+	bpf_object__close(obj);
+	return err;
+}
+
+static int do_help(int argc, char **argv)
+{
+	fprintf(stderr,
+		"Usage: %s %s pin OBJ PATH\n"
+		"       %s %s help\n"
+		"\n",
+		bin_name, argv[-2], bin_name, argv[-2]);
+
+	return 0;
+}
+
+static const struct cmd cmds[] =3D {
+	{ "help",	do_help },
+	{ "pin",	do_pin },
+	{ 0 }
+};
+
+int do_iter(int argc, char **argv)
+{
+	return cmd_select(cmds, argc, argv, do_help);
+}
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index adc7dc431ed8..b6a0b35c78ae 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -16,6 +16,7 @@ static const char * const link_type_name[] =3D {
 	[BPF_LINK_TYPE_RAW_TRACEPOINT]		=3D "raw_tracepoint",
 	[BPF_LINK_TYPE_TRACING]			=3D "tracing",
 	[BPF_LINK_TYPE_CGROUP]			=3D "cgroup",
+	[BPF_LINK_TYPE_ITER]			=3D "iter",
 };
=20
 static int link_parse_fd(int *argc, char ***argv)
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 1413a154806e..46bd716a9d86 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -59,7 +59,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT :=3D { prog | map | link | cgroup | perf | net | featur=
e | btf | gen | struct_ops }\n"
+		"       OBJECT :=3D { prog | map | link | cgroup | perf | net | featur=
e | btf | gen | struct_ops | iter }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
@@ -224,6 +224,7 @@ static const struct cmd cmds[] =3D {
 	{ "btf",	do_btf },
 	{ "gen",	do_gen },
 	{ "struct_ops",	do_struct_ops },
+	{ "iter",	do_iter },
 	{ "version",	do_version },
 	{ 0 }
 };
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 9b1fb81a8331..a41cefabccaf 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -199,6 +199,7 @@ int do_feature(int argc, char **argv);
 int do_btf(int argc, char **argv);
 int do_gen(int argc, char **argv);
 int do_struct_ops(int argc, char **argv);
+int do_iter(int argc, char **argv);
=20
 int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what)=
;
 int prog_parse_fd(int *argc, char ***argv);
--=20
2.24.1

