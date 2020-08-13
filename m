Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341AC2434BE
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHMHR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:17:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgHMHRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 03:17:52 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07D7BOcV005909
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xlKJFWlB+04ldRTWzzBPgR810/7GPQGv3npTM4pfkcs=;
 b=g7LqQhEZSDH9Gh6wKGDxjUSIZiXYKpF70TY5hPgk7GbMv+b0sA94TS9q9fblqLXi4ghO
 6WU5vD1dlaUZfKSiZ9GuaFlCv5trwZD9VZPMFwM3qwVUhgB5B4LsS8hTDFieoJWhksPE
 kP5BYQ7hLN2Hab0oFXS/MLWNqVqlz6aHK/w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kgrf66-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:17:51 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 00:17:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4D5982EC5928; Thu, 13 Aug 2020 00:17:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 9/9] selftests/bpf: make test_varlen work with 32-bit user-space arch
Date:   Thu, 13 Aug 2020 00:17:22 -0700
Message-ID: <20200813071722.2213397-10-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200813071722.2213397-1-andriin@fb.com>
References: <20200813071722.2213397-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_04:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=636 priorityscore=1501 mlxscore=0 suspectscore=8 clxscore=1015
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Despite bpftool generating data section memory layout that will work for
32-bit architectures on user-space side, BPF programs should be careful t=
o not
use ambiguous types like `long`, which have different size in 32-bit and
64-bit environments. Fix that in test by using __u64 explicitly, which is
a recommended approach anyway.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/varlen.c | 8 ++++----
 tools/testing/selftests/bpf/progs/test_varlen.c | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/varlen.c b/tools/test=
ing/selftests/bpf/prog_tests/varlen.c
index c75525eab02c..dd324b4933db 100644
--- a/tools/testing/selftests/bpf/prog_tests/varlen.c
+++ b/tools/testing/selftests/bpf/prog_tests/varlen.c
@@ -44,25 +44,25 @@ void test_varlen(void)
 	CHECK_VAL(bss->payload1_len2, size2);
 	CHECK_VAL(bss->total1, size1 + size2);
 	CHECK(memcmp(bss->payload1, exp_str, size1 + size2), "content_check",
-	      "doesn't match!");
+	      "doesn't match!\n");
=20
 	CHECK_VAL(data->payload2_len1, size1);
 	CHECK_VAL(data->payload2_len2, size2);
 	CHECK_VAL(data->total2, size1 + size2);
 	CHECK(memcmp(data->payload2, exp_str, size1 + size2), "content_check",
-	      "doesn't match!");
+	      "doesn't match!\n");
=20
 	CHECK_VAL(data->payload3_len1, size1);
 	CHECK_VAL(data->payload3_len2, size2);
 	CHECK_VAL(data->total3, size1 + size2);
 	CHECK(memcmp(data->payload3, exp_str, size1 + size2), "content_check",
-	      "doesn't match!");
+	      "doesn't match!\n");
=20
 	CHECK_VAL(data->payload4_len1, size1);
 	CHECK_VAL(data->payload4_len2, size2);
 	CHECK_VAL(data->total4, size1 + size2);
 	CHECK(memcmp(data->payload4, exp_str, size1 + size2), "content_check",
-	      "doesn't match!");
+	      "doesn't match!\n");
 cleanup:
 	test_varlen__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/test=
ing/selftests/bpf/progs/test_varlen.c
index cd4b72c55dfe..913acdffd90f 100644
--- a/tools/testing/selftests/bpf/progs/test_varlen.c
+++ b/tools/testing/selftests/bpf/progs/test_varlen.c
@@ -15,9 +15,9 @@ int test_pid =3D 0;
 bool capture =3D false;
=20
 /* .bss */
-long payload1_len1 =3D 0;
-long payload1_len2 =3D 0;
-long total1 =3D 0;
+__u64 payload1_len1 =3D 0;
+__u64 payload1_len2 =3D 0;
+__u64 total1 =3D 0;
 char payload1[MAX_LEN + MAX_LEN] =3D {};
=20
 /* .data */
--=20
2.24.1

