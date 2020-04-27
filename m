Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5144C1BAF0C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgD0UNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:13:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbgD0UND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:13:03 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK8FdZ022602
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:13:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZjwHMp00doVzKyGyBQm5cBW9JKLcyAAnoLaRok4ayAY=;
 b=aqwaMEFU01+CG+DEI1YqBijM+pZ5XvkMrqcO2LI32QpIlV1DB20M8GbujwyFWBEdSCl3
 LxqfHrjKj+hdpBN8MBff06ScswPn1Ernv6PiqzbOPUkPlaRlSd9uIJB7V96+l9vGEfib
 q3Zj4S6ueRl0DY+crqO6VZ9QeYjM8aPA5GY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54ea3nv-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:13:02 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:13:01 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id F32DB3700871; Mon, 27 Apr 2020 13:12:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 16/19] tools/bpftool: add bpf_iter support for bptool
Date:   Mon, 27 Apr 2020 13:12:53 -0700
Message-ID: <20200427201253.2996156-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270164
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

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpftool/Documentation/bpftool-iter.rst    | 71 ++++++++++++++++
 tools/bpf/bpftool/bash-completion/bpftool     | 13 +++
 tools/bpf/bpftool/iter.c                      | 84 +++++++++++++++++++
 tools/bpf/bpftool/main.c                      |  3 +-
 tools/bpf/bpftool/main.h                      |  1 +
 5 files changed, 171 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
 create mode 100644 tools/bpf/bpftool/iter.c

diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf=
/bpftool/Documentation/bpftool-iter.rst
new file mode 100644
index 000000000000..1997a6bac4a0
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -0,0 +1,71 @@
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
+STRUCT_OPS COMMANDS
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+|	**bpftool** **iter pin** *OBJ* *PATH*
+|	**bpftool** **struct_ops help**
+|
+|	*OBJ* :=3D /a/file/of/bpf_iter_target.o
+
+
+DESCRIPTION
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+	**bpftool iter pin** *OBJ* *PATH*
+		  Create a bpf iterator from *OBJ*, and pin it to
+		  *PATH*. The *PATH* should be located in *bpffs* mount.
+
+	**bpftool struct_ops help**
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
+	**bpftool-cgroup**\ (8),
+	**bpftool-feature**\ (8),
+	**bpftool-net**\ (8),
+	**bpftool-perf**\ (8),
+	**bpftool-btf**\ (8)
+	**bpftool-gen**\ (8)
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
index 45ee99b159e2..17a81695da0f 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -604,6 +604,19 @@ _bpftool()
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
+                        COMPREPLY=3D( $( compgen -W 'help' \
+                            -- "$cur" ) )
+                    ;;
+            esac
+            ;;
         map)
             local MAP_TYPE=3D'id pinned name'
             case $command in
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
new file mode 100644
index 000000000000..db9fae6be716
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
+	if (err < 0) {
+		err =3D -1;
+		p_err("can't load objfile %s", objfile);
+		goto close_obj;
+	}
+
+	prog =3D bpf_program__next(NULL, obj);
+	link =3D bpf_program__attach_iter(prog, NULL);
+	if (IS_ERR(link)) {
+		err =3D -1;
+		p_err("attach_iter failed for program %s",
+		      bpf_program__name(prog));
+		goto close_obj;
+	}
+
+	err =3D bpf_link__pin(link, path);
+	if (err) {
+		err =3D -1;
+		p_err("pin_iter failed for program %s to path %s",
+		      bpf_program__name(prog), path);
+		goto close_link;
+	}
+
+	err =3D 0;
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
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 466c269eabdd..6805b77789cb 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT :=3D { prog | map | cgroup | perf | net | feature | btf=
 | gen | struct_ops }\n"
+		"       OBJECT :=3D { prog | map | cgroup | perf | net | feature | btf=
 | gen | struct_ops | iter }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
@@ -222,6 +222,7 @@ static const struct cmd cmds[] =3D {
 	{ "btf",	do_btf },
 	{ "gen",	do_gen },
 	{ "struct_ops",	do_struct_ops },
+	{ "iter",	do_iter },
 	{ "version",	do_version },
 	{ 0 }
 };
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 86f14ce26fd7..2b5d4a616b48 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -162,6 +162,7 @@ int do_feature(int argc, char **argv);
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

