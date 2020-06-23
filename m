Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2C1205700
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733051AbgFWQSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:18:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732988AbgFWQSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:18:16 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NG6CWc011478
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pEQMQePIoDT1uqbqmfi+icJBygFu01ht7W9vXY7wzf0=;
 b=EWRieN9vN8lMuE5oYIpUSj9AtgqwjS3x1DDCuhZ3AuPzrtxhHvdTrtJnCy13Dplkyt12
 sX9/6wi1/C7yXtCTKN3IgmAP8IBir1dzThPdi403ZKb1YkHf2Vc/CRtb9QIxH0bIjhca
 tWwA0AVd2sqWbIZ2AC+yLaeEQNrvTESO05U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk2r0pxd-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:15 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:18:04 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 723873704B02; Tue, 23 Jun 2020 09:18:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 10/15] selftests/bpf: move newer bpf_iter_* type redefining to a new header file
Date:   Tue, 23 Jun 2020 09:18:02 -0700
Message-ID: <20200623161802.2501431-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
References: <20200623161749.2500196-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_10:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=8 phishscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b9f4c01f3e0b ("selftest/bpf: Make bpf_iter selftest
compilable against old vmlinux.h") and Commit dda18a5c0b75
("selftests/bpf: Convert bpf_iter_test_kern{3, 4}.c to define
own bpf_iter_meta") redefined newly introduced types
in bpf programs so the bpf program can still compile
properly with old kernels although loading may fail.

Since this patch set introduced new types and the same
workaround is needed, so let us move the workaround
to a separate header file so they do not clutter
bpf programs.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter.h  | 49 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    | 18 +------
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 18 +------
 .../selftests/bpf/progs/bpf_iter_netlink.c    | 18 +------
 .../selftests/bpf/progs/bpf_iter_task.c       | 18 +------
 .../selftests/bpf/progs/bpf_iter_task_file.c  | 20 +-------
 .../selftests/bpf/progs/bpf_iter_test_kern3.c | 17 +------
 .../selftests/bpf/progs/bpf_iter_test_kern4.c | 17 +------
 .../bpf/progs/bpf_iter_test_kern_common.h     | 18 +------
 9 files changed, 57 insertions(+), 136 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter.h

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing=
/selftests/bpf/progs/bpf_iter.h
new file mode 100644
index 000000000000..3757e88c6406
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__bpf_map bpf_iter__bpf_map___not_used
+#define bpf_iter__ipv6_route bpf_iter__ipv6_route___not_used
+#define bpf_iter__netlink bpf_iter__netlink___not_used
+#define bpf_iter__task bpf_iter__task___not_used
+#define bpf_iter__task_file bpf_iter__task_file___not_used
+#include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__bpf_map
+#undef bpf_iter__ipv6_route
+#undef bpf_iter__netlink
+#undef bpf_iter__task
+#undef bpf_iter__task_file
+
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__ipv6_route {
+	struct bpf_iter_meta *meta;
+	struct fib6_info *rt;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__netlink {
+	struct bpf_iter_meta *meta;
+	struct netlink_sock *sk;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__task {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__task_file {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+	__u32 fd;
+	struct file *file;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__bpf_map {
+	struct bpf_iter_meta *meta;
+	struct bpf_map *map;
+} __attribute__((preserve_access_index));
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
index b57bd6fef208..08651b23edba 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
@@ -1,27 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-/* "undefine" structs in vmlinux.h, because we "override" them below */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__bpf_map bpf_iter__bpf_map___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__bpf_map
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__bpf_map {
-	struct bpf_iter_meta *meta;
-	struct bpf_map *map;
-} __attribute__((preserve_access_index));
-
 SEC("iter/bpf_map")
 int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
index c8e9ca74c87b..93a452d1d136 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
@@ -1,25 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-/* "undefine" structs in vmlinux.h, because we "override" them below */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__ipv6_route bpf_iter__ipv6_route___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__ipv6_route
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__ipv6_route {
-	struct bpf_iter_meta *meta;
-	struct fib6_info *rt;
-} __attribute__((preserve_access_index));
-
 char _license[] SEC("license") =3D "GPL";
=20
 extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_netlink.c
index e7b8753eac0b..fda5036fdf75 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
@@ -1,11 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-/* "undefine" structs in vmlinux.h, because we "override" them below */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__netlink bpf_iter__netlink___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__netlink
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
@@ -14,17 +9,6 @@ char _license[] SEC("license") =3D "GPL";
 #define sk_rmem_alloc	sk_backlog.rmem_alloc
 #define sk_refcnt	__sk_common.skc_refcnt
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__netlink {
-	struct bpf_iter_meta *meta;
-	struct netlink_sock *sk;
-} __attribute__((preserve_access_index));
-
 static inline struct inode *SOCK_INODE(struct socket *socket)
 {
 	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task.c b/tools/te=
sting/selftests/bpf/progs/bpf_iter_task.c
index ee754021f98e..4983087852a0 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task.c
@@ -1,27 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-/* "undefine" structs in vmlinux.h, because we "override" them below */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__task bpf_iter__task___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__task
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__task {
-	struct bpf_iter_meta *meta;
-	struct task_struct *task;
-} __attribute__((preserve_access_index));
-
 SEC("iter/task")
 int dump_task(struct bpf_iter__task *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c b/too=
ls/testing/selftests/bpf/progs/bpf_iter_task_file.c
index 0f0ec3db20ba..8b787baa2654 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
@@ -1,29 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-/* "undefine" structs in vmlinux.h, because we "override" them below */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__task_file bpf_iter__task_file___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__task_file
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__task_file {
-	struct bpf_iter_meta *meta;
-	struct task_struct *task;
-	__u32 fd;
-	struct file *file;
-} __attribute__((preserve_access_index));
-
 SEC("iter/task_file")
 int dump_task_file(struct bpf_iter__task_file *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
index 13c2c90c835f..2a4647f20c46 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
@@ -1,25 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__task bpf_iter__task___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__task
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__task {
-	struct bpf_iter_meta *meta;
-	struct task_struct *task;
-} __attribute__((preserve_access_index));
-
 SEC("iter/task")
 int dump_task(struct bpf_iter__task *ctx)
 {
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
index 0aa71b333cf3..ee49493dc125 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
@@ -1,25 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__bpf_map bpf_iter__bpf_map___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__bpf_map
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
=20
 char _license[] SEC("license") =3D "GPL";
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__bpf_map {
-	struct bpf_iter_meta *meta;
-	struct bpf_map *map;
-} __attribute__((preserve_access_index));
-
 __u32 map1_id =3D 0, map2_id =3D 0;
 __u32 map1_accessed =3D 0, map2_accessed =3D 0;
 __u64 map1_seqnum =3D 0, map2_seqnum1 =3D 0, map2_seqnum2 =3D 0;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.=
h b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
index dee1339e6905..d5e3df66ad9a 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
@@ -1,27 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2020 Facebook */
-/* "undefine" structs in vmlinux.h, because we "override" them below */
-#define bpf_iter_meta bpf_iter_meta___not_used
-#define bpf_iter__task bpf_iter__task___not_used
-#include "vmlinux.h"
-#undef bpf_iter_meta
-#undef bpf_iter__task
+#include "bpf_iter.h"
 #include <bpf/bpf_helpers.h>
=20
 char _license[] SEC("license") =3D "GPL";
 int count =3D 0;
=20
-struct bpf_iter_meta {
-	struct seq_file *seq;
-	__u64 session_id;
-	__u64 seq_num;
-} __attribute__((preserve_access_index));
-
-struct bpf_iter__task {
-	struct bpf_iter_meta *meta;
-	struct task_struct *task;
-} __attribute__((preserve_access_index));
-
 SEC("iter/task")
 int dump_task(struct bpf_iter__task *ctx)
 {
--=20
2.24.1

