Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9046222913A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgGVGrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:47:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728497AbgGVGrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:47:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M6l3XX013324
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:47:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=52uDPvZHpM8dja7Q1VN27Rx2aaoG0bKvDlzDUpwQtqk=;
 b=jB53vEaLREhpZmh6GZPMYMd9G0Kj9Ej78FfOCLXcp8MSBlDRdyqgasNJaw4QUJZCeAjX
 sIY87gKLdhBoeWiYX7gOUx3jd69sAt9Ebfy5txfqBH40WPAW9IxAEfJZ4qNWPxMXCKlV
 MEESAZYy0QCKpH3iuLHFrRxjbm3pnqrURYk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32chbnw5p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:47:02 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 23:46:27 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2CB912EC494E; Tue, 21 Jul 2020 23:46:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 8/9] selftests/bpf: add BPF XDP link selftests
Date:   Tue, 21 Jul 2020 23:46:01 -0700
Message-ID: <20200722064603.3350758-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722064603.3350758-1-andriin@fb.com>
References: <20200722064603.3350758-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=9 clxscore=1015 mlxlogscore=810
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest validating all the attachment logic around BPF XDP link. Tes=
t
also link updates and get_obj_info() APIs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/xdp_link.c       | 137 ++++++++++++++++++
 .../selftests/bpf/progs/test_xdp_link.c       |  12 ++
 2 files changed, 149 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_link.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/te=
sting/selftests/bpf/prog_tests/xdp_link.c
new file mode 100644
index 000000000000..52cba6795d40
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <uapi/linux/if_link.h>
+#include <test_progs.h>
+#include "test_xdp_link.skel.h"
+
+#define IFINDEX_LO 1
+
+void test_xdp_link(void)
+{
+	__u32 duration =3D 0, id1, id2, id0 =3D 0, prog_fd1, prog_fd2, err;
+	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd =3D -1);
+	struct test_xdp_link *skel1 =3D NULL, *skel2 =3D NULL;
+	struct bpf_link_info link_info;
+	struct bpf_prog_info prog_info;
+	struct bpf_link *link;
+	__u32 link_info_len =3D sizeof(link_info);
+	__u32 prog_info_len =3D sizeof(prog_info);
+
+	skel1 =3D test_xdp_link__open_and_load();
+	if (CHECK(!skel1, "skel_load", "skeleton open and load failed\n"))
+		goto cleanup;
+	prog_fd1 =3D bpf_program__fd(skel1->progs.xdp_handler);
+
+	skel2 =3D test_xdp_link__open_and_load();
+	if (CHECK(!skel2, "skel_load", "skeleton open and load failed\n"))
+		goto cleanup;
+	prog_fd2 =3D bpf_program__fd(skel2->progs.xdp_handler);
+
+	memset(&prog_info, 0, sizeof(prog_info));
+	err =3D bpf_obj_get_info_by_fd(prog_fd1, &prog_info, &prog_info_len);
+	if (CHECK(err, "fd_info1", "failed %d\n", -errno))
+		goto cleanup;
+	id1 =3D prog_info.id;
+
+	memset(&prog_info, 0, sizeof(prog_info));
+	err =3D bpf_obj_get_info_by_fd(prog_fd2, &prog_info, &prog_info_len);
+	if (CHECK(err, "fd_info2", "failed %d\n", -errno))
+		goto cleanup;
+	id2 =3D prog_info.id;
+
+	/* set initial prog attachment */
+	err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd1, XDP_FLAGS_REPLAC=
E, &opts);
+	if (CHECK(err, "fd_attach", "initial prog attach failed: %d\n", err))
+		goto cleanup;
+
+	/* validate prog ID */
+	err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+	CHECK(err || id0 !=3D id1, "id1_check",
+	      "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err);
+
+	/* BPF link is not allowed to replace prog attachment */
+	link =3D bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDEX_LO);
+	if (CHECK(!IS_ERR(link), "link_attach_fail", "unexpected success\n")) {
+		bpf_link__destroy(link);
+		/* best-effort detach prog */
+		opts.old_fd =3D prog_fd1;
+		bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REPLACE, &opts);
+		goto cleanup;
+	}
+
+	/* detach BPF program */
+	opts.old_fd =3D prog_fd1;
+	err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REPLACE, &op=
ts);
+	if (CHECK(err, "prog_detach", "failed %d\n", err))
+		goto cleanup;
+
+	/* now BPF link should attach successfully */
+	link =3D bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDEX_LO);
+	if (CHECK(IS_ERR(link), "link_attach", "failed: %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	skel1->links.xdp_handler =3D link;
+
+	/* validate prog ID */
+	err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+	if (CHECK(err || id0 !=3D id1, "id1_check",
+		  "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err))
+		goto cleanup;
+
+	/* BPF prog attach is not allowed to replace BPF link */
+	opts.old_fd =3D prog_fd1;
+	err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd2, XDP_FLAGS_REPLAC=
E, &opts);
+	if (CHECK(!err, "prog_attach_fail", "unexpected success\n"))
+		goto cleanup;
+
+	/* Can't force-update when BPF link is active */
+	err =3D bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd2, 0);
+	if (CHECK(!err, "prog_update_fail", "unexpected success\n"))
+		goto cleanup;
+
+	/* Can't force-detach when BPF link is active */
+	err =3D bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
+	if (CHECK(!err, "prog_detach_fail", "unexpected success\n"))
+		goto cleanup;
+
+	/* BPF link is not allowed to replace another BPF link */
+	link =3D bpf_program__attach_xdp(skel2->progs.xdp_handler, IFINDEX_LO);
+	if (CHECK(!IS_ERR(link), "link_attach_fail", "unexpected success\n")) {
+		bpf_link__destroy(link);
+		goto cleanup;
+	}
+
+	bpf_link__destroy(skel1->links.xdp_handler);
+	skel1->links.xdp_handler =3D NULL;
+
+	/* new link attach should succeed */
+	link =3D bpf_program__attach_xdp(skel2->progs.xdp_handler, IFINDEX_LO);
+	if (CHECK(IS_ERR(link), "link_attach", "failed: %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	skel2->links.xdp_handler =3D link;
+
+	err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+	if (CHECK(err || id0 !=3D id2, "id2_check",
+		  "loaded prog id %u !=3D id2 %u, err %d", id0, id1, err))
+		goto cleanup;
+
+	/* updating program under active BPF link works as expected */
+	err =3D bpf_link__update_program(link, skel1->progs.xdp_handler);
+	if (CHECK(err, "link_upd", "failed: %d\n", err))
+		goto cleanup;
+
+	memset(&link_info, 0, sizeof(link_info));
+	err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &link_in=
fo_len);
+	if (CHECK(err, "link_info", "failed: %d\n", err))
+		goto cleanup;
+
+	CHECK(link_info.type !=3D BPF_LINK_TYPE_XDP, "link_type",
+	      "got %u !=3D exp %u\n", link_info.type, BPF_LINK_TYPE_XDP);
+	CHECK(link_info.prog_id !=3D id1, "link_prog_id",
+	      "got %u !=3D exp %u\n", link_info.prog_id, id1);
+	CHECK(link_info.xdp.ifindex !=3D IFINDEX_LO, "link_ifindex",
+	      "got %u !=3D exp %u\n", link_info.xdp.ifindex, IFINDEX_LO);
+
+cleanup:
+	test_xdp_link__destroy(skel1);
+	test_xdp_link__destroy(skel2);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_link.c b/tools/te=
sting/selftests/bpf/progs/test_xdp_link.c
new file mode 100644
index 000000000000..eb93ea95d1d8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_link.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char LICENSE[] SEC("license") =3D "GPL";
+
+SEC("xdp/handler")
+int xdp_handler(struct xdp_md *xdp)
+{
+	return 0;
+}
--=20
2.24.1

