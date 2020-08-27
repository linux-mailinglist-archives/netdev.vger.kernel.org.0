Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4FF253ADE
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgH0AGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:06:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44476 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgH0AGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:06:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R04lkH002596
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QKD71FgRdrV63rw8OMTz4tR+lNYd7sHK+PSEKlPqm18=;
 b=J/um0pRdurVRiSKk9WV6YNDlmTpTtqH+0F/VkgALRBLcboFPHmjFftasrqIs7+QXRIGd
 Q5JMiLYY6E/7vjqG8+UF56fakO1Jhu93x/q5Qk1n6SlihvFq8DMwkPW6Towi0AlU6lP5
 y024PNSd0HrT1FyVpCI2nZJGWG3xzHTLkWw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up82a3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:31 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 17:06:30 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 0C7C037052E0; Wed, 26 Aug 2020 17:06:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/5] bpftool: support optional 'task main_thread_only' argument
Date:   Wed, 26 Aug 2020 17:06:22 -0700
Message-ID: <20200827000622.2712178-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200827000618.2711826-1-yhs@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=8 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For task and task_file bpf iterators, optional 'task main_thread_only'
can signal the kernel to only iterate through main threads of each
process. link_query will also print out main_thread_only value for
task/task_file iterators.

This patch also fixed the issue where if the additional arguments
are not supported, bpftool will print an error message and exit.

  $ ./bpftool iter pin ./bpf_iter_task.o /sys/fs/bpf/p1 task main_thread_=
only
  $ ./bpftool iter pin ./bpf_iter_task_file.o /sys/fs/bpf/p2 task main_th=
read_only
  $ ./bpftool iter pin ./bpf_iter_task_file.o /sys/fs/bpf/p3
  $ ./bpftool link show
  1: iter  prog 6  target_name bpf_map
  2: iter  prog 7  target_name bpf_prog
  3: iter  prog 12  target_name task  main_thread_only 1
  5: iter  prog 23  target_name task_file  main_thread_only 1
  6: iter  prog 28  target_name task_file  main_thread_only 0

  $ cat /sys/fs/bpf/p2
    tgid      gid       fd      file
  ...
    1716     1716      255 ffffffffa2e95ec0
    1756     1756        0 ffffffffa2e95ec0
    1756     1756        1 ffffffffa2e95ec0
    1756     1756        2 ffffffffa2e95ec0
    1756     1756        3 ffffffffa2e20a80
    1756     1756        4 ffffffffa2e19ba0
    1756     1756        5 ffffffffa2e16460
    1756     1756        6 ffffffffa2e16460
    1756     1756        7 ffffffffa2e16460
    1756     1756        8 ffffffffa2e16260
    1761     1761        0 ffffffffa2e95ec0
  ...
  $ ls /proc/1756/task/
    1756  1757  1758  1759  1760

  In the above task_file iterator, the process with id 1756 has 5 threads=
 and
  only the thread with pid =3D 1756 is processed by the bpf program.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../bpftool/Documentation/bpftool-iter.rst    | 17 +++++++++--
 tools/bpf/bpftool/bash-completion/bpftool     |  9 +++++-
 tools/bpf/bpftool/iter.c                      | 28 ++++++++++++++++---
 tools/bpf/bpftool/link.c                      | 12 ++++++++
 4 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf=
/bpftool/Documentation/bpftool-iter.rst
index 070ffacb42b5..d9aac12c76da 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -17,15 +17,16 @@ SYNOPSIS
 ITER COMMANDS
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-|	**bpftool** **iter pin** *OBJ* *PATH* [**map** *MAP*]
+|	**bpftool** **iter pin** *OBJ* *PATH* [**map** *MAP* | **task** *TASK_=
OPT*]
 |	**bpftool** **iter help**
 |
 |	*OBJ* :=3D /a/file/of/bpf_iter_target.o
 |	*MAP* :=3D { **id** *MAP_ID* | **pinned** *FILE* }
+|	*TASK_OPT* :=3D { **main_thread_only** }
=20
 DESCRIPTION
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-	**bpftool iter pin** *OBJ* *PATH* [**map** *MAP*]
+	**bpftool iter pin** *OBJ* *PATH* [**map** *MAP* | **task** *TASK_OPT*]
 		  A bpf iterator combines a kernel iterating of
 		  particular kernel data (e.g., tasks, bpf_maps, etc.)
 		  and a bpf program called for each kernel data object
@@ -44,6 +45,11 @@ DESCRIPTION
 		  with each map element, do checking, filtering, aggregation,
 		  etc. without copying data to user space.
=20
+		  The task or task_file bpf iterator can have an optional
+		  parameter *TASK_OPT*. The current supported value is
+		  **main_thread_only** which supports to iterate only main
+		  threads of each process.
+
 		  User can then *cat PATH* to see the bpf iterator output.
=20
 	**bpftool iter help**
@@ -78,6 +84,13 @@ EXAMPLES
    Create a file-based bpf iterator from bpf_iter_hashmap.o and map with
    id 20, and pin it to /sys/fs/bpf/my_hashmap
=20
+**# bpftool iter pin bpf_iter_task.o /sys/fs/bpf/my_task task main_threa=
d_only**
+
+::
+
+   Create a file-based bpf iterator from bpf_iter_task.o which iterates =
main
+   threads of processes only, and pin it to /sys/fs/bpf/my_hashmap
+
 SEE ALSO
 =3D=3D=3D=3D=3D=3D=3D=3D
 	**bpf**\ (2),
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
index 7b68e3c0a5fb..84d538de71e1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -613,6 +613,7 @@ _bpftool()
             esac
             ;;
         iter)
+            local TARGET_TYPE=3D'map task'
             case $command in
                 pin)
                     case $prev in
@@ -628,9 +629,15 @@ _bpftool()
                         pinned)
                             _filedir
                             ;;
-                        *)
+                        task)
+                            _bpftool_one_of_list 'main_thread_only'
+                            ;;
+                        map)
                             _bpftool_one_of_list $MAP_TYPE
                             ;;
+                        *)
+                            _bpftool_one_of_list $TARGET_TYPE
+                            ;;
                     esac
                     return 0
                     ;;
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index 3b1aad7535dd..a4c789ea43f1 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -26,6 +26,7 @@ static int do_pin(int argc, char **argv)
=20
 	/* optional arguments */
 	if (argc) {
+		memset(&linfo, 0, sizeof(linfo));
 		if (is_prefix(*argv, "map")) {
 			NEXT_ARG();
=20
@@ -38,11 +39,29 @@ static int do_pin(int argc, char **argv)
 			if (map_fd < 0)
 				return -1;
=20
-			memset(&linfo, 0, sizeof(linfo));
 			linfo.map.map_fd =3D map_fd;
-			iter_opts.link_info =3D &linfo;
-			iter_opts.link_info_len =3D sizeof(linfo);
+		} else if (is_prefix(*argv, "task")) {
+			NEXT_ARG();
+
+			if (!REQ_ARGS(1)) {
+				p_err("incorrect task spec");
+				return -1;
+			}
+
+			if (strcmp(*argv, "main_thread_only") !=3D 0) {
+				p_err("incorrect task spec");
+				return -1;
+			}
+
+			linfo.task.main_thread_only =3D true;
+		} else {
+			p_err("expected no more arguments, 'map' or 'task', got: '%s'?",
+			      *argv);
+			return -1;
 		}
+
+		iter_opts.link_info =3D &linfo;
+		iter_opts.link_info_len =3D sizeof(linfo);
 	}
=20
 	obj =3D bpf_object__open(objfile);
@@ -95,9 +114,10 @@ static int do_pin(int argc, char **argv)
 static int do_help(int argc, char **argv)
 {
 	fprintf(stderr,
-		"Usage: %1$s %2$s pin OBJ PATH [map MAP]\n"
+		"Usage: %1$s %2$s pin OBJ PATH [map MAP | task TASK_OPT]\n"
 		"       %1$s %2$s help\n"
 		"       " HELP_SPEC_MAP "\n"
+		"       TASK_OPT :=3D { main_thread_only }\n"
 		"",
 		bin_name, "iter");
=20
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index e77e1525d20a..a159d5680c74 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -83,6 +83,12 @@ static bool is_iter_map_target(const char *target_name=
)
 	       strcmp(target_name, "bpf_sk_storage_map") =3D=3D 0;
 }
=20
+static bool is_iter_task_target(const char *target_name)
+{
+	return strcmp(target_name, "task") =3D=3D 0 ||
+	       strcmp(target_name, "task_file") =3D=3D 0;
+}
+
 static void show_iter_json(struct bpf_link_info *info, json_writer_t *wt=
r)
 {
 	const char *target_name =3D u64_to_ptr(info->iter.target_name);
@@ -91,6 +97,9 @@ static void show_iter_json(struct bpf_link_info *info, =
json_writer_t *wtr)
=20
 	if (is_iter_map_target(target_name))
 		jsonw_uint_field(wtr, "map_id", info->iter.map.map_id);
+	else if (is_iter_task_target(target_name))
+		jsonw_uint_field(wtr, "main_thread_only",
+				 info->iter.task.main_thread_only);
 }
=20
 static int get_prog_info(int prog_id, struct bpf_prog_info *info)
@@ -202,6 +211,9 @@ static void show_iter_plain(struct bpf_link_info *inf=
o)
=20
 	if (is_iter_map_target(target_name))
 		printf("map_id %u  ", info->iter.map.map_id);
+	else if (is_iter_task_target(target_name))
+		printf("main_thread_only %u  ",
+		       info->iter.task.main_thread_only);
 }
=20
 static int show_link_close_plain(int fd, struct bpf_link_info *info)
--=20
2.24.1

