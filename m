Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C3B1AB1AE
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436646AbgDOT32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:29:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32640 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411864AbgDOT23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJSNVB024724
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=h6xOUe1xExobaAv34ghOQ+fX0xY5qRBwmBhSlt1y7+k=;
 b=Qh7bl8egwa4/is6XEP5fK1rldPNjt4kVsEfJmBQRVfT5V4/eFGk3P1arLfSD7MqZRBfd
 9b66b4M1byZJtFUwZNoVbgePk555GQolQ4Z9WWdWX0EfwhOjWXUe9KhTv1BUOryjNrHi
 1a01UpneHSbm+tlZzOf15kT5c/1CTl5oh7Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7gqkrj-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:27 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:06 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D4E853700AF5; Wed, 15 Apr 2020 12:27:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 14/17] tools/bpftool: add bpf dumper support
Date:   Wed, 15 Apr 2020 12:27:56 -0700
Message-ID: <20200415192756.4083931-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implemented "bpftool dumper" command. Two subcommands now:
  bpftool dumper pin <bpf_prog.o> <dumper_name>
  bpftool dumper show {target|dumper}

The "pin" subcommand will create a dumper with <dumper_name>
under the dump target (specified in <bpf_prog>.o).
The "show" subcommand will show bpf prog ctx type name , which
will be useful on how to write the bpf program, and
the "dumper" subcommand will further show the corresponding prog_id
for each dumper.

For example, with some of later selftest dumpers are pinned
in the kernel, we can do inspection like below:
  $ bpftool dumper show target
  target                  prog_ctx_type
  task                    bpfdump__task
  task/file               bpfdump__task_file
  bpf_map                 bpfdump__bpf_map
  ipv6_route              bpfdump__ipv6_route
  netlink                 bpfdump__netlink
  $ bpftool dumper show dumper
  dumper                  prog_id   prog_ctx_type
  task/my1                8         bpfdump__task
  task/file/my1           12        bpfdump__task_file
  bpf_map/my1             4         bpfdump__bpf_map
  ipv6_route/my2          16        bpfdump__ipv6_route
  netlink/my2             24        bpfdump__ipv6_route
  netlink/my3             20        bpfdump__netlink

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/dumper.c | 135 +++++++++++++++++++++++++++++++++++++
 tools/bpf/bpftool/main.c   |   3 +-
 tools/bpf/bpftool/main.h   |   1 +
 3 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/dumper.c

diff --git a/tools/bpf/bpftool/dumper.c b/tools/bpf/bpftool/dumper.c
new file mode 100644
index 000000000000..46ca9d1d9a67
--- /dev/null
+++ b/tools/bpf/bpftool/dumper.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+// Copyright (C) 2020 Facebook
+// Author: Yonghong Song <yhs@fb.com>
+
+#define _GNU_SOURCE
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <ftw.h>
+
+#include <linux/err.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "main.h"
+
+static int do_pin(int argc, char **argv)
+{
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	const char *objfile, *dname;
+	int err;
+
+	if (!REQ_ARGS(2)) {
+		usage();
+		return -1;
+	}
+
+	objfile =3D GET_ARG();
+	dname =3D GET_ARG();
+
+	obj =3D bpf_object__open(objfile);
+	if (IS_ERR_OR_NULL(obj))
+		return -1;
+
+	err =3D bpf_object__load(obj);
+	if (err < 0)
+		return -1;
+
+	prog =3D bpf_program__next(NULL, obj);
+	return bpf_dump__pin(prog, dname);
+}
+
+static bool for_targets;
+static const char *bpfdump_root =3D "/sys/kernel/bpfdump";
+
+static int check_file(const char *fpath, const struct stat *sb,
+		      int typeflag, struct FTW *ftwbuf)
+{
+	char prog_ctx_cname_buf[64];
+	struct bpf_dump_info info;
+	unsigned info_len;
+	const char *name;
+	int ret, fd;
+
+	if ((for_targets && typeflag =3D=3D FTW_F) ||
+	    (!for_targets && typeflag =3D=3D FTW_D))
+		return 0;
+
+	if (for_targets && strcmp(fpath, bpfdump_root) =3D=3D 0)
+		return 0;
+
+	fd =3D open(fpath, O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	info_len =3D sizeof(info);
+	memset(&info, 0, info_len);
+	info.prog_ctx_type_name  =3D ptr_to_u64(prog_ctx_cname_buf);
+	info.type_name_buf_len =3D sizeof(prog_ctx_cname_buf);
+	ret =3D bpf_obj_get_info_by_fd(fd, &info, &info_len);
+	if (ret < 0)
+		goto done;
+
+	name =3D fpath + strlen(bpfdump_root) + 1;
+	if (for_targets)
+		fprintf(stdout, "%-24s%-24s\n", name, prog_ctx_cname_buf);
+	else
+		fprintf(stdout, "%-24s%-10d%-24s\n", name, info.prog_id,
+			prog_ctx_cname_buf);
+
+done:
+	close(fd);
+	return ret;
+}
+
+static int do_show(int argc, char **argv)
+{
+	int flags =3D FTW_PHYS;
+	int nopenfd =3D 16;
+	const char *spec;
+
+	if (!REQ_ARGS(1)) {
+		usage();
+		return -1;
+	}
+
+	spec =3D GET_ARG();
+	if (strcmp(spec, "target") =3D=3D 0) {
+		for_targets =3D true;
+		fprintf(stdout, "target                  prog_ctx_type\n");
+	} else if (strcmp(spec, "dumper") =3D=3D 0) {
+		fprintf(stdout, "dumper                  prog_id   prog_ctx_type\n");
+		for_targets =3D false;
+	} else {
+		return -1;
+	}
+
+	if (nftw(bpfdump_root, check_file, nopenfd, flags) =3D=3D -1)
+		return -1;
+
+	return 0;
+}
+
+static int do_help(int argc, char **argv)
+{
+	return 0;
+}
+
+static const struct cmd cmds[] =3D {
+	{ "help",	do_help },
+	{ "show",	do_show },
+	{ "pin",	do_pin },
+	{ 0 }
+};
+
+int do_dumper(int argc, char **argv)
+{
+	return cmd_select(cmds, argc, argv, do_help);
+}
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 466c269eabdd..8489aba6543d 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT :=3D { prog | map | cgroup | perf | net | feature | btf=
 | gen | struct_ops }\n"
+		"       OBJECT :=3D { prog | map | cgroup | perf | net | feature | btf=
 | gen | struct_ops | dumper}\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
@@ -222,6 +222,7 @@ static const struct cmd cmds[] =3D {
 	{ "btf",	do_btf },
 	{ "gen",	do_gen },
 	{ "struct_ops",	do_struct_ops },
+	{ "dumper",	do_dumper },
 	{ "version",	do_version },
 	{ 0 }
 };
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 86f14ce26fd7..2c59f319bbe9 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -162,6 +162,7 @@ int do_feature(int argc, char **argv);
 int do_btf(int argc, char **argv);
 int do_gen(int argc, char **argv);
 int do_struct_ops(int argc, char **argv);
+int do_dumper(int argc, char **arg);
=20
 int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what)=
;
 int prog_parse_fd(int *argc, char ***argv);
--=20
2.24.1

