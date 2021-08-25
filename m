Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4893F7CF2
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbhHYT7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:59:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242514AbhHYT7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:59:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PJodGX020198
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ogZSUXj0ZHYP0BP1TRjmNP8HcBr0CI6eSa1lZupWSDI=;
 b=inRvR0Ro61J3qtflYGPMqjVzBBlnOzVcVPOWnCHYzwNlgpHSIZW8UWvFA/wNvPS1NOHg
 MHwJDY0JGT1U0jBqCIxTj3DThSu7ey77uhee+YNKIoRcY02RMSbUKkaSCS+/4Bnm7+H+
 G7bfRJJwajNiPTZMceXazmm45Onb+Vg0Q4w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3an9dupuwb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:46 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 25 Aug 2021 12:58:44 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 228755A34F62; Wed, 25 Aug 2021 12:58:40 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 5/6] selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
Date:   Wed, 25 Aug 2021 12:58:22 -0700
Message-ID: <20210825195823.381016-6-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825195823.381016-1-davemarchevsky@fb.com>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: vIBjmvmgcgAOB2au4umNUAmT6Bh1DjxQ
X-Proofpoint-ORIG-GUID: vIBjmvmgcgAOB2au4umNUAmT6Bh1DjxQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 spamscore=0 mlxlogscore=915 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108250117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guidance for new tests is to use ASSERT macros instead of CHECK. Since
trace_vprintk test will borrow heavily from trace_printk's, migrate its
CHECKs so it remains obvious that the two are closely related.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 .../selftests/bpf/prog_tests/trace_printk.c   | 24 +++++++------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk.c b/tool=
s/testing/selftests/bpf/prog_tests/trace_printk.c
index d39bc00feb45..e47835f0a674 100644
--- a/tools/testing/selftests/bpf/prog_tests/trace_printk.c
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
@@ -10,7 +10,7 @@
=20
 void test_trace_printk(void)
 {
-	int err, iter =3D 0, duration =3D 0, found =3D 0;
+	int err =3D 0, iter =3D 0, found =3D 0;
 	struct trace_printk__bss *bss;
 	struct trace_printk *skel;
 	char *buf =3D NULL;
@@ -18,25 +18,24 @@ void test_trace_printk(void)
 	size_t buflen;
=20
 	skel =3D trace_printk__open();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!ASSERT_OK_PTR(skel, "trace_printk__open"))
 		return;
=20
-	ASSERT_EQ(skel->rodata->fmt[0], 'T', "invalid printk fmt string");
+	ASSERT_EQ(skel->rodata->fmt[0], 'T', "skel->rodata->fmt[0]");
 	skel->rodata->fmt[0] =3D 't';
=20
 	err =3D trace_printk__load(skel);
-	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+	if (!ASSERT_OK(err, "trace_printk__load"))
 		goto cleanup;
=20
 	bss =3D skel->bss;
=20
 	err =3D trace_printk__attach(skel);
-	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "trace_printk__attach"))
 		goto cleanup;
=20
 	fp =3D fopen(TRACEBUF, "r");
-	if (CHECK(fp =3D=3D NULL, "could not open trace buffer",
-		  "error %d opening %s", errno, TRACEBUF))
+	if (!ASSERT_OK_PTR(fp, "fopen(TRACEBUF)"))
 		goto cleanup;
=20
 	/* We do not want to wait forever if this test fails... */
@@ -46,14 +45,10 @@ void test_trace_printk(void)
 	usleep(1);
 	trace_printk__detach(skel);
=20
-	if (CHECK(bss->trace_printk_ran =3D=3D 0,
-		  "bpf_trace_printk never ran",
-		  "ran =3D=3D %d", bss->trace_printk_ran))
+	if (!ASSERT_GT(bss->trace_printk_ran, 0, "bss->trace_printk_ran"))
 		goto cleanup;
=20
-	if (CHECK(bss->trace_printk_ret <=3D 0,
-		  "bpf_trace_printk returned <=3D 0 value",
-		  "got %d", bss->trace_printk_ret))
+	if (!ASSERT_GT(bss->trace_printk_ret, 0, "bss->trace_printk_ret"))
 		goto cleanup;
=20
 	/* verify our search string is in the trace buffer */
@@ -66,8 +61,7 @@ void test_trace_printk(void)
 			break;
 	}
=20
-	if (CHECK(!found, "message from bpf_trace_printk not found",
-		  "no instance of %s in %s", SEARCHMSG, TRACEBUF))
+	if (!ASSERT_EQ(found, bss->trace_printk_ran, "found"))
 		goto cleanup;
=20
 cleanup:
--=20
2.30.2

