Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99CA42987E
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhJKU4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 16:56:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235122AbhJKU4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 16:56:43 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19BI6KRn026758
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 13:54:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jiWoWEoBxiQxuwofkhy30iHsqxcvYSjjlvcgUPlq5zM=;
 b=SgkzK7pgH0I0MVB/3Xcc7Ya3kYv0rhNGP2Xk/6w2fpZSC7N0hSPN25BVcM6DIszGqprl
 mozQr4fKb7iUoszk3UQkt6LjZrN8UvwFNzTu4ykqkThmCke4bzA6a8qdaWwrU5mL1xKw
 BBUm3p3ilCSpPFMqG/mjYAEcn3omjlVKyyU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3bmjs5mc8q-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 13:54:42 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 11 Oct 2021 13:54:23 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id F3BCD7E3770D; Mon, 11 Oct 2021 13:54:17 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: add verif_stats test
Date:   Mon, 11 Oct 2021 13:54:15 -0700
Message-ID: <20211011205415.234479-3-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011205415.234479-1-davemarchevsky@fb.com>
References: <20211011205415.234479-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: gn56uVK6btuj3G9zvLPagmYjFz670WEX
X-Proofpoint-GUID: gn56uVK6btuj3G9zvLPagmYjFz670WEX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_10,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=778
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

verified_insns field was added to response of bpf_obj_get_info_by_fd
call on a prog. Confirm that it's being populated by loading a simple
program and asking for its info.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 .../selftests/bpf/prog_tests/verif_stats.c    | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c

diff --git a/tools/testing/selftests/bpf/prog_tests/verif_stats.c b/tools=
/testing/selftests/bpf/prog_tests/verif_stats.c
new file mode 100644
index 000000000000..42843db519e5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
@@ -0,0 +1,31 @@
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
+	if (!ASSERT_GT((__u32)info.verified_insns, 0, "verified_insns"))
+		goto cleanup;
+
+cleanup:
+	trace_vprintk__destroy(skel);
+}
--=20
2.30.2

