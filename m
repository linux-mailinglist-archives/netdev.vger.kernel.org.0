Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA7B43462D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhJTHu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:50:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31226 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhJTHu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:50:56 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JNw0ne020365
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:48:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=l+EXY5ITIrA2bTA1mE+9i19+7GeZDrDna/h5jdbRXlc=;
 b=Xke9xPmWOAtOZ7B1beTWH/REPXvbq9KQhtVpQ8arNDrHHQunsfWPq6F91tIsOgCAJyi2
 IyHxvNPMVZ/QNd3phNwAlTYH6qzL5h+fdAgjdn/Y4FLsYgqn3ZUs0X/CoEiKpdj5xbIz
 ZU5WomgFCDRjTVFBBpUmruqcZfVMmjtbwJc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bt85gj4dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:48:42 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 20 Oct 2021 00:48:40 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 1C03E84FD53A; Wed, 20 Oct 2021 00:48:33 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v3 bpf-next 2/2] selftests/bpf: add verif_stats test
Date:   Wed, 20 Oct 2021 00:48:18 -0700
Message-ID: <20211020074818.1017682-3-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211020074818.1017682-1-davemarchevsky@fb.com>
References: <20211020074818.1017682-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 3fnyaD7-K0fYSlb1fCYNjaVz9DlztiDk
X-Proofpoint-ORIG-GUID: 3fnyaD7-K0fYSlb1fCYNjaVz9DlztiDk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=769 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

verified_insns field was added to response of bpf_obj_get_info_by_fd
call on a prog. Confirm that it's being populated by loading a simple
program and asking for its info.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/verif_stats.c    | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c

diff --git a/tools/testing/selftests/bpf/prog_tests/verif_stats.c b/tools=
/testing/selftests/bpf/prog_tests/verif_stats.c
new file mode 100644
index 000000000000..b4bae1340cf1
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/verif_stats.c
@@ -0,0 +1,28 @@
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
+	err =3D bpf_obj_get_info_by_fd(skel->progs.sys_enter.prog_fd, &info, &l=
en);
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
+		goto cleanup;
+
+	if (!ASSERT_GT(info.verified_insns, 0, "verified_insns"))
+		goto cleanup;
+
+cleanup:
+	trace_vprintk__destroy(skel);
+}
--=20
2.30.2

