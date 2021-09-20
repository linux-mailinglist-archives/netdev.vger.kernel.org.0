Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E57D4117F0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241328AbhITPNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:13:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14834 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241141AbhITPNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:13:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KALale031423
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:11:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=tSHVhq/Ytx9xEbm3hRA0+Mli0C2HqF26tqgeTIebAL8=;
 b=iKT+xALjJKpRwvv9YTrQU62QZUWnPhqfmbOAaQupnsbZxNPnzCjNuqLQygYRHAiO/bkE
 EHDPkesWcagq0YbIxeI5Mpf3zeiIvLYuBifflnrhUI2vV9Q6++t8Kt3PBRIDqbi3B339
 XK5wMOHlhJpXX5EmRGga0M8z2x3nzh0s9Lo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b6f2rbvhu-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:11:38 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 20 Sep 2021 08:11:35 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id E36A16E18CD3; Mon, 20 Sep 2021 08:11:27 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [RFC PATCH bpf-next 2/2] selftests/bpf: add verif_stats test
Date:   Mon, 20 Sep 2021 08:11:12 -0700
Message-ID: <20210920151112.3770991-3-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210920151112.3770991-1-davemarchevsky@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: yJxe-x0APERR1gX3NQBVGP_lflwTlXNF
X-Proofpoint-GUID: yJxe-x0APERR1gX3NQBVGP_lflwTlXNF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxlogscore=746
 impostorscore=0 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200098
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

verif_stats fields were added to response of bpf_obj_get_info_by_fd
call on a prog. Confirm that they're being populated by loading a simple
program and asking for its info.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 .../selftests/bpf/prog_tests/verif_stats.c    | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c

diff --git a/tools/testing/selftests/bpf/prog_tests/verif_stats.c b/tools=
/testing/selftests/bpf/prog_tests/verif_stats.c
new file mode 100644
index 000000000000..7bd9ccb0efb8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+
+#include "trace_vprintk.lskel.h"
+
+void test_verif_stats(void)
+{
+	__u32 len =3D sizeof(struct bpf_prog_info);
+	struct bpf_prog_info info =3D {};
+	struct trace_vprintk *skel;
+	int err;
+
+	skel =3D trace_vprintk__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "trace_vprintk__open_and_load"))
+		goto cleanup;
+
+	if (!ASSERT_GT(skel->progs.sys_enter.prog_fd, 0, "sys_enter_fd > 0"))
+		goto cleanup;
+
+	err =3D bpf_obj_get_info_by_fd(skel->progs.sys_enter.prog_fd, &info, &l=
en);
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
+		goto cleanup;
+
+	if (!ASSERT_GT(info.verif_stats.insn_processed, 0, "verif_stats.insn_pr=
ocessed"))
+		goto cleanup;
+
+	if (!ASSERT_GT(info.verif_stats.total_states, 0, "verif_stats.total_sta=
tes"))
+		goto cleanup;
+
+cleanup:
+	trace_vprintk__destroy(skel);
+}
--=20
2.30.2

