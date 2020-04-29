Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4A1BD1AD
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgD2BVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34952 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbgD2BVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:51 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1Lpfb022128
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=s1S0Ac9l2PA+bzzDp+yHLz1ibq1Xbf4IeFbnQQHjsZY=;
 b=GR0yj0fUQEWVvvJAqDlDaDv+B4RHjlfrc2TrsazVwIRFM7MCjgZBxxfjRbUM0gC6xcv8
 G7UMGBfpC48sEDXUaTSDlz60cvUSUq9EFfhZCUzxqqsqTFYZRq/tSDh0Zp6CyY6kO8ek
 LmboMnJWp8AbpK8A2JFxIVhnZ2IQDQE73i0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxb87w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:50 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A83762EC30E4; Tue, 28 Apr 2020 18:21:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 09/11] selftests/bpf: disable ASAN instrumentation for mmap()'ed memory read
Date:   Tue, 28 Apr 2020 18:21:09 -0700
Message-ID: <20200429012111.277390-10-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=498 suspectscore=25 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AddressSanitizer assumes that all memory dereferences are done against me=
mory
allocated by sanitizer's malloc()/free() code and not touched by anyone e=
lse.
Seems like this doesn't hold for perf buffer memory. Disable instrumentat=
ion
on perf buffer callback function.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools=
/testing/selftests/bpf/prog_tests/perf_buffer.c
index 1450ea2dd4cc..a122ce3b360e 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -6,6 +6,11 @@
 #include <test_progs.h>
 #include "bpf/libbpf_internal.h"
=20
+/* AddressSanitizer sometimes crashes due to data dereference below, due=
 to
+ * this being mmap()'ed memory. Disable instrumentation with
+ * no_sanitize_address attribute
+ */
+__attribute__((no_sanitize_address))
 static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 {
 	int cpu_data =3D *(int *)data, duration =3D 0;
--=20
2.24.1

