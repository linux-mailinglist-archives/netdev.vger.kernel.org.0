Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185EA21DB8D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgGMQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:18:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730219AbgGMQR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:17:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DFxxJr031266
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PXtcKKBP3zj8SCeDPXNhPvi0KfjBhu/jne8vgHssHVY=;
 b=M4YCyMKBQRK6XVHPasrYmneFXyKLPlCnm4XCtS4oiEz/0IH0/jLbBGuP5EL+KAp+GKoc
 oIP8PG8HCqSHrrYQJ6gq0tIUHDCp2Hp9b7+mOMEXTMjmYSOdNkYNovRgfX2qJ/EfnMEs
 OcUZ/3vte8NEtL+GoaRtX6muZQ2rdqRe/zA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 327wdrdcha-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:56 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 09:17:55 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id F17293702065; Mon, 13 Jul 2020 09:17:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 09/13] tools/bpftool: add bpftool support for bpf map element iterator
Date:   Mon, 13 Jul 2020 09:17:49 -0700
Message-ID: <20200713161749.3077526-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713161739.3076283-1-yhs@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_15:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=8
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The optional parameter "map MAP" can be added to "bpftool iter"
command to create a bpf iterator for map elements. For example,
  bpftool iter pin ./prog.o /sys/fs/bpf/p1 map id 333

For map element bpf iterator "map MAP" parameter is required.
Otherwise, bpf link creation will return an error.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpftool/Documentation/bpftool-iter.rst    | 16 ++++++++--
 tools/bpf/bpftool/iter.c                      | 32 ++++++++++++++++---
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf=
/bpftool/Documentation/bpftool-iter.rst
index 8dce698eab79..53ee4fb188b4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -17,14 +17,15 @@ SYNOPSIS
 ITER COMMANDS
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-|	**bpftool** **iter pin** *OBJ* *PATH*
+|	**bpftool** **iter pin** *OBJ* *PATH* [**map** *MAP*]
 |	**bpftool** **iter help**
 |
 |	*OBJ* :=3D /a/file/of/bpf_iter_target.o
+|       *MAP* :=3D { **id** *MAP_ID* | **pinned** *FILE* }
=20
 DESCRIPTION
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-	**bpftool iter pin** *OBJ* *PATH*
+	**bpftool iter pin** *OBJ* *PATH* [**map** *MAP*]
 		  A bpf iterator combines a kernel iterating of
 		  particular kernel data (e.g., tasks, bpf_maps, etc.)
 		  and a bpf program called for each kernel data object
@@ -37,6 +38,10 @@ DESCRIPTION
 		  character ('.'), which is reserved for future extensions
 		  of *bpffs*.
=20
+                  Map element bpf iterator requires an additional parame=
ter
+                  *MAP* so bpf program can iterate over map elements for
+                  that map.
+
 		  User can then *cat PATH* to see the bpf iterator output.
=20
 	**bpftool iter help**
@@ -64,6 +69,13 @@ EXAMPLES
    Create a file-based bpf iterator from bpf_iter_netlink.o and pin it
    to /sys/fs/bpf/my_netlink
=20
+**# bpftool iter pin bpf_iter_hashmap.o /sys/fs/bpf/my_hashmap map id 20=
**
+
+::
+
+   Create a file-based bpf iterator from bpf_iter_hashmap.o and map with
+   id 20, and pin it to /sys/fs/bpf/my_hashmap
+
 SEE ALSO
 =3D=3D=3D=3D=3D=3D=3D=3D
 	**bpf**\ (2),
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index 33240fcc6319..cc1d9bdf6e9d 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -2,6 +2,7 @@
 // Copyright (C) 2020 Facebook
=20
 #define _GNU_SOURCE
+#include <unistd.h>
 #include <linux/err.h>
 #include <bpf/libbpf.h>
=20
@@ -9,11 +10,12 @@
=20
 static int do_pin(int argc, char **argv)
 {
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, iter_opts);
 	const char *objfile, *path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	struct bpf_link *link;
-	int err;
+	int err =3D -1, map_fd =3D -1;
=20
 	if (!REQ_ARGS(2))
 		usage();
@@ -21,10 +23,26 @@ static int do_pin(int argc, char **argv)
 	objfile =3D GET_ARG();
 	path =3D GET_ARG();
=20
+	/* optional arguments */
+	if (argc) {
+		if (is_prefix(*argv, "map")) {
+			NEXT_ARG();
+
+			if (!REQ_ARGS(2)) {
+				p_err("incorrect map spec");
+				return -1;
+			}
+
+			map_fd =3D map_parse_fd(&argc, &argv);
+			if (map_fd < 0)
+				return -1;
+		}
+	}
+
 	obj =3D bpf_object__open(objfile);
 	if (IS_ERR(obj)) {
 		p_err("can't open objfile %s", objfile);
-		return -1;
+		goto close_map_fd;
 	}
=20
 	err =3D bpf_object__load(obj);
@@ -39,7 +57,10 @@ static int do_pin(int argc, char **argv)
 		goto close_obj;
 	}
=20
-	link =3D bpf_program__attach_iter(prog, NULL);
+	if (map_fd >=3D 0)
+		iter_opts.map_fd =3D map_fd;
+
+	link =3D bpf_program__attach_iter(prog, &iter_opts);
 	if (IS_ERR(link)) {
 		err =3D PTR_ERR(link);
 		p_err("attach_iter failed for program %s",
@@ -62,13 +83,16 @@ static int do_pin(int argc, char **argv)
 	bpf_link__destroy(link);
 close_obj:
 	bpf_object__close(obj);
+close_map_fd:
+	if (map_fd >=3D 0)
+		close(map_fd);
 	return err;
 }
=20
 static int do_help(int argc, char **argv)
 {
 	fprintf(stderr,
-		"Usage: %1$s %2$s pin OBJ PATH\n"
+		"Usage: %1$s %2$s pin OBJ PATH [map MAP]\n"
 		"       %1$s %2$s help\n"
 		"",
 		bin_name, "iter");
--=20
2.24.1

