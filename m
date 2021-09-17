Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB44640FF61
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbhIQSau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:30:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240432AbhIQSar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:30:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HGQGPj011145
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6gX/wkjz4vtaeulVpgKWOud0DL1t2r0JwoO1QsuOzQY=;
 b=BllLKo6LdL5pf7vWgvLuz2YmD6V4atMK3+/kizbxVid/XrmuY16otIg+2U/psYjxtJ+A
 RhNXwFL8ZSfqqWos6IheSxcWJnWmbNdHTKryziJc96ZsBkSaFC77khOmkw6srDCaDctL
 Nu2LzleZZmRI5GEv5t6hHENLa1Qvqsa9sNU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b4xhe0v71-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:25 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 11:29:24 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 1D0A96BF3223; Fri, 17 Sep 2021 11:29:20 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v6 bpf-next 7/9] selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
Date:   Fri, 17 Sep 2021 11:29:09 -0700
Message-ID: <20210917182911.2426606-8-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917182911.2426606-1-davemarchevsky@fb.com>
References: <20210917182911.2426606-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: MLjOrSKrnjSNZu12JneWg-Y1c1ifIaYY
X-Proofpoint-ORIG-GUID: MLjOrSKrnjSNZu12JneWg-Y1c1ifIaYY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxlogscore=818 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guidance for new tests is to use ASSERT macros instead of CHECK. Since
trace_vprintk test will borrow heavily from trace_printk's, migrate its
CHECKs so it remains obvious that the two are closely related.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

